#!/bin/bash
# ============================================
# PRÁCTICA 03: Comandos Básicos de Archivos
# ============================================
# Instrucciones: Descomenta las líneas de código
# según avanzas en cada paso del README.md
# ============================================

echo "================================================"
echo "  PRÁCTICA 03: Comandos Básicos de Archivos"
echo "================================================"
echo ""

# Crear directorio temporal para pruebas
test_dir=$(mktemp -d)
echo "Directorio de pruebas: $test_dir"
cd "$test_dir" || exit 1
echo ""

# ============================================
# PASO 1: Crear Archivos (touch y echo)
# ============================================
echo "--- Paso 1: Crear Archivos ---"

# Crear archivos vacíos y con contenido
# Descomenta las siguientes líneas:
# # Crear archivo vacío
# touch vacio.txt
# echo "Archivo vacío creado:"
# ls -l vacio.txt
# 
# # Crear archivo con contenido (sobrescribir)
# echo "Primera línea" > contenido.txt
# echo "Contenido inicial:"
# cat contenido.txt
# 
# # Añadir contenido (append)
# echo "Segunda línea" >> contenido.txt
# echo "Tercera línea" >> contenido.txt
# echo "Después de añadir:"
# cat contenido.txt
# 
# # Crear múltiples archivos
# touch file{1..5}.txt
# echo ""
# echo "Archivos creados con expansión {}:"
# ls -la file*.txt

echo ""

# ============================================
# PASO 2: Copiar Archivos (cp)
# ============================================
echo "--- Paso 2: Copiar Archivos ---"

# Practicar con cp
# Descomenta las siguientes líneas:
# # Crear archivo origen
# echo "Archivo original" > original.txt
# 
# # Copia simple
# cp original.txt copia.txt
# echo "Después de 'cp original.txt copia.txt':"
# ls -l original.txt copia.txt
# 
# # Copiar a directorio
# mkdir destino
# cp original.txt destino/
# echo ""
# echo "Después de 'cp original.txt destino/':"
# ls -l destino/
# 
# # Copiar directorio recursivamente
# mkdir -p fuente/sub
# touch fuente/archivo1.txt fuente/sub/archivo2.txt
# cp -r fuente/ copia_fuente/
# echo ""
# echo "Después de 'cp -r fuente/ copia_fuente/':"
# ls -laR copia_fuente/

echo ""

# ============================================
# PASO 3: Mover y Renombrar (mv)
# ============================================
echo "--- Paso 3: Mover y Renombrar ---"

# Practicar con mv
# Descomenta las siguientes líneas:
# # Crear archivo para mover
# echo "Contenido para mover" > para_mover.txt
# 
# # Renombrar archivo
# mv para_mover.txt renombrado.txt
# echo "Después de 'mv para_mover.txt renombrado.txt':"
# ls -l renombrado.txt
# ls -l para_mover.txt 2>&1 || echo "(ya no existe para_mover.txt)"
# 
# # Mover a directorio
# mkdir carpeta_mv
# mv renombrado.txt carpeta_mv/
# echo ""
# echo "Después de mover a carpeta_mv/:"
# ls -l carpeta_mv/
# 
# # Mover múltiples archivos con patrón
# touch a.log b.log c.log
# mkdir logs
# mv *.log logs/
# echo ""
# echo "Después de 'mv *.log logs/':"
# ls -l logs/

echo ""

# ============================================
# PASO 4: Eliminar (rm y rmdir)
# ============================================
echo "--- Paso 4: Eliminar Archivos ---"

# Practicar eliminación
# Descomenta las siguientes líneas:
# # Crear archivos para eliminar
# touch borrar1.txt borrar2.txt
# mkdir carpeta_vacia
# mkdir -p carpeta_contenido/sub
# touch carpeta_contenido/archivo.txt
# 
# echo "Antes de eliminar:"
# ls -la borrar*.txt carpeta_vacia carpeta_contenido 2>/dev/null
# 
# # Eliminar archivo simple
# rm borrar1.txt
# echo ""
# echo "Después de 'rm borrar1.txt':"
# ls -la borrar*.txt 2>/dev/null || echo "(borrar1.txt eliminado)"
# 
# # Eliminar directorio vacío
# rmdir carpeta_vacia
# echo "Después de 'rmdir carpeta_vacia': directorio eliminado"
# 
# # Eliminar directorio con contenido
# rm -r carpeta_contenido
# echo "Después de 'rm -r carpeta_contenido': directorio y contenido eliminados"

echo ""

# ============================================
# PASO 5: Ver Contenido (cat, head, tail)
# ============================================
echo "--- Paso 5: Ver Contenido de Archivos ---"

# Crear archivo con varias líneas para practicar
# Descomenta las siguientes líneas:
# # Crear archivo de prueba con 20 líneas
# for i in {1..20}; do
#   echo "Línea número $i - contenido de ejemplo" >> largo.txt
# done
# 
# echo "Archivo con 20 líneas creado"
# echo ""
# 
# # Ver todo con cat
# echo "cat largo.txt (primeras 5 líneas):"
# cat largo.txt | head -5
# echo "..."
# 
# # Ver con números de línea
# echo ""
# echo "cat -n largo.txt (primeras 5):"
# cat -n largo.txt | head -5
# 
# # Ver primeras líneas
# echo ""
# echo "head -n 3 largo.txt:"
# head -n 3 largo.txt
# 
# # Ver últimas líneas
# echo ""
# echo "tail -n 3 largo.txt:"
# tail -n 3 largo.txt

echo ""

# ============================================
# PASO 6: Buscar Archivos (find)
# ============================================
echo "--- Paso 6: Buscar Archivos ---"

# Crear estructura para buscar
# Descomenta las siguientes líneas:
# # Crear estructura de prueba
# mkdir -p proyecto/{src,docs,tests}
# touch proyecto/src/main.sh
# touch proyecto/src/utils.sh
# touch proyecto/docs/readme.md
# touch proyecto/tests/test.sh
# touch proyecto/config.txt
# 
# echo "Estructura creada:"
# find proyecto -type f
# 
# # Buscar por nombre
# echo ""
# echo "find proyecto -name '*.sh':"
# find proyecto -name "*.sh"
# 
# # Buscar por tipo
# echo ""
# echo "find proyecto -type d (solo directorios):"
# find proyecto -type d
# 
# # Buscar y ejecutar comando
# echo ""
# echo "Archivos .sh con sus permisos:"
# find proyecto -name "*.sh" -exec ls -l {} \;

echo ""

# ============================================
# LIMPIEZA
# ============================================
echo "--- Limpieza ---"
cd /
rm -rf "$test_dir"
echo "Directorio de pruebas eliminado"

echo ""
echo "================================================"
echo "  FIN DE LA PRÁCTICA 03"
echo "================================================"
