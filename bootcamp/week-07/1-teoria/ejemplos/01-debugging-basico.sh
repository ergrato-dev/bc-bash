#!/bin/bash
# Ejemplo 01: Debugging Básico
# Descripción: Técnicas para debuggear scripts

echo "=== Técnicas de Debugging ==="

# === 1. Modo Debug (-x) ===
echo -e "\n=== 1. Bash con -x (trace) ==="
echo "Activando trace para la siguiente sección..."

set -x  # Activar debug
variable="valor de prueba"
echo "Variable: $variable"
resultado=$((5 + 3))
echo "Resultado: $resultado"
set +x  # Desactivar debug

# === 2. PS4 personalizado ===
echo -e "\n=== 2. Trace personalizado con PS4 ==="
PS4='DEBUG [${LINENO}]: '
set -x
echo "Línea con número"
fecha=$(date)
set +x

# === 3. Función de debug ===
echo -e "\n=== 3. Función debug personalizada ==="

DEBUG=true

debug() {
    if [ "$DEBUG" = true ]; then
        echo "[DEBUG $(date +%H:%M:%S)] $*" >&2
    fi
}

debug "Iniciando proceso..."
valor=42
debug "Valor asignado: $valor"
debug "Proceso completado"

# === 4. Verificar códigos de salida ===
echo -e "\n=== 4. Verificar códigos de salida ==="

comando_exitoso() {
    return 0
}

comando_fallido() {
    return 1
}

if comando_exitoso; then
    echo "✓ Comando exitoso (código: $?)"
fi

if ! comando_fallido; then
    echo "✗ Comando falló (código: $?)"
fi

# === 5. Trap para errores ===
echo -e "\n=== 5. Trap para capturar errores ==="

trap 'echo "Error en línea $LINENO"' ERR

# Función que falla
funcion_error() {
    false  # Esto genera un error
}

set +e  # Desactivar exit on error temporalmente
funcion_error
set -e

# Desactivar trap
trap - ERR

# === 6. Validación de variables ===
echo -e "\n=== 6. Validar variables ==="

validar_variable() {
    local var_name=$1
    local var_value=$2
    
    if [ -z "$var_value" ]; then
        echo "ERROR: Variable '$var_name' está vacía" >&2
        return 1
    fi
    echo "✓ Variable '$var_name' tiene valor: $var_value"
    return 0
}

validar_variable "usuario" "juan"
validar_variable "vacia" ""  # Esto generará error

echo -e "\n✓ Script de debugging completado"
