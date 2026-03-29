#!/bin/bash
# ============================================
# Debug Library - Funciones de debugging
# ============================================

# Niveles de log
readonly LOG_DEBUG=0
readonly LOG_INFO=1
readonly LOG_WARN=2
readonly LOG_ERROR=3

# Nivel actual (configurable con DEBUG_LEVEL)
LOG_LEVEL="${DEBUG_LEVEL:-$LOG_INFO}"

# Colores
readonly _RED='\033[0;31m'
readonly _GREEN='\033[0;32m'
readonly _YELLOW='\033[0;33m'
readonly _BLUE='\033[0;34m'
readonly _NC='\033[0m'

# ============================================
# Función: debug
# Log condicional nivel DEBUG
# ============================================
debug() {
    [[ $LOG_LEVEL -le $LOG_DEBUG ]] && \
        echo -e "${_BLUE}[DEBUG]${_NC} $*" >&2
}

# ============================================
# Función: info
# Log nivel INFO
# ============================================
info() {
    [[ $LOG_LEVEL -le $LOG_INFO ]] && \
        echo -e "${_GREEN}[INFO]${_NC} $*" >&2
}

# ============================================
# Función: warn
# Log nivel WARNING
# ============================================
warn() {
    [[ $LOG_LEVEL -le $LOG_WARN ]] && \
        echo -e "${_YELLOW}[WARN]${_NC} $*" >&2
}

# ============================================
# Función: error
# Log nivel ERROR
# ============================================
error() {
    echo -e "${_RED}[ERROR]${_NC} $*" >&2
}

# ============================================
# Función: die
# Error fatal con exit
# ============================================
die() {
    error "$@"
    exit 1
}

# ============================================
# Función: trace_start
# Iniciar trace de ejecución
# ============================================
trace_start() {
    export PS4='+${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
    set -x
}

# ============================================
# Función: trace_stop
# Detener trace de ejecución
# ============================================
trace_stop() {
    set +x
}

# ============================================
# Función: assert
# Verificar condición
# ============================================
assert() {
    local message="$1"
    shift
    if ! "$@"; then
        die "Assertion failed: $message"
    fi
}
