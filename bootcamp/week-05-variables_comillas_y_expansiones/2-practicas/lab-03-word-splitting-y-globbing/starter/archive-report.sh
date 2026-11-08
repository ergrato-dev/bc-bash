#!/usr/bin/env bash
# archive-report.sh — guarda el informe en zona/archivo/ y borra los temporales.
set -euo pipefail

cd zona
mkdir -p archivo
origen="informe final.txt"

# TODO 1: mueve a archivo/ solo el informe (paso 9)
mv $origen archivo/

# TODO 2: borra todos los .tmp, también los que empiezan por - (paso 10)
rm *.tmp

echo "en archivo/:"
ls archivo
# TODO 3: imprime "informes que quedan:" y los .txt de la carpeta, con un glob (paso 11)
