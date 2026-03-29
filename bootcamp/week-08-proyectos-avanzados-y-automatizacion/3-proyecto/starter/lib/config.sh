#!/bin/bash
# ============================================
# Config Library - Gestión de configuración
# ============================================

declare -A CONFIG

config_set() {
    local key="$1"
    local value="$2"
    CONFIG["$key"]="$value"
}

config_get() {
    local key="$1"
    local default="${2:-}"
    echo "${CONFIG[$key]:-$default}"
}

config_load() {
    local config_file="$1"
    
    [[ -f "$config_file" ]] || {
        log_warn "Config no encontrada: $config_file"
        return 1
    }
    
    log_debug "Cargando config: $config_file"
    
    while IFS='=' read -r key value; do
        [[ "$key" =~ ^[[:space:]]*# ]] && continue
        [[ -z "$key" ]] && continue
        config_set "$key" "$value"
    done < "$config_file"
}

config_dump() {
    echo "=== Configuración Actual ==="
    for key in "${!CONFIG[@]}"; do
        echo "  $key = ${CONFIG[$key]}"
    done
}
