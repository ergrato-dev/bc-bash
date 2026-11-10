#!/usr/bin/env bash
# backup.sh — copia la base de PGDATABASE, comprimida, en copias/<base>.sql.gz.
# Para qué: tener a mano la copia de anoche por si hoy algo sale mal.
# pipefail: sin él, el código de "pg_dump | gzip" es el de gzip, que sale con 0 aunque
# pg_dump falle, y el script diría "copia hecha" con un archivo vacío.
set -euo pipefail

mkdir -p copias
final="copias/$PGDATABASE.sql.gz"
# La copia se escribe en un temporal de la misma carpeta: si algo falla, la buena de ayer
# sigue intacta. mv dentro de un mismo disco es instantáneo: nadie ve nunca media copia.
partial="copias/.$PGDATABASE.sql.gz.partial"
# Pase lo que pase (un fallo, un Ctrl-C), el temporal no se queda en la carpeta.
trap 'rm -f "$partial"' EXIT

if ! pg_dump | gzip > "$partial"; then
  echo "la copia falló: $final no se ha tocado" >&2
  exit 1
fi
mv "$partial" "$final"
echo "copia hecha: $final"
