#!/bin/bash
# Ejemplo: Análisis de Archivos de Log
# Módulo: 5
# Objetivo: Demostrar técnicas de análisis y procesamiento de logs

set -euo pipefail

# Colores para output
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly MAGENTA='\033[0;35m'
readonly RED='\033[0;31m'
readonly NC='\033[0m' # No Color

# Función para mostrar títulos
show_title() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

# Función para mostrar comandos
show_command() {
    echo -e "${YELLOW}$ $1${NC}"
    eval "$1"
}

# Función para mostrar resultados
show_result() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Función para mostrar información
show_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

# Función para mostrar alertas
show_alert() {
    echo -e "${RED}⚠️  $1${NC}"
}

echo -e "${BLUE}📊 MÓDULO 5: ANÁLISIS DE LOGS${NC}"
echo "=================================================="

# Verificar archivo de log o crearlo
check_log_file() {
    if [[ ! -f "../data/servidor.log" ]]; then
        echo -e "${YELLOW}Creando archivo de log de ejemplo...${NC}"
        mkdir -p ../data
        
        cat > ../data/servidor.log << 'EOF'
192.168.1.100 - - [24/Dec/2023:10:30:15 +0000] "GET /api/users HTTP/1.1" 200 1024 "-" "Mozilla/5.0"
192.168.1.101 - - [24/Dec/2023:10:30:16 +0000] "POST /api/login HTTP/1.1" 200 256 "-" "curl/7.68.0"
192.168.1.102 - - [24/Dec/2023:10:30:17 +0000] "GET /dashboard HTTP/1.1" 200 4096 "-" "Mozilla/5.0"
192.168.1.100 - - [24/Dec/2023:10:30:18 +0000] "GET /api/products HTTP/1.1" 200 2048 "-" "Mozilla/5.0"
192.168.1.103 - - [24/Dec/2023:10:30:19 +0000] "POST /api/users HTTP/1.1" 201 512 "-" "PostmanRuntime/7.28.0"
192.168.1.104 - - [24/Dec/2023:10:30:20 +0000] "GET /login HTTP/1.1" 404 128 "-" "Mozilla/5.0"
192.168.1.105 - - [24/Dec/2023:10:30:21 +0000] "GET /api/orders HTTP/1.1" 200 1536 "-" "curl/7.68.0"
192.168.1.100 - - [24/Dec/2023:10:30:22 +0000] "DELETE /api/users/123 HTTP/1.1" 200 64 "-" "Mozilla/5.0"
192.168.1.106 - - [24/Dec/2023:10:30:23 +0000] "GET /admin HTTP/1.1" 403 256 "-" "Mozilla/5.0"
192.168.1.107 - - [24/Dec/2023:10:30:24 +0000] "POST /api/login HTTP/1.1" 401 128 "-" "curl/7.68.0"
192.168.1.108 - - [24/Dec/2023:10:30:25 +0000] "GET /api/stats HTTP/1.1" 200 3072 "-" "PostmanRuntime/7.28.0"
192.168.1.109 - - [24/Dec/2023:10:30:26 +0000] "PUT /api/users/456 HTTP/1.1" 200 512 "-" "Mozilla/5.0"
192.168.1.110 - - [24/Dec/2023:10:30:27 +0000] "GET /health HTTP/1.1" 500 1024 "-" "curl/7.68.0"
192.168.1.100 - - [24/Dec/2023:10:30:28 +0000] "GET /api/users/789 HTTP/1.1" 200 256 "-" "Mozilla/5.0"
192.168.1.111 - - [24/Dec/2023:10:30:29 +0000] "POST /api/feedback HTTP/1.1" 201 128 "-" "PostmanRuntime/7.28.0"
EOF
        
        show_result "Archivo de log de ejemplo creado"
    fi
}

# 1. PREPARACIÓN Y EXPLORACIÓN
show_title "1. EXPLORACIÓN DEL LOG"

check_log_file

show_info "Archivo de log: ../data/servidor.log"
show_command "head -5 ../data/servidor.log"

echo
show_info "Estadísticas básicas del archivo:"
show_command "wc -l ../data/servidor.log"
show_command "du -h ../data/servidor.log"

echo

# 2. ANÁLISIS DE IPs
show_title "2. ANÁLISIS DE DIRECCIONES IP"

show_info "IPs más activas (Top 5):"
show_command "awk '{print \$1}' ../data/servidor.log | sort | uniq -c | sort -nr | head -5"

echo
show_info "Total de IPs únicas:"
show_command "awk '{print \$1}' ../data/servidor.log | sort -u | wc -l"

echo
show_info "Distribución de requests por IP:"
show_command "awk '{ip[\$1]++} END {for(i in ip) printf \"%-15s: %3d requests\\n\", i, ip[i]}' ../data/servidor.log | sort -k3 -nr"

