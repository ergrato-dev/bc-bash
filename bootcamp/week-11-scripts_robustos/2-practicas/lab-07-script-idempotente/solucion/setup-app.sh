#!/usr/bin/env bash
# setup-app.sh — prepara la carpeta de una app: sus carpetas, su configuración y el enlace a la versión actual.
# Para qué: dejar una máquina lista con un comando. Se lanza en cada deploy, así que tiene
# que poder ejecutarse muchas veces y dejar siempre lo mismo.
set -euo pipefail

app="${1:?uso: setup-app.sh <carpeta> [versión]}"
version="${2:-v1}"

# -p: crea lo que falta y no falla con lo que ya existe.
mkdir -p "$app/config" "$app/logs" "$app/releases/$version"

# add_line <línea> <archivo>: añade la línea solo si no está ya. Con >> a secas, cada
# ejecución la repetiría. -q: sin salida; -x: la línea entera; -F: tal cual, sin regex.
add_line() {
  grep -qxF -- "$1" "$2" 2> /dev/null || echo "$1" >> "$2"
}
add_line "port=8080" "$app/config/app.conf"
add_line "log_dir=$app/logs" "$app/config/app.conf"

# -f reemplaza el enlace si ya existe; -n lo trata como enlace y no entra en la carpeta a la
# que apunta (sin -n, el enlace nuevo acabaría dentro de releases/v1).
ln -sfn "releases/$version" "$app/current"

echo "app lista en $app (versión $version)"
