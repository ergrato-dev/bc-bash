#!/usr/bin/env bash
# wait-for-db.sh — espera a que PostgreSQL acepte conexiones, como mucho N segundos (30).
# Para qué: que lo que va detrás (una copia, una migración) no falle por llegar antes que la base.
set -euo pipefail

limit="${1:-30}"
if [[ ! $limit =~ ^[0-9]+$ ]]; then
  echo "uso: wait-for-db.sh [segundos]" >&2
  exit 2
fi

# until repite mientras el comando falle. -q: pg_isready no escribe nada, solo da el código.
# SECONDS es una variable de bash: los segundos desde que empezó el script.
until pg_isready -q; do
  if ((SECONDS >= limit)); then
    echo "PostgreSQL no responde después de $limit s" >&2
    exit 1
  fi
  sleep 1
done
echo "PostgreSQL responde después de $SECONDS s"
