#!/bin/bash
# ============================================
# PROYECTO: DebugKit - Toolkit de Debugging
# Semana 7 - Debugging y Optimización
# ============================================
#
# Uso: ./debugkit.sh [comando] [opciones]
#
# Comandos:
#   debug <script>     Ejecutar script con debug habilitado
#   test <script>      Ejecutar tests de un script
#   validate <script>  Validar sintaxis de un script
#   profile <script>   Medir rendimiento de un script
#   lint <script>      Analizar con ShellCheck
#   help               Mostrar ayuda
#
# ============================================

set -euo pipefail

# ============================================
# CONFIGURACIÓN
# ============================================

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LIB_DIR="$SCRIPT_DIR/lib"

# Colores
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# ============================================
# FUNCIONES DE UTILIDAD
# ============================================

print_header() {
    echo -e "${CYAN}========================================"
    echo -e "  $1"
    echo -e "========================================${NC}"
}

print_ok() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# ============================================
# COMANDO: debug
# Ejecutar script con debug habilitado
# ============================================
cmd_debug() {
    local script="${1:-}"
    
    [[ -z "$script" ]] && { print_error "Uso: debugkit debug <script>"; return 1; }
    [[ -f "$script" ]] || { print_error "Script no existe: $script"; return 1; }
    
    print_header "DEBUG: $script"
    echo ""
    
    # TODO: Implementar ejecución con debug
    # - Ejecutar con set -x
    # - Capturar output
    # - Mostrar líneas con timestamps
    
    echo "TODO: Implementar debug mode"
    echo ""
    echo "Sugerencia:"
    echo "  PS4='+\$SECONDS:\$LINENO: '"
    echo "  bash -x \"\$script\" 2>&1"
}

# ============================================
# COMANDO: test
# Ejecutar tests de un script
# ============================================
cmd_test() {
    local test_file="${1:-}"
    
    print_header "TEST RUNNER"
    echo ""
    
    # TODO: Implementar test runner
    # - Buscar funciones test_*
    # - Ejecutar cada una
    # - Contar passed/failed
    # - Mostrar resumen
    
    echo "TODO: Implementar test runner"
    echo ""
    echo "Sugerencia:"
    echo "  source \"\$test_file\""
    echo "  for func in \$(declare -F | grep test_); do"
    echo "      \$func && echo PASS || echo FAIL"
    echo "  done"
}

# ============================================
# COMANDO: validate
# Validar sintaxis de un script
# ============================================
cmd_validate() {
    local script="${1:-}"
    
    [[ -z "$script" ]] && { print_error "Uso: debugkit validate <script>"; return 1; }
    [[ -f "$script" ]] || { print_error "Script no existe: $script"; return 1; }
    
    print_header "VALIDATE: $script"
    echo ""
    
    # TODO: Implementar validación
    # - Verificar shebang
    # - Ejecutar bash -n
    # - Reportar errores de sintaxis
    
    echo "Verificando sintaxis..."
    if bash -n "$script" 2>&1; then
        print_ok "Sintaxis válida"
    else
        print_error "Errores de sintaxis detectados"
        return 1
    fi
}

# ============================================
# COMANDO: profile
# Medir rendimiento de un script
# ============================================
cmd_profile() {
    local script="${1:-}"
    
    [[ -z "$script" ]] && { print_error "Uso: debugkit profile <script>"; return 1; }
    [[ -f "$script" ]] || { print_error "Script no existe: $script"; return 1; }
    
    print_header "PROFILE: $script"
    echo ""
    
    # TODO: Implementar profiler
    # - Medir tiempo total con time
    # - Usar PS4 con timestamps
    # - Identificar líneas lentas
    # - Generar reporte
    
    echo "TODO: Implementar profiler"
    echo ""
    echo "Sugerencia:"
    echo "  PS4='+\$(date \"+%s.%N\"):\$LINENO: '"
    echo "  bash -x \"\$script\" 2>trace.log"
    echo "  # Analizar trace.log para líneas lentas"
}

# ============================================
# COMANDO: lint
# Analizar con ShellCheck
# ============================================
cmd_lint() {
    local script="${1:-}"
    
    [[ -z "$script" ]] && { print_error "Uso: debugkit lint <script>"; return 1; }
    [[ -f "$script" ]] || { print_error "Script no existe: $script"; return 1; }
    
    print_header "LINT: $script"
    echo ""
    
    if ! command -v shellcheck &>/dev/null; then
        print_error "ShellCheck no está instalado"
        echo ""
        echo "Instalación:"
        echo "  Ubuntu: sudo apt install shellcheck"
        echo "  Fedora: sudo dnf install ShellCheck"
        echo "  macOS:  brew install shellcheck"
        return 1
    fi
    
    # TODO: Implementar lint wrapper
    # - Ejecutar shellcheck
    # - Formatear output
    # - Contar warnings/errors
    
    echo "Analizando con ShellCheck..."
    echo ""
    
    if shellcheck "$script"; then
        print_ok "Sin problemas detectados"
    else
        print_warn "Revisar los problemas reportados"
    fi
}

# ============================================
# COMANDO: help
# Mostrar ayuda
# ============================================
cmd_help() {
    cat << 'EOF'
DebugKit - Toolkit de Debugging para Bash

Uso: ./debugkit.sh [comando] [opciones]

Comandos disponibles:
  debug <script>     Ejecutar script con debug habilitado (set -x)
  test [test_file]   Ejecutar tests (funciones test_*)
  validate <script>  Validar sintaxis con bash -n
  profile <script>   Medir rendimiento de ejecución
  lint <script>      Analizar con ShellCheck
  help               Mostrar esta ayuda

Ejemplos:
  ./debugkit.sh validate mi_script.sh
  ./debugkit.sh lint mi_script.sh
  ./debugkit.sh debug mi_script.sh
  ./debugkit.sh test tests/test_funciones.sh

Características:
  - Framework de debugging con funciones reutilizables
  - Test runner automático para funciones test_*
  - Profiler con timestamps por línea
  - Wrapper para ShellCheck con formato mejorado

EOF
}

# ============================================
# MAIN
# ============================================
main() {
    local command="${1:-help}"
    shift || true
    
    case "$command" in
        debug)
            cmd_debug "$@"
            ;;
        test)
            cmd_test "$@"
            ;;
        validate|check)
            cmd_validate "$@"
            ;;
        profile|perf)
            cmd_profile "$@"
            ;;
        lint|shellcheck)
            cmd_lint "$@"
            ;;
        help|--help|-h)
            cmd_help
            ;;
        *)
            print_error "Comando desconocido: $command"
            echo "Usa './debugkit.sh help' para ver comandos disponibles"
            exit 1
            ;;
    esac
}

main "$@"
