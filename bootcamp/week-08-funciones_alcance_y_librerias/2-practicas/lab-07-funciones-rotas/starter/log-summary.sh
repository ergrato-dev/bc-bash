#!/usr/bin/env bash
# log-summary.sh — para cada .log: cuántas líneas tiene y cuántas dicen ERROR.
# Para qué: saber qué log mirar primero después de un fallo.
set -euo pipefail

print_summary # TODO 1 y TODO 2

# count_errors <archivo>: cuántas líneas dicen ERROR.
count_errors() {
  echo "contando en $1" # TODO 3
  # grep -c sale con 1 si cuenta 0 líneas: || true evita que set -e pare el script.
  grep -c ERROR "$1" || true
}

# is_log <archivo>: sale con 0 si el nombre termina en .log.
is_log() {
  [[ $1 == *.log ]] || exit 1 # TODO 4
}

print_summary() {
  local f
  for f in "$@"; do
    if ! is_log "$f"; then
      echo "ignorado: $f" >&2
      continue
    fi
    echo "$f: $(wc -l < "$f") líneas, $(count_errors "$f") con ERROR"
  done
}
