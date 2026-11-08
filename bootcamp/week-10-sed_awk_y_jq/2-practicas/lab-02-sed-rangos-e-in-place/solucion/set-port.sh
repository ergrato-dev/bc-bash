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

# Sin la sección, sed no cambiaría nada y saldría con 0: el despliegue creería que funcionó.
grep -qx "\[$section\]" "$file" || { echo "set-port.sh: no hay sección [$section] en $file" >&2; exit 1; }

# El rango va de la línea [sección] a la siguiente que empieza por [: la s/// solo se aplica ahí.
# -i.bak cambia el archivo y deja el de antes en archivo.bak, por si hay que volver atrás.
sed -i.bak "/^\[$section\]/,/^\[/ s/^port=.*/port=$port/" "$file"
