#!/bin/bash
# Ejemplo 02: Arrays Avanzados
# Descripción: Operaciones avanzadas con arrays

echo "=== Arrays Avanzados en Bash ==="

# === 1. Declaración de arrays ===
echo -e "\n=== 1. Declaración de Arrays ==="

# Array simple
frutas=("manzana" "pera" "uva")

# Array con declare
declare -a numeros=(1 2 3 4 5)

# Array vacío
declare -a vacio

echo "Frutas: ${frutas[@]}"
echo "Números: ${numeros[@]}"

# === 2. Acceso a elementos ===
echo -e "\n=== 2. Acceso a Elementos ==="

echo "Primera fruta: ${frutas[0]}"
echo "Segunda fruta: ${frutas[1]}"
echo "Última fruta: ${frutas[-1]}"

# === 3. Longitud de arrays ===
echo -e "\n=== 3. Longitud de Arrays ==="

echo "Cantidad de frutas: ${#frutas[@]}"
echo "Longitud del primer elemento: ${#frutas[0]}"

# === 4. Agregar elementos ===
echo -e "\n=== 4. Agregar Elementos ==="

# Al final
frutas+=("plátano")
echo "Después de agregar: ${frutas[@]}"

# En posición específica
frutas[10]="sandía"
echo "Con elemento en índice 10: ${frutas[@]}"
echo "Longitud: ${#frutas[@]}"

# === 5. Eliminar elementos ===
echo -e "\n=== 5. Eliminar Elementos ==="

unset frutas[1]
echo "Después de eliminar índice 1: ${frutas[@]}"
echo "Índices existentes: ${!frutas[@]}"

# === 6. Iterar sobre arrays ===
echo -e "\n=== 6. Iterar sobre Arrays ==="

colores=("rojo" "verde" "azul" "amarillo")

echo "Por elementos:"
for color in "${colores[@]}"; do
    echo "  - $color"
done

echo -e "\nPor índices:"
for i in "${!colores[@]}"; do
    echo "  [$i] = ${colores[$i]}"
done

# === 7. Slicing (rebanado) ===
echo -e "\n=== 7. Slicing de Arrays ==="

numeros=(0 1 2 3 4 5 6 7 8 9)

echo "Array completo: ${numeros[@]}"
echo "Desde índice 2: ${numeros[@]:2}"
echo "3 elementos desde índice 2: ${numeros[@]:2:3}"
echo "Últimos 3 elementos: ${numeros[@]: -3}"

# === 8. Buscar en arrays ===
echo -e "\n=== 8. Buscar en Arrays ==="

buscar_en_array() {
    local buscar=$1
    shift
    local arr=("$@")
    
    for i in "${!arr[@]}"; do
        if [ "${arr[$i]}" = "$buscar" ]; then
            echo "Encontrado '$buscar' en índice $i"
            return 0
        fi
    done
    echo "'$buscar' no encontrado"
    return 1
}

animales=("perro" "gato" "loro" "pez")
buscar_en_array "gato" "${animales[@]}"
buscar_en_array "conejo" "${animales[@]}"

# === 9. Concatenar arrays ===
echo -e "\n=== 9. Concatenar Arrays ==="

arr1=(1 2 3)
arr2=(4 5 6)
arr3=("${arr1[@]}" "${arr2[@]}")

echo "Array 1: ${arr1[@]}"
echo "Array 2: ${arr2[@]}"
echo "Concatenado: ${arr3[@]}"

# === 10. Copiar arrays ===
echo -e "\n=== 10. Copiar Arrays ==="

original=("a" "b" "c")
copia=("${original[@]}")

echo "Original: ${original[@]}"
echo "Copia: ${copia[@]}"

copia[1]="Z"
echo "Después de modificar copia:"
echo "Original: ${original[@]}"
echo "Copia: ${copia[@]}"

# === 11. Ordenar arrays ===
echo -e "\n=== 11. Ordenar Arrays ==="

desordenado=(5 2 8 1 9 3)
echo "Desordenado: ${desordenado[@]}"

# Ordenar con sort
IFS=$'\n' ordenado=($(sort -n <<<"${desordenado[*]}"))
unset IFS

