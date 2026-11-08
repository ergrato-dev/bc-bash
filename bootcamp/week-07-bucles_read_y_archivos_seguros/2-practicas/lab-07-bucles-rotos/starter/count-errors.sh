#!/usr/bin/env bash
# count-errors.sh — cuenta las líneas con ERROR de cada .log de una carpeta y el total.
# Viene roto a propósito: cuatro fallos en los bucles, cada uno marcado con un TODO.
set -euo pipefail

dir="${1:?uso: count-errors.sh <carpeta>}"

total=0
# TODO 1
for f in $(ls $dir/*.log); do
  errors=0
  # TODO 2 y TODO 4
  cat "$f" | while read line; do
    if [[ $line == *ERROR* ]]; then
      # TODO 3
      ((errors++))
    fi
  done
  echo "$errors $f"
  total=$((total + errors))
done
echo "total: $total errores"
