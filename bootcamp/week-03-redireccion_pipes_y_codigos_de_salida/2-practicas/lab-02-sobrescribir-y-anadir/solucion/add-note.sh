#!/usr/bin/env bash
# Añade una nota con la fecha y la hora a zona/notas.txt y dice cuántas hay.
# Sin set -euo pipefail hasta el lab 07: allí verás qué cambia.

ls starter > /dev/null || exit 1
mkdir -p zona

# >> añade al final. Con > cada ejecución vaciaba el archivo y solo quedaba la última nota.
echo "$(date '+%F %T') revisión hecha" >> zona/notas.txt

# Con < wc lee de stdin y no sabe cómo se llama el archivo: imprime solo el número.
wc -l < zona/notas.txt
