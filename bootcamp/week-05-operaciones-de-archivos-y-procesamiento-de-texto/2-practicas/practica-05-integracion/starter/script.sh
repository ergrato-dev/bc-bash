#!/bin/bash
# ============================================
# PRACTICA 5: Pipeline de Integracion
# Semana 5: Procesamiento de Texto
# ============================================

TMPDIR="/tmp/pipeline_practice_$$"
mkdir -p "$TMPDIR"

# ============================================
# PASO 1: Crear Datos Complejos
# ============================================
echo "--- Paso 1: Crear Datos Complejos ---"

# Crear log de servidor
# Descomenta las siguientes lineas:
# cat > "$TMPDIR/server.log" << 'EOF'
# 2024-01-15 10:23:45 INFO user=admin action=login ip=192.168.1.100
# 2024-01-15 10:24:12 ERROR user=guest action=access_denied ip=10.0.0.50
# 2024-01-15 10:25:33 INFO user=maria action=upload ip=192.168.1.101
# 2024-01-15 10:26:01 WARN user=admin action=timeout ip=192.168.1.100
# 2024-01-15 10:27:45 ERROR user=juan action=invalid_request ip=10.0.0.51
# 2024-01-15 10:28:22 INFO user=maria action=download ip=192.168.1.101
# 2024-01-15 10:29:10 ERROR user=guest action=auth_failed ip=10.0.0.50
# 2024-01-15 10:30:55 INFO user=admin action=logout ip=192.168.1.100
# EOF
# 
# # Crear datos de ventas
# cat > "$TMPDIR/sales.dat" << 'EOF'
# REGION:Norte:Laptop:5:1200
# REGION:Sur:Mouse:50:25
# REGION:Norte:Teclado:30:75
# REGION:Este:Monitor:10:350
# REGION:Sur:Webcam:20:80
# REGION:Norte:Auriculares:40:60
# REGION:Este:Laptop:8:1200
# EOF
# 
# echo "=== server.log ==="
# cat "$TMPDIR/server.log"
# echo ""
# echo "=== sales.dat ==="
# cat "$TMPDIR/sales.dat"

echo ""

# ============================================
# PASO 2: grep + sed (Filtrar y Transformar)
# ============================================
echo "--- Paso 2: grep + sed ---"

# Filtrar errores y formatear
# Descomenta las siguientes lineas:
# echo "Errores formateados:"
# grep "ERROR" "$TMPDIR/server.log" | sed 's/ERROR/[!] ERROR/'

# Extraer usuarios de errores
# Descomenta las siguientes lineas:
# echo ""
# echo "Usuarios con errores (solo username):"
# grep "ERROR" "$TMPDIR/server.log" | sed 's/.*user=\([^ ]*\).*/\1/'

# Formatear IPs de warnings
# Descomenta las siguientes lineas:
# echo ""
# echo "IPs de advertencias:"
# grep "WARN\|ERROR" "$TMPDIR/server.log" | sed 's/.*ip=\([0-9.]*\)/IP: \1/'

echo ""

# ============================================
# PASO 3: grep + awk (Filtrar y Analizar)
# ============================================
echo "--- Paso 3: grep + awk ---"

# Contar errores por usuario
# Descomenta las siguientes lineas:
# echo "Errores por tipo:"
# grep "ERROR" "$TMPDIR/server.log" | awk '{print $4}' | sort | uniq -c

# Filtrar region y sumar
# Descomenta las siguientes lineas:
# echo ""
# echo "Ventas region Norte:"
# grep "Norte" "$TMPDIR/sales.dat" | awk -F':' '{sum += $4 * $5} END {print "Total: $" sum}'

# Extraer y procesar campos
# Descomenta las siguientes lineas:
# echo ""
# echo "Productos con precio > 100:"
# grep "REGION" "$TMPDIR/sales.dat" | awk -F':' '$5 > 100 {print $3, "$"$5}'

echo ""

# ============================================
# PASO 4: sed + awk (Transformar y Procesar)
# ============================================
echo "--- Paso 4: sed + awk ---"

# Cambiar delimitador y procesar
# Descomenta las siguientes lineas:
# echo "Datos normalizados (: a ,):"
# sed 's/REGION://g' "$TMPDIR/sales.dat" | sed 's/:/,/g' | head -3

# Transformar y calcular
# Descomenta las siguientes lineas:
# echo ""
# echo "Subtotales por linea:"
# sed 's/REGION://g' "$TMPDIR/sales.dat" | awk -F':' '{print $2, $3 * $4}'

# Limpiar y agrupar
# Descomenta las siguientes lineas:
# echo ""
# echo "Cantidad total por region:"
# sed 's/REGION://g' "$TMPDIR/sales.dat" | awk -F':' '{region[$1] += $3} END {for (r in region) print r, region[r]}'

echo ""

# ============================================
# PASO 5: Pipeline Completo (grep + sed + awk)
# ============================================
echo "--- Paso 5: Pipeline Completo ---"

