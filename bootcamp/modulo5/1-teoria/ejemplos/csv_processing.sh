#!/bin/bash
# Ejemplo: Procesamiento Avanzado de Archivos CSV
# Módulo: 5
# Objetivo: Demostrar técnicas de procesamiento de datos CSV

set -euo pipefail

# Colores para output
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly MAGENTA='\033[0;35m'
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

echo -e "${BLUE}📊 MÓDULO 5: PROCESAMIENTO DE CSV${NC}"
echo "=================================================="

# Verificar archivo de datos
if [[ ! -f "../data/usuarios.csv" ]]; then
    echo -e "${YELLOW}Archivo de datos no encontrado. Creando archivo de ejemplo...${NC}"
    mkdir -p ../data
    cat > ../data/usuarios.csv << 'EOF'
nombre,edad,ciudad,puesto,salario
Ana García,28,Madrid,Desarrolladora,45000
Carlos López,35,Barcelona,Manager,55000
María Rodríguez,31,Valencia,Diseñadora,40000
José Martín,42,Sevilla,Arquitecto,60000
Laura Sánchez,26,Bilbao,Analista,38000
Pedro González,39,Zaragoza,Senior Dev,52000
Carmen Díaz,33,Málaga,Product Owner,48000
Manuel Torres,29,Murcia,DevOps,50000
Isabel Ruiz,37,Palma,Tech Lead,58000
Andrés Jiménez,31,Granada,Backend Dev,46000
EOF
    show_result "Archivo CSV de ejemplo creado"
fi

echo

# 1. INSPECCIÓN INICIAL DEL CSV
show_title "1. INSPECCIÓN INICIAL DEL CSV"

show_info "Archivo de datos: ../data/usuarios.csv"
show_command "head -5 ../data/usuarios.csv"

echo
show_info "Estructura del archivo:"
show_command "wc -l ../data/usuarios.csv"
show_command "head -1 ../data/usuarios.csv | tr ',' '\\n' | nl"

echo

# 2. EXTRACCIÓN DE COLUMNAS ESPECÍFICAS
show_title "2. EXTRACCIÓN DE COLUMNAS"

show_info "Extraer solo nombres y ciudades:"
show_command "awk -F',' '{print \$1, \"->\" , \$3}' ../data/usuarios.csv"

echo
show_info "Extraer columnas numéricas (edad y salario):"
show_command "awk -F',' 'NR>1 {print \$1 \": Edad=\" \$2 \", Salario=\" \$5}' ../data/usuarios.csv"

echo

# 3. FILTRADO DE DATOS
show_title "3. FILTRADO DE DATOS"

show_info "Empleados mayores de 35 años:"
show_command "awk -F',' 'NR>1 && \$2 > 35 {print \$1, \"(\" \$2 \" años) -\", \$4}' ../data/usuarios.csv"

echo
show_info "Empleados con salario superior a 50000:"
show_command "awk -F',' 'NR>1 && \$5 > 50000 {printf \"%-15s | %6d | %-15s\\n\", \$1, \$5, \$4}' ../data/usuarios.csv"

echo
show_info "Empleados de Madrid o Barcelona:"
show_command "awk -F',' 'NR>1 && (\$3 == \"Madrid\" || \$3 == \"Barcelona\") {print \$1, \"(\"\$3\")\"}' ../data/usuarios.csv"

echo

# 4. ESTADÍSTICAS Y AGREGACIONES
show_title "4. ESTADÍSTICAS Y AGREGACIONES"

show_info "Edad promedio:"
show_command "awk -F',' 'NR>1 {sum+=\$2; count++} END {printf \"Edad promedio: %.1f años\\n\", sum/count}' ../data/usuarios.csv"

echo
show_info "Salario total y promedio:"
show_command "awk -F',' 'NR>1 {sum+=\$5; count++} END {printf \"Salario total: %d\\nSalario promedio: %.0f\\n\", sum, sum/count}' ../data/usuarios.csv"

echo
show_info "Rango de edades (min/max):"
show_command "awk -F',' 'NR>1 {if(NR==2) {min=max=\$2} else {if(\$2<min) min=\$2; if(\$2>max) max=\$2}} END {print \"Edad mínima:\", min, \"- Edad máxima:\", max}' ../data/usuarios.csv"

echo

# 5. AGRUPACIÓN POR CIUDAD
show_title "5. AGRUPACIÓN POR CIUDAD"

show_info "Empleados por ciudad:"
show_command "awk -F',' 'NR>1 {ciudad[\$3]++} END {for(c in ciudad) printf \"%-12s: %d empleados\\n\", c, ciudad[c]}' ../data/usuarios.csv | sort"

echo
show_info "Salario promedio por ciudad:"
show_command "awk -F',' 'NR>1 {ciudad[\$3]+=\$5; count[\$3]++} END {for(c in ciudad) printf \"%-12s: %6.0f€\\n\", c, ciudad[c]/count[c]}' ../data/usuarios.csv | sort"

echo

# 6. TRANSFORMACIÓN DE DATOS
show_title "6. TRANSFORMACIÓN DE DATOS"

show_info "Crear tabla formateada:"
show_command "awk -F',' 'BEGIN {printf \"%-18s | %-4s | %-10s | %-15s | %-8s\\n\", \"NOMBRE\", \"EDAD\", \"CIUDAD\", \"PUESTO\", \"SALARIO\"; print \"-------------------+------+------------+-----------------+----------\"} NR>1 {printf \"%-18s | %-4s | %-10s | %-15s | %8s€\\n\", \$1, \$2, \$3, \$4, \$5}' ../data/usuarios.csv"

