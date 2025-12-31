#!/bin/bash
# ============================================
# PRÁCTICA 03: Monitoreo de Sistema
# Semana 6 - Herramientas del Sistema
# ============================================

set -euo pipefail

echo "========================================"
echo "📊 PRÁCTICA 03: Monitoreo de Sistema"
echo "========================================"
echo ""

# ============================================
# PASO 1: Monitoreo de Disco
# ============================================
echo "--- Paso 1: Monitoreo de Disco ---"

# df muestra uso de sistemas de archivos
# du muestra tamaño de directorios

# Descomenta las siguientes líneas:
# echo "Uso de disco por partición:"
# df -h | grep -E '^/dev|^Filesystem'
# echo ""
# echo "Particiones con más del 50% de uso:"
# df -h | awk 'NR>1 && $5+0 > 50 {print $6, $5}'
# echo ""
# echo "Tamaño del directorio HOME:"
# du -sh "$HOME" 2>/dev/null || echo "No se pudo calcular"

echo ""

# ============================================
# PASO 2: Monitoreo de Memoria
# ============================================
echo "--- Paso 2: Monitoreo de Memoria ---"

# free muestra RAM y swap
# -h para formato legible, -m para megabytes

# Descomenta las siguientes líneas:
# echo "Uso de memoria:"
# free -h
# echo ""
# echo "Memoria disponible (MB):"
# free -m | awk '/Mem:/{print $7 " MB disponibles"}'
# echo ""
# echo "Porcentaje de memoria usada:"
# free | awk '/Mem:/{printf "%.1f%%\n", $3/$2 * 100}'

echo ""

# ============================================
# PASO 3: Monitoreo de CPU
# ============================================
echo "--- Paso 3: Monitoreo de CPU ---"

# uptime muestra load average
# nproc muestra número de CPUs

# Descomenta las siguientes líneas:
# echo "Información de CPU:"
# echo "Número de CPUs: $(nproc)"
# echo ""
# echo "Uptime y Load Average:"
# uptime
# echo ""
# echo "Load average (1 min):"
# load_1min=$(uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1 | tr -d ' ')
# echo "$load_1min"
# echo ""
# num_cpus=$(nproc)
# if (( $(echo "$load_1min > $num_cpus" | bc -l 2>/dev/null || echo 0) )); then
#     echo "⚠️  Load alto: $load_1min (CPUs: $num_cpus)"
# else
#     echo "✅ Load normal: $load_1min (CPUs: $num_cpus)"
# fi

echo ""

# ============================================
# PASO 4: Monitoreo de Red
# ============================================
echo "--- Paso 4: Monitoreo de Red ---"

# ss muestra sockets y conexiones
# ip addr muestra interfaces

# Descomenta las siguientes líneas:
# echo "Puertos TCP escuchando:"
# ss -tuln 2>/dev/null | grep LISTEN | head -10 || echo "Requiere permisos"
# echo ""
# echo "Resumen de conexiones:"
# ss -s 2>/dev/null | head -5 || echo "Requiere permisos"
# echo ""
# echo "Interfaces de red:"
# ip -brief addr 2>/dev/null || ip addr | grep -E '^[0-9]+:|inet ' | head -10

echo ""

# ============================================
# PASO 5: Función Health Check
# ============================================
echo "--- Paso 5: Health Check ---"

# Función que consolida métricas principales

