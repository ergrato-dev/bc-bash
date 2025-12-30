#!/bin/bash
# ============================================
# PRÁCTICA 02: Búsqueda con grep
# Semana 02 - Bash Bootcamp
# ============================================
set -euo pipefail

echo "🔍 Práctica 02: Búsqueda con grep"
echo "=================================="
echo ""

# ============================================
# PREPARACIÓN: Crear archivo de prueba
# ============================================
echo "📝 Preparando archivos de prueba..."

cat > /tmp/empleados.txt << 'EOF'
Juan Pérez, Desarrollador, 2500, Madrid
María García, Diseñadora, 2200, Barcelona
Pedro López, Administrador, 2800, Valencia
Ana Martín, Desarrolladora, 2600, Madrid
Luis Rodríguez, Diseñador, 2100, Sevilla
Carmen Sánchez, Administradora, 2750, Madrid
Roberto Fernández, Desarrollador, 2900, Barcelona
EOF

cat > /tmp/log.txt << 'EOF'
[2024-01-15 10:00:00] INFO: Sistema iniciado
[2024-01-15 10:01:23] WARNING: Memoria al 80%
[2024-01-15 10:02:45] ERROR: Conexión rechazada
[2024-01-15 10:03:12] INFO: Usuario admin conectado
[2024-01-15 10:04:00] error: Timeout de base de datos
[2024-01-15 10:05:30] INFO: Backup completado
[2024-01-15 10:06:15] ERROR: Disco lleno
[2024-01-15 10:07:00] Info: Servicio reiniciado
EOF

echo "✓ Archivos creados en /tmp/"
echo ""

# ============================================
# PASO 1: Búsqueda Básica
# ============================================
echo "--- Paso 1: Búsqueda Básica ---"

# grep busca un patrón y muestra las líneas que coinciden.
# Sintaxis: grep "patrón" archivo

# Descomenta las siguientes líneas:
# echo "Empleados de Madrid:"
# grep "Madrid" /tmp/empleados.txt

echo ""

# ============================================
# PASO 2: Ignorar Mayúsculas (-i)
# ============================================
echo "--- Paso 2: Ignorar Mayúsculas ---"

# -i hace la búsqueda case-insensitive.
# "ERROR", "error", "Error" coincidirán.

# Descomenta las siguientes líneas:
# echo "Todas las líneas con 'error' (cualquier capitalización):"
# grep -i "error" /tmp/log.txt

echo ""

# ============================================
# PASO 3: Búsqueda Inversa (-v)
# ============================================
echo "--- Paso 3: Búsqueda Inversa ---"

# -v muestra líneas que NO coinciden con el patrón.
# Útil para excluir líneas.

# Descomenta las siguientes líneas:
# echo "Empleados que NO son de Madrid:"
# grep -v "Madrid" /tmp/empleados.txt

echo ""

# ============================================
# PASO 4: Mostrar Números de Línea (-n)
# ============================================
echo "--- Paso 4: Números de Línea ---"

# -n añade el número de línea al principio.
# Muy útil para localizar problemas en código.

# Descomenta las siguientes líneas:
# echo "Líneas con 'INFO' (con número de línea):"
# grep -n "INFO" /tmp/log.txt

echo ""

# ============================================
# PASO 5: Contar Coincidencias (-c)
# ============================================
echo "--- Paso 5: Contar Coincidencias ---"

# -c cuenta las líneas que coinciden.
# Solo muestra el número, no las líneas.

# Descomenta las siguientes líneas:
# echo "Cantidad de errores en el log:"
# grep -c -i "error" /tmp/log.txt

echo ""

# ============================================
# PASO 6: Palabra Completa (-w)
# ============================================
echo "--- Paso 6: Palabra Completa ---"

# -w busca la palabra completa, no subcadenas.
# "log" no coincidiría con "login" o "catalog"

# Descomenta las siguientes líneas:
# echo "Buscando 'admin' como palabra completa:"
# grep -w "admin" /tmp/log.txt

