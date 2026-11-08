#!/usr/bin/env bash
# line-at.sh — imprime la línea número N de un archivo.
# Para qué: elegir un servidor de una lista por su posición, o enseñar cuántos hay.
set -euo pipefail

file="${1:?uso: line-at.sh <archivo> <número>}"
n="${2:?uso: line-at.sh <archivo> <número>}"

# TODO 1: carga "$file" en el array lines con mapfile -t e imprime la línea n (paso 6)
# TODO 2: si n no es un número de 1 al total de líneas, avisa y sale con 1 (paso 7)
echo "sin implementar: $file $n"
