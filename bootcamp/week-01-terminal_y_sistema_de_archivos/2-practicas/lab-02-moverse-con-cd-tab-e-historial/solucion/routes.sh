#!/usr/bin/env bash
# routes.sh — recorre starter/empresa con cd y lista cada parada.
# El cd de un script cambia la carpeta del script, no la de tu terminal.
# cd ... || exit 1: si cd falla, el script para en vez de listar la carpeta equivocada.

echo "== 1. ventas, con ruta relativa =="
cd starter/empresa/ventas || exit 1
ls

echo "== 2. servidores, subiendo con .. =="
cd ../it/servidores || exit 1
ls

echo "== 3. raíz, con ruta absoluta =="
cd / || exit 1
pwd

echo "== 4. home =="
cd ~ || exit 1
pwd
