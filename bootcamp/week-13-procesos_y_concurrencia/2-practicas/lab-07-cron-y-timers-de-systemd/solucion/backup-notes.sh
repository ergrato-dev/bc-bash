#!/usr/bin/env bash
# backup-notes.sh — guarda una copia comprimida de notas/ en copias/, con la fecha en el nombre.
# Para qué: que cron o un timer de systemd lo ejecuten solo, cada día, sin nadie delante.
set -euo pipefail

# cron empieza en tu home, no en la carpeta del script: con rutas relativas, tar buscaría
# notas/ en el home. La carpeta del lab sale de dónde está el script (BASH_SOURCE, semana 08).
base="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
backups="$base/copias"

mkdir -p "$backups"
file="$backups/notas-$(date +%Y%m%d-%H%M%S).tar.gz"
# -C: tar entra en la carpeta del lab antes de guardar notas, y la copia no lleva la ruta entera.
tar -czf "$file" -C "$base" notas
echo "backup-notes.sh: copia en $file"
