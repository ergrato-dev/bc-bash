#!/usr/bin/env bash
# errors-report.sh — cuenta errores y avisos de un log y guarda las líneas de error.
set -euo pipefail

log=datos/app.log
mkdir -p zona

errores=$(grep -c ERROR "$log")
echo "errores: $errores"

# grep sale con 1 si no encuentra nada, y con set -e eso para el script en silencio.
# Cero críticos es una respuesta válida: || true evita la parada; grep -c ya imprimió el 0.
criticos=$(grep -c CRITICAL "$log" || true)
echo "críticos: $criticos"

# -i: el log escribe "Disco" y "disco"; sin -i se perdería un aviso.
echo "disco: $(grep -ci disco "$log")"
# -n deja el número de línea: con él puedes ir directo a esa línea del log original.
grep -n ERROR "$log" > zona/errores.txt
