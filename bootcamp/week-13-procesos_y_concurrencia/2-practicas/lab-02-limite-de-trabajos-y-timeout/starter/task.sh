#!/usr/bin/env bash
# task.sh <nombre> <segundos>: simula una llamada a un servicio que tarda unos segundos.
# La tarea "terca" ignora TERM, como un programa que no sabe parar a medias.
set -euo pipefail

# trap '' ignora la señal, y un proceso hereda las señales ignoradas: sleep también la ignora.
if [[ $1 == terca ]]; then
  trap '' TERM
fi
sleep "$2"
echo "$1: hecha en $2 s"
