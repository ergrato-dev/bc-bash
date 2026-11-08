#!/usr/bin/env bash
# Genera zona/app.conf, la configuración de una aplicación, con los datos de este equipo.
# Sin set -euo pipefail hasta el lab 07: allí verás qué cambia.

ls starter > /dev/null || exit 1
mkdir -p zona

# TODO 1: con cat y un here-doc (<<EOF), escribe en zona/app.conf tres líneas:
#   usuario= y la salida de id -un
#   equipo= y la salida de hostname
#   creado= y la salida de date '+%F'

# TODO 2: con un here-doc entre comillas (<<'EOF'), añade al final de zona/app.conf
# estas dos líneas tal cual, sin que bash sustituya nada:
#   # $HOME lo resuelve la aplicación al arrancar, no este script
#   datos=$HOME/datos

cat zona/app.conf
