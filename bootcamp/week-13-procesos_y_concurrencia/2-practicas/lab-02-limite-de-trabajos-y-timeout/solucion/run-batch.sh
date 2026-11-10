#!/usr/bin/env bash
# run-batch.sh — ejecuta a la vez las tareas de una lista y dice cuáles fallan.
# Para qué: no esperar una detrás de otra, sin lanzar cien a la vez ni colgarse con una.
set -euo pipefail

usage="uso: run-batch.sh [-j trabajos] [-t segundos] <lista>"
max_jobs=3
limit=10
while getopts ":j:t:" opt; do
  case "$opt" in
    j) max_jobs="$OPTARG" ;;
    t) limit="$OPTARG" ;;
    *)
      echo "$usage" >&2
      exit 2
      ;;
  esac
done
shift $((OPTIND - 1))
list="${1:?$usage}"
# task.sh está en la misma carpeta que este script.
task="$(dirname "${BASH_SOURCE[0]}")/task.sh"

pids=()
names=()
while read -r name seconds; do
  # No más de max_jobs a la vez: jobs -rp da los pids de las que siguen en marcha, y
  # wait -n espera a que acabe una cualquiera. Su código no sirve: en bash 5.2, wait -n no
  # ve una tarea que ya terminó. El de cada una lo da wait <pid>, al final.
  while (($(jobs -rp | wc -l) >= max_jobs)); do
    wait -n || true
  done
  # timeout para la tarea si pasa de limit segundos, y entonces sale con 124.
  # -k 2: si 2 segundos después sigue viva (ignora TERM), la mata con KILL (código 137).
  timeout -k 2 "$limit" "$task" "$name" "$seconds" &
  pids+=("$!")
  names+=("$name")
  echo "en marcha: $(jobs -rp | wc -l)" >&2
done < "$list"

failed=0
for i in "${!pids[@]}"; do
  code=0
  wait "${pids[i]}" || code=$?
  if ((code != 0)); then
    echo "run-batch.sh: ${names[i]} salió con código $code" >&2
    failed=$((failed + 1))
  fi
done
if ((failed > 0)); then
  exit 1
fi
