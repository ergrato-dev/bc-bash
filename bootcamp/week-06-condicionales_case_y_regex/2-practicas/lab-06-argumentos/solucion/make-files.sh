#!/usr/bin/env bash
# make-files.sh — crea archivos vacíos; con -v, dice cuáles ha creado.
set -euo pipefail

verbose=""
case "${1:-}" in
  -v)
    verbose=1
    shift
    ;;
esac
if [[ $# -eq 0 ]]; then
  echo "uso: make-files.sh [-v] <archivo>..." >&2
  exit 2
fi

# "$@" pasa cada argumento tal cual llegó; $* los junta y los vuelve a partir por
# los espacios. -- evita que un nombre como -r se tome por una opción de touch.
touch -- "$@"
if [[ -n $verbose ]]; then
  printf 'creado: %s\n' "$@"
fi
