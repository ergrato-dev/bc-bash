#!/bin/bash
# ============================================
# PROYECTO: Analizador de Logs
# Semana 5: Procesamiento de Texto
# SOLUCIÓN COMPLETA
# ============================================
# Uso: ./log-analyzer.sh <archivo_log> [opciones]
# ============================================

set -euo pipefail

# ============================================
# COLORES Y FORMATO
# ============================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ============================================
# VARIABLES GLOBALES
# ============================================
LOG_FILE=""
OUTPUT_FORMAT="text"

# ============================================
# FUNCIONES DE AYUDA
# ============================================

show_usage() {
    echo "Uso: log-analyzer.sh <archivo_log> [opciones]"
    echo ""
    echo "Opciones:"
    echo "  -l, --level NIVEL    Filtrar por nivel (INFO, WARN, ERROR, CRITICAL)"
    echo "  -u, --user USUARIO   Filtrar por usuario"
    echo "  -i, --ip IP          Filtrar por dirección IP"
    echo "  -s, --summary        Mostrar solo resumen"
    echo "  -c, --csv            Salida en formato CSV"
    echo "  -h, --help           Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  ./log-analyzer.sh server.log"
    echo "  ./log-analyzer.sh server.log -l ERROR"
    echo "  ./log-analyzer.sh server.log -u admin --summary"
}

error_exit() {
    echo -e "${RED}ERROR: $1${NC}" >&2
    exit 1
}

info_msg() {
    echo -e "${BLUE}INFO: $1${NC}"
}

# ============================================
# FUNCIONES DE VALIDACIÓN
# ============================================

validate_file() {
    local file="$1"
    
    if [[ ! -e "$file" ]]; then
        error_exit "El archivo no existe: $file"
        return 1
    fi
    
    if [[ ! -f "$file" ]]; then
        error_exit "No es un archivo regular: $file"
        return 1
    fi
    
    if [[ ! -r "$file" ]]; then
        error_exit "El archivo no es legible: $file"
        return 1
    fi
    
    return 0
}

validate_log_format() {
    local line="$1"
    # Formato: YYYY-MM-DD HH:MM:SS LEVEL [module] ...
    if echo "$line" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} (INFO|WARN|ERROR|CRITICAL)'; then
        return 0
    else
        return 1
    fi
}

# ============================================
# FUNCIONES DE FILTRADO
# ============================================

filter_by_level() {
    local level="$1"
    grep -E "^[0-9-]+ [0-9:]+ ${level} "
}

filter_by_user() {
    local user="$1"
    grep "user=${user}"
}

filter_by_ip() {
    local ip="$1"
    grep "ip=${ip}"
}

# ============================================
# FUNCIONES DE EXTRACCIÓN
# ============================================

extract_field() {
    local field="$1"
    sed -n "s/.*${field}=\([^ ]*\).*/\1/p"
}

extract_timestamp() {
    awk '{print $1, $2}'
}

extract_level() {
    awk '{print $3}'
}

extract_module() {
    awk '{print $4}' | tr -d '[]'
}

# ============================================
# FUNCIONES DE ESTADÍSTICAS
# ============================================

count_by_level() {
    awk '{count[$3]++} END {for (k in count) print k, count[k]}' | sort -k2 -rn
}

stats_by_level() {
    awk '
    {
        total++
        count[$3]++
    }
    END {
        printf "%-10s %8s %8s\n", "NIVEL", "CANTIDAD", "PORCENTAJE"
        printf "%-10s %8s %8s\n", "----------", "--------", "----------"
        for (k in count) {
            pct = (count[k] / total) * 100
            printf "%-10s %8d %7.1f%%\n", k, count[k], pct
        }
        printf "%-10s %8s %8s\n", "----------", "--------", "----------"
        printf "%-10s %8d %8s\n", "TOTAL", total, "100.0%"
    }'
}

top_ips() {
    local n="${1:-5}"
    sed -n 's/.*ip=\([0-9.]*\).*/\1/p' | sort | uniq -c | sort -rn | head -"$n"
}

top_users() {
    local n="${1:-5}"
    sed -n 's/.*user=\([^ ]*\).*/\1/p' | sort | uniq -c | sort -rn | head -"$n"
}

top_errors_by_ip() {
    local n="${1:-5}"
    grep -E "(ERROR|CRITICAL)" | sed -n 's/.*ip=\([0-9.]*\).*/\1/p' | \
        sort | uniq -c | sort -rn | head -"$n"
}

