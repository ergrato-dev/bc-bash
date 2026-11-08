#!/usr/bin/env bash
# make-snapshot.sh — empaqueta datos/web en zona/ con la fecha en el nombre y lo resume.
set -euo pipefail

mkdir -p zona
# TODO 1: la fecha de hoy, con date +%F (paso 9)
fecha=hoy
archivo="zona/snapshot-$fecha.tar.gz"
tar -czf "$archivo" datos/web
echo "creado: $archivo"
# TODO 2: imprime "archivos: N", los archivos que guarda el .tar.gz (paso 10)
# TODO 3: imprime "tamaño: N KiB", con du -k (paso 11)

# TODO 4: la lista sale en una sola línea: que salga un servidor por línea (paso 12)
servidores=$(cat datos/servidores.txt)
echo "copiar a:"
echo $servidores
