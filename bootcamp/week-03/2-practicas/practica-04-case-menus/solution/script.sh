#!/bin/bash
# ============================================
# Práctica 04: Case Statement y Menús
# Semana 3 - Variables y Control de Flujo
# SOLUCIÓN COMPLETA
# ============================================

echo "=== Práctica 04: Case Statement ==="
echo ""

# ============================================
# PASO 1: Case Básico
# ============================================
echo "--- Paso 1: Case Básico ---"

opcion="a"

case $opcion in
    a)
        echo "Seleccionaste opción A"
        ;;
    b)
        echo "Seleccionaste opción B"
        ;;
    c)
        echo "Seleccionaste opción C"
        ;;
    *)
        echo "Opción desconocida"
        ;;
esac

echo ""

# ============================================
# PASO 2: Múltiples Patrones
# ============================================
echo "--- Paso 2: Múltiples Patrones ---"

respuesta="SI"

case $respuesta in
    s|S|si|SI|Si|sí|SÍ)
        echo "✓ Respondiste SÍ"
        ;;
    n|N|no|NO|No)
        echo "✗ Respondiste NO"
        ;;
    *)
        echo "? Respuesta no reconocida"
        ;;
esac

echo ""

# ============================================
# PASO 3: Wildcards con *
# ============================================
echo "--- Paso 3: Wildcards ---"

archivos=("imagen.jpg" "documento.txt" "script.sh" "data.csv")

for archivo in "${archivos[@]}"; do
    case $archivo in
        *.jpg|*.png|*.gif|*.svg)
            echo "$archivo → Es una imagen"
            ;;
        *.txt|*.md|*.doc)
            echo "$archivo → Es un documento de texto"
            ;;
        *.sh|*.bash)
            echo "$archivo → Es un script"
            ;;
        *.csv|*.json|*.xml)
            echo "$archivo → Es archivo de datos"
            ;;
        *)
            echo "$archivo → Tipo desconocido"
            ;;
    esac
done

echo ""

# ============================================
# PASO 4: Rangos de Caracteres
# ============================================
echo "--- Paso 4: Rangos ---"

caracteres=("A" "m" "5" "@")

for c in "${caracteres[@]}"; do
    case $c in
        [0-9])
            echo "'$c' es un dígito"
            ;;
        [a-z])
            echo "'$c' es letra minúscula"
            ;;
        [A-Z])
            echo "'$c' es letra mayúscula"
            ;;
        *)
            echo "'$c' es símbolo especial"
            ;;
    esac
done

echo ""

# ============================================
# PASO 5: Validación de Argumentos
# ============================================
echo "--- Paso 5: Argumentos ---"

# Simulamos argumentos
args=("-h" "-v" "-f" "archivo.txt")

for arg in "${args[@]}"; do
    case $arg in
        -h|--help)
            echo "  $arg → Mostrar ayuda"
            ;;
        -v|--version)
            echo "  $arg → Mostrar versión"
            ;;
        -f|--file)
            echo "  $arg → Especificar archivo"
            ;;
        -*)
            echo "  $arg → Opción desconocida"
            ;;
        *)
            echo "  $arg → Argumento: valor"
            ;;
    esac
done

echo ""

# ============================================
# PASO 6: Menú Simple (Simulado)
# ============================================
echo "--- Paso 6: Menú Simple ---"

echo "  === MENÚ ==="
echo "  1. Ver fecha"
echo "  2. Ver directorio"
echo "  3. Salir"

# Simulamos selección
seleccion="1"

echo "  (Selección simulada: $seleccion)"
case $seleccion in
    1)
        echo "  → Fecha: $(date +%Y-%m-%d)"
        ;;
    2)
        echo "  → Directorio: $(pwd)"
        ;;
    3)
        echo "  → Saliendo..."
        ;;
    *)
        echo "  → Opción inválida"
        ;;
esac

echo ""

# ============================================
# PASO 7: Menú con Bucle (Simulado)
# ============================================
echo "--- Paso 7: Menú con Bucle ---"

# Simulamos opciones del menú
opciones_menu=("info" "status" "q")

for opt in "${opciones_menu[@]}"; do
    echo "  Procesando: $opt"
    case $opt in
        info)
            echo "    → Sistema: $(uname -s)"
            ;;
        status)
            echo "    → Usuario: $USER"
            ;;
        q|Q|quit|exit)
            echo "    → Salir del menú"
            break
            ;;
        *)
            echo "    → Comando no reconocido"
            ;;
    esac
done

echo ""

# ============================================
# PASO 8: Procesador de Comandos
# ============================================
echo "--- Paso 8: Procesador ---"

comandos=("fecha" "usuario" "disco" "ayuda")

for cmd in "${comandos[@]}"; do
    echo "  Comando: $cmd"
    case $cmd in
        fecha|date)
            echo "    $(date)"
            ;;
        usuario|user|whoami)
            echo "    $USER"
            ;;
        disco|disk|df)
            echo "    $(df -h / | tail -1 | awk '{print $4}') disponible"
            ;;
        ayuda|help|?)
            echo "    Comandos: fecha, usuario, disco, ayuda"
            ;;
    esac
done

echo ""

# ============================================
# PASO 9: Calculadora
# ============================================
echo "--- Paso 9: Calculadora ---"

# Operaciones de prueba
operaciones=(
    "10 + 5"
    "20 - 8"
    "6 x 7"
    "100 / 4"
)

for op in "${operaciones[@]}"; do
    # Extraer operandos y operador
    a=$(echo "$op" | awk '{print $1}')
    operador=$(echo "$op" | awk '{print $2}')
    b=$(echo "$op" | awk '{print $3}')
    
    case $operador in
        +)
            resultado=$((a + b))
            ;;
        -)
            resultado=$((a - b))
            ;;
        x|\*)
            resultado=$((a * b))
            ;;
        /)
            if [[ $b -ne 0 ]]; then
                resultado=$((a / b))
            else
                resultado="Error: división por cero"
            fi
            ;;
        *)
            resultado="Operador desconocido"
            ;;
    esac
    echo "  $a $operador $b = $resultado"
done

echo ""

# ============================================
# PASO 10: Case Anidado
# ============================================
echo "--- Paso 10: Case Anidado ---"

categoria="fruta"
item="manzana"

echo "  Categoría: $categoria, Item: $item"
case $categoria in
    fruta)
        echo -n "  Color: "
        case $item in
            manzana)
                echo "Rojo o Verde"
                ;;
            naranja)
                echo "Naranja"
                ;;
            plátano)
                echo "Amarillo"
                ;;
            *)
                echo "Desconocido"
                ;;
        esac
        ;;
    vegetal)
        echo "  Es un vegetal"
        ;;
    *)
        echo "  Categoría desconocida"
        ;;
esac

echo ""
echo "✅ ¡Práctica completada!"
