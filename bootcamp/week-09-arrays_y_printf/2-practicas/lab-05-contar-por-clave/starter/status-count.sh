#!/usr/bin/env bash
# status-count.sh — cuántas peticiones de un access log acabaron con cada código HTTP.
set -euo pipefail

main() {
  local log="${1:?uso: status-count.sh <access.log>}"
  local -A count=()
  local status total=0
  # El código es el campo 9; _ recoge los que no interesan, y el último, el resto de la línea.
  while read -r _ _ _ _ _ _ _ _ status _; do
    ((count[$status]++)) # TODO 1
    total=$((total + 1))
  done < "$log"

  # TODO 2: una línea por código, de más a menos.
  # TODO 3: el porcentaje de cada código.
  declare -p count total
}

main "$@"
