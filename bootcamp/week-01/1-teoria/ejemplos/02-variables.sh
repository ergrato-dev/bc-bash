#!/bin/bash
# Ejemplo 02: Variables en Bash
# Descripción: Cómo declarar y usar variables

# === Variables Básicas ===
nombre="Juan Pérez"
edad=25
ciudad="Madrid"

echo "Nombre: $nombre"
echo "Edad: $edad años"
echo "Ciudad: $ciudad"

# === Variables del Sistema ===
echo -e "\n=== Variables del Sistema ==="
echo "Usuario actual: $USER"
echo "Directorio home: $HOME"
echo "Shell actual: $SHELL"
echo "Directorio de trabajo: $PWD"

# === Variables de Fecha ===
echo -e "\n=== Trabajando con Fechas ==="
fecha_actual=$(date +%Y-%m-%d)
hora_actual=$(date +%H:%M:%S)
timestamp=$(date +%s)

echo "Fecha: $fecha_actual"
echo "Hora: $hora_actual"
echo "Timestamp: $timestamp"

# === Concatenación de Variables ===
echo -e "\n=== Concatenación ==="
nombre_completo="$nombre"
saludo="Hola, ${nombre_completo}!"
echo "$saludo"

# === Variables numéricas ===
echo -e "\n=== Operaciones Numéricas ==="
a=10
b=5
suma=$((a + b))
resta=$((a - b))
multiplicacion=$((a * b))
division=$((a / b))

echo "$a + $b = $suma"
echo "$a - $b = $resta"
echo "$a × $b = $multiplicacion"
echo "$a ÷ $b = $division"

# === Variables de solo lectura ===
readonly PI=3.14159
echo -e "\n=== Variable de Solo Lectura ==="
echo "PI = $PI"
# PI=3.14  # Esto daría error

# === Limpiar variables ===
echo -e "\n=== Limpiar Variables ==="
temporal="valor temporal"
echo "Antes: $temporal"
unset temporal
echo "Después: $temporal (vacía)"
