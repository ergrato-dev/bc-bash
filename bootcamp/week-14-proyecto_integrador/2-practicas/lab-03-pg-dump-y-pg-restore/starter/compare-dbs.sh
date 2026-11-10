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
  # TODO 1: lista las tablas de "$db" con psql y, para cada una, escribe "tabla filas".
  :
}

# TODO 2: compara row_counts "$1" con row_counts "$2" usando diff y <( ). Si son iguales,
# escribe "iguales"; si no, sal con código 1 (diff ya enseña qué cambia).
echo "iguales"
