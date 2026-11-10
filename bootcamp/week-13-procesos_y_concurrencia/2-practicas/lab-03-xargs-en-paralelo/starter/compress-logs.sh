#!/usr/bin/env bash
# compress-logs.sh — comprime con gzip los .log de una carpeta (y sus subcarpetas), varios a la vez.
# Para qué: gzip usa un solo núcleo; con varios gzip a la vez se aprovechan todos.
set -euo pipefail

dir="${1:?uso: compress-logs.sh <carpeta> [trabajos]}"
# nproc: cuántos núcleos tiene la máquina. Más gzip que núcleos no va más rápido.
max_jobs="${2:-$(nproc)}"

# TODO 1: con find -print0 y xargs -0 -P "$max_jobs" -n 1, comprime cada .log con gzip -9 -k.
# TODO 2: si algún gzip falla, avisa en stderr y sal con 1.
for file in $(ls "$dir"/*.log); do
  gzip -9 -k "$file"
done
echo "comprimidos los logs de $dir"
