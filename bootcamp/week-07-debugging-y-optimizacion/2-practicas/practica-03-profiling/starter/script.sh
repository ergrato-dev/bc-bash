#!/bin/bash
# ============================================
# PRÁCTICA 03: Profiling y Optimización
# Semana 7 - Debugging y Optimización
# ============================================

echo "========================================"
echo "⚡ PRÁCTICA 03: Profiling y Optimización"
echo "========================================"
echo ""

# ============================================
# PASO 1: Comando time
# ============================================
echo "--- Paso 1: Comando time ---"

# time mide el tiempo de ejecución de un comando

# Descomenta las siguientes líneas:
# echo "Usando el comando time:"
# echo ""
# echo "Ejemplo: time sleep 0.5"
# echo ""
# time sleep 0.5
# echo ""
# echo "Interpretación:"
# echo "  real: Tiempo total transcurrido"
# echo "  user: Tiempo CPU en modo usuario"
# echo "  sys:  Tiempo CPU en modo kernel"

echo ""

# ============================================
# PASO 2: Variable SECONDS
# ============================================
echo "--- Paso 2: Variable SECONDS ---"

# SECONDS cuenta segundos desde el inicio del script
# Útil para medir secciones de código

# Descomenta las siguientes líneas:
# echo "Midiendo con SECONDS:"
# echo ""
# 
# measure_section() {
#     local name="$1"
#     local start=$SECONDS
#     
#     shift
#     "$@"  # Ejecutar el comando
#     
#     local duration=$((SECONDS - start))
#     echo "  $name: ${duration}s"
# }
# 
# # Simular diferentes tareas
# task_rapida() { sleep 0.2; }
# task_lenta() { sleep 0.5; }
# 
# measure_section "Tarea rápida" task_rapida
# measure_section "Tarea lenta" task_lenta
# 
# echo ""
# echo "Tiempo total desde inicio: ${SECONDS}s"

echo ""

# ============================================
# PASO 3: Profiling con PS4
# ============================================
echo "--- Paso 3: Profiling con PS4 ---"

# PS4 define el prefijo cuando set -x está activo
# Podemos incluir timestamps y líneas

# Descomenta las siguientes líneas:
# echo "Profiling con PS4:"
# echo ""
# 
# (
#     # Configurar PS4 con timestamp y línea
#     PS4='+${SECONDS}s:L${LINENO}: '
#     set -x
#     
#     x=10
#     y=20
#     sum=$((x + y))
#     sleep 0.1
#     result="$sum"
# )
# 
# echo ""
# echo "Cada línea muestra segundos y número de línea"

echo ""

# ============================================
# PASO 4: Benchmark Comparativo
# ============================================
echo "--- Paso 4: Benchmark Comparativo ---"

# Comparar diferentes implementaciones

# Descomenta las siguientes líneas:
# benchmark() {
#     local name="$1"
#     local iterations="${2:-1000}"
#     shift 2
#     
#     local start=$SECONDS
#     for ((i=0; i<iterations; i++)); do
#         "$@" > /dev/null
#     done
#     local duration=$((SECONDS - start))
#     
#     echo "  $name ($iterations iter): ${duration}s"
# }
# 
# echo "Comparando métodos para extraer campo:"
# echo ""
# 
# test_string="usuario:grupo:1000:1000:Nombre:/home/user:/bin/bash"
# 
# # Método 1: cut (comando externo)
# method_cut() {
#     echo "$test_string" | cut -d: -f1
# }
# 
# # Método 2: awk (comando externo)
# method_awk() {
#     echo "$test_string" | awk -F: '{print $1}'
# }
# 
# # Método 3: Parameter expansion (built-in)
# method_builtin() {
#     echo "${test_string%%:*}"
# }
# 
# # Ejecutar benchmarks (reducido para demo)
# benchmark "cut (externo)" 100 method_cut
# benchmark "awk (externo)" 100 method_awk
# benchmark "builtin"      100 method_builtin
# 
# echo ""
# echo "Los built-ins son significativamente más rápidos"

echo ""

# ============================================
# PASO 5: Evitar Subshells
# ============================================
echo "--- Paso 5: Evitar Subshells ---"

# Los subshells ($(...)) tienen overhead
# Usar built-ins cuando sea posible

# Descomenta las siguientes líneas:
# echo "Subshells vs Built-ins:"
# echo ""
# 
# var="hello:world:test"
# 
# echo "Extraer primer campo:"
# echo "  ❌ Subshell: \$(echo \$var | cut -d: -f1)"
# result1=$(echo "$var" | cut -d: -f1)
# echo "     Resultado: $result1"
# 
# echo "  ✅ Built-in: \${var%%:*}"
# result2="${var%%:*}"
# echo "     Resultado: $result2"
# 
# echo ""
# echo "Convertir a mayúsculas:"
# echo "  ❌ Subshell: \$(echo \$var | tr 'a-z' 'A-Z')"
# result3=$(echo "$var" | tr 'a-z' 'A-Z')
# echo "     Resultado: $result3"
# 
# echo "  ✅ Built-in: \${var^^}"
# result4="${var^^}"
# echo "     Resultado: $result4"

echo ""

# ============================================
# PASO 6: Evitar UUOC
# ============================================
echo "--- Paso 6: Evitar UUOC ---"

# UUOC = Useless Use of Cat
# Muchos comandos pueden leer archivos directamente

# Descomenta las siguientes líneas:
# echo "UUOC - Useless Use of Cat:"
# echo ""
# 
# # Crear archivo de prueba
# test_file=$(mktemp)
# echo -e "línea 1\nlínea 2\nlínea 3" > "$test_file"
# 
# echo "Buscar 'línea 2' en archivo:"
# echo ""
# echo "  ❌ cat file | grep pattern"
# cat "$test_file" | grep "línea 2"
# 
# echo ""
# echo "  ✅ grep pattern file"
# grep "línea 2" "$test_file"
# 
# echo ""
# echo "Otros ejemplos de UUOC:"
# echo "  ❌ cat file | wc -l"
# echo "  ✅ wc -l < file"
# echo ""
# echo "  ❌ cat file | head -10"
# echo "  ✅ head -10 file"
# 
# rm -f "$test_file"

echo ""

# ============================================
# PASO 7: Tips de Optimización
# ============================================
echo "--- Paso 7: Tips de Optimización ---"

# Resumen de buenas prácticas

# Descomenta las siguientes líneas:
# echo "Tips de optimización:"
# echo ""
# echo "1. Preferir built-ins sobre comandos externos"
# echo "   \${var#pattern}  vs  echo | cut"
# echo ""
# echo "2. Usar [[ ]] en lugar de [ ]"
# echo "   [[ \$a == \$b ]]  vs  [ \"\$a\" = \"\$b\" ]"
# echo ""
# echo "3. Evitar loops para procesar texto grande"
# echo "   awk/sed  vs  while read"
# echo ""
# echo "4. Usar arrays para datos estructurados"
# echo "   array=()  vs  múltiples variables"
# echo ""
# echo "5. Reducir forks - agrupar operaciones"
# echo "   cmd1; cmd2; cmd3  vs  cmd1 && cmd2 && cmd3"

echo ""

echo "========================================"
echo "✅ Práctica 03 completada"
echo "========================================"
