#!/bin/bash
# Ejercicio 04: Pipeline Real - Sistema de Análisis de Logs
# Módulo: 2 | Dificultad: Avanzada
# Objetivo: Integrar pipes, grep, sed, awk y otras herramientas en un pipeline completo

# ============================================================================
# INSTRUCCIONES
# ============================================================================
# Este ejercicio simula un caso real: analizar logs de un servidor web.
# Combinarás todas las herramientas aprendidas para extraer información útil.
#
# ESCENARIO:
# Eres administrador de sistemas y necesitas analizar logs de acceso web
# para generar un reporte con estadísticas clave.
#
# TAREAS:
# 1. Contar requests por código de estado (200, 404, 500, etc.)
# 2. Listar las 5 IPs con más requests
# 3. Identificar las URLs más visitadas
# 4. Detectar intentos de ataque (SQL injection, path traversal)
# 5. Calcular tiempo promedio de respuesta
# 6. Generar un reporte completo en formato legible
#
# CRITERIOS DE ÉXITO:
# ✓ Pipeline eficiente (sin archivos temporales innecesarios)
# ✓ Uso apropiado de cada herramienta
# ✓ Resultados precisos y bien formateados
# ✓ Código comentado y legible

echo "🌐 Ejercicio 04: Pipeline Real - Análisis de Logs"
echo "=================================================="
echo ""

# ============================================================================
# PREPARACIÓN: Crear log simulado de servidor web
# ============================================================================
echo "📝 Generando log de servidor web simulado..."

cat > /tmp/access.log << 'EOF'
192.168.1.100 - - [26/Oct/2024:10:00:01] "GET /index.html HTTP/1.1" 200 2326 0.045
192.168.1.101 - - [26/Oct/2024:10:00:02] "GET /api/users HTTP/1.1" 200 1453 0.120
192.168.1.102 - - [26/Oct/2024:10:00:03] "GET /nonexistent HTTP/1.1" 404 286 0.012
192.168.1.100 - - [26/Oct/2024:10:00:04] "POST /api/login HTTP/1.1" 200 543 0.230
192.168.1.103 - - [26/Oct/2024:10:00:05] "GET /admin.php HTTP/1.1" 403 158 0.008
192.168.1.104 - - [26/Oct/2024:10:00:06] "GET /products HTTP/1.1" 200 8234 0.089
192.168.1.100 - - [26/Oct/2024:10:00:07] "GET /images/logo.png HTTP/1.1" 200 15234 0.034
192.168.1.105 - - [26/Oct/2024:10:00:08] "GET /../../../etc/passwd HTTP/1.1" 403 158 0.005
192.168.1.101 - - [26/Oct/2024:10:00:09] "GET /api/products HTTP/1.1" 200 3421 0.156
192.168.1.106 - - [26/Oct/2024:10:00:10] "GET /contact HTTP/1.1" 200 1245 0.067
192.168.1.102 - - [26/Oct/2024:10:00:11] "GET /missing HTTP/1.1" 404 286 0.009
192.168.1.100 - - [26/Oct/2024:10:00:12] "GET /about HTTP/1.1" 200 987 0.045
192.168.1.107 - - [26/Oct/2024:10:00:13] "POST /api/data HTTP/1.1" 500 234 0.456
192.168.1.103 - - [26/Oct/2024:10:00:14] "GET /admin/?id=1' OR '1'='1 HTTP/1.1" 403 158 0.007
192.168.1.108 - - [26/Oct/2024:10:00:15] "GET /products HTTP/1.1" 200 8234 0.092
192.168.1.100 - - [26/Oct/2024:10:00:16] "GET /index.html HTTP/1.1" 200 2326 0.038
192.168.1.104 - - [26/Oct/2024:10:00:17] "GET /cart HTTP/1.1" 200 1876 0.078
192.168.1.109 - - [26/Oct/2024:10:00:18] "GET /notfound HTTP/1.1" 404 286 0.011
192.168.1.101 - - [26/Oct/2024:10:00:19] "POST /api/users HTTP/1.1" 200 654 0.198
192.168.1.100 - - [26/Oct/2024:10:00:20] "GET /products HTTP/1.1" 200 8234 0.085
EOF

echo "✓ Log generado con 20 requests simuladas"
echo ""

# ============================================================================
# ANÁLISIS DEL LOG
# ============================================================================

echo "═══════════════════════════════════════════════════════════"
echo "          📊 REPORTE DE ANÁLISIS DE LOGS"
echo "═══════════════════════════════════════════════════════════"
echo ""

