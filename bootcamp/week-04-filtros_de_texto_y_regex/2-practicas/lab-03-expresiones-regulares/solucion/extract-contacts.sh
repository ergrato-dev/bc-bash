#!/usr/bin/env bash
# extract-contacts.sh — revisa una lista de contactos: quién es de ejemplo.com,
# qué correos tienen buena forma y qué teléfonos están completos.
set -euo pipefail

datos=datos/contactos.txt
mkdir -p zona

# \. es un punto de verdad (un . suelto encaja con "-" o "s") y el ; de detrás
# obliga a que el dominio termine ahí. -i: los dominios no distinguen mayúsculas.
echo "de ejemplo.com: $(grep -ci '@ejemplo\.com;' "$datos")"

# Entre ; y ;: algo antes de una sola @, un nombre de dominio, un punto y 2 letras o más.
grep -iE ';[a-z0-9._]+@[a-z0-9-]+\.[a-z]{2,};' "$datos" > zona/correos-validos.txt
# El $ ancla al final: 9 cifras en grupos de 3, con espacios o sin ellos y un +34 opcional.
grep -oE '(\+34 )?[0-9]{3} ?[0-9]{3} ?[0-9]{3}$' "$datos" > zona/telefonos.txt
