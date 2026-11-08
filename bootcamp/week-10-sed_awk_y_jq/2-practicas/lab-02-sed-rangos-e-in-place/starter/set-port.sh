#!/usr/bin/env bash
# set-port.sh — cambia el port= de una sección de un archivo .conf sin tocar el de las otras.
# Para qué: cambiar un puerto desde un script de despliegue, sin abrir el editor.
set -euo pipefail

[[ $# -eq 3 ]] || { echo "uso: set-port.sh <archivo> <sección> <puerto>" >&2; exit 2; }
file="$1"
section="$2"
port="$3"

# Lo que entra en el programa de sed no puede llevar / ni &: solo letras en la sección y dígitos en el puerto.
[[ $section =~ ^[a-z]+$ ]] || { echo "set-port.sh: '$section' no es un nombre de sección" >&2; exit 2; }
[[ $port =~ ^[0-9]+$ ]] || { echo "set-port.sh: '$port' no es un puerto" >&2; exit 2; }

# TODO 3: si el archivo no tiene la línea [sección], avisa y sale con 1.

# TODO 1: cambia solo el port= de la sección que te piden.
# TODO 2: guarda el archivo de antes en archivo.bak.
sed -i "s/^port=.*/port=$port/" "$file"
