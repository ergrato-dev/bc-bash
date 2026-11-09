#!/usr/bin/env bash
# grep-log.sh — las líneas de un log que contienen un texto: todas, las últimas N o cuántas hay.
# Para qué: mirar errores en un log sin recordar la combinación de grep, tail y wc de cada vez.
set -euo pipefail

usage="uso: grep-log.sh [-i] [-c] [-n N] <texto> <log>"

ignore_case=""
count_only=""
last=0

# getopts lee una opción en cada vuelta y la deja en opt. "n:" lleva valor, que llega en
# OPTARG. Los dos puntos del principio: getopts no avisa, y deja ":" o "?" en opt para
# que los errores los dé el script, con su mensaje y su código.
while getopts ":icn:h" opt; do
  case "$opt" in
    i) ignore_case=1 ;;
    c) count_only=1 ;;
    n)
      [[ $OPTARG =~ ^[1-9][0-9]*$ ]] || { echo "grep-log.sh: -n necesita un número, no '$OPTARG'" >&2; exit 2; }
      last="$OPTARG"
      ;;
    h)
      echo "$usage"
      exit 0
      ;;
    :)
      echo "grep-log.sh: a -$OPTARG le falta su valor" >&2
      exit 2
      ;;
    *)
      echo "grep-log.sh: opción desconocida: -$OPTARG" >&2
      echo "$usage" >&2
      exit 2
      ;;
  esac
done
# OPTIND es la posición del primer argumento que no es una opción: sin el shift,
# $1 seguiría siendo "-i" y no el texto.
shift $((OPTIND - 1))

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
