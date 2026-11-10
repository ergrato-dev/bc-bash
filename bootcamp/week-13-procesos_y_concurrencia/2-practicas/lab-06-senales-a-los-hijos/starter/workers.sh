#!/usr/bin/env bash
# workers.sh <número> [carpeta] — lanza varios workers que trabajan en segundo plano hasta
# que paras el script. Cada worker apunta cada vuelta en su log, como un consumidor de una cola.
set -euo pipefail

count="${1:?uso: workers.sh <número> [carpeta]}"
out="${2:-out}"
mkdir -p "$out"

# worker <id>: trabaja en un bucle sin fin; cada vuelta, una línea en su log.
worker() {
  local id="$1" n=0
  # TODO 2: al recibir TERM o INT, que apunte en su log en qué vuelta paró y salga con 0.
  while true; do
    n=$((n + 1))
    echo "worker $id: vuelta $n" >> "$out/worker-$id.log"
    sleep 0.5
  done
}

# TODO 1: con INT o TERM, para a los workers, espera a que terminen y sal con 130 o 143.

for ((i = 1; i <= count; i++)); do
  worker "$i" &
done
echo "workers.sh: $count workers en marcha (pid $$)" >&2
wait
