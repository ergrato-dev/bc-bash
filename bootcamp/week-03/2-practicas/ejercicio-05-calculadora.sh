#!/bin/bash
# Ejercicio 05: Calculadora Interactiva - Proyecto Integrador
# Semana: 3 | Dificultad: Avanzada
# Objetivo: Integrar todos los conceptos: condicionales, loops, case y validación

# ============================================================================
# INSTRUCCIONES
# ============================================================================
# Este es un proyecto completo que integra todo lo aprendido en la semana 3.
# Crearás una calculadora interactiva con menú, validación y manejo de errores.
#
# FUNCIONALIDADES REQUERIDAS:
# 1. Menú principal con opciones (suma, resta, multiplicación, división)
# 2. Operaciones avanzadas (potencia, raíz cuadrada, módulo)
# 3. Historial de operaciones
# 4. Validación de entrada (solo números)
# 5. Manejo de errores (división por cero)
# 6. Opción de salir
# 7. Modo batch (múltiples operaciones)
#
# CRITERIOS DE ÉXITO:
# ✓ Menú funcional con case
# ✓ Validación robusta de entrada
# ✓ Manejo apropiado de errores
# ✓ Código limpio y bien estructurado

set -euo pipefail

echo "🧮 Calculadora Interactiva Avanzada"
echo "===================================="
echo ""

# ============================================================================
# VARIABLES GLOBALES
# ============================================================================

declare -a historial=()
operaciones_realizadas=0

# ============================================================================
# FUNCIONES AUXILIARES
# ============================================================================

