# shellcheck shell=bash
# strings.sh — funciones para limpiar textos. Se carga con source; no ejecuta nada al cargarse.

# to_lower <texto>: el texto en minúsculas.
to_lower() {
  # TODO 1: ${1,,} es $1 en minúsculas.
  echo "sin implementar: to_lower" >&2
}

# to_slug <texto>: minúsculas y guiones en lugar de espacios, para usarlo en un nombre
# de archivo o en una URL.
to_slug() {
  local text
  text=$(to_lower "$1")
  echo "${text// /-}"
}
