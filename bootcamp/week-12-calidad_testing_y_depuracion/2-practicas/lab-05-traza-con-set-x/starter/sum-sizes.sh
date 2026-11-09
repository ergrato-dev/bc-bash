#!/usr/bin/env bash
# sum-sizes.sh — cuántos archivos hay en una carpeta (y en sus subcarpetas) y cuánto ocupan entre todos.
# Roto a propósito: siempre dice que la carpeta está vacía.
set -euo pipefail

# TODO 2: con TRACE=<archivo>, la traza (set -x) va a ese archivo y no a stderr (BASH_XTRACEFD),
# con el número de línea delante (PS4).

# to_kib <bytes>: los bytes en KiB (1024 bytes), redondeando hacia arriba.
to_kib() {
  echo $((($1 + 1023) / 1024))
}

dir="${1:?uso: sum-sizes.sh <carpeta>}"
[[ -d $dir ]] || { echo "sum-sizes.sh: '$dir' no es una carpeta" >&2; exit 1; }

total=0
count=0
find "$dir" -type f -print0 | while IFS= read -r -d '' file; do
  size="$(stat -c %s "$file")"
  total=$((total + size))
  count=$((count + 1))
done
echo "total: $total bytes ($(to_kib "$total") KiB) en $count archivos"
