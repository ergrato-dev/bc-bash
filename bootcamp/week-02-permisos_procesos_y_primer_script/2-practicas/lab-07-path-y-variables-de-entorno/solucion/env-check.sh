#!/usr/bin/env bash
# Muestra qué variables recibe un script desde la shell que lo lanza.
# Sin set -euo pipefail todavía: llega en la semana 03.

echo "HOME: $HOME"
echo "PATH: $PATH"
# Solo llega si la shell que te lanza la exportó, o si la pones delante del comando.
echo "BK_ENTORNO: $BK_ENTORNO"

# Un hijo no puede cambiar las variables de su padre: al terminar, esta desaparece.
ultimo_script="env-check.sh"
echo "ultimo_script dentro del script: $ultimo_script"
