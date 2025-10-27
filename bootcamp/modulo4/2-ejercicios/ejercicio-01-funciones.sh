#!/bin/bash
# Ejercicio 01: Funciones Básicas y Avanzadas
# Módulo: 4 | Dificultad: Básica-Media
# Objetivo: Dominar funciones, parámetros, return values y scope

echo "🔧 Ejercicio 01: Funciones en Bash"
echo "==================================="
echo ""

# TAREA 1: Función simple sin parámetros
saludar() {
    echo "¡Hola desde una función!"
}

echo "📋 TAREA 1: Función simple"
# TU CÓDIGO: Llama a la función saludar


# TAREA 2: Función con parámetros
saludar_persona() {
    local nombre=$1
    echo "¡Hola, $nombre!"
}

echo ""
echo "📋 TAREA 2: Función con parámetros"
# TU CÓDIGO: Llama saludar_persona con tu nombre


# TAREA 3: Función con return
es_par() {
    local num=$1
    if [[ $((num % 2)) -eq 0 ]]; then
        return 0  # verdadero
    else
        return 1  # falso
    fi
}

echo ""
echo "📋 TAREA 3: Función con return value"
# TU CÓDIGO: Verifica si 10 es par usando es_par


# TAREA 4: Función que retorna string (con echo)
obtener_fecha() {
    echo "$(date '+%Y-%m-%d')"
}

echo ""
echo "📋 TAREA 4: Función que retorna string"
# TU CÓDIGO: fecha=$(obtener_fecha) y muestra


# TAREA 5: Función con múltiples parámetros
sumar() {
    local a=$1
    local b=$2
    echo $((a + b))
}

echo ""
echo "�� TAREA 5: Función con múltiples parámetros"
# TU CÓDIGO: resultado=$(sumar 5 3) y muestra


# TAREA 6: Función recursiva - factorial
factorial() {
    local n=$1
    if [[ $n -le 1 ]]; then
        echo 1
    else
        local prev=$(factorial $((n-1)))
        echo $((n * prev))
    fi
}

echo ""
echo "📋 TAREA 6: Recursión - Factorial"
# TU CÓDIGO: Calcula factorial de 5


echo ""
echo "✅ Ejercicio completado!"

: '
SOLUCIONES:

# TAREA 1
saludar

# TAREA 2  
saludar_persona "Juan"

# TAREA 3
if es_par 10; then
    echo "10 es par"
fi

# TAREA 4
fecha=$(obtener_fecha)
echo "Fecha: $fecha"

# TAREA 5
resultado=$(sumar 5 3)
echo "5 + 3 = $resultado"

# TAREA 6
fact=$(factorial 5)
echo "5! = $fact"
'
