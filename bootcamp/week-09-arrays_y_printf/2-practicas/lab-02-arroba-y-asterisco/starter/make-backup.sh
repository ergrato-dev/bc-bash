#!/usr/bin/env bash
# make-backup.sh — empaqueta una carpeta en copia.tgz; con --sin-logs deja fuera los .log.
set -euo pipefail

main() {
  local src="${1:?uso: make-backup.sh <carpeta> [--sin-logs]}"
  # TODO 1: las opciones en un array, no en un texto.
  local args="-czf copia.tgz"
  if [[ ${2:-} == --sin-logs ]]; then
    : # TODO 2: añadir --exclude='*.log' al array.
  fi
  args="$args -C $src ."

  # Cada argumento entre corchetes: se ve dónde empieza y dónde acaba cada uno.
  printf '[%s]' tar $args
  echo
  tar $args
}

main "$@"
