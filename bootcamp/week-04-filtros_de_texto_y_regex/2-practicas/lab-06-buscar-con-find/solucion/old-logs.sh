#!/usr/bin/env bash
# old-logs.sh — los logs de zona/app con más de 7 días, los que ya se pueden archivar,
# y los archivos grandes que ocupan sitio.
set -euo pipefail

echo "== logs de más de 7 días =="
# Sin comillas, si en la carpeta actual hay algún .log, bash cambia *.log por esos nombres
# antes de que find lo vea. sort: find devuelve los archivos en el orden del disco.
find zona/app -name '*.log' -mtime +7 | sort

echo "total: $(find zona/app -name '*.log' -mtime +7 | wc -l)"

echo "== archivos de más de 1 MiB =="
# -type f: una carpeta también tiene tamaño. -h en ls: 2.0M en vez de 2097152.
find zona/app -type f -size +1M -exec ls -lh {} +