# Función: Validar si entrada es número
validar_numero() {
    local valor=$1
    # TU CÓDIGO AQUÍ:
    # Verificar si $valor es un número (entero o decimal)
    # Usar regex: ^-?[0-9]+(\.[0-9]+)?$
    # Retornar 0 si válido, 1 si inválido
    
    if [[ $valor =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
        return 0
    else
        return 1
    fi
}

# Función: Leer número con validación
leer_numero() {
    local prompt=$1
    local numero
    
    while true; do
        read -p "$prompt" numero
        
        # TU CÓDIGO AQUÍ:
        # Validar que numero sea válido usando validar_numero
        # Si es válido, hacer echo del número y return
        # Si no, mostrar error y volver a pedir
        
        if validar_numero "$numero"; then
            echo "$numero"
            return 0
        else
            echo "❌ Error: '$numero' no es un número válido" >&2
        fi
    done
}

# Función: Agregar al historial
agregar_historial() {
    local operacion=$1
    historial+=("$operacion")
    ((operaciones_realizadas++))
}

# Función: Mostrar historial
mostrar_historial() {
    echo ""
    echo "📜 Historial de Operaciones"
    echo "============================"
    
    # TU CÓDIGO AQUÍ:
    # Si historial está vacío, mostrar mensaje
    # Si no, iterar con for y mostrar cada operación numerada
    
    if [[ ${#historial[@]} -eq 0 ]]; then
        echo "No hay operaciones en el historial"
    else
        local i=1
        for op in "${historial[@]}"; do
            echo "$i. $op"
            ((i++))
        done
    fi
    echo ""
}

# ============================================================================
# OPERACIONES BÁSICAS
# ============================================================================

operacion_suma() {
    echo ""
    echo "➕ SUMA"
    echo "-------"
    
    # TU CÓDIGO AQUÍ:
    # Leer dos números usando leer_numero
    # Calcular suma
    # Mostrar resultado
    # Agregar al historial
    
    local num1
    local num2
    num1=$(leer_numero "Primer número: ")
    num2=$(leer_numero "Segundo número: ")
    
    local resultado
    resultado=$(echo "$num1 + $num2" | bc)
    
    echo "Resultado: $num1 + $num2 = $resultado"
    agregar_historial "$num1 + $num2 = $resultado"
}

operacion_resta() {
    echo ""
    echo "➖ RESTA"
    echo "--------"
    
    # TU CÓDIGO AQUÍ (similar a suma)
    local num1
    local num2
    num1=$(leer_numero "Primer número: ")
    num2=$(leer_numero "Segundo número: ")
    
    local resultado
    resultado=$(echo "$num1 - $num2" | bc)
    
    echo "Resultado: $num1 - $num2 = $resultado"
    agregar_historial "$num1 - $num2 = $resultado"
}

operacion_multiplicacion() {
    echo ""
    echo "✖️  MULTIPLICACIÓN"
    echo "-----------------"
    
    # TU CÓDIGO AQUÍ
    local num1
    local num2
    num1=$(leer_numero "Primer número: ")
    num2=$(leer_numero "Segundo número: ")
    
    local resultado
    resultado=$(echo "$num1 * $num2" | bc)
    
    echo "Resultado: $num1 × $num2 = $resultado"
    agregar_historial "$num1 × $num2 = $resultado"
}

operacion_division() {
    echo ""
    echo "➗ DIVISIÓN"
    echo "----------"
    
    # TU CÓDIGO AQUÍ:
    # IMPORTANTE: Validar que divisor no sea 0
    # Usar bc con scale para decimales
    
    local num1
    local num2
    num1=$(leer_numero "Dividendo: ")
    num2=$(leer_numero "Divisor: ")
    
    if [[ $(echo "$num2 == 0" | bc) -eq 1 ]]; then
        echo "❌ Error: No se puede dividir por cero"
        return 1
    fi
    
    local resultado
    resultado=$(echo "scale=4; $num1 / $num2" | bc)
    
    echo "Resultado: $num1 ÷ $num2 = $resultado"
    agregar_historial "$num1 ÷ $num2 = $resultado"
}

# ============================================================================
# OPERACIONES AVANZADAS
# ============================================================================

operacion_potencia() {
    echo ""
    echo "🔢 POTENCIA"
    echo "-----------"
    
    # TU CÓDIGO AQUÍ:
    # base^exponente usando bc o $(())
    
    local base
    local exp
    base=$(leer_numero "Base: ")
    exp=$(leer_numero "Exponente: ")
    
    local resultado
    resultado=$(echo "$base ^ $exp" | bc)
    
    echo "Resultado: $base ^ $exp = $resultado"
    agregar_historial "$base ^ $exp = $resultado"
}

operacion_raiz() {
    echo ""
    echo "√ RAÍZ CUADRADA"
    echo "---------------"
    
    # TU CÓDIGO AQUÍ:
    # Validar que número sea positivo
    # Calcular raíz con bc: sqrt()
    
    local num
    num=$(leer_numero "Número: ")
    
    if [[ $(echo "$num < 0" | bc) -eq 1 ]]; then
        echo "❌ Error: No se puede calcular raíz de número negativo"
        return 1
    fi
    
    local resultado
    resultado=$(echo "scale=4; sqrt($num)" | bc)
    
    echo "Resultado: √$num = $resultado"
    agregar_historial "√$num = $resultado"
}

operacion_modulo() {
    echo ""
    echo "📐 MÓDULO (Resto de división)"
    echo "-----------------------------"
    
    # TU CÓDIGO AQUÍ:
    # num1 % num2
    
    local num1
    local num2
    num1=$(leer_numero "Primer número: ")
    num2=$(leer_numero "Segundo número: ")
    
    if [[ $(echo "$num2 == 0" | bc) -eq 1 ]]; then
        echo "❌ Error: No se puede calcular módulo por cero"
        return 1
    fi
    
    local resultado
    resultado=$(echo "$num1 % $num2" | bc)
    
    echo "Resultado: $num1 mod $num2 = $resultado"
    agregar_historial "$num1 mod $num2 = $resultado"
}

# ============================================================================
# MENÚ PRINCIPAL
# ============================================================================

mostrar_menu() {
    echo ""
    echo "╔════════════════════════════════════╗"
    echo "║     CALCULADORA INTERACTIVA        ║"
    echo "╠════════════════════════════════════╣"
    echo "║  OPERACIONES BÁSICAS               ║"
    echo "║  1. ➕ Suma                         ║"
    echo "║  2. ➖ Resta                        ║"
    echo "║  3. ✖️  Multiplicación              ║"
    echo "║  4. ➗ División                     ║"
    echo "║                                    ║"
    echo "║  OPERACIONES AVANZADAS             ║"
    echo "║  5. 🔢 Potencia                     ║"
    echo "║  6. √ Raíz Cuadrada                ║"
    echo "║  7. 📐 Módulo                       ║"
    echo "║                                    ║"
    echo "║  OTRAS OPCIONES                    ║"
    echo "║  8. 📜 Ver Historial                ║"
    echo "║  9. 🗑️  Limpiar Historial           ║"
    echo "║  0. 🚪 Salir                        ║"
    echo "╚════════════════════════════════════╝"
    echo ""
    echo "Operaciones realizadas: $operaciones_realizadas"
    echo ""
}

# ============================================================================
# FUNCIÓN PRINCIPAL
# ============================================================================

main() {
    local opcion
    
    # TU CÓDIGO AQUÍ:
    # Loop while infinito
    # Mostrar menú
    # Leer opción
    # case para ejecutar función correspondiente
    # Pausar después de cada operación (read -p)
    
    while true; do
        mostrar_menu
        read -p "Selecciona una opción: " opcion
        
        case $opcion in
            1)
                operacion_suma
                read -p "Presiona ENTER para continuar..."
                ;;
            2)
                operacion_resta
                read -p "Presiona ENTER para continuar..."
                ;;
            3)
                operacion_multiplicacion
                read -p "Presiona ENTER para continuar..."
                ;;
            4)
                operacion_division
                read -p "Presiona ENTER para continuar..."
                ;;
            5)
                operacion_potencia
                read -p "Presiona ENTER para continuar..."
                ;;
            6)
                operacion_raiz
                read -p "Presiona ENTER para continuar..."
                ;;
            7)
                operacion_modulo
                read -p "Presiona ENTER para continuar..."
                ;;
            8)
                mostrar_historial
                read -p "Presiona ENTER para continuar..."
                ;;
            9)
                historial=()
                operaciones_realizadas=0
                echo "✅ Historial limpiado"
                read -p "Presiona ENTER para continuar..."
                ;;
            0)
                echo ""
                echo "👋 ¡Gracias por usar la calculadora!"
                echo "Total de operaciones realizadas: $operaciones_realizadas"
                exit 0
                ;;
            *)
                echo "❌ Opción inválida. Por favor selecciona 0-9"
                read -p "Presiona ENTER para continuar..."
                ;;
        esac
    done
}

