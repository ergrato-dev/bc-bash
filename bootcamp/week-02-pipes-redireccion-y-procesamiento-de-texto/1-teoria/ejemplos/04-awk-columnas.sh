#!/bin/bash
# Ejemplo 04: Awk - Procesamiento de Columnas
# Descripción: Trabajar con datos tabulares usando awk

# Crear archivo CSV de prueba
cat > temp_ventas.csv << EOF
Producto,Cantidad,Precio,Vendedor
Laptop,5,1200,Juan
Mouse,15,25,Maria
Teclado,10,75,Pedro
Monitor,8,350,Ana
Laptop,3,1200,Carlos
Mouse,20,25,Juan
EOF

echo "=== Archivo CSV Original ==="
cat temp_ventas.csv
echo

# === Imprimir columnas específicas ===
echo "=== 1. Solo productos (columna 1) ==="
awk -F',' '{print $1}' temp_ventas.csv

# === Múltiples columnas ===
echo -e "\n=== 2. Producto y Cantidad ==="
awk -F',' '{print $1, $2}' temp_ventas.csv

# === Saltar header ===
echo -e "\n=== 3. Sin encabezado (desde línea 2) ==="
awk -F',' 'NR>1 {print $1, $2}' temp_ventas.csv

# === Filtrar por condición ===
echo -e "\n=== 4. Productos con cantidad > 10 ==="
awk -F',' 'NR>1 && $2>10 {print $1, $2}' temp_ventas.csv

# === Calcular total ===
echo -e "\n=== 5. Total de unidades vendidas ==="
awk -F',' 'NR>1 {sum+=$2} END {print "Total:", sum}' temp_ventas.csv

# === Calcular ingresos ===
echo -e "\n=== 6. Ingresos por producto ==="
awk -F',' 'NR>1 {print $1, ":", $2*$3}' temp_ventas.csv

# === Promedio ===
echo -e "\n=== 7. Precio promedio ==="
awk -F',' 'NR>1 {sum+=$3; count++} END {print "Promedio:", sum/count}' temp_ventas.csv

# === Contar ocurrencias ===
echo -e "\n=== 8. Ventas por vendedor ==="
awk -F',' 'NR>1 {ventas[$4]+=$2} END {for(v in ventas) print v, ventas[v]}' temp_ventas.csv

# === Formatear salida ===
echo -e "\n=== 9. Tabla formateada ==="
awk -F',' 'NR>1 {printf "%-10s %5d x $%-5d = $%d\n", $1, $2, $3, $2*$3}' temp_ventas.csv

# === Filtro complejo ===
echo -e "\n=== 10. Laptops vendidas por Juan o Carlos ==="
awk -F',' 'NR>1 && $1=="Laptop" && ($4=="Juan" || $4=="Carlos") {print $0}' temp_ventas.csv

# === Agregar columna calculada ===
echo -e "\n=== 11. Con columna Total ==="
awk -F',' 'BEGIN{print "Producto,Cantidad,Precio,Total"} NR>1 {print $1","$2","$3","$2*$3}' temp_ventas.csv

# Limpiar
rm -f temp_ventas.csv
echo -e "\n✓ Limpieza completada"
