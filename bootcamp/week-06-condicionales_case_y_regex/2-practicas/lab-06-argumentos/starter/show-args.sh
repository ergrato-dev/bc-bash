#!/usr/bin/env bash
# show-args.sh — enseña cómo llegan los argumentos a un script: cuántos y cada uno entre [ ].
set -euo pipefail

echo "script: $0"
echo "argumentos: $#"
# printf repite el formato por cada argumento: una línea por cada uno, sin bucle.
printf 'arg: [%s]\n' "$@"
