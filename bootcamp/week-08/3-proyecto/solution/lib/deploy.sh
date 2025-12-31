#!/bin/bash
# ============================================
# Deploy Library - Funciones de deployment
# SOLUCIÓN COMPLETA
# ============================================

# ============================================
# Transfer functions
# ============================================

deploy_rsync() {
    local source="$1"
    local dest="$2"
    local options="${3:--avz}"
    
    log_info "Deploying: $source → $dest"
    
    # Verificar que source existe
    if [[ ! -e "$source" ]]; then
        log_error "Source not found: $source"
        return 1
    fi
    
    rsync $options \
        --delete \
        --exclude '.git' \
        --exclude '.git*' \
        --exclude 'node_modules' \
        --exclude '.env' \
        --exclude '*.log' \
        --exclude '.DS_Store' \
        "$source" "$dest"
}

deploy_scp() {
    local source="$1"
    local dest="$2"
    
    log_info "Copying: $source → $dest"
    scp -r "$source" "$dest"
}

# ============================================
# Health checks
# ============================================

deploy_health_check() {
    local url="$1"
    local max_attempts="${2:-10}"
    local delay="${3:-3}"
    local expected_code="${4:-200}"
    
    log_info "Health check: $url"
    
    for ((i=1; i<=max_attempts; i++)); do
        local http_code
        http_code=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null || echo "000")
        
        if [[ "$http_code" == "$expected_code" ]]; then
            log_info "Health check passed (HTTP $http_code)"
            return 0
        fi
        
        log_warn "Attempt $i/$max_attempts: HTTP $http_code (expected $expected_code)"
        
        if [[ $i -lt $max_attempts ]]; then
            sleep "$delay"
        fi
    done
    
    log_error "Health check failed after $max_attempts attempts"
    return 1
}

deploy_tcp_check() {
    local host="$1"
    local port="$2"
    local timeout="${3:-5}"
    
    log_info "TCP check: $host:$port"
    
    if timeout "$timeout" bash -c "echo >/dev/tcp/$host/$port" 2>/dev/null; then
        log_info "TCP check passed"
        return 0
    else
        log_error "TCP check failed"
        return 1
    fi
}

# ============================================
# Backup and rollback
# ============================================

deploy_backup() {
    local source="$1"
    local backup_dir="${2:-./backups}"
    local timestamp
    timestamp=$(date "+%Y%m%d_%H%M%S")
    
    local backup_path="$backup_dir/backup_$timestamp"
    
    log_info "Creating backup: $backup_path"
    
    mkdir -p "$backup_dir"
    cp -r "$source" "$backup_path"
    
    echo "$backup_path"
}

deploy_rollback() {
    local backup_path="$1"
    local target_dir="$2"
    
    log_warn "Rolling back from: $backup_path"
    
    if [[ ! -d "$backup_path" ]]; then
        log_error "Backup not found: $backup_path"
        return 1
    fi
    
    # Crear backup del estado actual antes de rollback
    local current_backup
    current_backup=$(deploy_backup "$target_dir" "$(dirname "$backup_path")")
    log_info "Current state backed up to: $current_backup"
    
    # Restaurar
    rm -rf "$target_dir"
    cp -r "$backup_path" "$target_dir"
    
    log_info "Rollback completed"
}

deploy_cleanup_backups() {
    local backup_dir="$1"
    local keep="${2:-5}"
    
    log_info "Cleaning up old backups (keeping $keep newest)"
    
    local count
    count=$(find "$backup_dir" -maxdepth 1 -type d -name "backup_*" | wc -l)
    
    if [[ $count -gt $keep ]]; then
        local to_delete=$((count - keep))
        find "$backup_dir" -maxdepth 1 -type d -name "backup_*" | \
            sort | \
            head -n "$to_delete" | \
            xargs rm -rf
        
        log_info "Removed $to_delete old backup(s)"
    fi
}

# ============================================
# Remote execution
# ============================================

deploy_ssh_exec() {
    local host="$1"
    local user="$2"
    shift 2
    local cmd="$*"
    
    log_debug "SSH exec on $user@$host: $cmd"
    ssh "$user@$host" "$cmd"
}

deploy_remote_script() {
    local host="$1"
    local user="$2"
    local script="$3"
    
    log_info "Running remote script on $user@$host"
    ssh "$user@$host" 'bash -s' < "$script"
}
