#!/usr/bin/env bash
# top-cities.sh — de dónde vienen las visitas de la web y cuánto tardan las respuestas.
set -euo pipefail

visitas=datos/visitas.txt
tiempos=datos/tiempos.txt

echo "== las 3 ciudades con más visitas =="
# TODO 1: este recuento sale mal; compáralo con el del paso 5 y arréglalo (paso 7)
uniq -c "$visitas" | sort -rn | head -3

echo "== las 3 respuestas más lentas (ms) =="
# TODO 2: los 3 números más altos de "$tiempos", de mayor a menor (paso 8)

# TODO 3: imprime "ciudades distintas: " y cuántas hay en "$visitas" (paso 9)
