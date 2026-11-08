#!/usr/bin/env bash
# path-parts.sh — separa una ruta en carpeta, nombre y extensión, y propone el nombre de su copia.
set -euo pipefail

test "$#" -gt 0 || { echo "uso: path-parts.sh <ruta>" >&2; exit 2; }
ruta="$1"
echo "ruta:      $ruta (${#ruta} caracteres)"

# TODO 1: el nombre tiene que ser lo que hay tras la última / (paso 8)
nombre="${ruta#*/}"
echo "nombre:    $nombre"
# TODO 2: carpeta: todo lo que hay antes de la última / (paso 9)
# TODO 3: extensión (tras el último punto) y base (el nombre sin ella) (paso 10)
# TODO 4: imprime "tipo:" y la extensión en mayúsculas (paso 11)
# TODO 5: imprime "copia:" y carpeta/base-copia.extensión (paso 12)
