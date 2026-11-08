#!/usr/bin/env bash
# validate-user.sh — comprueba si un texto sirve como nombre de usuario Linux.
# Reglas: de 3 a 16 caracteres; empieza por una minúscula; después, minúsculas,
# cifras, _ o -; y no es un nombre reservado (root, admin).
set -euo pipefail

name="${1-}"

# TODO 1 (paso 4)
if [ -z $name ]; then
  echo "uso: validate-user.sh <nombre>" >&2
  exit 2
fi

# TODO 2 (paso 5)
if [ ${#name} -lt 3 -o ${#name} > 16 ]; then
  echo "no: '$name' tiene que tener de 3 a 16 caracteres" >&2
  exit 1
fi

# TODO 3 (paso 6)
if [[ ! $name =~ "^[a-z][a-z0-9_-]*$" ]]; then
  echo "no: '$name' solo puede tener minúsculas, cifras, _ y -, y empezar por letra" >&2
  exit 1
fi

# TODO 4 (paso 7)
case "$name" in
  *) echo "ok: $name" ;;
  root | admin)
    echo "no: '$name' está reservado" >&2
    exit 1
    ;;
esac
