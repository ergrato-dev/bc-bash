#!/usr/bin/env bash
# split-targets.sh — separa cada "host:puerto" de una lista en host y puerto (22 si no lo dice).
# Para qué: preparar la lista de máquinas a las que conectarse por ssh o comprobar un puerto.
set -euo pipefail

# split_target <"host:puerto"> <var-host> <var-puerto>: guarda las dos partes en las
# variables que le digas.
split_target() {
  # TODO 1: local -n out_host=$2 out_port=$3; out_host con ${1%%:*} y out_port con ${1##*:}.
  # TODO 2: out_port 22, y ${1##*:} solo si $1 lleva ":".
  :
}

host="" port=""
while IFS= read -r target; do
  split_target "$target" host port
  echo "host=$host puerto=$port"
done < "${1:?uso: split-targets.sh <archivo>}"