echo

# 3. ANÁLISIS DE CÓDIGOS DE ESTADO
show_title "3. ANÁLISIS DE CÓDIGOS DE ESTADO"

show_info "Distribución de códigos de estado:"
show_command "awk '{print \$9}' ../data/servidor.log | sort | uniq -c | sort -nr"

echo
show_info "Requests exitosos (2xx):"
show_command "awk '\$9 ~ /^2/ {count++} END {print \"Requests exitosos:\", count+0}' ../data/servidor.log"

echo
show_info "Errores de cliente (4xx):"
show_command "awk '\$9 ~ /^4/ {print \$1, \$7, \$9}' ../data/servidor.log"

echo
show_info "Errores de servidor (5xx):"
show_command "awk '\$9 ~ /^5/ {print \$1, \$7, \$9}' ../data/servidor.log"

echo

# 4. ANÁLISIS DE ENDPOINTS
show_title "4. ANÁLISIS DE ENDPOINTS"

show_info "Endpoints más solicitados:"
show_command "awk '{print \$7}' ../data/servidor.log | sort | uniq -c | sort -nr"

echo
show_info "Métodos HTTP utilizados:"
show_command "awk '{print \$6}' ../data/servidor.log | sed 's/\"//g' | sort | uniq -c | sort -nr"

echo
show_info "APIs más utilizadas:"
show_command "grep '/api/' ../data/servidor.log | awk '{print \$7}' | sort | uniq -c | sort -nr"

echo

# 5. ANÁLISIS TEMPORAL
show_title "5. ANÁLISIS TEMPORAL"

show_info "Actividad por minuto:"
show_command "awk '{print \$4}' ../data/servidor.log | sed 's/\\[//g' | cut -d: -f2-3 | sort | uniq -c"

echo
show_info "Distribución horaria:"
show_command "awk '{print \$4}' ../data/servidor.log | sed 's/.*://; s/\\].*//' | sort | uniq -c"

echo

# 6. ANÁLISIS DE USER AGENTS
show_title "6. ANÁLISIS DE USER AGENTS"

show_info "User Agents únicos:"
show_command "awk -F'\"' '{print \$6}' ../data/servidor.log | sort -u"

echo
show_info "Distribución por tipo de cliente:"
show_command "awk -F'\"' '{print \$6}' ../data/servidor.log | sort | uniq -c | sort -nr"

echo

# 7. ANÁLISIS DE TAMAÑO DE RESPUESTA
show_title "7. ANÁLISIS DE TAMAÑO DE RESPUESTA"

show_info "Tamaños de respuesta:"
show_command "awk '{print \$10}' ../data/servidor.log | sort -n"

echo
show_info "Estadísticas de tamaño:"
show_command "awk '{sum+=\$10; count++; if(\$10>max) max=\$10; if(min==\"\" || \$10<min) min=\$10} END {printf \"Total: %d bytes\\nPromedio: %.0f bytes\\nMínimo: %d bytes\\nMáximo: %d bytes\\n\", sum, sum/count, min, max}' ../data/servidor.log"

echo

# 8. DETECCIÓN DE PATRONES SOSPECHOSOS
show_title "8. DETECCIÓN DE PATRONES SOSPECHOSOS"

show_info "Intentos de acceso no autorizado (403, 401):"
show_command "awk '\$9 == 403 || \$9 == 401 {printf \"%-15s | %-25s | %s\\n\", \$1, \$7, \$9}' ../data/servidor.log"

echo
show_info "Errores 404 (recursos no encontrados):"
show_command "awk '\$9 == 404 {print \$1, \$7}' ../data/servidor.log"

echo
show_info "IPs con múltiples tipos de error:"
show_command "awk '\$9 >= 400 {errors[\$1]++} END {for(ip in errors) if(errors[ip] > 1) printf \"%-15s: %d errores\\n\", ip, errors[ip]}' ../data/servidor.log"

echo

# 9. REPORTES CUSTOMIZADOS
show_title "9. REPORTES CUSTOMIZADOS"

show_info "Creando reporte de seguridad:"

cat << 'EOF' > reporte_seguridad.txt
REPORTE DE SEGURIDAD - ANÁLISIS DE LOGS
=======================================

RESUMEN EJECUTIVO:
EOF

# Añadir estadísticas al reporte
awk '
BEGIN {
    total = 0
    errores_4xx = 0
    errores_5xx = 0
    exitos = 0
}
{
    total++
    if($9 ~ /^2/) exitos++
    else if($9 ~ /^4/) errores_4xx++
    else if($9 ~ /^5/) errores_5xx++
    
    ips[$1]++
    if($9 >= 400) ips_problema[$1]++
}
END {
    printf "Total de requests: %d\n", total
    printf "Requests exitosos: %d (%.1f%%)\n", exitos, exitos*100/total
    printf "Errores de cliente (4xx): %d (%.1f%%)\n", errores_4xx, errores_4xx*100/total
    printf "Errores de servidor (5xx): %d (%.1f%%)\n", errores_5xx, errores_5xx*100/total
    printf "IPs únicas: %d\n", length(ips)
    printf "IPs problemáticas: %d\n", length(ips_problema)
    
    print "\nIPs MÁS ACTIVAS:"
    # Esta parte sería más compleja de hacer solo con awk, así que la manejamos por separado
}' ../data/servidor.log >> reporte_seguridad.txt

