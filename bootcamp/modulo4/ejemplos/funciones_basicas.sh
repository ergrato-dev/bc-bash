#!/bin/bash
#=====================================================================
# FUNCIONES_BASICAS.SH
# Ejemplos fundamentales de funciones en Bash
#=====================================================================

set -euo pipefail

echo "=== FUNCIONES BÁSICAS EN BASH ==="

echo -e "\n=== DEFINICIÓN Y SINTAXIS ==="

# Función simple sin parámetros
saludo_simple() {
    echo "¡Hola desde una función!"
}

# Función con la palabra clave 'function' (opcional)
function saludo_formal() {
    echo "Saludos formales desde una función"
}

# Ejecutar las funciones
echo "Llamando funciones básicas:"
saludo_simple
saludo_formal

echo -e "\n=== FUNCIONES CON PARÁMETROS ==="

# Función con un parámetro
saludar_persona() {
    local nombre=$1
    echo "¡Hola, $nombre! Bienvenido al Bootcamp Bash."
}

# Función con múltiples parámetros
presentar_persona() {
    local nombre=$1
    local edad=$2
    local ciudad=$3
    
    echo "Nombre: $nombre"
    echo "Edad: $edad años"
    echo "Ciudad: $ciudad"
}

# Función con parámetros opcionales
saludar_con_titulo() {
    local nombre=$1
    local titulo=${2:-""}  # Parámetro opcional con valor por defecto
    
    if [[ -n $titulo ]]; then
        echo "¡Hola, $titulo $nombre!"
    else
        echo "¡Hola, $nombre!"
    fi
}

echo "Funciones con parámetros:"
saludar_persona "Ana"
echo ""
presentar_persona "Carlos" "25" "Madrid"
echo ""
saludar_con_titulo "María"
saludar_con_titulo "Juan" "Dr."

echo -e "\n=== VARIABLES LOCALES VS GLOBALES ==="

# Variable global
variable_global="Soy global"

demostrar_scope() {
    local variable_local="Soy local"
    variable_global="Modificada en función"
    
    echo "Dentro de la función:"
    echo "  Variable local: $variable_local"
    echo "  Variable global: $variable_global"
}

echo "Antes de llamar la función:"
echo "  Variable global: $variable_global"

demostrar_scope

echo "Después de llamar la función:"
echo "  Variable global: $variable_global"
# echo "  Variable local: $variable_local"  # Esto causaría error

echo -e "\n=== VALORES DE RETORNO ==="

# Función que retorna un código de salida
es_numero() {
    local input=$1
    if [[ $input =~ ^[0-9]+$ ]]; then
        return 0  # true
    else
        return 1  # false
    fi
}

# Función que retorna un valor via echo
obtener_cuadrado() {
    local numero=$1
    local resultado=$((numero * numero))
    echo $resultado
}

# Función que retorna múltiples valores
obtener_estadisticas() {
    local numero=$1
    local cuadrado=$((numero * numero))
    local cubo=$((numero * numero * numero))
    
    echo "$cuadrado $cubo"
}

echo "Demostrando valores de retorno:"

# Usando código de salida
if es_numero "42"; then
    echo "✅ '42' es un número"
else
    echo "❌ '42' no es un número"
fi

if es_numero "abc"; then
    echo "✅ 'abc' es un número"
else
    echo "❌ 'abc' no es un número"
fi

# Capturando valor de retorno
numero=7
cuadrado=$(obtener_cuadrado $numero)
echo "El cuadrado de $numero es $cuadrado"

# Capturando múltiples valores
read -r cuadrado_5 cubo_5 <<< "$(obtener_estadisticas 5)"
echo "Para el número 5: cuadrado=$cuadrado_5, cubo=$cubo_5"

echo -e "\n=== FUNCIONES CON VALIDACIÓN ==="

