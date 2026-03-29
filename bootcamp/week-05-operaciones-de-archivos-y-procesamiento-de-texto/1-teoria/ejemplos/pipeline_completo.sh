#!/bin/bash
# Ejemplo: Pipeline Completo de Procesamiento de Datos
# Módulo: 5
# Objetivo: Demostrar un flujo completo de procesamiento combinando todas las herramientas

set -euo pipefail

# Colores para output
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly MAGENTA='\033[0;35m'
readonly NC='\033[0m' # No Color

# Variables de configuración
readonly DATA_DIR="../data"
readonly OUTPUT_DIR="./pipeline_output"
readonly TIMESTAMP=$(date '+%Y%m%d_%H%M%S')

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

# Función para mostrar progreso
show_progress() {
    echo -e "${MAGENTA}⏳ $1${NC}"
}

echo -e "${BLUE}🔄 MÓDULO 5: PIPELINE COMPLETO DE PROCESAMIENTO${NC}"
echo "=================================================================="

# 1. PREPARACIÓN DEL ENTORNO
show_title "1. PREPARACIÓN DEL ENTORNO"

show_progress "Creando estructura de directorios..."
mkdir -p "$OUTPUT_DIR"/{processed,reports,temp}
show_result "Estructura creada: $OUTPUT_DIR"

# Verificar archivos de datos
if [[ ! -f "$DATA_DIR/usuarios.csv" ]] || [[ ! -f "$DATA_DIR/servidor.log" ]]; then
    show_progress "Creando archivos de datos necesarios..."
    mkdir -p "$DATA_DIR"
    
    # Crear datos de usuarios
    cat > "$DATA_DIR/usuarios.csv" << 'EOF'
nombre,edad,ciudad,puesto,salario,email,telefono
Ana García,28,Madrid,Desarrolladora,45000,ana@empresa.com,+34 912 345 678
Carlos López,35,Barcelona,Manager,55000,carlos@empresa.com,+34 932 456 789
María Rodríguez,31,Valencia,Diseñadora,40000,maria@empresa.com,+34 963 567 890
José Martín,42,Sevilla,Arquitecto,60000,jose@empresa.com,+34 954 678 901
Laura Sánchez,26,Bilbao,Analista,38000,laura@empresa.com,+34 944 789 012
Pedro González,39,Zaragoza,Senior Dev,52000,pedro@empresa.com,+34 976 890 123
Carmen Díaz,33,Málaga,Product Owner,48000,carmen@empresa.com,+34 952 901 234
Manuel Torres,29,Murcia,DevOps,50000,manuel@empresa.com,+34 968 012 345
Isabel Ruiz,37,Palma,Tech Lead,58000,isabel@empresa.com,+34 971 123 456
Andrés Jiménez,31,Granada,Backend Dev,46000,andres@empresa.com,+34 958 234 567
EOF
    
    # Crear logs de servidor
    cat > "$DATA_DIR/servidor.log" << 'EOF'
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
EOF
    
    show_result "Archivos de datos creados"
fi

echo

# 2. FASE 1: VALIDACIÓN Y LIMPIEZA DE DATOS
show_title "2. FASE 1: VALIDACIÓN Y LIMPIEZA"

show_progress "Validando integridad de datos CSV..."

# Validar estructura CSV
show_info "Verificando estructura del CSV:"
show_command "head -1 $DATA_DIR/usuarios.csv | tr ',' '\\n' | nl"

# Contar registros válidos
valid_records=$(awk -F',' 'NR>1 && NF==7 {count++} END {print count+0}' "$DATA_DIR/usuarios.csv")
show_result "$valid_records registros válidos encontrados"

# Validar emails
show_progress "Validando emails..."
grep -E '^[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,},' "$DATA_DIR/usuarios.csv" > "$OUTPUT_DIR/temp/emails_validos.csv"
invalid_emails=$(awk -F',' 'NR>1 && $6 !~ /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/ {count++} END {print count+0}' "$DATA_DIR/usuarios.csv")

if [[ $invalid_emails -gt 0 ]]; then
    show_info "⚠️  $invalid_emails emails inválidos encontrados"
else
    show_result "Todos los emails son válidos"
