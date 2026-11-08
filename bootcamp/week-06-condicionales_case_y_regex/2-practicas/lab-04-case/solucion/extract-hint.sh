#!/usr/bin/env bash
# extract-hint.sh — dice con qué comando se descomprime un archivo, según su extensión.
set -euo pipefail

file="${1:?uso: extract-hint.sh <archivo>}"

# En minúsculas solo para comparar: el comando que se imprime lleva el nombre original.
case "${file,,}" in
  # case se queda con la primera rama que encaja: *.tar.gz tiene que ir antes que
  # *.gz, que también encaja con app.tar.gz.
  *.tar.gz | *.tgz) echo "tar -xzf '$file'" ;;
  *.tar) echo "tar -xf '$file'" ;;
  *.gz) echo "gunzip -- '$file'" ;;
  *.zip) echo "unzip '$file'" ;;
  *)
    echo "extract-hint.sh: no sé descomprimir '$file'" >&2
    exit 1
    ;;
esac
