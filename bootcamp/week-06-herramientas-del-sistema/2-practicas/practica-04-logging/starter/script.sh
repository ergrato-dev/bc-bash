#!/bin/bash
# ============================================
# PRÁCTICA 04: Logs y Servicios
# Semana 6 - Herramientas del Sistema
# ============================================

set -euo pipefail

echo "========================================"
echo "📝 PRÁCTICA 04: Logs y Servicios"
echo "========================================"
echo ""

# ============================================
# PASO 1: Journalctl Básico
# ============================================
echo "--- Paso 1: Journalctl Básico ---"

# journalctl lee logs del journal de systemd
# -n limita líneas, --no-pager evita paginación

# Descomenta las siguientes líneas:
# echo "Últimas 10 entradas del journal:"
# if command -v journalctl &>/dev/null; then
#     journalctl -n 10 --no-pager 2>/dev/null || echo "Requiere permisos de root"
# else
#     echo "journalctl no disponible (sistema sin systemd)"
# fi

echo ""

# ============================================
# PASO 2: Filtrar por Servicio
# ============================================
echo "--- Paso 2: Logs por Servicio ---"

# -u filtra por unidad/servicio de systemd

# Descomenta las siguientes líneas:
# echo "Servicios disponibles (primeros 10):"
# if command -v systemctl &>/dev/null; then
#     systemctl list-units --type=service --no-pager | head -12
#     echo ""
#     echo "Logs del servicio cron (últimas 5 líneas):"
#     journalctl -u cron -n 5 --no-pager 2>/dev/null || \
#     journalctl -u crond -n 5 --no-pager 2>/dev/null || \
#     echo "Servicio cron no encontrado o sin permisos"
# else
#     echo "systemctl no disponible"
# fi

echo ""

# ============================================
# PASO 3: Filtrar por Tiempo
# ============================================
echo "--- Paso 3: Logs por Tiempo ---"

# --since y --until filtran por rango temporal

# Descomenta las siguientes líneas:
# echo "Logs desde hace 1 hora (últimos 5):"
# if command -v journalctl &>/dev/null; then
#     journalctl --since "1 hour ago" -n 5 --no-pager 2>/dev/null || \
#     echo "Sin permisos o sin logs recientes"
#     echo ""
#     echo "Logs de hoy (conteo):"
#     count=$(journalctl --since today 2>/dev/null | wc -l || echo "0")
#     echo "Total de entradas hoy: $count"
# else
#     echo "journalctl no disponible"
# fi

echo ""

# ============================================
# PASO 4: Filtrar por Prioridad
# ============================================
echo "--- Paso 4: Logs por Prioridad ---"

# -p filtra por nivel: emerg, alert, crit, err, warning, notice, info, debug

# Descomenta las siguientes líneas:
# echo "Niveles de prioridad en journalctl:"
# echo "  0 - emerg   (sistema inutilizable)"
# echo "  1 - alert   (acción inmediata)"
# echo "  2 - crit    (condiciones críticas)"
# echo "  3 - err     (errores)"
# echo "  4 - warning (advertencias)"
# echo "  5 - notice  (normal pero significativo)"
# echo "  6 - info    (informativo)"
# echo "  7 - debug   (debug)"
# echo ""
# echo "Errores de hoy:"
# if command -v journalctl &>/dev/null; then
#     journalctl -p err --since today -n 5 --no-pager 2>/dev/null || \
#     echo "Sin errores hoy o sin permisos"
# fi

echo ""

# ============================================
# PASO 5: Systemctl - Gestión de Servicios
# ============================================
echo "--- Paso 5: Gestión de Servicios ---"

# systemctl controla servicios de systemd

# Descomenta las siguientes líneas:
# echo "Comandos de systemctl:"
# echo "  systemctl status <servicio>   Ver estado"
# echo "  systemctl start <servicio>    Iniciar"
# echo "  systemctl stop <servicio>     Detener"
# echo "  systemctl restart <servicio>  Reiniciar"
# echo "  systemctl enable <servicio>   Habilitar al boot"
# echo "  systemctl disable <servicio>  Deshabilitar"
# echo ""
# 
# if command -v systemctl &>/dev/null; then
#     echo "Servicios activos (primeros 10):"
#     systemctl list-units --type=service --state=running --no-pager | head -12
#     echo ""
#     echo "Servicios fallidos:"
#     failed=$(systemctl --failed --no-pager 2>/dev/null | grep -c "failed" || echo "0")
#     echo "Total de servicios fallidos: $failed"
# else
#     echo "systemctl no disponible"
# fi

