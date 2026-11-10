#!/usr/bin/env bash
# wait-for-db.sh — espera a que PostgreSQL acepte conexiones, como mucho N segundos (30).
# Para qué: que lo que va detrás (una copia, una migración) no falle por llegar antes que la base.
set -euo pipefail

limit="${1:-30}"
if [[ ! $limit =~ ^[0-9]+$ ]]; then
  echo "uso: wait-for-db.sh [segundos]" >&2
  exit 2
fi

# TODO 1: mientras pg_isready -q falle, espera 1 segundo y vuelve a preguntar.
# TODO 2: si ya han pasado $limit segundos, avisa en stderr y sal con código 1.
# SECONDS es una variable de bash: los segundos desde que empezó el script.

echo "PostgreSQL responde después de $SECONDS s"
