#!/usr/bin/env bash
# Añade una nota con la fecha y la hora a zona/notas.txt y dice cuántas hay.
# Sin set -euo pipefail hasta el lab 07: allí verás qué cambia.

ls starter > /dev/null || exit 1
mkdir -p zona

# Error a propósito: cada ejecución debería sumar una línea, pero solo queda la última.
# TODO 1: arregla la redirección para que la nota se añada al final
echo "$(date '+%F %T') revisión hecha" > zona/notas.txt

# TODO 2: imprime solo el número de notas, sin el nombre del archivo
wc -l zona/notas.txt
