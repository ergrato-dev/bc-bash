#!/usr/bin/env bash
# mask-ips.sh — escribe un access log sin datos personales: la IP sin su último número y sin tokens en las URLs.
# Para qué: poder pegar el log en un ticket o pasarlo a otro equipo.
set -euo pipefail

log="${1:?uso: mask-ips.sh <access.log>}"

# TODO 1: la IP del principio de la línea, sin su último número (192.168.1.27 pasa a 192.168.1.0).
# TODO 2: el valor de cada token= de las URLs, cambiado por XXX.
cat "$log"
