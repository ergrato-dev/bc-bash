#!/bin/bash
# ============================================
# PRÁCTICA 04: CI/CD y Git Hooks
# Semana 8 - Proyectos Avanzados
# ============================================

set -euo pipefail

# ============================================
# PASO 1: Pre-commit Hook
# ============================================
echo "--- Paso 1: Pre-commit Hook ---"

# Estructura de un pre-commit hook
# Descomenta las siguientes líneas:
# PRE_COMMIT_HOOK='#!/bin/bash
# set -euo pipefail
# 
# echo "🔍 Running pre-commit checks..."
# 
# # Obtener archivos staged
# files=$(git diff --cached --name-only --diff-filter=ACM | grep "\.sh$" || true)
# 
# if [[ -n "$files" ]]; then
#     echo "Checking: $files"
#     shellcheck $files || exit 1
# fi
# 
# echo "✅ Pre-commit passed"
# '
# 
# echo "Ejemplo de pre-commit hook:"
# echo "$PRE_COMMIT_HOOK" | head -15

echo ""

# ============================================
# PASO 2: Validación de Código
# ============================================
echo "--- Paso 2: Validación de Código ---"

# Funciones de validación
# Descomenta las siguientes líneas:
# validate_syntax() {
#     local file="$1"
#     echo "  Verificando sintaxis: $file"
#     if bash -n "$file" 2>&1; then
#         echo "    ✅ Sintaxis válida"
#         return 0
#     else
#         echo "    ❌ Error de sintaxis"
#         return 1
#     fi
# }
# 
# validate_lint() {
#     local file="$1"
#     echo "  Linting: $file"
#     if command -v shellcheck &>/dev/null; then
#         if shellcheck "$file" 2>&1 | head -5; then
#             echo "    ✅ Sin warnings críticos"
#             return 0
#         fi
#     else
#         echo "    ⚠️ shellcheck no instalado, saltando"
#     fi
#     return 0
# }
# 
# # Validar este script
# echo "Validando script actual..."
# validate_syntax "${BASH_SOURCE[0]}"

echo ""

# ============================================
# PASO 3: Tests Automatizados
# ============================================
echo "--- Paso 3: Tests Automatizados ---"

# Framework simple de tests
# Descomenta las siguientes líneas:
# declare -i TESTS_PASSED=0
# declare -i TESTS_FAILED=0
# 
# assert_equals() {
#     local expected="$1"
#     local actual="$2"
#     local message="${3:-}"
#     
#     if [[ "$expected" == "$actual" ]]; then
#         echo "  ✅ PASS: $message"
#         ((TESTS_PASSED++))
#         return 0
#     else
#         echo "  ❌ FAIL: $message"
#         echo "     Expected: $expected"
#         echo "     Actual:   $actual"
#         ((TESTS_FAILED++))
#         return 1
#     fi
# }
# 
# test_string_operations() {
#     local str="hello"
#     assert_equals "HELLO" "${str^^}" "uppercase"
#     assert_equals "hello" "${str}" "original unchanged"
#     assert_equals "5" "${#str}" "string length"
# }
# 
# # Ejecutar tests
# echo "Ejecutando tests..."
# test_string_operations || true
# echo ""
# echo "Resultados: $TESTS_PASSED passed, $TESTS_FAILED failed"

echo ""

# ============================================
# PASO 4: Makefile Básico
# ============================================
echo "--- Paso 4: Makefile Básico ---"

# Generar un Makefile de ejemplo
# Descomenta las siguientes líneas:
# MAKEFILE_CONTENT='.PHONY: all test lint clean install

# all: lint test

# lint:
# 	@echo "🔍 Linting..."
# 	shellcheck bin/*.sh lib/*.sh

# test:
# 	@echo "🧪 Testing..."
# 	./tests/run-all.sh

# clean:
# 	@echo "🧹 Cleaning..."
# 	rm -rf dist/ .cache/

# build: clean
# 	@echo "📦 Building..."
# 	mkdir -p dist
# 	cp -r bin lib dist/

# install-hooks:
# 	@echo "🔗 Installing git hooks..."
# 	cp hooks/* .git/hooks/
# 	chmod +x .git/hooks/*
# '
# 
# echo "Ejemplo de Makefile:"
# echo "$MAKEFILE_CONTENT" | head -20

echo ""

# ============================================
# PASO 5: Script de Instalación de Hooks
# ============================================
echo "--- Paso 5: Script de Instalación de Hooks ---"

# Instalar hooks de Git
# Descomenta las siguientes líneas:
# install_git_hooks() {
#     local hooks_dir="${1:-.git/hooks}"
#     local hooks=("pre-commit" "pre-push")
#     
#     echo "Instalando hooks en $hooks_dir..."
#     
#     for hook in "${hooks[@]}"; do
#         local hook_file="$hooks_dir/$hook"
#         
#         # Crear hook básico
#         cat > "$hook_file" << 'HOOK'
# #!/bin/bash
# set -euo pipefail
# echo "Running $0..."
# # Añadir validaciones aquí
# exit 0
# HOOK
#         
#         chmod +x "$hook_file"
#         echo "  ✅ Instalado: $hook"
#     done
# }
# 
# # Demo (no ejecutar en repo real)
# # install_git_hooks "/tmp/demo-hooks"
# echo "Función install_git_hooks definida"

echo ""

# ============================================
# PASO 6: Pipeline CI Local
# ============================================
echo "--- Paso 6: Pipeline CI Local ---"

# Simular pipeline de CI en local
# Descomenta las siguientes líneas:
# readonly GREEN='\033[0;32m'
# readonly RED='\033[0;31m'
# readonly NC='\033[0m'
# 
# ci_stage() {
#     local name="$1"
#     local cmd="$2"
#     
#     echo -n "[$name] "
#     if eval "$cmd" &>/dev/null; then
#         echo -e "${GREEN}✓${NC}"
#         return 0
#     else
#         echo -e "${RED}✗${NC}"
#         return 1
#     fi
# }
# 
# run_ci_pipeline() {
#     echo "╔════════════════════════════════════╗"
#     echo "║         LOCAL CI PIPELINE          ║"
#     echo "╚════════════════════════════════════╝"
#     echo ""
#     
#     ci_stage "Syntax Check" "bash -n ${BASH_SOURCE[0]}"
#     ci_stage "ShellCheck" "command -v shellcheck"
#     ci_stage "Dependencies" "command -v curl"
#     ci_stage "Tests" "true"  # Placeholder
#     
#     echo ""
#     echo "═══════════════════════════════════════"
#     echo "✅ CI Pipeline completed"
#     echo "═══════════════════════════════════════"
# }
# 
# run_ci_pipeline

echo ""

# ============================================
# RESUMEN
# ============================================
echo "=== RESUMEN ==="
echo "✓ Pre-commit hook para validación"
echo "✓ Validación: sintaxis + shellcheck"
echo "✓ Framework de tests con assert"
echo "✓ Makefile para automatización"
echo "✓ Script de instalación de hooks"
echo "✓ Pipeline CI local"
