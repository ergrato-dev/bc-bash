#!/usr/bin/env bash
# disk-alert.sh — cuánto ocupa un disco y cuántos días faltan para que se llene.
set -euo pipefail

usado_mb=4300
total_mb=5000
crecimiento_mb=35
comprobaciones=0

# bash solo divide enteros: primero multiplicar y después dividir, o 4300 / 5000 da 0.
porcentaje=$(( usado_mb * 100 / total_mb ))
echo "uso: ${porcentaje}%"
# ((comprobaciones++)) vale 0 la primera vez, y (( 0 )) sale con 1: set -e pararía aquí.
comprobaciones=$(( comprobaciones + 1 ))

libre_mb=$(( total_mb - usado_mb ))
echo "libre: $libre_mb MB"
echo "se llena en $(( libre_mb / crecimiento_mb )) días"
comprobaciones=$(( comprobaciones + 1 ))

hora=08
# Un número que empieza por 0 es octal para bash, y 08 no existe en octal: 10# lo fuerza a decimal.
echo "próxima comprobación: a las $(( 10#$hora + 1 ))"
echo "comprobaciones: $comprobaciones"
