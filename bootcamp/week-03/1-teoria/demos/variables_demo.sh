#!/bin/bash
# Demo: Variables y expansión de parámetros

# Variables básicas
nombre="Bootcamp Bash"
version=3.0
activo=true

# Variables de entorno
export MI_VARIABLE="Valor global"

# Expansión de parámetros
echo "Nombre: $nombre"
echo "Versión: ${version}"
echo "Longitud del nombre: ${#nombre}"
echo "Nombre en mayúsculas: ${nombre^^}"

# Variables por defecto
echo "Usuario: ${USER:-'usuario_desconocido'}"
echo "Valor personalizado: ${MI_VALOR:-'valor_por_defecto'}"
