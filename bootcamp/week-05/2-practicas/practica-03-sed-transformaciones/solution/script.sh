#!/bin/bash
# ============================================
# PRACTICA 3: sed Transformaciones
# Semana 5: Procesamiento de Texto
# SOLUCION COMPLETA
# ============================================

TMPDIR="/tmp/sed_practice_$$"
mkdir -p "$TMPDIR"

# ============================================
# PASO 1: Crear Datos de Prueba
# ============================================
echo "--- Paso 1: Crear Datos de Prueba ---"

cat > "$TMPDIR/config.conf" << 'EOF'
# Archivo de configuracion
server_host=localhost
server_port=8080
database_host=localhost
database_port=5432
database_name=myapp

# Opciones de debug
debug_mode=false
log_level=info
EOF

cat > "$TMPDIR/texto.txt" << 'EOF'
La palabra foo aparece aqui foo y aqui foo tambien.
Esta linea no tiene esa palabra.
foo al inicio y foo al final foo
Linea con FOO en mayusculas.

Una linea con espacios extra.
# Este es un comentario
# Otro comentario
Linea normal.
EOF

echo "Archivos creados en $TMPDIR"
echo ""
echo "=== config.conf ==="
cat "$TMPDIR/config.conf"
echo ""
echo "=== texto.txt ==="
cat "$TMPDIR/texto.txt"

echo ""

# ============================================
# PASO 2: Sustitucion Basica
# ============================================
echo "--- Paso 2: Sustitucion Basica ---"

echo "Reemplazar primera 'foo' por 'BAR':"
sed 's/foo/BAR/' "$TMPDIR/texto.txt"

echo ""
echo "Reemplazar TODAS las 'foo' por 'BAR' (flag g):"
sed 's/foo/BAR/g' "$TMPDIR/texto.txt"

echo ""

# ============================================
# PASO 3: Flags de Sustitucion
# ============================================
echo "--- Paso 3: Flags de Sustitucion ---"

echo "Reemplazar 'foo' ignorando caso (flag i):"
sed 's/foo/REPLACED/gi' "$TMPDIR/texto.txt"

echo ""
echo "Reemplazar solo la 2da ocurrencia de 'foo':"
sed 's/foo/SECOND/2' "$TMPDIR/texto.txt"

echo ""

# ============================================
# PASO 4: Eliminar Lineas
# ============================================
echo "--- Paso 4: Eliminar Lineas ---"

echo "Eliminar lineas que contienen 'foo':"
sed '/foo/d' "$TMPDIR/texto.txt"

echo ""
echo "Eliminar lineas vacias:"
sed '/^$/d' "$TMPDIR/texto.txt"

echo ""
echo "Eliminar comentarios (lineas que empiezan con #):"
sed '/^#/d' "$TMPDIR/config.conf"

echo ""

# ============================================
# PASO 5: Rangos de Lineas
# ============================================
echo "--- Paso 5: Rangos de Lineas ---"

echo "Imprimir solo lineas 2-4:"
sed -n '2,4p' "$TMPDIR/texto.txt"

echo ""
echo "Eliminar lineas 1-3:"
sed '1,3d' "$TMPDIR/texto.txt"

echo ""
echo "Desde linea 1 hasta encontrar 'comentario':"
sed -n '1,/comentario/p' "$TMPDIR/texto.txt"

echo ""

# ============================================
# PASO 6: Multiples Comandos
# ============================================
echo "--- Paso 6: Multiples Comandos ---"

echo "Multiples sustituciones con -e:"
sed -e 's/localhost/127.0.0.1/g' -e 's/8080/9000/' "$TMPDIR/config.conf"

echo ""
echo "Mismo resultado con punto y coma:"
sed 's/localhost/127.0.0.1/g; s/8080/9000/' "$TMPDIR/config.conf"

echo ""
echo "Eliminar comentarios Y sustituir localhost:"
sed '/^#/d; s/localhost/127.0.0.1/g' "$TMPDIR/config.conf"

echo ""

# ============================================
# PASO 7: Edicion In-Place
# ============================================
echo "--- Paso 7: Edicion In-Place ---"

cp "$TMPDIR/config.conf" "$TMPDIR/config_edit.conf"

echo "Archivo antes de -i:"
cat "$TMPDIR/config_edit.conf" | head -5

sed -i 's/localhost/192.168.1.1/g' "$TMPDIR/config_edit.conf"

echo ""
echo "Archivo despues de -i:"
cat "$TMPDIR/config_edit.conf" | head -5

cp "$TMPDIR/config.conf" "$TMPDIR/config_backup.conf"
sed -i.bak 's/8080/3000/' "$TMPDIR/config_backup.conf"

echo ""
echo "Archivo .bak creado automaticamente:"
ls -la "$TMPDIR"/config_backup*

echo ""

# ============================================
# PASO 8: Transformaciones Avanzadas
# ============================================
echo "--- Paso 8: Transformaciones Avanzadas ---"

echo "Agregar prefijo ENV_ a variables:"
sed 's/^\([a-z_]*\)=/ENV_\1=/' "$TMPDIR/config.conf" | grep -v "^#"

echo ""
echo "Convertir key=value a export KEY=value:"
sed 's/^\([a-z_]*\)=\(.*\)/export \U\1\E=\2/' "$TMPDIR/config.conf" | grep -v "^#"

echo ""
echo "Encerrar valores en comillas:"
sed 's/=\(.*\)$/="\1"/' "$TMPDIR/config.conf" | grep -v "^#"

echo ""

rm -rf "$TMPDIR"

echo "=== Practica 3 completada ==="
