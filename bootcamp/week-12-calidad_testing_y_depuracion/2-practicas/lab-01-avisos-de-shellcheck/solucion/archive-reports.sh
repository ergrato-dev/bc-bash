#!/usr/bin/env bash
# archive-reports.sh — copia los informes .txt de una carpeta a otra y apunta cada copia.
# Para qué: guardar los informes del mes sin perder ninguno, con nombres con espacios incluidos.
set -euo pipefail

if [[ $# -ne 2 ]]; then
  # $HOME va entre comillas simples a propósito: es un ejemplo para quien lo lee, no una ruta.
  # shellcheck disable=SC2016
  echo 'uso: archive-reports.sh <carpeta> <destino>   (ejemplo: archive-reports.sh "$HOME/informes" archivo)' >&2
  exit 2
fi
src="$1"
dest="$2"

# local en su propia línea: "local x=$(...)" devuelve el código de local (0) y no el del
# comando, y set -e no pararía si date fallara (SC2155).
log_copy() {
  local stamp
  stamp="$(date +%T)"
  echo "$stamp $1" >> "$dest/copias.log"
}

mkdir -p "$dest"
count=0
# Un glob y no $(ls): cada nombre llega entero, con sus espacios (SC2045).
for f in "$src"/*.txt; do
  # Sin ningún .txt, el glob se queda tal cual ("carpeta/*.txt"): -e lo descarta.
  [[ -e $f ]] || continue
  cp -- "$f" "$dest/"
  log_copy "${f##*/}"
  count=$((count + 1))
done
echo "copiados: $count"
