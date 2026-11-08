#!/usr/bin/env bash
# need-tool.sh — dice si un programa está disponible y dónde, antes de que otro script lo use.
set -euo pipefail

# TODO 1: si no hay exactamente 1 argumento, "uso: need-tool.sh <programa>" a stderr y código 2 (paso 9)
tool="$1"

# TODO 2: si command -v no lo encuentra, "falta: <programa>" a stderr y código 1 (paso 10)
# TODO 3: elif: si la ruta empieza por /, "ok: <programa> está en <ruta>" (paso 11)
# TODO 4: else: "ok: <programa> es parte de bash" (paso 12)
echo "sin implementar: $tool"
