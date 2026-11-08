#!/usr/bin/env bash
# path-kind.sh — dice qué hay en una ruta: nada, un enlace roto, una carpeta o qué tipo de archivo.
set -euo pipefail

p="${1:?uso: path-kind.sh <ruta>}"

# TODO 1: si p es un enlace (-L) y su destino no existe (! -e), "enlace roto" (paso 8)
# TODO 2: elif: si no existe, "no existe" en stderr y código 1 (paso 9)
# TODO 3: elif: si es un directorio, "directorio" (paso 10)
# TODO 4: elif: si está vacío (! -s), "archivo vacío" (paso 11)
# TODO 5: elif: si se puede ejecutar, "ejecutable"; else: "archivo" (paso 12)
echo "$p: sin implementar"
