#!/usr/bin/env bash
# connect-db.sh — arma la URL de conexión a PostgreSQL con las variables DB_*.
set -euo pipefail

# TODO 1: DB_HOST, o localhost si no existe o está vacía (paso 7)
host="$DB_HOST"
# TODO 2: DB_PORT, o 5432 (paso 8)
port=5432
# TODO 3: DB_USER es obligatoria: si falta, para con un mensaje claro (paso 9)
user=postgres
# TODO 4: DB_NAME, o el mismo valor que user (paso 10)
name=postgres

# TODO 5: añade " (con contraseña)" al final solo si DB_PASSWORD tiene algo (paso 11)
echo "postgresql://$user@$host:$port/$name"
