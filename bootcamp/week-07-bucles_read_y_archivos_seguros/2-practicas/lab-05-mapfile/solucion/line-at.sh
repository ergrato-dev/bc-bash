#!/usr/bin/env bash
# line-at.sh — imprime la línea número N de un archivo.
# Para qué: elegir un servidor de una lista por su posición, o enseñar cuántos hay.
set -euo pipefail

file="${1:?uso: line-at.sh <archivo> <número>}"
n="${2:?uso: line-at.sh <archivo> <número>}"

# -t quita el salto de línea del final de cada elemento; sin él, cada línea lo arrastra.
mapfile -t lines < "$file"

if [[ ! $n =~ ^[1-9][0-9]*$ || $n -gt ${#lines[@]} ]]; then
  echo "line-at.sh: '$n' no está entre 1 y ${#lines[@]}" >&2
  exit 1
fi
# Las personas cuentan desde 1 y el array desde 0: la línea 1 es lines[0].
echo "${lines[n - 1]}"