echo

# 7. EXPORTAR DATOS FILTRADOS
show_title "7. EXPORTAR DATOS FILTRADOS"

show_info "Crear CSV de empleados seniors (>35 años):"
# Crear header
echo "nombre,edad,ciudad,puesto,salario" > empleados_seniors.csv
# Filtrar y agregar datos
awk -F',' 'NR>1 && $2 > 35 {print $0}' ../data/usuarios.csv >> empleados_seniors.csv

show_command "cat empleados_seniors.csv"
show_result "Archivo empleados_seniors.csv creado"

echo
show_info "Crear CSV de empleados tech:"
# Crear archivo para empleados tech
echo "nombre,puesto,salario" > empleados_tech.csv
awk -F',' 'NR>1 && ($4 ~ /Dev/ || $4 ~ /Tech/) {print $1","$4","$5}' ../data/usuarios.csv >> empleados_tech.csv

show_command "cat empleados_tech.csv"
show_result "Archivo empleados_tech.csv creado"

echo

# 8. VALIDACIÓN DE DATOS CSV
show_title "8. VALIDACIÓN DE DATOS CSV"

show_info "Verificar integridad del CSV:"

# Contar campos por línea
show_command "awk -F',' '{print NR \": \" NF \" campos\"}' ../data/usuarios.csv | head -5"

# Verificar datos numéricos
show_info "Verificar que las edades sean números:"
show_command "awk -F',' 'NR>1 {if(\$2 !~ /^[0-9]+\$/) print \"Línea \" NR \": edad inválida - \" \$2}' ../data/usuarios.csv || echo 'Todas las edades son válidas'"

# Verificar rangos
show_info "Verificar rangos de edad (18-70):"
show_command "awk -F',' 'NR>1 {if(\$2 < 18 || \$2 > 70) print \"Línea \" NR \": edad fuera de rango - \" \$2}' ../data/usuarios.csv || echo 'Todas las edades están en rango válido'"

echo

# 9. PROCESAMIENTO CON SED
show_title "9. TRANSFORMACIONES CON SED"

show_info "Normalizar nombres de ciudades (mayúsculas):"
show_command "sed 's/,\\([^,]*\\),/,\\U\\1,/3' ../data/usuarios.csv | head -5"

show_info "Añadir prefijo a puestos de trabajo:"
show_command "sed 's/,\\([^,]*\\),\\([0-9]*\\)\$/,IT-\\1,\\2€/' ../data/usuarios.csv | head -5"

echo

# 10. REPORTES AVANZADOS
show_title "10. REPORTES AVANZADOS"

show_info "Reporte ejecutivo completo:"

cat << 'EOF' | bash
awk -F',' '
BEGIN {
    print "═══════════════════════════════════════════"
    print "        REPORTE EJECUTIVO DE PERSONAL"
    print "═══════════════════════════════════════════"
}
NR>1 {
    total_empleados++
    suma_edades += $2
    suma_salarios += $5
    
    # Agrupar por rango de edad
    if($2 < 30) jovenes++
    else if($2 < 40) adultos++
    else seniors++
    
    # Agrupar salarios
    if($5 < 40000) salario_bajo++
    else if($5 < 55000) salario_medio++
    else salario_alto++
    
    ciudades[$3]++
}
END {
    printf "\n📊 RESUMEN GENERAL:\n"
    printf "Total empleados: %d\n", total_empleados
    printf "Edad promedio: %.1f años\n", suma_edades/total_empleados
    printf "Salario promedio: %.0f€\n", suma_salarios/total_empleados
    
    printf "\n👥 DISTRIBUCIÓN POR EDAD:\n"
    printf "Jóvenes (<30): %d (%.1f%%)\n", jovenes, jovenes*100/total_empleados
    printf "Adultos (30-39): %d (%.1f%%)\n", adultos, adultos*100/total_empleados
    printf "Seniors (40+): %d (%.1f%%)\n", seniors, seniors*100/total_empleados
    
    printf "\n💰 DISTRIBUCIÓN SALARIAL:\n"
    printf "Bajo (<40k): %d empleados\n", salario_bajo
    printf "Medio (40k-55k): %d empleados\n", salario_medio
    printf "Alto (>55k): %d empleados\n", salario_alto
    
    printf "\n🏙️  DISTRIBUCIÓN GEOGRÁFICA:\n"
    for(ciudad in ciudades) {
        printf "%-12s: %d empleados\n", ciudad, ciudades[ciudad]
    }
    
    print "\n═══════════════════════════════════════════"
}' ../data/usuarios.csv
EOF

echo

# LIMPIEZA
show_title "LIMPIEZA"
echo -e "${YELLOW}Limpiando archivos temporales...${NC}"
rm -f empleados_seniors.csv empleados_tech.csv
show_result "Archivos temporales eliminados"

echo
show_title "RESUMEN DE TÉCNICAS CSV"
echo "✓ Inspección y validación de estructura"
echo "✓ Extracción de columnas específicas"
echo "✓ Filtrado por condiciones múltiples"
echo "✓ Cálculos estadísticos (sum, avg, min, max)"
echo "✓ Agrupación y conteo por categorías"
echo "✓ Transformación y formateo de datos"
echo "✓ Exportación de subconjuntos"
echo "✓ Validación de integridad de datos"
echo "✓ Reportes ejecutivos automatizados"

echo
echo -e "${GREEN}🎉 ¡Procesamiento de CSV completado!${NC}"
