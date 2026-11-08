#!/usr/bin/env bash
# Muestra con qué usuario y grupos trabajas, y cómo te ve el sistema en /etc/passwd.
# Sin set -euo pipefail todavía: llega en la semana 03.

echo "== nombre de usuario =="
id -un

echo "== número de usuario (uid) =="
# El sistema decide los permisos con el número, no con el nombre.
id -u

echo "== grupos =="
id -Gn

echo "== tu línea en /etc/passwd =="
getent passwd alumno

echo "== la línea de root =="
getent passwd root
