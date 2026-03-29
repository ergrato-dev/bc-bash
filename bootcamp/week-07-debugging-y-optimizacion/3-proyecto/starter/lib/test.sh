#!/bin/bash
# ============================================
# Test Library - Framework de testing
# ============================================

# Contadores
declare -i _TESTS_PASSED=0
declare -i _TESTS_FAILED=0
declare -i _TESTS_TOTAL=0

# Colores
readonly _T_RED='\033[0;31m'
readonly _T_GREEN='\033[0;32m'
readonly _T_NC='\033[0m'

# ============================================
# Función: run_test
# Ejecutar un test individual
# ============================================
run_test() {
    local test_name="$1"
    ((_TESTS_TOTAL++))
    
    if "$test_name" 2>/dev/null; then
        echo -e "${_T_GREEN}✅ PASS${_T_NC}: $test_name"
        ((_TESTS_PASSED++))
        return 0
    else
        echo -e "${_T_RED}❌ FAIL${_T_NC}: $test_name"
        ((_TESTS_FAILED++))
        return 1
    fi
}

# ============================================
# Función: run_all_tests
# Ejecutar todos los tests (funciones test_*)
# ============================================
run_all_tests() {
    local test_funcs
    test_funcs=$(declare -F | grep " test_" | awk '{print $3}')
    
    echo "Running tests..."
    echo ""
    
    for func in $test_funcs; do
        run_test "$func"
    done
    
    test_summary
}

# ============================================
# Función: test_summary
# Mostrar resumen de tests
# ============================================
test_summary() {
    echo ""
    echo "================================"
    echo "Tests: $_TESTS_TOTAL total"
    echo -e "${_T_GREEN}Passed: $_TESTS_PASSED${_T_NC}"
    echo -e "${_T_RED}Failed: $_TESTS_FAILED${_T_NC}"
    echo "================================"
    
    [[ $_TESTS_FAILED -eq 0 ]]
}

# ============================================
# Función: assert_equals
# Verificar igualdad
# ============================================
assert_equals() {
    local expected="$1"
    local actual="$2"
    local message="${3:-Values should be equal}"
    
    if [[ "$expected" == "$actual" ]]; then
        return 0
    else
        echo "  Expected: '$expected'"
        echo "  Actual:   '$actual'"
        return 1
    fi
}

# ============================================
# Función: assert_true
# Verificar condición verdadera
# ============================================
assert_true() {
    "$@"
}

# ============================================
# Función: assert_false
# Verificar condición falsa
# ============================================
assert_false() {
    ! "$@"
}
