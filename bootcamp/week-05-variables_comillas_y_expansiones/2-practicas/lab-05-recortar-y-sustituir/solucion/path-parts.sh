#!/usr/bin/env bash
# path-parts.sh — separa una ruta en carpeta, nombre y extensión, y propone el nombre de su copia.
set -euo pipefail

test "$#" -gt 0 || { echo "uso: path-parts.sh <ruta>" >&2; exit 2; }
ruta="$1"
echo "ruta:      $ruta (${#ruta} caracteres)"

# ## quita lo más largo que encaje con */: hasta la última /. Con una #, solo la primera.
nombre="${ruta##*/}"
echo "nombre:    $nombre"
# % quita del final lo más corto que encaje con /*: la última / y el nombre.
carpeta="${ruta%/*}"
echo "carpeta:   $carpeta"
# Con varios puntos (access.log.2.gz), la extensión es solo lo que va tras el último.
extension="${nombre##*.}"
base="${nombre%.*}"
echo "extensión: $extension"
echo "base:      $base"
echo "tipo:      ${extension^^}"
echo "copia:     $carpeta/$base-copia.$extension"
