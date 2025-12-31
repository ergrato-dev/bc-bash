#!/bin/bash
# ============================================
# PRACTICA 4: awk Procesamiento Columnar
# Semana 5: Procesamiento de Texto
# SOLUCION COMPLETA
# ============================================

TMPDIR="/tmp/awk_practice_$$"
mkdir -p "$TMPDIR"

# ============================================
# PASO 1: Crear Datos de Prueba
# ============================================
echo "--- Paso 1: Crear Datos de Prueba ---"

# Crear archivo de ventas (espacio como separador)
cat > "$TMPDIR/ventas.txt" << 'EOF'
Producto Cantidad Precio
Laptop 5 1200
Mouse 50 25
Teclado 30 75
Monitor 10 350
Webcam 20 80
Auriculares 40 60
EOF

# Crear archivo CSV de empleados
cat > "$TMPDIR/empleados.csv" << 'EOF'
nombre,departamento,salario,antiguedad
Juan,Ventas,45000,3
Maria,IT,65000,5
Carlos,Marketing,50000,2
Ana,IT,70000,7
Pedro,Ventas,48000,4
Laura,HR,55000,6
EOF

echo "=== ventas.txt ==="
cat "$TMPDIR/ventas.txt"
echo ""
echo "=== empleados.csv ==="
cat "$TMPDIR/empleados.csv"

echo ""

# ============================================
# PASO 2: Imprimir Campos
# ============================================
echo "--- Paso 2: Imprimir Campos ---"

# $1 = primer campo, $2 = segundo, etc
echo "Primer campo (Producto):"
awk '{print $1}' "$TMPDIR/ventas.txt"

# Multiples campos
echo ""
echo "Producto y Precio (campos 1 y 3):"
awk '{print $1, $3}' "$TMPDIR/ventas.txt"

# $NF = ultimo campo
echo ""
echo "Ultimo campo de cada linea (\$NF):"
awk '{print $NF}' "$TMPDIR/ventas.txt"

echo ""

# ============================================
# PASO 3: Separador de Campos
# ============================================
echo "--- Paso 3: Separador de Campos ---"

# -F define el separador de entrada
echo "Nombres de empleados (CSV con -F','):"
awk -F',' '{print $1}' "$TMPDIR/empleados.csv"

echo ""
echo "Nombre y Salario:"
awk -F',' '{print $1, $3}' "$TMPDIR/empleados.csv"

# Ejemplo con /etc/passwd
echo ""
echo "Primeros 5 usuarios del sistema:"
awk -F':' '{print $1}' /etc/passwd | head -5

echo ""

# ============================================
# PASO 4: Variables Built-in
# ============================================
echo "--- Paso 4: Variables Built-in ---"

# NR = numero de registro (linea actual)
echo "Numero de linea con NR:"
awk '{print NR, $0}' "$TMPDIR/ventas.txt"

# NF = numero de campos en la linea
echo ""
echo "Campos por linea (NF):"
awk '{print "Linea", NR, "tiene", NF, "campos"}' "$TMPDIR/ventas.txt"

# Combinar NR y condicion
echo ""
echo "Saltar encabezado (NR > 1):"
awk 'NR > 1 {print $1, $2}' "$TMPDIR/ventas.txt"

echo ""

# ============================================
# PASO 5: Filtrar por Condicion
# ============================================
echo "--- Paso 5: Filtrar por Condicion ---"

# Filtrar por valor numerico
echo "Productos con cantidad > 25:"
awk 'NR > 1 && $2 > 25 {print $1, $2}' "$TMPDIR/ventas.txt"

# Filtrar por patron
echo ""
echo "Empleados del departamento IT:"
awk -F',' '$2 == "IT" {print $1, $3}' "$TMPDIR/empleados.csv"

# Operador regex ~
echo ""
echo "Productos que contienen 'a':"
awk '$1 ~ /a/ {print $1}' "$TMPDIR/ventas.txt"

echo ""

# ============================================
# PASO 6: Calculos y Acumuladores
# ============================================
echo "--- Paso 6: Calculos y Acumuladores ---"

# Sumar una columna
echo "Suma de cantidades:"
awk 'NR > 1 {sum += $2} END {print "Total:", sum}' "$TMPDIR/ventas.txt"

# Calcular total por fila
echo ""
echo "Total por producto (cantidad * precio):"
awk 'NR > 1 {print $1, $2 * $3}' "$TMPDIR/ventas.txt"

# Promedio
echo ""
echo "Salario promedio:"
awk -F',' 'NR > 1 {sum += $3; count++} END {print "Promedio:", sum/count}' "$TMPDIR/empleados.csv"

# Maximo y minimo
echo ""
echo "Salario maximo:"
awk -F',' 'NR > 1 {if ($3 > max || NR == 2) {max = $3; emp = $1}} END {print emp, max}' "$TMPDIR/empleados.csv"

echo ""

# ============================================
# PASO 7: BEGIN y END
# ============================================
echo "--- Paso 7: BEGIN y END ---"

# BEGIN ejecuta antes de procesar, END al final
echo "Reporte de ventas con header y footer:"
awk 'BEGIN {
    print "=== REPORTE DE VENTAS ==="
    print ""
}
NR > 1 {
    total = $2 * $3
    sum += total
    print $1, ":", total
}
END {
    print ""
    print "Total general:", sum
    print "========================="
}' "$TMPDIR/ventas.txt"

echo ""

# ============================================
# PASO 8: Formateo con printf
# ============================================
echo "--- Paso 8: Formateo con printf ---"

# printf para formato preciso
echo "Tabla formateada de ventas:"
awk 'BEGIN {
    printf "%-15s %10s %10s %12s\n", "PRODUCTO", "CANTIDAD", "PRECIO", "TOTAL"
    printf "%-15s %10s %10s %12s\n", "---------------", "----------", "----------", "------------"
}
NR > 1 {
    total = $2 * $3
    printf "%-15s %10d %10.2f %12.2f\n", $1, $2, $3, total
    sum += total
}
END {
    printf "%-15s %10s %10s %12s\n", "---------------", "----------", "----------", "------------"
    printf "%-15s %10s %10s %12.2f\n", "TOTAL", "", "", sum
}' "$TMPDIR/ventas.txt"

# Reporte de empleados
echo ""
echo "Empleados con salario > 50000:"
awk -F',' 'BEGIN {
    printf "%-10s %-12s %10s\n", "Nombre", "Depto", "Salario"
    printf "%-10s %-12s %10s\n", "----------", "------------", "----------"
}
NR > 1 && $3 > 50000 {
    printf "%-10s %-12s $%9.2f\n", $1, $2, $3
}' "$TMPDIR/empleados.csv"

echo ""

# Limpiar
rm -rf "$TMPDIR"

echo "=== Practica 4 completada ==="
