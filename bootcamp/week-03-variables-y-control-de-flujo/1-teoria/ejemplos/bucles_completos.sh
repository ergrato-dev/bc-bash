#!/bin/bash
#=====================================================================
# BUCLES_COMPLETOS.SH
# Ejemplos completos de bucles en Bash
#=====================================================================

set -euo pipefail

echo "=== BUCLES COMPLETOS EN BASH ==="

echo -e "\n=== BUCLE FOR - RANGOS NUMÉRICOS ==="

# Rango simple
echo "Contador del 1 al 5:"
for i in {1..5}; do
    echo "  Número: $i"
done

# Rango con incremento
echo -e "\nNúmeros pares del 2 al 10:"
for i in {2..10..2}; do
    echo "  Número par: $i"
done

# Rango descendente
echo -e "\nCuenta regresiva:"
for i in {5..1}; do
    echo "  $i..."
done
echo "  ¡Despegue!"

echo -e "\n=== BUCLE FOR - LISTAS DE ELEMENTOS ==="

# Lista de cadenas
frutas=("manzana" "banana" "naranja" "uva" "fresa")
echo "Lista de frutas:"
for fruta in "${frutas[@]}"; do
    echo "  🍎 $fruta"
done

# Lista de archivos
echo -e "\nArchivos .sh en el directorio actual:"
for archivo in *.sh; do
    if [[ -f $archivo ]]; then
        echo "  📄 $archivo"
        echo "    Tamaño: $(stat -f%z "$archivo" 2>/dev/null || stat -c%s "$archivo" 2>/dev/null || echo "N/A") bytes"
    fi
done

# Lista de directorios
echo -e "\nDirectorios en /tmp:"
for dir in /tmp/*/; do
    if [[ -d $dir ]]; then
        echo "  📁 $(basename "$dir")"
    fi
done 2>/dev/null || echo "  No hay subdirectorios en /tmp"

echo -e "\n=== BUCLE FOR - ESTILO C ==="

echo "Bucle estilo C - Tabla del 7:"
for ((i=1; i<=10; i++)); do
    resultado=$((7 * i))
    echo "  7 × $i = $resultado"
done

echo -e "\nBucle con incremento variable:"
for ((i=1, step=1; i<=20; i+=step, step++)); do
    echo "  i=$i, step=$step"
done

echo -e "\n=== BUCLE WHILE ==="

# Contador simple
echo "Bucle while - Contador:"
contador=1
while [[ $contador -le 5 ]]; do
    echo "  Iteración $contador"
    ((contador++))
done

# Leer archivo línea por línea
echo -e "\nCreando archivo temporal y leyéndolo:"
temp_file="/tmp/demo_lines.txt"
cat > "$temp_file" << EOF
Primera línea
Segunda línea
Tercera línea
Línea con espacios múltiples
Última línea
EOF

echo "Contenido del archivo:"
line_number=1
while IFS= read -r linea; do
    echo "  Línea $line_number: $linea"
    ((line_number++))
done < "$temp_file"

# Limpiar archivo temporal
rm -f "$temp_file"

# Bucle infinito con break
echo -e "\nBucle while con break:"
contador=1
while true; do
    echo "  Iteración $contador"
    if [[ $contador -eq 3 ]]; then
        echo "  → Rompiendo el bucle en la iteración 3"
        break
    fi
    ((contador++))
done

echo -e "\n=== BUCLE UNTIL ==="

# Until básico
echo "Bucle until - Cuenta hasta 5:"
numero=1
until [[ $numero -gt 5 ]]; do
    echo "  Número: $numero"
    ((numero++))
done

# Until con condición compuesta
echo -e "\nBucle until con condición compuesta:"
intentos=1
exito=false
until [[ $intentos -gt 3 || $exito == true ]]; do
    echo "  Intento $intentos"
    if [[ $intentos -eq 2 ]]; then
        exito=true
        echo "  → ¡Éxito en el intento $intentos!"
    fi
    ((intentos++))
done

echo -e "\n=== CONTROL DE FLUJO - CONTINUE ==="

echo "Bucle con continue - Solo números impares:"
for i in {1..10}; do
    if [[ $((i % 2)) -eq 0 ]]; then
        continue  # Saltar números pares
    fi
    echo "  Número impar: $i"
done

echo -e "\n=== BUCLES ANIDADOS ==="

echo "Tabla de multiplicar (3x3):"
for i in {1..3}; do
    for j in {1..3}; do
        resultado=$((i * j))
        printf "  %d×%d=%d " "$i" "$j" "$resultado"
    done
    echo  # Nueva línea después de cada fila
done

echo -e "\n=== BUCLES CON ARRAYS ASOCIATIVOS ==="

# Crear array asociativo
declare -A colores
colores[rojo]="#FF0000"
colores[verde]="#00FF00"
colores[azul]="#0000FF"

echo "Colores y sus códigos:"
for color in "${!colores[@]}"; do
    echo "  $color: ${colores[$color]}"
done

echo -e "\n=== BUCLE CON COMANDOS ==="

echo "Verificando servicios del sistema:"
servicios=("bash" "ls" "cat" "grep" "awk")

for servicio in "${servicios[@]}"; do
    if command -v "$servicio" >/dev/null 2>&1; then
        echo "  ✅ $servicio está disponible"
    else
        echo "  ❌ $servicio no está disponible"
    fi
done

echo -e "\n=== BUCLE CON FUNCIÓN ==="

# Función para procesar elementos
procesar_numero() {
    local num=$1
    if [[ $((num % 2)) -eq 0 ]]; then
        echo "    $num es par"
    else
        echo "    $num es impar"
    fi
    
    if [[ $num -gt 5 ]]; then
        echo "    $num es mayor que 5"
    fi
}

echo "Procesando números con función:"
for numero in {1..8}; do
    echo "  Procesando $numero:"
    procesar_numero "$numero"
done

echo -e "\n=== BUCLE CON MANEJO DE ERRORES ==="

echo "Procesando archivos con manejo de errores:"
archivos_prueba=("archivo_existe.txt" "/etc/passwd" "archivo_no_existe.txt")

for archivo in "${archivos_prueba[@]}"; do
    echo "  Procesando: $archivo"
    if [[ -f $archivo ]]; then
        lineas=$(wc -l < "$archivo" 2>/dev/null || echo "0")
        echo "    ✅ Archivo encontrado ($lineas líneas)"
    else
        echo "    ❌ Archivo no encontrado"
        continue
    fi
done

echo -e "\n=== BUCLE CON PROGRESO ==="

echo "Simulando progreso (5 pasos):"
total=5
for ((i=1; i<=total; i++)); do
    porcentaje=$((i * 100 / total))
    printf "  Paso %d/%d [%d%%] " "$i" "$total" "$porcentaje"
    
    # Simular trabajo
    sleep 0.5
    
    # Mostrar barra de progreso simple
    case $porcentaje in
        20)  echo "▓░░░░" ;;
        40)  echo "▓▓░░░" ;;
        60)  echo "▓▓▓░░" ;;
        80)  echo "▓▓▓▓░" ;;
        100) echo "▓▓▓▓▓ ¡Completado!" ;;
    esac
done

echo -e "\n=== FIN DEL EJEMPLO ==="
