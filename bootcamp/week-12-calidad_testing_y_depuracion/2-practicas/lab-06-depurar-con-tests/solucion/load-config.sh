#!/usr/bin/env bash
# load-config.sh — lee un archivo de configuración "clave=valor" y enseña cada clave con su valor.
# Se salta los comentarios (#) y las líneas vacías.
# Para qué: comprobar qué valores va a usar una app antes de arrancarla.
set -euo pipefail

# Si algo falla, di dónde: set -e para el script sin explicar nada, y esta línea dice cuál
# y con qué comando. Comillas simples: $LINENO y $BASH_COMMAND se leen al fallar, no ahora.
trap 'echo "load-config.sh: falló la línea $LINENO: $BASH_COMMAND" >&2' ERR

file="${1:?uso: load-config.sh <archivo>}"
[[ -r $file ]] || { echo "load-config.sh: no puedo leer '$file'" >&2; exit 1; }

# grep sale con 1 si no queda ninguna línea (un archivo con solo comentarios), y con pipefail
# pararía el script. Un archivo sin claves no es un error: || true lo convierte en "nada".
{ grep -v -e '^#' -e '^$' "$file" || true; } | while IFS= read -r line; do
  # Un archivo escrito en Windows acaba cada línea en \r\n: el \r se quedaría en el valor.
  line="${line%$'\r'}"
  # Hasta el primer = es la clave; todo lo demás, el valor, aunque lleve más =.
  key="${line%%=*}"
  value="${line#*=}"
  echo "$key -> $value"
done
