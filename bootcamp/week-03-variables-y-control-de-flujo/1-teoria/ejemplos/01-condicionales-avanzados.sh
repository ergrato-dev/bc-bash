#!/bin/bash
# Ejemplo 01: Condicionales Avanzados
# Descripción: Uso completo de if, elif, else

echo "=== Condicionales Avanzados en Bash ==="

# === 1. IF Básico ===
echo -e "\n=== 1. IF Básico ==="

edad=25

if [ "$edad" -ge 18 ]; then
    echo "✓ Eres mayor de edad"
fi

# === 2. IF-ELSE ===
echo -e "\n=== 2. IF-ELSE ==="

temperatura=30

if [ "$temperatura" -gt 35 ]; then
    echo "🌡️ Hace mucho calor"
else
    echo "😊 Temperatura agradable"
fi

# === 3. IF-ELIF-ELSE ===
echo -e "\n=== 3. IF-ELIF-ELSE ==="

calificacion=85

if [ "$calificacion" -ge 90 ]; then
    echo "📚 Calificación: A - Excelente"
elif [ "$calificacion" -ge 80 ]; then
    echo "📚 Calificación: B - Muy bien"
elif [ "$calificacion" -ge 70 ]; then
    echo "📚 Calificación: C - Bien"
elif [ "$calificacion" -ge 60 ]; then
    echo "📚 Calificación: D - Suficiente"
else
    echo "📚 Calificación: F - Insuficiente"
fi

# === 4. Doble corchete [[ ]] vs [ ] ===
echo -e "\n=== 4. [[ ]] vs [ ] ==="

nombre="Juan"

# [[ ]] permite operadores lógicos y regex
if [[ "$nombre" == "Juan" && "$edad" -gt 20 ]]; then
    echo "✓ Es Juan y tiene más de 20 años"
fi

# Comparación de strings con patrón
if [[ "$nombre" == J* ]]; then
    echo "✓ El nombre empieza con J"
fi

# === 5. Operadores de comparación numérica ===
echo -e "\n=== 5. Operadores Numéricos ==="

a=10
b=20

echo "a=$a, b=$b"

if [ "$a" -eq "$b" ]; then echo "a igual a b"; fi
if [ "$a" -ne "$b" ]; then echo "✓ a diferente de b"; fi
if [ "$a" -lt "$b" ]; then echo "✓ a menor que b"; fi
if [ "$a" -le "$b" ]; then echo "✓ a menor o igual a b"; fi
if [ "$a" -gt "$b" ]; then echo "a mayor que b"; fi
if [ "$a" -ge "$b" ]; then echo "a mayor o igual a b"; fi

# === 6. Operadores de comparación de strings ===
echo -e "\n=== 6. Operadores de Strings ==="

str1="hola"
str2="mundo"

if [ "$str1" = "$str2" ]; then echo "Strings iguales"; fi
if [ "$str1" != "$str2" ]; then echo "✓ Strings diferentes"; fi
if [ -z "$str1" ]; then echo "str1 está vacío"; fi
if [ -n "$str1" ]; then echo "✓ str1 no está vacío"; fi

# === 7. Verificaciones de archivos ===
echo -e "\n=== 7. Verificaciones de Archivos ==="

archivo="/tmp/test_file.txt"
echo "contenido" > "$archivo"

if [ -e "$archivo" ]; then echo "✓ El archivo existe"; fi
if [ -f "$archivo" ]; then echo "✓ Es un archivo regular"; fi
if [ -r "$archivo" ]; then echo "✓ Es legible"; fi
if [ -w "$archivo" ]; then echo "✓ Es escribible"; fi
if [ -x "$archivo" ]; then echo "No es ejecutable"; fi

rm -f "$archivo"

# === 8. Operadores lógicos ===
echo -e "\n=== 8. Operadores Lógicos ==="

x=5
y=10

# AND (&&)
if [ "$x" -lt 10 ] && [ "$y" -gt 5 ]; then
    echo "✓ Ambas condiciones son verdaderas (&&)"
fi

# OR (||)
if [ "$x" -gt 10 ] || [ "$y" -gt 5 ]; then
    echo "✓ Al menos una condición es verdadera (||)"
fi

# NOT (!)
if [ ! "$x" -eq 10 ]; then
    echo "✓ x NO es igual a 10"
fi

# === 9. Condicional con código de salida ===
echo -e "\n=== 9. Verificar Código de Salida ==="

if ping -c 1 localhost > /dev/null 2>&1; then
    echo "✓ Ping exitoso"
else
    echo "Ping falló"
fi

# === 10. One-liner condicional ===
echo -e "\n=== 10. Condicionales en una línea ==="

[ "$edad" -ge 18 ] && echo "✓ Mayor de edad" || echo "Menor de edad"

# Asignación condicional
resultado=$([ "$x" -gt "$y" ] && echo "x mayor" || echo "y mayor")
echo "Resultado: $resultado"

echo -e "\n✓ Script completado"
