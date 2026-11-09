#!/usr/bin/env bash
# wait-for-file.sh — espera a que aparezca un archivo, mirando cada segundo, durante N segundos como mucho.
# Para qué: que un script de deploy espere a la señal "listo" de otro proceso, sin quedarse colgado para siempre.
# Mientras espera, deja su PID en wait-for-file.pid: así se sabe quién espera y se le puede parar.
set -euo pipefail

target="${1:?uso: wait-for-file.sh <archivo> [segundos]}"
limit="${2:-10}"
pid_file=wait-for-file.pid

echo "$$" > "$pid_file"
# EXIT limpia en todos los caminos: listo, sin tiempo, error, Ctrl-C o kill.
# Un PID viejo en el archivo haría creer que alguien sigue esperando.
trap 'rm -f -- "$pid_file"' EXIT
# Con trap, la señal ya no mata el script: corre el aviso, y el exit sale con el código
# de siempre para esa señal (128 + su número), el que espera quien lo lanzó.
trap 'echo "cancelado" >&2; exit 130' INT
trap 'echo "parado" >&2; exit 143' TERM

for ((i = 1; i <= limit; i++)); do
  if [[ -e $target ]]; then
    echo "listo: $target"
    exit 0
  fi
  sleep 1
done

echo "wait-for-file.sh: $target no apareció en $limit s" >&2
exit 1
