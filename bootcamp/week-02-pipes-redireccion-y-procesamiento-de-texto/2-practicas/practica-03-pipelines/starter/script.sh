#!/bin/bash
# ============================================
# PRÁCTICA 03: Pipelines con sed y awk
# Semana 02 - Bash Bootcamp
# ============================================
set -euo pipefail

echo "🔧 Práctica 03: Pipelines con sed y awk"
echo "========================================"
echo ""

# ============================================
# PREPARACIÓN: Crear archivos de prueba
# ============================================
echo "📝 Preparando archivos de prueba..."

cat > /tmp/ventas.csv << 'EOF'
fecha,producto,cantidad,precio,vendedor
2024-01-15,Laptop,2,1200,Ana
2024-01-15,Mouse,5,25,Pedro
2024-01-16,Teclado,3,75,Ana
2024-01-16,Monitor,1,350,Luis
2024-01-17,Laptop,1,1200,Pedro
2024-01-17,Mouse,10,25,Ana
2024-01-18,Teclado,2,75,Luis
2024-01-18,Monitor,2,350,Pedro
EOF

cat > /tmp/access.log << 'EOF'
192.168.1.100 - - [15/Jan/2024:10:00:00] "GET /index.html HTTP/1.1" 200 1234
192.168.1.101 - - [15/Jan/2024:10:01:00] "GET /about.html HTTP/1.1" 200 2345
192.168.1.100 - - [15/Jan/2024:10:02:00] "POST /api/login HTTP/1.1" 401 123
192.168.1.102 - - [15/Jan/2024:10:03:00] "GET /products HTTP/1.1" 200 5678
192.168.1.100 - - [15/Jan/2024:10:04:00] "GET /index.html HTTP/1.1" 200 1234
192.168.1.103 - - [15/Jan/2024:10:05:00] "GET /api/data HTTP/1.1" 500 89
192.168.1.101 - - [15/Jan/2024:10:06:00] "GET /contact HTTP/1.1" 404 456
EOF

echo "✓ Archivos creados en /tmp/"
echo ""

# ============================================
# PARTE A: sed - Transformaciones
# ============================================
echo "═══════════════════════════════════════"
echo "PARTE A: Transformaciones con sed"
echo "═══════════════════════════════════════"
echo ""

# ============================================
# PASO 1: Sustitución Simple
# ============================================
echo "--- Paso 1: Sustitución Simple ---"

# sed 's/viejo/nuevo/' reemplaza la primera ocurrencia.
# sed 's/viejo/nuevo/g' reemplaza TODAS las ocurrencias.

# Descomenta las siguientes líneas:
# echo "Cambiar 'Laptop' por 'Portátil':"
# sed 's/Laptop/Portátil/g' /tmp/ventas.csv | head -5

echo ""

# ============================================
# PASO 2: Múltiples Sustituciones
# ============================================
echo "--- Paso 2: Múltiples Sustituciones ---"

# Puedes encadenar sed con -e o con pipes.
# -e permite múltiples comandos.

# Descomenta las siguientes líneas:
# echo "Cambiar varios productos:"
# sed -e 's/Laptop/Portátil/g' -e 's/Mouse/Ratón/g' -e 's/Teclado/Keyboard/g' /tmp/ventas.csv | head -5

echo ""

# ============================================
# PASO 3: Eliminar Líneas
# ============================================
echo "--- Paso 3: Eliminar Líneas ---"

# sed '/patrón/d' elimina líneas que coinciden.
# Útil para filtrar datos.

# Descomenta las siguientes líneas:
# echo "Ventas sin la cabecera (eliminar primera línea):"
# sed '1d' /tmp/ventas.csv

echo ""

# ============================================
# PASO 4: Delimitadores Alternativos
# ============================================
echo "--- Paso 4: Delimitadores Alternativos ---"

# Cuando el patrón tiene /, usa otro delimitador.
# sed 's|/old|/new|' o sed 's#/old#/new#'

# Descomenta las siguientes líneas:
# echo "Cambiar ruta en logs:"
# echo "/home/user/old/path" | sed 's|/old/|/new/|'

echo ""

# ============================================
# PARTE B: awk - Procesamiento de Columnas
# ============================================
echo ""
echo "═══════════════════════════════════════"
echo "PARTE B: Procesamiento con awk"
echo "═══════════════════════════════════════"
echo ""

# ============================================
# PASO 5: Imprimir Columnas
# ============================================
echo "--- Paso 5: Imprimir Columnas ---"

# awk '{print $N}' imprime la columna N.
# -F define el separador de campos.

# Descomenta las siguientes líneas:
# echo "Productos y cantidades (columnas 2 y 3):"
# awk -F',' 'NR > 1 {print $2, $3}' /tmp/ventas.csv

echo ""

# ============================================
# PASO 6: Condiciones en awk
# ============================================
echo "--- Paso 6: Condiciones en awk ---"

