#!/usr/bin/env bash
# find-files.sh — busca en starter/web por nombre y por tipo, y guarda un listado.

mkdir -p zona

echo "== hojas de estilo =="
# Comillas en '*.css': el * tiene que llegarle a find, no a bash.
find starter/web -name '*.css'

echo "== carpetas =="
find starter/web -type d

echo "== páginas, guardadas en zona/paginas.txt =="
# > reemplaza el archivo en cada ejecución: el listado siempre está al día.
find starter/web -type f -name '*.html' > zona/paginas.txt
cat zona/paginas.txt
