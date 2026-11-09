#!/usr/bin/env bash
# setup-app.sh — prepara la carpeta de una app: sus carpetas, su configuración y el enlace a la versión actual.
# Para qué: dejar una máquina lista con un comando. Se lanza en cada deploy, así que tiene
# que poder ejecutarse muchas veces y dejar siempre lo mismo.
set -euo pipefail

app="${1:?uso: setup-app.sh <carpeta> [versión]}"
version="${2:-v1}"

mkdir -p "$app/config" "$app/logs" "$app/releases/$version"

add_line() {
  grep -qxF -- "$1" "$2" 2> /dev/null || echo "$1" >> "$2"
}
add_line "port=8080" "$app/config/app.conf"
add_line "log_dir=$app/logs" "$app/config/app.conf"

ln -s "releases/$version" "$app/current"

echo "app lista en $app (versión $version)"
