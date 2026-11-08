#!/usr/bin/env bash
# Comprueba que el equipo tiene lo necesario para desplegar. Cada fallo sale con su propio código.
# Sin set -euo pipefail hasta el lab 07: allí verás qué cambia.

# command -v sale con 0 si encuentra el programa y con 1 si no. La ruta que imprime no interesa.
command -v git > /dev/null || { echo "falta git" >&2; exit 3; }

# TODO 1: lo mismo para docker, con el mensaje "falta docker" y el código 4

# TODO 2: test -w /tmp sale con 0 si puedes escribir en /tmp. Si no, "no se puede escribir en /tmp" y el código 5

# TODO 3: si ha llegado hasta aquí, escribe "todo listo" por stdout y sal con el código 0
