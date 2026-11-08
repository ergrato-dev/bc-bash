#!/usr/bin/env bash
# count-errors.sh — cuenta las líneas con ERROR de cada .log de una carpeta y el total.
set -euo pipefail

dir="${1:?uso: count-errors.sh <carpeta>}"

total=0
# El glob da cada nombre entero; $(ls) partiría "app web.log" en dos.
for f in "$dir"/*.log; do
  errors=0
  # < "$f" y no cat | while: detrás de un pipe el while va en un subshell y
  # errors volvería a 0 al terminar. -r deja las \ tal cual.
  while IFS= read -r line; do
    if [[ $line == *ERROR* ]]; then
      # ((errors++)) sale con 1 cuando errors vale 0, y set -e pararía el script.
      errors=$((errors + 1))
    fi
  done < "$f"
  echo "$errors $f"
  total=$((total + errors))
done
echo "total: $total errores"
