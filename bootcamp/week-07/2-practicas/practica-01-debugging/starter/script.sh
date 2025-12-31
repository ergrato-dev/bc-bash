#!/bin/bash
# ============================================
# PRÁCTICA 01: Debugging con Set
# Semana 7 - Debugging y Optimización
# ============================================

echo "========================================"
echo "🐛 PRÁCTICA 01: Debugging con Set"
echo "========================================"
echo ""

# ============================================
# PASO 1: set -e (errexit)
# ============================================
echo "--- Paso 1: set -e (errexit) ---"

# set -e hace que el script termine si un comando falla
# Útil para detectar errores temprano

# Descomenta las siguientes líneas:
# echo "Demostración de set -e"
# echo ""
# 
# # Función que simula un comando exitoso
# cmd_ok() {
#     echo "  Comando exitoso"
#     return 0
# }
# 
# # Función que simula un comando fallido
# cmd_fail() {
#     echo "  Comando fallido"
#     return 1
# }
# 
# # Sin set -e, el script continúa después de un error
# echo "Sin set -e:"
# cmd_fail || true  # Usamos || true para que no falle el script
# echo "  Script continúa..."
# 
# # Nota: No activamos set -e aquí porque terminaría el script
# echo ""
# echo "Con set -e, el script terminaría en cmd_fail"

echo ""

# ============================================
# PASO 2: set -u (nounset)
# ============================================
echo "--- Paso 2: set -u (nounset) ---"

# set -u genera error si se usa una variable no definida
# Previene bugs por typos en nombres de variables

# Descomenta las siguientes líneas:
# echo "Demostración de set -u"
# echo ""
# 
# # Forma segura de usar variables con default
# echo "Con valor por defecto:"
# echo "  VAR_NO_EXISTE: '${VAR_NO_EXISTE:-valor_default}'"
# 
# # Verificar si variable está definida
# if [[ -v MI_VAR ]]; then
#     echo "  MI_VAR está definida"
# else
#     echo "  MI_VAR no está definida"
# fi
# 
# # Definir y usar
# MI_VAR="ahora sí"
# echo "  MI_VAR: $MI_VAR"

echo ""

# ============================================
# PASO 3: set -o pipefail
# ============================================
echo "--- Paso 3: set -o pipefail ---"

# pipefail hace que un pipeline falle si cualquier comando falla
# Por defecto, solo importa el exit code del último comando

# Descomenta las siguientes líneas:
# echo "Demostración de pipefail"
# echo ""
# 
# # Sin pipefail
# echo "Sin pipefail:"
# (false | true)
# echo "  Exit code: $?"
# 
# # Con pipefail
# echo ""
# echo "Con pipefail:"
# (set -o pipefail; false | true)
# echo "  Exit code: $?"
# 
# # Ejemplo práctico
# echo ""
# echo "Ejemplo práctico:"
# # Simular: comando_que_falla | grep pattern
# (set -o pipefail; cat /archivo/inexistente 2>/dev/null | grep "x")
# echo "  Pipeline falló correctamente: $?"

echo ""

# ============================================
# PASO 4: set -x (xtrace)
# ============================================
echo "--- Paso 4: set -x (xtrace) ---"

# set -x muestra cada comando antes de ejecutarlo
# Prefijo + indica el nivel de anidamiento

# Descomenta las siguientes líneas:
# echo "Demostración de set -x"
# echo ""
# 
# # Activar trace
# echo "Activando set -x:"
# set -x
# mi_var="hello"
# resultado=$((2 + 3))
# echo "Resultado: $resultado"
# set +x
# 
# echo ""
# echo "set -x desactivado"

echo ""

# ============================================
# PASO 5: Combo set -euo pipefail
# ============================================
echo "--- Paso 5: Combo Recomendado ---"

# La combinación estándar para scripts robustos

# Descomenta las siguientes líneas:
# echo "El combo recomendado es:"
# echo ""
# echo "  #!/bin/bash"
# echo "  set -euo pipefail"
# echo ""
# echo "Equivale a:"
# echo "  set -e        # Exit on error"
# echo "  set -u        # Error on undefined vars"
# echo "  set -o pipefail  # Pipe errors propagate"
# echo ""
# echo "Beneficios:"
# echo "  - Detecta errores temprano"
# echo "  - Previene bugs por variables indefinidas"
# echo "  - Captura errores en pipelines"

echo ""

# ============================================
# PASO 6: Activar/Desactivar Dinámicamente
# ============================================
echo "--- Paso 6: Control Dinámico ---"

# Las opciones se pueden activar/desactivar en cualquier momento

# Descomenta las siguientes líneas:
# echo "Control dinámico de opciones"
# echo ""
# 
# debug_section() {
#     echo "=== Sección con debug ==="
#     set -x
#     local x=10
#     local y=20
#     local sum=$((x + y))
#     echo "Suma: $sum"
#     set +x
#     echo "=== Fin debug ==="
# }
# 
# echo "Antes de la sección debug..."
# debug_section
# echo "Después de la sección debug..."
# echo ""
# echo "✅ Debug solo afectó la sección específica"

echo ""

# ============================================
# PASO 7: Debug Condicional
# ============================================
echo "--- Paso 7: Debug Condicional ---"

# Función para debug que solo actúa si DEBUG está definido

# Descomenta las siguientes líneas:
# debug() {
#     [[ -n "${DEBUG:-}" ]] && echo "[DEBUG] $*" >&2
# }
# 
# process_data() {
#     local input="$1"
#     debug "Procesando: $input"
#     local result="${input^^}"  # uppercase
#     debug "Resultado: $result"
#     echo "$result"
# }
# 
# echo "Sin DEBUG:"
# process_data "hello"
# 
# echo ""
# echo "Con DEBUG=1:"
# DEBUG=1 process_data "hello"
# 
# echo ""
# echo "Tip: Ejecuta 'DEBUG=1 ./script.sh' para ver debug"

echo ""

echo "========================================"
echo "✅ Práctica 01 completada"
echo "========================================"
