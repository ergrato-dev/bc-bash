#!/usr/bin/env bash
# connect-db.sh — arma la URL de conexión a PostgreSQL con las variables DB_*.
set -euo pipefail

# :- da un valor por defecto sin tocar la variable; con set -u, "$DB_HOST" a secas
# pararía el script si no existe.
host="${DB_HOST:-localhost}"
port="${DB_PORT:-5432}"
# Sin usuario no hay valor razonable que inventar: :? para el script con el mensaje.
user="${DB_USER:?dime con qué usuario conectar}"
# El valor por defecto puede ser otra variable: en PostgreSQL, la base se llama
# como el usuario si no se dice otra cosa.
name="${DB_NAME:-$user}"

# :+ añade el texto solo si DB_PASSWORD tiene algo; la contraseña nunca se imprime.
echo "postgresql://$user@$host:$port/$name${DB_PASSWORD:+ (con contraseña)}"
