#!/bin/bash
# ============================================
# Pipeline Library - Ejecución de stages
# SOLUCIÓN COMPLETA
# ============================================

declare -a PIPELINE_STAGES=()
declare -A STAGE_STATUS=()
declare -A STAGE_DURATION=()

# ============================================
# Gestión de stages
# ============================================

pipeline_reset() {
    PIPELINE_STAGES=()
    STAGE_STATUS=()
    STAGE_DURATION=()
}

pipeline_add_stage() {
    local stage="$1"
    PIPELINE_STAGES+=("$stage")
    STAGE_STATUS["$stage"]="pending"
}

pipeline_remove_stage() {
    local stage="$1"
    local new_stages=()
    
    for s in "${PIPELINE_STAGES[@]}"; do
        [[ "$s" != "$stage" ]] && new_stages+=("$s")
    done
    
    PIPELINE_STAGES=("${new_stages[@]}")
}

# ============================================
# Ejecución
# ============================================

pipeline_run() {
    local failed=false
    local start_time=$SECONDS
    
    echo ""
    echo "╔════════════════════════════════════════════╗"
    echo "║           PIPELINE EXECUTION               ║"
    echo "╠════════════════════════════════════════════╣"
    printf "║  Stages: %-33s║\n" "${#PIPELINE_STAGES[@]}"
    echo "╚════════════════════════════════════════════╝"
    echo ""
    
    for stage in "${PIPELINE_STAGES[@]}"; do
        local stage_start=$SECONDS
        local timestamp
        timestamp=$(date "+%H:%M:%S")
        
        printf "${CYAN}[%s]${NC} ▶ %-20s " "$timestamp" "$stage"
        STAGE_STATUS["$stage"]="running"
        
        if "stage_$stage" &>/dev/null; then
            STAGE_STATUS["$stage"]="pass"
            STAGE_DURATION["$stage"]=$((SECONDS - stage_start))
            echo -e "${GREEN}✓${NC} (${STAGE_DURATION[$stage]}s)"
        else
            STAGE_STATUS["$stage"]="fail"
            STAGE_DURATION["$stage"]=$((SECONDS - stage_start))
            echo -e "${RED}✗${NC} (${STAGE_DURATION[$stage]}s)"
            failed=true
            break
        fi
    done
    
    local total_duration=$((SECONDS - start_time))
    
    echo ""
    echo "════════════════════════════════════════════"
    
    if [[ "$failed" == "true" ]]; then
        echo -e "${RED}❌ PIPELINE FAILED${NC} (${total_duration}s)"
        echo "════════════════════════════════════════════"
        return 1
    else
        echo -e "${GREEN}✅ PIPELINE COMPLETED${NC} (${total_duration}s)"
        echo "════════════════════════════════════════════"
        return 0
    fi
}

pipeline_run_stage() {
    local stage="$1"
    local func="stage_$stage"
    
    if ! declare -f "$func" &>/dev/null; then
        log_error "Stage function not found: $func"
        return 1
    fi
    
    "$func"
}

# ============================================
# Retry mechanism
# ============================================

pipeline_retry() {
    local max_attempts="${1:-3}"
    local delay="${2:-5}"
    shift 2
    local cmd=("$@")
    
    for ((attempt=1; attempt<=max_attempts; attempt++)); do
        log_debug "Attempt $attempt/$max_attempts: ${cmd[*]}"
        
        if "${cmd[@]}"; then
            return 0
        fi
        
        if [[ $attempt -lt $max_attempts ]]; then
            log_warn "Failed, retrying in ${delay}s..."
            sleep "$delay"
        fi
    done
    
    log_error "Failed after $max_attempts attempts"
    return 1
}

# ============================================
# Reporting
# ============================================

pipeline_summary() {
    echo ""
    echo "╔════════════════════════════════════════════╗"
    echo "║           PIPELINE SUMMARY                 ║"
    echo "╚════════════════════════════════════════════╝"
    echo ""
    
    for stage in "${PIPELINE_STAGES[@]}"; do
        local status="${STAGE_STATUS[$stage]:-pending}"
        local duration="${STAGE_DURATION[$stage]:-0}"
        local icon
        
        case "$status" in
            pass)    icon="${GREEN}✓${NC}" ;;
            fail)    icon="${RED}✗${NC}" ;;
            running) icon="${YELLOW}▶${NC}" ;;
            *)       icon="${CYAN}○${NC}" ;;
        esac
        
        printf "  %b %-20s %s (%ds)\n" "$icon" "$stage" "$status" "$duration"
    done
    
    echo ""
}

pipeline_to_json() {
    echo "{"
    echo "  \"stages\": ["
    
    local first=true
    for stage in "${PIPELINE_STAGES[@]}"; do
        [[ "$first" == "true" ]] || echo ","
        first=false
        
        printf '    {"name": "%s", "status": "%s", "duration": %d}' \
            "$stage" \
            "${STAGE_STATUS[$stage]:-pending}" \
            "${STAGE_DURATION[$stage]:-0}"
    done
    
    echo ""
    echo "  ]"
    echo "}"
}
