#!/usr/bin/env bash
# extract-hint.sh — dice con qué comando se descomprime un archivo, según su extensión.
set -euo pipefail

file="${1:?uso: extract-hint.sh <archivo>}"

# TODO 3: compara en minúsculas, para que FOTOS.ZIP también encaje (paso 9)
case "$file" in
  # TODO 1: app.tar.gz entra en esta rama y no en la suya (paso 7)
  *.gz) echo "gunzip -- '$file'" ;;
  *.tar.gz | *.tgz) echo "tar -xzf '$file'" ;;
  *.tar) echo "tar -xf '$file'" ;;
  # TODO 2: la rama de *.zip (paso 8)
  # TODO 4: la rama *) para lo que no se reconoce: aviso a stderr y código 1 (paso 10)
esac
