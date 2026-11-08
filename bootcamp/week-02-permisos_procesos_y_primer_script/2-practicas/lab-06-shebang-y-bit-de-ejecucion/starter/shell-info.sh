# TODO 1: sustituye esta línea por el shebang #!/usr/bin/env bash
# Muestra qué programa interpreta este script y desde dónde lo ejecutas.
# Sin set -euo pipefail todavía: llega en la semana 03.

# /proc/PID/exe apunta al programa que ejecuta ese proceso; $$ es el PID de este script.
echo "intérprete: $(readlink /proc/$$/exe)"
echo "versión de bash: $BASH_VERSION"
# $0 es la ruta con la que llamaste al script, tal como la escribiste.
echo "script: $0"
# PWD es la carpeta desde la que lo lanzas, no la carpeta donde está el script.
# TODO 2: una línea "directorio: ..." con la variable PWD
