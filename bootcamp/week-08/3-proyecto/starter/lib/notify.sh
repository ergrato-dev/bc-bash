#!/bin/bash
# ============================================
# Notify Library - Notificaciones
# ============================================

notify_slack() {
    local webhook_url="${SLACK_WEBHOOK:-}"
    local message="$1"
    local channel="${2:-#deployments}"
    
    [[ -z "$webhook_url" ]] && {
        log_warn "SLACK_WEBHOOK no configurado"
        return 1
    }
    
    curl -s -X POST "$webhook_url" \
        -H "Content-Type: application/json" \
        -d "{\"channel\":\"$channel\",\"text\":\"$message\"}"
}

notify_email() {
    local to="$1"
    local subject="$2"
    local body="$3"
    
    if command -v mail &>/dev/null; then
        echo "$body" | mail -s "$subject" "$to"
    else
        log_warn "Comando mail no disponible"
        return 1
    fi
}

notify_console() {
    local title="$1"
    local message="$2"
    
    echo ""
    echo "╔════════════════════════════════════╗"
    echo "║ $title"
    echo "╠════════════════════════════════════╣"
    echo "║ $message"
    echo "╚════════════════════════════════════╝"
    echo ""
}
