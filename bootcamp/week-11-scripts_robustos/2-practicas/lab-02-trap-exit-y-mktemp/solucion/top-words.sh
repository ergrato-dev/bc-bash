#!/usr/bin/env bash
# top-words.sh — las N palabras que más se repiten en un texto (5 si no dices cuántas).
# Para qué: ver de qué habla un documento largo sin leerlo entero.
set -euo pipefail

text="${1:?uso: top-words.sh <archivo> [N]}"
n="${2:-5}"

# Una carpeta nueva en cada ejecución: con una ruta fija, dos ejecuciones a la vez
# se pisarían los archivos, y otro usuario que la creara antes nos dejaría sin poder escribir.
work="$(mktemp -d)"
# Justo después de crearla, antes de nada que pueda fallar: EXIT corre al salir por
# cualquier camino, también cuando set -e para el script a mitad.
trap 'rm -rf -- "$work"' EXIT

# Una palabra por línea y en minúsculas: "Un" y "un" cuentan como la misma.
grep -oE '[[:alpha:]]+' "$text" | tr '[:upper:]' '[:lower:]' > "$work/words.txt"
sort "$work/words.txt" | uniq -c | sort -rn > "$work/counts.txt"
head -n "$n" "$work/counts.txt"
