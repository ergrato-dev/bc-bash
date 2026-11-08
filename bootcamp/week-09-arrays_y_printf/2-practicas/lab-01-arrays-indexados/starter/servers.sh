#!/usr/bin/env bash
# servers.sh — cuenta y numera los servidores de una lista, uno por línea.
set -euo pipefail

main() {
  local file="${1:?uso: servers.sh <lista>}"
  local servers=() i
  # Una línea, un elemento del array: un nombre con espacios sigue siendo uno.
  mapfile -t servers < "$file"

  # TODO 1: cuántos servidores hay.
  # TODO 2: el primero y el último.
  # TODO 3: la lista numerada desde 1.
  echo "sin implementar: ${servers[*]}"
}

main "$@"
