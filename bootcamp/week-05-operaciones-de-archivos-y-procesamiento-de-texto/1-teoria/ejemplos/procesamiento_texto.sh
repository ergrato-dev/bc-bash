#!/bin/bash
# Ejemplo: Procesamiento de Texto con grep, sed y awk
# Módulo: 5
# Objetivo: Demostrar herramientas esenciales de procesamiento de texto

set -euo pipefail

# Colores para output
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
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

# Verificar que existan los archivos de datos
check_data_files() {
    local data_dir="../data"
    if [[ ! -d "$data_dir" ]]; then
        echo -e "${YELLOW}Creando archivos de datos de ejemplo...${NC}"
        mkdir -p "$data_dir"
        
        # Crear archivo de texto de ejemplo
        cat > "$data_dir/texto_ejemplo.txt" << 'EOF'
Esta es una línea de texto normal.
ERROR: Algo salió mal en el sistema.
Esta línea contiene la palabra IMPORTANTE.
WARNING: Memoria baja detectada.
Línea con números: 123, 456, 789
Email de contacto: admin@ejemplo.com
Otra línea normal de texto.
CRITICAL: Error crítico en la aplicación.
Fecha: 2023-12-24 10:30:15
Final del archivo de ejemplo.
EOF
        
        show_result "Archivos de datos creados"
    fi
}

echo -e "${BLUE}📄 MÓDULO 5: PROCESAMIENTO DE TEXTO${NC}"
echo "=================================================="

# Verificar archivos de datos
check_data_files

echo

# 1. GREP - BÚSQUEDA DE PATRONES
show_title "1. GREP - BÚSQUEDA DE PATRONES"

echo -e "${CYAN}Archivo de ejemplo:${NC}"
show_command "cat ../data/texto_ejemplo.txt"

echo
echo -e "${CYAN}Búsquedas básicas con grep:${NC}"

# Búsqueda simple
show_command "grep 'ERROR' ../data/texto_ejemplo.txt"

# Búsqueda insensible a mayúsculas
show_command "grep -i 'error' ../data/texto_ejemplo.txt"

# Contar coincidencias
show_command "grep -c 'línea' ../data/texto_ejemplo.txt"

# Mostrar números de línea
show_command "grep -n 'WARNING\\|ERROR\\|CRITICAL' ../data/texto_ejemplo.txt"

# Invertir búsqueda (líneas que NO contienen el patrón)
show_command "grep -v 'ERROR\\|WARNING' ../data/texto_ejemplo.txt"

echo

# 2. GREP CON EXPRESIONES REGULARES
show_title "2. GREP CON EXPRESIONES REGULARES"

# Buscar emails
show_command "grep -E '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}' ../data/texto_ejemplo.txt"

# Buscar números
show_command "grep -E '[0-9]+' ../data/texto_ejemplo.txt"

# Buscar fechas (formato YYYY-MM-DD)
show_command "grep -E '[0-9]{4}-[0-9]{2}-[0-9]{2}' ../data/texto_ejemplo.txt"

# Buscar líneas que empiezan con mayúscula
show_command "grep '^[A-Z]' ../data/texto_ejemplo.txt"

echo

# 3. SED - EDICIÓN DE FLUJO
show_title "3. SED - EDICIÓN DE FLUJO"

echo -e "${CYAN}Sustituciones con sed:${NC}"

# Sustitución simple
show_command "sed 's/ERROR/FALLO/' ../data/texto_ejemplo.txt"

# Sustitución global en cada línea
show_command "sed 's/línea/LÍNEA/g' ../data/texto_ejemplo.txt"

# Sustitución insensible a mayúsculas
show_command "sed 's/error/FALLO/I' ../data/texto_ejemplo.txt"

# Eliminar líneas que contienen un patrón
show_command "sed '/WARNING/d' ../data/texto_ejemplo.txt"

# Imprimir solo líneas específicas
show_command "sed -n '3,6p' ../data/texto_ejemplo.txt"

# Insertar texto antes de una línea
show_command "sed '1i\\=== INICIO DEL ARCHIVO ===' ../data/texto_ejemplo.txt | head -5"

echo

# 4. AWK - PROCESAMIENTO AVANZADO
show_title "4. AWK - PROCESAMIENTO AVANZADO"

# Crear archivo CSV de ejemplo para AWK
cat > ejemplo_temporal.csv << 'EOF'
nombre,edad,ciudad,salario
Ana,28,Madrid,45000
Carlos,35,Barcelona,55000
María,31,Valencia,40000
José,42,Sevilla,60000
EOF

echo -e "${CYAN}Archivo CSV de ejemplo:${NC}"
show_command "cat ejemplo_temporal.csv"

echo
echo -e "${CYAN}Procesamiento con AWK:${NC}"

