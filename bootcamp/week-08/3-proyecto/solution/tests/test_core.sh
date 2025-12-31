#!/bin/bash
# ============================================
# Tests para core.sh
# SOLUCIÓN COMPLETA
# ============================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/core.sh"

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
        return 0
    else
        echo -e "  ${RED}✗${NC} $message"
        ((FAILED++))
        return 1
    fi
}

assert_false() {
    local condition="$1"
    local message="${2:-Should be false}"
    
    if ! eval "$condition"; then
        echo -e "  ${GREEN}✓${NC} $message"
        ((PASSED++))
        return 0
    else
        echo -e "  ${RED}✗${NC} $message"
        ((FAILED++))
        return 1
    fi
}

# ============================================
# Tests
# ============================================

test_log_functions() {
    echo "Testing log functions..."
    
    assert_true "declare -f log_info >/dev/null" "log_info exists"
    assert_true "declare -f log_warn >/dev/null" "log_warn exists"
    assert_true "declare -f log_error >/dev/null" "log_error exists"
    assert_true "declare -f log_debug >/dev/null" "log_debug exists"
}

test_die_function() {
    echo "Testing die function..."
    
    assert_true "declare -f die >/dev/null" "die function exists"
}

test_trim_function() {
    echo "Testing trim function..."
    
    local result
    result=$(trim "  hello  ")
    assert_equals "hello" "$result" "trim removes spaces"
    
    result=$(trim "no spaces")
    assert_equals "no spaces" "$result" "trim keeps normal text"
}

test_case_functions() {
    echo "Testing case functions..."
    
    local result
    result=$(to_upper "hello")
    assert_equals "HELLO" "$result" "to_upper works"
    
    result=$(to_lower "HELLO")
    assert_equals "hello" "$result" "to_lower works"
}

test_file_functions() {
    echo "Testing file functions..."
    
    assert_true "file_exists '${BASH_SOURCE[0]}'" "file_exists on existing file"
    assert_false "file_exists '/nonexistent/file'" "file_exists on missing file"
    
    assert_true "dir_exists '$SCRIPT_DIR'" "dir_exists on existing dir"
    assert_false "dir_exists '/nonexistent/dir'" "dir_exists on missing dir"
}

# ============================================
# Run tests
# ============================================

main() {
    echo ""
    echo "╔════════════════════════════════════════════╗"
    echo "║          CORE.SH TEST SUITE                ║"
    echo "╚════════════════════════════════════════════╝"
    echo ""
    
    test_log_functions
    echo ""
    
    test_die_function
    echo ""
    
    test_trim_function
    echo ""
    
    test_case_functions
    echo ""
    
    test_file_functions
    echo ""
    
    echo "════════════════════════════════════════════"
    echo -e "Results: ${GREEN}$PASSED passed${NC}, ${RED}$FAILED failed${NC}"
    echo "════════════════════════════════════════════"
    
    [[ $FAILED -eq 0 ]]
}

main "$@"
