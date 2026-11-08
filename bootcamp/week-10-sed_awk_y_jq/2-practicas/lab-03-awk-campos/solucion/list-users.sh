#!/usr/bin/env bash
# list-users.sh — las personas que pueden entrar en la máquina: usuario, uid, carpeta personal y shell.
# Para qué: revisar quién tiene acceso antes de una auditoría, sin las cuentas de servicio.
set -euo pipefail

passwd="${1:-/etc/passwd}"

# /etc/passwd separa sus 7 campos con ":"; el 5.º (el nombre completo) puede llevar espacios.
# Las cuentas de personas empiezan en el uid 1000; 65534 es nobody, que no es nadie.
# $NF es el último campo, la shell: con nologin, la cuenta no puede abrir una sesión.
awk -F: '
  BEGIN { printf "%-10s %6s  %-14s %s\n", "USUARIO", "UID", "CARPETA", "SHELL" }
  $3 >= 1000 && $3 < 60000 && $NF !~ /nologin$/ { printf "%-10s %6d  %-14s %s\n", $1, $3, $6, $NF }
' "$passwd"
