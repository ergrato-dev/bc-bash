#!/usr/bin/env bash
# status-count.sh — cuántas peticiones de un access log acabaron con cada código HTTP.
set -euo pipefail

main() {
  local log="${1:?uso: status-count.sh <access.log>}"
  local -A count=()
  local status total=0
  # El código es el campo 9; _ recoge los que no interesan, y el último, el resto de la línea.
  while read -r _ _ _ _ _ _ _ _ status _; do
    # ((count[$status]++)) valdría 0 la primera vez y set -e pararía el script.
    count[$status]=$((${count[$status]:-0} + 1))
    total=$((total + 1))
  done < "$log"

  # De más a menos: sort -rn ordena por el número del principio.
  for status in "${!count[@]}"; do
    echo "${count[$status]} $status $((count[$status] * 100 / total))%"
  done | sort -rn
}

main "$@"
