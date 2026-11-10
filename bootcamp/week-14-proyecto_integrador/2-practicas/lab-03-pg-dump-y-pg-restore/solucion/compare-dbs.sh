#!/usr/bin/env bash
# compare-dbs.sh — compara cuántas filas tiene cada tabla en dos bases de datos.
# Para qué: comprobar que una copia restaurada tiene lo mismo que la base de la que salió.
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "uso: compare-dbs.sh <base1> <base2>" >&2
  exit 2
fi

# row_counts <base>: una línea "tabla filas" por cada tabla de la base, por orden de nombre.
row_counts() {
  local db="$1" table
  psql -d "$db" -v ON_ERROR_STOP=1 -Atc \
    "select tablename from pg_tables where schemaname = 'public' order by 1" |
    while read -r table; do
      # < /dev/null: este psql no debe leer del pipe; las tablas que quedan son para read.
      printf '%s %s\n' "$table" "$(psql -d "$db" -Atc "select count(*) from \"$table\"" < /dev/null)"
    done
}

# diff con <( ): compara las dos salidas sin archivos temporales. diff sale con 0 si son
# iguales y con 1 si no, después de enseñar las líneas que cambian (< de la primera, > de la segunda).
if diff <(row_counts "$1") <(row_counts "$2"); then
  echo "iguales"
else
  exit 1
fi
