#!/usr/bin/env bash
# status-report.sh — informe rápido de un access log: cuántas peticiones, con qué
# códigos de estado, qué rutas no existen y a qué horas hay más tráfico.
set -euo pipefail

log=datos/access.log

# TODO 1: imprime "peticiones: " y el número de líneas de "$log" (paso 9)

echo "== códigos de estado =="
# TODO 2: cuántas peticiones hay de cada código de estado, de más a menos (paso 10)

echo "== rutas que dan 404 =="
# TODO 3: las rutas de las peticiones con código 404, con su recuento, de más a menos (paso 11)

echo "== peticiones por hora =="
# TODO 4: cuántas peticiones hay en cada hora, en orden de hora (paso 12)
