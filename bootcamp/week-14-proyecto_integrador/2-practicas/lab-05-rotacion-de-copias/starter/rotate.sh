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

# TODO 1: guarda en el array copies las copias de "$db" que hay en "$dir", con nombre
# <base>-AAAAMMDD-HHMMSS.dump, de la más vieja a la más nueva. Sin ninguna, el array vacío.

# TODO 2: calcula cuántas sobran (excess); si no sobra ninguna, sal con 0.

# TODO 3: recorre las que sobran (las primeras del array): con -n escribe "borraría <archivo>";
# sin -n, bórralas y escribe "borrada <archivo>".
