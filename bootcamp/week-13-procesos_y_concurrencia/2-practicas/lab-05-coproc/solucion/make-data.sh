#!/usr/bin/env bash
# make-data.sh <carpeta>: crea la tarifa (50 000 productos con su precio en céntimos) y un
# pedido de 1000 líneas. Siempre los mismos números: tus resultados y los del lab coinciden.
set -euo pipefail

dir="${1:?uso: make-data.sh <carpeta>}"
mkdir -p "$dir"
awk 'BEGIN { for (i = 1; i <= 50000; i++) printf "P%05d %d\n", i, 100 + (i * 37) % 9900 }' > "$dir/precios.txt"
awk 'BEGIN { for (i = 1; i <= 1000; i++) { p = (i * 7919) % 50000 + 1; printf "P%05d %d\n", p, 1 + p % 3 } }' > "$dir/pedido.txt"
