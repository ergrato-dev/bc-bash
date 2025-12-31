#!/bin/bash
# ============================================
# Core Library - Funciones básicas
# ============================================

# Colores
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# ============================================
# Logging
# ============================================

log_info() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*" >&2
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

log_debug() {
    [[ "${DEBUG:-false}" == "true" ]] && \
        echo -e "${BLUE}[DEBUG]${NC} $*" >&2
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
    command -v "$cmd" &>/dev/null || \
        die "Comando requerido no encontrado: $cmd"
}

confirm() {
    local message="${1:-¿Continuar?}"
    read -rp "$message [y/N] " response
    [[ "$response" =~ ^[Yy]$ ]]
}
