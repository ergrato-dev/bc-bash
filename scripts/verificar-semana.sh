#!/usr/bin/env bash
#
# verificar-semana.sh — autograding declarativo del bootcamp.
#
# Uso:
#   ./scripts/verificar-semana.sh 03        comprueba la Semana 03
#   ./scripts/verificar-semana.sh --doctor  comprueba tu entorno
#   ENTREGA=solucion ./scripts/verificar-semana.sh 03
#                                           comprueba la solución de referencia
#   ./scripts/verificar-semana.sh --host 03 usa el bash de tu equipo
#
# Por defecto los checks corren dentro del laboratorio Docker (compose.yaml,
# bash 5.2), así todos obtienen el mismo resultado.
#
# Este script no sabe nada de ninguna semana en concreto: lee las
# comprobaciones de bootcamp/week-NN-*/checks.json y las ejecuta. Si necesitas
# lógica específica de una semana, el sitio es el checks.json, nunca este
# archivo. El contrato completo está en docs/autograding.md.

set -euo pipefail

RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$RAIZ"

rojo()  { printf '\033[0;31m%s\033[0m\n' "$*"; }
verde() { printf '\033[0;32m%s\033[0m\n' "$*"; }
gris()  { printf '\033[0;90m%s\033[0m\n' "$*"; }

# ---------------------------------------------------------------------------
# --doctor: comprueba las dependencias antes de culpar al material
# ---------------------------------------------------------------------------
doctor() {
  local fallos=0

  comprobar() {
    local etiqueta="$1" resultado="$2" detalle="${3:-}"
    if [[ "$resultado" == ok ]]; then
      printf '  \033[0;32m✅\033[0m %-14s %s\n' "$etiqueta" "$detalle"
    else
      printf '  \033[0;31m❌\033[0m %-14s %s\n' "$etiqueta" "$detalle"
      fallos=$(( fallos + 1 ))
    fi
  }

  herramienta() {  # herramienta NOMBRE "comando de versión" "para qué"
    local version
    if command -v "$1" >/dev/null 2>&1 && version=$(bash -c "$2" 2>&1); then
      comprobar "$1" ok "$version"
    else
      comprobar "$1" no "no instalado — $3"
    fi
  }

  # Fuera del laboratorio solo hace falta Docker: ahí corre todo lo demás.
  if [[ -z "${BC_BASH_LAB:-}" ]]; then
    if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
      comprobar "docker" ok "$(docker compose version 2>/dev/null | head -1)"
    else
      comprobar "docker" no "no disponible — el laboratorio corre en Docker (docs/setup-entorno.md)"
    fi
  else
    if (( BASH_VERSINFO[0] > 5 || (BASH_VERSINFO[0] == 5 && BASH_VERSINFO[1] >= 2) )); then
      comprobar "bash" ok "$BASH_VERSION"
    else
      comprobar "bash" no "$BASH_VERSION — se necesita bash >= 5.2"
    fi
    herramienta jq "jq --version" "obligatorio para leer checks.json"
    herramienta git "git --version" "bashkit se versiona con git"
    herramienta shellcheck "shellcheck --version | awk '/^version:/{print \$2}'" "semana 12"
    herramienta shfmt "shfmt --version" "semana 12"
    herramienta bats "bats --version" "semana 12"
    herramienta psql "psql --version" "semana 14"
  fi

  echo
  if (( fallos == 0 )); then
    verde "Todo listo."
    return 0
  fi
  rojo "$fallos comprobación(es) del entorno fallaron."
  return 1
}

# ---------------------------------------------------------------------------
# Evaluación de una aserción
#   exit0        el comando sale con 0
#   exit!=0      el comando sale distinto de 0
#   exit=N       el comando sale exactamente con N
#   stdout~RE    la salida (stdout + stderr) casa con la regex extendida RE
#   stdout!~RE   la salida NO casa con RE
# ---------------------------------------------------------------------------
evaluar() {
  local asercion="$1" codigo="$2" salida="$3"

  case "$asercion" in
    exit0)       [[ "$codigo" -eq 0 ]] ;;
    "exit!=0")   [[ "$codigo" -ne 0 ]] ;;
    exit=*)      [[ "$codigo" -eq "${asercion#exit=}" ]] ;;
    "stdout!~"*) ! grep -qE -- "${asercion#stdout!~}" <<<"$salida" ;;
    stdout~*)    grep -qE -- "${asercion#stdout~}" <<<"$salida" ;;
    *)
      rojo "ASERCIÓN DESCONOCIDA: '$asercion'"
      gris "Válidas: exit0, exit!=0, exit=N, stdout~RE, stdout!~RE"
      return 2
      ;;
  esac
}

