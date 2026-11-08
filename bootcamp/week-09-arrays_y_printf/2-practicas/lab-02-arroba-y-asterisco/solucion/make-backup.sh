#!/usr/bin/env bash
# make-backup.sh — empaqueta una carpeta en copia.tgz; con --sin-logs deja fuera los .log.
set -euo pipefail

main() {
  local src="${1:?uso: make-backup.sh <carpeta> [--sin-logs]}"
  # Las opciones de tar, una por elemento: "mis datos" sigue siendo un solo argumento.
  local args=(-czf copia.tgz)
  if [[ ${2:-} == --sin-logs ]]; then
    args+=(--exclude='*.log')
  fi
  # -C entra en la carpeta antes de empaquetar: dentro del .tgz no queda la ruta entera.
  args+=(-C "$src" .)

  # Cada argumento entre corchetes: se ve dónde empieza y dónde acaba cada uno.
  printf '[%s]' tar "${args[@]}"
  echo
  tar "${args[@]}"
}

main "$@"
