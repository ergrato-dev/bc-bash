#!/bin/bash
# Ejemplo 04: Operaciones Básicas con Archivos
# Descripción: Crear, leer, modificar archivos

# Directorio de trabajo temporal
TEMP_DIR="./temp_ejemplos"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR" || exit 1

echo "=== Trabajando en: $PWD ==="

# === Crear archivos ===
echo -e "\n=== Creando Archivos ==="

# Archivo vacío
touch archivo_vacio.txt
echo "✓ Creado: archivo_vacio.txt"

# Archivo con contenido
echo "Hola Mundo" > saludo.txt
echo "✓ Creado: saludo.txt con contenido"

# Agregar al archivo existente
echo "Segunda línea" >> saludo.txt
echo "✓ Agregada línea a saludo.txt"

# Crear múltiples líneas
cat > datos.txt << EOF
Línea 1
Línea 2
Línea 3
EOF
echo "✓ Creado: datos.txt con múltiples líneas"

# === Leer archivos ===
echo -e "\n=== Leyendo Archivos ==="

echo "Contenido de saludo.txt:"
cat saludo.txt

echo -e "\nPrimeras 2 líneas de datos.txt:"
head -n 2 datos.txt

echo -e "\nÚltima línea de datos.txt:"
tail -n 1 datos.txt

# === Copiar archivos ===
echo -e "\n=== Copiando Archivos ==="
cp saludo.txt saludo_backup.txt
echo "✓ Copiado: saludo.txt → saludo_backup.txt"

# === Mover/Renombrar archivos ===
echo -e "\n=== Moviendo/Renombrando ==="
mv saludo_backup.txt saludo_copia.txt
echo "✓ Renombrado: saludo_backup.txt → saludo_copia.txt"

# === Información de archivos ===
echo -e "\n=== Información de Archivos ==="
for archivo in *.txt; do
    tamaño=$(wc -c < "$archivo")
    lineas=$(wc -l < "$archivo")
    echo "$archivo: $tamaño bytes, $lineas líneas"
done

# === Listar archivos ===
echo -e "\n=== Listado de Archivos ==="
ls -lh *.txt

# Limpiar
cd ..
echo -e "\n=== Limpieza ==="
echo "Para limpiar: rm -rf $TEMP_DIR"
