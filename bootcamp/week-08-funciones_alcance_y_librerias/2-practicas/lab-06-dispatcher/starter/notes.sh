#!/usr/bin/env bash
# notes.sh — notas rápidas desde la terminal: notes.sh add|list|count.
# Para qué: apuntar lo que haces en una máquina sin abrir un editor.
set -euo pipefail

# NOTES_FILE cambia dónde se guardan; si no, notas.txt en la carpeta actual.
notes_file="${NOTES_FILE:-notas.txt}"

usage() {
  echo "uso: notes.sh add <texto> | list | count"
}

# Un subcomando, una función: cmd_<nombre>.
cmd_add() {
  # TODO 2: sin argumentos, usage a stderr y exit 2; si no, "$*" al final de "$notes_file".
  echo "sin implementar: add $*"
}

cmd_list() {
  # TODO 3: si "$notes_file" no existe, return 0; si existe, cada línea con su número: "1. texto".
  echo "sin implementar: list"
}

cmd_count() {
  cmd_list | wc -l
}

main() {
  # TODO 1: case con "${1:-}": add (shift y cmd_add "$@"), list, count, -h/--help y *) uso a stderr y exit 2.
  echo "sin implementar: $*"
}

main "$@"
