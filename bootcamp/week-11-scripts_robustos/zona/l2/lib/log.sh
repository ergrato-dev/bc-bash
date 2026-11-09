# shellcheck shell=bash
# log.sh — avisos con nivel: debug, info, warn y error, en stderr y con la hora delante.
# Para qué: que un script cuente mucho cuando lo depuras y solo lo importante en un cron.
# Se carga con source. LOG_LEVEL dice desde qué nivel se escribe (info si no dices otro).

# TODO 3: la hora delante del aviso: 2026-11-09T08:00:00 WARN mensaje.
# TODO 4: con LOG_FILE, además, una copia del aviso al final de ese archivo.
level_number() {
  case "$1" in
    debug) echo 0 ;;
    info) echo 1 ;;
    warn) echo 2 ;;
    error) echo 3 ;;
    *) return 1 ;;
  esac
}

log_at() {
  local level="$1" min
  shift
  if ! min="$(level_number "${LOG_LEVEL:-info}")"; then
    echo "log.sh: LOG_LEVEL='$LOG_LEVEL' no es debug, info, warn ni error" >&2
    return 2
  fi
  (($(level_number "$level") >= min)) || return 0
  echo "$level $*" >&2
}

log_debug() { log_at debug "$@"; }
log_info() { log_at info "$@"; }
log_warn() { log_at warn "$@"; }
log_error() { log_at error "$@"; }
