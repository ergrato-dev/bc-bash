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

# TODO 1: si pg_restore -l no sabe leer "$file", avisa de que no es una copia de
# pg_dump -Fc y sal con código 1, antes de tocar la base.

# TODO 2: sin -y, pregunta antes de seguir. Si no hay terminal (-t 0), sal con código 2
# y di que uses -y; si la respuesta no es s o S, sal con código 1 sin tocar nada.

# TODO 3: restaura con pg_restore, borrando antes lo que haya y todo o nada.
echo "sin implementar" >&2
exit 1
