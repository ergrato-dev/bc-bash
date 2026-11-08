#!/usr/bin/env bash
# Ejecuta noisy.sh y guarda todo lo que dice, salida y errores, en zona/todo.log.
# Sin set -euo pipefail hasta el lab 07: allí verás qué cambia.

ls starter > /dev/null || exit 1
mkdir -p zona

# Primero stdout al archivo y después stderr adonde apunte stdout: al archivo.
# Al revés, stderr copiaría stdout cuando aún era la pantalla.
bash starter/noisy.sh > zona/todo.log 2>&1

# >> con 2>&1: la segunda ejecución se suma a la primera.
bash starter/noisy.sh >> zona/todo.log 2>&1
