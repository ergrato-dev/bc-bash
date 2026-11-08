#!/usr/bin/env bash
# prepare.sh — crea zona/ con archivos de prueba para practicar el borrado.
# Lab 05, semana 01. Completo: no tiene TODOs. Ejecútalo desde la carpeta del lab.

# Protección: si no estás en la carpeta del lab, starter/ no existe y el script
# sale sin tocar nada (el || exit 1 lo viste en el lab 02).
ls starter > /dev/null || exit 1

# Empieza de cero en cada ejecución: zona/ es tu área de pruebas y git la ignora.
rm -rf zona
mkdir zona

touch zona/informe-final.txt zona/informe-borrador.txt
touch "zona/copia de seguridad.txt"
mkdir zona/vacia zona/fotos-viejas
touch zona/fotos-viejas/playa.jpg zona/fotos-viejas/monte.jpg
