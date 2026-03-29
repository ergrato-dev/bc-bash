#!/bin/bash
# ============================================
# Tests para sample.sh
# ============================================

# Cargar el script a testear
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/sample.sh"

# Cargar framework de tests
source "$SCRIPT_DIR/../lib/test.sh"

# ============================================
# Tests
# ============================================

test_suma_basica() {
    local result=$(suma 2 3)
    assert_equals "5" "$result"
}

test_suma_cero() {
    local result=$(suma 0 0)
    assert_equals "0" "$result"
}

test_suma_negativos() {
    local result=$(suma -5 3)
    assert_equals "-2" "$result"
}

test_resta_basica() {
    local result=$(resta 10 3)
    assert_equals "7" "$result"
}

test_multiplica_basica() {
    local result=$(multiplica 4 5)
    assert_equals "20" "$result"
}

test_multiplica_por_cero() {
    local result=$(multiplica 100 0)
    assert_equals "0" "$result"
}

# ============================================
# Ejecutar tests si es el script principal
# ============================================
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    run_all_tests
fi
