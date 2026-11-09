#!/usr/bin/env bash
# sum-sizes.sh — cuántos archivos hay en una carpeta (y en sus subcarpetas) y cuánto ocupan entre todos.
# Para qué: saber cuánto ocupan los logs o los informes antes de copiarlos o borrarlos.
set -euo pipefail

# TRACE=<archivo>: la traza de set -x va a ese archivo, con el número de línea delante.
# BASH_XTRACEFD la manda a un descriptor propio: sin él iría a stderr, mezclada con los avisos.
if [[ -n ${TRACE:-} ]]; then
  exec {BASH_XTRACEFD}> "$TRACE"
  PS4='+ ${LINENO}: '
  set -x
fi

# to_kib <bytes>: los bytes en KiB (1024 bytes), redondeando hacia arriba.
to_kib() {
  echo $((($1 + 1023) / 1024))
}

dir="${1:?uso: sum-sizes.sh <carpeta>}"
[[ -d $dir ]] || { echo "sum-sizes.sh: '$dir' no es una carpeta" >&2; exit 1; }

total=0
count=0
# < <(find ...) y no find | while: con el pipe, el while va en un subshell y
# total y count se pierden al salir del bucle. Así el while corre en esta shell.
while IFS= read -r -d '' file; do
  size="$(stat -c %s "$file")"
  total=$((total + size))
  count=$((count + 1))
done < <(find "$dir" -type f -print0)
echo "total: $total bytes ($(to_kib "$total") KiB) en $count archivos"
