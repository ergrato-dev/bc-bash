#!/usr/bin/env bash
# disk-table.sh — tabla de uso de discos a partir de líneas "montaje total_gb usado_gb".
set -euo pipefail

main() {
  local file="${1:?uso: disk-table.sh <archivo>}"
  local mounts=() sizes=() useds=()
  local mount size used width=7 i pct bar
  while read -r mount size used; do
    mounts+=("$mount")
    sizes+=("$size")
    useds+=("$used")
    if ((${#mount} > width)); then
      width=${#mount}
    fi
  done < "$file"

  # TODO 1: la cabecera MONTAJE TOTAL USADO USO.
  for i in "${!mounts[@]}"; do
    pct=$((useds[i] * 100 / sizes[i]))
    # TODO 3: una barra de # en bar, uno por cada 10%.
    bar=""
    # TODO 2: la fila alineada con la cabecera.
    echo "${mounts[i]} ${sizes[i]}G ${useds[i]}G $pct% $bar"
  done
}

main "$@"
