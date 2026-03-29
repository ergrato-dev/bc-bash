#!/bin/bash
#=====================================================================
# CONDICIONALES_AVANZADAS.SH
# Ejemplos avanzados de estructuras condicionales en Bash
#=====================================================================

set -euo pipefail

echo "=== CONDICIONALES AVANZADAS EN BASH ==="

echo -e "\n=== OPERADORES DE COMPARACIÓN NUMÉRICA ==="

numero=42

if [[ $numero -eq 42 ]]; then
    echo "✅ El número es igual a 42"
fi

if [[ $numero -gt 30 ]]; then
    echo "✅ El número es mayor que 30"
fi

if [[ $numero -lt 50 ]]; then
    echo "✅ El número es menor que 50"
fi

if [[ $numero -ge 42 ]]; then
    echo "✅ El número es mayor o igual que 42"
fi

if [[ $numero -le 42 ]]; then
    echo "✅ El número es menor o igual que 42"
fi

if [[ $numero -ne 0 ]]; then
    echo "✅ El número no es cero"
fi

echo -e "\n=== OPERADORES DE COMPARACIÓN DE CADENAS ==="

texto="Bash"
otro_texto="bash"

if [[ $texto == "Bash" ]]; then
    echo "✅ La cadena es exactamente 'Bash'"
fi

if [[ $texto != "$otro_texto" ]]; then
    echo "✅ Las cadenas son diferentes (sensible a mayúsculas)"
fi

# Comparación insensible a mayúsculas
if [[ ${texto,,} == "${otro_texto,,}" ]]; then
    echo "✅ Las cadenas son iguales (insensible a mayúsculas)"
fi

# Verificar si una cadena está vacía
cadena_vacia=""
if [[ -z $cadena_vacia ]]; then
    echo "✅ La cadena está vacía"
fi

# Verificar si una cadena no está vacía
cadena_no_vacia="contenido"
if [[ -n $cadena_no_vacia ]]; then
    echo "✅ La cadena no está vacía"
fi

echo -e "\n=== PRUEBAS DE ARCHIVOS Y DIRECTORIOS ==="

# Crear archivo temporal para demos
temp_file="/tmp/demo_file.txt"
echo "Contenido de prueba" > "$temp_file"

if [[ -f $temp_file ]]; then
    echo "✅ El archivo existe"
fi

if [[ -r $temp_file ]]; then
    echo "✅ El archivo es legible"
fi

if [[ -w $temp_file ]]; then
    echo "✅ El archivo es escribible"
fi

# Pruebas de directorios
if [[ -d "/tmp" ]]; then
    echo "✅ /tmp es un directorio"
fi

if [[ -d "/archivo_inexistente" ]]; then
    echo "❌ Este mensaje no debería aparecer"
else
    echo "✅ /archivo_inexistente no es un directorio"
fi

# Limpiar archivo temporal
rm -f "$temp_file"

echo -e "\n=== CONDICIONALES COMPUESTAS ==="

edad=25
tiene_licencia=true

# AND lógico
if [[ $edad -ge 18 && $tiene_licencia == true ]]; then
    echo "✅ Puede conducir (mayor de edad Y tiene licencia)"
fi

# OR lógico
dia="sabado"
if [[ $dia == "sabado" || $dia == "domingo" ]]; then
    echo "✅ Es fin de semana"
fi

# NOT lógico
if [[ ! $dia == "lunes" ]]; then
    echo "✅ No es lunes"
fi

echo -e "\n=== CONDICIONALES ANIDADAS ==="

puntuacion=85

if [[ $puntuacion -ge 90 ]]; then
    echo "Calificación: Excelente"
elif [[ $puntuacion -ge 80 ]]; then
    echo "Calificación: Buena"
    if [[ $puntuacion -ge 85 ]]; then
        echo "  → Casi excelente!"
    fi
elif [[ $puntuacion -ge 70 ]]; then
    echo "Calificación: Regular"
else
    echo "Calificación: Necesita mejorar"
fi

echo -e "\n=== CASE STATEMENT AVANZADO ==="

opcion="bash"

case $opcion in
    "bash"|"sh"|"zsh")
        echo "Shell Unix/Linux detectado"
        case $opcion in
            "bash") echo "  → Bourne Again Shell" ;;
            "sh")   echo "  → Bourne Shell" ;;
            "zsh")  echo "  → Z Shell" ;;
        esac
        ;;
    "powershell"|"cmd")
        echo "Shell de Windows detectado"
        ;;
    "python"|"ruby"|"node")
        echo "Intérprete de lenguaje detectado"
        ;;
    *)
        echo "Opción no reconocida: $opcion"
        ;;
esac

echo -e "\n=== EXPRESIONES REGULARES EN CONDICIONALES ==="

email="usuario@ejemplo.com"

# Verificar formato básico de email
if [[ $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "✅ Email con formato válido: $email"
else
    echo "❌ Email con formato inválido: $email"
fi

# Verificar extensión de archivo
archivo="script.sh"
if [[ $archivo =~ \.sh$ ]]; then
    echo "✅ Archivo de shell script: $archivo"
fi

echo -e "\n=== CONDICIONALES CON CÓDIGOS DE SALIDA ==="

# Verificar si un comando existe
if command -v git >/dev/null 2>&1; then
    echo "✅ Git está instalado"
    git_version=$(git --version)
    echo "  Versión: $git_version"
else
    echo "❌ Git no está instalado"
fi

# Verificar resultado de comando
if grep -q "bash" /etc/shells 2>/dev/null; then
    echo "✅ Bash está disponible en el sistema"
else
    echo "❌ Bash no está en /etc/shells"
fi

echo -e "\n=== FUNCIÓN CON CONDICIONALES ==="

verificar_numero() {
    local num=$1
    
    if [[ ! $num =~ ^-?[0-9]+$ ]]; then
        echo "❌ '$num' no es un número válido"
        return 1
    fi
    
    if [[ $num -eq 0 ]]; then
        echo "El número es cero"
    elif [[ $num -gt 0 ]]; then
        echo "El número $num es positivo"
        if [[ $((num % 2)) -eq 0 ]]; then
            echo "  → Y es par"
        else
            echo "  → Y es impar"
        fi
    else
        echo "El número $num es negativo"
    fi
    
    return 0
}

# Probar la función
echo "Probando función verificar_numero:"
verificar_numero 42
verificar_numero -15
verificar_numero 0
verificar_numero "abc"

echo -e "\n=== FIN DEL EJEMPLO ==="
