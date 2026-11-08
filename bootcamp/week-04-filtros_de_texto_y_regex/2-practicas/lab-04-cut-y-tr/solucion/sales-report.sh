#!/usr/bin/env bash
# sales-report.sh — prepara un CSV exportado desde una hoja de cálculo para trabajar con él
# en la terminal: sin finales de Windows, con solo las columnas útiles y ciudades uniformes.
set -euo pipefail

csv=datos/ventas.csv
mkdir -p zona

# Con el \r pegado al último campo, "89.70" sería "89.70\r" y no encajaría en ninguna comparación.
# tr solo lee de stdin: el archivo entra con <.
tr -d '\r' < "$csv" > zona/ventas.csv
# tail -n +2 empieza en la línea 2: se salta la cabecera.
tail -n +2 zona/ventas.csv | cut -d, -f2,5 > zona/importes.csv
# "valencia" y "Valencia" deben contar como la misma ciudad cuando se agrupen.
cut -d, -f1 zona/importes.csv | tr '[:lower:]' '[:upper:]' > zona/ciudades.txt
echo "ventas: $(wc -l < zona/importes.csv)"
