#!/usr/bin/env bash
# validate-user.sh — comprueba si un texto sirve como nombre de usuario Linux.
# Reglas: de 3 a 16 caracteres; empieza por una minúscula; después, minúsculas,
# cifras, _ o -; y no es un nombre reservado (root, admin).
set -euo pipefail

name="${1-}"

# [[ ]] no parte la variable: con "ana maria" no hay "too many arguments".
if [[ -z $name ]]; then
  echo "uso: validate-user.sh <nombre>" >&2
  exit 2
fi

# -gt compara números; > dentro de [ ] es una redirección. || une dos condiciones
# dentro de [[ ]]; el -o de [ ] está obsoleto.
if [[ ${#name} -lt 3 || ${#name} -gt 16 ]]; then
  echo "no: '$name' tiene que tener de 3 a 16 caracteres" >&2
  exit 1
fi

# La regex, sin comillas: con ellas =~ busca el texto literal "^[a-z]..." y no encaja nunca.
re='^[a-z][a-z0-9_-]*$'
if [[ ! $name =~ $re ]]; then
  echo "no: '$name' solo puede tener minúsculas, cifras, _ y -, y empezar por letra" >&2
  exit 1
fi

# case se queda con la primera rama que encaja: *) va siempre la última.
case "$name" in
  root | admin)
    echo "no: '$name' está reservado" >&2
    exit 1
    ;;
  *) echo "ok: $name" ;;
esac
