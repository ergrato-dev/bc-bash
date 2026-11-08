#!/usr/bin/env bash
# log-summary.sh — resumen rápido de un log: cuántas líneas tiene, la primera, la última
# y una copia de las 5 últimas para mirarlas después.
set -euo pipefail

log=datos/app.log
mkdir -p zona

# TODO 1: imprime "líneas: " y el número de líneas de "$log", solo el número (paso 7)
# TODO 2: imprime "primera: " y la primera línea de "$log" (paso 8)
# TODO 3: imprime "última: " y la última línea de "$log" (paso 8)
# TODO 4: guarda las 5 últimas líneas de "$log" en zona/ultimas.txt (paso 9)
