#!/usr/bin/env bash
# slugify.sh — convierte cada título en un slug, el nombre que va en una URL: "Hola Mundo!" da hola-mundo.
# Para qué: nombres de archivo y de página sin espacios, mayúsculas ni símbolos.
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "uso: slugify.sh <título>..." >&2
  exit 2
fi

for title in "$@"; do
  # Minúsculas, los espacios a guiones y fuera todo lo que no sea letra, cifra o guion.
  # tr -s junta los guiones seguidos: "Hola  Mundo" da un solo guion, no dos.
  slug="${title,,}"
  slug="$(tr -s ' ' '-' <<< "$slug")"
  slug="${slug//[^a-z0-9-]/}"
  echo "$slug"
done
