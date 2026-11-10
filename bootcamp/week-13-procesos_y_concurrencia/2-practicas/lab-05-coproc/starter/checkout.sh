#!/usr/bin/env bash
# checkout.sh — suma un pedido línea a línea con los precios de la tarifa y para en cuanto
# se pasa del presupuesto. Para qué: no seguir buscando precios de un pedido que ya no cabe.
set -euo pipefail

order="${1:?uso: checkout.sh <pedido> <tarifa> <presupuesto en céntimos>}"
prices="${2:?uso: checkout.sh <pedido> <tarifa> <presupuesto en céntimos>}"
budget="${3:?uso: checkout.sh <pedido> <tarifa> <presupuesto en céntimos>}"

# TODO 1: un solo awk que cargue la tarifa una vez y conteste a cada código (coproc).

total=0
count=0
while read -r code quantity; do
  # TODO 1: pregúntale el precio al coproc en lugar de lanzar un grep por línea.
  price="$(grep -m 1 "^$code " "$prices" | cut -d ' ' -f 2)"
  if [[ -z $price ]]; then
    echo "checkout.sh: '$code' no está en la tarifa" >&2
    exit 1
  fi
  total=$((total + price * quantity))
  count=$((count + 1))
  if ((total > budget)); then
    echo "checkout.sh: presupuesto superado en la línea $count: $total > $budget" >&2
    exit 1
  fi
done < "$order"

# TODO 2: cierra la entrada del coproc y espera a que termine.
echo "total: $total céntimos en $count líneas"
