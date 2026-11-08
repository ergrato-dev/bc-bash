#!/usr/bin/env bash
# sizes.sh — enseña el tamaño en bytes de cada archivo de una carpeta y la suma de todos.
set -euo pipefail

dir="${1:?uso: sizes.sh <carpeta>}"

total=0
# El glob da cada nombre entero, con espacios incluidos; $(ls) los partiría.
for f in "$dir"/*; do
  # -f deja fuera las carpetas y, en una carpeta vacía, el "*" que el glob deja tal cual.
  if [[ -f $f ]]; then
    size=$(wc -c < "$f")
    echo "$size $f"
    total=$((total + size))
  fi
done
echo "total: $total bytes"
