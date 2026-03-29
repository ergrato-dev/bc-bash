#!/bin/bash
# ============================================
# PROYECTO: Organizador de Archivos
# Semana 01 - Bootcamp Bash
# ============================================
# Descripción: Organiza archivos en carpetas
#              según su extensión/tipo
# ============================================

set -euo pipefail

# ============================================
# CONFIGURACIÓN
# ============================================

# Colores para output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Versión del script
readonly VERSION="1.0"

# ============================================
# VARIABLES GLOBALES
# ============================================

# Directorio a organizar (se establece desde argumentos)
TARGET_DIR=""

# Modo simulación (dry-run)
DRY_RUN=false

# Contadores
declare -A FILE_COUNTS

# ============================================
# FUNCIÓN: show_header
# Muestra el encabezado del programa
# ============================================
show_header() {
  echo "========================================"
  echo "  ORGANIZADOR DE ARCHIVOS v${VERSION}"
  echo "========================================"
  echo ""
}

# ============================================
# FUNCIÓN: show_help
# Muestra la ayuda del programa
# ============================================
show_help() {
  show_header
  echo "Uso: $0 [opciones] <directorio>"
  echo ""
  echo "Opciones:"
  echo "  -h, --help      Muestra esta ayuda"
  echo "  -d, --dry-run   Simula sin mover archivos"
  echo "  -v, --version   Muestra la versión"
  echo ""
  echo "Ejemplos:"
  echo "  $0 ~/Descargas"
  echo "  $0 --dry-run ~/Descargas"
  echo ""
}

# ============================================
# FUNCIÓN: show_version
# Muestra la versión del programa
# ============================================
show_version() {
  echo "Organizador de Archivos v${VERSION}"
}

# ============================================
# FUNCIÓN: error_exit
# Muestra error y termina el programa
# Parámetros:
#   $1 - Mensaje de error
# ============================================
error_exit() {
  echo -e "${RED}ERROR: $1${NC}" >&2
  exit 1
}

# ============================================
# FUNCIÓN: success_msg
# Muestra mensaje de éxito
# Parámetros:
#   $1 - Mensaje
# ============================================
success_msg() {
  echo -e "${GREEN}✓${NC} $1"
}

# ============================================
# FUNCIÓN: info_msg
# Muestra mensaje informativo
# Parámetros:
#   $1 - Mensaje
# ============================================
info_msg() {
  echo -e "${BLUE}→${NC} $1"
}

# ============================================
# FUNCIÓN: warn_msg
# Muestra mensaje de advertencia
# Parámetros:
#   $1 - Mensaje
# ============================================
warn_msg() {
  echo -e "${YELLOW}!${NC} $1"
}

# ============================================
# FUNCIÓN: validate_directory
# Valida que el directorio exista y sea accesible
# Parámetros:
#   $1 - Ruta del directorio
# Retorna:
#   0 si es válido, 1 si no
# ============================================
validate_directory() {
  local dir="$1"
  
  # TODO: Implementar validación
  # - Verificar que el argumento no esté vacío
  # - Verificar que el directorio exista (-d)
  # - Verificar que sea legible (-r)
  # - Verificar que sea escribible (-w)
  
  return 0
}

# ============================================
# FUNCIÓN: get_category
# Determina la categoría de un archivo por su extensión
# Parámetros:
#   $1 - Nombre del archivo
# Retorna:
#   Nombre de la categoría (echo)
# ============================================
get_category() {
  local filename="$1"
  
  # TODO: Implementar lógica de categorización
  # Obtener la extensión del archivo
  # Usar case o if para determinar categoría
  # Categorías: imagenes, documentos, videos, audio, codigo, comprimidos, otros
  
  echo "otros"
}

# ============================================
# FUNCIÓN: create_category_dirs
# Crea las carpetas de categorías
# ============================================
create_category_dirs() {
  echo "Creando carpetas de categorías..."
  
  # TODO: Implementar creación de carpetas
  # Crear: imagenes, documentos, videos, audio, codigo, comprimidos, otros
  # Usar mkdir -p para crear si no existe
  # Si DRY_RUN es true, solo mostrar lo que se haría
  
  echo ""
}

# ============================================
# FUNCIÓN: organize_files
# Organiza los archivos en sus categorías
# ============================================
organize_files() {
  echo "Organizando archivos..."
  
  # TODO: Implementar organización
  # Recorrer archivos en TARGET_DIR
  # Para cada archivo:
  #   - Obtener su categoría con get_category
  #   - Mover a la carpeta correspondiente
  #   - Incrementar contador FILE_COUNTS
  # Si DRY_RUN es true, solo mostrar lo que se haría
  
  echo ""
}

# ============================================
# FUNCIÓN: show_summary
# Muestra el resumen de archivos organizados
# ============================================
show_summary() {
  echo "========================================"
  echo "  RESUMEN"
  echo "========================================"
  
  # TODO: Implementar resumen
  # Mostrar conteo por cada categoría
  # Mostrar total de archivos organizados
  
  echo "----------------------------------------"
  echo ""
}

# ============================================
# FUNCIÓN: parse_arguments
# Procesa los argumentos de línea de comandos
# Parámetros:
#   $@ - Todos los argumentos
# ============================================
parse_arguments() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        show_help
        exit 0
        ;;
      -v|--version)
        show_version
        exit 0
        ;;
      -d|--dry-run)
        DRY_RUN=true
        shift
        ;;
      -*)
        error_exit "Opción desconocida: $1"
        ;;
      *)
        TARGET_DIR="$1"
        shift
        ;;
    esac
  done
}

# ============================================
# FUNCIÓN: main
# Función principal del programa
# ============================================
main() {
  # Procesar argumentos
  parse_arguments "$@"
  
  # Mostrar encabezado
  show_header
  
  # Validar que se proporcionó un directorio
  if [[ -z "$TARGET_DIR" ]]; then
    error_exit "Debe especificar un directorio. Use --help para más información."
  fi
  
  # Validar directorio
  validate_directory "$TARGET_DIR" || error_exit "Directorio inválido: $TARGET_DIR"
  
  echo "Directorio: $TARGET_DIR"
  
  if [[ "$DRY_RUN" == true ]]; then
    warn_msg "Modo simulación (dry-run) - No se moverán archivos"
  fi
  
  echo "Analizando archivos..."
  echo ""
  
  # Crear carpetas
  create_category_dirs
  
  # Organizar archivos
  organize_files
  
  # Mostrar resumen
  show_summary
  
  success_msg "Organización completada!"
}

# ============================================
# EJECUCIÓN
# ============================================
main "$@"