echo ""

# ============================================
# PASO 7: Regex - Inicio de Línea (^)
# ============================================
echo "--- Paso 7: Regex - Inicio de Línea ---"

# ^ significa "inicio de línea"
# ^Juan busca líneas que EMPIEZAN con "Juan"

# Descomenta las siguientes líneas:
# echo "Empleados cuyo nombre empieza con 'A':"
# grep "^A" /tmp/empleados.txt

echo ""

# ============================================
# PASO 8: Regex - Fin de Línea ($)
# ============================================
echo "--- Paso 8: Regex - Fin de Línea ---"

# $ significa "fin de línea"
# Madrid$ busca líneas que TERMINAN con "Madrid"

# Descomenta las siguientes líneas:
# echo "Empleados de Madrid (terminan con Madrid):"
# grep "Madrid$" /tmp/empleados.txt

echo ""

# ============================================
# PASO 9: Regex - Cualquier Carácter (.)
# ============================================
echo "--- Paso 9: Regex - Cualquier Carácter ---"

# . coincide con cualquier carácter individual
# "D.s" coincide con "Dis", "Das", "Des", etc.

# Descomenta las siguientes líneas:
# echo "Buscando patrón 'D.s' (Diseñador/Diseñadora):"
# grep "D.s" /tmp/empleados.txt

echo ""

# ============================================
# PASO 10: grep Extendido - Alternativas (|)
# ============================================
echo "--- Paso 10: grep -E con Alternativas ---"

# grep -E activa expresiones regulares extendidas.
# | significa "OR" - busca uno u otro patrón.

# Descomenta las siguientes líneas:
# echo "Líneas con ERROR o WARNING:"
# grep -E "ERROR|WARNING" /tmp/log.txt

echo ""

# ============================================
# PASO 11: Contexto (-A, -B, -C)
# ============================================
echo "--- Paso 11: Mostrar Contexto ---"

# -A N: muestra N líneas DESPUÉS de la coincidencia
# -B N: muestra N líneas ANTES de la coincidencia
# -C N: muestra N líneas antes Y después

# Descomenta las siguientes líneas:
# echo "ERROR con 1 línea de contexto antes y después:"
# grep -C 1 "ERROR" /tmp/log.txt

echo ""

# ============================================
# PASO 12: grep con Pipes
# ============================================
echo "--- Paso 12: grep con Pipes ---"

# grep es muy poderoso combinado con otros comandos.
# Filtrar la salida de cualquier comando.

# Descomenta las siguientes líneas:
# echo "Procesos que contienen 'bash':"
# ps aux | grep bash | grep -v grep

echo ""

# ============================================
# PASO 13: Pipeline Completo
# ============================================
echo "--- Paso 13: Pipeline Completo ---"

# Combinemos grep con otros comandos:
# Contar desarrolladores únicos por ciudad

# Descomenta las siguientes líneas:
# echo "Ciudades con desarrolladores y cantidad:"
# grep -i "desarrollador" /tmp/empleados.txt | cut -d',' -f4 | sort | uniq -c

echo ""

# ============================================
# LIMPIEZA
# ============================================
echo "--- Limpieza ---"
# rm -f /tmp/empleados.txt /tmp/log.txt
echo "Archivos temporales limpiados (descomenta para activar)"
echo ""

echo "✅ Práctica completada!"
echo ""
echo "📚 Resumen de opciones grep:"
echo "   -i    Ignorar mayúsculas/minúsculas"
echo "   -v    Invertir (líneas que NO coinciden)"
echo "   -n    Mostrar número de línea"
echo "   -c    Contar coincidencias"
echo "   -w    Palabra completa"
echo "   -r    Búsqueda recursiva"
echo "   -E    Expresiones regulares extendidas"
echo ""
echo "📚 Regex básicos:"
echo "   ^     Inicio de línea"
echo "   $     Fin de línea"
echo "   .     Cualquier carácter"
echo "   |     Alternativa (OR, con -E)"
