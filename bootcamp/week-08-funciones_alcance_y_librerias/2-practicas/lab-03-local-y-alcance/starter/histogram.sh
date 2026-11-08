#!/usr/bin/env bash
# histogram.sh — dibuja una barra de # por cada línea "nombre número" de un archivo.
# Para qué: ver de un vistazo qué día vendió más, sin abrir una hoja de cálculo.
set -euo pipefail

# draw_bar <n>: una barra de n almohadillas.
draw_bar() {
  # TODO 1: la variable del for, local.
  for ((i = 0; i < $1; i++)); do
    echo -n "#"
  done
  echo
}

# draw_row <"nombre número">: el nombre y su barra.
draw_row() {
  # TODO 2: day y count, locales.
  day=${1%% *}
  count=${1##* }
  echo -n "$day "
  draw_bar "$count"
}

mapfile -t lines < "${1:?uso: histogram.sh <archivo>}"
count=${#lines[@]}
for ((i = 0; i < ${#lines[@]}; i++)); do
  draw_row "${lines[i]}"
done
echo "$count días"
