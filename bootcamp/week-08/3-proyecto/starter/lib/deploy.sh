#!/bin/bash
# ============================================
# Deploy Library - Funciones de deployment
# ============================================

deploy_rsync() {
    local source="$1"
    local dest="$2"
    
    log_info "Desplegando $source → $dest"
    
    rsync -avz --delete \
        --exclude '.git' \
        --exclude 'node_modules' \
        --exclude '.env' \
        "$source" "$dest"
}

deploy_health_check() {
    local url="$1"
    local max_attempts="${2:-5}"
    
    log_info "Health check: $url"
    
    for ((i=1; i<=max_attempts; i++)); do
        if curl -sf "$url" &>/dev/null; then
            log_info "Health check passed"
            return 0
        fi
        log_warn "Intento $i/$max_attempts fallido, reintentando..."
        sleep 2
    done
    
    log_error "Health check falló después de $max_attempts intentos"
    return 1
}

deploy_rollback() {
    local backup_dir="$1"
    local target_dir="$2"
    
    log_warn "Ejecutando rollback..."
    
    if [[ -d "$backup_dir" ]]; then
        rm -rf "$target_dir"
        mv "$backup_dir" "$target_dir"
        log_info "Rollback completado"
    else
        log_error "No hay backup disponible para rollback"
        return 1
    fi
}
