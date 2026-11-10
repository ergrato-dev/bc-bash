#!/usr/bin/env bash
# restore.sh — deja la base de PGDATABASE como estaba en una copia de pg_dump -Fc.
# Para qué: volver atrás después de un borrado sin teclear las opciones de pg_restore a mano.
set -euo pipefail

yes=""
if [[ ${1:-} == -y ]]; then
  yes=1
  shift
fi
file="${1:-}"
if [[ -z $file || ! -r $file ]]; then
  echo "uso: restore.sh [-y] <copia.dump>" >&2
  exit 2
fi

# pg_restore -l solo lee el índice: si falla, el archivo no es una copia custom o está
# cortado, y se para antes de borrar nada.
if ! pg_restore -l "$file" > /dev/null 2>&1; then
  echo "'$file' no es una copia de pg_dump -Fc" >&2
  exit 1
fi

# Restaurar borra lo que hay ahora: se pregunta, salvo con -y. -t 0: ¿la entrada es una
# terminal? Desde cron o un pipe nadie puede contestar, y suponer un sí sería peligroso.
if [[ -z $yes ]]; then
  if [[ ! -t 0 ]]; then
    echo "sin terminal no puedo preguntar: usa -y para confirmar" >&2
    exit 2
  fi
  read -r -p "Esto reemplaza lo que hay en '$PGDATABASE' por '$file'. ¿Seguir? [s/N] " answer || answer=""
  if [[ $answer != [sS] ]]; then
    echo "cancelado: no he tocado la base" >&2
    exit 1
  fi
fi

# --clean --if-exists: borra cada objeto antes de crearlo, sin error si no existe.
# --no-owner: lo restaurado es del usuario que restaura, aunque la copia venga de otro.
# --single-transaction: todo o nada; al primer error, la base se queda como estaba.
pg_restore --clean --if-exists --no-owner --single-transaction -d "$PGDATABASE" "$file"
echo "'$PGDATABASE' restaurada desde '$file'"
