#!/bin/bash
# Ejercicio 02: Arrays en Bash
# Módulo: 4 | Objetivo: Dominar arrays indexados

echo "📚 Ejercicio 02: Arrays"
echo "======================="

# TAREA 1: Crear array
frutas=("manzana" "naranja" "plátano" "uva")
echo "Array creado: ${frutas[@]}"

# TAREA 2: Acceder elemento
echo "Primera fruta: ${frutas[0]}"
echo "Tercera fruta: ${frutas[2]}"

# TAREA 3: Agregar elemento
frutas+=("pera")
echo "Array con pera: ${frutas[@]}"

# TAREA 4: Tamaño del array
echo "Número de frutas: ${#frutas[@]}"

# TAREA 5: Iterar array
echo "Todas las frutas:"
for fruta in "${frutas[@]}"; do
    echo "  - $fruta"
done

# TAREA 6: Indices
echo "Con índices:"
for i in "${!frutas[@]}"; do
    echo "  [$i] = ${frutas[$i]}"
done

# TAREA 7: Slice de array
echo "Primeras 3: ${frutas[@]:0:3}"

# TAREA 8: Eliminar elemento
unset frutas[1]
echo "Sin naranja: ${frutas[@]}"

echo "✅ Completado"
