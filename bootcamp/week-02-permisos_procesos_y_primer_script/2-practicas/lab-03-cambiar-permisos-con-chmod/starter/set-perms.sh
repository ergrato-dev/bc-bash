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
# TODO 1: chmod +x sobre zona/deploy.sh

# Notas que solo tú puedes leer y cambiar.
# TODO 2: chmod en octal: 600 sobre zona/notas.txt

# Un archivo que tu grupo también puede editar.
# TODO 3: chmod simbólico: escritura para el grupo en zona/compartido.txt

# Una carpeta en la que nadie más puede entrar ni mirar.
# TODO 4: chmod simbólico: quita lectura y entrada al grupo y a los demás en zona/privada

stat -c '%A %a %n' zona/*
