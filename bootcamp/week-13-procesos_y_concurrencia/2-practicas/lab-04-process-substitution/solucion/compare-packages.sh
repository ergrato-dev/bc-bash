#!/usr/bin/env bash
# compare-packages.sh — compara los paquetes de dos servidores: qué le falta a cada uno y
# cuáles tienen otra versión. Para qué: ver por qué dos máquinas "iguales" no se comportan igual.
set -euo pipefail

a="${1:?uso: compare-packages.sh <lista-a> <lista-b>}"
b="${2:?uso: compare-packages.sh <lista-a> <lista-b>}"

# names <lista>: los nombres de los paquetes, ordenados: comm necesita las dos entradas en orden.
names() { cut -d ' ' -f 1 "$1" | sort; }

# <(comando) es un archivo de mentira (/dev/fd/63) que se lee como la salida del comando:
# comm recibe dos "archivos" sin que haya que crearlos, ni acordarse de borrarlos.
echo "solo en $a:"
comm -23 <(names "$a") <(names "$b")
echo "solo en $b:"
comm -13 <(names "$a") <(names "$b")

# join junta las líneas de los dos archivos que empiezan por el mismo nombre: "git 2.43.0 2.45.1".
# < <(join ...) y no join | while: detrás de un pipe, el while va en un subshell y lo que
# cuenta en changed se pierde al salir del bucle.
changed=0
echo "con otra versión:"
while read -r name version_a version_b; do
  if [[ $version_a != "$version_b" ]]; then
    echo "  $name: de $version_a a $version_b"
    changed=$((changed + 1))
  fi
done < <(join <(sort "$a") <(sort "$b"))
echo "total con otra versión: $changed"
