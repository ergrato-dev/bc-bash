#!/bin/bash
# ============================================
# Tests para pipeline.sh
# SOLUCIÓN COMPLETA
# ============================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/core.sh"
source "$SCRIPT_DIR/../lib/pipeline.sh"

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
# Mock stages
# ============================================

stage_success() {
    return 0
}

stage_failure() {
    return 1
}

stage_slow() {
    sleep 0.1
    return 0
}

# ============================================
# Tests
# ============================================

test_pipeline_add_stage() {
    echo "Testing pipeline_add_stage..."
    
    pipeline_reset
    pipeline_add_stage "success"
    
    assert_equals "1" "${#PIPELINE_STAGES[@]}" "Stage added to array"
    assert_equals "success" "${PIPELINE_STAGES[0]}" "Stage name is correct"
}

test_pipeline_run_success() {
    echo "Testing pipeline_run with success..."
    
    pipeline_reset
    pipeline_add_stage "success"
    
    if pipeline_run &>/dev/null; then
        echo -e "  ${GREEN}✓${NC} Pipeline completes successfully"
        ((PASSED++))
    else
        echo -e "  ${RED}✗${NC} Pipeline should succeed"
        ((FAILED++))
    fi
    
    assert_equals "pass" "${STAGE_STATUS[success]}" "Stage status is pass"
}

test_pipeline_run_failure() {
    echo "Testing pipeline_run with failure..."
    
    pipeline_reset
    pipeline_add_stage "success"
    pipeline_add_stage "failure"
    pipeline_add_stage "success"  # Should not run
    
    if ! pipeline_run &>/dev/null; then
        echo -e "  ${GREEN}✓${NC} Pipeline fails as expected"
        ((PASSED++))
    else
        echo -e "  ${RED}✗${NC} Pipeline should fail"
        ((FAILED++))
    fi
    
    assert_equals "fail" "${STAGE_STATUS[failure]}" "Failed stage status is fail"
}

test_pipeline_retry() {
    echo "Testing pipeline_retry..."
    
    local counter=0
    flaky_cmd() {
        ((counter++))
        [[ $counter -ge 3 ]]
    }
    
    if pipeline_retry 5 0.1 flaky_cmd; then
        echo -e "  ${GREEN}✓${NC} Retry succeeds after multiple attempts"
        ((PASSED++))
    else
        echo -e "  ${RED}✗${NC} Retry should succeed"
        ((FAILED++))
    fi
}

# ============================================
# Run tests
# ============================================

main() {
    echo ""
    echo "╔════════════════════════════════════════════╗"
    echo "║       PIPELINE.SH TEST SUITE               ║"
    echo "╚════════════════════════════════════════════╝"
    echo ""
    
    test_pipeline_add_stage
    echo ""
    
    test_pipeline_run_success
    echo ""
    
    test_pipeline_run_failure
    echo ""
    
    test_pipeline_retry
    echo ""
    
    echo "════════════════════════════════════════════"
    echo -e "Results: ${GREEN}$PASSED passed${NC}, ${RED}$FAILED failed${NC}"
    echo "════════════════════════════════════════════"
    
    [[ $FAILED -eq 0 ]]
}

main "$@"
