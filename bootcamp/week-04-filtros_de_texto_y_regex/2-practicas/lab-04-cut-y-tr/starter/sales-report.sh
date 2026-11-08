#!/usr/bin/env bash
# sales-report.sh — prepara un CSV exportado desde una hoja de cálculo para trabajar con él
# en la terminal: sin finales de Windows, con solo las columnas útiles y ciudades uniformes.
set -euo pipefail

csv=datos/ventas.csv
mkdir -p zona

# TODO 1: copia "$csv" en zona/ventas.csv sin los \r de Windows (paso 8)
# TODO 2: de zona/ventas.csv, sin la cabecera, ciudad e importe en zona/importes.csv (paso 9)
# TODO 3: las ciudades de zona/importes.csv en mayúsculas, una por línea, en zona/ciudades.txt (paso 10)
echo "ventas: $(wc -l < zona/importes.csv)"
