#!/usr/bin/env bash
# build-office.sh — crea, copia, renombra y mueve dentro de zona/oficina.

# Protección: si no estás en la carpeta del lab, starter/ no existe y el script
# sale sin tocar nada (el || exit 1 lo viste en el lab 02).
ls starter > /dev/null || exit 1

# Empieza de cero en cada ejecución: zona/ es tu área de pruebas y git la ignora.
rm -rf zona
mkdir zona

# Sin -p, mkdir fallaría porque zona/oficina todavía no existe.
mkdir -p zona/oficina/docs zona/oficina/archivo
touch zona/oficina/docs/acta.txt
cp starter/plantilla.txt zona/oficina/docs/informe.txt
cp -r zona/oficina/docs zona/oficina/docs-copia
mv zona/oficina/docs-copia/acta.txt zona/oficina/docs-copia/acta-2025.txt
# El destino es una carpeta que existe: docs-copia entra dentro, no la reemplaza.
mv zona/oficina/docs-copia zona/oficina/archivo

ls -R zona