# ============================================================================
# PUNTO DE ENTRADA
# ============================================================================

# Verificar si bc está instalado (necesario para operaciones)
if ! command -v bc &> /dev/null; then
    echo "❌ Error: 'bc' no está instalado"
    echo "Instálalo con: sudo apt-get install bc"
    exit 1
fi

# Ejecutar programa principal
main


# ============================================================================
# EXPLICACIÓN DE CONCEPTOS
# ============================================================================

: '
📚 CONCEPTOS INTEGRADOS EN ESTE PROYECTO:

1. ESTRUCTURAS DE CONTROL:
   ✓ while true para loop infinito del menú
   ✓ case para selección de opciones
   ✓ if/elif/else para validaciones
   ✓ for para iterar historial

2. FUNCIONES:
   ✓ Modularización del código
   ✓ Funciones con parámetros
   ✓ Return values y exit codes
   ✓ Variables locales vs globales

3. VALIDACIÓN:
   ✓ Expresiones regulares para números
   ✓ Verificación de entrada del usuario
   ✓ Manejo de casos especiales (división por cero)
   ✓ Loops de validación

4. ARRAYS:
   ✓ declare -a para declarar array
   ✓ += para agregar elementos
   ✓ ${#array[@]} para tamaño
   ✓ Iteración con for

5. OPERACIONES MATEMÁTICAS:
   ✓ bc para cálculos de punto flotante
   ✓ scale=N para precisión decimal
   ✓ Operadores: +, -, *, /, ^, %, sqrt()

6. ENTRADA/SALIDA:
   ✓ read -p para prompt
   ✓ echo para salida
   ✓ Redirección de errores con >&2
   ✓ command -v para verificar comandos

7. BEST PRACTICES:
   ✓ set -euo pipefail para errores estrictos
   ✓ Variables locales en funciones
   ✓ Nombres descriptivos
   ✓ Comentarios claros
   ✓ Separación de funcionalidades

💡 DESAFÍOS EXTRA:

1. FÁCIL:
   - Agregar operación factorial
   - Mostrar fecha/hora en historial
   - Opción para exportar historial a archivo

2. MEDIO:
   - Modo científico (sin, cos, tan, log)
   - Soportar expresiones: "2+3*4"
   - Memoria: guardar/recuperar resultado

3. DIFÍCIL:
   - Parser de expresiones matemáticas
   - Gráficos ASCII de funciones
   - Modo programador (binario, hex, octal)
   - Variables definidas por usuario

🎯 OBJETIVOS DE APRENDIZAJE:

Este proyecto demuestra:
✅ Integración de múltiples conceptos
✅ Diseño de interfaz de usuario
✅ Manejo robusto de errores
✅ Código mantenible y escalable
✅ Validación exhaustiva de entrada
✅ Experiencia de usuario fluida

¡Felicidades por completar la Semana 3!
'