# ============================================
# FUNCIONES DE DETECCIÓN
# ============================================

detect_error_ips() {
    local threshold="${1:-5}"
    echo -e "${YELLOW}--- IPs con múltiples errores (>$threshold) ---${NC}"
    grep -E "(ERROR|CRITICAL)" "$LOG_FILE" | \
        sed -n 's/.*ip=\([0-9.]*\).*/\1/p' | \
        sort | uniq -c | sort -rn | \
        awk -v t="$threshold" '$1 > t {printf "  %-20s %d errores\n", $2, $1}'
}

detect_suspicious_users() {
    echo -e "${YELLOW}--- Usuarios con actividad sospechosa ---${NC}"
    # Buscar usuarios con intentos fallidos de login
    grep -E "(ERROR|CRITICAL).*action=(login|auth|access)" "$LOG_FILE" 2>/dev/null | \
        sed -n 's/.*user=\([^ ]*\).*/\1/p' | \
        sort | uniq -c | sort -rn | \
        awk '$1 > 2 {printf "  %-15s %d intentos fallidos\n", $2, $1}'
}

detect_time_anomalies() {
    echo -e "${YELLOW}--- Actividad por hora ---${NC}"
    awk '{
        split($2, t, ":")
        hour = t[1]
        count[hour]++
    }
    END {
        for (h = 0; h < 24; h++) {
            hstr = sprintf("%02d", h)
            c = count[hstr] ? count[hstr] : 0
            printf "  %s:00 - %s:59: %d eventos\n", hstr, hstr, c
        }
    }' "$LOG_FILE"
}

# ============================================
# FUNCIONES DE REPORTE
# ============================================

generate_summary() {
    local log_file="$1"
    
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║         RESUMEN DE ANÁLISIS DE LOGS                  ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Info básica
    local total_lines
    total_lines=$(wc -l < "$log_file")
    local first_date
    first_date=$(head -1 "$log_file" | awk '{print $1, $2}')
    local last_date
    last_date=$(tail -1 "$log_file" | awk '{print $1, $2}')
    
    echo -e "${CYAN}Archivo:${NC} $log_file"
    echo -e "${CYAN}Período:${NC} $first_date - $last_date"
    echo -e "${CYAN}Total eventos:${NC} $total_lines"
    echo ""
    
    # Estadísticas por nivel
    echo -e "${BLUE}--- Estadísticas por Severidad ---${NC}"
    cat "$log_file" | stats_by_level
    echo ""
    
    # Top 5 IPs
    echo -e "${BLUE}--- Top 5 IPs ---${NC}"
    cat "$log_file" | top_ips 5 | awk '{printf "  %-20s %d requests\n", $2, $1}'
    echo ""
    
    # Top 5 usuarios
    echo -e "${BLUE}--- Top 5 Usuarios ---${NC}"
    cat "$log_file" | top_users 5 | awk '{printf "  %-15s %d eventos\n", $2, $1}'
    echo ""
}

generate_report() {
    local log_file="$1"
    
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║         REPORTE COMPLETO DE ANÁLISIS                 ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Info básica
    local total_lines
    total_lines=$(wc -l < "$log_file")
    local valid_lines
    valid_lines=$(grep -cE '^[0-9]{4}-[0-9]{2}-[0-9]{2}' "$log_file" || echo "0")
    
    echo -e "${CYAN}Archivo:${NC} $log_file"
    echo -e "${CYAN}Total líneas:${NC} $total_lines"
    echo -e "${CYAN}Líneas válidas:${NC} $valid_lines"
    echo ""
    
    # Rango de fechas
    local first_date last_date
    first_date=$(head -1 "$log_file" | awk '{print $1, $2}')
    last_date=$(tail -1 "$log_file" | awk '{print $1, $2}')
    echo -e "${CYAN}Período:${NC} $first_date - $last_date"
    echo ""
    
    # Estadísticas por nivel
    echo -e "${BLUE}═══ ESTADÍSTICAS POR SEVERIDAD ═══${NC}"
    cat "$log_file" | stats_by_level
    echo ""
    
    # Top IPs
    echo -e "${BLUE}═══ TOP 10 IPs ═══${NC}"
    printf "  %-20s %s\n" "IP" "REQUESTS"
    printf "  %-20s %s\n" "--------------------" "--------"
    cat "$log_file" | top_ips 10 | awk '{printf "  %-20s %d\n", $2, $1}'
    echo ""
    
    # Top usuarios
    echo -e "${BLUE}═══ TOP 10 USUARIOS ═══${NC}"
    printf "  %-15s %s\n" "USUARIO" "EVENTOS"
    printf "  %-15s %s\n" "---------------" "-------"
    cat "$log_file" | top_users 10 | awk '{printf "  %-15s %d\n", $2, $1}'
    echo ""
    
    # IPs con errores
    echo -e "${BLUE}═══ TOP 5 IPs CON ERRORES ═══${NC}"
    printf "  %-20s %s\n" "IP" "ERRORES"
    printf "  %-20s %s\n" "--------------------" "-------"
    cat "$log_file" | top_errors_by_ip 5 | awk '{printf "  %-20s %d\n", $2, $1}'
    echo ""
    
    # Detección de anomalías
    echo -e "${BLUE}═══ DETECCIÓN DE ANOMALÍAS ═══${NC}"
    detect_error_ips 3
    echo ""
    detect_suspicious_users
    echo ""
    
    echo -e "${GREEN}═══ FIN DEL REPORTE ═══${NC}"
}

