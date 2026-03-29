#!/bin/bash
# ============================================
# PRÁCTICA 01: Arquitectura Modular
# Semana 8 - Proyectos Avanzados
# ============================================

set -euo pipefail

# ============================================
# PASO 1: Estructura de Directorios
# ============================================
echo "--- Paso 1: Estructura de Directorios ---"

# Crear estructura de proyecto profesional
# Descomenta las siguientes líneas:
# PROJECT_DIR="./demo-project"
# mkdir -p "$PROJECT_DIR"/{bin,lib,config,tests}
# echo "✅ Estructura creada en $PROJECT_DIR"
# ls -la "$PROJECT_DIR"

echo ""

# ============================================
# PASO 2: Script Principal con Source
# ============================================
echo "--- Paso 2: Script Principal con Source ---"

# Variables para ubicar módulos
# Descomenta las siguientes líneas:
# SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# echo "Script ubicado en: $SCRIPT_DIR"
# # En proyecto real: LIB_DIR="$PROJECT_ROOT/lib"
# # source "$LIB_DIR/utils.sh"

echo ""

# ============================================
# PASO 3: Módulo de Utilidades
# ============================================
echo "--- Paso 3: Módulo de Utilidades ---"

# Funciones de utilidad reutilizables
# Descomenta las siguientes líneas:
# trim() {
#     local var="$*"
#     # Eliminar espacios al inicio
#     var="${var#"${var%%[![:space:]]*}"}"
#     # Eliminar espacios al final
#     var="${var%"${var##*[![:space:]]}"}"
#     echo "$var"
# }
# 
# # Probar trim
# original="   texto con espacios   "
# trimmed=$(trim "$original")
# echo "Original: '$original'"
# echo "Trimmed:  '$trimmed'"

echo ""

# ============================================
# PASO 4: Módulo de Logging
# ============================================
echo "--- Paso 4: Módulo de Logging ---"

# Sistema de logging con niveles
# Descomenta las siguientes líneas:
# readonly RED='\033[0;31m'
# readonly GREEN='\033[0;32m'
# readonly YELLOW='\033[0;33m'
# readonly NC='\033[0m'
# 
# log_info() {
#     echo -e "${GREEN}[INFO]${NC} $*"
# }
# 
# log_warn() {
#     echo -e "${YELLOW}[WARN]${NC} $*" >&2
# }
# 
# log_error() {
#     echo -e "${RED}[ERROR]${NC} $*" >&2
# }
# 
# # Probar logging
# log_info "Este es un mensaje informativo"
# log_warn "Este es un warning"
# log_error "Este es un error"

echo ""

# ============================================
# PASO 5: Carga de Configuración
# ============================================
echo "--- Paso 5: Carga de Configuración ---"

# Cargar configuración de archivos externos
# Descomenta las siguientes líneas:
# config_load() {
#     local config_file="$1"
#     if [[ -f "$config_file" ]]; then
#         echo "Cargando configuración: $config_file"
#         source "$config_file"
#         return 0
#     else
#         echo "Config no encontrada: $config_file" >&2
#         return 1
#     fi
# }
# 
# # Crear config de ejemplo
# CONFIG_FILE="/tmp/demo.conf"
# cat > "$CONFIG_FILE" << 'EOF'
# APP_NAME="MiApp"
# APP_VERSION="1.0.0"
# DEBUG_MODE=true
# EOF
# 
# # Cargar y usar
# config_load "$CONFIG_FILE"
# echo "App: $APP_NAME v$APP_VERSION"
# echo "Debug: $DEBUG_MODE"
# rm "$CONFIG_FILE"

echo ""

# ============================================
# PASO 6: Función Main con Guard
# ============================================
echo "--- Paso 6: Función Main con Guard ---"

# Patrón main + guard para scripts importables
# Descomenta las siguientes líneas:
# app_main() {
#     echo "=== Aplicación Principal ==="
#     echo "Argumentos recibidos: $#"
#     for arg in "$@"; do
#         echo "  - $arg"
#     done
#     echo "=========================="
# }
# 
# # Guard: solo ejecutar si es script principal
# # [[ "${BASH_SOURCE[0]}" == "$0" ]] && app_main "$@"
# 
# # Para demo, llamar directamente:
# app_main "arg1" "arg2" "arg3"

echo ""

# ============================================
# RESUMEN
# ============================================
echo "=== RESUMEN ==="
echo "✓ Estructura de carpetas: bin/, lib/, config/, tests/"
echo "✓ Source para importar módulos"
echo "✓ Funciones de utilidad reutilizables"
echo "✓ Sistema de logging con colores"
echo "✓ Carga de configuración externa"
echo "✓ Patrón main con guard"
