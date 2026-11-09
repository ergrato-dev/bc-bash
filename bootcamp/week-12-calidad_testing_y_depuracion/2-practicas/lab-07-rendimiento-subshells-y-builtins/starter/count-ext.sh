#!/usr/bin/env bash
# count-ext.sh — cuántos archivos hay de cada extensión en una carpeta: "txt 3", "log 12"...
# Funciona, pero es lento: lanza tres procesos por cada archivo.
set -euo pipefail

dir="${1:?uso: count-ext.sh <carpeta>}"

declare -A count=()
for path in "$dir"/*; do
  # TODO 1: el nombre sin la carpeta, sin lanzar basename.
  name="$(basename "$path")"
  # TODO 2: la extensión, sin lanzar echo ni sed.
  ext="$(echo "$name" | sed 's/.*\.//')"
  count[$ext]=$((${count[$ext]:-0} + 1))
done

for ext in "${!count[@]}"; do
  printf '%s %d\n' "$ext" "${count[$ext]}"
done | sort
