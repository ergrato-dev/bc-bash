#!/bin/bash
# Demo: Procesamiento de argumentos

echo "=== Información de argumentos ==="
echo "Nombre del script: $0"
echo "Número de argumentos: $#"
echo "Todos los argumentos: $*"
echo "Argumentos como array: $@"

echo -e "\n=== Argumentos individuales ==="
echo "Primer argumento: ${1:-'No proporcionado'}"
echo "Segundo argumento: ${2:-'No proporcionado'}"
echo "Tercer argumento: ${3:-'No proporcionado'}"

echo -e "\n=== Procesando todos los argumentos ==="
for arg in "$@"; do
    echo "Argumento: $arg"
done

# Demo de opciones con getopts
while getopts "hv:n:" opt; do
    case $opt in
        h)
            echo "Ayuda: Uso del script"
            ;;
        v)
            echo "Versión: $OPTARG"
            ;;
        n)
            echo "Nombre: $OPTARG"
            ;;
        \?)
            echo "Opción inválida: -$OPTARG"
            ;;
    esac
done
