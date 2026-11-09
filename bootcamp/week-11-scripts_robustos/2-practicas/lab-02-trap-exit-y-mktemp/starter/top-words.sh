#!/usr/bin/env bash
# top-words.sh — las N palabras que más se repiten en un texto (5 si no dices cuántas).
# Para qué: ver de qué habla un documento largo sin leerlo entero.
set -euo pipefail

text="${1:?uso: top-words.sh <archivo> [N]}"
n="${2:-5}"

# TODO 1: una carpeta de trabajo nueva con mktemp -d, en lugar de una ruta fija.
work=/tmp/top-words
mkdir -p "$work"
# TODO 2: que un trap la borre al salir.

# Una palabra por línea y en minúsculas: "Un" y "un" cuentan como la misma.
grep -oE '[[:alpha:]]+' "$text" | tr '[:upper:]' '[:lower:]' > "$work/words.txt"
sort "$work/words.txt" | uniq -c | sort -rn > "$work/counts.txt"
head -n "$n" "$work/counts.txt"
