#!/usr/bin/env bash
# stock.sh — el inventario desde la terminal: "stock.sh add tornillos 3" y "stock.sh get tornillos".
# Para qué: apuntar entradas de almacén sin abrir el archivo. Guarda en STOCK_FILE (stock.txt si no dices otro).
set -euo pipefail

# shellcheck source=SCRIPTDIR/lib/stock.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib/stock.sh"

file="${STOCK_FILE:-stock.txt}"
case "${1:-}" in
  add) stock_add "$file" "${2:?uso: stock.sh add <nombre> <cantidad>}" "${3:?uso: stock.sh add <nombre> <cantidad>}" ;;
  get) stock_get "$file" "${2:?uso: stock.sh get <nombre>}" ;;
  *)
    echo "uso: stock.sh <add|get> <nombre> [cantidad]" >&2
    exit 2
    ;;
esac
