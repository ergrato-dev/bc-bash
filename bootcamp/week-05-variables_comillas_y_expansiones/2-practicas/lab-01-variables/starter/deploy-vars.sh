#!/usr/bin/env bash
# deploy-vars.sh — los datos de un despliegue, guardados en variables.
set -euo pipefail

app=tienda
version=1.4.2
# TODO 1: esta línea no guarda nada en entorno: arréglala (paso 8)
entorno = produccion

echo "app: $app $version"
echo "entorno: $entorno"
# TODO 2: el nombre del log no sale "tienda_produccion.log": arréglalo (paso 9)
echo "log: $app_$entorno.log"

# TODO 3: haz que printenv, que es otro programa, vea app (paso 10)
printenv app || echo "printenv no ve app"
