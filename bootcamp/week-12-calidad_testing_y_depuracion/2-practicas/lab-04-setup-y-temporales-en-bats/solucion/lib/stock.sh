# shellcheck shell=bash
# stock.sh — funciones para llevar un inventario en un archivo de texto, una línea "nombre cantidad".
# Se carga con source: no lleva shebang ni set -euo pipefail.

# stock_get <archivo> <nombre>: escribe la cantidad del producto, o 0 si no está.
stock_get() {
  [[ -f $1 ]] || { echo 0; return 0; }
  awk -v name="$2" '$1 == name { qty = $2 } END { print qty + 0 }' "$1"
}

# stock_add <archivo> <nombre> <cantidad>: suma la cantidad al producto (lo crea si no está).
# Reescribe el archivo entero en un temporal y lo cambia de una vez con mv: si algo falla
# a mitad, el inventario de antes sigue entero.
stock_add() {
  local file="$1" name="$2" qty="$3" current
  if [[ ! $qty =~ ^[1-9][0-9]*$ ]]; then
    echo "stock_add: '$qty' no es una cantidad" >&2
    return 2
  fi
  current="$(stock_get "$file" "$name")"
  {
    [[ ! -f $file ]] || awk -v name="$name" '$1 != name' "$file"
    echo "$name $((current + qty))"
  } > "$file.tmp" || return 1
  mv -- "$file.tmp" "$file"
}
