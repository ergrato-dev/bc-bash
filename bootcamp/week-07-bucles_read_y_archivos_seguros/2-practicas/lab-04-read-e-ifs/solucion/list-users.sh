#!/usr/bin/env bash
# list-users.sh — lista las personas de un archivo con el formato de /etc/passwd.
# Para qué: en /etc/passwd hay usuarios de sistema (root, daemon, www-data) y de personas;
# las personas tienen un uid de 1000 o más.
set -euo pipefail

file="${1:?uso: list-users.sh <archivo>}"

# IFS=: solo vale para este read: parte la línea por los ":" sin cambiar el IFS del script.
# El último "_" se lleva el resto de la línea (home y shell), que aquí no hace falta.
# || [[ -n $user ]]: si la última línea no acaba en salto de línea, read falla aunque
# la haya leído, y sin esto el bucle terminaría sin procesarla.
while IFS=: read -r user _ uid _ gecos _ || [[ -n $user ]]; do
  if [[ $uid -lt 1000 || $uid -eq 65534 ]]; then
    continue
  fi
  # El campo del nombre puede traer despacho y teléfonos tras comas: "Ana García,,,".
  echo "$user (uid $uid): ${gecos%%,*}"
done < "$file"