# Descomenta las siguientes líneas:
# health_check() {
#     echo "====== HEALTH CHECK ======"
#     echo "Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
#     echo "Host: $(hostname)"
#     echo ""
#     
#     # Disco
#     echo "📁 DISCO:"
#     df -h / | awk 'NR==2{print "  Root: " $5 " usado (" $4 " libre)"}'
#     
#     # Memoria
#     echo ""
#     echo "🧠 MEMORIA:"
#     free -h | awk '/Mem:/{print "  RAM: " $3 " usado / " $2 " total"}'
#     free -h | awk '/Swap:/{print "  Swap: " $3 " usado / " $2 " total"}'
#     
#     # CPU
#     echo ""
#     echo "⚡ CPU:"
#     echo "  CPUs: $(nproc)"
#     echo "  Load: $(uptime | awk -F'load average:' '{print $2}')"
#     
#     # Uptime
#     echo ""
#     echo "⏱️  UPTIME:"
#     echo "  $(uptime -p 2>/dev/null || uptime | cut -d',' -f1)"
#     
#     echo "=========================="
# }
# 
# health_check

echo ""

# ============================================
# PASO 6: Alertas por Umbrales
# ============================================
echo "--- Paso 6: Sistema de Alertas ---"

# Función que verifica umbrales y genera alertas

# Descomenta las siguientes líneas:
# check_alerts() {
#     local alerts=0
#     
#     echo "====== VERIFICANDO ALERTAS ======"
#     
#     # Verificar disco (umbral 80%)
#     local disk_usage
#     disk_usage=$(df / | awk 'NR==2{print $5}' | tr -d '%')
#     if [[ $disk_usage -gt 80 ]]; then
#         echo "🔴 ALERTA: Disco root al ${disk_usage}%"
#         ((alerts++))
#     else
#         echo "✅ Disco: ${disk_usage}% (umbral: 80%)"
#     fi
#     
#     # Verificar memoria (umbral 90%)
#     local mem_usage
#     mem_usage=$(free | awk '/Mem:/{printf "%.0f", $3/$2 * 100}')
#     if [[ $mem_usage -gt 90 ]]; then
#         echo "🔴 ALERTA: Memoria al ${mem_usage}%"
#         ((alerts++))
#     else
#         echo "✅ Memoria: ${mem_usage}% (umbral: 90%)"
#     fi
#     
#     # Verificar procesos zombie
#     local zombies
#     zombies=$(ps aux | awk '$8=="Z"' | wc -l)
#     if [[ $zombies -gt 0 ]]; then
#         echo "🟡 AVISO: $zombies procesos zombie detectados"
#         ((alerts++))
#     else
#         echo "✅ Sin procesos zombie"
#     fi
#     
#     echo ""
#     if [[ $alerts -eq 0 ]]; then
#         echo "✅ Sistema saludable - Sin alertas"
#     else
#         echo "⚠️  $alerts alerta(s) detectada(s)"
#     fi
#     
#     echo "================================"
# }
# 
# check_alerts

echo ""

# ============================================
# PASO 7: Generar Reporte
# ============================================
echo "--- Paso 7: Generar Reporte ---"

# Función para generar reporte en formato texto

# Descomenta las siguientes líneas:
# generate_report() {
#     local report_file="/tmp/system-report-$(date +%Y%m%d-%H%M%S).txt"
#     
#     {
#         echo "REPORTE DE SISTEMA"
#         echo "=================="
#         echo "Generado: $(date)"
#         echo "Host: $(hostname)"
#         echo ""
#         echo "--- DISCO ---"
#         df -h
#         echo ""
#         echo "--- MEMORIA ---"
#         free -h
#         echo ""
#         echo "--- CPU/LOAD ---"
#         uptime
#         echo "CPUs: $(nproc)"
#         echo ""
#         echo "--- PROCESOS TOP ---"
#         ps aux --sort=-%cpu | head -6
#     } > "$report_file"
#     
#     echo "Reporte generado: $report_file"
#     echo ""
#     echo "Primeras 20 líneas:"
#     head -20 "$report_file"
# }
# 
# generate_report

echo ""

echo "========================================"
echo "✅ Práctica 03 completada"
echo "========================================"
echo ""
echo "💡 Tips de monitoreo:"
echo "   - Ejecuta health checks con cron cada 5 minutos"
echo "   - Configura alertas por email o Slack"
echo "   - Guarda histórico de métricas para análisis"
