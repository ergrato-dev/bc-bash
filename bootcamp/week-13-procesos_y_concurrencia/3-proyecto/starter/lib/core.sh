# shellcheck shell=bash
# core.sh — funciones que comparten todos los comandos de bashkit: avisar, parar y comprobar.
# Para qué: que cada comando avise igual y no repita las mismas tres líneas.
# Se carga con source, no se ejecuta: por eso no lleva shebang ni bit de ejecución.
# Tampoco pone set -euo pipefail: eso lo decide el script que la carga.

# log <mensaje>: escribe "comando: mensaje" en stderr.
# ${0##*/} es el nombre del script que cargó la librería, sin la ruta: el aviso dice
# de qué comando viene. stderr, para no mezclarse con la salida que alguien captura.
log() {
  printf '%s: %s\n' "${0##*/}" "$*" >&2
}

# die <mensaje> [código]: avisa y termina el script con el código (1 si no dices otro).
# exit y no return: desde una función, exit para el script entero.
die() {
  log "$1"
  exit "${2:-1}"
}

# require <comando>...: para el script si falta alguno de los comandos.
# Mejor fallar al principio con un aviso claro que a mitad de trabajo con "command not found".
require() {
  local cmd
  for cmd in "$@"; do
    command -v "$cmd" > /dev/null || die "falta el comando '$cmd'"
  done
}

# Niveles de aviso: debug < info < warn < error. BK_LOG_LEVEL dice desde cuál se escriben
# (info si no dices otro): con BK_LOG_LEVEL=debug ves los detalles, con error solo los fallos.
# level_number <nivel>: el número del nivel, o código 1 si no es ninguno de los cuatro.
level_number() {
  case "$1" in
    debug) echo 0 ;;
    info) echo 1 ;;
    warn) echo 2 ;;
    error) echo 3 ;;
    *) return 1 ;;
  esac
}

# log_at <nivel> <mensaje>: escribe "comando: nivel: mensaje" si el nivel llega al de BK_LOG_LEVEL.
# Un BK_LOG_LEVEL mal escrito para el script: si lo callara, no verías ni los avisos que pediste.
log_at() {
  local level="$1" min
  shift
  min="$(level_number "${BK_LOG_LEVEL:-info}")" ||
    die "BK_LOG_LEVEL='$BK_LOG_LEVEL' no es un nivel (debug, info, warn o error)" 2
  # return 0 y no un if sin else: un aviso que no se escribe no es un fallo, y con set -e
  # un código 1 aquí pararía el script que llamó a log_at.
  (($(level_number "$level") >= min)) || return 0
  log "$level: $*"
}

log_debug() { log_at debug "$@"; }
log_info() { log_at info "$@"; }
log_warn() { log_at warn "$@"; }

# BK_TRACE=<archivo>: escribe en ese archivo cada línea que ejecuta el comando (set -x).
# PS4 es lo que va delante de cada línea de la traza: el archivo y el número de línea
# dicen dónde mirar. BASH_XTRACEFD manda la traza a un descriptor propio: sin él iría a
# stderr y se mezclaría con los avisos del comando y con lo que capture quien lo llama.
if [[ -n ${BK_TRACE:-} ]]; then
  exec {BASH_XTRACEFD}>> "$BK_TRACE"
  PS4='+ ${BASH_SOURCE[0]##*/}:${LINENO}: '
  set -x
fi
