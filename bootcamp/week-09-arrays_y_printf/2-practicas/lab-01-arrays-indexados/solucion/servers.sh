#!/usr/bin/env bash
# servers.sh — cuenta y numera los servidores de una lista, uno por línea.
set -euo pipefail

main() {
  local file="${1:?uso: servers.sh <lista>}"
  local servers=() i
  # Una línea, un elemento del array: un nombre con espacios sigue siendo uno.
  mapfile -t servers < "$file"

  echo "${#servers[@]} servidores"
  echo "primero: ${servers[0]}"
  # -1 cuenta desde el final: el último, sin saber cuántos hay.
  echo "último: ${servers[-1]}"

  # ${!servers[@]} son los índices (0, 1, 2...); se suma 1 para numerar desde 1.
  for i in "${!servers[@]}"; do
    echo "$((i + 1)). ${servers[i]}"
  done
}

main "$@"
