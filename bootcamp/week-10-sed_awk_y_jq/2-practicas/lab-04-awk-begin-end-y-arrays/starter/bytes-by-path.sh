#!/usr/bin/env bash
# bytes-by-path.sh — cuántas peticiones y cuántos bytes se llevó cada ruta de un access log, de más a menos bytes.
# Para qué: saber qué archivo se come el ancho de banda antes de pagar más.
set -euo pipefail

log="${1:?uso: bytes-by-path.sh <access.log>}"

# TODO 3: una cabecera RUTA PETICIONES BYTES, encima de las filas.
awk '
  # TODO 1: un contador de peticiones y una suma de bytes ($10) por ruta ($7).
  { print $7, $10 }
  # TODO 2: al terminar, una línea por ruta: ruta, peticiones y bytes.
' "$log"
