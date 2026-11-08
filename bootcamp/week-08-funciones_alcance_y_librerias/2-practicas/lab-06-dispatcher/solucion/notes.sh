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
  [[ $# -gt 0 ]] || { usage >&2; exit 2; }
  echo "$*" >> "$notes_file"
}

cmd_list() {
  # Sin notas todavía, el archivo no existe: no es un error, es una lista vacía.
  [[ -f $notes_file ]] || return 0
  local n=0 line
  while IFS= read -r line; do
    n=$((n + 1))
    echo "$n. $line"
  done < "$notes_file"
}

cmd_count() {
  cmd_list | wc -l
}

main() {
  case "${1:-}" in
    add)
      shift
      cmd_add "$@"
      ;;
    list) cmd_list ;;
    count) cmd_count ;;
    -h | --help) usage ;;
    *)
      usage >&2
      exit 2
      ;;
  esac
}

main "$@"
