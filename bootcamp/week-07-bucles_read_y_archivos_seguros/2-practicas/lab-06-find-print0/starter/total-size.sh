#!/usr/bin/env bash
# total-size.sh — suma los bytes de todos los archivos con una extensión, también en subcarpetas.
# Para qué: saber cuánto ocupan los .log o los .dump de una carpeta antes de limpiarla.
set -euo pipefail

dir="${1:?uso: total-size.sh <carpeta> <extensión>}"
ext="${2:?uso: total-size.sh <carpeta> <extensión>}"

total=0
count=0
# TODO 1: rutas separadas por el byte nulo: -print0 en find y read -r -d '' con IFS= (paso 6)
# TODO 2: el while sin pipe, con done < <(find ...), para no perder total ni count (paso 8)
find "$dir" -type f -name "*.$ext" | while read -r f; do
  size=$(wc -c < "$f")
  echo "$size $f"
  total=$((total + size))
  count=$((count + 1))
done
echo "total: $total bytes en $count archivos"
