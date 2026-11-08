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

  # Un formato para la cabecera y otro para las filas, con los mismos anchos.
  printf '%-*s %6s %6s %4s\n' "$width" MONTAJE TOTAL USADO USO
  for i in "${!mounts[@]}"; do
    pct=$((useds[i] * 100 / sizes[i]))
    # %*s con un texto vacío da tantos espacios como diga el ancho; luego cada espacio, un #.
    printf -v bar '%*s' $((pct / 10)) ''
    printf '%-*s %5sG %5sG %3d%% %s\n' "$width" "${mounts[i]}" "${sizes[i]}" "${useds[i]}" "$pct" "${bar// /#}"
  done
}

main "$@"
