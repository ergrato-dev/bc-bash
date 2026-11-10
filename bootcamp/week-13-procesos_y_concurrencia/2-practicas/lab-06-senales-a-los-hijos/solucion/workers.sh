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
  # Con TERM (el kill de stop) o INT (Ctrl-C llega a todo el grupo), apunta en su log en qué
  # vuelta paró y sale. Comillas simples: $id y $n se leen al llegar la señal.
  trap 'echo "worker $id: parado en la vuelta $n" >> "$out/worker-$id.log"; exit 0' TERM INT
  while true; do
    n=$((n + 1))
    echo "worker $id: vuelta $n" >> "$out/worker-$id.log"
    sleep 0.5
  done
}

# stop: manda TERM a los workers que sigan vivos y espera a que terminen.
# Sin esto, un Ctrl-C o un kill al script los deja vivos: la señal llega al script y no a
# sus hijos, y un programa que el script lanza con & ignora el INT de Ctrl-C.
stop() {
  local pids
  pids="$(jobs -p)"
  if [[ -n $pids ]]; then
    # Sin comillas a propósito: un pid por palabra.
    # shellcheck disable=SC2086
    kill $pids 2> /dev/null || true
  fi
  wait || true
  echo "workers.sh: workers parados" >&2
}
# exit con 128 + el número de la señal: quien lanzó el script sabe por qué terminó.
trap 'stop; exit 130' INT
trap 'stop; exit 143' TERM

for ((i = 1; i <= count; i++)); do
  worker "$i" &
done
echo "workers.sh: $count workers en marcha (pid $$)" >&2
wait
