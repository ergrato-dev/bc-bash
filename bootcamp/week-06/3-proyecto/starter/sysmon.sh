#!/bin/bash
# ============================================
# PROYECTO: SysMon - Sistema de Monitoreo
# Semana 6 - Herramientas del Sistema
# ============================================
# 
# Uso: ./sysmon.sh [comando] [opciones]
# 
# Comandos:
#   status     Mostrar estado general del sistema
#   processes  Listar procesos principales
#   alerts     Verificar alertas activas
#   watch      Monitoreo en tiempo real
#   report     Generar reporte
#   services   Estado de servicios
#   help       Mostrar ayuda
#
# ============================================

set -euo pipefail

# ============================================
# CONFIGURACIÓN
# ============================================

# Colores
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Umbrales de alerta (personalizar según necesidades)
readonly DISK_THRESHOLD=80
readonly MEM_THRESHOLD=90
readonly LOAD_THRESHOLD_MULTIPLIER=1.5

# Archivo de configuración (opcional)
readonly CONFIG_FILE="${HOME}/.sysmon.conf"

# ============================================
# FUNCIONES DE UTILIDAD
# ============================================

print_header() {
    local title="$1"
    echo -e "${CYAN}========================================"
    echo -e "  $title"
    echo -e "========================================${NC}"
}

print_section() {
    local title="$1"
    echo -e "${BLUE}--- $title ---${NC}"
}

print_ok() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}🔴 $1${NC}"
}

# ============================================
# COMANDO: status
# Muestra estado general del sistema
# ============================================
cmd_status() {
    print_header "ESTADO DEL SISTEMA"
    echo ""
    
    # Información básica
    echo "Host: $(hostname)"
    echo "Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "Uptime: $(uptime -p 2>/dev/null || uptime | cut -d',' -f1 | cut -d' ' -f4-)"
    echo ""
    
    # TODO: Implementar sección de DISCO
    # Mostrar uso de cada partición
    # Usar df -h y formatear la salida
    print_section "DISCO"
    echo "TODO: Implementar métricas de disco"
    echo ""
    
    # TODO: Implementar sección de MEMORIA
    # Mostrar RAM total, usada, disponible
    # Mostrar Swap si está disponible
    print_section "MEMORIA"
    echo "TODO: Implementar métricas de memoria"
    echo ""
    
    # TODO: Implementar sección de CPU
    # Mostrar número de CPUs
    # Mostrar load average
    print_section "CPU"
    echo "TODO: Implementar métricas de CPU"
    echo ""
}

# ============================================
# COMANDO: processes
# Lista los procesos principales
# ============================================
cmd_processes() {
    print_header "PROCESOS DEL SISTEMA"
    echo ""
    
    # TODO: Implementar Top 5 por CPU
    # Usar ps aux --sort=-%cpu
    print_section "Top 5 por CPU"
    echo "TODO: Implementar lista de procesos por CPU"
    echo ""
    
    # TODO: Implementar Top 5 por Memoria
    # Usar ps aux --sort=-%mem
    print_section "Top 5 por Memoria"
    echo "TODO: Implementar lista de procesos por memoria"
    echo ""
    
    # TODO: Implementar detección de zombies
    # Buscar procesos con estado Z
    print_section "Procesos Zombie"
    echo "TODO: Implementar detección de zombies"
    echo ""
}

# ============================================
# COMANDO: alerts
# Verifica alertas activas
# ============================================
cmd_alerts() {
    print_header "VERIFICACIÓN DE ALERTAS"
    echo ""
    
    local alert_count=0
    
    # TODO: Verificar disco
    # Si uso > DISK_THRESHOLD, mostrar alerta
    print_section "Disco"
    echo "TODO: Implementar verificación de disco"
    echo ""
    
    # TODO: Verificar memoria
    # Si uso > MEM_THRESHOLD, mostrar alerta
    print_section "Memoria"
    echo "TODO: Implementar verificación de memoria"
    echo ""
    
    # TODO: Verificar load average
    # Si load > CPUs * LOAD_THRESHOLD_MULTIPLIER, alerta
    print_section "CPU Load"
    echo "TODO: Implementar verificación de load"
    echo ""
    
    # TODO: Resumen de alertas
    echo ""
    if [[ $alert_count -eq 0 ]]; then
        print_ok "Sistema saludable - Sin alertas activas"
    else
        print_error "$alert_count alerta(s) activa(s)"
    fi
}

