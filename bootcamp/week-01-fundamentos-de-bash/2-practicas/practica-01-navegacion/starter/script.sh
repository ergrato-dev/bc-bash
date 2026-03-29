#!/bin/bash
# ============================================
# PRÁCTICA 01: Navegación del Sistema de Archivos
# ============================================
# Instrucciones: Descomenta las líneas de código
# según avanzas en cada paso del README.md
# ============================================

echo "================================================"
echo "  PRÁCTICA 01: Navegación del Sistema"
echo "================================================"
echo ""

# ============================================
# PASO 1: Conocer tu Ubicación (pwd)
# ============================================
echo "--- Paso 1: Comando pwd ---"

# El comando pwd muestra el directorio actual
# Descomenta las siguientes líneas:
# current_dir=$(pwd)
# echo "Directorio actual: $current_dir"

echo ""

# ============================================
# PASO 2: Listar Contenidos (ls)
# ============================================
echo "--- Paso 2: Comando ls ---"

# Diferentes formas de listar contenidos
# Descomenta las siguientes líneas:
# echo "Listado simple de /tmp:"
# ls /tmp
# echo ""
# echo "Listado detallado de /tmp:"
# ls -l /tmp
# echo ""
# echo "Listado con archivos ocultos del home:"
# ls -la ~

echo ""

# ============================================
# PASO 3: Cambiar de Directorio (cd)
# ============================================
echo "--- Paso 3: Comando cd ---"

# Guardar directorio original para volver después
# Descomenta las siguientes líneas:
# original_dir=$(pwd)
# echo "Directorio original: $original_dir"
# 
# # Ir al home
# cd ~
# echo "Después de 'cd ~': $(pwd)"
# 
# # Ir a /tmp
# cd /tmp
# echo "Después de 'cd /tmp': $(pwd)"
# 
# # Volver al original
# cd "$original_dir"
# echo "De vuelta en: $(pwd)"

echo ""

# ============================================
# PASO 4: Rutas Absolutas vs Relativas
# ============================================
echo "--- Paso 4: Rutas Absolutas vs Relativas ---"

# Demostración de tipos de rutas
# Descomenta las siguientes líneas:
# echo "Ruta absoluta a etc:"
# ls -la /etc/hostname 2>/dev/null || echo "(archivo no encontrado)"
# 
# echo ""
# echo "Usando ruta relativa desde home:"
# cd ~
# # .bashrc está en el home (ruta relativa)
# ls -la .bashrc 2>/dev/null || ls -la .bash_profile 2>/dev/null || echo "(archivo de config no encontrado)"

echo ""

# ============================================
# PASO 5: Crear Estructura de Prueba
# ============================================
echo "--- Paso 5: Crear y Navegar Estructura ---"

# Crear estructura de directorios para practicar
# Descomenta las siguientes líneas:
# test_dir=~/practica-navegacion-test
# 
# # Crear estructura anidada
# mkdir -p "$test_dir/nivel1/nivel2/nivel3"
# echo "Estructura creada en: $test_dir"
# 
# # Mostrar estructura con tree o ls -R
# echo ""
# echo "Contenido (recursivo):"
# ls -R "$test_dir"
# 
# # Navegar por la estructura
# cd "$test_dir"
# echo ""
# echo "En: $(pwd)"
# cd nivel1/nivel2
# echo "Después de 'cd nivel1/nivel2': $(pwd)"
# cd ../..
# echo "Después de 'cd ../..': $(pwd)"
# 
# # Limpiar
# rm -rf "$test_dir"
# echo ""
# echo "Estructura de prueba eliminada"

echo ""
echo "================================================"
echo "  FIN DE LA PRÁCTICA 01"
echo "================================================"
