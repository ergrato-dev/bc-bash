#!/bin/bash
# Ejemplo: Operaciones Básicas con Archivos
# Módulo: 5
# Objetivo: Demostrar operaciones CRUD con archivos y directorios

set -euo pipefail

# Colores para output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Función para mostrar títulos
show_title() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

# Función para mostrar comandos
show_command() {
    echo -e "${YELLOW}$ $1${NC}"
    eval "$1"
}

# Función para mostrar resultados
show_result() {
    echo -e "${GREEN}✓ $1${NC}"
}

echo -e "${BLUE}🛠️  MÓDULO 5: OPERACIONES CON ARCHIVOS${NC}"
echo "=================================================="

# 1. CREACIÓN DE ARCHIVOS
show_title "1. CREACIÓN DE ARCHIVOS"

# Crear archivos con diferentes métodos
show_command "touch archivo_vacio.txt"
show_result "Archivo vacío creado"

show_command "echo 'Contenido básico' > archivo_contenido.txt"
show_result "Archivo con contenido creado"

show_command "cat > archivo_multilinea.txt << EOF
Primera línea
Segunda línea
Tercera línea
EOF"
show_result "Archivo multilínea creado"

# Mostrar archivos creados
show_command "ls -la archivo_*.txt"

echo

# 2. LECTURA DE ARCHIVOS
show_title "2. LECTURA DE ARCHIVOS"

show_command "cat archivo_contenido.txt"
show_command "head -2 archivo_multilinea.txt"
show_command "tail -1 archivo_multilinea.txt"

echo

# 3. COPIA DE ARCHIVOS
show_title "3. COPIA DE ARCHIVOS"

show_command "cp archivo_contenido.txt copia_archivo.txt"
show_result "Archivo copiado"

show_command "cp -v archivo_multilinea.txt backup_archivo.txt"
show_result "Archivo copiado con confirmación"

# Verificar copias
show_command "ls -la *archivo*.txt"

echo

# 4. MOVIMIENTO Y RENOMBRADO
show_title "4. MOVIMIENTO Y RENOMBRADO"

# Crear directorio temporal
show_command "mkdir -p temp_files"
show_result "Directorio temporal creado"

# Mover archivo
show_command "mv copia_archivo.txt temp_files/"
show_result "Archivo movido"

# Renombrar archivo
show_command "mv backup_archivo.txt archivo_respaldo.txt"
show_result "Archivo renombrado"

# Verificar operaciones
show_command "ls -la temp_files/"
show_command "ls -la archivo_respaldo.txt"

echo

# 5. BÚSQUEDA DE ARCHIVOS
show_title "5. BÚSQUEDA DE ARCHIVOS"

show_command "find . -name '*.txt' -type f"
show_command "find . -name 'archivo*' -exec ls -la {} +"

echo

# 6. PROPIEDADES DE ARCHIVOS
show_title "6. PROPIEDADES DE ARCHIVOS"

show_command "ls -la archivo_contenido.txt"
show_command "stat archivo_contenido.txt"
show_command "file archivo_contenido.txt"

echo

# 7. COMPARACIÓN DE ARCHIVOS
show_title "7. COMPARACIÓN DE ARCHIVOS"

# Crear archivo similar para comparar
echo "Contenido básico modificado" > archivo_modificado.txt

show_command "diff archivo_contenido.txt archivo_modificado.txt"
show_command "cmp archivo_contenido.txt archivo_multilinea.txt; echo \"Exit code: \$?\""

echo

# 8. COMPRESIÓN Y ARCHIVOS
show_title "8. COMPRESIÓN Y ARCHIVOS"

show_command "tar -czf archivos_ejemplo.tar.gz archivo_*.txt"
show_result "Archivos comprimidos"

show_command "tar -tzf archivos_ejemplo.tar.gz"
show_result "Contenido del archivo comprimido"

echo

# 9. TRABAJO CON DIRECTORIOS
show_title "9. TRABAJO CON DIRECTORIOS"

show_command "mkdir -p estructura/{docs,scripts,data}"
show_result "Estructura de directorios creada"

show_command "tree estructura/ 2>/dev/null || find estructura -type d"

# Copiar archivos a la estructura
show_command "cp archivo_*.txt estructura/docs/"
show_result "Archivos copiados a la estructura"

show_command "ls -la estructura/docs/"

echo

# 10. LIMPIEZA CONTROLADA
show_title "10. LIMPIEZA CONTROLADA"

# Función de limpieza segura
cleanup_demo() {
    echo -e "${YELLOW}Limpiando archivos de demostración...${NC}"
    
    # Confirmar antes de eliminar
    read -p "¿Eliminar archivos de demostración? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -f archivo_*.txt
        rm -f archivos_ejemplo.tar.gz
        rm -rf temp_files/
        rm -rf estructura/
        show_result "Limpieza completada"
    else
        echo -e "${BLUE}Archivos conservados para inspección${NC}"
    fi
}

echo -e "${YELLOW}Demostración completada. Archivos creados para inspección.${NC}"
echo -e "${BLUE}Para limpiar ejecuta: cleanup_demo${NC}"

# Resumen final
echo
show_title "RESUMEN DE OPERACIONES"
echo "✓ Creación de archivos (touch, echo, cat)"
echo "✓ Lectura de archivos (cat, head, tail)"
echo "✓ Copia de archivos (cp)"
echo "✓ Movimiento y renombrado (mv)"
echo "✓ Búsqueda de archivos (find)"
echo "✓ Propiedades de archivos (ls, stat, file)"
echo "✓ Comparación de archivos (diff, cmp)"
echo "✓ Compresión de archivos (tar)"
echo "✓ Trabajo con directorios (mkdir, tree)"
echo "✓ Limpieza controlada (rm, rmdir)"

echo
echo -e "${GREEN}🎉 ¡Operaciones con archivos completadas!${NC}"
