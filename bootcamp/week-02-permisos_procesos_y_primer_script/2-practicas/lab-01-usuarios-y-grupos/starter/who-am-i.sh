#!/usr/bin/env bash
# Muestra con qué usuario y grupos trabajas, y cómo te ve el sistema en /etc/passwd.
# Sin set -euo pipefail todavía: llega en la semana 03.

echo "== nombre de usuario =="
# TODO 1: tu nombre de usuario con id -un

echo "== número de usuario (uid) =="
# El sistema decide los permisos con el número, no con el nombre.
# TODO 2: tu uid con id -u

echo "== grupos =="
# TODO 3: tus grupos con id -Gn

echo "== tu línea en /etc/passwd =="
# TODO 4: tu línea con getent passwd alumno

echo "== la línea de root =="
# TODO 5: la línea de root con getent passwd root
