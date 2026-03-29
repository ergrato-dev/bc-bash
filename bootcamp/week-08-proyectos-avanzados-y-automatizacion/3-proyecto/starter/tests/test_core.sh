#!/bin/bash
# ============================================
# Tests para core.sh
# ============================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/core.sh"

# Contadores
declare -i PASSED=0
declare -i FAILED=0

assert_equals() {
    local expected="$1"
    local actual="$2"
    local message="$3"
    
    if [[ "$expected" == "$actual" ]]; then
        echo "✅ PASS: $message"
        ((PASSED++))
    else
        echo "❌ FAIL: $message"
        echo "   Expected: $expected"
        echo "   Actual:   $actual"
        ((FAILED++))
    fi
}

# Tests
test_log_functions_exist() {
    assert_equals "0" "$(type -t log_info &>/dev/null; echo $?)" "log_info exists"
    assert_equals "0" "$(type -t log_warn &>/dev/null; echo $?)" "log_warn exists"
    assert_equals "0" "$(type -t log_error &>/dev/null; echo $?)" "log_error exists"
}

test_die_function() {
    assert_equals "0" "$(type -t die &>/dev/null; echo $?)" "die function exists"
}

# Run tests
echo "=== Running Core Tests ==="
test_log_functions_exist
test_die_function

echo ""
echo "=== Results ==="
echo "Passed: $PASSED"
echo "Failed: $FAILED"

[[ $FAILED -eq 0 ]]
