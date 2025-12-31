#!/bin/bash
# ============================================
# PRÁCTICA 04: Testing y Validación
# Semana 7 - Debugging y Optimización
# ============================================

echo "========================================"
echo "🧪 PRÁCTICA 04: Testing y Validación"
echo "========================================"
echo ""

# ============================================
# PASO 1: Función Assert
# ============================================
echo "--- Paso 1: Función Assert ---"

# assert verifica que una condición sea verdadera

# Descomenta las siguientes líneas:
# assert() {
#     local message="$1"
#     shift
#     if "$@"; then
#         echo "  ✅ PASS: $message"
#         return 0
#     else
#         echo "  ❌ FAIL: $message" >&2
#         return 1
#     fi
# }
# 
# echo "Probando assert:"
# echo ""
# assert "2+2 equals 4" [ $((2+2)) -eq 4 ]
# assert "String 'hello' is not empty" [ -n "hello" ]
# assert "/etc/passwd exists" [ -f "/etc/passwd" ]
# 
# echo ""
# echo "Probando assert que falla (esperado):"
# assert "1 equals 2 (should fail)" [ 1 -eq 2 ] || true

echo ""

# ============================================
# PASO 2: Estructura de Tests
# ============================================
echo "--- Paso 2: Estructura de Tests ---"

# Organizar tests como funciones con prefijo test_

# Descomenta las siguientes líneas:
# # Funciones a testear
# suma() {
#     echo $(($1 + $2))
# }
# 
# resta() {
#     echo $(($1 - $2))
# }
# 
# es_numero() {
#     [[ "$1" =~ ^[0-9]+$ ]]
# }
# 
# # Tests
# test_suma_basica() {
#     local result=$(suma 2 3)
#     [[ "$result" -eq 5 ]]
# }
# 
# test_suma_cero() {
#     local result=$(suma 0 0)
#     [[ "$result" -eq 0 ]]
# }
# 
# test_resta_basica() {
#     local result=$(resta 5 3)
#     [[ "$result" -eq 2 ]]
# }
# 
# test_es_numero_valido() {
#     es_numero "123"
# }
# 
# test_es_numero_invalido() {
#     ! es_numero "abc"
# }
# 
# echo "Tests definidos:"
# declare -F | grep "test_" | awk '{print "  - " $3}'

echo ""

# ============================================
# PASO 3: Test Runner
# ============================================
echo "--- Paso 3: Test Runner ---"

# Ejecutar todos los tests automáticamente

# Descomenta las siguientes líneas:
# run_tests() {
#     local passed=0
#     local failed=0
#     local test_funcs
#     
#     # Obtener lista de funciones test_
#     test_funcs=$(declare -F | grep "test_" | awk '{print $3}')
#     
#     echo "Ejecutando tests:"
#     echo ""
#     
#     for test_func in $test_funcs; do
#         if $test_func; then
#             echo "  ✅ $test_func"
#             ((passed++))
#         else
#             echo "  ❌ $test_func"
#             ((failed++))
#         fi
#     done
#     
#     echo ""
#     echo "================================"
#     echo "Resultados: $passed passed, $failed failed"
#     
#     [[ $failed -eq 0 ]]
# }
# 
# run_tests

echo ""

# ============================================
# PASO 4: Validación de Input
# ============================================
echo "--- Paso 4: Validación de Input ---"

# Validar argumentos antes de usarlos

# Descomenta las siguientes líneas:
# die() {
#     echo "ERROR: $*" >&2
#     return 1
# }
# 
# validate_number() {
#     local value="$1"
#     [[ "$value" =~ ^[0-9]+$ ]] || die "'$value' no es un número"
#     echo "  ✅ '$value' es un número válido"
# }
# 
# validate_file() {
#     local file="$1"
#     [[ -f "$file" ]] || die "Archivo no existe: $file"
#     [[ -r "$file" ]] || die "Sin permisos de lectura: $file"
#     echo "  ✅ '$file' es válido"
# }
# 
# validate_not_empty() {
#     local value="$1"
#     local name="${2:-valor}"
#     [[ -n "$value" ]] || die "$name está vacío"
#     echo "  ✅ $name no está vacío"
# }
# 
# echo "Probando validaciones:"
# echo ""
# validate_number "123"
# validate_number "456"
# validate_file "/etc/passwd"
# validate_not_empty "hello" "mi_variable"
# 
# echo ""
# echo "Probando validación que falla:"
# validate_number "abc" || true

echo ""

# ============================================
# PASO 5: ShellCheck
# ============================================
echo "--- Paso 5: ShellCheck ---"

# ShellCheck es un analizador estático para scripts

# Descomenta las siguientes líneas:
# echo "ShellCheck - Análisis estático de scripts"
# echo ""
# 
# if command -v shellcheck &>/dev/null; then
#     echo "✅ ShellCheck está instalado"
#     echo "   Versión: $(shellcheck --version | head -2 | tail -1)"
# else
#     echo "❌ ShellCheck no está instalado"
#     echo ""
#     echo "Instalación:"
#     echo "  Ubuntu/Debian: sudo apt install shellcheck"
#     echo "  Fedora: sudo dnf install ShellCheck"
#     echo "  macOS: brew install shellcheck"
# fi
# 
# echo ""
# echo "Uso:"
# echo "  shellcheck script.sh"
# echo "  shellcheck -x script.sh  # Seguir sources"
# echo ""
# echo "Ejemplo de errores que detecta:"
# echo "  SC2086: Double quote to prevent globbing"
# echo "  SC2046: Quote to prevent word splitting"
# echo "  SC2034: Variable appears unused"

echo ""

# ============================================
# PASO 6: Mini Framework de Tests
# ============================================
echo "--- Paso 6: Mini Framework ---"

# Framework completo con setup/teardown

# Descomenta las siguientes líneas:
# # Variables globales para el framework
# declare -i TEST_PASSED=0
# declare -i TEST_FAILED=0
# 
# # Setup que se ejecuta antes de cada test
# setup() {
#     TEST_TEMP_DIR=$(mktemp -d)
# }
# 
# # Teardown que se ejecuta después de cada test
# teardown() {
#     [[ -d "$TEST_TEMP_DIR" ]] && rm -rf "$TEST_TEMP_DIR"
# }
# 
# # Runner mejorado
# run_test() {
#     local test_name="$1"
#     
#     setup
#     if "$test_name"; then
#         echo "  ✅ $test_name"
#         ((TEST_PASSED++))
#     else
#         echo "  ❌ $test_name"
#         ((TEST_FAILED++))
#     fi
#     teardown
# }
# 
# # Tests de ejemplo usando el framework
# test_create_temp_file() {
#     local file="$TEST_TEMP_DIR/test.txt"
#     echo "hello" > "$file"
#     [[ -f "$file" ]]
# }
# 
# test_read_temp_file() {
#     local file="$TEST_TEMP_DIR/data.txt"
#     echo "world" > "$file"
#     local content=$(cat "$file")
#     [[ "$content" == "world" ]]
# }
# 
# echo "Ejecutando framework de tests:"
# echo ""
# run_test test_create_temp_file
# run_test test_read_temp_file
# 
# echo ""
# echo "================================"
# echo "Total: $TEST_PASSED passed, $TEST_FAILED failed"

echo ""

echo "========================================"
echo "✅ Práctica 04 completada"
echo "========================================"
echo ""
echo "💡 Tips para testing:"
echo "   - Escribe tests para funciones críticas"
echo "   - Usa ShellCheck en tu CI/CD"
echo "   - Valida TODOS los inputs del usuario"
