#!/usr/bin/env bash
# Prepara en zona/ archivos con permisos distintos y los muestra de tres formas.
# Sin set -euo pipefail todavía: llega en la semana 03.

# Si no estás en la carpeta del lab, sal antes de borrar nada.
ls starter > /dev/null || exit 1
rm -rf zona
mkdir zona

# Preparación: chmod se explica en el lab 03. Aquí solo lees el resultado.
touch zona/informe.txt zona/secreto.txt zona/deploy.sh
mkdir zona/publica zona/privada
chmod 644 zona/informe.txt
chmod 600 zona/secreto.txt
chmod 755 zona/deploy.sh zona/publica
chmod 700 zona/privada

echo "== ls -l =="
ls -l zona

echo "== la carpeta zona, no su contenido =="
# -d: sin él, ls -l de una carpeta lista lo que hay dentro.
ls -ld zona

echo "== permisos en octal =="
stat -c '%a %n' zona/*

echo "== dueño y grupo =="
stat -c '%U %G %n' zona/*
