#!/usr/bin/env bash
# need-tool.sh — dice si un programa está disponible y dónde, antes de que otro script lo use.
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "uso: need-tool.sh <programa>" >&2
  exit 2
fi
tool="$1"

# if mira el código de salida de la asignación, que es el de $( ): command -v sale
# con 1 si no encuentra el programa. Dentro del if, set -e no para el script.
if ! path=$(command -v -- "$tool"); then
  echo "falta: $tool" >&2
  exit 1
elif [[ $path == /* ]]; then
  echo "ok: $tool está en $path"
else
  # Sin / delante, command -v devuelve el nombre tal cual: es una orden interna de bash.
  echo "ok: $tool es parte de bash"
fi
