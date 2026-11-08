#!/usr/bin/env bash
# wait-for-file.sh — espera a que aparezca un archivo, comprobando una vez por segundo.
# Para qué: un script que necesita lo que crea otro (un volcado, un archivo "listo")
# espera a que exista en lugar de fallar porque llegó antes.
set -euo pipefail

file="${1:?uso: wait-for-file.sh <archivo> <segundos>}"
max="${2:?uso: wait-for-file.sh <archivo> <segundos>}"

waited=0
# TODO 1: un until que, mientras "$file" no exista, espere 1 segundo con sleep (paso 5)
# TODO 2: dentro del until, suma 1 a waited en cada vuelta (paso 6)
# TODO 3: dentro del until, si waited llega a max, avisa en stderr y sale con 1 (paso 7)

echo "listo: $file (tras $waited s)"
