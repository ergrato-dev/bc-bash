#!/usr/bin/env bash
# Comprueba que el equipo tiene lo necesario para desplegar. Cada fallo sale con su propio código.
# Sin set -euo pipefail hasta el lab 07: allí verás qué cambia.

# command -v sale con 0 si encuentra el programa y con 1 si no. La ruta que imprime no interesa.
command -v git > /dev/null || { echo "falta git" >&2; exit 3; }

# Un código por fallo: quien lance el script sabe qué falta sin leer el mensaje.
command -v docker > /dev/null || { echo "falta docker" >&2; exit 4; }

test -w /tmp || { echo "no se puede escribir en /tmp" >&2; exit 5; }

echo "todo listo"
exit 0
