#!/bin/bash
# ============================================
# Profile Library - Funciones de profiling
# ============================================

# ============================================
# Función: profile_start
# Iniciar medición de tiempo
# ============================================
profile_start() {
    _PROFILE_START=$SECONDS
    _PROFILE_START_NS=$(date +%s%N 2>/dev/null || echo "0")
}

# ============================================
# Función: profile_end
# Finalizar medición y mostrar resultado
# ============================================
profile_end() {
    local label="${1:-Execution}"
    local duration=$((SECONDS - _PROFILE_START))
    echo "$label: ${duration}s"
}

# ============================================
# Función: benchmark
# Ejecutar función N veces y medir
# ============================================
benchmark() {
    local name="$1"
    local iterations="${2:-100}"
    shift 2
    
    local start=$SECONDS
    for ((i=0; i<iterations; i++)); do
        "$@" > /dev/null 2>&1
    done
    local duration=$((SECONDS - start))
    
    echo "$name: ${duration}s for $iterations iterations"
}

# ============================================
# Función: trace_with_timing
# Ejecutar script con timestamps por línea
# ============================================
trace_with_timing() {
    local script="$1"
    local output="${2:-/dev/stderr}"
    
    PS4='+$(date "+%s.%N"):$LINENO: '
    bash -x "$script" 2>"$output"
}

# ============================================
# Función: measure_section
# Medir tiempo de una sección de código
# ============================================
measure_section() {
    local name="$1"
    shift
    
    local start=$SECONDS
    "$@"
    local duration=$((SECONDS - start))
    
    echo "[PROFILE] $name: ${duration}s" >&2
}
