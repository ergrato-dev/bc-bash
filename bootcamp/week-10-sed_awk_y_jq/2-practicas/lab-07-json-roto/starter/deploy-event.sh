#!/usr/bin/env bash
# deploy-event.sh — escribe en una línea de JSON el evento de un despliegue: servicio, duración, mensaje y hosts.
# Para qué: mandarlo a un webhook o añadirlo a un log que después se lee con jq.
set -euo pipefail

[[ $# -eq 4 ]] || { echo "uso: deploy-event.sh <servicio> <segundos> <mensaje> <hosts.txt>" >&2; exit 2; }
service="$1"
seconds="$2"
message="$3"
hosts_file="$4"
# TODO 4

hosts=$(tr '\n' ',' < "$hosts_file") # TODO 1
printf '{"servicio":"%s","segundos":"%s","mensaje":"%s","hosts":[%s]}\n' "$service" "$seconds" "$message" "$hosts" # TODO 2 y TODO 3
