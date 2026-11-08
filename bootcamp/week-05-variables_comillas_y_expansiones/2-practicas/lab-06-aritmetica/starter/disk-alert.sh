#!/usr/bin/env bash
# disk-alert.sh — cuánto ocupa un disco y cuántos días faltan para que se llene.
set -euo pipefail

usado_mb=4300
total_mb=5000
crecimiento_mb=35
comprobaciones=0

# TODO 1: sale 0%: cambia el orden de las operaciones (paso 8)
porcentaje=$(( usado_mb / total_mb * 100 ))
echo "uso: ${porcentaje}%"
# TODO 2: esta línea para el script: cámbiala por una suma (paso 9)
((comprobaciones++))

libre_mb=$(( total_mb - usado_mb ))
echo "libre: $libre_mb MB"
# TODO 3: imprime "se llena en N días" a crecimiento_mb por día, y suma otra comprobación (paso 10)

hora=08
# TODO 4: esta cuenta falla con la hora 08: arréglala (paso 11)
echo "próxima comprobación: a las $(( hora + 1 ))"
echo "comprobaciones: $comprobaciones"
