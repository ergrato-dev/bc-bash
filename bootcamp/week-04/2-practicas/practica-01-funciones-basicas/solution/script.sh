#!/bin/bash
# ============================================
# Práctica 1: Funciones Básicas - SOLUCIÓN
# Semana 4 - Funciones y Arrays
# ============================================

echo "=== Práctica 1: Funciones Básicas ==="
echo ""

# ============================================
# PASO 1: Tu Primera Función
# ============================================
echo "--- Paso 1: Tu Primera Función ---"

saludar() {
    echo "¡Hola desde mi primera función!"
}
saludar

echo ""

# ============================================
# PASO 2: Función con Mensaje Personalizado
# ============================================
echo "--- Paso 2: Información del Sistema ---"

mostrar_info() {
    echo "=== Información del Sistema ==="
    echo "Usuario: $USER"
    echo "Directorio: $PWD"
    echo "Shell: $SHELL"
    echo "=============================="
}
mostrar_info

echo ""

# ============================================
# PASO 3: Variables Locales
# ============================================
echo "--- Paso 3: Variables Locales ---"

calcular() {
    local resultado=42
    local mensaje="El resultado es"
    echo "$mensaje: $resultado"
}
calcular
echo "Fuera de la función, \$resultado no existe: '$resultado'"

echo ""

# ============================================
# PASO 4: Diferencia entre Local y Global
# ============================================
echo "--- Paso 4: Local vs Global ---"

variable_global="Soy global desde el inicio"

funcion_variables() {
    local var_local="Soy local"
    var_sin_local="Soy global (creada en función)"
    echo "Dentro - Local: $var_local"
    echo "Dentro - Sin local: $var_sin_local"
}

echo "Antes de llamar función:"
echo "  Global inicial: $variable_global"

funcion_variables

echo "Después de llamar función:"
echo "  Variable local: '$var_local' (vacía, no existe)"
echo "  Variable sin local: '$var_sin_local' (existe)"

echo ""

# ============================================
# PASO 5: Múltiples Funciones
# ============================================
echo "--- Paso 5: Múltiples Funciones ---"

inicio() {
    echo "[1] Iniciando proceso..."
}

proceso() {
    echo "[2] Ejecutando proceso..."
}

fin() {
    echo "[3] Proceso finalizado"
}

inicio
proceso
fin

echo ""

# ============================================
# PASO 6: Funciones que Llaman Otras Funciones
# ============================================
echo "--- Paso 6: Funciones Anidadas ---"

validar_entrada() {
    echo "  → Validando entrada..."
}

procesar_datos() {
    echo "  → Procesando datos..."
}

generar_salida() {
    echo "  → Generando salida..."
}

ejecutar_pipeline() {
    echo "Ejecutando pipeline completo:"
    validar_entrada
    procesar_datos
    generar_salida
    echo "Pipeline completado ✓"
}

ejecutar_pipeline

echo ""

# ============================================
# PASO 7: Orden de Definición
# ============================================
echo "--- Paso 7: Orden de Definición ---"

funcion_definida_primero() {
    echo "Esta función fue definida antes de llamarla ✓"
}

funcion_definida_primero

echo ""

# ============================================
# PASO 8: Documentar Funciones
# ============================================
echo "--- Paso 8: Funciones Documentadas ---"

# ----------------------------------------
# Muestra un banner de bienvenida
# Uso: mostrar_bienvenida
# ----------------------------------------
mostrar_bienvenida() {
    echo "╔════════════════════════════════╗"
    echo "║   Bienvenido al Sistema v1.0   ║"
    echo "║   Fecha: $(date +%Y-%m-%d)        ║"
    echo "╚════════════════════════════════╝"
}

mostrar_bienvenida

echo ""
echo "=== Práctica 1 Completada ==="
