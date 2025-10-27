#!/bin/bash
# Ejemplo de script de ejercicio - Módulo 1

echo "Hola mundo desde Bash!"
echo "Este es un ejercicio de ejemplo"

# Variables
nombre="Estudiante"
curso="Bootcamp Bash"

echo "Bienvenido $nombre al $curso"

# Función simple
saludar() {
    local nombre=$1
    echo "¡Hola $nombre! Aprendiendo shell scripting."
}

saludar "$nombre"
