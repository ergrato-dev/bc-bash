#!/bin/bash
# Ejemplo 03: Sed - Editor de Stream
# Descripción: Transformar texto con sed

# Crear archivo de prueba
cat > temp_datos.txt << EOF
Nombre: juan perez
Email: juan@ejemplo.com
Tel: 123-456-7890
Ciudad: madrid
Estado: activo
EOF

echo "=== Archivo Original ==="
cat temp_datos.txt
echo

# === Reemplazo simple ===
echo "=== 1. Reemplazar 'juan' por 'Juan' ==="
sed 's/juan/Juan/' temp_datos.txt

# === Reemplazo global (todas las ocurrencias) ===
echo -e "\n=== 2. Reemplazar todas las 'a' por 'A' ==="
sed 's/a/A/g' temp_datos.txt

# === Reemplazo case-insensitive ===
echo -e "\n=== 3. Reemplazar 'madrid' (ignora mayúsculas) ==="
sed 's/madrid/Madrid/I' temp_datos.txt

# === Eliminar líneas ===
echo -e "\n=== 4. Eliminar línea que contiene 'Tel' ==="
sed '/Tel/d' temp_datos.txt

# === Eliminar líneas vacías ===
echo -e "\n=== 5. Sin líneas vacías ==="
echo -e "línea1\n\nlínea2\n\nlínea3" | sed '/^$/d'

# === Agregar texto al inicio ===
echo -e "\n=== 6. Agregar prefijo a cada línea ==="
sed 's/^/>> /' temp_datos.txt

# === Agregar texto al final ===
echo -e "\n=== 7. Agregar sufijo a cada línea ==="
sed 's/$/ <</' temp_datos.txt

# === Reemplazar en línea específica ===
echo -e "\n=== 8. Reemplazar solo en línea 2 ==="
sed '2s/juan/JUAN/' temp_datos.txt

# === Múltiples reemplazos ===
echo -e "\n=== 9. Múltiples reemplazos encadenados ==="
sed -e 's/juan/Juan/g' -e 's/madrid/Madrid/g' temp_datos.txt

# === Extraer líneas específicas ===
echo -e "\n=== 10. Líneas 2 a 4 ==="
sed -n '2,4p' temp_datos.txt

# === In-place editing (modificar archivo) ===
echo -e "\n=== 11. Modificar archivo (backup) ==="
cp temp_datos.txt temp_datos_original.txt
sed -i.bak 's/juan/Juan/g' temp_datos.txt
echo "Archivo modificado:"
cat temp_datos.txt

# Limpiar
rm -f temp_datos.txt temp_datos.txt.bak temp_datos_original.txt
echo -e "\n✓ Limpieza completada"