# Añadir IPs más activas
echo -e "\nTOP 5 IPs MÁS ACTIVAS:" >> reporte_seguridad.txt
awk '{print $1}' ../data/servidor.log | sort | uniq -c | sort -nr | head -5 >> reporte_seguridad.txt

# Añadir endpoints problemáticos
echo -e "\nENDPOINTS CON ERRORES:" >> reporte_seguridad.txt
awk '$9 >= 400 {print $7, $9}' ../data/servidor.log | sort | uniq -c | sort -nr >> reporte_seguridad.txt

show_command "cat reporte_seguridad.txt"

echo

# 10. MONITOREO EN TIEMPO REAL (SIMULADO)
show_title "10. SCRIPTS DE MONITOREO"

show_info "Crear script de monitoreo de errores:"

cat << 'EOF' > monitor_errores.sh
#!/bin/bash
# Script de monitoreo de errores en logs

LOG_FILE="../data/servidor.log"
THRESHOLD=3

echo "🔍 MONITOR DE ERRORES - $(date)"
echo "=================================="

# Contar errores por IP en las últimas líneas
tail -10 "$LOG_FILE" | awk '
$9 >= 400 {
    printf "⚠️  ERROR %s desde %s en %s\n", $9, $1, $7
    errors[$1]++
}
END {
    for(ip in errors) {
        if(errors[ip] >= '$THRESHOLD') {
            printf "🚨 ALERTA: IP %s con %d errores\n", ip, errors[ip]
        }
    }
}'

# Detectar patrones de ataque
echo -e "\n🛡️  DETECCIÓN DE PATRONES:"
tail -10 "$LOG_FILE" | awk '
$7 ~ /admin|login|config/ && $9 >= 400 {
    printf "🔒 Posible intento de acceso: %s -> %s (%s)\n", $1, $7, $9
}
'
EOF

chmod +x monitor_errores.sh
show_result "Script de monitoreo creado"

show_command "./monitor_errores.sh"

echo

# 11. FILTROS AVANZADOS
show_title "11. FILTROS AVANZADOS"

show_info "Logs de una IP específica:"
show_command "grep '192.168.1.100' ../data/servidor.log"

echo
show_info "Requests entre timestamps específicos:"
show_command "awk '\$4 ~ /10:30:2[0-5]/ {print \$4, \$7, \$9}' ../data/servidor.log"

echo
show_info "Requests con tamaño de respuesta mayor a 1000 bytes:"
show_command "awk '\$10 > 1000 {printf \"%-15s | %-25s | %6d bytes\\n\", \$1, \$7, \$10}' ../data/servidor.log"

echo

# 12. EXPORTAR DATOS PARA ANÁLISIS
show_title "12. EXPORTAR DATOS"

show_info "Crear CSV para análisis externo:"
echo "ip,timestamp,method,endpoint,status,size,user_agent" > log_analysis.csv
awk '{
    gsub(/\[|\]/, "", $4)
    gsub(/"/, "", $6)
    gsub(/"/, "", $12)
    printf "%s,%s,%s,%s,%s,%s,%s\n", $1, $4, $6, $7, $9, $10, $12
}' ../data/servidor.log >> log_analysis.csv

show_command "head -5 log_analysis.csv"
show_result "Datos exportados a log_analysis.csv"

echo

# LIMPIEZA
show_title "LIMPIEZA"
echo -e "${YELLOW}Limpiando archivos temporales...${NC}"
rm -f reporte_seguridad.txt monitor_errores.sh log_analysis.csv
show_result "Archivos temporales eliminados"

echo
show_title "RESUMEN DE ANÁLISIS DE LOGS"
echo "✓ Exploración y estadísticas básicas"
echo "✓ Análisis de direcciones IP"
echo "✓ Distribución de códigos de estado"
echo "✓ Análisis de endpoints y métodos"
echo "✓ Análisis temporal de actividad"
echo "✓ Análisis de User Agents"
echo "✓ Estadísticas de tamaño de respuesta"
echo "✓ Detección de patrones sospechosos"
echo "✓ Generación de reportes de seguridad"
echo "✓ Scripts de monitoreo automatizado"
echo "✓ Filtros avanzados y exportación"

echo
echo -e "${GREEN}🎉 ¡Análisis de logs completado!${NC}"
