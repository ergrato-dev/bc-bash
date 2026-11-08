#!/usr/bin/env bash
# Crea, en la carpeta actual, los datos con los que el autograding prueba bk-clean.
# Las fechas no viajan con git: por eso los archivos se crean aquí y no van en el repositorio.
set -euo pipefail

old="10 days ago"
new="1 day ago"

mkdir -p basura/sub otra
touch -d "$old" basura/viejo.log "basura/con espacios.log" basura/-empieza-por-guion.log \
  basura/sub/dentro.tmp "basura/*" "basura/linea"$'\n'"nueva.log" otra/viejo.txt fuera.txt
touch -d "$new" basura/nuevo.log otra/nuevo.txt
# Un enlace viejo a un archivo viejo de fuera: bk-clean no debe tocar ninguno de los dos.
ln -sfn ../fuera.txt basura/enlace
touch -h -d "$old" basura/enlace
