#!/bin/bash
# ============================================
# PRÁCTICA 02: Traps y Manejo de Errores
# Semana 7 - Debugging y Optimización
# ============================================

echo "========================================"
echo "🪤 PRÁCTICA 02: Traps y Manejo de Errores"
echo "========================================"
echo ""

# ============================================
# PASO 1: Trap EXIT (Limpieza)
# ============================================
echo "--- Paso 1: Trap EXIT ---"

# trap EXIT se ejecuta siempre al salir del script
# Perfecto para limpieza de recursos temporales

# Descomenta las siguientes líneas:
# # Variable para archivo temporal
# TEMP_FILE=""
# 
# cleanup() {
#     echo "  [CLEANUP] Ejecutando limpieza..."
#     if [[ -n "$TEMP_FILE" && -f "$TEMP_FILE" ]]; then
#         rm -f "$TEMP_FILE"
#         echo "  [CLEANUP] Archivo temporal eliminado"
#     fi
# }
# 
# # Registrar el trap
# trap cleanup EXIT
# 
# echo "Creando archivo temporal..."
# TEMP_FILE=$(mktemp)
# echo "  Archivo creado: $TEMP_FILE"
# echo "datos de prueba" > "$TEMP_FILE"
# 
# echo "Verificando que existe:"
# ls -la "$TEMP_FILE"
# 
# echo ""
# echo "El cleanup se ejecutará al final del script..."

echo ""

# ============================================
# PASO 2: Trap ERR (Errores)
# ============================================
echo "--- Paso 2: Trap ERR ---"

# trap ERR se ejecuta cuando un comando retorna error
# Útil para logging de errores

# Descomenta las siguientes líneas:
# on_error() {
#     local exit_code=$?
#     local line_no=$1
#     echo "  [ERROR] Código $exit_code en línea $line_no" >&2
# }
# 
# # El trap pasa LINENO como argumento
# trap 'on_error $LINENO' ERR
# 
# echo "Ejecutando comandos..."
# echo "  Comando 1: OK"
# true  # Siempre exitoso
# 
# echo "  Comando 2: OK"
# true
# 
# echo ""
# echo "Simulando error (controlado):"
# # Usamos subshell para no afectar el script principal
# (
#     trap 'on_error $LINENO' ERR
#     set -e
#     false  # Este falla
# ) || echo "  Error capturado en subshell"

echo ""

# ============================================
# PASO 3: Trap DEBUG (Tracing)
# ============================================
echo "--- Paso 3: Trap DEBUG ---"

# trap DEBUG se ejecuta antes de cada comando
# Muy útil para tracing detallado

# Descomenta las siguientes líneas:
# echo "Activando trap DEBUG temporalmente:"
# echo ""
# 
# (
#     # Solo en esta subshell para no afectar el resto
#     debug_trace() {
#         echo "  [TRACE] $BASH_COMMAND"
#     }
#     trap debug_trace DEBUG
#     
#     x=5
#     y=10
#     sum=$((x + y))
# )
# 
# echo ""
# echo "DEBUG trap desactivado"

echo ""

# ============================================
# PASO 4: Trap para Señales
# ============================================
echo "--- Paso 4: Trap de Señales ---"

# Capturar señales del sistema como SIGINT (Ctrl+C)

# Descomenta las siguientes líneas:
# echo "Señales comunes:"
# echo "  SIGINT  (2)  - Ctrl+C"
# echo "  SIGTERM (15) - Terminación"
# echo "  SIGHUP  (1)  - Hangup"
# echo ""
# 
# on_interrupt() {
#     echo ""
#     echo "  [SIGNAL] Interrupción detectada!"
#     echo "  [SIGNAL] Limpiando antes de salir..."
# }
# 
# # Ejemplo de configuración (no activamos para no interferir)
# echo "Ejemplo de configuración:"
# echo "  trap 'on_interrupt; exit 130' SIGINT"
# echo "  trap 'cleanup; exit 0' SIGTERM"
# echo ""
# echo "El código 130 = 128 + 2 (SIGINT)"

echo ""

# ============================================
# PASO 5: Múltiples Traps
# ============================================
echo "--- Paso 5: Combinar Traps ---"

# Puedes tener múltiples traps para diferentes eventos

# Descomenta las siguientes líneas:
# echo "Patrón robusto de traps:"
# echo ""
# cat << 'EOF'
#   #!/bin/bash
#   set -euo pipefail
#   
#   cleanup() { ... }
#   on_error() { ... }
#   on_interrupt() { cleanup; exit 130; }
#   
#   trap cleanup EXIT
#   trap 'on_error $LINENO' ERR
#   trap on_interrupt SIGINT SIGTERM
# EOF
# echo ""
# echo "Este patrón garantiza:"
# echo "  - Limpieza siempre (EXIT)"
# echo "  - Logging de errores (ERR)"
# echo "  - Manejo de interrupciones (SIGINT/SIGTERM)"

echo ""

# ============================================
# PASO 6: Función die()
# ============================================
echo "--- Paso 6: Función die() ---"

# Patrón común para errores fatales con mensaje

# Descomenta las siguientes líneas:
# die() {
#     echo "ERROR: $*" >&2
#     exit 1
# }
# 
# validate_file() {
#     local file="$1"
#     [[ -f "$file" ]] || die "Archivo no existe: $file"
#     [[ -r "$file" ]] || die "Sin permisos de lectura: $file"
#     echo "  ✅ Archivo válido: $file"
# }
# 
# echo "Validando archivos:"
# 
# # Archivo que existe
# validate_file "/etc/passwd"
# 
# # Archivo que no existe (capturamos el error)
# echo ""
# echo "Probando con archivo inexistente:"
# (validate_file "/archivo/que/no/existe") || echo "  Error capturado correctamente"

echo ""

# ============================================
# PASO 7: Patrón Completo
# ============================================
echo "--- Paso 7: Patrón Completo ---"

# Ejemplo de script con manejo robusto de errores

# Descomenta las siguientes líneas:
# robust_script() {
#     local temp_file=""
#     
#     # Limpieza
#     cleanup() {
#         [[ -n "$temp_file" && -f "$temp_file" ]] && rm -f "$temp_file"
#     }
#     trap cleanup EXIT
#     
#     # Error handler
#     on_error() {
#         echo "Error en línea $1" >&2
#     }
#     trap 'on_error $LINENO' ERR
#     
#     # Lógica del script
#     temp_file=$(mktemp)
#     echo "Procesando..."
#     echo "data" > "$temp_file"
#     cat "$temp_file"
#     echo "✅ Completado"
# }
# 
# echo "Ejecutando script robusto:"
# robust_script

echo ""

echo "========================================"
echo "✅ Práctica 02 completada"
echo "========================================"