echo "Ordenado: ${ordenado[@]}"

# === 12. Eliminar duplicados ===
echo -e "\n=== 12. Eliminar Duplicados ==="

con_duplicados=(1 2 2 3 3 3 4 5 5)
echo "Con duplicados: ${con_duplicados[@]}"

# Usar associative array
declare -A vistos
sin_duplicados=()

for num in "${con_duplicados[@]}"; do
    if [ -z "${vistos[$num]}" ]; then
        sin_duplicados+=("$num")
        vistos[$num]=1
    fi
done

echo "Sin duplicados: ${sin_duplicados[@]}"

# === 13. Arrays asociativos (diccionarios) ===
echo -e "\n=== 13. Arrays Asociativos ==="

declare -A usuario
usuario[nombre]="Juan"
usuario[edad]=30
usuario[ciudad]="Madrid"

echo "Nombre: ${usuario[nombre]}"
echo "Edad: ${usuario[edad]}"
echo "Ciudad: ${usuario[ciudad]}"

echo -e "\nTodas las claves:"
for clave in "${!usuario[@]}"; do
    echo "  $clave = ${usuario[$clave]}"
done

# === 14. Array de arrays (simulado) ===
echo -e "\n=== 14. Array de Arrays (Simulado) ==="

# Bash no soporta arrays multidimensionales nativamente
# Pero podemos simularlos

declare -A matriz

# Establecer valores
matriz[0,0]="A"
matriz[0,1]="B"
matriz[1,0]="C"
matriz[1,1]="D"

# Leer valores
echo "Matriz 2x2:"
for i in 0 1; do
    for j in 0 1; do
        echo -n "${matriz[$i,$j]} "
    done
    echo ""
done

# === 15. Operaciones con todos los elementos ===
echo -e "\n=== 15. Operaciones Masivas ==="

palabras=("hola" "mundo" "bash" "scripting")

# Convertir a mayúsculas
echo "Mayúsculas:"
for palabra in "${palabras[@]}"; do
    echo -n "${palabra^^} "
done
echo ""

# Convertir a minúsculas
palabras_mayus=("ALPHA" "BETA" "GAMMA")
echo -e "\nMinúsculas:"
for palabra in "${palabras_mayus[@]}"; do
    echo -n "${palabra,,} "
done
echo ""

# === 16. Filtrar array ===
echo -e "\n=== 16. Filtrar Array ==="

todos_nums=(1 2 3 4 5 6 7 8 9 10)
pares=()

for num in "${todos_nums[@]}"; do
    if [ $((num % 2)) -eq 0 ]; then
        pares+=("$num")
    fi
done

echo "Números: ${todos_nums[@]}"
echo "Solo pares: ${pares[@]}"

# === 17. Map (transformar) ===
echo -e "\n=== 17. Map - Transformar Elementos ==="

numeros=(1 2 3 4 5)
cuadrados=()

for num in "${numeros[@]}"; do
    cuadrados+=($((num * num)))
done

echo "Números: ${numeros[@]}"
echo "Cuadrados: ${cuadrados[@]}"

# === 18. Reduce (acumular) ===
echo -e "\n=== 18. Reduce - Acumular Valores ==="

valores=(1 2 3 4 5)
suma=0

for val in "${valores[@]}"; do
    suma=$((suma + val))
done

echo "Valores: ${valores[@]}"
echo "Suma total: $suma"

# === 19. Array desde comando ===
echo -e "\n=== 19. Array desde Comando ==="

# Leer líneas de archivo en array
mapfile -t lineas < <(echo -e "línea 1\nlínea 2\nlínea 3")
echo "Líneas leídas:"
for linea in "${lineas[@]}"; do
    echo "  - $linea"
done

# === 20. Exportar array como string ===
echo -e "\n=== 20. Serializar Array ==="

datos=("apple" "banana" "cherry")

# Convertir a string
datos_string="${datos[*]}"
echo "Como string: $datos_string"

# Convertir de vuelta a array
IFS=' ' read -ra datos_recuperados <<< "$datos_string"
echo "Recuperado como array: ${datos_recuperados[@]}"

echo -e "\n✓ Script completado"
