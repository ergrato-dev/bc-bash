#!/bin/bash
# ============================================
# Tests para config.sh
# SOLUCIÓN COMPLETA
# ============================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/core.sh"
source "$SCRIPT_DIR/../lib/config.sh"

# Contadores
declare -i PASSED=0
declare -i FAILED=0

# ============================================
# Test framework
# ============================================

assert_equals() {
    local expected="$1"
    local actual="$2"
    local message="${3:-Assertion}"
    
    if [[ "$expected" == "$actual" ]]; then
        echo -e "  ${GREEN}✓${NC} $message"
        ((PASSED++))
        return 0
    else
        echo -e "  ${RED}✗${NC} $message"
        echo "    Expected: '$expected'"
        echo "    Actual:   '$actual'"
        ((FAILED++))
        return 1
    fi
}

assert_true() {
    local condition="$1"
    local message="${2:-Should be true}"
    
    if eval "$condition"; then
        echo -e "  ${GREEN}✓${NC} $message"
        ((PASSED++))
    else
        echo -e "  ${RED}✗${NC} $message"
        ((FAILED++))
    fi
}

# ============================================
# Tests
# ============================================

test_config_set_get() {
    echo "Testing config_set and config_get..."
    
    config_set "TEST_KEY" "test_value"
    local result
    result=$(config_get "TEST_KEY")
    assert_equals "test_value" "$result" "config_set/get works"
    
    result=$(config_get "NONEXISTENT" "default")
    assert_equals "default" "$result" "config_get returns default"
}

test_config_has() {
    echo "Testing config_has..."
    
    config_set "EXISTS" "yes"
    assert_true "config_has 'EXISTS'" "config_has returns true for existing"
    assert_true "! config_has 'NOTEXISTS'" "config_has returns false for missing"
}

test_config_load() {
    echo "Testing config_load..."
    
    # Crear archivo de config temporal
    local temp_config="/tmp/test_config_$$.conf"
    cat > "$temp_config" << 'EOF'
# Comment line
APP_NAME=TestApp
VERSION=2.0.0

# Another comment
DEBUG=true
EOF
    
    config_load "$temp_config"
    
    local result
    result=$(config_get "APP_NAME")
    assert_equals "TestApp" "$result" "config_load parses APP_NAME"
    
    result=$(config_get "VERSION")
    assert_equals "2.0.0" "$result" "config_load parses VERSION"
    
    result=$(config_get "DEBUG")
    assert_equals "true" "$result" "config_load parses DEBUG"
    
    rm -f "$temp_config"
}

test_config_validate() {
    echo "Testing config_validate..."
    
    config_set "REQUIRED1" "value1"
    config_set "REQUIRED2" "value2"
    
    assert_true "config_validate 'REQUIRED1' 'REQUIRED2'" "validate passes with all required"
}

# ============================================
# Run tests
# ============================================

main() {
    echo ""
    echo "╔════════════════════════════════════════════╗"
    echo "║        CONFIG.SH TEST SUITE                ║"
    echo "╚════════════════════════════════════════════╝"
    echo ""
    
    test_config_set_get
    echo ""
    
    test_config_has
    echo ""
    
    test_config_load
    echo ""
    
    test_config_validate
    echo ""
    
    echo "════════════════════════════════════════════"
    echo -e "Results: ${GREEN}$PASSED passed${NC}, ${RED}$FAILED failed${NC}"
    echo "════════════════════════════════════════════"
    
    [[ $FAILED -eq 0 ]]
}

main "$@"
