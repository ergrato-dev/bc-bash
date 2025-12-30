#!/bin/bash
# Ejemplo 03: CASE Statement
# Descripción: Switch/case en Bash

echo "=== Case Statement en Bash ==="

# === 1. Case básico ===
echo -e "\n=== 1. Case Básico ==="

dia="lunes"

case $dia in
    lunes)
        echo "📅 Inicio de semana"
        ;;
    viernes)
        echo "🎉 Casi fin de semana"
        ;;
    sabado|domingo)
        echo "🏖️ ¡Fin de semana!"
        ;;
    *)
        echo "📆 Día normal de la semana"
        ;;
esac

# === 2. Case con patrones ===
echo -e "\n=== 2. Case con Patrones ==="

archivo="documento.pdf"

case $archivo in
    *.txt)
        echo "📄 Archivo de texto"
        ;;
    *.pdf)
        echo "📕 Archivo PDF"
        ;;
    *.jpg|*.png|*.gif)
        echo "🖼️ Archivo de imagen"
        ;;
    *.sh)
        echo "🔧 Script de Bash"
        ;;
    *)
        echo "❓ Tipo de archivo desconocido"
        ;;
esac

# === 3. Case para menú ===
echo -e "\n=== 3. Menú con Case ==="

mostrar_menu() {
    echo ""
    echo "=== MENÚ PRINCIPAL ==="
    echo "1) Ver archivos"
    echo "2) Ver procesos"
    echo "3) Ver uso de disco"
    echo "4) Salir"
    echo -n "Selecciona una opción: "
}

# Simular opción 1 para demo
opcion="1"

case $opcion in
    1)
        echo "📂 Listando archivos..."
        ls -lh | head -5
        ;;
    2)
        echo "⚙️ Mostrando procesos..."
        ps aux | head -5
        ;;
    3)
        echo "💾 Uso de disco..."
        df -h | head -5
        ;;
    4)
        echo "👋 Adiós!"
        ;;
    *)
        echo "❌ Opción inválida"
        ;;
esac

# === 4. Case con rangos ===
echo -e "\n=== 4. Case con Rangos ==="

calificacion=85

case $calificacion in
    [9][0-9]|100)
        echo "🏆 Calificación: A"
        ;;
    [8][0-9])
        echo "🥈 Calificación: B"
        ;;
    [7][0-9])
        echo "🥉 Calificación: C"
        ;;
    [6][0-9])
        echo "📝 Calificación: D"
        ;;
    *)
        echo "❌ Calificación: F"
        ;;
esac

# === 5. Case con opciones de comando ===
echo -e "\n=== 5. Case para Argumentos de Script ==="

procesar_opcion() {
    local opt=$1
    
    case $opt in
        -h|--help)
            echo "Ayuda del script"
            echo "Uso: script.sh [opciones]"
            ;;
        -v|--version)
            echo "Versión 1.0.0"
            ;;
        -d|--debug)
            echo "Modo debug activado"
            ;;
        -q|--quiet)
            echo "Modo silencioso activado"
            ;;
        *)
            echo "Opción desconocida: $opt"
            echo "Use -h para ayuda"
            ;;
    esac
}

# Demostrar
procesar_opcion "-h"
procesar_opcion "--version"

# === 6. Case con verificación de sistema ===
echo -e "\n=== 6. Case para Sistema Operativo ==="

os=$(uname -s)

case $os in
    Linux)
        echo "🐧 Sistema: Linux"
        ;;
    Darwin)
        echo "🍎 Sistema: macOS"
        ;;
    CYGWIN*|MINGW*|MSYS*)
        echo "🪟 Sistema: Windows"
        ;;
    *)
        echo "❓ Sistema desconocido: $os"
        ;;
esac

# === 7. Case con múltiples comandos ===
echo -e "\n=== 7. Case con Múltiples Comandos ==="

operacion="sumar"
num1=10
num2=5

case $operacion in
    sumar)
        resultado=$((num1 + num2))
        echo "➕ $num1 + $num2 = $resultado"
        ;;
    restar)
        resultado=$((num1 - num2))
        echo "➖ $num1 - $num2 = $resultado"
        ;;
    multiplicar)
        resultado=$((num1 * num2))
        echo "✖️ $num1 × $num2 = $resultado"
        ;;
    dividir)
        if [ $num2 -ne 0 ]; then
            resultado=$((num1 / num2))
            echo "➗ $num1 ÷ $num2 = $resultado"
        else
            echo "❌ Error: División por cero"
        fi
        ;;
    *)
        echo "❌ Operación no soportada"
        ;;
esac

# === 8. Case con validación de input ===
echo -e "\n=== 8. Case para Validar Input ==="

validar_respuesta() {
    local respuesta=$1
    
    case $respuesta in
        [yY]|[yY][eE][sS]|[sS]|[sS][iI])
            echo "✓ Confirmado"
            return 0
            ;;
        [nN]|[nN][oO])
            echo "✗ Cancelado"
            return 1
            ;;
        *)
            echo "❓ Respuesta no válida (use: y/n)"
            return 2
            ;;
    esac
}

# Demostrar
validar_respuesta "yes"
validar_respuesta "no"
validar_respuesta "maybe"

# === 9. Case anidado ===
echo -e "\n=== 9. Case Anidado ==="

tipo="documento"
formato="pdf"

case $tipo in
    documento)
        case $formato in
            pdf)
                echo "📕 Documento PDF"
                ;;
            doc|docx)
                echo "📝 Documento Word"
                ;;
            txt)
                echo "📄 Archivo de texto"
                ;;
        esac
        ;;
    imagen)
        case $formato in
            jpg|jpeg)
                echo "🖼️ Imagen JPEG"
                ;;
            png)
                echo "🖼️ Imagen PNG"
                ;;
        esac
        ;;
esac

echo -e "\n✓ Script completado"
