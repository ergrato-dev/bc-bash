#!/usr/bin/env bash
# make-logs.sh <carpeta>: crea 8 logs de unos 11 MB, con un espacio en el nombre, para comprimirlos.
# Se generan y no vienen en el repositorio: 90 MB de logs no pintan nada en git.
set -euo pipefail

dir="${1:?uso: make-logs.sh <carpeta>}"
mkdir -p "$dir"
for day in 01 02 03 04 05 06 07 08; do
  # Rutas al azar (shuf): un log real no se repite tanto, y comprimirlo cuesta más.
  shuf -r -i 1-999999 -n 250000 |
    sed "s|^|2026-11-$day 10:00:00 GET /api/items/|; s|\$| 200|" > "$dir/app 2026-11-$day.log"
done
