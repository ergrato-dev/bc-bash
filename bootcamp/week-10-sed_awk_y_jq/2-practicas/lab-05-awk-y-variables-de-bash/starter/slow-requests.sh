#!/usr/bin/env bash
# slow-requests.sh — las peticiones que tardaron más de N milisegundos: hora, ruta y tiempo.
# Para qué: que un cron o un pipeline de CI avise cuando la API se vuelve lenta (sale con 1 si hay alguna).
set -euo pipefail

log="${1:?uso: slow-requests.sh <log> <ms>}"
limit="${2:?uso: slow-requests.sh <log> <ms>}"
[[ $limit =~ ^[0-9]+$ ]] || { echo "slow-requests.sh: '$limit' no es un número de milisegundos" >&2; exit 2; }

# TODO 1: pasa el límite a awk con -v.
# TODO 2: compara el tiempo como número, sin la "ms" del final.
# TODO 3: solo la hora (lo que va detrás de la T), la ruta y los ms, separados por " | ".
# TODO 4: sale con 1 si hubo alguna petición lenta.
awk '$5 > limit' "$log"
