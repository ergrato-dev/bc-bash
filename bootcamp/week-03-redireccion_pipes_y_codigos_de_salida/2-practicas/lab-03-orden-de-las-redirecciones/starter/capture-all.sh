#!/usr/bin/env bash
# Ejecuta noisy.sh y guarda todo lo que dice, salida y errores, en zona/todo.log.
# Sin set -euo pipefail hasta el lab 07: allí verás qué cambia.

ls starter > /dev/null || exit 1
mkdir -p zona

# Error a propósito: los errores siguen saliendo por pantalla y no llegan al log.
# TODO 1: cambia el orden de las dos redirecciones
bash starter/noisy.sh 2>&1 > zona/todo.log

# TODO 2: ejecuta noisy.sh otra vez y añade su salida y sus errores al final de zona/todo.log
