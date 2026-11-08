#!/usr/bin/env bash
# build-office.sh — crea, copia, renombra y mueve dentro de zona/oficina.
# Lab 04, semana 01. Ejecútalo desde la carpeta del lab: bash starter/build-office.sh

# Protección: si no estás en la carpeta del lab, starter/ no existe y el script
# sale sin tocar nada (el || exit 1 lo viste en el lab 02).
ls starter > /dev/null || exit 1

# Empieza de cero en cada ejecución: zona/ es tu área de pruebas y git la ignora.
rm -rf zona
mkdir zona

# TODO 1: crea zona/oficina/docs y zona/oficina/archivo con un solo mkdir (necesitas -p).

# TODO 2: crea el archivo vacío zona/oficina/docs/acta.txt.

# TODO 3: copia starter/plantilla.txt a zona/oficina/docs/informe.txt.

# TODO 4: copia la carpeta zona/oficina/docs entera a zona/oficina/docs-copia.

# TODO 5: renombra zona/oficina/docs-copia/acta.txt a acta-2025.txt.

# TODO 6: mueve la carpeta zona/oficina/docs-copia dentro de zona/oficina/archivo.

ls -R zona
