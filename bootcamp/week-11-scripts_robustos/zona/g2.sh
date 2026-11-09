#!/usr/bin/env bash
# grep-log.sh — las líneas de un log que contienen un texto: todas, las últimas N o cuántas hay.
# Para qué: mirar errores en un log sin recordar la combinación de grep, tail y wc de cada vez.
set -euo pipefail

usage="uso: grep-log.sh [-i] [-c] [-n N] <texto> <log>"

ignore_case=""
count_only=""
last=0

while getopts "ich" opt; do
  case "$opt" in
    i) ignore_case=1 ;;
    c) count_only=1 ;;
    h)
      echo "$usage"
      exit 0
      ;;
  esac
done
shift $((OPTIND - 1))
# TODO 3: -n N, con su valor en OPTARG; tiene que ser un número.
# TODO 4: una opción desconocida o sin valor: aviso en stderr y código 2.

[[ $# -eq 2 ]] || { echo "$usage" >&2; exit 2; }
pattern="$1"
log="$2"

# -F: el texto se busca tal cual, sin regex: "95%" o "a.b" no son patrones.
grep_opts=(-F)
[[ -z $ignore_case ]] || grep_opts+=(-i)

if [[ -n $count_only ]]; then
  # grep -c sale con 1 si no hay ninguna: "0" también es una respuesta.
  grep -c "${grep_opts[@]}" -- "$pattern" "$log" || true
elif ((last > 0)); then
  { grep "${grep_opts[@]}" -- "$pattern" "$log" || true; } | tail -n "$last"
else
  grep "${grep_opts[@]}" -- "$pattern" "$log" || true
fi
