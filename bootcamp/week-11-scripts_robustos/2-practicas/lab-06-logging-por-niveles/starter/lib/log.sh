# shellcheck shell=bash
# log.sh — avisos con nivel: debug, info, warn y error, en stderr y con la hora delante.
# Para qué: que un script cuente mucho cuando lo depuras y solo lo importante en un cron.
# Se carga con source. LOG_LEVEL dice desde qué nivel se escribe (info si no dices otro).

# TODO 1: level_number <nivel>: 0, 1, 2 o 3; código 1 si el nivel no existe.
# TODO 2: log_at <nivel> <mensaje>: no escribe nada si el nivel no llega a LOG_LEVEL.
# TODO 3: la hora delante del aviso: 2026-11-09T08:00:00 WARN mensaje.
# TODO 4: con LOG_FILE, además, una copia del aviso al final de ese archivo.
log_at() {
  local level="$1"
  shift
  echo "$level $*" >&2
}

log_debug() { log_at debug "$@"; }
log_info() { log_at info "$@"; }
log_warn() { log_at warn "$@"; }
log_error() { log_at error "$@"; }
