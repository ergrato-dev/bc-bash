#!/bin/bash
# Ejemplo 01: Funciones Avanzadas
# Descripción: Técnicas avanzadas de funciones en Bash

echo "=== Funciones Avanzadas en Bash ==="

# === 1. Función básica ===
echo -e "\n=== 1. Función Básica ==="

saludar() {
    echo "¡Hola desde una función!"
}

saludar

# === 2. Funciones con parámetros ===
echo -e "\n=== 2. Funciones con Parámetros ==="

saludar_persona() {
    local nombre=$1
    local edad=$2
    echo "Hola $nombre, tienes $edad años"
}

saludar_persona "Ana" 25
saludar_persona "Carlos" 30

# === 3. Valores de retorno ===
echo -e "\n=== 3. Valores de Retorno ==="

# Return solo devuelve códigos de salida (0-255)
es_par() {
    local numero=$1
    if [ $((numero % 2)) -eq 0 ]; then
        return 0  # true
    else
        return 1  # false
    fi
}

if es_par 10; then
    echo "✓ 10 es par"
fi

if ! es_par 7; then
    echo "✓ 7 es impar"
fi

# === 4. Devolver valores con echo ===
echo -e "\n=== 4. Devolver Valores con Echo ==="

sumar() {
    local a=$1
    local b=$2
    echo $((a + b))
}

resultado=$(sumar 5 3)
echo "5 + 3 = $resultado"

# === 5. Múltiples valores de retorno ===
echo -e "\n=== 5. Múltiples Valores de Retorno ==="

obtener_estadisticas() {
    local min=5
    local max=100
    local promedio=52
    echo "$min $max $promedio"
}

read -r minimo maximo promedio <<< "$(obtener_estadisticas)"
echo "Mínimo: $minimo, Máximo: $maximo, Promedio: $promedio"

# === 6. Variables locales vs globales ===
echo -e "\n=== 6. Variables Locales vs Globales ==="

global_var="soy global"

test_scope() {
    local local_var="soy local"
    global_var="modificada en función"
    echo "Dentro función - Local: $local_var"
    echo "Dentro función - Global: $global_var"
}

echo "Antes función - Global: $global_var"
test_scope
echo "Después función - Global: $global_var"
# echo "Local: $local_var"  # Esto daría error

# === 7. Argumentos variables ($@) ===
echo -e "\n=== 7. Argumentos Variables ==="

mostrar_todos() {
    echo "Número de argumentos: $#"
    echo "Todos los argumentos: $*"
    echo "Argumentos individualmente:"
    for arg in "$@"; do
        echo "  - $arg"
    done
}

mostrar_todos uno dos tres cuatro

# === 8. Valores por defecto ===
echo -e "\n=== 8. Valores por Defecto ==="

crear_usuario() {
    local nombre=${1:-"usuario"}
    local rol=${2:-"invitado"}
    local activo=${3:-"true"}
    
    echo "Usuario: $nombre | Rol: $rol | Activo: $activo"
}

crear_usuario "admin" "administrador"
crear_usuario "juan"
crear_usuario

# === 9. Funciones recursivas ===
echo -e "\n=== 9. Funciones Recursivas ==="

factorial() {
    local n=$1
    if [ "$n" -le 1 ]; then
        echo 1
    else
        local anterior=$(factorial $((n - 1)))
        echo $((n * anterior))
    fi
}

echo "Factorial de 5: $(factorial 5)"
echo "Factorial de 7: $(factorial 7)"

# === 10. Función con validación ===
echo -e "\n=== 10. Función con Validación ==="

dividir() {
    local a=$1
    local b=$2
    
    # Validar argumentos
    if [ $# -ne 2 ]; then
        echo "Error: Se requieren 2 argumentos" >&2
        return 1
    fi
    
    # Validar que son números
    if ! [[ "$a" =~ ^[0-9]+$ ]] || ! [[ "$b" =~ ^[0-9]+$ ]]; then
        echo "Error: Los argumentos deben ser números" >&2
        return 1
    fi
    
    # Validar división por cero
    if [ "$b" -eq 0 ]; then
        echo "Error: División por cero" >&2
        return 1
    fi
    
    echo $((a / b))
}

echo "10 ÷ 2 = $(dividir 10 2)"
dividir 10 0 2>&1 || echo "  (error capturado)"

# === 11. Función como callback ===
echo -e "\n=== 11. Función como Callback ==="

procesar_array() {
    local -n arr=$1
    local callback=$2
    
    for elemento in "${arr[@]}"; do
        $callback "$elemento"
    fi
}

imprimir_mayuscula() {
    echo "${1^^}"
}

imprimir_con_prefijo() {
    echo ">>> $1"
}

palabras=("hola" "mundo" "bash")

echo "Con mayúsculas:"
procesar_array palabras imprimir_mayuscula

echo -e "\nCon prefijo:"
procesar_array palabras imprimir_con_prefijo

# === 12. Funciones anónimas (subshell) ===
echo -e "\n=== 12. Funciones Anónimas ==="

resultado=$({
    local temp=10
    temp=$((temp * 2))
    temp=$((temp + 5))
    echo $temp
} 2>/dev/null || echo 25)  # Workaround para bash antiguo

echo "Resultado de función anónima: $resultado"

# === 13. Función con manejo de errores ===
echo -e "\n=== 13. Manejo de Errores ==="

error_exit() {
    echo "ERROR: $1" >&2
    exit 1
}

cargar_archivo() {
    local archivo=$1
    
    [ -z "$archivo" ] && error_exit "No se especificó archivo"
    [ ! -f "$archivo" ] && error_exit "Archivo no existe: $archivo"
    [ ! -r "$archivo" ] && error_exit "Archivo no legible: $archivo"
    
    cat "$archivo"
}

# Crear archivo temporal para demo
echo "contenido de prueba" > /tmp/test_func.txt
echo "Contenido: $(cargar_archivo /tmp/test_func.txt)"
rm -f /tmp/test_func.txt

# === 14. Función con opciones ===
echo -e "\n=== 14. Función con Opciones ==="

copiar_con_opciones() {
    local verbose=false
    local backup=false
    local origen=""
    local destino=""
    
    while [ $# -gt 0 ]; do
        case $1 in
            -v|--verbose)
                verbose=true
                shift
                ;;
            -b|--backup)
                backup=true
                shift
                ;;
            *)
                if [ -z "$origen" ]; then
                    origen=$1
                else
                    destino=$1
                fi
                shift
                ;;
        esac
    done
    
    [ "$verbose" = true ] && echo "Copiando $origen -> $destino"
    [ "$backup" = true ] && echo "Creando backup..."
    echo "✓ Copia realizada"
}

copiar_con_opciones -v -b archivo.txt destino.txt

echo -e "\n✓ Script completado"
