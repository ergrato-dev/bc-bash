#!/usr/bin/env bash
# check-quota.sh — avisa si un usuario pasa de su cuota de disco, en MB.
set -euo pipefail

user="${1:?uso: check-quota.sh <usuario> <usado_mb> <limite_mb>}"
used="${2:?uso: check-quota.sh <usuario> <usado_mb> <limite_mb>}"
limit="${3:?uso: check-quota.sh <usuario> <usado_mb> <limite_mb>}"

# TODO 1: esta condición falla con un usuario que tiene un espacio (paso 9)
if [ $user == "root" ]; then
  echo "root no tiene cuota"
  exit 0
fi

# TODO 2: esta condición siempre se cumple, y además crea un archivo (paso 10)
if [ $used > $limit ]; then
  echo "AVISO: $user usa $used MB de $limit"
  exit 1
fi
# TODO 3: elif: a partir del 90% de la cuota, "cerca del límite: ..." (paso 11)

echo "ok: $user usa $used MB de $limit"
