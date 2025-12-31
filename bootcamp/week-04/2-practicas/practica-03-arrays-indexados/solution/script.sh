#!/bin/bash
# ============================================
# Práctica 3: Arrays Indexados - SOLUCIÓN
# Semana 4 - Funciones y Arrays
# ============================================

echo "=== Práctica 3: Arrays Indexados ==="
echo ""

# ============================================
# PASO 1: Crear Arrays
# ============================================
echo "--- Paso 1: Crear Arrays ---"

# Forma 1: Asignación directa
frutas=("manzana" "pera" "uva" "naranja")

# Forma 2: Con declare
declare -a numeros=(10 20 30 40 50)

# Forma 3: Índices explícitos
colores[0]="rojo"
colores[1]="verde"
colores[2]="azul"

echo "Arrays creados ✓"

echo ""

# ============================================
# PASO 2: Acceder a Elementos
# ============================================
echo "--- Paso 2: Acceder a Elementos ---"

frutas=("manzana" "pera" "uva" "naranja" "limón")

echo "Primer elemento: ${frutas[0]}"
echo "Tercer elemento: ${frutas[2]}"
echo "Último elemento: ${frutas[-1]}"
echo "Penúltimo elemento: ${frutas[-2]}"

echo ""

# ============================================
# PASO 3: Todos los Elementos
# ============================================
echo "--- Paso 3: Información del Array ---"

frutas=("manzana" "pera" "uva" "naranja")

echo "Todos los elementos: ${frutas[@]}"
echo "Cantidad de elementos: ${#frutas[@]}"
echo "Índices disponibles: ${!frutas[@]}"
echo "Longitud del primer elemento: ${#frutas[0]} caracteres"

echo ""

# ============================================
# PASO 4: Agregar Elementos
# ============================================
echo "--- Paso 4: Agregar Elementos ---"

animales=("perro" "gato")
echo "Original: ${animales[@]}"

animales+=("pájaro")
echo "Después de agregar pájaro: ${animales[@]}"

animales+=("pez" "tortuga")
echo "Después de agregar pez y tortuga: ${animales[@]}"

echo "Total: ${#animales[@]} animales"

echo ""

# ============================================
# PASO 5: Modificar y Eliminar
# ============================================
echo "--- Paso 5: Modificar y Eliminar ---"

lenguajes=("Python" "JavaScript" "Ruby" "PHP" "Go")
echo "Original: ${lenguajes[@]}"

lenguajes[2]="Rust"
echo "Después de cambiar Ruby por Rust: ${lenguajes[@]}"

unset 'lenguajes[3]'
echo "Después de eliminar PHP: ${lenguajes[@]}"
echo "Índices ahora: ${!lenguajes[@]}"

echo ""

# ============================================
# PASO 6: Iterar con For
# ============================================
echo "--- Paso 6: Iterar con For ---"

ciudades=("Madrid" "Barcelona" "Valencia" "Sevilla")

echo "Lista de ciudades:"
for ciudad in "${ciudades[@]}"; do
    echo "  → $ciudad"
done

echo ""

# ============================================
# PASO 7: Iterar con Índices
# ============================================
echo "--- Paso 7: Iterar con Índices ---"

tareas=("Comprar pan" "Llamar al médico" "Estudiar Bash" "Hacer ejercicio")

echo "Lista de tareas:"
for i in "${!tareas[@]}"; do
    echo "  [$((i+1))] ${tareas[$i]}"
done

echo ""

# ============================================
# PASO 8: Slice (Subcadena)
# ============================================
echo "--- Paso 8: Slice ---"

meses=("Ene" "Feb" "Mar" "Abr" "May" "Jun" "Jul" "Ago" "Sep" "Oct" "Nov" "Dic")

echo "Todos los meses: ${meses[@]}"
echo "Primer trimestre: ${meses[@]:0:3}"
echo "Segundo trimestre: ${meses[@]:3:3}"
echo "Últimos 3 meses: ${meses[@]: -3}"

echo ""
echo "=== Práctica 3 Completada ==="
