#!/bin/bash
# ============================================
# PROYECTO: Analizador de Logs
# Semana 5: Procesamiento de Texto
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
NC='\033[0m' # No Color

# ============================================
# VARIABLES GLOBALES
# ============================================
LOG_FILE=""
OUTPUT_FORMAT="text"  # text, csv

# ============================================
# FUNCIONES DE AYUDA
# ============================================

# Muestra mensaje de uso
show_usage() {
    cat << 'EOF'
Uso: log-analyzer.sh <archivo_log> [opciones]

Opciones:
  -l, --level NIVEL    Filtrar por nivel (INFO, WARN, ERROR, CRITICAL)
  -u, --user USUARIO   Filtrar por usuario
  -i, --ip IP          Filtrar por dirección IP
  -s, --summary        Mostrar solo resumen
  -c, --csv            Salida en formato CSV
  -h, --help           Mostrar esta ayuda

Ejemplos:
  ./log-analyzer.sh server.log
  ./log-analyzer.sh server.log -l ERROR
  ./log-analyzer.sh server.log -u admin --summary
EOF
}

# Muestra mensaje de error y sale
error_exit() {
    echo -e "${RED}ERROR: $1${NC}" >&2
    exit 1
}

# ============================================
# FUNCIONES DE VALIDACIÓN
# ============================================

# Valida que el archivo existe y es legible
# TODO: Implementar validación
validate_file() {
    local file="$1"
    # TODO: Verificar que el archivo existe
    # TODO: Verificar que es un archivo regular
    # TODO: Verificar que es legible
    return 0
}

# Valida el formato de una línea de log
# Formato esperado: YYYY-MM-DD HH:MM:SS LEVEL [module] campo=valor ...
# TODO: Implementar validación con regex
validate_log_format() {
    local line="$1"
    # TODO: Usar grep -E para validar formato
    # Regex sugerido: ^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}
    return 0
}

# ============================================
# FUNCIONES DE FILTRADO
# ============================================

# Filtra líneas por nivel de severidad
# Parámetros: $1 = nivel (INFO, WARN, ERROR, CRITICAL)
# TODO: Implementar con grep
filter_by_level() {
    local level="$1"
    # TODO: Usar grep para filtrar líneas con el nivel especificado
    # Tip: El nivel aparece como tercer campo
    cat
}

# Filtra líneas por usuario
# Parámetros: $1 = nombre de usuario
# TODO: Implementar con grep
filter_by_user() {
    local user="$1"
    # TODO: Buscar user=$user en las líneas
    cat
}

# Filtra líneas por dirección IP
# Parámetros: $1 = dirección IP
# TODO: Implementar con grep
filter_by_ip() {
    local ip="$1"
    # TODO: Buscar ip=$ip en las líneas
    cat
}

# ============================================
# FUNCIONES DE EXTRACCIÓN
# ============================================

# Extrae un campo específico de las líneas
# Parámetros: $1 = nombre del campo (user, ip, action, etc.)
# TODO: Implementar con sed o awk
extract_field() {
    local field="$1"
    # TODO: Extraer valor después de campo=
    # Tip: sed 's/.*field=\([^ ]*\).*/\1/'
    cat
}

# Extrae el timestamp de las líneas
# TODO: Implementar con awk
extract_timestamp() {
    # TODO: Extraer campos 1 y 2 (fecha y hora)
    cat
}

# Extrae el nivel de severidad
# TODO: Implementar con awk
extract_level() {
    # TODO: Extraer campo 3
    cat
}

# ============================================
# FUNCIONES DE ESTADÍSTICAS
# ============================================

# Cuenta ocurrencias por campo
# Parámetros: $1 = número de campo o nombre
# TODO: Implementar con awk y sort
count_by_field() {
    local field="$1"
    # TODO: Contar ocurrencias únicas del campo
    # Tip: awk '{count[$campo]++} END {for (k in count) print k, count[k]}'
    cat
}

# Genera estadísticas de niveles
# TODO: Implementar con awk
stats_by_level() {
    # TODO: Contar líneas por nivel y calcular porcentajes
    echo "Estadísticas por nivel:"
}

# Encuentra los top N por campo
# Parámetros: $1 = campo, $2 = número (default 5)
# TODO: Implementar con sort y head
top_by_field() {
    local field="$1"
    local n="${2:-5}"
    # TODO: Ordenar por conteo y mostrar top N
    cat
}

# ============================================
# FUNCIONES DE DETECCIÓN
# ============================================

# Detecta IPs con muchos errores
# Parámetros: $1 = umbral (default 10)
# TODO: Implementar pipeline completo
detect_error_ips() {
    local threshold="${1:-10}"
    # TODO: Filtrar errores, extraer IPs, contar, filtrar por umbral
    echo "IPs con errores:"
}

# Detecta usuarios con actividad sospechosa
# TODO: Implementar pipeline completo
detect_suspicious_users() {
    # TODO: Buscar patrones como múltiples fallos de login
    echo "Usuarios sospechosos:"
}

# ============================================
# FUNCIONES DE REPORTE
# ============================================

# Genera resumen del análisis
# TODO: Implementar reporte completo
generate_summary() {
    local log_file="$1"
    
    echo "=== RESUMEN DE ANÁLISIS DE LOGS ==="
    echo "Archivo: $log_file"
    echo ""
    
    # TODO: Total de líneas
    # TODO: Rango de fechas
    # TODO: Estadísticas por nivel
    # TODO: Top IPs
    # TODO: Top usuarios
}

# Genera reporte completo
# TODO: Implementar
generate_report() {
    local log_file="$1"
    
    echo "=== REPORTE COMPLETO DE ANÁLISIS ==="
    echo ""
    
    # TODO: Llamar a las funciones de estadísticas
    # TODO: Llamar a las funciones de detección
    # TODO: Formatear salida
}

# Exporta resultados a CSV
# TODO: Implementar
export_csv() {
    local log_file="$1"
    local output_file="${2:-report.csv}"
    
    # TODO: Generar CSV con estadísticas
    echo "CSV generado: $output_file"
}

# ============================================
# FUNCIÓN PRINCIPAL
# ============================================
main() {
    # Parsear argumentos
    if [[ $# -lt 1 ]]; then
        show_usage
        exit 1
    fi
    
    local filter_level=""
    local filter_user=""
    local filter_ip=""
    local show_summary=false
    
    # TODO: Implementar parseo de argumentos
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
                OUTPUT_FORMAT="csv"
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
    validate_file "$LOG_FILE" || error_exit "Archivo inválido: $LOG_FILE"
    
    # Procesar según opciones
    if [[ "$show_summary" == true ]]; then
        generate_summary "$LOG_FILE"
    else
        generate_report "$LOG_FILE"
    fi
}

# Ejecutar si no se está importando
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
