#!/usr/bin/env bash
# cleanup.sh — deja en zona/ solo informe-final.txt, borrando lo demás uno a uno.
# Lab 05, semana 01. Ejecútalo desde la carpeta del lab: bash starter/cleanup.sh

# Rehace zona/ desde cero, así puedes repetir el script las veces que quieras.
bash starter/prepare.sh || exit 1

# TODO 1: borra el archivo zona/informe-borrador.txt.

# TODO 2: borra la carpeta vacía zona/vacia con el comando que solo borra carpetas vacías.

# TODO 3: borra zona/fotos-viejas con todo lo que tiene, mostrando cada borrado (-v).

# TODO 4: borra "zona/copia de seguridad.txt" (el nombre tiene espacios).

ls zona
