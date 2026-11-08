#!/usr/bin/env bash
# slow-requests.sh — las peticiones que tardaron más de N milisegundos: hora, ruta y tiempo.
# Para qué: que un cron o un pipeline de CI avise cuando la API se vuelve lenta (sale con 1 si hay alguna).
set -euo pipefail

log="${1:?uso: slow-requests.sh <log> <ms>}"
limit="${2:?uso: slow-requests.sh <log> <ms>}"
[[ $limit =~ ^[0-9]+$ ]] || { echo "slow-requests.sh: '$limit' no es un número de milisegundos" >&2; exit 2; }

# -v: el límite entra en awk como una variable con su valor, no como código pegado en el programa.
# OFS es lo que print pone entre lo que le pasas separado por comas.
awk -v limit="$limit" -v OFS=' | ' '
  # "532ms" no parece un número y awk lo compararía como texto ("95ms" > "500").
  # Sumarle 0 lo convierte: awk se queda con las cifras del principio, 532.
  { ms = $5 + 0 }
  ms > limit {
    split($1, t, "T")
    print t[2], $3, ms
    slow++
  }
  # El código de salida de awk es el del script (set -e): 1 si hubo alguna lenta.
  END { exit (slow > 0) }
' "$log"
