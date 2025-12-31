#!/bin/bash
# ============================================
# PRÁCTICA 02: Pipelines y Workflows
# Semana 8 - Proyectos Avanzados
# ============================================

set -euo pipefail

# ============================================
# PASO 1: Pipeline Básico
# ============================================
echo "--- Paso 1: Pipeline Básico ---"

# Array de stages a ejecutar en secuencia
# Descomenta las siguientes líneas:
# declare -a PIPELINE_STAGES=("init" "validate" "build" "test")
# 
# echo "Stages definidos:"
# for stage in "${PIPELINE_STAGES[@]}"; do
#     echo "  → $stage"
# done

echo ""

# ============================================
# PASO 2: Funciones de Stage
# ============================================
echo "--- Paso 2: Funciones de Stage ---"

# Cada stage es una función independiente
# Descomenta las siguientes líneas:
# stage_init() {
#     echo "  Inicializando proyecto..."
#     sleep 0.3
#     return 0
# }
# 
# stage_validate() {
#     echo "  Validando configuración..."
#     sleep 0.2
#     return 0
# }
# 
# stage_build() {
#     echo "  Compilando artefactos..."
#     sleep 0.4
#     return 0
# }
# 
# stage_test() {
#     echo "  Ejecutando tests..."
#     sleep 0.3
#     return 0
# }
# 
# echo "Funciones de stage definidas ✓"

echo ""

# ============================================
# PASO 3: Ejecución con Control de Errores
# ============================================
echo "--- Paso 3: Ejecución con Control de Errores ---"

# Ejecutar stage con manejo de errores
# Descomenta las siguientes líneas:
# run_stage() {
#     local stage_name="$1"
#     local stage_func="stage_$stage_name"
#     
#     echo "Ejecutando: $stage_name"
#     
#     if "$stage_func"; then
#         echo "  ✅ $stage_name completado"
#         return 0
#     else
#         echo "  ❌ $stage_name falló"
#         return 1
#     fi
# }
# 
# # Probar con un stage
# # run_stage "init"

echo ""

# ============================================
# PASO 4: Estado y Logging
# ============================================
echo "--- Paso 4: Estado y Logging ---"

# Sistema de logging con timestamps
# Descomenta las siguientes líneas:
# readonly GREEN='\033[0;32m'
# readonly RED='\033[0;31m'
# readonly YELLOW='\033[0;33m'
# readonly NC='\033[0m'
# 
# log_stage() {
#     local status="$1"
#     local stage="$2"
#     local timestamp
#     timestamp=$(date "+%H:%M:%S")
#     
#     case "$status" in
#         START) echo -e "${YELLOW}[$timestamp]${NC} ▶ $stage" ;;
#         PASS)  echo -e "${GREEN}[$timestamp]${NC} ✓ $stage" ;;
#         FAIL)  echo -e "${RED}[$timestamp]${NC} ✗ $stage" ;;
#     esac
# }
# 
# # Demo logging
# log_stage "START" "demo_stage"
# log_stage "PASS" "demo_stage"

echo ""

# ============================================
# PASO 5: Retry Automático
# ============================================
echo "--- Paso 5: Retry Automático ---"

# Reintentar comandos que fallan
# Descomenta las siguientes líneas:
# retry() {
#     local max_attempts="$1"
#     local delay="$2"
#     shift 2
#     local cmd=("$@")
#     
#     for ((attempt=1; attempt<=max_attempts; attempt++)); do
#         echo "  Intento $attempt/$max_attempts..."
#         if "${cmd[@]}"; then
#             echo "  ✅ Éxito en intento $attempt"
#             return 0
#         fi
#         [[ $attempt -lt $max_attempts ]] && sleep "$delay"
#     done
#     
#     echo "  ❌ Falló después de $max_attempts intentos"
#     return 1
# }
# 
# # Comando que falla aleatoriamente
# flaky_command() {
#     [[ $((RANDOM % 3)) -eq 0 ]] && return 0 || return 1
# }
# 
# # Probar retry
# echo "Probando retry con comando inestable:"
# retry 5 0.5 flaky_command || echo "Comando falló definitivamente"

echo ""

# ============================================
# PASO 6: Pipeline Completo
# ============================================
echo "--- Paso 6: Pipeline Completo ---"

# Runner de pipeline completo
# Descomenta las siguientes líneas:
# run_pipeline() {
#     local stages=("init" "validate" "build" "test")
#     local failed=false
#     
#     echo "╔════════════════════════════════════╗"
#     echo "║       PIPELINE EXECUTION           ║"
#     echo "╚════════════════════════════════════╝"
#     echo ""
#     
#     for stage in "${stages[@]}"; do
#         log_stage "START" "$stage"
#         
#         if "stage_$stage" 2>/dev/null; then
#             log_stage "PASS" "$stage"
#         else
#             log_stage "FAIL" "$stage"
#             failed=true
#             break
#         fi
#     done
#     
#     echo ""
#     if [[ "$failed" == "false" ]]; then
#         echo "═══════════════════════════════════════"
#         echo "✅ PIPELINE COMPLETED SUCCESSFULLY"
#         echo "═══════════════════════════════════════"
#         return 0
#     else
#         echo "═══════════════════════════════════════"
#         echo "❌ PIPELINE FAILED"
#         echo "═══════════════════════════════════════"
#         return 1
#     fi
# }
# 
# # Ejecutar pipeline (requiere pasos 2 y 4)
# # run_pipeline

echo ""

# ============================================
# RESUMEN
# ============================================
echo "=== RESUMEN ==="
echo "✓ Pipeline con array de stages"
echo "✓ Funciones independientes por stage"
echo "✓ Control de errores con || y return"
echo "✓ Logging con timestamps y colores"
echo "✓ Retry automático para comandos inestables"
echo "✓ Pipeline runner completo"
