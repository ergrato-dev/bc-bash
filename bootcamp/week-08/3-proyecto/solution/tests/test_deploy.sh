#!/bin/bash
# ============================================
# Tests para deploy.sh
# SOLUCIÓN COMPLETA
# ============================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/core.sh"
source "$SCRIPT_DIR/../lib/deploy.sh"

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

test_deploy_functions_exist() {
    echo "Testing deploy functions exist..."
    
    assert_true "declare -f deploy_rsync >/dev/null" "deploy_rsync exists"
    assert_true "declare -f deploy_scp >/dev/null" "deploy_scp exists"
    assert_true "declare -f deploy_health_check >/dev/null" "deploy_health_check exists"
    assert_true "declare -f deploy_backup >/dev/null" "deploy_backup exists"
    assert_true "declare -f deploy_rollback >/dev/null" "deploy_rollback exists"
}

test_deploy_backup() {
    echo "Testing deploy_backup..."
    
    # Crear directorio temporal para test
    local temp_dir="/tmp/test_deploy_$$"
    local source_dir="$temp_dir/source"
    local backup_dir="$temp_dir/backups"
    
    mkdir -p "$source_dir"
    echo "test content" > "$source_dir/test.txt"
    
    # Ejecutar backup
    local backup_path
    backup_path=$(deploy_backup "$source_dir" "$backup_dir" 2>/dev/null)
    
    if [[ -d "$backup_path" ]]; then
        echo -e "  ${GREEN}✓${NC} Backup directory created"
        ((PASSED++))
    else
        echo -e "  ${RED}✗${NC} Backup directory not created"
        ((FAILED++))
    fi
    
    if [[ -f "$backup_path/test.txt" ]]; then
        echo -e "  ${GREEN}✓${NC} Backup contains files"
        ((PASSED++))
    else
        echo -e "  ${RED}✗${NC} Backup missing files"
        ((FAILED++))
    fi
    
    # Cleanup
    rm -rf "$temp_dir"
}

test_deploy_cleanup_backups() {
    echo "Testing deploy_cleanup_backups..."
    
    # Crear directorio temporal con varios backups
    local backup_dir="/tmp/test_backups_$$"
    mkdir -p "$backup_dir"
    
    for i in 1 2 3 4 5 6 7; do
        mkdir -p "$backup_dir/backup_2024010${i}_120000"
        sleep 0.1
    done
    
    local before_count
    before_count=$(find "$backup_dir" -maxdepth 1 -type d -name "backup_*" | wc -l)
    
    deploy_cleanup_backups "$backup_dir" 3 2>/dev/null
    
    local after_count
    after_count=$(find "$backup_dir" -maxdepth 1 -type d -name "backup_*" | wc -l)
    
    assert_equals "3" "$after_count" "Cleanup keeps only 3 backups"
    
    # Cleanup
    rm -rf "$backup_dir"
}

# ============================================
# Run tests
# ============================================

main() {
    echo ""
    echo "╔════════════════════════════════════════════╗"
    echo "║        DEPLOY.SH TEST SUITE                ║"
    echo "╚════════════════════════════════════════════╝"
    echo ""
    
    test_deploy_functions_exist
    echo ""
    
    test_deploy_backup
    echo ""
    
    test_deploy_cleanup_backups
    echo ""
    
    echo "════════════════════════════════════════════"
    echo -e "Results: ${GREEN}$PASSED passed${NC}, ${RED}$FAILED failed${NC}"
    echo "════════════════════════════════════════════"
    
    [[ $FAILED -eq 0 ]]
}

main "$@"