echo ""

# ============================================
# PASO 6: Archivos de Log Tradicionales
# ============================================
echo "--- Paso 6: Logs Tradicionales ---"

# /var/log contiene logs del sistema

# Descomenta las siguientes líneas:
# echo "Archivos de log en /var/log:"
# ls -lh /var/log/*.log 2>/dev/null | head -10 || echo "Sin acceso a /var/log"
# echo ""
# 
# echo "Ubicaciones comunes de logs:"
# echo "  /var/log/syslog    - Log general (Debian/Ubuntu)"
# echo "  /var/log/messages  - Log general (RHEL/Fedora)"
# echo "  /var/log/auth.log  - Autenticación"
# echo "  /var/log/kern.log  - Kernel"
# echo "  /var/log/dmesg     - Boot messages"
# echo ""
# 
# # Intentar leer syslog o messages
# if [[ -r /var/log/syslog ]]; then
#     echo "Últimas 5 líneas de syslog:"
#     tail -5 /var/log/syslog
# elif [[ -r /var/log/messages ]]; then
#     echo "Últimas 5 líneas de messages:"
#     tail -5 /var/log/messages
# else
#     echo "Sin acceso a logs del sistema (requiere root)"
# fi

echo ""

# ============================================
# PASO 7: Función de Análisis de Logs
# ============================================
echo "--- Paso 7: Análisis de Logs ---"

# Función para analizar patrones en logs

# Descomenta las siguientes líneas:
# analyze_log_file() {
#     local log_file="$1"
#     
#     if [[ ! -r "$log_file" ]]; then
#         echo "No se puede leer: $log_file"
#         return 1
#     fi
#     
#     echo "Analizando: $log_file"
#     echo ""
#     
#     local total_lines
#     total_lines=$(wc -l < "$log_file")
#     echo "Total de líneas: $total_lines"
#     
#     local errors
#     errors=$(grep -ci "error" "$log_file" || echo "0")
#     echo "Líneas con 'error': $errors"
#     
#     local warnings
#     warnings=$(grep -ci "warning\|warn" "$log_file" || echo "0")
#     echo "Líneas con 'warning': $warnings"
#     
#     local failed
#     failed=$(grep -ci "failed\|failure" "$log_file" || echo "0")
#     echo "Líneas con 'failed': $failed"
# }
# 
# # Crear log de prueba y analizarlo
# test_log="/tmp/test-analysis.log"
# cat > "$test_log" << 'EOF'
# 2024-01-15 10:00:00 INFO Application started
# 2024-01-15 10:01:00 WARNING High memory usage
# 2024-01-15 10:02:00 ERROR Connection failed
# 2024-01-15 10:03:00 INFO Processing data
# 2024-01-15 10:04:00 ERROR Database timeout
# 2024-01-15 10:05:00 INFO Task completed
# 2024-01-15 10:06:00 WARNING Disk space low
# EOF
# 
# analyze_log_file "$test_log"
# rm -f "$test_log"

echo ""

# ============================================
# PASO 8: Monitoreo de Logs en Tiempo Real
# ============================================
echo "--- Paso 8: Tips de Monitoreo ---"

# Técnicas para monitorear logs

# Descomenta las siguientes líneas:
# echo "Técnicas de monitoreo de logs:"
# echo ""
# echo "1. Seguir logs en tiempo real:"
# echo "   journalctl -f"
# echo "   tail -f /var/log/syslog"
# echo ""
# echo "2. Filtrar mientras sigues:"
# echo "   journalctl -f | grep -i error"
# echo "   tail -f /var/log/syslog | grep --line-buffered error"
# echo ""
# echo "3. Múltiples logs simultáneos:"
# echo "   tail -f /var/log/syslog /var/log/auth.log"
# echo ""
# echo "4. Buscar patrones con contexto:"
# echo "   grep -B2 -A2 'error' /var/log/syslog"
# echo ""
# echo "5. Contar errores por hora:"
# echo "   grep 'error' log.txt | cut -d':' -f1 | uniq -c"

echo ""

echo "========================================"
echo "✅ Práctica 04 completada"
echo "========================================"
echo ""
echo "💡 Tips de logging:"
echo "   - Configura logrotate para rotar logs automáticamente"
echo "   - Centraliza logs críticos con rsyslog o similar"
echo "   - Usa journalctl --vacuum-time=7d para limpiar"
