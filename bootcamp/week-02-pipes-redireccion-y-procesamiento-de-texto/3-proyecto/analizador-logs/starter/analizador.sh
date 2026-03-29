#!/bin/bash
# ============================================
# PROYECTO: Analizador de Logs
# Semana 02 - Bash Bootcamp
# ============================================
# Descripción: Herramienta para analizar logs de servidor
#              web y generar estadísticas.
#
# Uso: ./analizador.sh <archivo_log>
# ============================================
set -euo pipefail

# ============================================
# COLORES (opcional)
# ============================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# ============================================
# FUNCIONES DE UTILIDAD
# ============================================

# Muestra mensaje de error y sale
# Parámetros:
#   $1 - Mensaje de error
error_exit() {
    echo -e "${RED}ERROR: $1${NC}" >&2
    exit 1
}

# Muestra el uso del script
show_usage() {
    echo "Uso: $0 <archivo_log>"
    echo ""
    echo "Analiza un archivo de log de servidor web y genera estadísticas."
    echo ""
    echo "Ejemplo:"
    echo "  $0 access.log"
    echo "  $0 /var/log/nginx/access.log"
}

# Imprime un separador
print_separator() {
    echo "════════════════════════════════════════════════════════"
}

# Imprime un título de sección
# Parámetros:
#   $1 - Título de la sección
print_section() {
    echo ""
    echo -e "${CYAN}${BOLD}📊 $1${NC}"
    print_separator
}

# ============================================
# FUNCIONES DE ANÁLISIS
# ============================================

# Cuenta el total de peticiones en el log
# Parámetros:
#   $1 - Archivo de log
# Salida:
#   Número total de líneas/peticiones
count_total_requests() {
    local log_file="$1"
    # TODO: Implementar usando wc -l
    echo "0"
}

# Cuenta peticiones por código HTTP
# Parámetros:
#   $1 - Archivo de log
# Salida:
#   Lista de códigos HTTP con sus conteos
count_by_http_code() {
    local log_file="$1"
    # TODO: Implementar usando awk para extraer columna 9,
    #       luego sort | uniq -c | sort -rn
    echo "  Sin implementar"
}

# Obtiene las top N IPs con más peticiones
# Parámetros:
#   $1 - Archivo de log
#   $2 - Número de resultados (default: 10)
# Salida:
#   Lista de IPs con sus conteos
top_ips() {
    local log_file="$1"
    local limit="${2:-10}"
    # TODO: Implementar usando awk '{print $1}',
    #       luego sort | uniq -c | sort -rn | head -$limit
    echo "  Sin implementar"
}

# Obtiene los top N recursos más solicitados
# Parámetros:
#   $1 - Archivo de log
#   $2 - Número de resultados (default: 10)
# Salida:
#   Lista de recursos con sus conteos
top_resources() {
    local log_file="$1"
    local limit="${2:-10}"
    # TODO: Implementar usando awk '{print $7}',
    #       luego sort | uniq -c | sort -rn | head -$limit
    echo "  Sin implementar"
}

# Cuenta peticiones por hora
# Parámetros:
#   $1 - Archivo de log
# Salida:
#   Distribución de peticiones por hora (00-23)
requests_by_hour() {
    local log_file="$1"
    # TODO: Implementar extrayendo la hora del timestamp
    #       Pista: awk -F'[:]' '{print $2}' extrae después de :
    #       O usar: grep -oE '[0-9]{2}:[0-9]{2}:[0-9]{2}' | cut -d: -f1
    echo "  Sin implementar"
}

# Calcula el total de bytes transferidos
# Parámetros:
#   $1 - Archivo de log
# Salida:
#   Total de bytes (y versión legible en KB/MB/GB)
total_bytes_transferred() {
    local log_file="$1"
    # TODO: Implementar usando awk para sumar columna 10
    #       awk '{sum += $10} END {print sum}'
    echo "0"
}

# Convierte bytes a formato legible
# Parámetros:
#   $1 - Número de bytes
# Salida:
#   Formato legible (KB, MB, GB)
format_bytes() {
    local bytes="$1"
    # TODO: Implementar conversión
    #       if bytes > 1073741824 -> GB
    #       elif bytes > 1048576 -> MB
    #       elif bytes > 1024 -> KB
    #       else -> bytes
    echo "$bytes bytes"
}

# Cuenta peticiones exitosas vs errores
# Parámetros:
#   $1 - Archivo de log
# Salida:
#   Resumen de éxitos (2xx) y errores (4xx, 5xx)
success_vs_errors() {
    local log_file="$1"
    # TODO: Implementar usando grep o awk
    #       Éxitos: código empieza con 2
    #       Errores cliente: código empieza con 4
    #       Errores servidor: código empieza con 5
    echo "  Sin implementar"
}

# ============================================
# FUNCIÓN PRINCIPAL
# ============================================

generate_report() {
    local log_file="$1"

    echo ""
    echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}${BOLD}║          REPORTE DE ANÁLISIS DE LOGS                 ║${NC}"
    echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "📁 Archivo: ${YELLOW}$log_file${NC}"
    echo -e "📅 Fecha:   $(date '+%Y-%m-%d %H:%M:%S')"

    # Estadísticas generales
    print_section "RESUMEN GENERAL"
    local total
    total=$(count_total_requests "$log_file")
    echo -e "  Total de peticiones: ${BOLD}$total${NC}"

    local bytes
    bytes=$(total_bytes_transferred "$log_file")
    echo -e "  Bytes transferidos:  ${BOLD}$(format_bytes "$bytes")${NC}"

    # Códigos HTTP
    print_section "PETICIONES POR CÓDIGO HTTP"
    count_by_http_code "$log_file"

    # Top IPs
    print_section "TOP 10 IPs CON MÁS PETICIONES"
    top_ips "$log_file" 10

    # Top Recursos
    print_section "TOP 10 RECURSOS MÁS SOLICITADOS"
    top_resources "$log_file" 10

    # Distribución por hora
    print_section "DISTRIBUCIÓN POR HORA"
    requests_by_hour "$log_file"

    # Resumen éxitos/errores
    print_section "ÉXITOS VS ERRORES"
    success_vs_errors "$log_file"

    echo ""
    print_separator
    echo -e "${GREEN}✅ Reporte completado${NC}"
    echo ""
}

# ============================================
# VALIDACIÓN Y EJECUCIÓN
# ============================================

main() {
    # Verificar argumentos
    if [[ $# -eq 0 ]]; then
        show_usage
        exit 1
    fi

    # Verificar si es ayuda
    if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
        show_usage
        exit 0
    fi

    local log_file="$1"

    # TODO: Validar que el archivo existe
    # Pista: if [[ ! -f "$log_file" ]]; then ...

    # TODO: Validar que el archivo es legible
    # Pista: if [[ ! -r "$log_file" ]]; then ...

    # TODO: Validar que el archivo no está vacío
    # Pista: if [[ ! -s "$log_file" ]]; then ...

    # Generar reporte
    generate_report "$log_file"
}

# Ejecutar
main "$@"
