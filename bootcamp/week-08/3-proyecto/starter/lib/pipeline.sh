#!/bin/bash
# ============================================
# Pipeline Library - Ejecución de stages
# ============================================

declare -a PIPELINE_STAGES=()
declare -A STAGE_STATUS=()

pipeline_add_stage() {
    local stage="$1"
    PIPELINE_STAGES+=("$stage")
}

pipeline_run() {
    local failed=false
    
    log_info "Iniciando pipeline con ${#PIPELINE_STAGES[@]} stages"
    echo ""
    
    for stage in "${PIPELINE_STAGES[@]}"; do
        local timestamp
        timestamp=$(date "+%H:%M:%S")
        
        echo -n "[$timestamp] $stage... "
        
        if "stage_$stage" &>/dev/null; then
            echo -e "${GREEN}✓${NC}"
            STAGE_STATUS["$stage"]="pass"
        else
            echo -e "${RED}✗${NC}"
            STAGE_STATUS["$stage"]="fail"
            failed=true
            break
        fi
    done
    
    echo ""
    
    if [[ "$failed" == "true" ]]; then
        log_error "Pipeline falló"
        return 1
    else
        log_info "Pipeline completado exitosamente"
        return 0
    fi
}

pipeline_summary() {
    echo "=== Pipeline Summary ==="
    for stage in "${PIPELINE_STAGES[@]}"; do
        local status="${STAGE_STATUS[$stage]:-pending}"
        echo "  $stage: $status"
    done
}
