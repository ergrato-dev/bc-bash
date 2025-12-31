#!/bin/bash
# ============================================
# Config Library - Gestión de configuración
# SOLUCIÓN COMPLETA
# ============================================

declare -A CONFIG
declare -A CONFIG_DEFAULTS

# ============================================
# Funciones principales
# ============================================

config_define() {
    local key="$1"
    local default="${2:-}"
    CONFIG_DEFAULTS["$key"]="$default"
    CONFIG["$key"]="$default"
}

config_set() {
    local key="$1"
    local value="$2"
    CONFIG["$key"]="$value"
    log_debug "Config set: $key = $value"
}

config_get() {
    local key="$1"
    local default="${2:-${CONFIG_DEFAULTS[$key]:-}}"
    echo "${CONFIG[$key]:-$default}"
}

config_has() {
    local key="$1"
    [[ -n "${CONFIG[$key]:-}" ]]
}

# ============================================
# Carga de configuración
# ============================================

config_load() {
    local config_file="$1"
    
    if [[ ! -f "$config_file" ]]; then
        log_warn "Config no encontrada: $config_file"
        return 1
    fi
    
    log_debug "Cargando config: $config_file"
    
    while IFS='=' read -r key value || [[ -n "$key" ]]; do
        # Ignorar comentarios y líneas vacías
        [[ "$key" =~ ^[[:space:]]*# ]] && continue
        [[ -z "$key" ]] && continue
        
        # Limpiar espacios
        key=$(trim "$key")
        value=$(trim "$value")
        
        # Remover comillas si existen
        value="${value#\"}"
        value="${value%\"}"
        value="${value#\'}"
        value="${value%\'}"
        
        config_set "$key" "$value"
    done < "$config_file"
    
    return 0
}

config_load_env() {
    # Cargar variables de entorno con prefijo
    local prefix="${1:-APP_}"
    
    while IFS='=' read -r key value; do
        if [[ "$key" == "${prefix}"* ]]; then
            local config_key="${key#$prefix}"
            config_set "$config_key" "$value"
        fi
    done < <(env)
}

# ============================================
# Utilidades
# ============================================

config_dump() {
    echo "╔════════════════════════════════════════════╗"
    echo "║         CURRENT CONFIGURATION              ║"
    echo "╚════════════════════════════════════════════╝"
    echo ""
    
    for key in "${!CONFIG[@]}"; do
        local value="${CONFIG[$key]}"
        # Ocultar valores sensibles
        if [[ "$key" =~ (PASSWORD|SECRET|TOKEN|KEY) ]]; then
            value="********"
        fi
        printf "  %-20s = %s\n" "$key" "$value"
    done | sort
    
    echo ""
}

config_validate() {
    local required=("$@")
    local missing=()
    
    for key in "${required[@]}"; do
        if ! config_has "$key"; then
            missing+=("$key")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing required config: ${missing[*]}"
        return 1
    fi
    
    return 0
}

config_export() {
    # Exportar config como variables de entorno
    for key in "${!CONFIG[@]}"; do
        export "$key=${CONFIG[$key]}"
    done
}