# Función robusta con validación de parámetros
dividir() {
    # Verificar número de parámetros
    if [[ $# -ne 2 ]]; then
        echo "Error: Se requieren exactamente 2 parámetros"
        echo "Uso: dividir <dividendo> <divisor>"
        return 1
    fi
    
    local dividendo=$1
    local divisor=$2
    
    # Verificar que son números
    if ! es_numero "$dividendo" || ! es_numero "$divisor"; then
        echo "Error: Ambos parámetros deben ser números"
        return 1
    fi
    
    # Verificar división por cero
    if [[ $divisor -eq 0 ]]; then
        echo "Error: División por cero no permitida"
        return 1
    fi
    
    local resultado=$((dividendo / divisor))
    echo "Resultado: $dividendo ÷ $divisor = $resultado"
    return 0
}

echo "Función con validación:"
dividir 20 4
dividir 15 0  # Error: división por cero
dividir 10    # Error: parámetros insuficientes
dividir "abc" "def"  # Error: no son números

echo -e "\n=== FUNCIONES CON ARRAYS ==="

# Función que procesa un array (pasando por referencia)
mostrar_array() {
    local -n array_ref=$1  # Referencia al array
    local nombre_array=$2
    
    echo "Array '$nombre_array':"
    echo "  Elementos: ${array_ref[*]}"
    echo "  Cantidad: ${#array_ref[@]}"
    echo "  Índices: ${!array_ref[*]}"
}

# Función que modifica un array
agregar_elemento() {
    local -n array_ref=$1
    local nuevo_elemento=$2
    
    array_ref+=("$nuevo_elemento")
    echo "Elemento '$nuevo_elemento' agregado al array"
}

# Demostrar funciones con arrays
colores=("rojo" "verde" "azul")
mostrar_array colores "colores"

agregar_elemento colores "amarillo"
mostrar_array colores "colores (después de agregar)"

echo -e "\n=== FUNCIONES MATEMÁTICAS ==="

# Función para calcular factorial
factorial() {
    local n=$1
    
    if [[ $n -lt 0 ]]; then
        echo "Error: No se puede calcular factorial de número negativo"
        return 1
    fi
    
    if [[ $n -eq 0 || $n -eq 1 ]]; then
        echo 1
    else
        local resultado=1
        for ((i=2; i<=n; i++)); do
            resultado=$((resultado * i))
        done
        echo $resultado
    fi
}

# Función para verificar si un número es primo
es_primo() {
    local numero=$1
    
    if [[ $numero -lt 2 ]]; then
        return 1
    fi
    
    for ((i=2; i*i<=numero; i++)); do
        if [[ $((numero % i)) -eq 0 ]]; then
            return 1
        fi
    done
    
    return 0
}

echo "Funciones matemáticas:"
echo "Factorial de 5: $(factorial 5)"
echo "Factorial de 0: $(factorial 0)"

for num in {2..10}; do
    if es_primo $num; then
        echo "$num es primo"
    fi
done

echo -e "\n=== FUNCIONES DE UTILIDAD ==="

# Función para timestamp
timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

# Función para logging
log_message() {
    local nivel=$1
    local mensaje=$2
    echo "[$(timestamp)] [$nivel] $mensaje"
}

# Función para validar email (básico)
validar_email() {
    local email=$1
    if [[ $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        return 0
    else
        return 1
    fi
}

echo "Funciones de utilidad:"
log_message "INFO" "Sistema iniciado"
log_message "ERROR" "Archivo no encontrado"

if validar_email "usuario@ejemplo.com"; then
    echo "✅ Email válido"
else
    echo "❌ Email inválido"
fi

if validar_email "email-invalido"; then
    echo "✅ Email válido"
else
    echo "❌ Email inválido"
fi

echo -e "\n=== INFORMACIÓN DE FUNCIONES ==="

echo "Funciones definidas en este script:"
declare -F | grep -E "(saludo|presentar|dividir|factorial)" | awk '{print "  " $3}'

echo -e "\nDefinición de la función 'factorial':"
declare -f factorial

echo -e "\n=== FIN DEL EJEMPLO ==="
