#!/bin/bash
# ============================================
# PRACTICA 2: grep Avanzado
# Semana 5: Procesamiento de Texto
# ============================================

# Directorio temporal para datos de prueba
TMPDIR="/tmp/grep_practice_$$"
mkdir -p "$TMPDIR"

# ============================================
# PASO 1: Crear Datos de Prueba
# ============================================
echo "--- Paso 1: Crear Datos de Prueba ---"

# Crear archivo de log simulado
# Descomenta las siguientes lineas:
# cat > "$TMPDIR/app.log" << 'EOF'
# 2024-01-15 08:00:01 INFO Server started on port 8080
# 2024-01-15 08:00:02 DEBUG Loading configuration
# 2024-01-15 08:00:03 INFO Connected to database
# 2024-01-15 08:05:10 WARNING High memory usage: 85%
# 2024-01-15 08:10:15 ERROR Connection timeout from 192.168.1.100
# 2024-01-15 08:10:16 DEBUG Retrying connection
# 2024-01-15 08:10:17 INFO Connection restored
# 2024-01-15 08:15:20 ERROR Failed login from 10.0.0.50
# 2024-01-15 08:15:21 WARNING Too many failed attempts
# 2024-01-15 08:20:30 INFO User admin logged in
# 2024-01-15 08:25:00 DEBUG Cleanup task started
# 2024-01-15 08:30:45 ERROR Disk space low on /var
# 2024-01-15 08:30:46 WARNING Critical: only 5% remaining
# 2024-01-15 08:35:00 INFO Backup completed successfully
# 2024-01-15 09:00:00 error lowercase error message
# EOF
# 
# echo "Archivo de log creado: $TMPDIR/app.log"
# echo "Contenido:"
# cat "$TMPDIR/app.log"

echo ""

# ============================================
# PASO 2: Busqueda Basica
# ============================================
echo "--- Paso 2: Busqueda Basica ---"

# -i = ignorar mayusculas/minusculas
# Descomenta las siguientes lineas:
# echo "Buscar 'error' ignorando caso (-i):"
# grep -i "error" "$TMPDIR/app.log"

# -n = mostrar numero de linea
# Descomenta las siguientes lineas:
# echo ""
# echo "Buscar 'WARNING' con numero de linea (-n):"
# grep -n "WARNING" "$TMPDIR/app.log"

echo ""

# ============================================
# PASO 3: Contar e Invertir
# ============================================
echo "--- Paso 3: Contar e Invertir ---"

# -c = contar coincidencias
# Descomenta las siguientes lineas:
# echo "Contar lineas con ERROR (-c):"
# grep -ic "error" "$TMPDIR/app.log"

# -v = invertir (mostrar lo que NO coincide)
# Descomenta las siguientes lineas:
# echo ""
# echo "Lineas que NO contienen DEBUG (-v):"
# grep -v "DEBUG" "$TMPDIR/app.log" | head -5

echo ""

# ============================================
# PASO 4: Extended Regex
# ============================================
echo "--- Paso 4: Extended Regex ---"

# -E = expresiones regulares extendidas
# Descomenta las siguientes lineas:
# echo "Lineas con ERROR o WARNING (-E para alternancia):"
# grep -E "ERROR|WARNING" "$TMPDIR/app.log"

# Descomenta las siguientes lineas:
# echo ""
# echo "Lineas con hora entre 08:00 y 08:30:"
# grep -E "08:(0|1|2)[0-9]:" "$TMPDIR/app.log"

echo ""

# ============================================
# PASO 5: Extraer Coincidencias
# ============================================
echo "--- Paso 5: Extraer Coincidencias ---"

# -o = mostrar solo la parte que coincide
# Descomenta las siguientes lineas:
# echo "Extraer solo las IPs (-o):"
# grep -oE "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" "$TMPDIR/app.log"

# Descomenta las siguientes lineas:
# echo ""
# echo "Extraer solo las horas:"
# grep -oE "[0-9]{2}:[0-9]{2}:[0-9]{2}" "$TMPDIR/app.log" | sort -u

echo ""

# ============================================
# PASO 6: Contexto
# ============================================
echo "--- Paso 6: Contexto ---"

# -A n = mostrar n lineas DESPUES
# -B n = mostrar n lineas ANTES
# -C n = mostrar n lineas de contexto (antes y despues)
# Descomenta las siguientes lineas:
# echo "ERROR con 1 linea despues (-A 1):"
# grep -A 1 "ERROR" "$TMPDIR/app.log" | head -8

# Descomenta las siguientes lineas:
# echo ""
# echo "ERROR con 1 linea antes (-B 1):"
# grep -B 1 "ERROR" "$TMPDIR/app.log" | head -8

echo ""

# ============================================
# PASO 7: Busqueda Recursiva
# ============================================
echo "--- Paso 7: Busqueda Recursiva ---"

# Crear estructura de directorios para prueba
# Descomenta las siguientes lineas:
# mkdir -p "$TMPDIR/src/utils"
# echo "# TODO: implement validation" > "$TMPDIR/src/main.sh"
# echo "# FIXME: handle errors" >> "$TMPDIR/src/main.sh"
# echo "# TODO: add logging" > "$TMPDIR/src/utils/helper.sh"
# echo "# config file" > "$TMPDIR/src/config.txt"
# 
# echo "Buscar 'TODO' recursivamente (-r):"
# grep -rn "TODO" "$TMPDIR/src/"

# Descomenta las siguientes lineas:
# echo ""
# echo "Buscar solo en archivos .sh (--include):"
# grep -rn "TODO\|FIXME" --include="*.sh" "$TMPDIR/src/"

echo ""

# ============================================
# PASO 8: Funcion de Analisis
# ============================================
echo "--- Paso 8: Funcion de Analisis ---"

# Funcion para analisis completo de logs
# Descomenta las siguientes lineas:
# analizar_log() {
#     local archivo="$1"
#     
#     echo "=== Analisis de Log: $archivo ==="
#     echo ""
#     
#     echo "Resumen por nivel:"
#     echo "  ERROR:   $(grep -ic 'error' "$archivo")"
#     echo "  WARNING: $(grep -ic 'warning' "$archivo")"
#     echo "  INFO:    $(grep -ic 'info' "$archivo")"
#     echo "  DEBUG:   $(grep -ic 'debug' "$archivo")"
#     echo ""
#     
#     echo "IPs unicas encontradas:"
#     grep -oE "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" "$archivo" | sort -u | while read ip; do
#         echo "  $ip"
#     done
#     echo ""
#     
#     echo "Errores criticos:"
#     grep -iE "error|critical" "$archivo" | head -5
# }
# 
# analizar_log "$TMPDIR/app.log"

echo ""

# Limpiar archivos temporales
rm -rf "$TMPDIR"

echo "=== Practica 2 completada ==="
