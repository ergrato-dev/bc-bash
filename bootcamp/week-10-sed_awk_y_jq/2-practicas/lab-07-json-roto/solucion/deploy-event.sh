#!/usr/bin/env bash
# deploy-event.sh — escribe en una línea de JSON el evento de un despliegue: servicio, duración, mensaje y hosts.
# Para qué: mandarlo a un webhook o añadirlo a un log que después se lee con jq.
set -euo pipefail

[[ $# -eq 4 ]] || { echo "uso: deploy-event.sh <servicio> <segundos> <mensaje> <hosts.txt>" >&2; exit 2; }
service="$1"
seconds="$2"
message="$3"
hosts_file="$4"
# --argjson exige JSON válido: con "12s", jq pararía con un error que no dice qué argumento era.
[[ $seconds =~ ^[0-9]+$ ]] || { echo "deploy-event.sh: '$seconds' no es un número de segundos" >&2; exit 2; }

# -R: cada línea es un texto; -n con inputs, todas en un array, sin la coma de más del final; -c, en una línea.
hosts=$(jq -ncR '[inputs]' < "$hosts_file")
# --arg mete un texto y jq lo escapa (comillas, barras, saltos de línea); --argjson mete un número o un array.
# -c: el objeto en una sola línea, como espera un log de una línea por evento.
jq -nc --arg service "$service" --argjson seconds "$seconds" --arg message "$message" --argjson hosts "$hosts" \
  '{servicio: $service, segundos: $seconds, mensaje: $message, hosts: $hosts}'
