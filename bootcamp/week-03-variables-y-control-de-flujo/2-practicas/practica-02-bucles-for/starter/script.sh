#!/bin/bash
# ============================================
# Práctica 02: Bucles for
# Semana 3 - Variables y Control de Flujo
# ============================================
# Instrucciones: Descomenta las líneas indicadas
# en cada paso para aprender bucles for.
# ============================================

echo "=== Práctica 02: Bucles for ==="
echo ""

# ============================================
# PASO 1: Iteración sobre Lista Simple
# ============================================
echo "--- Paso 1: Lista Simple ---"

# Descomenta las siguientes líneas:
# for fruta in manzana naranja plátano; do
#     echo "Fruta: $fruta"
# done

echo ""

# ============================================
# PASO 2: Rangos Numéricos
# ============================================
echo "--- Paso 2: Rangos ---"

# Descomenta las siguientes líneas:
# for num in {1..5}; do
#     echo "Número: $num"
# done

echo ""

# ============================================
# PASO 3: Rangos con Incremento
# ============================================
echo "--- Paso 3: Rangos con Incremento ---"

# Descomenta las siguientes líneas:
# for num in {0..10..2}; do
#     echo "Par: $num"
# done

echo ""

# ============================================
# PASO 4: Estilo C
# ============================================
echo "--- Paso 4: Estilo C ---"

# Descomenta las siguientes líneas:
# for ((i=0; i<5; i++)); do
#     echo "Índice: $i"
# done

echo ""

# ============================================
# PASO 5: Iteración sobre Arrays
# ============================================
echo "--- Paso 5: Arrays ---"

colores=("rojo" "verde" "azul" "amarillo")

# Descomenta las siguientes líneas:
# for color in "${colores[@]}"; do
#     echo "Color: $color"
# done

echo ""

# ============================================
# PASO 6: Índices de Array
# ============================================
echo "--- Paso 6: Índices de Array ---"

# Descomenta las siguientes líneas:
# for i in "${!colores[@]}"; do
#     echo "[$i] = ${colores[$i]}"
# done

echo ""

# ============================================
# PASO 7: Iteración sobre Archivos
# ============================================
echo "--- Paso 7: Archivos ---"

# Descomenta las siguientes líneas:
# contador=0
# for archivo in /etc/*.conf; do
#     if [[ -f "$archivo" ]]; then
#         echo "Config: $(basename "$archivo")"
#         ((contador++))
#         # Limitar a 5 archivos para el ejemplo
#         [[ $contador -ge 5 ]] && break
#     fi
# done
# echo "Total: $contador archivos .conf encontrados"

echo ""

# ============================================
# PASO 8: break - Salir del Bucle
# ============================================
echo "--- Paso 8: break ---"

# Descomenta las siguientes líneas:
# for num in {1..10}; do
#     if [[ $num -eq 5 ]]; then
#         echo "¡Encontrado 5! Saliendo del bucle..."
#         break
#     fi
#     echo "Número: $num"
# done

echo ""

# ============================================
# PASO 9: continue - Saltar Iteración
# ============================================
echo "--- Paso 9: continue ---"

# Descomenta las siguientes líneas:
# for num in {1..5}; do
#     if [[ $num -eq 3 ]]; then
#         echo "  (Saltando 3...)"
#         continue
#     fi
#     echo "Procesando: $num"
# done

echo ""

# ============================================
# PASO 10: Bucles Anidados
# ============================================
echo "--- Paso 10: Bucles Anidados ---"

# Descomenta las siguientes líneas:
# echo "Tabla de coordenadas:"
# for fila in {1..3}; do
#     for col in {1..3}; do
#         echo -n "[$fila,$col] "
#     done
#     echo ""  # Nueva línea al final de cada fila
# done

echo ""
echo "✅ ¡Práctica completada!"
