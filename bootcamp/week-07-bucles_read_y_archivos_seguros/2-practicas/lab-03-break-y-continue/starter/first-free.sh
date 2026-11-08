#!/usr/bin/env bash
# first-free.sh — busca el primer nombre libre de base.1 a base.9.
# Para qué: guardar una copia nueva sin pisar las anteriores.
set -euo pipefail

base="${1:?uso: first-free.sh <base>}"

free=""
for ((i = 1; i <= 9; i++)); do
  # TODO 1: si "$base.$i" existe, pasa al siguiente número con continue (paso 4)
  free="$base.$i"
  # TODO 2: sal del bucle con break: ya tienes el primero libre (paso 5)
done

# TODO 3: si free sigue vacía, los nueve están ocupados: avisa y sale con 1 (paso 6)
echo "$free"
