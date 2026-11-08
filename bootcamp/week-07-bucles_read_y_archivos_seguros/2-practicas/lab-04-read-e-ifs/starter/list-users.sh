#!/usr/bin/env bash
# list-users.sh — lista las personas de un archivo con el formato de /etc/passwd.
# Para qué: en /etc/passwd hay usuarios de sistema (root, daemon, www-data) y de personas;
# las personas tienen un uid de 1000 o más.
set -euo pipefail

file="${1:?uso: list-users.sh <archivo>}"

# TODO 1: lee "$file" línea a línea, separando por ":" con IFS (paso 6)
# TODO 2: salta con continue los uid menores de 1000 y el 65534 (nobody) (paso 7)
# TODO 3: imprime "usuario (uid N): nombre", el nombre sin lo que va tras la primera coma (paso 8)
# TODO 4: que no se pierda la última línea si no termina en salto de línea (paso 9)
echo "sin implementar: $file"
