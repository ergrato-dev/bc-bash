#!/usr/bin/env bash
# log-summary.sh — resumen rápido de un log: cuántas líneas tiene, la primera, la última
# y una copia de las 5 últimas para mirarlas después.
set -euo pipefail

log=datos/app.log
mkdir -p zona

# Con < el archivo llega por stdin y wc no repite su nombre: queda solo el número.
echo "líneas: $(wc -l < "$log")"
echo "primera: $(head -1 "$log")"
echo "última: $(tail -1 "$log")"
# > y no >>: cada ejecución deja solo las 5 últimas de ahora, no se acumulan.
tail -5 "$log" > zona/ultimas.txt
