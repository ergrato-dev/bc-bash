#!/usr/bin/env bash
# top-cities.sh — de dónde vienen las visitas de la web y cuánto tardan las respuestas.
set -euo pipefail

visitas=datos/visitas.txt
tiempos=datos/tiempos.txt

echo "== las 3 ciudades con más visitas =="
# uniq -c solo junta repetidas seguidas: sin el sort, cada racha de Madrid contaría aparte.
sort "$visitas" | uniq -c | sort -rn | head -3

echo "== las 3 respuestas más lentas (ms) =="
# -n compara como número: como texto, 95 iría delante de 2210.
sort -rn "$tiempos" | head -3

# sort -u deja una línea por ciudad: contarlas es contar ciudades.
echo "ciudades distintas: $(sort -u "$visitas" | wc -l)"
