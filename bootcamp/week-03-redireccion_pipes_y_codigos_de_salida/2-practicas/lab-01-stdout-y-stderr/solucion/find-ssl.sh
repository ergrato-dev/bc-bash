#!/usr/bin/env bash
# Hace inventario de los archivos de /etc/ssl en zona/: la lista por un lado, los avisos por otro.
# Sin set -euo pipefail hasta el lab 07: allí verás qué cambia.

# Si no estás en la carpeta del lab, sal antes de crear nada.
ls starter > /dev/null || exit 1
mkdir -p zona

# find escribe la lista por stdout y avisa por stderr de cada carpeta que no puede leer.
find /etc/ssl -type f > zona/ssl.txt 2> /dev/null

# Los avisos dicen qué carpetas se quedaron sin revisar: también conviene guardarlos.
find /etc/ssl -type f > /dev/null 2> zona/avisos.txt

# Un mensaje para quien ejecuta el script, no un resultado: va por stderr.
echo "listo: zona/ssl.txt" >&2
