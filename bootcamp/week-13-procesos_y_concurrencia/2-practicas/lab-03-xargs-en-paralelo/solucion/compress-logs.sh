#!/usr/bin/env bash
# compress-logs.sh — comprime con gzip los .log de una carpeta (y sus subcarpetas), varios a la vez.
# Para qué: gzip usa un solo núcleo; con varios gzip a la vez se aprovechan todos.
set -euo pipefail

dir="${1:?uso: compress-logs.sh <carpeta> [trabajos]}"
# nproc: cuántos núcleos tiene la máquina. Más gzip que núcleos no va más rápido.
max_jobs="${2:-$(nproc)}"

# -print0 y -0 separan los nombres con el carácter nulo: uno con espacios llega entero.
# -P: cuántos gzip a la vez. -n 1: un archivo por gzip, para que haya trabajo que repartir.
# --: un nombre que empiece por - no se toma como una opción de gzip.
# xargs sigue con el resto si un gzip falla, y al final sale con 123: el if lo recoge.
if ! find "$dir" -type f -name '*.log' -print0 | xargs -0 -P "$max_jobs" -n 1 gzip -9 -k --; then
  echo "compress-logs.sh: algún log de $dir no se pudo comprimir" >&2
  exit 1
fi
echo "comprimidos los logs de $dir"
