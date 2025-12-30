#!/bin/bash
# Ejemplo 05: Permisos de Archivos
# Descripción: Entender y modificar permisos

# Crear directorio de prueba
TEMP_DIR="./temp_permisos"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR" || exit 1

echo "=== Trabajando con Permisos ==="

# Crear archivo de prueba
echo "Script de prueba" > script_test.sh

# === Mostrar permisos ===
echo -e "\n=== Permisos Iniciales ==="
ls -l script_test.sh

# === Hacer ejecutable ===
echo -e "\n=== Hacer Ejecutable ==="
chmod +x script_test.sh
echo "✓ Agregado permiso de ejecución"
ls -l script_test.sh

# === Permisos numéricos ===
echo -e "\n=== Permisos Numéricos ==="

# 755: rwxr-xr-x (dueño: rwx, grupo: r-x, otros: r-x)
chmod 755 script_test.sh
echo "chmod 755 (rwxr-xr-x):"
ls -l script_test.sh

# 644: rw-r--r-- (dueño: rw-, grupo: r--, otros: r--)
chmod 644 script_test.sh
echo -e "\nchmod 644 (rw-r--r--):"
ls -l script_test.sh

# 600: rw------- (dueño: rw-, grupo: ---, otros: ---)
chmod 600 script_test.sh
echo -e "\nchmod 600 (rw-------):"
ls -l script_test.sh

# === Permisos simbólicos ===
echo -e "\n=== Permisos Simbólicos ==="

# Agregar ejecución al dueño
chmod u+x script_test.sh
echo "chmod u+x (usuario + ejecución):"
ls -l script_test.sh

# Agregar lectura al grupo
chmod g+r script_test.sh
echo -e "\nchmod g+r (grupo + lectura):"
ls -l script_test.sh

# Quitar todos los permisos a otros
chmod o-rwx script_test.sh
echo -e "\nchmod o-rwx (otros - todos):"
ls -l script_test.sh

# === Verificar permisos ===
echo -e "\n=== Verificar Permisos ==="

if [ -r script_test.sh ]; then
    echo "✓ El archivo es legible"
fi

if [ -w script_test.sh ]; then
    echo "✓ El archivo es escribible"
fi

if [ -x script_test.sh ]; then
    echo "✓ El archivo es ejecutable"
fi

# === Permisos comunes ===
echo -e "\n=== Permisos Comunes ==="
cat << EOF
755 (rwxr-xr-x) - Scripts ejecutables
644 (rw-r--r--) - Archivos de texto
600 (rw-------) - Archivos privados
777 (rwxrwxrwx) - Todos los permisos (NO recomendado)
700 (rwx------) - Solo dueño (privado)
EOF

# Limpiar
cd ..
echo -e "\n=== Limpieza ==="
echo "Para limpiar: rm -rf $TEMP_DIR"