# ============================================================================
# TAREA 1: Estadísticas por código de estado
# ============================================================================
echo "📈 TAREA 1: Requests por código de estado"
echo "-------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: Extraer columna del código (campo 9), contar con sort | uniq -c
# awk '{print $9}' /tmp/access.log | sort | uniq -c | sort -rn


echo ""

# ============================================================================
# TAREA 2: Top 5 IPs con más requests
# ============================================================================
echo "🌍 TAREA 2: Top 5 IPs con más requests"
echo "---------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: Extraer IP (campo 1), contar, ordenar, tomar primeras 5
# awk '{print $1}' /tmp/access.log | sort | uniq -c | sort -rn | head -5


echo ""

# ============================================================================
# TAREA 3: URLs más visitadas
# ============================================================================
echo "📍 TAREA 3: Top 5 URLs más visitadas"
echo "-------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: Extraer URL (campo 7), contar, ordenar
# awk '{print $7}' /tmp/access.log | sort | uniq -c | sort -rn | head -5


echo ""

# ============================================================================
# TAREA 4: Detección de posibles ataques
# ============================================================================
echo "🚨 TAREA 4: Detección de posibles ataques"
echo "------------------------------------------"

echo "Intentos de Path Traversal (../):"
# TU CÓDIGO AQUÍ:
# Pista: grep para buscar ../ en las URLs


echo ""
echo "Intentos de SQL Injection (OR, UNION):"
# TU CÓDIGO AQUÍ:
# Pista: grep -i para buscar patrones SQL


echo ""

# ============================================================================
# TAREA 5: Análisis de errores
# ============================================================================
echo "❌ TAREA 5: Análisis de errores (4xx y 5xx)"
echo "--------------------------------------------"

echo "Errores 404 (No encontrado):"
# TU CÓDIGO AQUÍ:
# Pista: awk para filtrar código 404 y extraer URL


echo ""
echo "Errores 500 (Error del servidor):"
# TU CÓDIGO AQUÍ:
# Pista: Similar al anterior pero con código 500


echo ""

# ============================================================================
# TAREA 6: Tiempo promedio de respuesta
# ============================================================================
echo "⏱️  TAREA 6: Tiempo promedio de respuesta"
echo "-----------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: awk para sumar tiempos y calcular promedio
# awk '{sum+=$NF; count++} END {print sum/count}' /tmp/access.log


echo ""

# ============================================================================
# TAREA 7: Estadísticas por método HTTP
# ============================================================================
echo "🔧 TAREA 7: Requests por método HTTP"
echo "-------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: Extraer método (GET, POST) del campo 6, contar
# awk '{print $6}' /tmp/access.log | tr -d '"' | sort | uniq -c


echo ""

# ============================================================================
# TAREA 8: Reporte de tráfico por hora
# ============================================================================
echo "🕐 TAREA 8: Distribución de tráfico por hora"
echo "---------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: Extraer hora del timestamp, contar
# awk '{print $4}' /tmp/access.log | cut -d: -f2 | sort | uniq -c


echo ""

# ============================================================================
# TAREA AVANZADA: Pipeline completo - Top IPs sospechosas
# ============================================================================
echo "🔍 TAREA AVANZADA: IPs con actividad sospechosa"
echo "------------------------------------------------"
echo "(IPs con errores 403 o intentos de ataque)"

# TU CÓDIGO AQUÍ:
# Combinar grep para ataques + awk para errores 403 + sort + uniq
# Pista: (grep -E "\.\./|'|UNION|SELECT" /tmp/access.log; awk '$9==403' /tmp/access.log) | awk '{print $1}' | sort -u


echo ""

# Limpiar
rm -f /tmp/access.log
echo "═══════════════════════════════════════════════════════════"
echo "🧹 Archivos temporales eliminados"
echo "✅ Ejercicio completado!"


# ============================================================================
# SOLUCIÓN COMPLETA (descomenta para ver)
# ============================================================================

: '
# TAREA 1: Códigos de estado
echo "Códigos de estado:"
awk "{print \$9}" /tmp/access.log | sort | uniq -c | sort -rn | \
  awk "{printf \"  %s: %d requests\n\", \$2, \$1}"

# TAREA 2: Top IPs
echo "Top 5 IPs:"
awk "{print \$1}" /tmp/access.log | sort | uniq -c | sort -rn | head -5 | \
  awk "{printf \"  %s: %d requests\n\", \$2, \$1}"

