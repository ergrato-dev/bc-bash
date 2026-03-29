#!/bin/bash
# Ejemplo 02: Monitor de Sistema
# Descripción: Monitoreo de recursos y alertas

set -euo pipefail

# === Configuración ===
readonly CPU_THRESHOLD=80
readonly MEM_THRESHOLD=80
readonly DISK_THRESHOLD=85
readonly CHECK_INTERVAL=5
readonly LOG_FILE="monitor.log"

# Colores para output
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly GREEN='\033[0;32m'
readonly NC='\033[0m' # No Color

# === Funciones de Logging ===
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

alerta() {
    echo -e "${RED}[ALERTA]${NC} $*" | tee -a "$LOG_FILE"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*" | tee -a "$LOG_FILE"
}

ok() {
    echo -e "${GREEN}[OK]${NC} $*"
}

# === Funciones de Monitoreo ===

obtener_uso_cpu() {
    # Diferentes métodos según disponibilidad
    if command -v top &> /dev/null; then
        # Linux
        top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}'
    elif command -v ps &> /dev/null; then
        # MacOS / BSD
        ps -A -o %cpu | awk '{s+=$1} END {print s}'
    else
        echo "0"
    fi
}

obtener_uso_memoria() {
    if command -v free &> /dev/null; then
        # Linux
        free | grep Mem | awk '{printf "%.0f", $3/$2 * 100.0}'
    elif command -v vm_stat &> /dev/null; then
        # MacOS
        vm_stat | awk '/Pages active/ {active=$3} /Pages free/ {free=$3} /Pages wired/ {wired=$3} END {printf "%.0f", (active+wired)/(active+free+wired) * 100}'
    else
        echo "0"
    fi
}

obtener_uso_disco() {
    df -h / | awk 'NR==2 {print $5}' | sed 's/%//'
}

obtener_carga_sistema() {
    uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//'
}

obtener_procesos_top() {
    local limite=${1:-5}
    
    echo "=== Top $limite Procesos por CPU ==="
    ps aux --sort=-%cpu | head -n $((limite + 1))
}

obtener_procesos_memoria() {
    local limite=${1:-5}
    
    echo "=== Top $limite Procesos por Memoria ==="
    ps aux --sort=-%mem | head -n $((limite + 1))
}

# === Verificaciones ===

verificar_cpu() {
    local uso=$(obtener_uso_cpu)
    local uso_int=${uso%.*}
    
    if [ "$uso_int" -ge "$CPU_THRESHOLD" ]; then
        alerta "CPU al ${uso}% (umbral: ${CPU_THRESHOLD}%)"
        return 1
    elif [ "$uso_int" -ge $((CPU_THRESHOLD - 10)) ]; then
        warning "CPU al ${uso}% (cerca del umbral)"
        return 0
    else
        ok "CPU: ${uso}%"
        return 0
    fi
}

verificar_memoria() {
    local uso=$(obtener_uso_memoria)
    
    if [ "$uso" -ge "$MEM_THRESHOLD" ]; then
        alerta "Memoria al ${uso}% (umbral: ${MEM_THRESHOLD}%)"
        return 1
    elif [ "$uso" -ge $((MEM_THRESHOLD - 10)) ]; then
        warning "Memoria al ${uso}% (cerca del umbral)"
        return 0
    else
        ok "Memoria: ${uso}%"
        return 0
    fi
}

verificar_disco() {
    local uso=$(obtener_uso_disco)
    
    if [ "$uso" -ge "$DISK_THRESHOLD" ]; then
        alerta "Disco al ${uso}% (umbral: ${DISK_THRESHOLD}%)"
        return 1
    elif [ "$uso" -ge $((DISK_THRESHOLD - 10)) ]; then
        warning "Disco al ${uso}% (cerca del umbral)"
        return 0
    else
        ok "Disco: ${uso}%"
        return 0
    fi
}

# === Reporte Completo ===

generar_reporte() {
    echo ""
    echo "╔════════════════════════════════════════════╗"
    echo "║     REPORTE DE MONITOREO DE SISTEMA       ║"
    echo "╚════════════════════════════════════════════╝"
    echo ""
    
    echo "🖥️  Uso de Recursos:"
    echo "   CPU: $(obtener_uso_cpu)%"
    echo "   Memoria: $(obtener_uso_memoria)%"
    echo "   Disco: $(obtener_uso_disco)%"
    echo "   Carga: $(obtener_carga_sistema)"
    echo ""
    
    verificar_cpu
    verificar_memoria
    verificar_disco
    
    echo ""
    echo "📊 Información del Sistema:"
    echo "   Uptime: $(uptime -p 2>/dev/null || uptime | awk '{print $3}')"
    echo "   Usuarios: $(who | wc -l)"
    echo ""
}

# === Modo Continuo ===

modo_monitor_continuo() {
    log "Iniciando monitoreo continuo (intervalo: ${CHECK_INTERVAL}s)"
    log "Presiona Ctrl+C para detener"
    
    while true; do
        clear
        generar_reporte
        sleep "$CHECK_INTERVAL"
    done
}

# === Main ===

main() {
    local modo=${1:-single}
    
    case "$modo" in
        continuous|continuo|-c)
            modo_monitor_continuo
            ;;
        report|reporte|-r)
            generar_reporte
            ;;
        *)
            generar_reporte
            echo "💡 Uso: $0 [continuous|report]"
            ;;
    esac
}

# Ejecutar
main "$@"
