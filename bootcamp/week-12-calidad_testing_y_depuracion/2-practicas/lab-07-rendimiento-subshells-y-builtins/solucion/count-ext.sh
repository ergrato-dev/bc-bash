#!/usr/bin/env bash
# count-ext.sh — cuántos archivos hay de cada extensión en una carpeta: "txt 3", "log 12"...
# Para qué: ver de un vistazo qué se acumula en una carpeta de logs o de descargas.
set -euo pipefail

dir="${1:?uso: count-ext.sh <carpeta>}"

declare -A count=()
for path in "$dir"/*; do
  # Expansiones y no $(basename) ni $(echo | sed): cada $( ) con un comando de fuera
  # lanza un proceso, y con miles de archivos el script pasa el tiempo creando procesos.
  name="${path##*/}"
  ext="${name##*.}"
  count[$ext]=$((${count[$ext]:-0} + 1))
done

for ext in "${!count[@]}"; do
  printf '%s %d\n' "$ext" "${count[$ext]}"
done | sort
