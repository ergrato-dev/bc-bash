#!/usr/bin/env bash
# split-targets.sh — separa cada "host:puerto" de una lista en host y puerto (22 si no lo dice).
# Para qué: preparar la lista de máquinas a las que conectarse por ssh o comprobar un puerto.
set -euo pipefail

# split_target <"host:puerto"> <var-host> <var-puerto>: guarda las dos partes en las
# variables que le digas. Con $( ) solo se puede devolver un texto; con declare -n,
# tantas variables como haga falta, sin subshell.
# out_host y out_port escriben en las variables de fuera, y shellcheck no lo ve.
# shellcheck disable=SC2034
split_target() {
  local -n out_host=$2 out_port=$3
  # Sin ":", ${1%%:*} no quita nada: el host es el texto entero.
  out_host=${1%%:*}
  out_port=22
  if [[ $1 == *:* ]]; then
    out_port=${1##*:}
  fi
}

host="" port=""
while IFS= read -r target; do
  split_target "$target" host port
  echo "host=$host puerto=$port"
done < "${1:?uso: split-targets.sh <archivo>}"
