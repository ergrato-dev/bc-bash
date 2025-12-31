#!/bin/bash
# ============================================
# Práctica 2: Parámetros y Retorno - SOLUCIÓN
# Semana 4 - Funciones y Arrays
# ============================================

echo "=== Práctica 2: Parámetros y Retorno ==="
echo ""

# ============================================
# PASO 1: Parámetros Posicionales
# ============================================
echo "--- Paso 1: Parámetros Posicionales ---"

saludar_persona() {
    echo "Hola $1, bienvenido!"
}

saludar_persona "Juan"
saludar_persona "María"

echo ""

# ============================================
# PASO 2: Múltiples Parámetros
# ============================================
echo "--- Paso 2: Múltiples Parámetros ---"

presentar() {
    local nombre="$1"
    local edad="$2"
    local ciudad="$3"
    echo "Soy $nombre, tengo $edad años y vivo en $ciudad"
}

presentar "Ana" "25" "Madrid"
presentar "Carlos" "30" "Barcelona"

echo ""

# ============================================
# PASO 3: Valores por Defecto
# ============================================
echo "--- Paso 3: Valores por Defecto ---"

saludar_con_default() {
    local nombre="${1:-Invitado}"
    local saludo="${2:-Hola}"
    echo "$saludo, $nombre!"
}

saludar_con_default
saludar_con_default "Pedro"
saludar_con_default "Laura" "Buenos días"

echo ""

# ============================================
# PASO 4: Todos los Parámetros ($@ y $#)
# ============================================
echo "--- Paso 4: \$@ y \$# ---"

listar_argumentos() {
    echo "Recibí $# argumentos:"
    local contador=1
    for arg in "$@"; do
        echo "  [$contador] $arg"
        ((contador++))
    done
}

listar_argumentos "manzana" "pera" "naranja" "uva"

echo ""

# ============================================
# PASO 5: Return (Código de Salida)
# ============================================
echo "--- Paso 5: Return ---"

es_numero_par() {
    local num="$1"
    if (( num % 2 == 0 )); then
        return 0
    else
        return 1
    fi
}

for n in 2 5 8 11; do
    if es_numero_par "$n"; then
        echo "$n es par"
    else
        echo "$n es impar"
    fi
done

echo ""

# ============================================
# PASO 6: Echo para Retornar Valores
# ============================================
echo "--- Paso 6: Echo para Valores ---"

calcular_area() {
    local base="$1"
    local altura="$2"
    local area=$(( base * altura ))
    echo "$area"
}

resultado=$(calcular_area 5 3)
echo "Área del rectángulo: $resultado"
echo "Área del cuadrado: $(calcular_area 4 4)"

echo ""

# ============================================
# PASO 7: Exit Status ($?)
# ============================================
echo "--- Paso 7: Exit Status ---"

archivo_existe() {
    [[ -f "$1" ]]
}

archivo_existe "/etc/passwd"
echo "/etc/passwd existe? Exit status: $?"

archivo_existe "/archivo/inexistente"
echo "/archivo/inexistente existe? Exit status: $?"

echo ""

# ============================================
# PASO 8: Combinando Return y Echo
# ============================================
echo "--- Paso 8: Patrón Completo ---"

dividir() {
    local dividendo="$1"
    local divisor="$2"
    
    if [[ "$divisor" -eq 0 ]]; then
        echo "Error: división por cero"
        return 1
    fi
    
    echo $(( dividendo / divisor ))
    return 0
}

if resultado=$(dividir 20 4); then
    echo "20 / 4 = $resultado"
fi

if resultado=$(dividir 10 0); then
    echo "10 / 0 = $resultado"
else
    echo "La división falló: $resultado"
fi

echo ""
echo "=== Práctica 2 Completada ==="