# awk 'condición {acción}' filtra por condición.
# $3 > 2 significa "columna 3 mayor que 2"

# Descomenta las siguientes líneas:
# echo "Ventas con cantidad > 2:"
# awk -F',' 'NR > 1 && $3 > 2 {print $2, $3, $5}' /tmp/ventas.csv

echo ""

# ============================================
# PASO 7: Cálculos con awk
# ============================================
echo "--- Paso 7: Cálculos con awk ---"

# awk puede hacer operaciones matemáticas.
# Variables se acumulan línea por línea.

# Descomenta las siguientes líneas:
# echo "Total de unidades vendidas:"
# awk -F',' 'NR > 1 {total += $3} END {print "Total:", total, "unidades"}' /tmp/ventas.csv

echo ""

# ============================================
# PASO 8: printf para Formato
# ============================================
echo "--- Paso 8: Formato con printf ---"

# printf permite formatear la salida.
# %-10s = string alineado izquierda, 10 caracteres
# %d = entero, %f = decimal

# Descomenta las siguientes líneas:
# echo "Ventas formateadas:"
# awk -F',' 'NR > 1 {printf "%-10s %3d unidades @ $%d\n", $2, $3, $4}' /tmp/ventas.csv

echo ""

# ============================================
# PARTE C: Pipelines Completos
# ============================================
echo ""
echo "═══════════════════════════════════════"
echo "PARTE C: Pipelines Completos"
echo "═══════════════════════════════════════"
echo ""

# ============================================
# PASO 9: grep + awk
# ============================================
echo "--- Paso 9: grep + awk ---"

# Combinar grep para filtrar y awk para procesar.
# Primero filtrar, luego extraer columnas.

# Descomenta las siguientes líneas:
# echo "Ventas de Ana (solo producto y cantidad):"
# grep "Ana" /tmp/ventas.csv | awk -F',' '{print $2, $3}'

echo ""

# ============================================
# PASO 10: Pipeline de Análisis de Logs
# ============================================
echo "--- Paso 10: Análisis de Access Log ---"

# Pipeline: extraer IPs → ordenar → contar únicos.
# Útil para identificar visitantes frecuentes.

# Descomenta las siguientes líneas:
# echo "IPs ordenadas por número de peticiones:"
# awk '{print $1}' /tmp/access.log | sort | uniq -c | sort -rn

echo ""

# ============================================
# PASO 11: Filtrar Errores HTTP
# ============================================
echo "--- Paso 11: Filtrar Errores HTTP ---"

# Buscar códigos de error (4xx, 5xx) en logs.
# Combinar grep + awk para extraer información.

# Descomenta las siguientes líneas:
# echo "Peticiones con error (4xx, 5xx):"
# awk '$9 >= 400 {print $1, $9, $7}' /tmp/access.log

echo ""

# ============================================
# PASO 12: Reporte de Ventas por Vendedor
# ============================================
echo "--- Paso 12: Reporte de Ventas ---"

# Agrupar ventas por vendedor y calcular totales.
# Usar arrays asociativos de awk.

# Descomenta las siguientes líneas:
# echo "Total vendido por cada vendedor:"
# awk -F',' 'NR > 1 {ventas[$5] += $3 * $4} END {for (v in ventas) printf "%-10s $%d\n", v, ventas[v]}' /tmp/ventas.csv | sort -t'$' -k2 -rn

echo ""

# ============================================
# PASO 13: Pipeline Transformación Completa
# ============================================
echo "--- Paso 13: Pipeline Completo ---"

# Transformar CSV a formato legible:
# 1. Eliminar cabecera (sed)
# 2. Cambiar separador (sed)
# 3. Filtrar por condición (awk)
# 4. Formatear salida (awk)

# Descomenta las siguientes líneas:
# echo "Ventas de Laptops/Monitores (formato legible):"
# sed '1d' /tmp/ventas.csv | \
#   grep -E "Laptop|Monitor" | \
#   awk -F',' '{printf "%s: %s vendió %d x %s = $%d\n", $1, $5, $3, $2, $3*$4}'

echo ""

# ============================================
# LIMPIEZA
# ============================================
echo "--- Limpieza ---"
# rm -f /tmp/ventas.csv /tmp/access.log
echo "Archivos temporales limpiados (descomenta para activar)"
echo ""

echo "✅ Práctica completada!"
echo ""
echo "📚 Resumen:"
echo ""
echo "sed:"
echo "   s/old/new/g   Sustituir (g = global)"
echo "   /patrón/d     Eliminar líneas"
echo "   Nd            Eliminar línea N"
echo ""
echo "awk:"
echo "   -F','         Separador de campos"
echo "   {print \$1}    Imprimir columna 1"
echo "   NR > 1        Saltar primera línea"
echo "   END {}        Ejecutar al final"
echo ""
echo "Pipeline típico:"
echo "   grep 'filtro' | sed 's/a/b/' | awk '{print \$1}' | sort | uniq -c"
