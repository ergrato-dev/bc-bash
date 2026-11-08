#!/usr/bin/env bash
# extract-contacts.sh — revisa una lista de contactos: quién es de ejemplo.com,
# qué correos tienen buena forma y qué teléfonos están completos.
set -euo pipefail

datos=datos/contactos.txt
mkdir -p zona

# TODO 1: este recuento da 5 y deberían ser 4; arregla la regex (pasos 7 y 8)
echo "de ejemplo.com: $(grep -c '@ejemplo.com' "$datos")"

# TODO 2: guarda en zona/correos-validos.txt las líneas con un correo de buena forma (paso 9)
# TODO 3: guarda en zona/telefonos.txt solo los teléfonos completos, uno por línea (paso 10)
