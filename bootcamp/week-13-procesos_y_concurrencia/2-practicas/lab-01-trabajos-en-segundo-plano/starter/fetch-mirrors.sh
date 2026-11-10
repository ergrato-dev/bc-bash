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

# TODO 1: lanza cada descarga en segundo plano y guarda su pid en el array pids.
while read -r name seconds code; do
  download "$name" "$seconds" "$code"
done < "$list"

# TODO 2: espera a cada pid y cuenta las que fallan; si falla alguna, avisa y sale con 1.
wait
echo "todas las descargas terminadas"