# Filtrar, transformar, analizar
# Descomenta las siguientes lineas:
# echo "Errores: usuario y accion:"
# grep "ERROR" "$TMPDIR/server.log" | sed 's/=/ /g' | awk '{print $5, $7}'

# Pipeline de ventas Norte
# Descomenta las siguientes lineas:
# echo ""
# echo "Reporte Norte (filtrar, limpiar, calcular):"
# grep "Norte" "$TMPDIR/sales.dat" | sed 's/REGION://g' | awk -F':' '{printf "%-15s %5d x $%-6d = $%d\n", $2, $3, $4, $3*$4}'

# Analisis complejo de logs
# Descomenta las siguientes lineas:
# echo ""
# echo "IPs con problemas (WARN/ERROR):"
# grep "WARN\|ERROR" "$TMPDIR/server.log" | sed 's/.*ip=//g' | awk '{count[$1]++} END {for (ip in count) print ip, count[ip], "incidentes"}' | sort -k2 -rn

echo ""

# ============================================
# PASO 6: Procesar Logs de Acceso
# ============================================
echo "--- Paso 6: Procesar Logs ---"

# Crear log de acceso web
# Descomenta las siguientes lineas:
# cat > "$TMPDIR/access.log" << 'EOF'
# 192.168.1.100 - - [15/Jan/2024:10:23:45] "GET /index.html HTTP/1.1" 200 1234
# 10.0.0.50 - - [15/Jan/2024:10:24:12] "POST /login HTTP/1.1" 401 89
# 192.168.1.101 - - [15/Jan/2024:10:25:33] "GET /api/data HTTP/1.1" 200 5678
# 192.168.1.100 - - [15/Jan/2024:10:26:01] "GET /styles.css HTTP/1.1" 200 890
# 10.0.0.51 - - [15/Jan/2024:10:27:45] "GET /admin HTTP/1.1" 403 56
# 192.168.1.101 - - [15/Jan/2024:10:28:22] "GET /images/logo.png HTTP/1.1" 200 3456
# 10.0.0.50 - - [15/Jan/2024:10:29:10] "POST /login HTTP/1.1" 401 89
# 192.168.1.100 - - [15/Jan/2024:10:30:55] "GET /logout HTTP/1.1" 302 0
# EOF

# Top IPs por requests
# Descomenta las siguientes lineas:
# echo "Top IPs por numero de requests:"
# awk '{print $1}' "$TMPDIR/access.log" | sort | uniq -c | sort -rn

# Errores HTTP (4xx, 5xx)
# Descomenta las siguientes lineas:
# echo ""
# echo "Requests con error (4xx):"
# awk '$9 ~ /^4/ {print $1, $7, $9}' "$TMPDIR/access.log"

# Bytes transferidos por IP
# Descomenta las siguientes lineas:
# echo ""
# echo "Bytes transferidos por IP:"
# awk '{bytes[$1] += $10} END {for (ip in bytes) print ip, bytes[ip], "bytes"}' "$TMPDIR/access.log" | sort -k2 -rn

echo ""

# ============================================
# PASO 7: Generar Reporte CSV
# ============================================
echo "--- Paso 7: Generar Reporte CSV ---"

# Convertir logs a CSV
# Descomenta las siguientes lineas:
# echo "Generando reporte CSV..."
# echo "ip,timestamp,method,path,status,bytes" > "$TMPDIR/report.csv"
# sed 's/\[//g; s/\]//g; s/"//g' "$TMPDIR/access.log" | \
#     awk '{print $1","$4","$5","$6","$8","$9}' >> "$TMPDIR/report.csv"
# 
# echo "Contenido de report.csv:"
# cat "$TMPDIR/report.csv"

# Resumen desde CSV
# Descomenta las siguientes lineas:
# echo ""
# echo "Resumen por status:"
# awk -F',' 'NR > 1 {status[$5]++} END {for (s in status) print "Status", s":", status[s]}' "$TMPDIR/report.csv"

echo ""

# ============================================
# PASO 8: Script de Analisis Completo
# ============================================
echo "--- Paso 8: Analisis Completo ---"

# Analisis completo del log de servidor
# Descomenta las siguientes lineas:
# echo "=== ANALISIS DE SERVER.LOG ==="
# grep -E "ERROR|WARN|INFO" "$TMPDIR/server.log" | awk '
# BEGIN {
#     print "Procesando eventos del servidor..."
#     print ""
# }
# {
#     level = $3
#     levels[level]++
#     
#     # Extraer usuario
#     match($0, /user=([^ ]+)/, arr)
#     if (arr[1] != "") users[arr[1]]++
#     
#     total++
# }
# END {
#     print "=== RESUMEN DE EVENTOS ==="
#     print ""
#     print "Por nivel:"
#     for (l in levels) printf "  %-8s %d\n", l, levels[l]
#     print ""
#     print "Por usuario:"
#     for (u in users) printf "  %-10s %d eventos\n", u, users[u]
#     print ""
#     print "Total de eventos:", total
#     print "=========================="
# }'

echo ""

# Limpiar
rm -rf "$TMPDIR"

echo "=== Practica 5 completada ==="
