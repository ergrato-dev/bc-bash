#!/bin/bash
# ============================================
# Práctica 4: Arrays Asociativos - SOLUCIÓN
# Semana 4 - Funciones y Arrays
# ============================================

echo "=== Práctica 4: Arrays Asociativos ==="
echo ""

# ============================================
# PASO 1: Declarar Array Asociativo
# ============================================
echo "--- Paso 1: Declarar con declare -A ---"

declare -A persona
persona[nombre]="María"
persona[edad]=28
persona[ciudad]="Madrid"
persona[profesion]="Desarrolladora"

echo "Array asociativo 'persona' creado ✓"

echo ""

# ============================================
# PASO 2: Sintaxis Compacta
# ============================================
echo "--- Paso 2: Sintaxis Compacta ---"

declare -A colores=(
    [rojo]="#FF0000"
    [verde]="#00FF00"
    [azul]="#0000FF"
    [amarillo]="#FFFF00"
)

echo "Array 'colores' creado con ${#colores[@]} elementos"

echo ""

# ============================================
# PASO 3: Acceder a Valores
# ============================================
echo "--- Paso 3: Acceder a Valores ---"

declare -A producto=(
    [nombre]="Laptop"
    [precio]=999
    [stock]=50
    [categoria]="Electrónica"
)

echo "Producto: ${producto[nombre]}"
echo "Precio: \$${producto[precio]}"
echo "Stock disponible: ${producto[stock]} unidades"
echo "Categoría: ${producto[categoria]}"

echo ""

# ============================================
# PASO 4: Obtener Claves y Valores
# ============================================
echo "--- Paso 4: Claves y Valores ---"

declare -A paises=(
    [ES]="España"
    [FR]="Francia"
    [DE]="Alemania"
    [IT]="Italia"
)

echo "Códigos (claves): ${!paises[@]}"
echo "Nombres (valores): ${paises[@]}"
echo "Cantidad de países: ${#paises[@]}"

echo ""

# ============================================
# PASO 5: Iterar Array Asociativo
# ============================================
echo "--- Paso 5: Iterar ---"

declare -A capitales=(
    [España]="Madrid"
    [Francia]="París"
    [Italia]="Roma"
    [Portugal]="Lisboa"
)

echo "Capitales europeas:"
for pais in "${!capitales[@]}"; do
    echo "  $pais → ${capitales[$pais]}"
done

echo ""

# ============================================
# PASO 6: Verificar si Existe Clave
# ============================================
echo "--- Paso 6: Verificar Existencia ---"

declare -A usuario=(
    [nombre]="Carlos"
    [email]="carlos@mail.com"
)

if [[ -v usuario[nombre] ]]; then
    echo "✓ Clave 'nombre' existe: ${usuario[nombre]}"
fi

if [[ -v usuario[telefono] ]]; then
    echo "✓ Clave 'telefono' existe"
else
    echo "✗ Clave 'telefono' NO existe"
fi

echo ""

# ============================================
# PASO 7: Modificar y Eliminar
# ============================================
echo "--- Paso 7: Modificar y Eliminar ---"

declare -A config=(
    [debug]="false"
    [timeout]=30
    [temporal]="borrar"
)

echo "Original:"
for k in "${!config[@]}"; do echo "  $k=${config[$k]}"; done

config[debug]="true"
config[timeout]=60
unset 'config[temporal]'

echo "Modificado:"
for k in "${!config[@]}"; do echo "  $k=${config[$k]}"; done

echo ""

# ============================================
# PASO 8: Caso Práctico - Configuración
# ============================================
echo "--- Paso 8: Caso Práctico ---"

declare -A db_config=(
    [host]="localhost"
    [port]="5432"
    [database]="myapp"
    [user]="admin"
    [ssl]="true"
)

mostrar_config() {
    echo "╔══════════════════════════════╗"
    echo "║   Configuración de Base de   ║"
    echo "║          Datos               ║"
    echo "╠══════════════════════════════╣"
    for clave in host port database user ssl; do
        printf "║  %-10s: %-14s ║\n" "$clave" "${db_config[$clave]}"
    done
    echo "╚══════════════════════════════╝"
}

mostrar_config

echo ""
echo "=== Práctica 4 Completada ==="
