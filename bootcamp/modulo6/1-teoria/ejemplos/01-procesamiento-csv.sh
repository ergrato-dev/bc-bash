#!/bin/bash
# Ejemplo 01: Procesamiento de CSV
# Descripción: Manipulación avanzada de archivos CSV

echo "=== Procesamiento de CSV Avanzado ==="

# === 1. Crear CSV de ejemplo ===
echo -e "\n=== 1. Crear CSV de Ejemplo ==="

cat > usuarios.csv << 'EOF'
id,nombre,edad,ciudad,salario
1,Juan Pérez,28,Madrid,35000
2,María García,32,Barcelona,42000
3,Carlos López,25,Valencia,28000
4,Ana Martínez,35,Sevilla,45000
5,Luis Rodríguez,29,Bilbao,38000
6,Carmen Sánchez,31,Málaga,40000
EOF

echo "✓ Archivo usuarios.csv creado"
cat usuarios.csv

# === 2. Leer CSV línea por línea ===
echo -e "\n=== 2. Leer CSV Línea por Línea ==="

contador=0
while IFS=',' read -r id nombre edad ciudad salario; do
    if [ $contador -eq 0 ]; then
        echo "Encabezados: $id | $nombre | $edad | $ciudad | $salario"
    else
        echo "Usuario $id: $nombre ($edad años) - $ciudad"
    fi
    contador=$((contador + 1))
done < usuarios.csv

# === 3. Filtrar por condición ===
echo -e "\n=== 3. Filtrar: Edad > 30 ==="

awk -F',' 'NR==1 {print; next} $3 > 30' usuarios.csv

# === 4. Seleccionar columnas específicas ===
echo -e "\n=== 4. Seleccionar Columnas (nombre, ciudad) ==="

cut -d',' -f2,4 usuarios.csv

# === 5. Ordenar por columna ===
echo -e "\n=== 5. Ordenar por Salario (descendente) ==="

(head -1 usuarios.csv && tail -n +2 usuarios.csv | sort -t',' -k5 -nr)

# === 6. Calcular estadísticas ===
echo -e "\n=== 6. Estadísticas de Salarios ==="

# Saltar encabezado y calcular
tail -n +2 usuarios.csv | awk -F',' '
{
    sum += $5
    count++
    if (NR == 1 || $5 > max) max = $5
    if (NR == 1 || $5 < min) min = $5
}
END {
    print "Total empleados: " count
    print "Salario promedio: " sum/count
    print "Salario máximo: " max
    print "Salario mínimo: " min
}'

# === 7. Agregar nueva columna ===
echo -e "\n=== 7. Agregar Columna: Categoría ==="

awk -F',' 'BEGIN {OFS=","}
NR==1 {print $0, "categoria"; next}
{
    if ($5 >= 40000) cat = "Senior"
    else if ($5 >= 30000) cat = "Mid"
    else cat = "Junior"
    print $0, cat
}' usuarios.csv

# === 8. Agrupar y contar ===
echo -e "\n=== 8. Contar Usuarios por Ciudad ==="

tail -n +2 usuarios.csv | cut -d',' -f4 | sort | uniq -c | awk '{print $2 ": " $1 " usuario(s)"}'

# === 9. Buscar y reemplazar ===
echo -e "\n=== 9. Reemplazar 'Madrid' por 'Madrid (Capital)' ==="

sed 's/Madrid/Madrid (Capital)/g' usuarios.csv | head -3

# === 10. Convertir CSV a JSON ===
echo -e "\n=== 10. Convertir CSV a JSON ==="

awk -F',' '
BEGIN { print "[" }
NR==1 { 
    for (i=1; i<=NF; i++) headers[i] = $i
    next
}
{
    printf "%s  {\n", (NR==2 ? "" : ",\n")
    for (i=1; i<=NF; i++) {
        printf "    \"%s\": ", headers[i]
        if ($i ~ /^[0-9]+$/) printf "%s", $i
        else printf "\"%s\"", $i
        if (i < NF) printf ","
        printf "\n"
    }
    printf "  }"
}
END { print "\n]" }
' usuarios.csv > usuarios.json

echo "✓ Archivo usuarios.json creado"
head -15 usuarios.json

# === 11. Validar formato CSV ===
echo -e "\n=== 11. Validar Formato CSV ==="

validar_csv() {
    local archivo=$1
    local num_columnas=$(head -1 "$archivo" | awk -F',' '{print NF}')
    local linea=0
    local errores=0
    
    while IFS= read -r line; do
        linea=$((linea + 1))
        local cols=$(echo "$line" | awk -F',' '{print NF}')
        
        if [ "$cols" -ne "$num_columnas" ]; then
            echo "⚠ Línea $linea: tiene $cols columnas (esperadas: $num_columnas)"
            errores=$((errores + 1))
        fi
    done < "$archivo"
    
    if [ $errores -eq 0 ]; then
        echo "✓ CSV válido: todas las líneas tienen $num_columnas columnas"
    else
        echo "✗ CSV inválido: $errores error(es) encontrado(s)"
    fi
}

validar_csv usuarios.csv

# === 12. Merge de dos CSVs ===
echo -e "\n=== 12. Merge de CSVs ==="

# Crear segundo CSV
cat > departamentos.csv << 'EOF'
id,departamento
1,IT
2,Marketing
3,IT
4,Ventas
5,IT
6,Marketing
EOF

echo "Archivo departamentos.csv:"
cat departamentos.csv

echo -e "\nMerge por ID:"
awk -F',' '
NR==FNR {
    if (NR==1) next
    dept[$1] = $2
    next
}
{
    if (NR==1) {
        print $0 ",departamento"
    } else {
        print $0 "," (dept[$1] ? dept[$1] : "N/A")
    }
}
' departamentos.csv usuarios.csv | head -5

# === 13. Pivotear datos ===
echo -e "\n=== 13. Pivot: Salario Promedio por Ciudad ==="

tail -n +2 usuarios.csv | awk -F',' '
{
    ciudad = $4
    salario = $5
    suma[ciudad] += salario
    count[ciudad]++
}
END {
    print "Ciudad,Salario_Promedio"
    for (c in suma) {
        printf "%s,%.0f\n", c, suma[c]/count[c]
    }
}' | sort -t',' -k2 -nr

# === 14. Exportar a formato TSV ===
echo -e "\n=== 14. Convertir CSV a TSV ==="

sed 's/,/\t/g' usuarios.csv > usuarios.tsv
echo "✓ Archivo usuarios.tsv creado"
head -3 usuarios.tsv

# === 15. Limpieza y normalización ===
echo -e "\n=== 15. Limpiar CSV (eliminar espacios) ==="

# CSV con espacios
cat > sucio.csv << 'EOF'
nombre, edad , ciudad
Juan , 28, Madrid 
María,32 , Barcelona
EOF

echo "Antes de limpiar:"
cat sucio.csv

echo -e "\nDespués de limpiar:"
sed 's/ *, */,/g; s/ *$//g; s/^ *//g' sucio.csv

# Limpiar archivos temporales
rm -f usuarios.csv usuarios.json usuarios.tsv departamentos.csv sucio.csv

echo -e "\n✓ Script completado"
