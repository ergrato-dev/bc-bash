#!/usr/bin/env bash
# old-logs.sh — los logs de zona/app con más de 7 días, los que ya se pueden archivar,
# y los archivos grandes que ocupan sitio.
set -euo pipefail

echo "== logs de más de 7 días =="
# TODO 1: este find falla según desde dónde lo ejecutes; arréglalo y ordena la lista (paso 9)
find zona/app -name *.log -mtime +7

# TODO 2: imprime "total: " y cuántos logs de más de 7 días hay (paso 10)

echo "== archivos de más de 1 MiB =="
# TODO 3: los archivos de zona/app de más de 1 MiB, con su tamaño legible (paso 11)
