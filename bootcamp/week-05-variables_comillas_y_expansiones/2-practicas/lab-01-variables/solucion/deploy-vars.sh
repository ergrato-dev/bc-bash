#!/usr/bin/env bash
# deploy-vars.sh — los datos de un despliegue, guardados en variables.
set -euo pipefail

# export la pasa a los programas que lance este script; las otras se quedan aquí.
export app=tienda
version=1.4.2
# Sin espacios alrededor del =: con ellos, bash buscaría un comando llamado entorno.
entorno=produccion

echo "app: $app $version"
echo "entorno: $entorno"
# Las llaves marcan dónde acaba el nombre: sin ellas, bash buscaría la variable app_.
echo "log: ${app}_$entorno.log"

printenv app || echo "printenv no ve app"
