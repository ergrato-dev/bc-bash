#!/bin/bash
# ============================================
# PRÁCTICA 01: Gestión de Procesos
# Semana 6 - Herramientas del Sistema
# ============================================

set -euo pipefail

echo "========================================"
echo "🔄 PRÁCTICA 01: Gestión de Procesos"
echo "========================================"
echo ""

# ============================================
# PASO 1: Listar Procesos con ps
# ============================================
echo "--- Paso 1: Listar Procesos ---"

# El comando ps muestra procesos activos
# Opciones comunes: aux (BSD), -ef (UNIX)

# Descomenta las siguientes líneas:
# echo "Procesos del usuario actual:"
# ps -u $USER | head -10
# echo ""
# echo "Todos los procesos (formato BSD):"
# ps aux | head -10

echo ""

# ============================================
# PASO 2: Árbol de Procesos
# ============================================
echo "--- Paso 2: Árbol de Procesos ---"

# --forest muestra la jerarquía padre-hijo
# Útil para entender qué proceso lanzó qué

# Descomenta las siguientes líneas:
# echo "Árbol de procesos:"
# ps -ef --forest | head -20

echo ""

# ============================================
# PASO 3: Buscar Procesos con pgrep
# ============================================
echo "--- Paso 3: Buscar Procesos ---"

# pgrep busca procesos por nombre/patrón
# -a muestra también la línea de comando

# Descomenta las siguientes líneas:
# echo "Procesos bash activos:"
# pgrep -a bash
# echo ""
# echo "Cantidad de procesos bash:"
# pgrep bash | wc -l

echo ""

# ============================================
# PASO 4: Top Processes (Snapshot)
# ============================================
echo "--- Paso 4: Top Procesos ---"

# top -bn1 genera un snapshot sin modo interactivo
# Ordenar por CPU o memoria para encontrar problemas

# Descomenta las siguientes líneas:
# echo "Top 5 procesos por CPU:"
# ps aux --sort=-%cpu | head -6
# echo ""
# echo "Top 5 procesos por memoria:"
# ps aux --sort=-%mem | head -6

echo ""

# ============================================
# PASO 5: Jobs y Background
# ============================================
echo "--- Paso 5: Jobs y Background ---"

# & envía proceso a background
# jobs lista procesos en background del shell actual

# Descomenta las siguientes líneas:
# echo "Lanzando proceso en background..."
# sleep 5 &
# background_pid=$!
# echo "PID del proceso en background: $background_pid"
# echo ""
# echo "Jobs activos:"
# jobs
# echo ""
# echo "Esperando a que termine..."
# wait $background_pid
# echo "Proceso $background_pid completado"

echo ""

# ============================================
# PASO 6: Señales y Kill
# ============================================
echo "--- Paso 6: Señales y Kill ---"

# kill envía señales a procesos
# SIGTERM (15) = terminar limpio, SIGKILL (9) = forzar

# Descomenta las siguientes líneas:
# echo "Señales disponibles (primeras 15):"
# kill -l | head -3
# echo ""
# echo "Creando proceso de prueba..."
# sleep 100 &
# test_pid=$!
# echo "Proceso creado con PID: $test_pid"
# echo ""
# echo "Enviando SIGTERM..."
# kill $test_pid 2>/dev/null && echo "Proceso terminado con SIGTERM"
# echo ""
# echo "Verificando que ya no existe:"
# if ! ps -p $test_pid > /dev/null 2>&1; then
#     echo "✅ Proceso $test_pid ya no existe"
# fi

echo ""

# ============================================
# PASO 7: Función de Monitoreo de Proceso
# ============================================
echo "--- Paso 7: Función de Monitoreo ---"

# Función reutilizable para verificar si un proceso existe
# Útil en scripts de monitoreo

# Descomenta las siguientes líneas:
# process_exists() {
#     local pid="$1"
#     if ps -p "$pid" > /dev/null 2>&1; then
#         return 0  # existe
#     else
#         return 1  # no existe
#     fi
# }
# 
# # Probar la función
# echo "Verificando PID 1 (init/systemd):"
# if process_exists 1; then
#     echo "✅ PID 1 existe"
# else
#     echo "❌ PID 1 no existe"
# fi
# 
# echo ""
# echo "Verificando PID 99999 (improbable):"
# if process_exists 99999; then
#     echo "✅ PID 99999 existe"
# else
#     echo "❌ PID 99999 no existe"
# fi

echo ""

echo "========================================"
echo "✅ Práctica 01 completada"
echo "========================================"
