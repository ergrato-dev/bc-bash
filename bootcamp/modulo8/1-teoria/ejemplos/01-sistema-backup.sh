#!/bin/bash
# Ejemplo 01: Sistema de Backup Completo
# Descripción: Script robusto de backup con rotación

set -euo pipefail

# === Configuración ===
readonly SCRIPT_NAME=$(basename "$0")
readonly BACKUP_SOURCE="${HOME}/Documents"
readonly BACKUP_DEST="${HOME}/backups"
readonly RETENTION_DAYS=7
readonly LOG_FILE="${BACKUP_DEST}/backup.log"

# === Funciones de Logging ===
log() {
    local nivel=$1
    shift
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$nivel] $*" | tee -a "$LOG_FILE"
}

log_info() { log INFO "$@"; }
log_error() { log ERROR "$@"; }
log_success() { log SUCCESS "$@"; }

# === Funciones de Utilidad ===
error_exit() {
    log_error "$1"
    exit 1
}

verificar_dependencias() {
    local dependencias=("tar" "gzip" "find")
    
    for cmd in "${dependencias[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            error_exit "Comando requerido no encontrado: $cmd"
        fi
    done
    
    log_info "✓ Todas las dependencias están instaladas"
}

crear_directorios() {
    if [ ! -d "$BACKUP_DEST" ]; then
        mkdir -p "$BACKUP_DEST" || error_exit "No se pudo crear $BACKUP_DEST"
        log_info "Directorio de backup creado: $BACKUP_DEST"
    fi
}

# === Función Principal de Backup ===
realizar_backup() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_name="backup_${timestamp}.tar.gz"
    local backup_path="${BACKUP_DEST}/${backup_name}"
    
    log_info "Iniciando backup: $backup_name"
    
    # Verificar que existe el origen
    if [ ! -d "$BACKUP_SOURCE" ]; then
        error_exit "Directorio origen no existe: $BACKUP_SOURCE"
    fi
    
    # Crear backup
    if tar -czf "$backup_path" -C "$(dirname "$BACKUP_SOURCE")" "$(basename "$BACKUP_SOURCE")" 2>&1; then
        local size=$(du -h "$backup_path" | cut -f1)
        log_success "Backup completado: $backup_name (Tamaño: $size)"
        return 0
    else
        error_exit "Falló la creación del backup"
    fi
}

# === Rotación de Backups ===
rotar_backups() {
    log_info "Iniciando rotación de backups (mantener últimos $RETENTION_DAYS días)"
    
    local eliminados=0
    
    # Buscar backups antiguos
    while IFS= read -r archivo; do
        rm -f "$archivo"
        eliminados=$((eliminados + 1))
        log_info "Eliminado backup antiguo: $(basename "$archivo")"
    done < <(find "$BACKUP_DEST" -name "backup_*.tar.gz" -mtime +"$RETENTION_DAYS")
    
    if [ "$eliminados" -eq 0 ]; then
        log_info "No hay backups para eliminar"
    else
        log_success "Eliminados $eliminados backups antiguos"
    fi
}

# === Función de Verificación ===
verificar_backup() {
    local backup_path=$1
    
    log_info "Verificando integridad del backup..."
    
    if tar -tzf "$backup_path" > /dev/null 2>&1; then
        log_success "✓ Backup verificado correctamente"
        return 0
    else
        log_error "✗ Backup corrupto"
        return 1
    fi
}

# === Reporte de Estado ===
generar_reporte() {
    log_info "=== Reporte de Backups ==="
    
    local total_backups=$(find "$BACKUP_DEST" -name "backup_*.tar.gz" | wc -l)
    local espacio_total=$(du -sh "$BACKUP_DEST" | cut -f1)
    
    log_info "Total de backups: $total_backups"
    log_info "Espacio utilizado: $espacio_total"
    
    log_info "Backups disponibles:"
    find "$BACKUP_DEST" -name "backup_*.tar.gz" -exec ls -lh {} \; | while read -r line; do
        log_info "  $line"
    done
}

# === Main ===
main() {
    log_info "=== Sistema de Backup Iniciado ==="
    
    verificar_dependencias
    crear_directorios
    realizar_backup
    
    # Obtener el último backup
    local ultimo_backup=$(find "$BACKUP_DEST" -name "backup_*.tar.gz" -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -d' ' -f2)
    
    if [ -n "$ultimo_backup" ]; then
        verificar_backup "$ultimo_backup"
    fi
    
    rotar_backups
    generar_reporte
    
    log_success "=== Backup Completado Exitosamente ==="
}

# Ejecutar
main
