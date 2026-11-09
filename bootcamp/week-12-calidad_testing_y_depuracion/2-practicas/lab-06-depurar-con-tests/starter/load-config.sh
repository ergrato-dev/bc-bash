#!/usr/bin/env bash
# load-config.sh — lee un archivo de configuración "clave=valor" y enseña cada clave con su valor.
# Se salta los comentarios (#) y las líneas vacías.
# Roto a propósito: con algunos archivos pierde datos o se para sin decir nada.
set -euo pipefail

file="${1:?uso: load-config.sh <archivo>}"

grep -v -e '^#' -e '^$' "$file" | while read line; do
  key="$(echo "$line" | cut -d= -f1)"
  value="$(echo "$line" | cut -d= -f2)"
  echo "$key -> $value"
done
