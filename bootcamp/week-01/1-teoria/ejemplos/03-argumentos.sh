#!/bin/bash
# Ejemplo 03: Argumentos del Script
# Descripción: Cómo trabajar con parámetros de entrada
# Uso: ./03-argumentos.sh arg1 arg2 arg3

echo "=== Información de Argumentos ==="
echo "Nombre del script: $0"
echo "Número de argumentos: $#"
echo "Todos los argumentos: $@"
echo "PID del script: $$"

# Verificar si hay argumentos
if [ $# -eq 0 ]; then
    echo -e "\n❌ No se proporcionaron argumentos"
    echo "Uso: $0 <nombre> <edad> [ciudad]"
    exit 1
fi

# Acceder a argumentos individuales
echo -e "\n=== Argumentos Individuales ==="
echo "Primer argumento (\$1): $1"

if [ -n "$2" ]; then
    echo "Segundo argumento (\$2): $2"
fi

if [ -n "$3" ]; then
    echo "Tercer argumento (\$3): $3"
fi

# Procesar todos los argumentos
echo -e "\n=== Iterando Argumentos ==="
contador=1
for arg in "$@"; do
    echo "Argumento $contador: $arg"
    ((contador++))
done

# Ejemplo con valores por defecto
nombre=${1:-"Usuario"}
edad=${2:-"0"}
ciudad=${3:-"Desconocida"}

echo -e "\n=== Información del Usuario ==="
echo "Nombre: $nombre"
echo "Edad: $edad"
echo "Ciudad: $ciudad"
