#!/bin/bash
#=====================================================================
# VARIABLES_BASICAS.SH
# Ejemplos básicos de variables en Bash
#=====================================================================

set -euo pipefail

echo "=== VARIABLES BÁSICAS EN BASH ==="

# Variables simples
nombre="Bootcamp Bash"
version=3
activo=true

echo "Nombre del curso: $nombre"
echo "Módulo número: $version"
echo "Estado activo: $activo"

echo -e "\n=== VARIABLES DE ENTORNO ==="

# Variables de entorno del sistema
echo "Usuario actual: $USER"
echo "Directorio home: $HOME"
echo "Path actual: $PWD"
echo "Shell actual: $SHELL"

# Crear variable de entorno personalizada
export MI_VARIABLE="Valor de ejemplo"
echo "Mi variable personalizada: $MI_VARIABLE"

echo -e "\n=== EXPANSIÓN DE PARÁMETROS ==="

# Formas de referenciar variables
echo "Forma simple: $nombre"
echo "Forma explícita: ${nombre}"
echo "Con texto adicional: ${nombre}_modificado"

# Longitud de variables
echo "Longitud del nombre: ${#nombre} caracteres"

# Transformaciones
texto="Hola Mundo"
echo "Texto original: $texto"
echo "En mayúsculas: ${texto^^}"
echo "En minúsculas: ${texto,,}"
echo "Primera letra mayúscula: ${texto^}"

echo -e "\n=== VALORES POR DEFECTO ==="

# Variable no definida con valor por defecto
echo "Variable indefinida: ${VARIABLE_INDEFINIDA:-'valor por defecto'}"

# Variable vacía con valor por defecto
variable_vacia=""
echo "Variable vacía: ${variable_vacia:-'valor para vacía'}"

# Variable con valor
variable_con_valor="mi valor"
echo "Variable con valor: ${variable_con_valor:-'valor por defecto'}"

echo -e "\n=== VARIABLES ESPECIALES ==="

echo "Nombre del script: $0"
echo "PID del proceso: $$"

# Ejemplo con comando que falla
false
exit_code=$?
echo "Código de salida después de false: $exit_code"

# Ejemplo con comando exitoso
true
exit_code=$?
echo "Código de salida después de true: $exit_code"

echo -e "\n=== ARRAYS BÁSICOS ==="

# Array simple
frutas=("manzana" "banana" "naranja")
echo "Primera fruta: ${frutas[0]}"
echo "Segunda fruta: ${frutas[1]}"
echo "Todas las frutas: ${frutas[*]}"
echo "Número de frutas: ${#frutas[@]}"

echo -e "\n=== VARIABLES CALCULADAS ==="

# Operaciones aritméticas
numero1=10
numero2=5

suma=$((numero1 + numero2))
resta=$((numero1 - numero2))
multiplicacion=$((numero1 * numero2))
division=$((numero1 / numero2))

echo "Número 1: $numero1"
echo "Número 2: $numero2"
echo "Suma: $suma"
echo "Resta: $resta"
echo "Multiplicación: $multiplicacion"
echo "División: $division"

echo -e "\n=== VARIABLES DE SOLO LECTURA ==="

# Variable de solo lectura
readonly CONSTANTE="Este valor no puede cambiar"
echo "Constante: $CONSTANTE"

# Intentar cambiar resultaría en error:
# CONSTANTE="nuevo valor"  # Esto fallaría

echo -e "\n=== FIN DEL EJEMPLO ==="
