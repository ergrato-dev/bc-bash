#!/usr/bin/env bash
# list-users.sh — las personas que pueden entrar en la máquina: usuario, uid, carpeta personal y shell.
# Para qué: revisar quién tiene acceso antes de una auditoría, sin las cuentas de servicio.
set -euo pipefail

passwd="${1:-/etc/passwd}"

# TODO 1: separa los campos por ":" y escribe el usuario, el uid, la carpeta y la shell.
# TODO 2: solo las cuentas con uid entre 1000 y 60000 y una shell que no sea nologin.
# TODO 3: en columnas, con una cabecera.
awk '{ print $1 }' "$passwd"
