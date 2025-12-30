#!/bin/bash
# Ejemplo 01: Introducción a Pipes
# Descripción: Conectar comandos con pipes (|)

echo "=== Pipes Básicos ==="

# Crear archivo de prueba
cat > temp_usuarios.txt << EOF
juan:admin:1001
maria:user:1002
pedro:admin:1003
ana:user:1004
carlos:admin:1005
EOF

echo "Archivo creado: temp_usuarios.txt"
echo

# === Pipe simple ===
echo "=== 1. Mostrar archivo y contar líneas ==="
cat temp_usuarios.txt | wc -l

# === Múltiples pipes ===
echo -e "\n=== 2. Extraer columna y ordenar ==="
cat temp_usuarios.txt | cut -d':' -f1 | sort

# === Pipe con filtro ===
echo -e "\n=== 3. Filtrar solo admins ==="
cat temp_usuarios.txt | grep "admin"

# === Pipe complejo ===
echo -e "\n=== 4. Usuarios admin ordenados ==="
cat temp_usuarios.txt | grep "admin" | cut -d':' -f1 | sort

# === Pipe con transformación ===
echo -e "\n=== 5. Usuarios en MAYÚSCULAS ==="
cat temp_usuarios.txt | cut -d':' -f1 | tr '[:lower:]' '[:upper:]'

# === Contar resultados filtrados ===
echo -e "\n=== 6. Cantidad de admins ==="
cat temp_usuarios.txt | grep "admin" | wc -l

# === Pipeline legible (multi-línea) ===
echo -e "\n=== 7. Pipeline complejo y legible ==="
cat temp_usuarios.txt | \
    grep "admin" | \
    cut -d':' -f1,3 | \
    sort -t':' -k2 -n

# Limpiar
rm -f temp_usuarios.txt
echo -e "\n✓ Limpieza completada"
