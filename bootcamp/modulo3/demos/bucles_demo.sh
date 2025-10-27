#!/bin/bash
# Demo: Bucles en Bash

echo "=== Demo de bucle FOR ==="
# Bucle for con rango
for i in {1..5}; do
    echo "Iteración $i"
done

echo -e "\n=== Demo de bucle FOR con archivos ==="
# Bucle for con archivos
for archivo in *.sh; do
    echo "Archivo encontrado: $archivo"
done

echo -e "\n=== Demo de bucle WHILE ==="
# Bucle while
contador=1
while [[ $contador -le 3 ]]; do
    echo "Contador: $contador"
    ((contador++))
done

echo -e "\n=== Demo de bucle UNTIL ==="
# Bucle until
numero=1
until [[ $numero -gt 3 ]]; do
    echo "Número: $numero"
    ((numero++))
done
