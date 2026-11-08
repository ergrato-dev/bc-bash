#!/usr/bin/env bash
# port-of.sh — dice el puerto de cada servicio que le pidas, según datos/puertos.conf.
set -euo pipefail

conf="$(dirname "${BASH_SOURCE[0]}")/../datos/puertos.conf"

main() {
  [[ $# -gt 0 ]] || { echo "uso: port-of.sh <servicio>... | --list" >&2; exit 2; }
  local -A ports=()
  local line name status=0
  while IFS= read -r line; do
    # Las líneas vacías y los comentarios no son servicios.
    [[ -z $line || $line == \#* ]] && continue
    ports[${line%%=*}]=${line#*=}
  done < "$conf"

  if [[ $1 == --list ]]; then
    # Las claves salen sin orden: sort las ordena.
    for name in "${!ports[@]}"; do
      echo "$name=${ports[$name]}"
    done | sort
    return 0
  fi

  for name in "$@"; do
    # -v dice si la clave existe; sin él, uno que no está y uno vacío se confunden.
    if [[ -v ports[$name] ]]; then
      echo "$name: ${ports[$name]}"
    else
      echo "port-of.sh: no conozco '$name'" >&2
      status=1
    fi
  done
  return "$status"
}

main "$@"
