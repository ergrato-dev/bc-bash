#!/bin/bash
# ============================================
# Práctica 2: Parámetros y Retorno
# Semana 4 - Funciones y Arrays
# ============================================

echo "=== Práctica 2: Parámetros y Retorno ==="
echo ""

# ============================================
# PASO 1: Parámetros Posicionales
# ============================================
echo "--- Paso 1: Parámetros Posicionales ---"

# $1 es el primer argumento, $2 el segundo, etc.
# Descomenta las siguientes líneas:

# saludar_persona() {
#     echo "Hola $1, bienvenido!"
# }
# 
# saludar_persona "Juan"
# saludar_persona "María"

echo ""

# ============================================
# PASO 2: Múltiples Parámetros
# ============================================
echo "--- Paso 2: Múltiples Parámetros ---"

# Puedes usar $1, $2, $3... para múltiples argumentos
# Descomenta las siguientes líneas:

# presentar() {
#     local nombre="$1"
#     local edad="$2"
#     local ciudad="$3"
#     echo "Soy $nombre, tengo $edad años y vivo en $ciudad"
# }
# 
# presentar "Ana" "25" "Madrid"
# presentar "Carlos" "30" "Barcelona"

echo ""

# ============================================
# PASO 3: Valores por Defecto
# ============================================
echo "--- Paso 3: Valores por Defecto ---"

# ${param:-default} usa default si param está vacío
# Descomenta las siguientes líneas:

# saludar_con_default() {
#     local nombre="${1:-Invitado}"
#     local saludo="${2:-Hola}"
#     echo "$saludo, $nombre!"
# }
# 
# saludar_con_default                    # Usa ambos defaults
# saludar_con_default "Pedro"            # Usa default de saludo
# saludar_con_default "Laura" "Buenos días"  # Sin defaults

echo ""

# ============================================
# PASO 4: Todos los Parámetros ($@ y $#)
# ============================================
echo "--- Paso 4: \$@ y \$# ---"

# $# = cantidad de argumentos
# $@ = todos los argumentos como lista
# Descomenta las siguientes líneas:

# listar_argumentos() {
#     echo "Recibí $# argumentos:"
#     local contador=1
#     for arg in "$@"; do
#         echo "  [$contador] $arg"
#         ((contador++))
#     done
# }
# 
# listar_argumentos "manzana" "pera" "naranja" "uva"

echo ""

# ============================================
# PASO 5: Return (Código de Salida)
# ============================================
echo "--- Paso 5: Return ---"

# return devuelve un código 0-255 (0=éxito)
# Se usa en condicionales
# Descomenta las siguientes líneas:

# es_numero_par() {
#     local num="$1"
#     if (( num % 2 == 0 )); then
#         return 0  # éxito = es par
#     else
#         return 1  # fallo = es impar
#     fi
# }
# 
# for n in 2 5 8 11; do
#     if es_numero_par "$n"; then
#         echo "$n es par"
#     else
#         echo "$n es impar"
#     fi
# done

echo ""

# ============================================
# PASO 6: Echo para Retornar Valores
# ============================================
echo "--- Paso 6: Echo para Valores ---"

# Para retornar datos, usa echo y captura con $()
# Descomenta las siguientes líneas:

# calcular_area() {
#     local base="$1"
#     local altura="$2"
#     local area=$(( base * altura ))
#     echo "$area"  # "retorna" el valor
# }
# 
# resultado=$(calcular_area 5 3)
# echo "Área del rectángulo: $resultado"
# 
# # También se puede usar directamente
# echo "Área del cuadrado: $(calcular_area 4 4)"

echo ""

# ============================================
# PASO 7: Exit Status ($?)
# ============================================
echo "--- Paso 7: Exit Status ---"

# $? contiene el código de salida del último comando
# Descomenta las siguientes líneas:

# archivo_existe() {
#     [[ -f "$1" ]]
# }
# 
# archivo_existe "/etc/passwd"
# echo "/etc/passwd existe? Exit status: $?"
# 
# archivo_existe "/archivo/inexistente"
# echo "/archivo/inexistente existe? Exit status: $?"

echo ""

# ============================================
# PASO 8: Combinando Return y Echo
# ============================================
echo "--- Paso 8: Patrón Completo ---"

# Patrón profesional: echo para datos, return para estado
# Descomenta las siguientes líneas:

# dividir() {
#     local dividendo="$1"
#     local divisor="$2"
#     
#     # Validar división por cero
#     if [[ "$divisor" -eq 0 ]]; then
#         echo "Error: división por cero"
#         return 1
#     fi
#     
#     echo $(( dividendo / divisor ))
#     return 0
# }
# 
# # Caso exitoso
# if resultado=$(dividir 20 4); then
#     echo "20 / 4 = $resultado"
# fi
# 
# # Caso con error
# if resultado=$(dividir 10 0); then
#     echo "10 / 0 = $resultado"
# else
#     echo "La división falló: $resultado"
# fi

echo ""
echo "=== Práctica 2 Completada ==="
