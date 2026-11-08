#!/usr/bin/env bash
# status-report.sh — informe rápido de un access log: cuántas peticiones, con qué
# códigos de estado, qué rutas no existen y a qué horas hay más tráfico.
set -euo pipefail

log=datos/access.log

echo "peticiones: $(wc -l < "$log")"

# En el formato de nginx y Apache, separando por espacios, el campo 9 es el código de estado.
echo "== códigos de estado =="
cut -d' ' -f9 "$log" | sort | uniq -c | sort -rn

# '" 404 ' y no '404' a secas: así no cuentan las peticiones que pesan 404 bytes
# o una ruta que contenga 404. Las comillas cierran la petición justo antes del código.
echo "== rutas que dan 404 =="
grep '" 404 ' "$log" | cut -d' ' -f7 | sort | uniq -c | sort -rn

# El campo 4 es [07/Nov/2026:08:11:28; separando por :, la hora es el campo 2.
# sort -n y no sort -rn: aquí el orden que importa es el de las horas.
echo "== peticiones por hora =="
cut -d' ' -f4 "$log" | cut -d: -f2 | sort -n | uniq -c
