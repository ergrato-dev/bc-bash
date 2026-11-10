#!/usr/bin/env bash
# fetch-mirrors.sh — descarga el mismo paquete de varios espejos y dice cuáles fallan.
# Cada línea de la lista dice el nombre del espejo, cuántos segundos tarda y con qué código
# acaba: la descarga se simula con sleep para que el lab no dependa de la red.
set -euo pipefail

list="${1:?uso: fetch-mirrors.sh <lista>}"

# download <nombre> <segundos> <código>: una descarga lenta que puede fallar.
download() {
  sleep "$2"
  if [[ $3 -ne 0 ]]; then
    echo "$1: falló con código $3" >&2
    return "$3"
  fi
  echo "$1: descargado"
}

# Con & cada descarga va en segundo plano y el bucle sigue sin esperar: tardan lo que la
# más lenta, no la suma. $! es el pid del último trabajo lanzado.
pids=()
while read -r name seconds code; do
  download "$name" "$seconds" "$code" &
  pids+=("$!")
done < "$list"

# wait sin argumentos sale siempre con 0: un fallo pasaría sin aviso. wait <pid> sale con
# el código de ese trabajo, aunque haya terminado antes. || evita que set -e pare aquí.
failed=0
for pid in "${pids[@]}"; do
  wait "$pid" || failed=$((failed + 1))
done
if ((failed > 0)); then
  echo "fetch-mirrors.sh: fallaron $failed de ${#pids[@]} descargas" >&2
  exit 1
fi
echo "todas las descargas terminadas"