fi

# Limpiar y normalizar datos
show_progress "Normalizando datos..."
awk -F',' 'BEGIN {OFS=","} 
NR==1 {print; next}
{
    # Normalizar nombre (primera letra mayúscula)
    gsub(/^./, toupper(substr($1,1,1)), $1)
    # Normalizar ciudad
    $3 = toupper(substr($3,1,1)) tolower(substr($3,2))
    # Limpiar espacios
    gsub(/^ +| +$/, "", $1)
    gsub(/^ +| +$/, "", $3)
    print
}' "$DATA_DIR/usuarios.csv" > "$OUTPUT_DIR/processed/usuarios_limpios.csv"

show_result "Datos normalizados guardados en usuarios_limpios.csv"

echo

# 3. FASE 2: PROCESAMIENTO DE LOGS
show_title "3. FASE 2: PROCESAMIENTO DE LOGS"

show_progress "Analizando logs de servidor..."

# Extraer estadísticas de logs
awk '{
    total++
    ips[$1]++
    status[$9]++
    if($9 >= 400) errors++
    if($9 ~ /^2/) success++
    size += $10
}
END {
    print "total_requests:" total > "'"$OUTPUT_DIR/temp/log_stats.txt"'"
    print "unique_ips:" length(ips) >> "'"$OUTPUT_DIR/temp/log_stats.txt"'"
    print "errors:" errors+0 >> "'"$OUTPUT_DIR/temp/log_stats.txt"'"
    print "success:" success+0 >> "'"$OUTPUT_DIR/temp/log_stats.txt"'"
    print "total_size:" size >> "'"$OUTPUT_DIR/temp/log_stats.txt"'"
}' "$DATA_DIR/servidor.log"

# Crear CSV de requests
echo "ip,timestamp,method,endpoint,status,size" > "$OUTPUT_DIR/processed/requests.csv"
awk '{
    gsub(/\[|\]/, "", $4)
    gsub(/"/, "", $6)
    printf "%s,%s,%s,%s,%s,%s\n", $1, $4, $6, $7, $9, $10
}' "$DATA_DIR/servidor.log" >> "$OUTPUT_DIR/processed/requests.csv"

show_result "Logs procesados y convertidos a CSV"

# Identificar IPs problemáticas
awk '$9 >= 400 {ips[$1]++} END {for(ip in ips) if(ips[ip] > 1) print ip "," ips[ip]}' "$DATA_DIR/servidor.log" > "$OUTPUT_DIR/processed/ips_problematicas.csv"

show_command "echo 'IPs con múltiples errores:' && cat $OUTPUT_DIR/processed/ips_problematicas.csv"

echo

# 4. FASE 3: ANÁLISIS COMBINADO
show_title "4. FASE 3: ANÁLISIS COMBINADO"

show_progress "Generando análisis combinado..."

# Combinar datos de empleados con ubicaciones geográficas de logs
show_info "Correlacionando datos de empleados con actividad del sistema:"

# Crear mapa de ciudades a rangos IP (simulado)
cat > "$OUTPUT_DIR/temp/ip_ciudades.txt" << 'EOF'
192.168.1.100,Madrid
192.168.1.101,Barcelona  
192.168.1.102,Valencia
192.168.1.103,Madrid
192.168.1.104,Sevilla
192.168.1.105,Barcelona
192.168.1.106,Madrid
192.168.1.107,Valencia
EOF

# Analizar actividad por ciudad
join -t',' -1 3 -2 2 \
    <(tail -n +2 "$OUTPUT_DIR/processed/usuarios_limpios.csv" | sort -t',' -k3) \
    <(sort -t',' -k2 "$OUTPUT_DIR/temp/ip_ciudades.txt") \
    2>/dev/null | head -5 || echo "Datos de ejemplo para correlación"

echo

# 5. FASE 4: GENERACIÓN DE REPORTES
show_title "5. FASE 4: GENERACIÓN DE REPORTES"

show_progress "Generando reporte ejecutivo..."

cat << EOF > "$OUTPUT_DIR/reports/reporte_ejecutivo_$TIMESTAMP.md"
# REPORTE EJECUTIVO - $TIMESTAMP

