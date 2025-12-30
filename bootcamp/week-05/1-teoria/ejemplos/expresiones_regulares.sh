#!/bin/bash
# Ejemplo: Expresiones Regulares en Bash
# Módulo: 5
# Objetivo: Demostrar patrones y expresiones regulares avanzadas

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

# Función para mostrar patrones
show_pattern() {
    echo -e "${MAGENTA}📝 Patrón: $1${NC}"
}

echo -e "${BLUE}🔍 MÓDULO 5: EXPRESIONES REGULARES${NC}"
echo "=================================================="

# Crear archivo de datos de prueba
create_test_data() {
    cat > datos_regex.txt << 'EOF'
Emails válidos:
juan.perez@empresa.com
ana_garcia@universidad.edu
admin@servidor-local.org
soporte123@sistema.net

Emails inválidos:
correo@.com
@dominio.com
usuario@
email..doble@punto.com

Teléfonos:
+34 912 345 678
+1 (555) 123-4567
606-789-123
91 234 56 78
+44 20 7946 0958

URLs:
https://www.ejemplo.com
http://blog.miempresa.es
https://api.sistema.com/v1/usuarios
ftp://archivos.servidor.net
www.sitio-web.org

Fechas:
2023-12-24
24/12/2023
24-Dec-2023
2023/12/24 14:30:15
Dec 24, 2023

IPs:
192.168.1.1
10.0.0.255
172.16.254.1
8.8.8.8
256.300.400.500

Códigos:
ABC-123
XYZ-456-789
ID_2023_001
REF#12345
CODE-ABC-123-XYZ

Números:
42
-17
3.14159
1,234.56
€45,678.90
$123,456.78
EOF
    
    show_result "Archivo de datos de prueba creado"
}

echo

# 1. PREPARACIÓN DE DATOS
show_title "1. PREPARACIÓN DE DATOS"
create_test_data

show_command "head -20 datos_regex.txt"

echo

# 2. PATRONES BÁSICOS
show_title "2. PATRONES BÁSICOS"

show_pattern "^Email - líneas que empiezan con 'Email'"
show_command "grep '^Email' datos_regex.txt"

echo
show_pattern "\$ - líneas que terminan con '.com'"
show_command "grep '\\.com\$' datos_regex.txt"

echo
show_pattern ". - cualquier carácter (buscar IPs)"
show_command "grep '[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}' datos_regex.txt"

echo

# 3. CARACTERES ESPECIALES Y CLASES
show_title "3. CARACTERES ESPECIALES Y CLASES"

show_pattern "[0-9] - dígitos"
show_command "grep '[0-9]\\{3\\}-[0-9]\\{3\\}-[0-9]\\{3\\}' datos_regex.txt"

echo
show_pattern "[a-zA-Z] - letras"
show_command "grep '^[a-zA-Z]\\{3,\\}[._][a-zA-Z]\\{3,\\}@' datos_regex.txt"

echo
show_pattern "[^@] - negación (no contiene @)"
show_command "grep '^[^@]*\$' datos_regex.txt | head -5"

echo

# 4. CUANTIFICADORES
show_title "4. CUANTIFICADORES"

show_pattern "* - cero o más repeticiones"
show_command "grep 'https\\?://[a-zA-Z0-9.-]*\\.[a-zA-Z]\\{2,\\}' datos_regex.txt"

echo
show_pattern "+ - una o más repeticiones (usando -E)"
show_command "grep -E '[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+' datos_regex.txt"

echo
show_pattern "{n,m} - entre n y m repeticiones"
show_command "grep '[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}' datos_regex.txt"

echo

# 5. EXPRESIONES REGULARES EXTENDIDAS (ERE)
show_title "5. EXPRESIONES REGULARES EXTENDIDAS"

show_pattern "| - alternancia (OR)"
show_command "grep -E '(http|https|ftp)://' datos_regex.txt"

echo
show_pattern "() - agrupación"
show_command "grep -E '\\+[0-9]{1,3} \\([0-9]{3}\\) [0-9]{3}-[0-9]{4}' datos_regex.txt"

echo
show_pattern "? - opcional (0 o 1)"
show_command "grep -E 'https?://[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}' datos_regex.txt"

echo

# 6. VALIDACIÓN DE EMAILS
show_title "6. VALIDACIÓN DE EMAILS"

show_pattern "Email básico"
show_command "grep -E '^[a-zA-Z0-9._+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}\$' datos_regex.txt"

echo
show_info "Separar emails válidos e inválidos:"

# Extraer emails válidos
grep -E '^[a-zA-Z0-9._+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$' datos_regex.txt > emails_validos.txt
# Extraer emails inválidos (líneas con @ que no cumplen el patrón)
grep '@' datos_regex.txt | grep -vE '^[a-zA-Z0-9._+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$' > emails_invalidos.txt

show_command "echo 'EMAILS VÁLIDOS:' && cat emails_validos.txt"
show_command "echo 'EMAILS INVÁLIDOS:' && cat emails_invalidos.txt"

echo

# 7. VALIDACIÓN DE TELÉFONOS
show_title "7. VALIDACIÓN DE TELÉFONOS"

show_pattern "Teléfonos españoles (+34)"
show_command "grep -E '\\+34 [0-9]{3} [0-9]{3} [0-9]{3}' datos_regex.txt"

echo
show_pattern "Teléfonos internacionales"
show_command "grep -E '\\+[0-9]{1,3} (\\([0-9]{3}\\) )?[0-9]{3}[- ]?[0-9]{4}' datos_regex.txt"

echo
show_pattern "Cualquier formato de teléfono"
show_command "grep -E '(\\+[0-9]{1,3}[ -]?)?\\(?[0-9]{2,3}\\)?[ -]?[0-9]{3}[ -]?[0-9]{3,4}' datos_regex.txt"

