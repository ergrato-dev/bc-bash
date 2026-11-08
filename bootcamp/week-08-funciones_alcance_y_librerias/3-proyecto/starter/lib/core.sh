# shellcheck shell=bash
# core.sh — funciones que comparten todos los comandos de bashkit: avisar, parar y comprobar.
# Para qué: que cada comando avise igual y no repita las mismas tres líneas.
# Se carga con source, no se ejecuta: por eso no lleva shebang ni bit de ejecución.
# Tampoco pone set -euo pipefail: eso lo decide el script que la carga.

# log <mensaje>: escribe "comando: mensaje" en stderr.
log() {
  # TODO(semana 08) 1: printf con el nombre del script (${0##*/}) y "$*", a stderr.
  echo "sin implementar: log" >&2
}

# die <mensaje> [código]: avisa y termina el script con el código (1 si no dices otro).
die() {
  # TODO(semana 08) 2: log con el mensaje y exit con "${2:-1}".
  echo "sin implementar: die" >&2
}

# require <comando>...: para el script si falta alguno de los comandos.
require() {
  # TODO(semana 08) 3: un for con una variable local por "$@"; command -v o die.
  echo "sin implementar: require" >&2
}