export_csv() {
    local log_file="$1"
    local output_file="${2:-report.csv}"
    
    echo "timestamp,level,module,user,action,ip" > "$output_file"
    
    awk '{
        timestamp = $1 " " $2
        level = $3
        gsub(/[\[\]]/, "", $4)
        module = $4
        
        user = ""
        action = ""
        ip = ""
        
        for (i = 5; i <= NF; i++) {
            if ($i ~ /^user=/) {
                split($i, a, "=")
                user = a[2]
            }
            if ($i ~ /^action=/) {
                split($i, a, "=")
                action = a[2]
            }
            if ($i ~ /^ip=/) {
                split($i, a, "=")
                ip = a[2]
            }
        }
        
        print timestamp "," level "," module "," user "," action "," ip
    }' "$log_file" >> "$output_file"
    
    echo -e "${GREEN}CSV generado: $output_file${NC}"
    echo "Líneas exportadas: $(wc -l < "$output_file")"
}

# ============================================
# FUNCIÓN PRINCIPAL
# ============================================
main() {
    if [[ $# -lt 1 ]]; then
        show_usage
        exit 1
    fi
    
    local filter_level=""
    local filter_user=""
    local filter_ip=""
    local show_summary=false
    local export_csv_flag=false
    
    LOG_FILE="$1"
    shift
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -l|--level)
                filter_level="$2"
                shift 2
                ;;
            -u|--user)
                filter_user="$2"
                shift 2
                ;;
            -i|--ip)
                filter_ip="$2"
                shift 2
                ;;
            -s|--summary)
                show_summary=true
                shift
                ;;
            -c|--csv)
                export_csv_flag=true
                shift
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                error_exit "Opción desconocida: $1"
                ;;
        esac
    done
    
    # Validar archivo
    validate_file "$LOG_FILE"
    
    # Exportar CSV si se solicitó
    if [[ "$export_csv_flag" == true ]]; then
        export_csv "$LOG_FILE"
        exit 0
    fi
    
    # Aplicar filtros si se especificaron
    local temp_file=""
    if [[ -n "$filter_level" ]] || [[ -n "$filter_user" ]] || [[ -n "$filter_ip" ]]; then
        temp_file=$(mktemp)
        cat "$LOG_FILE" > "$temp_file"
        
        if [[ -n "$filter_level" ]]; then
            filter_by_level "$filter_level" < "$temp_file" > "${temp_file}.tmp"
            mv "${temp_file}.tmp" "$temp_file"
        fi
        
        if [[ -n "$filter_user" ]]; then
            filter_by_user "$filter_user" < "$temp_file" > "${temp_file}.tmp"
            mv "${temp_file}.tmp" "$temp_file"
        fi
        
        if [[ -n "$filter_ip" ]]; then
            filter_by_ip "$filter_ip" < "$temp_file" > "${temp_file}.tmp"
            mv "${temp_file}.tmp" "$temp_file"
        fi
        
        LOG_FILE="$temp_file"
    fi
    
    # Generar reporte
    if [[ "$show_summary" == true ]]; then
        generate_summary "$LOG_FILE"
    else
        generate_report "$LOG_FILE"
    fi
    
    # Limpiar archivo temporal
    if [[ -n "$temp_file" ]] && [[ -f "$temp_file" ]]; then
        rm -f "$temp_file"
    fi
}

# Ejecutar si no se está importando
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
