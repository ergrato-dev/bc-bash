#!/usr/bin/env bash
# sizes.sh — enseña el tamaño en bytes de cada archivo de una carpeta y la suma de todos.
set -euo pipefail

dir="${1:?uso: sizes.sh <carpeta>}"

total=0
# TODO 1: recorre "$dir"/* con un glob en lugar de $(ls) (paso 5)
for f in $(ls "$dir"); do
  # TODO 2: salta lo que no sea un archivo normal (paso 6)
  size=$(wc -c < "$dir/$f")
  echo "$size $f"
  total=$((total + size))
done
echo "total: $total bytes"