# ---------------------------------------------------------------------------
# Ejecución de una semana
# ---------------------------------------------------------------------------
verificar_semana() {
  local semana="$1"

  if ! [[ "$semana" =~ ^[0-9]{2}$ ]]; then
    rojo "La semana se indica con dos dígitos: 01, 02 ... 14"
    exit 1
  fi

  if ! command -v jq >/dev/null 2>&1; then
    rojo "Falta jq. Es obligatorio para leer checks.json."
    exit 1
  fi

  local dir
  dir=$(find "$RAIZ/bootcamp" -maxdepth 1 -type d -name "week-${semana}-*" | head -1)
  if [[ -z "$dir" ]]; then
    rojo "No existe la carpeta de la Semana $semana."
    exit 1
  fi

  local archivo="$dir/checks.json"
  if [[ ! -f "$archivo" ]]; then
    rojo "La Semana $semana todavía no tiene checks.json."
    gris "Se escribe antes que el contenido: ver docs/autograding.md"
    exit 1
  fi

  if ! jq -e . "$archivo" >/dev/null 2>&1; then
    rojo "checks.json inválido: $archivo"
    exit 1
  fi

  echo "Semana $semana — $(jq -r '.titulo' "$archivo")"
  echo

  local total=0 pasados=0 tmp
  local _id descripcion cmd asercion pista codigo salida

  while IFS=$'\t' read -r _id descripcion cmd asercion pista; do
    total=$(( total + 1 ))

    # Cada check corre en un directorio vacío propio que también hace de HOME:
    # nada se arrastra de un check a otro ni toca el $HOME del estudiante.
    tmp=$(mktemp -d)

    # Los marcadores dejan el checks.json independiente de rutas y plataforma.
    cmd=${cmd//\{semana\}/$dir}
    cmd=${cmd//\{raiz\}/$RAIZ}
    cmd=${cmd//\{tmp\}/$tmp}
    # El estudiante trabaja en starter/; el instructor valida solucion/.
    cmd=${cmd//\{proyecto\}/$dir/3-proyecto/${ENTREGA:-starter}}

    # `if` alrededor: con `set -e`, capturar el código de un comando que falla
    # a propósito requiere que la ejecución esté en un contexto condicional.
    # timeout: un script con un bucle infinito no cuelga el autograding.
    if salida=$(cd "$tmp" && HOME="$tmp" timeout 20 bash -c "$cmd" 2>&1 </dev/null); then codigo=0; else codigo=$?; fi
    rm -rf -- "$tmp"

    if evaluar "$asercion" "$codigo" "$salida"; then
      printf '  \033[0;32m✅\033[0m %s\n' "$descripcion"
      pasados=$(( pasados + 1 ))
    else
      printf '  \033[0;31m❌\033[0m %s\n' "$descripcion"
      printf '     \033[0;90mpista: %s\033[0m\n' "$pista"
    fi
  done < <(jq -r '.checks[] | [.id, .descripcion, .cmd, .assert, .pista] | join("\t")' "$archivo")

  echo
  if (( pasados == total )); then
    verde "$pasados/$total comprobaciones superadas."
    return 0
  fi
  rojo "$pasados/$total comprobaciones superadas."
  gris "Cada pista dice en qué lab y en qué paso se arregla."
  return 1
}

# ---------------------------------------------------------------------------
# Fuera del laboratorio y sin --host, la semana se verifica dentro del
# contenedor. El --doctor siempre mira la máquina donde se ejecuta.
EN_HOST=""
if [[ "${1:-}" == "--host" ]]; then EN_HOST=1; shift; fi

if [[ -z "$EN_HOST" && -z "${BC_BASH_LAB:-}" && "${1:-}" =~ ^[0-9]{2}$ ]]; then
  exec docker compose run --rm -T -e ENTREGA="${ENTREGA:-starter}" lab \
    ./scripts/verificar-semana.sh "$1"
fi

case "${1:-}" in
  --doctor)      doctor ;;
  -h|--help|"")  sed -n '3,18p' "${BASH_SOURCE[0]}" | sed 's|^# \?||' ;;
  *)             verificar_semana "$1" ;;
esac
