#!/bin/bash
# Ejemplo 01: Hola Mundo - Tu primer script
# Descripción: Script básico que muestra mensajes en pantalla

# Configuración básica
set -e  # Detener si hay error

# Mensaje simple
echo "¡Hola Mundo!"

# Mensaje con variables
nombre="Estudiante"
echo "Hola, $nombre"

# Mensaje con fecha
echo "Hoy es: $(date +%Y-%m-%d)"

# Mensaje formateado
echo "================================"
echo "  Bienvenido al Bootcamp Bash  "
echo "================================"

# Uso de comillas simples vs dobles
echo 'Comillas simples: $nombre no se expande'
echo "Comillas dobles: $nombre sí se expande"

# Echo con opciones
echo -e "Nueva\nLínea"  # -e interpreta caracteres de escape
echo -n "Sin salto de línea al final"
echo " - continuación"
