#!/bin/bash
# Ejemplo 02: Loops Completos
# Descripción: For, While, Until, Select

echo "=== Loops Completos en Bash ==="

# === 1. FOR con rango ===
echo -e "\n=== 1. FOR con Rango {1..5} ==="

for i in {1..5}; do
    echo "Iteración: $i"
done

# === 2. FOR con lista ===
echo -e "\n=== 2. FOR con Lista ==="

for fruta in manzana pera naranja plátano; do
    echo "🍎 Fruta: $fruta"
done

# === 3. FOR estilo C ===
echo -e "\n=== 3. FOR Estilo C ==="

for ((i=0; i<5; i++)); do
    echo "Contador: $i"
done

# === 4. FOR con archivos ===
echo -e "\n=== 4. FOR con Archivos ==="

# Crear archivos de prueba
for i in {1..3}; do
    echo "contenido $i" > "temp_$i.txt"
done

echo "Procesando archivos:"
for archivo in temp_*.txt; do
    echo "  - Archivo: $archivo"
    cat "$archivo"
done

# Limpiar
rm -f temp_*.txt

# === 5. FOR con comando ===
echo -e "\n=== 5. FOR con Salida de Comando ==="

for usuario in $(cut -d: -f1 /etc/passwd | head -5); do
    echo "👤 Usuario: $usuario"
done

# === 6. WHILE loop ===
echo -e "\n=== 6. WHILE Loop ==="

contador=1
while [ $contador -le 5 ]; do
    echo "While iteración: $contador"
    contador=$((contador + 1))
done

# === 7. WHILE leyendo archivo ===
echo -e "\n=== 7. WHILE Leyendo Archivo ==="

# Crear archivo de prueba
cat > frutas.txt << EOF
manzana
pera
uva
plátano
EOF

echo "Frutas del archivo:"
while IFS= read -r linea; do
    echo "  🍇 $linea"
done < frutas.txt

rm -f frutas.txt

# === 8. UNTIL loop ===
echo -e "\n=== 8. UNTIL Loop ==="

numero=1
until [ $numero -gt 5 ]; do
    echo "Until iteración: $numero"
    numero=$((numero + 1))
done

# === 9. Loop infinito con break ===
echo -e "\n=== 9. Loop Infinito con Break ==="

contador=0
while true; do
    contador=$((contador + 1))
    echo "Iteración infinita: $contador"
    
    if [ $contador -ge 3 ]; then
        echo "¡Break! Saliendo del loop"
        break
    fi
done

# === 10. Continue en loops ===
echo -e "\n=== 10. Continue en Loops ==="

echo "Números impares (usando continue):"
for n in {1..10}; do
    # Saltar números pares
    if [ $((n % 2)) -eq 0 ]; then
        continue
    fi
    echo "  Número impar: $n"
done

# === 11. Loop anidado ===
echo -e "\n=== 11. Loops Anidados ==="

echo "Tabla de multiplicar (3x3):"
for i in {1..3}; do
    for j in {1..3}; do
        resultado=$((i * j))
        echo -n "$i x $j = $resultado  "
    done
    echo ""
done

# === 12. SELECT menu ===
echo -e "\n=== 12. SELECT Menu Interactivo ==="

echo "Selecciona tu lenguaje favorito:"
select lenguaje in Bash Python JavaScript Ruby "Salir"; do
    case $lenguaje in
        Bash|Python|JavaScript|Ruby)
            echo "✓ Has seleccionado: $lenguaje"
            break
            ;;
        "Salir")
            echo "👋 Adiós!"
            break
            ;;
        *)
            echo "Opción inválida"
            ;;
    esac
done

# === 13. Loop sobre array ===
echo -e "\n=== 13. Loop sobre Array ==="

colores=("rojo" "verde" "azul" "amarillo")

echo "Colores con índice:"
for i in "${!colores[@]}"; do
    echo "  [$i] ${colores[$i]}"
done

# === 14. Loop con paso personalizado ===
echo -e "\n=== 14. Loop con Paso ==="

echo "Números de 0 a 10 de 2 en 2:"
for i in {0..10..2}; do
    echo -n "$i "
done
echo ""

echo -e "\n✓ Script completado"
