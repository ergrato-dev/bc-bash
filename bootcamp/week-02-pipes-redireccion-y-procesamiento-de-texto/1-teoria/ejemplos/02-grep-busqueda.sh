#!/bin/bash
# Ejemplo 02: Grep - Búsqueda de Patrones
# Descripción: Usar grep para buscar texto

# Crear archivo de log de prueba
cat > temp_server.log << EOF
2025-01-15 10:23:45 INFO Server started on port 8080
2025-01-15 10:24:12 ERROR Connection timeout to database
2025-01-15 10:24:30 INFO User admin logged in
2025-01-15 10:25:01 WARNING Low memory: 15% available
2025-01-15 10:25:45 ERROR Failed to load configuration
2025-01-15 10:26:10 INFO Request processed successfully
2025-01-15 10:27:33 ERROR Database connection lost
2025-01-15 10:28:00 INFO Server shutdown initiated
EOF

echo "=== Archivo de log creado ==="
cat temp_server.log
echo

# === Búsqueda básica ===
echo "=== 1. Buscar 'ERROR' ==="
grep "ERROR" temp_server.log

# === Búsqueda case-insensitive ===
echo -e "\n=== 2. Buscar 'error' (ignora mayúsculas) ==="
grep -i "error" temp_server.log

# === Contar coincidencias ===
echo -e "\n=== 3. Contar errores ==="
grep -c "ERROR" temp_server.log

# === Mostrar números de línea ===
echo -e "\n=== 4. Errores con números de línea ==="
grep -n "ERROR" temp_server.log

# === Invertir búsqueda (NOT) ===
echo -e "\n=== 5. Todo EXCEPTO INFO ==="
grep -v "INFO" temp_server.log

# === Contexto (líneas antes y después) ===
echo -e "\n=== 6. ERROR con contexto (1 línea antes y después) ==="
grep -C 1 "Database connection lost" temp_server.log

# === Búsqueda con regex ===
echo -e "\n=== 7. Líneas con números (regex) ==="
grep -E "[0-9]{4}" temp_server.log

# === Múltiples patrones ===
echo -e "\n=== 8. ERROR o WARNING ==="
grep -E "ERROR|WARNING" temp_server.log

# === Solo nombres de archivo con coincidencias ===
echo -e "\n=== 9. Archivo contiene 'ERROR' ==="
grep -l "ERROR" temp_server.log

# === Colorear resultados ===
echo -e "\n=== 10. Resultados con color ==="
grep --color=always "ERROR" temp_server.log

# Limpiar
rm -f temp_server.log
echo -e "\n✓ Limpieza completada"
