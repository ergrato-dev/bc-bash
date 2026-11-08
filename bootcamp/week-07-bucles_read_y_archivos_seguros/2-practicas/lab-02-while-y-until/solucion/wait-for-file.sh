#!/usr/bin/env bash
# wait-for-file.sh — espera a que aparezca un archivo, comprobando una vez por segundo.
# Para qué: un script que necesita lo que crea otro (un volcado, un archivo "listo")
# espera a que exista en lugar de fallar porque llegó antes.
set -euo pipefail

file="${1:?uso: wait-for-file.sh <archivo> <segundos>}"
max="${2:?uso: wait-for-file.sh <archivo> <segundos>}"

waited=0
until [[ -e $file ]]; do
  # Sin un límite, si el archivo no llega nunca, el script se queda esperando para siempre.
  if [[ $waited -ge $max ]]; then
    echo "wait-for-file.sh: '$file' no apareció en $max s" >&2
    exit 1
  fi
  sleep 1
  waited=$((waited + 1))
done

echo "listo: $file (tras $waited s)"
