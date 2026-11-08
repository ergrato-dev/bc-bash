#!/usr/bin/env bash
# archive-report.sh — guarda el informe en zona/archivo/ y borra los temporales.
set -euo pipefail

cd zona
mkdir -p archivo
origen="informe final.txt"

# Sin comillas, el espacio parte el nombre en dos: mv movería final.txt, otro archivo.
mv -- "$origen" archivo/

# El glob se expande antes de que rm lo vea: -f.tmp llegaría como una opción.
# -- marca el final de las opciones.
rm -- *.tmp

echo "en archivo/:"
ls archivo
# El glob va fuera de las comillas: dentro, echo imprimiría *.txt tal cual.
echo "informes que quedan:" *.txt
