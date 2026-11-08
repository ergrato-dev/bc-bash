#!/usr/bin/env bash
# total-size.sh — suma los bytes de todos los archivos con una extensión, también en subcarpetas.
# Para qué: saber cuánto ocupan los .log o los .dump de una carpeta antes de limpiarla.
set -euo pipefail

dir="${1:?uso: total-size.sh <carpeta> <extensión>}"
ext="${2:?uso: total-size.sh <carpeta> <extensión>}"

total=0
count=0
# -print0 y -d '': cada ruta termina en el byte nulo, que no puede ir en un nombre;
# con saltos de línea, un archivo con uno en el nombre contaría como dos.
# < <(...) y no un pipe: detrás de un pipe el while va en un subshell, y total
# y count volverían a 0 al terminar.
while IFS= read -r -d '' f; do
  size=$(wc -c < "$f")
  echo "$size $f"
  total=$((total + size))
  count=$((count + 1))
done < <(find "$dir" -type f -name "*.$ext" -print0)
echo "total: $total bytes en $count archivos"
