#!/usr/bin/env bash
# mask-ips.sh — escribe un access log sin datos personales: la IP sin su último número y sin tokens en las URLs.
# Para qué: poder pegar el log en un ticket o pasarlo a otro equipo.
set -euo pipefail

log="${1:?uso: mask-ips.sh <access.log>}"

# Un -e por sustitución: sed las aplica en orden a cada línea.
# ^ ata la IP al principio: la del referer, más adelante, no es la del visitante.
# [^& "]+ es el valor del token, hasta el siguiente parámetro, el espacio o las comillas.
sed -E \
  -e 's/^([0-9]+\.[0-9]+\.[0-9]+)\.[0-9]+ /\1.0 /' \
  -e 's/([?&]token=)[^& "]+/\1XXX/g' \
  "$log"
