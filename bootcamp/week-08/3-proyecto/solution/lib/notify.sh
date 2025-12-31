#!/bin/bash
# ============================================
# Notify Library - Notificaciones
# SOLUCIÓN COMPLETA
# ============================================

# ============================================
# Slack
# ============================================

notify_slack() {
    local message="$1"
    local channel="${2:-#deployments}"
    local webhook_url="${SLACK_WEBHOOK:-}"
    local username="${SLACK_USERNAME:-AutoDeploy}"
    local icon="${SLACK_ICON:-:rocket:}"
    
    if [[ -z "$webhook_url" ]]; then
        log_debug "SLACK_WEBHOOK not configured, skipping notification"
        return 0
    fi
    
    local payload
    payload=$(cat << EOF
{
    "channel": "$channel",
    "username": "$username",
    "icon_emoji": "$icon",
    "text": "$message"
}
EOF
)
    
    curl -s -X POST "$webhook_url" \
        -H "Content-Type: application/json" \
        -d "$payload" >/dev/null
    
    log_debug "Slack notification sent to $channel"
}

notify_slack_rich() {
    local title="$1"
    local message="$2"
    local color="${3:-good}"  # good, warning, danger
    local webhook_url="${SLACK_WEBHOOK:-}"
    
    if [[ -z "$webhook_url" ]]; then
        return 0
    fi
    
    local payload
    payload=$(cat << EOF
{
    "attachments": [{
        "color": "$color",
        "title": "$title",
        "text": "$message",
        "footer": "AutoDeploy",
        "ts": $(date +%s)
    }]
}
EOF
)
    
    curl -s -X POST "$webhook_url" \
        -H "Content-Type: application/json" \
        -d "$payload" >/dev/null
}

# ============================================
# Email
# ============================================

notify_email() {
    local to="$1"
    local subject="$2"
    local body="$3"
    
    if ! command -v mail &>/dev/null; then
        log_warn "mail command not available"
        return 1
    fi
    
    echo "$body" | mail -s "$subject" "$to"
    log_debug "Email sent to $to"
}

notify_email_html() {
    local to="$1"
    local subject="$2"
    local html_body="$3"
    
    if ! command -v mail &>/dev/null; then
        log_warn "mail command not available"
        return 1
    fi
    
    echo "$html_body" | mail -s "$subject" -a "Content-Type: text/html" "$to"
}

# ============================================
# Webhook genérico
# ============================================

notify_webhook() {
    local url="$1"
    local payload="$2"
    local method="${3:-POST}"
    
    curl -s -X "$method" "$url" \
        -H "Content-Type: application/json" \
        -d "$payload"
}

# ============================================
# Console
# ============================================

notify_console() {
    local title="$1"
    local message="$2"
    local type="${3:-info}"
    
    local color
    case "$type" in
        success) color="$GREEN" ;;
        warning) color="$YELLOW" ;;
        error)   color="$RED" ;;
        *)       color="$CYAN" ;;
    esac
    
    local width=50
    local border
    border=$(printf '═%.0s' $(seq 1 $width))
    
    echo ""
    echo -e "${color}╔${border}╗${NC}"
    printf "${color}║${NC} %-$((width-2))s ${color}║${NC}\n" "$title"
    echo -e "${color}╠${border}╣${NC}"
    
    # Word wrap message
    echo "$message" | fold -w $((width-4)) | while read -r line; do
        printf "${color}║${NC}  %-$((width-4))s  ${color}║${NC}\n" "$line"
    done
    
    echo -e "${color}╚${border}╝${NC}"
    echo ""
}

# ============================================
# Desktop notifications (Linux)
# ============================================

notify_desktop() {
    local title="$1"
    local message="$2"
    local icon="${3:-dialog-information}"
    
    if command -v notify-send &>/dev/null; then
        notify-send -i "$icon" "$title" "$message"
    elif command -v osascript &>/dev/null; then
        # macOS
        osascript -e "display notification \"$message\" with title \"$title\""
    else
        log_debug "No desktop notification system available"
    fi
}

# ============================================
# Deploy notifications
# ============================================

notify_deploy_start() {
    local env="$1"
    local version="$2"
    
    local message="🚀 Deploy started\nEnvironment: $env\nVersion: $version"
    
    notify_console "DEPLOY STARTED" "$message" "info"
    notify_slack "$message"
}

notify_deploy_success() {
    local env="$1"
    local version="$2"
    local duration="$3"
    
    local message="✅ Deploy completed\nEnvironment: $env\nVersion: $version\nDuration: ${duration}s"
    
    notify_console "DEPLOY SUCCESS" "$message" "success"
    notify_slack_rich "Deploy Successful" "$message" "good"
}

notify_deploy_failure() {
    local env="$1"
    local error="$2"
    
    local message="❌ Deploy failed\nEnvironment: $env\nError: $error"
    
    notify_console "DEPLOY FAILED" "$message" "error"
    notify_slack_rich "Deploy Failed" "$message" "danger"
}
