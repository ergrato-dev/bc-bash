#!/usr/bin/env bash
# count-orders.sh — escribe cuántos pedidos hay en la tienda de PGDATABASE.
# Para qué: un comando pequeño con tests, para montar su CI sin distraerse con el comando.
set -euo pipefail

if ! pg_isready -q; then
  echo "PostgreSQL no responde en '${PGHOST:-localhost}'" >&2
  exit 1
fi
psql -v ON_ERROR_STOP=1 -Atc 'select count(*) from pedidos'
