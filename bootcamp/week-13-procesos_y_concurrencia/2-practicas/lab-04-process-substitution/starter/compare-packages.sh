#!/usr/bin/env bash
# compare-packages.sh — compara los paquetes de dos servidores: qué le falta a cada uno y
# cuáles tienen otra versión. Para qué: ver por qué dos máquinas "iguales" no se comportan igual.
set -euo pipefail

a="${1:?uso: compare-packages.sh <lista-a> <lista-b>}"
b="${2:?uso: compare-packages.sh <lista-a> <lista-b>}"

# names <lista>: los nombres de los paquetes, ordenados: comm necesita las dos entradas en orden.
names() { cut -d ' ' -f 1 "$1" | sort; }

# TODO 1: sin archivos temporales: dale a comm las dos listas con <( ).
names_a="$(mktemp)"
names_b="$(mktemp)"
names "$a" > "$names_a"
names "$b" > "$names_b"
echo "solo en $a:"
comm -23 "$names_a" "$names_b"
echo "solo en $b:"
comm -13 "$names_a" "$names_b"

# join junta las líneas de los dos archivos que empiezan por el mismo nombre: "git 2.43.0 2.45.1".
# TODO 2: que changed cuente de verdad: el while no puede ir detrás de un pipe.
changed=0
echo "con otra versión:"
join <(sort "$a") <(sort "$b") | while read -r name version_a version_b; do
  if [[ $version_a != "$version_b" ]]; then
    echo "  $name: de $version_a a $version_b"
    changed=$((changed + 1))
  fi
done
echo "total con otra versión: $changed"
