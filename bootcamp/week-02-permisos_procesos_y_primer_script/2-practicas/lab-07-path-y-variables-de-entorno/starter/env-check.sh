#!/usr/bin/env bash
# Muestra qué variables recibe un script desde la shell que lo lanza.
# Sin set -euo pipefail todavía: llega en la semana 03.

echo "HOME: $HOME"
# TODO 1: una línea "PATH: ..." con la variable PATH
# Solo llega si la shell que te lanza la exportó, o si la pones delante del comando.
# TODO 2: una línea "BK_ENTORNO: ..." con la variable BK_ENTORNO

# Un hijo no puede cambiar las variables de su padre: al terminar, esta desaparece.
# TODO 3: guarda env-check.sh en la variable ultimo_script
echo "ultimo_script dentro del script: $ultimo_script"
