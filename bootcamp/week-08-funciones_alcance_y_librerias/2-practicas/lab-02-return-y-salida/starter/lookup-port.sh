#!/usr/bin/env bash
# lookup-port.sh — busca el puerto de un servicio en una lista "nombre puerto".
# Para qué: no tener que recordar en qué puerto escucha cada cosa.
set -euo pipefail

services="${SERVICES:-datos/servicios.txt}"

# is_port <texto>: sale con 0 si es un puerto válido (1 a 65535). No imprime nada.
is_port() {
  # TODO 3: return 1 si $1 no encaja con ^[1-9][0-9]*$; si encaja, (($1 <= 65535)).
  return 0
}

# port_of <servicio>: imprime su puerto, o sale con 1 si no está en la lista.
port_of() {
  # TODO 1: while read -r name port por "$services"; si name es $1, echo del puerto y return 0. Al final, return 1.
  echo "80"
}

main() {
  local service="${1:?uso: lookup-port.sh <servicio>}"
  local port
  # TODO 2: if ! port=$(port_of "$service"), aviso a stderr y exit 1; si ! is_port "$port", lo mismo.
  port=$(port_of "$service")
  echo "$service: $port"
}

main "$@"
