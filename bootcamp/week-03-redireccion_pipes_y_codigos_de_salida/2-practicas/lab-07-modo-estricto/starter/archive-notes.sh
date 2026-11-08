#!/usr/bin/env bash
# Cuenta las notas de zona/notas y deja en zona/archivo la fecha de la última copia.
# Tiene tres errores a propósito. Sin modo estricto, ninguno lo para.

# TODO 1: activa el modo estricto

origen=zona/notas
destino=zona/archivo

total=$(find "$origen" -type f | wc -l)
echo "notas encontradas: $total"

# TODO 2: crea $destino antes de entrar
cd "$destino"
date '+%F' > ultima-copia.txt

# TODO 3: arregla el nombre de la variable
echo "copia registrada en $destno/ultima-copia.txt"
