#!/usr/bin/env bash
# scaffold.sh — crea el esqueleto de bashkit/ dentro de la carpeta desde la que lo ejecutas.
# Para qué: rehacer la estructura del kit en otra máquina con un solo comando.
# Sin set -euo pipefail todavía: llega en la semana 03.

# -p: no falla si ya existen, así el script se puede repetir sin romper nada.
mkdir -p bashkit/bin bashkit/lib bashkit/tests bashkit/docs

# git no guarda carpetas vacías: con un .gitkeep dentro, la carpeta llega al repositorio.
# touch sobre un archivo que ya existe solo cambia su fecha, no lo vacía.
touch bashkit/bin/.gitkeep bashkit/lib/.gitkeep bashkit/tests/.gitkeep bashkit/docs/.gitkeep

# > reemplaza el archivo si ya existía. En la semana 06 aprenderás a comprobarlo antes.
echo "# bashkit" > bashkit/README.md

echo "bashkit/ creado"
