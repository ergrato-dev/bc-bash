#!/bin/bash
# Ejercicio 02: Búsqueda con grep
# Módulo: 2 | Dificultad: Básica
# Objetivo: Dominar patrones de búsqueda con grep y expresiones regulares básicas

# ============================================================================
# INSTRUCCIONES
# ============================================================================
# grep es una de las herramientas más poderosas para buscar patrones en texto.
# En este ejercicio practicarás diferentes opciones y casos de uso.
#
# TAREAS:
# 1. Buscar líneas que contengan "root" en /etc/passwd
# 2. Buscar líneas que NO contengan comentarios (#) en un archivo
# 3. Búsqueda case-insensitive de "error" en logs
# 4. Contar líneas que coinciden con un patrón
# 5. Mostrar líneas con números de línea
# 6. Búsqueda recursiva en directorios
#
# CRITERIOS DE ÉXITO:
# ✓ Usar diferentes opciones de grep (-i, -v, -c, -n, -r)
# ✓ Combinar grep con pipes cuando sea necesario
# ✓ Entender la diferencia entre búsqueda literal y con regex

echo "🔍 Ejercicio 02: Búsqueda con grep"
echo "==================================="
echo ""

# ============================================================================
# PREPARACIÓN: Crear archivos de prueba
# ============================================================================
echo "📝 Preparando archivos de prueba..."

# Crear archivo de log simulado
cat > /tmp/test_log.txt << 'EOF'
[2024-10-26 10:00] INFO: Sistema iniciado
[2024-10-26 10:01] ERROR: Conexión fallida
[2024-10-26 10:02] WARNING: Memoria baja
[2024-10-26 10:03] INFO: Usuario conectado
[2024-10-26 10:04] error: Timeout en base de datos
[2024-10-26 10:05] INFO: Backup completado
[2024-10-26 10:06] ERROR: Disco lleno
EOF

# Crear archivo de configuración simulado
cat > /tmp/test_config.txt << 'EOF'
# Configuración del sistema
port=8080
host=localhost
# debug=true
timeout=30
# Opciones avanzadas
max_connections=100
EOF

echo "✓ Archivos de prueba creados en /tmp/"
echo ""

# ============================================================================
# TAREA 1: Búsqueda simple
# ============================================================================
echo "📋 TAREA 1: Buscar 'root' en /etc/passwd"
echo "-----------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: grep "root" /etc/passwd


echo ""

# ============================================================================
# TAREA 2: Búsqueda inversa (líneas que NO coinciden)
# ============================================================================
echo "📋 TAREA 2: Mostrar líneas sin comentarios (#) en test_config.txt"
echo "------------------------------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: grep -v "^#" /tmp/test_config.txt


echo ""

# ============================================================================
# TAREA 3: Búsqueda case-insensitive
# ============================================================================
echo "📋 TAREA 3: Buscar 'error' (sin importar mayúsculas) en test_log.txt"
echo "---------------------------------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: grep -i "error" /tmp/test_log.txt


echo ""

# ============================================================================
# TAREA 4: Contar coincidencias
# ============================================================================
echo "📋 TAREA 4: Contar cuántas veces aparece 'INFO' en test_log.txt"
echo "----------------------------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: grep -c "INFO" /tmp/test_log.txt


echo ""

# ============================================================================
# TAREA 5: Mostrar números de línea
# ============================================================================
echo "📋 TAREA 5: Buscar 'ERROR' y mostrar números de línea"
echo "------------------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: grep -n "ERROR" /tmp/test_log.txt


echo ""

# ============================================================================
# TAREA 6: Búsqueda con contexto
# ============================================================================
echo "📋 TAREA 6: Buscar 'ERROR' con 1 línea de contexto antes y después"
echo "-------------------------------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: grep -C 1 "ERROR" /tmp/test_log.txt


echo ""

# ============================================================================
# TAREA 7: Búsqueda con expresiones regulares
# ============================================================================
echo "📋 TAREA 7: Buscar líneas que empiezan con '[' en test_log.txt"
echo "---------------------------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: grep "^\[" /tmp/test_log.txt


echo ""

# ============================================================================
# TAREA 8: Múltiples patrones
# ============================================================================
echo "📋 TAREA 8: Buscar 'ERROR' o 'WARNING' en test_log.txt"
echo "-------------------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: grep -E "ERROR|WARNING" /tmp/test_log.txt


echo ""

# Limpiar archivos temporales
rm -f /tmp/test_log.txt /tmp/test_config.txt
echo "🧹 Archivos temporales eliminados"
echo ""
echo "✅ Ejercicio completado!"


# ============================================================================
# SOLUCIÓN COMPLETA (descomenta para ver)
# ============================================================================

: '
# TAREA 1: Búsqueda simple
echo "Líneas con root:"
grep "root" /etc/passwd

# TAREA 2: Búsqueda inversa
echo "Configuración sin comentarios:"
grep -v "^#" /tmp/test_config.txt

# TAREA 3: Case-insensitive
echo "Todas las líneas con error (cualquier mayúscula):"
grep -i "error" /tmp/test_log.txt

# TAREA 4: Contar
echo "Número de líneas con INFO:"
grep -c "INFO" /tmp/test_log.txt

# TAREA 5: Con números de línea
echo "ERROR con números de línea:"
grep -n "ERROR" /tmp/test_log.txt

# TAREA 6: Con contexto
echo "ERROR con contexto:"
grep -C 1 "ERROR" /tmp/test_log.txt

# TAREA 7: Regex - inicio de línea
echo "Líneas que empiezan con [:"
grep "^\[" /tmp/test_log.txt

# TAREA 8: Múltiples patrones
echo "ERROR o WARNING:"
grep -E "ERROR|WARNING" /tmp/test_log.txt
'

# ============================================================================
# EXPLICACIÓN DE CONCEPTOS
# ============================================================================

: '
📚 CONCEPTOS CLAVE:

1. OPCIONES BÁSICAS DE GREP:
   -i : Ignorar mayúsculas/minúsculas (case-insensitive)
   -v : Invertir búsqueda (líneas que NO coinciden)
   -c : Contar líneas que coinciden
   -n : Mostrar números de línea
   -r : Búsqueda recursiva en directorios
   -l : Mostrar solo nombres de archivos
   -w : Coincidir palabra completa

2. OPCIONES DE CONTEXTO:
   -A n : Mostrar n líneas DESPUÉS (After)
   -B n : Mostrar n líneas ANTES (Before)
   -C n : Mostrar n líneas de contexto (antes y después)

3. EXPRESIONES REGULARES BÁSICAS:
   ^ : Inicio de línea
   $ : Fin de línea
   . : Cualquier carácter
   * : Cero o más repeticiones
   [] : Conjunto de caracteres
   | : OR lógico (requiere -E)

4. VARIANTES DE GREP:
   grep  : Expresiones regulares básicas
   egrep : Expresiones regulares extendidas (= grep -E)
   fgrep : Búsqueda de cadenas literales (= grep -F)

5. COMBINACIONES ÚTILES:
   grep -r "patron" /ruta     : Buscar en todos los archivos
   grep -rl "patron" /ruta    : Listar archivos que contienen patrón
   grep -v "^$" archivo       : Eliminar líneas vacías
   grep -v "^#" archivo       : Eliminar comentarios
   grep -E "pat1|pat2"        : Buscar múltiples patrones

💡 TIPS:
   - Usa comillas para proteger caracteres especiales
   - -E es más flexible que grep básico
   - Combina -i con otros flags para búsquedas flexibles
   - grep es case-sensitive por defecto
   - Usa ^ y $ para anclar patrones
'