# ============================================
# COMANDO: watch
# Monitoreo en tiempo real
# ============================================
cmd_watch() {
    local interval="${1:-5}"
    
    print_header "MONITOREO EN TIEMPO REAL"
    echo "Actualizando cada $interval segundos..."
    echo "Presiona Ctrl+C para salir"
    echo ""
    
    # TODO: Implementar loop de monitoreo
    # Usar while true con sleep
    # Limpiar pantalla con clear
    # Mostrar métricas actualizadas
    
    echo "TODO: Implementar modo watch"
    echo ""
    echo "Sugerencia de implementación:"
    echo "  while true; do"
    echo "      clear"
    echo "      cmd_status"
    echo "      sleep \$interval"
    echo "  done"
}

# ============================================
# COMANDO: report
# Genera reporte del sistema
# ============================================
cmd_report() {
    local format="${1:-text}"
    local output_file="/tmp/sysmon-report-$(date +%Y%m%d-%H%M%S)"
    
    print_header "GENERANDO REPORTE"
    echo ""
    
    case "$format" in
        text)
            output_file="${output_file}.txt"
            # TODO: Generar reporte en texto plano
            echo "TODO: Implementar reporte texto"
            ;;
        json)
            output_file="${output_file}.json"
            # TODO: Generar reporte en JSON
            echo "TODO: Implementar reporte JSON"
            ;;
        html)
            output_file="${output_file}.html"
            # TODO: Generar reporte en HTML
            echo "TODO: Implementar reporte HTML"
            ;;
        *)
            print_error "Formato no soportado: $format"
            echo "Formatos disponibles: text, json, html"
            return 1
            ;;
    esac
    
    echo ""
    echo "Reporte generado: $output_file"
}

# ============================================
# COMANDO: services
# Estado de servicios del sistema
# ============================================
cmd_services() {
    print_header "ESTADO DE SERVICIOS"
    echo ""
    
    # Lista de servicios a verificar
    local services=("ssh" "cron" "systemd-journald")
    
    # TODO: Implementar verificación de servicios
    # Para cada servicio, mostrar si está activo
    # Usar systemctl is-active
    
    for service in "${services[@]}"; do
        echo "TODO: Verificar servicio $service"
    done
    
    echo ""
    
    # TODO: Mostrar servicios fallidos
    print_section "Servicios Fallidos"
    echo "TODO: Listar servicios fallidos"
}

# ============================================
# COMANDO: help
# Muestra ayuda del programa
# ============================================
cmd_help() {
    cat << 'EOF'
SysMon - Sistema de Monitoreo de Sistema

Uso: ./sysmon.sh [comando] [opciones]

Comandos disponibles:
  status              Mostrar estado general del sistema
  processes           Listar procesos principales (CPU, memoria, zombies)
  alerts              Verificar alertas activas según umbrales
  watch [segundos]    Monitoreo en tiempo real (default: 5s)
  report [formato]    Generar reporte (text|json|html)
  services            Estado de servicios del sistema
  help                Mostrar esta ayuda

Ejemplos:
  ./sysmon.sh status
  ./sysmon.sh watch 10
  ./sysmon.sh report json
  ./sysmon.sh alerts

Configuración:
  Los umbrales de alerta se pueden personalizar editando
  las variables al inicio del script o creando ~/.sysmon.conf

Umbrales por defecto:
  - Disco: 80%
  - Memoria: 90%
  - Load: 1.5x número de CPUs

EOF
}

# ============================================
# MAIN - Procesamiento de argumentos
# ============================================
main() {
    local command="${1:-help}"
    shift || true
    
    case "$command" in
        status)
            cmd_status
            ;;
        processes|procs|ps)
            cmd_processes
            ;;
        alerts|check)
            cmd_alerts
            ;;
        watch|monitor)
            cmd_watch "$@"
            ;;
        report)
            cmd_report "$@"
            ;;
        services|svc)
            cmd_services
            ;;
        help|--help|-h)
            cmd_help
            ;;
        *)
            print_error "Comando desconocido: $command"
            echo "Usa './sysmon.sh help' para ver comandos disponibles"
            exit 1
            ;;
    esac
}

# Ejecutar main con todos los argumentos
main "$@"
