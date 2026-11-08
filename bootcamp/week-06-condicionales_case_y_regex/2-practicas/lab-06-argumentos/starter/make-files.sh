#!/usr/bin/env bash
# make-files.sh — crea archivos vacíos; con -v, dice cuáles ha creado.
set -euo pipefail

verbose=""
# TODO 1: si el primer argumento es -v, verbose=1 y quítalo con shift (paso 9)
# TODO 2: si no queda ningún argumento, "uso: make-files.sh [-v] <archivo>..." a stderr y código 2 (paso 10)

# TODO 3: con un nombre que tiene espacios, esta línea crea dos archivos (paso 8)
touch $*
# TODO 4: con verbose, "creado: <archivo>" por cada argumento, con printf (paso 11)
