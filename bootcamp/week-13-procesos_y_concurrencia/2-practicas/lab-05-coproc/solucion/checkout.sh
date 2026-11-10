#!/usr/bin/env bash
# checkout.sh — suma un pedido línea a línea con los precios de la tarifa y para en cuanto
# se pasa del presupuesto. Para qué: no seguir buscando precios de un pedido que ya no cabe.
set -euo pipefail

order="${1:?uso: checkout.sh <pedido> <tarifa> <presupuesto en céntimos>}"
prices="${2:?uso: checkout.sh <pedido> <tarifa> <presupuesto en céntimos>}"
budget="${3:?uso: checkout.sh <pedido> <tarifa> <presupuesto en céntimos>}"

# Un solo awk para todo el pedido: lee la tarifa una vez (NR == FNR: el primer archivo) y
# después contesta a cada código que le llega por stdin (-) con su precio, o con ? si no está.
# fflush(): awk escribe a un pipe y guardaría las respuestas en su búfer; sin él, el read de
# abajo esperaría para siempre una respuesta que no llega.
coproc PRICES {
  awk 'NR == FNR { price[$1] = $2; next } { print (($1 in price) ? price[$1] : "?"); fflush() }' "$prices" -
}

total=0
count=0
while read -r code quantity; do
  # Pregunta y respuesta: una línea al coproc por PRICES[1], una de vuelta por PRICES[0].
  echo "$code" >&"${PRICES[1]}"
  read -r price <&"${PRICES[0]}"
  if [[ $price == "?" ]]; then
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

# Cerrar su entrada es decirle a awk que no hay más preguntas: termina, y wait lo recoge.
# exec {var}>&- cierra el descriptor cuyo número guarda var. Con {PRICES[1]} también
# funciona, pero shellcheck no lo entiende: por eso se copia antes a una variable.
to_prices="${PRICES[1]}"
exec {to_prices}>&-
wait "$PRICES_PID"
echo "total: $total céntimos en $count líneas"
