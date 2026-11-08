#!/usr/bin/env bash
# Cuenta las notas de zona/notas y deja en zona/archivo la fecha de la última copia.
# -e: para en el primer fallo. -u: para si una variable no existe. pipefail: un pipe falla si falla cualquiera de sus partes.
set -euo pipefail

origen=zona/notas
destino=zona/archivo

# Sin pipefail, si find falla, wc cuenta 0 líneas y el script sigue como si no hubiera notas.
total=$(find "$origen" -type f | wc -l)
echo "notas encontradas: $total"

# Sin la carpeta, cd falla; sin -e, la copia se escribiría en la carpeta equivocada.
mkdir -p "$destino"
cd "$destino"
date '+%F' > ultima-copia.txt

echo "copia registrada en $destino/ultima-copia.txt"
