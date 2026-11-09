# shellcheck shell=bash
# log.sh — avisos con nivel: debug, info, warn y error, en stderr y con la hora delante.
# Para qué: que un script cuente mucho cuando lo depuras y solo lo importante en un cron.
# Se carga con source. LOG_LEVEL dice desde qué nivel se escribe (info si no dices otro).

# level_number <nivel>: el orden del nivel. Con números, "¿llega a LOG_LEVEL?" es un >=.
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
  local level="$1" min line
  shift
  # Un LOG_LEVEL mal escrito se avisa: callarlo escondería justo los avisos que pediste.
  if ! min="$(level_number "${LOG_LEVEL:-info}")"; then
    echo "log.sh: LOG_LEVEL='$LOG_LEVEL' no es debug, info, warn ni error" >&2
    return 2
  fi
  # return 0: un aviso que no toca escribir no es un error, y con set -e un 1 pararía el script.
  (($(level_number "$level") >= min)) || return 0
  # La hora en ISO 8601 y el nivel en mayúsculas (${level^^}): se leen y se filtran con grep.
  line="$(date +%FT%T) ${level^^} $*"
  echo "$line" >&2
  # El archivo, además de stderr: el cron no tiene pantalla, y el aviso queda para mañana.
  if [[ -n ${LOG_FILE:-} ]]; then
    echo "$line" >> "$LOG_FILE"
  fi
}

log_debug() { log_at debug "$@"; }
log_info() { log_at info "$@"; }
log_warn() { log_at warn "$@"; }
log_error() { log_at error "$@"; }
