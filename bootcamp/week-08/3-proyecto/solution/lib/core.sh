#!/bin/bash
# ============================================
# Core Library - Funciones básicas
# SOLUCIÓN COMPLETA
# ============================================

# Colores
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# ============================================
# Logging
# ============================================

log_info() {
    local timestamp
    timestamp=$(date "+%H:%M:%S")
    echo -e "${GREEN}[$timestamp][INFO]${NC} $*"
}

log_warn() {
    local timestamp
    timestamp=$(date "+%H:%M:%S")
    echo -e "${YELLOW}[$timestamp][WARN]${NC} $*" >&2
}

log_error() {
    local timestamp
    timestamp=$(date "+%H:%M:%S")
    echo -e "${RED}[$timestamp][ERROR]${NC} $*" >&2
}

log_debug() {
    if [[ "${DEBUG:-false}" == "true" ]]; then
        local timestamp
        timestamp=$(date "+%H:%M:%S")
        echo -e "${BLUE}[$timestamp][DEBUG]${NC} $*" >&2
    fi
}

# ============================================
# Utilidades
# ============================================

die() {
    log_error "$@"
    exit 1
}

require_command() {
    local cmd="$1"
    if ! command -v "$cmd" &>/dev/null; then
        die "Comando requerido no encontrado: $cmd"
    fi
}

require_var() {
    local var_name="$1"
    local var_value="${!var_name:-}"
    
    if [[ -z "$var_value" ]]; then
        die "Variable requerida no definida: $var_name"
    fi
}

confirm() {
    local message="${1:-¿Continuar?}"
    local default="${2:-n}"
    
    local prompt
    if [[ "$default" == "y" ]]; then
        prompt="[Y/n]"
    else
        prompt="[y/N]"
    fi
    
    read -rp "$message $prompt " response
    response="${response:-$default}"
    
    [[ "$response" =~ ^[Yy]$ ]]
}

# ============================================
# String utilities
# ============================================

trim() {
    local var="$*"
    var="${var#"${var%%[![:space:]]*}"}"
    var="${var%"${var##*[![:space:]]}"}"
    echo "$var"
}

to_upper() {
    echo "${1^^}"
}

to_lower() {
    echo "${1,,}"
}

# ============================================
# File utilities
# ============================================

file_exists() {
    [[ -f "$1" ]]
}

dir_exists() {
    [[ -d "$1" ]]
}

ensure_dir() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        log_debug "Created directory: $dir"
    fi
}
