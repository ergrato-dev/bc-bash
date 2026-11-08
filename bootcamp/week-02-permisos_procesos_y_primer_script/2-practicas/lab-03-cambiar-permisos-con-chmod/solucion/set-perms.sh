#!/usr/bin/env bash
# Deja cada archivo de zona/ con el permiso que pide su uso y muestra el resultado.
# Sin set -euo pipefail todavía: llega en la semana 03.

# Si no estás en la carpeta del lab, sal antes de borrar nada.
ls starter > /dev/null || exit 1
rm -rf zona
mkdir zona

# Todo nace con 644 (archivos) o 755 (carpetas): lo decide la umask 022.
touch zona/deploy.sh zona/notas.txt zona/compartido.txt
mkdir zona/privada

# Un script que todos pueden ejecutar.
chmod +x zona/deploy.sh

# Notas que solo tú puedes leer y cambiar.
chmod 600 zona/notas.txt

# Un archivo que tu grupo también puede editar.
chmod g+w zona/compartido.txt

# Una carpeta en la que nadie más puede entrar ni mirar.
chmod go-rx zona/privada

stat -c '%A %a %n' zona/*
