#!/bin/bash
# ============================================
# PRÁCTICA 02: Gestión de Permisos
# ============================================
# Instrucciones: Descomenta las líneas de código
# según avanzas en cada paso del README.md
# ============================================

echo "================================================"
echo "  PRÁCTICA 02: Gestión de Permisos"
echo "================================================"
echo ""

# Crear directorio temporal para pruebas
test_dir=$(mktemp -d)
echo "Directorio de pruebas: $test_dir"
cd "$test_dir"
echo ""

# ============================================
# PASO 1: Interpretar Permisos (ls -l)
# ============================================
echo "--- Paso 1: Interpretar Permisos ---"

# Crear archivos de ejemplo
# Descomenta las siguientes líneas:
# touch archivo_normal.txt
# touch script_ejemplo.sh
# mkdir carpeta_ejemplo
# 
# echo "Permisos por defecto:"
# ls -la
# 
# echo ""
# echo "Interpretación:"
# echo "- archivo_normal.txt: archivo regular (-)"
# echo "- script_ejemplo.sh: archivo regular (-)"
# echo "- carpeta_ejemplo: directorio (d)"

echo ""

# ============================================
# PASO 2: Chmod con Notación Simbólica
# ============================================
echo "--- Paso 2: Notación Simbólica ---"

# Modificar permisos con letras
# Descomenta las siguientes líneas:
# # Añadir ejecución al usuario
# chmod u+x script_ejemplo.sh
# echo "Después de 'chmod u+x script_ejemplo.sh':"
# ls -l script_ejemplo.sh
# 
# # Añadir lectura a todos
# chmod a+r archivo_normal.txt
# echo "Después de 'chmod a+r archivo_normal.txt':"
# ls -l archivo_normal.txt
# 
# # Quitar escritura al grupo y otros
# chmod go-w archivo_normal.txt
# echo "Después de 'chmod go-w archivo_normal.txt':"
# ls -l archivo_normal.txt

echo ""

# ============================================
# PASO 3: Chmod con Notación Octal
# ============================================
echo "--- Paso 3: Notación Octal ---"

# Crear archivos para demostrar octal
# Descomenta las siguientes líneas:
# touch ejecutable.sh
# touch privado.txt
# touch publico.txt
# 
# # 755 = rwxr-xr-x (script ejecutable)
# chmod 755 ejecutable.sh
# echo "chmod 755 ejecutable.sh -> $(ls -l ejecutable.sh | awk '{print $1}')"
# 
# # 600 = rw------- (archivo privado)
# chmod 600 privado.txt
# echo "chmod 600 privado.txt -> $(ls -l privado.txt | awk '{print $1}')"
# 
# # 644 = rw-r--r-- (archivo normal)
# chmod 644 publico.txt
# echo "chmod 644 publico.txt -> $(ls -l publico.txt | awk '{print $1}')"

echo ""

# ============================================
# PASO 4: Permisos en Directorios
# ============================================
echo "--- Paso 4: Permisos en Directorios ---"

# Experimentar con permisos de directorios
# Descomenta las siguientes líneas:
# mkdir dir_normal
# mkdir dir_restringido
# touch dir_normal/archivo.txt
# touch dir_restringido/secreto.txt
# 
# # Directorio normal
# chmod 755 dir_normal
# echo "dir_normal (755):"
# ls -la dir_normal
# 
# # Directorio sin permiso de lectura
# chmod 711 dir_restringido
# echo ""
# echo "dir_restringido (711) - sin permiso de listar:"
# ls -la dir_restringido 2>&1 || echo "(Acceso denegado a listar)"
# # Pero sí podemos acceder si conocemos el nombre
# cat dir_restringido/secreto.txt 2>/dev/null && echo "Archivo accedido directamente"
# 
# # Restaurar para limpieza
# chmod 755 dir_restringido

echo ""

# ============================================
# PASO 5: Permisos Recursivos
# ============================================
echo "--- Paso 5: Permisos Recursivos ---"

# Aplicar permisos a estructura completa
# Descomenta las siguientes líneas:
# # Crear estructura
# mkdir -p proyecto/src proyecto/docs
# touch proyecto/src/main.sh
# touch proyecto/src/utils.sh
# touch proyecto/docs/readme.txt
# 
# echo "Estructura creada:"
# find proyecto -type f -o -type d | head -10
# 
# # Aplicar permisos recursivos
# chmod -R 755 proyecto/
# echo ""
# echo "Después de 'chmod -R 755 proyecto/':"
# ls -laR proyecto/
# 
# # Patrón común: 755 para dirs, 644 para archivos
# find proyecto/ -type d -exec chmod 755 {} \;
# find proyecto/ -type f -exec chmod 644 {} \;
# echo ""
# echo "Después de diferenciar archivos (644) y directorios (755):"
# ls -laR proyecto/

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
echo "  FIN DE LA PRÁCTICA 02"
echo "================================================"