# TAREA 3: URLs más visitadas
echo "Top 5 URLs:"
awk "{print \$7}" /tmp/access.log | sort | uniq -c | sort -rn | head -5 | \
  awk "{printf \"  %s: %d visitas\n\", \$2, \$1}"

# TAREA 4: Detección de ataques
echo "Path Traversal:"
grep "\.\.\/" /tmp/access.log | awk "{print \$1, \$7}"

echo "SQL Injection:"
grep -iE "(OR.*=|UNION|SELECT)" /tmp/access.log | awk "{print \$1, \$7}"

# TAREA 5: Análisis de errores
echo "404 Errors:"
awk "\$9==404 {print \$7}" /tmp/access.log | sort | uniq -c | sort -rn

echo "500 Errors:"
awk "\$9==500 {print \$7}" /tmp/access.log

# TAREA 6: Tiempo promedio
avg_time=$(awk "{sum+=\$NF; count++} END {printf \"%.3f\", sum/count}" /tmp/access.log)
echo "Tiempo promedio de respuesta: ${avg_time}s"

# TAREA 7: Por método
echo "Por método HTTP:"
awk "{print \$6}" /tmp/access.log | tr -d "\"" | sort | uniq -c | \
  awk "{printf \"  %s: %d requests\n\", \$2, \$1}"

# TAREA 8: Por hora
echo "Por hora:"
awk "{print \$4}" /tmp/access.log | cut -d: -f2 | sort | uniq -c | \
  awk "{printf \"  Hora %s: %d requests\n\", \$2, \$1}"

# TAREA AVANZADA: IPs sospechosas
echo "IPs sospechosas:"
(grep -E "\.\./|\"\'|UNION|SELECT" /tmp/access.log; awk "\$9==403" /tmp/access.log) | \
  awk "{print \$1}" | sort -u
'

# ============================================================================
# EXPLICACIÓN DE CONCEPTOS
# ============================================================================

: '
📚 CONCEPTOS CLAVE DE PIPELINES:

1. FORMATO DE LOG APACHE/NGINX:
   Campo 1: IP del cliente
   Campo 4: Timestamp [fecha:hora]
   Campo 6: Método HTTP "GET", "POST"
   Campo 7: URL solicitada
   Campo 9: Código de estado (200, 404, 500)
   Campo 10: Tamaño de respuesta
   Último campo: Tiempo de respuesta

2. ESTRATEGIA DE ANÁLISIS:
   a) Identificar qué información necesitas
   b) Determinar en qué campo está
   c) Extraer con awk, cut, o grep
   d) Procesar con sort, uniq, count
   e) Formatear salida con awk o printf

3. PATRONES COMUNES:
   
   # Contar ocurrencias
   awk "{print \$N}" | sort | uniq -c | sort -rn
   
   # Top N elementos
   ... | head -N
   
   # Filtrar por condición
   awk "\$campo==valor" archivo
   
   # Combinar múltiples fuentes
   (comando1; comando2) | procesamiento
   
   # Calcular estadísticas
   awk "{sum+=\$N} END {print sum/NR}"

4. DETECCIÓN DE ATAQUES:
   
   Path Traversal: ../../../
   SQL Injection: OR, UNION, SELECT, --
   XSS: <script>, javascript:
   Scan de puertos: Muchos 404s desde misma IP
   Brute force: Muchos 401/403 desde misma IP

5. OPTIMIZACIÓN DE PIPELINES:
   
   ✓ Filtrar primero (grep/awk) para reducir datos
   ✓ Evitar archivos temporales cuando sea posible
   ✓ Usar awk cuando sea posible (más eficiente)
   ✓ sort antes de uniq (uniq requiere entrada ordenada)
   ✓ Combinar comandos relacionados

6. DEBUGGING DE PIPELINES:
   
   # Probar cada paso por separado
   comando1 | head
   comando1 | comando2 | head
   comando1 | comando2 | comando3 | head
   
   # Ver qué está pasando en cada paso
   comando1 | tee /tmp/step1 | comando2

💡 TIPS PROFESIONALES:
   - Los logs reales pueden tener millones de líneas
   - Usa herramientas apropiadas: grep para filtrar, awk para procesar
   - sort consume mucha memoria con archivos grandes
   - Considera herramientas especializadas (GoAccess, Logwatch)
   - Automatiza análisis con scripts y cron
   - Archiva logs antiguos comprimidos (gzip)
   - Rota logs regularmente para evitar archivos enormes
'
