#!/usr/bin/env bash
# wait-for-file.sh — espera a que aparezca un archivo, mirando cada segundo, durante N segundos como mucho.
# Para qué: que un script de deploy espere a la señal "listo" de otro proceso, sin quedarse colgado para siempre.
# Mientras espera, deja su PID en wait-for-file.pid: así se sabe quién espera y se le puede parar.
set -euo pipefail

target="${1:?uso: wait-for-file.sh <archivo> [segundos]}"
limit="${2:-10}"
pid_file=wait-for-file.pid

echo "$$" > "$pid_file"
# TODO 1: un trap EXIT que borre el archivo del PID.
# TODO 2: un trap INT que avise "cancelado" en stderr y salga con 130.
# TODO 3: un trap TERM que avise "parado" en stderr y salga con 143.

for ((i = 1; i <= limit; i++)); do
  if [[ -e $target ]]; then
    echo "listo: $target"
    exit 0
  fi
  sleep 1
done

echo "wait-for-file.sh: $target no apareció en $limit s" >&2
exit 1