## 📊 RESUMEN DE DATOS

### Personal
$(awk -F',' 'END {printf "- Total empleados: %d\n", NR-1}' "$OUTPUT_DIR/processed/usuarios_limpios.csv")
$(awk -F',' 'NR>1 {sum+=$5; count++} END {printf "- Salario promedio: %.0f€\n", sum/count}' "$OUTPUT_DIR/processed/usuarios_limpios.csv")
$(awk -F',' 'NR>1 {sum+=$2; count++} END {printf "- Edad promedio: %.1f años\n", sum/count}' "$OUTPUT_DIR/processed/usuarios_limpios.csv")

### Actividad del Sistema
$(grep "total_requests" "$OUTPUT_DIR/temp/log_stats.txt" | sed 's/total_requests:/- Total requests: /')
$(grep "unique_ips" "$OUTPUT_DIR/temp/log_stats.txt" | sed 's/unique_ips:/- IPs únicas: /')
$(grep "errors" "$OUTPUT_DIR/temp/log_stats.txt" | sed 's/errors:/- Errores detectados: /')

## 🏙️ DISTRIBUCIÓN GEOGRÁFICA

### Empleados por Ciudad
$(awk -F',' 'NR>1 {ciudad[$3]++} END {for(c in ciudad) printf "- %s: %d empleados\n", c, ciudad[c]}' "$OUTPUT_DIR/processed/usuarios_limpios.csv" | sort)

### Costo Salarial por Ciudad
$(awk -F',' 'NR>1 {ciudad[$3]+=$5; count[$3]++} END {for(c in ciudad) printf "- %s: %.0f€ (promedio: %.0f€)\n", c, ciudad[c], ciudad[c]/count[c]}' "$OUTPUT_DIR/processed/usuarios_limpios.csv" | sort)

## 🔍 ANÁLISIS DE SEGURIDAD

### IPs Problemáticas
$(if [[ -s "$OUTPUT_DIR/processed/ips_problematicas.csv" ]]; then cat "$OUTPUT_DIR/processed/ips_problematicas.csv" | sed 's/^/- IP /; s/,/ con /; s/$/ errores/'; else echo "- No se detectaron IPs problemáticas"; fi)

## 📈 RECOMENDACIONES

1. **Personal**: Considerar política salarial en ciudades con mayor costo de vida
2. **Seguridad**: Implementar monitoreo adicional para IPs con múltiples errores
3. **Recursos**: Revisar capacidad del sistema en horas pico

---
*Reporte generado automáticamente el $(date)*
EOF

show_result "Reporte ejecutivo generado"

# Mostrar el reporte
show_command "cat $OUTPUT_DIR/reports/reporte_ejecutivo_$TIMESTAMP.md"

echo

# 6. FASE 5: EXPORTACIÓN Y VISUALIZACIÓN
show_title "6. FASE 5: EXPORTACIÓN FINAL"

show_progress "Preparando datos para exportación..."

# Crear archivo JSON consolidado
cat << EOF > "$OUTPUT_DIR/processed/datos_consolidados.json"
{
  "metadata": {
    "generated": "$(date -Iseconds)",
    "version": "1.0",
    "source": "Pipeline Bash Bootcamp"
  },
  "summary": {
    "empleados": $(awk -F',' 'END {print NR-1}' "$OUTPUT_DIR/processed/usuarios_limpios.csv"),
    "requests": $(grep "total_requests" "$OUTPUT_DIR/temp/log_stats.txt" | cut -d: -f2),
    "errores": $(grep "errors" "$OUTPUT_DIR/temp/log_stats.txt" | cut -d: -f2)
  },
  "datos": {
    "empleados_file": "usuarios_limpios.csv",
    "requests_file": "requests.csv",
    "reporte": "reporte_ejecutivo_$TIMESTAMP.md"
  }
}
EOF

show_result "Datos consolidados en formato JSON"

# Crear script de validación
cat << 'EOF' > "$OUTPUT_DIR/validate_pipeline.sh"
#!/bin/bash
# Script de validación del pipeline

echo "🔍 VALIDANDO RESULTADOS DEL PIPELINE"
echo "===================================="

