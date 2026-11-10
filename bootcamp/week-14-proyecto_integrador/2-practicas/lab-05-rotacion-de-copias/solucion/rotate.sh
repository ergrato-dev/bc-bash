#!/usr/bin/env bash
# rotate.sh — deja en una carpeta solo las N copias más nuevas de una base; con -n solo
# dice qué borraría.
# Para qué: que las copias de cada noche no llenen el disco.
set -euo pipefail

dry_run=""
if [[ ${1:-} == -n ]]; then
  dry_run=1
  shift
fi
if [[ $# -ne 3 || ! $3 =~ ^[1-9][0-9]*$ ]]; then
  echo "uso: rotate.sh [-n] <carpeta> <base> <copias>" >&2
  exit 2
fi
dir="$1"
db="$2"
keep="$3"

# nullglob: un glob sin coincidencias se queda en nada, no en el propio texto del patrón.
# Sin él, con la carpeta vacía, copies tendría un elemento: "copias/tienda-????????-??????.dump".
shopt -s nullglob
# Cada ? es un carácter: solo encaja la forma exacta de la fecha, así que no entran las
# copias de otra base cuyo nombre empiece igual (tienda-viejo-... para "tienda").
# El glob sale ordenado por nombre, y con la fecha de año a segundo eso es de vieja a nueva.
copies=("$dir/$db"-????????-??????.dump)

excess=$((${#copies[@]} - keep))
if ((excess <= 0)); then
  exit 0
fi

# ${copies[@]:0:excess}: los excess primeros elementos del array, las más viejas.
for old in "${copies[@]:0:excess}"; do
  if [[ -n $dry_run ]]; then
    echo "borraría $old"
  else
    rm -- "$old"
    echo "borrada $old"
  fi
done
