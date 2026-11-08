#!/usr/bin/env bash
# port-of.sh — dice el puerto de cada servicio que le pidas, según datos/puertos.conf.
set -euo pipefail

conf="$(dirname "${BASH_SOURCE[0]}")/../datos/puertos.conf"

main() {
  [[ $# -gt 0 ]] || { echo "uso: port-of.sh <servicio>... | --list" >&2; exit 2; }
  # TODO 1: un array asociativo ports, con el servicio como clave.
  local line name status=0
  while IFS= read -r line; do
    # Las líneas vacías y los comentarios no son servicios.
    [[ -z $line || $line == \#* ]] && continue
    : # TODO 1: guardar el puerto con el servicio como clave.
  done < "$conf"

  if [[ $1 == --list ]]; then
    : # TODO 3: todos los servicio=puerto, ordenados.
    return 0
  fi

  for name in "$@"; do
    # TODO 2: el puerto, o un aviso en stderr si no existe ese servicio.
    echo "sin implementar: $name"
  done
  # TODO 2: borra esta línea, que mientras tanto enseña lo que se cargó.
  declare -p ports 2>&1 || true
  return "$status"
}

main "$@"
