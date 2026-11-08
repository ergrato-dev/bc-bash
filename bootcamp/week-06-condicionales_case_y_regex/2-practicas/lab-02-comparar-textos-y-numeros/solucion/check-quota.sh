#!/usr/bin/env bash
# check-quota.sh — avisa si un usuario pasa de su cuota de disco, en MB.
set -euo pipefail

user="${1:?uso: check-quota.sh <usuario> <usado_mb> <limite_mb>}"
used="${2:?uso: check-quota.sh <usuario> <usado_mb> <limite_mb>}"
limit="${3:?uso: check-quota.sh <usuario> <usado_mb> <limite_mb>}"

# [[ ]] no parte las variables: "ana maria" es un solo texto, sin comillas ni errores.
if [[ $user == root ]]; then
  echo "root no tiene cuota"
  exit 0
fi

# -gt compara números. > compararía textos ("900" > "1000"), y dentro de [ ] sería
# una redirección que crea un archivo llamado como el límite.
if [[ $used -gt $limit ]]; then
  echo "AVISO: $user usa $used MB de $limit"
  exit 1
elif [[ $(( used * 100 / limit )) -ge 90 ]]; then
  echo "cerca del límite: $user usa $used MB de $limit"
  exit 0
fi

echo "ok: $user usa $used MB de $limit"