# Imprimir columnas específicas
show_command "awk -F',' '{print \$1, \$3}' ejemplo_temporal.csv"

# Filtrar por condición
show_command "awk -F',' '\$2 > 30 {print \$1, \"es mayor de 30 años\"}' ejemplo_temporal.csv"

# Calcular suma de salarios
show_command "awk -F',' 'NR>1 {sum+=\$4} END {print \"Suma total de salarios:\", sum}' ejemplo_temporal.csv"

# Contar registros
show_command "awk -F',' 'END {print \"Total de empleados:\", NR-1}' ejemplo_temporal.csv"

# Formatear salida
show_command "awk -F',' 'NR>1 {printf \"%-10s | %-12s | %s\\n\", \$1, \$3, \$4}' ejemplo_temporal.csv"

echo

# 5. COMBINACIÓN DE HERRAMIENTAS
show_title "5. COMBINACIÓN DE HERRAMIENTAS (PIPELINES)"

echo -e "${CYAN}Pipeline complejo:${NC}"

# Buscar errores, extraer timestamp y ordenar
show_command "grep -E '(ERROR|WARNING|CRITICAL)' ../data/texto_ejemplo.txt | sed 's/.*\\([0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}\\).*/\\1/' | sort -u"

# Procesar CSV: filtrar, transformar y resumir
echo -e "${CYAN}Procesamiento CSV complejo:${NC}"
show_command "cat ejemplo_temporal.csv | grep -v '^nombre' | awk -F',' '{if(\$2>=30) print \$1\"(\"toupper(\$3)\"): \"\$4}' | sort -t':' -k2 -nr"

echo

# 6. CASOS PRÁCTICOS
show_title "6. CASOS PRÁCTICOS"

# Análisis de logs
if [[ -f "../data/servidor.log" ]]; then
    echo -e "${CYAN}Análisis de logs de servidor:${NC}"
    
    # IPs más frecuentes
    show_command "awk '{print \$1}' ../data/servidor.log | sort | uniq -c | sort -nr | head -3"
    
    # Códigos de estado
    show_command "awk '{print \$9}' ../data/servidor.log | sort | uniq -c"
    
    # Errores 404 y 500
    show_command "awk '\$9 ~ /^[45]/ {print \$7, \$9}' ../data/servidor.log"
fi

echo

# 7. PROCESAMIENTO DE TEXTO AVANZADO
show_title "7. PROCESAMIENTO AVANZADO"

# Crear archivo con datos mezclados
cat > datos_mezclados.txt << 'EOF'
Juan,25,Madrid
ERROR: Database connection failed
Ana,30,Barcelona
WARNING: High memory usage
Carlos,28,Valencia
INFO: System started successfully
María,35,Sevilla
EOF

echo -e "${CYAN}Separar datos válidos de logs:${NC}"
show_command "cat datos_mezclados.txt"

echo
# Separar datos válidos
show_command "grep -v '^(ERROR\\|WARNING\\|INFO)' datos_mezclados.txt > usuarios_validos.csv"
show_command "grep '^(ERROR\\|WARNING\\|INFO)' datos_mezclados.txt > logs_sistema.txt"

show_command "echo 'Usuarios válidos:' && cat usuarios_validos.csv"
show_command "echo 'Logs del sistema:' && cat logs_sistema.txt"

echo

# 8. TRANSFORMACIÓN DE DATOS
show_title "8. TRANSFORMACIÓN DE DATOS"

echo -e "${CYAN}Transformar formato de datos:${NC}"

# Convertir CSV a formato tabla
show_command "awk -F',' 'BEGIN{printf \"%-10s | %-5s | %-10s\\n\", \"Nombre\", \"Edad\", \"Ciudad\"; print \"-----------|-------|----------\"} {printf \"%-10s | %-5s | %-10s\\n\", \$1, \$2, \$3}' usuarios_validos.csv"

echo

# LIMPIEZA
show_title "LIMPIEZA"
echo -e "${YELLOW}Limpiando archivos temporales...${NC}"
rm -f ejemplo_temporal.csv datos_mezclados.txt usuarios_validos.csv logs_sistema.txt
show_result "Archivos temporales eliminados"

echo
show_title "RESUMEN DE HERRAMIENTAS"
echo "✓ grep: Búsqueda de patrones en texto"
echo "✓ sed: Edición y transformación de flujo"
echo "✓ awk: Procesamiento y análisis avanzado"
echo "✓ Pipelines: Combinación de herramientas"
echo "✓ Expresiones regulares: Patrones complejos"
echo "✓ Transformación de datos: Formateo y conversión"

echo
echo -e "${GREEN}🎉 ¡Procesamiento de texto completado!${NC}"
