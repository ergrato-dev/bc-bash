#!/usr/bin/env bash
# Genera zona/app.conf, la configuración de una aplicación, con los datos de este equipo.
# Sin set -euo pipefail hasta el lab 07: allí verás qué cambia.

ls starter > /dev/null || exit 1
mkdir -p zona

# Sin comillas en EOF, bash sustituye $( ) dentro del texto antes de pasárselo a cat.
cat > zona/app.conf <<EOF
usuario=$(id -un)
equipo=$(hostname)
creado=$(date '+%F')
EOF

# Con 'EOF' entre comillas el texto llega literal: $HOME debe quedar escrito para la aplicación.
cat >> zona/app.conf <<'EOF'
# $HOME lo resuelve la aplicación al arrancar, no este script
datos=$HOME/datos
EOF

cat zona/app.conf
