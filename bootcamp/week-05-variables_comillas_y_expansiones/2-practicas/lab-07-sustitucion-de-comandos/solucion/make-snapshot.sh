#!/usr/bin/env bash
# make-snapshot.sh — empaqueta datos/web en zona/ con la fecha en el nombre y lo resume.
set -euo pipefail

mkdir -p zona
# Con la fecha en el nombre, la copia de mañana no pisa la de hoy.
fecha=$(date +%F)
archivo="zona/snapshot-$fecha.tar.gz"
tar -czf "$archivo" datos/web
echo "creado: $archivo"
# tar -t lista también las carpetas, que acaban en /: grep -v las deja fuera.
echo "archivos: $(tar -tzf "$archivo" | grep -vc '/$')"
# du -k escribe "tamaño<TAB>nombre": cut se queda con el primer campo.
echo "tamaño: $(du -k "$archivo" | cut -f1) KiB"

servidores=$(cat datos/servidores.txt)
echo "copiar a:"
# Con comillas se conservan los saltos de línea; sin ellas, el word splitting los convierte en espacios.
echo "$servidores"
