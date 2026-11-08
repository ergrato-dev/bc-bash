#!/usr/bin/env bash
# first-free.sh — busca el primer nombre libre de base.1 a base.9.
# Para qué: guardar una copia nueva sin pisar las anteriores.
set -euo pipefail

base="${1:?uso: first-free.sh <base>}"

free=""
for ((i = 1; i <= 9; i++)); do
  if [[ -e $base.$i ]]; then
    continue
  fi
  free="$base.$i"
  # Sin break, el bucle seguiría y free acabaría siendo el último libre, no el primero.
  break
done

# Si el bucle termina sin break, free sigue vacía: no queda ningún nombre libre.
if [[ -z $free ]]; then
  echo "first-free.sh: de $base.1 a $base.9 están todos ocupados" >&2
  exit 1
fi
echo "$free"
