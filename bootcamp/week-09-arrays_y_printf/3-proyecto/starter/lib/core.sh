# shellcheck shell=bash
# core.sh — funciones que comparten todos los comandos de bashkit: avisar, parar y comprobar.
# Para qué: que cada comando avise igual y no repita las mismas tres líneas.
# Se carga con source, no se ejecuta: por eso no lleva shebang ni bit de ejecución.
# Tampoco pone set -euo pipefail: eso lo decide el script que la carga.

# log <mensaje>: escribe "comando: mensaje" en stderr.
# ${0##*/} es el nombre del script que cargó la librería, sin la ruta: el aviso dice
# de qué comando viene. stderr, para no mezclarse con la salida que alguien captura.
log() {
  printf '%s: %s\n' "${0##*/}" "$*" >&2
}

# die <mensaje> [código]: avisa y termina el script con el código (1 si no dices otro).
# exit y no return: desde una función, exit para el script entero.
die() {
  log "$1"
  exit "${2:-1}"
}

# require <comando>...: para el script si falta alguno de los comandos.
# Mejor fallar al principio con un aviso claro que a mitad de trabajo con "command not found".
require() {
  local cmd
  for cmd in "$@"; do
    command -v "$cmd" > /dev/null || die "falta el comando '$cmd'"
  done
}
