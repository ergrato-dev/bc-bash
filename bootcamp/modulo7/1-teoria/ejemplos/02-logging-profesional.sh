#!/bin/bash
# Ejemplo 02: Sistema de Logging
# Descripción: Implementar logging profesional

# === Configuración de Logging ===
readonly LOG_FILE="app.log"
readonly LOG_LEVEL="${LOG_LEVEL:-INFO}"  # DEBUG, INFO, WARN, ERROR

# Niveles en orden de severidad
declare -A LOG_LEVELS
LOG_LEVELS[DEBUG]=0
LOG_LEVELS[INFO]=1
LOG_LEVELS[WARN]=2
LOG_LEVELS[ERROR]=3

# Función de logging
log() {
    local nivel=$1
    shift
    local mensaje="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Verificar si el nivel es suficiente para loggear
    if [ ${LOG_LEVELS[$nivel]} -ge ${LOG_LEVELS[$LOG_LEVEL]} ]; then
        # Formato: [TIMESTAMP] [NIVEL] mensaje
        local log_entry="[$timestamp] [$nivel] $mensaje"
        
        # Escribir a archivo y consola
        echo "$log_entry" | tee -a "$LOG_FILE"
    fi
}

# Funciones de conveniencia
log_debug() { log DEBUG "$@"; }
log_info() { log INFO "$@"; }
log_warn() { log WARN "$@"; }
log_error() { log ERROR "$@"; }

# === Demostración ===
echo "=== Sistema de Logging ===" | tee "$LOG_FILE"

log_debug "Esto es un mensaje DEBUG"
log_info "Aplicación iniciada"
log_info "Procesando archivo: datos.txt"
log_warn "Espacio en disco bajo: 15%"
log_error "Falló conexión a base de datos"

echo -e "\n=== Contenido del log ==="
cat "$LOG_FILE"

# === Logging con contexto ===
echo -e "\n=== Logging con contexto ==="

log_with_context() {
    local nivel=$1
    local contexto=$2
    shift 2
    local mensaje="$*"
    
    log "$nivel" "[$contexto] $mensaje"
}

log_with_context INFO "ModuloUsuarios" "Usuario 'admin' logueado"
log_with_context ERROR "ModuloBaseDatos" "Timeout en query"
log_with_context WARN "ModuloArchivos" "Archivo no encontrado: config.ini"

# === Rotación de logs ===
echo -e "\n=== Rotación de logs ==="

rotar_log() {
    local log_file=$1
    local max_size=1024  # 1KB para demo
    
    if [ -f "$log_file" ]; then
        local size=$(stat -f%z "$log_file" 2>/dev/null || stat -c%s "$log_file" 2>/dev/null)
        
        if [ "$size" -gt "$max_size" ]; then
            local timestamp=$(date +%Y%m%d_%H%M%S)
            mv "$log_file" "${log_file}.${timestamp}"
            log_info "Log rotado: ${log_file}.${timestamp}"
        fi
    fi
}

# Ejemplo de uso
log_info "Este es el último mensaje antes de rotar"

# Limpiar (comentar para mantener logs)
# rm -f app.log*

echo -e "\n✓ Sistema de logging demostrado"
echo "Ver logs: cat $LOG_FILE"
