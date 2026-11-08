#!/usr/bin/env bash
# path-kind.sh — dice qué hay en una ruta: nada, un enlace roto, una carpeta o qué tipo de archivo.
set -euo pipefail

p="${1:?uso: path-kind.sh <ruta>}"

# El orden importa: -e sigue el enlace y da falso si el destino no existe, así que el
# enlace roto va antes que "no existe"; y una carpeta también tiene -x, así que -d va
# antes que -x.
if [[ -L $p && ! -e $p ]]; then
  echo "$p: enlace roto"
elif [[ ! -e $p ]]; then
  echo "$p: no existe" >&2
  exit 1
elif [[ -d $p ]]; then
  echo "$p: directorio"
elif [[ ! -s $p ]]; then
  echo "$p: archivo vacío"
elif [[ -x $p ]]; then
  echo "$p: ejecutable"
else
  echo "$p: archivo"
fi
