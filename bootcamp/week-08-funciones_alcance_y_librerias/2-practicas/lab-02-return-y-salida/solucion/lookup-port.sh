#!/usr/bin/env bash
# lookup-port.sh — busca el puerto de un servicio en una lista "nombre puerto".
# Para qué: no tener que recordar en qué puerto escucha cada cosa.
set -euo pipefail

services="${SERVICES:-datos/servicios.txt}"

# is_port <texto>: sale con 0 si es un puerto válido (1 a 65535). No imprime nada:
# la respuesta es su código, para usarla directamente en un if.
is_port() {
  [[ $1 =~ ^[1-9][0-9]*$ ]] || return 1
  (($1 <= 65535))
}

# port_of <servicio>: imprime su puerto, o sale con 1 si no está en la lista.
# El dato va por stdout, para recogerlo con $( ); el "no lo encontré", por el código.
port_of() {
  local name port
  while read -r name port; do
    if [[ $name == "$1" ]]; then
      echo "$port"
      return 0
    fi
  done < "$services"
  return 1
}

main() {
  local service="${1:?uso: lookup-port.sh <servicio>}"
  local port
  if ! port=$(port_of "$service"); then
    echo "lookup-port.sh: '$service' no está en $services" >&2
    exit 1
  fi
  if ! is_port "$port"; then
    echo "lookup-port.sh: '$port' no es un puerto válido" >&2
    exit 1
  fi
  echo "$service: $port"
}

main "$@"
