#!/bin/bash
# ============================================
# PROYECTO FINAL: AutoDeploy Framework
# SOLUCIÓN COMPLETA
# Semana 8 - Proyectos Avanzados
# ============================================
#
# Uso: ./autodeploy.sh [comando] [opciones]
#
# Comandos:
#   init        Inicializar proyecto
#   build       Ejecutar pipeline de build
#   test        Ejecutar tests
#   deploy      Desplegar a servidor
#   status      Mostrar estado
#   help        Mostrar ayuda
#
# ============================================

set -euo pipefail

# ============================================
# CONFIGURACIÓN
# ============================================

readonly VERSION="1.0.0"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LIB_DIR="$SCRIPT_DIR/lib"
readonly CONFIG_DIR="$SCRIPT_DIR/config"
readonly BUILD_DIR="$SCRIPT_DIR/dist"
readonly TESTS_DIR="$SCRIPT_DIR/tests"

# Cargar librerías
for lib in "$LIB_DIR"/*.sh; do
    [[ -f "$lib" ]] && source "$lib"
done

# Cargar configuración
[[ -f "$CONFIG_DIR/default.conf" ]] && source "$CONFIG_DIR/default.conf"
[[ -f "$CONFIG_DIR/local.conf" ]] && source "$CONFIG_DIR/local.conf"

# ============================================
# COMANDOS
# ============================================

cmd_init() {
    log_info "Inicializando proyecto..."
    
    # Crear estructura de directorios
    local dirs=("bin" "lib" "config" "tests" "dist" "backups")
    for dir in "${dirs[@]}"; do
        if [[ ! -d "$SCRIPT_DIR/$dir" ]]; then
            mkdir -p "$SCRIPT_DIR/$dir"
            log_info "Creado: $dir/"
        fi
    done
    
    # Crear config local si no existe
    if [[ ! -f "$CONFIG_DIR/local.conf" ]]; then
        cat > "$CONFIG_DIR/local.conf" << 'EOF'
# Configuración local (no commitear)
# Sobreescribe valores de default.conf

# DEBUG=true
# DEPLOY_HOST=mi-servidor.com
EOF
        log_info "Creado: config/local.conf"
    fi
    
    # Instalar hooks si hay .git
    if [[ -d "$SCRIPT_DIR/../.git" ]]; then
        install_hooks
    fi
    
    log_info "✅ Proyecto inicializado"
}

cmd_build() {
    log_info "Ejecutando pipeline de build..."
    
    # Configurar stages
    pipeline_add_stage "validate"
    pipeline_add_stage "prepare"
    pipeline_add_stage "package"
    
    # Ejecutar pipeline
    pipeline_run
}

# Stages del build
stage_validate() {
    # Verificar sintaxis de todos los scripts
    local scripts
    scripts=$(find "$SCRIPT_DIR" -name "*.sh" -type f 2>/dev/null)
    
    for script in $scripts; do
        bash -n "$script" || return 1
    done
    return 0
}

stage_prepare() {
    # Limpiar y preparar directorio de build
    rm -rf "$BUILD_DIR"
    mkdir -p "$BUILD_DIR"
    return 0
}

stage_package() {
    # Copiar archivos al directorio de build
    cp -r "$SCRIPT_DIR/lib" "$BUILD_DIR/"
    cp -r "$SCRIPT_DIR/config" "$BUILD_DIR/"
    cp "$SCRIPT_DIR/autodeploy.sh" "$BUILD_DIR/"
    chmod +x "$BUILD_DIR/autodeploy.sh"
    return 0
}

cmd_test() {
    log_info "Ejecutando tests..."
    
    local test_files
    local passed=0
    local failed=0
    
    test_files=$(find "$TESTS_DIR" -name "test_*.sh" -type f 2>/dev/null || true)
    
    if [[ -z "$test_files" ]]; then
        log_warn "No se encontraron archivos de test"
        return 0
    fi
    
    for test_file in $test_files; do
        log_info "Running: $(basename "$test_file")"
        if bash "$test_file"; then
            ((passed++))
        else
            ((failed++))
        fi
    done
    
    echo ""
    log_info "Resultados: $passed passed, $failed failed"
    
    [[ $failed -eq 0 ]]
}

cmd_deploy() {
    local env="${1:-staging}"
    
    log_info "Desplegando a: $env"
    
    # Verificar que existe el build
    if [[ ! -d "$BUILD_DIR" ]]; then
        log_error "No existe build. Ejecuta primero: ./autodeploy.sh build"
        return 1
    fi
    
    # Cargar configuración del ambiente
    local env_config="$CONFIG_DIR/$env.conf"
    if [[ -f "$env_config" ]]; then
        source "$env_config"
    fi
    
    # Simular deploy (en producción usaría rsync real)
    log_info "Transfiriendo archivos..."
    sleep 1
    
    log_info "Ejecutando health check..."
    sleep 0.5
    
    # Notificar
    notify_console "DEPLOY COMPLETE" "Ambiente: $env"
    
    log_info "✅ Deploy completado"
}

cmd_status() {
    echo "╔════════════════════════════════════════════╗"
    echo "║         AUTODEPLOY STATUS                  ║"
    echo "╚════════════════════════════════════════════╝"
    echo ""
    echo "  Version:     $VERSION"
    echo "  Script Dir:  $SCRIPT_DIR"
    echo "  Build Dir:   $BUILD_DIR"
    echo ""
    
    # Estado del build
    if [[ -d "$BUILD_DIR" ]]; then
        local build_time
        build_time=$(stat -c %y "$BUILD_DIR" 2>/dev/null | cut -d. -f1)
        echo "  Build:       ✅ Exists ($build_time)"
    else
        echo "  Build:       ❌ Not found"
    fi
    
    # Estado de config
    if [[ -f "$CONFIG_DIR/local.conf" ]]; then
        echo "  Local conf:  ✅ Configured"
    else
        echo "  Local conf:  ⚠️  Using defaults"
    fi
    
    # Tests
    local test_count
    test_count=$(find "$TESTS_DIR" -name "test_*.sh" 2>/dev/null | wc -l)
    echo "  Tests:       $test_count files"
    
    echo ""
}

cmd_help() {
    cat << EOF
╔════════════════════════════════════════════════════════════╗
║              AutoDeploy Framework v$VERSION                   ║
╚════════════════════════════════════════════════════════════╝

USAGE:
    ./autodeploy.sh [command] [options]

COMMANDS:
    init              Initialize project structure
    build             Run build pipeline (validate → prepare → package)
    test              Run automated tests
    deploy [env]      Deploy to environment (default: staging)
    status            Show project status
    help              Show this help message

OPTIONS:
    -v, --version     Show version
    -h, --help        Show help

EXAMPLES:
    ./autodeploy.sh init
    ./autodeploy.sh build
    ./autodeploy.sh test
    ./autodeploy.sh deploy staging
    ./autodeploy.sh deploy production

CONFIGURATION:
    config/default.conf    Default configuration
    config/local.conf      Local overrides (gitignored)
    config/<env>.conf      Environment-specific config

For more information, see the README.md file.
EOF
}

install_hooks() {
    local hooks_dir="$SCRIPT_DIR/../.git/hooks"
    
    if [[ ! -d "$hooks_dir" ]]; then
        log_warn "No .git/hooks directory found"
        return 1
    fi
    
    # Pre-commit hook
    cat > "$hooks_dir/pre-commit" << 'HOOK'
#!/bin/bash
set -euo pipefail

echo "🔍 Running pre-commit checks..."

# Find shell scripts
files=$(git diff --cached --name-only --diff-filter=ACM | grep "\.sh$" || true)

if [[ -n "$files" ]]; then
    # Syntax check
    for file in $files; do
        if ! bash -n "$file"; then
            echo "❌ Syntax error in $file"
            exit 1
        fi
    done
    
    # ShellCheck if available
    if command -v shellcheck &>/dev/null; then
        shellcheck $files || exit 1
    fi
fi

echo "✅ Pre-commit passed"
HOOK
    
    chmod +x "$hooks_dir/pre-commit"
    log_info "Instalado: pre-commit hook"
}

# ============================================
# MAIN
# ============================================

main() {
    local command="${1:-help}"
    shift || true
    
    case "$command" in
        init)
            cmd_init "$@"
            ;;
        build)
            cmd_build "$@"
            ;;
        test)
            cmd_test "$@"
            ;;
        deploy)
            cmd_deploy "$@"
            ;;
        status)
            cmd_status "$@"
            ;;
        help|--help|-h)
            cmd_help
            ;;
        --version|-v)
            echo "AutoDeploy v$VERSION"
            ;;
        *)
            log_error "Comando desconocido: $command"
            echo "Usa './autodeploy.sh help' para ver comandos"
            exit 1
            ;;
    esac
}

main "$@"
