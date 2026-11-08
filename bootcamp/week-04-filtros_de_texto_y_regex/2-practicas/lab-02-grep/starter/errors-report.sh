#!/usr/bin/env bash
# errors-report.sh — cuenta errores y avisos de un log y guarda las líneas de error.
set -euo pipefail

log=datos/app.log
mkdir -p zona

errores=$(grep -c ERROR "$log")
echo "errores: $errores"

# TODO 1: el script se para aquí sin decir nada; averigua por qué y arréglalo (paso 9)
criticos=$(grep -c CRITICAL "$log")
echo "críticos: $criticos"

# TODO 2: imprime "disco: " y cuántas líneas dicen disco, con mayúscula o sin ella (paso 10)
# TODO 3: guarda en zona/errores.txt las líneas de ERROR con su número de línea delante (paso 11)
