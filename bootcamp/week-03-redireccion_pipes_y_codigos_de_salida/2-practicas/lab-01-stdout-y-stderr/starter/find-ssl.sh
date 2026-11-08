#!/usr/bin/env bash
# Hace inventario de los archivos de /etc/ssl en zona/: la lista por un lado, los avisos por otro.
# Sin set -euo pipefail hasta el lab 07: allí verás qué cambia.

# Si no estás en la carpeta del lab, sal antes de crear nada.
ls starter > /dev/null || exit 1
mkdir -p zona

# find escribe la lista por stdout y avisa por stderr de cada carpeta que no puede leer.
# TODO 1: la lista a zona/ssl.txt y los avisos a /dev/null
find /etc/ssl -type f

# Los avisos dicen qué carpetas se quedaron sin revisar: también conviene guardarlos.
# TODO 2: los avisos a zona/avisos.txt y la lista a /dev/null
find /etc/ssl -type f

# Un mensaje para quien ejecuta el script, no un resultado: va por stderr.
# TODO 3: escribe "listo: zona/ssl.txt" en stderr