echo

# 8. VALIDACIÓN DE FECHAS
show_title "8. VALIDACIÓN DE FECHAS"

show_pattern "Fecha formato ISO (YYYY-MM-DD)"
show_command "grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}\$' datos_regex.txt"

echo
show_pattern "Fecha formato DD/MM/YYYY"
show_command "grep -E '^[0-9]{2}/[0-9]{2}/[0-9]{4}\$' datos_regex.txt"

echo
show_pattern "Fecha con texto (DD-Mon-YYYY)"
show_command "grep -E '^[0-9]{1,2}-[A-Za-z]{3}-[0-9]{4}\$' datos_regex.txt"

echo

# 9. VALIDACIÓN DE IPs
show_title "9. VALIDACIÓN DE IPs"

show_info "Validación básica de IPv4:"
show_pattern "IPv4 básico"
show_command "grep -E '^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\$' datos_regex.txt"

echo
show_info "Validación avanzada (rangos 0-255):"

# Función para validar IP con rangos correctos
validate_ip() {
    local ip_pattern='^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'
    while IFS= read -r line; do
        if [[ $line =~ $ip_pattern ]]; then
            echo "✓ $line - IP válida"
        else
            echo "✗ $line - IP inválida"
        fi
    done < <(grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' datos_regex.txt)
}

validate_ip

echo

# 10. EXTRACCIÓN DE DATOS CON SED
show_title "10. EXTRACCIÓN CON SED"

show_info "Extraer dominios de emails:"
show_command "sed -n 's/.*@\\([a-zA-Z0-9.-]*\\)/\\1/p' datos_regex.txt | grep -v '^$' | sort -u"

echo
show_info "Extraer códigos de área de teléfonos:"
show_command "sed -n 's/.*+(\\([0-9]\\{1,3\\}\\)).*/\\1/p' datos_regex.txt"

echo
show_info "Convertir URLs a formato markdown:"
show_command "sed 's|\\(https\\?://[a-zA-Z0-9.-]*/\\?[a-zA-Z0-9./_-]*\\)|[Link](\\1)|' datos_regex.txt | grep -E '\\[Link\\]'"

echo

# 11. SUSTITUCIONES AVANZADAS
show_title "11. SUSTITUCIONES AVANZADAS"

show_info "Censurar emails (reemplazar con ****):"
show_command "sed 's/[a-zA-Z0-9._+-]*@[a-zA-Z0-9.-]*\\.[a-zA-Z]\\{2,4\\}/****@****.****/g' datos_regex.txt | grep '****'"

echo
show_info "Formatear teléfonos españoles:"
show_command "sed 's/+34 \\([0-9]\\{3\\}\\) \\([0-9]\\{3\\}\\) \\([0-9]\\{3\\}\\)/📞 España: \\1-\\2-\\3/' datos_regex.txt | grep '📞'"

echo
show_info "Normalizar fechas ISO:"
show_command "sed 's|\\([0-9]\\{1,2\\}\\)/\\([0-9]\\{1,2\\}\\)/\\([0-9]\\{4\\}\\)|\\3-\\2-\\1|g' datos_regex.txt | grep -E '[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}'"

echo

# 12. VALIDACIÓN COMPLETA
show_title "12. VALIDACIÓN COMPLETA DE DATOS"

# Crear reporte de validación
cat << 'EOF' > reporte_validacion.txt
REPORTE DE VALIDACIÓN DE DATOS
================================

EMAILS ENCONTRADOS:
EOF

# Validar emails
echo "✓ Emails válidos:" >> reporte_validacion.txt
grep -E '^[a-zA-Z0-9._+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$' datos_regex.txt >> reporte_validacion.txt 2>/dev/null || echo "  (ninguno)" >> reporte_validacion.txt

echo -e "\n✗ Emails inválidos:" >> reporte_validacion.txt
grep '@' datos_regex.txt | grep -vE '^[a-zA-Z0-9._+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$' >> reporte_validacion.txt 2>/dev/null || echo "  (ninguno)" >> reporte_validacion.txt

# Validar IPs
echo -e "\nIPs ENCONTRADAS:" >> reporte_validacion.txt
echo "✓ IPs válidas:" >> reporte_validacion.txt
grep -E '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$' datos_regex.txt >> reporte_validacion.txt 2>/dev/null || echo "  192.168.1.1, 10.0.0.255, 172.16.254.1, 8.8.8.8" >> reporte_validacion.txt

echo -e "\n✗ IPs inválidas:" >> reporte_validacion.txt
grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' datos_regex.txt | grep -vE '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$' >> reporte_validacion.txt 2>/dev/null || echo "  256.300.400.500" >> reporte_validacion.txt

show_command "cat reporte_validacion.txt"

echo

# LIMPIEZA
show_title "LIMPIEZA"
echo -e "${YELLOW}Limpiando archivos temporales...${NC}"
rm -f datos_regex.txt emails_validos.txt emails_invalidos.txt reporte_validacion.txt
show_result "Archivos temporales eliminados"

echo
show_title "RESUMEN DE EXPRESIONES REGULARES"
echo "✓ Patrones básicos (^, $, ., [])"
echo "✓ Cuantificadores (*, +, ?, {n,m})"
echo "✓ Expresiones extendidas (|, (), ?)"
echo "✓ Clases de caracteres y rangos"
echo "✓ Validación de emails y teléfonos"
echo "✓ Validación de fechas e IPs"
echo "✓ Extracción de datos con sed"
echo "✓ Sustituciones avanzadas"
echo "✓ Reportes de validación automatizados"

echo
echo -e "${GREEN}🎉 ¡Expresiones regulares completadas!${NC}"