# Verificar archivos generados
files=("processed/usuarios_limpios.csv" "processed/requests.csv" "processed/datos_consolidados.json")

for file in "${files[@]}"; do
    if [[ -f "$file" ]]; then
        echo "✓ $file - $(wc -l < "$file") líneas"
    else
        echo "✗ $file - NO ENCONTRADO"
    fi
done

# Verificar integridad de datos
echo -e "\n📊 INTEGRIDAD DE DATOS:"
echo "- Empleados procesados: $(tail -n +2 processed/usuarios_limpios.csv | wc -l)"
echo "- Requests procesados: $(tail -n +2 processed/requests.csv | wc -l)"

# Verificar emails válidos
invalid_emails=$(awk -F',' 'NR>1 && $6 !~ /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/ {count++} END {print count+0}' processed/usuarios_limpios.csv)
echo "- Emails inválidos restantes: $invalid_emails"

echo -e "\n✅ Validación completada"
EOF

chmod +x "$OUTPUT_DIR/validate_pipeline.sh"
show_result "Script de validación creado"

# Ejecutar validación
show_command "cd $OUTPUT_DIR && ./validate_pipeline.sh && cd -"

echo

# 7. FASE 6: LIMPIEZA Y OPTIMIZACIÓN
show_title "7. FASE 6: LIMPIEZA Y OPTIMIZACIÓN"

show_progress "Optimizando archivos de salida..."

# Comprimir archivos grandes
if [[ $(wc -c < "$OUTPUT_DIR/processed/requests.csv") -gt 1000 ]]; then
    gzip -k "$OUTPUT_DIR/processed/requests.csv"
    show_result "Archivo requests.csv comprimido"
fi

# Limpiar archivos temporales
rm -rf "$OUTPUT_DIR/temp"
show_result "Archivos temporales eliminados"

# Crear resumen final
cat << EOF > "$OUTPUT_DIR/RESUMEN_PIPELINE.txt"
PIPELINE DE PROCESAMIENTO COMPLETADO
===================================

Timestamp: $TIMESTAMP
Duración: $SECONDS segundos

ARCHIVOS GENERADOS:
- processed/usuarios_limpios.csv
- processed/requests.csv  
- processed/datos_consolidados.json
- reports/reporte_ejecutivo_$TIMESTAMP.md
- validate_pipeline.sh

ESTADÍSTICAS:
- Empleados procesados: $(awk -F',' 'END {print NR-1}' "$OUTPUT_DIR/processed/usuarios_limpios.csv")
- Requests analizados: $(wc -l < "$DATA_DIR/servidor.log")
- Reportes generados: 1

PRÓXIMOS PASOS:
1. Revisar reporte ejecutivo
2. Validar datos con validate_pipeline.sh
3. Importar CSVs a sistema de análisis
4. Programar ejecución automática del pipeline

===================================
Pipeline ejecutado exitosamente ✅
EOF

show_command "cat $OUTPUT_DIR/RESUMEN_PIPELINE.txt"

echo

# 8. RESULTADO FINAL
show_title "8. RESULTADO FINAL"

show_info "Estructura de archivos generados:"
show_command "find $OUTPUT_DIR -type f | sort"

echo
show_result "Pipeline completo ejecutado exitosamente"
show_info "Tiempo total de ejecución: $SECONDS segundos"

echo
show_title "COMANDOS PARA INSPECCIONAR RESULTADOS"
echo "# Ver empleados procesados:"
echo "cat $OUTPUT_DIR/processed/usuarios_limpios.csv"
echo ""
echo "# Ver análisis de requests:"
echo "cat $OUTPUT_DIR/processed/requests.csv"
echo ""
echo "# Ver reporte ejecutivo:"
echo "cat $OUTPUT_DIR/reports/reporte_ejecutivo_$TIMESTAMP.md"
echo ""
echo "# Validar integridad:"
echo "cd $OUTPUT_DIR && ./validate_pipeline.sh"

echo
echo -e "${GREEN}🎉 ¡Pipeline completo de procesamiento terminado!${NC}"
echo -e "${CYAN}💡 Este ejemplo demuestra un flujo real de trabajo con datos usando herramientas Bash${NC}"
