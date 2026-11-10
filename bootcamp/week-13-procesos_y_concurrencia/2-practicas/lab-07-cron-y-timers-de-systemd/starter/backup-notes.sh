#!/usr/bin/env bash
# backup-notes.sh — guarda una copia comprimida de notas/ en copias/, con la fecha en el nombre.
# Para qué: que cron o un timer de systemd lo ejecuten solo, cada día, sin nadie delante.
set -euo pipefail

# TODO 1: que funcione desde cualquier carpeta: notas/ y copias/ están en la carpeta del lab,
# una por encima de este script.
notes="notas"
backups="copias"

mkdir -p "$backups"
file="$backups/notas-$(date +%Y%m%d-%H%M%S).tar.gz"
tar -czf "$file" "$notes"
echo "backup-notes.sh: copia en $file"
