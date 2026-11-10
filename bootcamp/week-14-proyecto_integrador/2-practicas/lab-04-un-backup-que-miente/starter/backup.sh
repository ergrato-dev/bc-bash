#!/usr/bin/env bash
# backup.sh — copia la base de PGDATABASE, comprimida, en copias/<base>.sql.gz.
# Para qué: tener a mano la copia de anoche por si hoy algo sale mal.
set -eu

mkdir -p copias
pg_dump | gzip > "copias/$PGDATABASE.sql.gz"
echo "copia hecha: copias/$PGDATABASE.sql.gz"
