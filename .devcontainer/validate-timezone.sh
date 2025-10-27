#!/bin/bash
# Script para validar configuración de zona horaria - Bogotá
# Bootcamp Bash - Dev Container Setup

set -euo pipefail

echo "🌍 Validando configuración de zona horaria..."

# Verificar zona horaria configurada
current_tz=$(timedatectl show --property=Timezone --value 2>/dev/null || cat /etc/timezone 2>/dev/null || echo "desconocida")
expected_tz="America/Bogota"

echo "Zona horaria actual: $current_tz"
echo "Zona horaria esperada: $expected_tz"

# Verificar si la zona horaria es correcta
if [[ "$current_tz" == "$expected_tz" ]]; then
    echo "✅ Zona horaria configurada correctamente"
else
    echo "⚠️  Zona horaria no coincide, intentando corregir..."
    
    # Intentar configurar la zona horaria
    if command -v timedatectl >/dev/null 2>&1; then
        sudo timedatectl set-timezone "$expected_tz"
        echo "✅ Zona horaria actualizada con timedatectl"
    else
        # Método alternativo
        echo "$expected_tz" | sudo tee /etc/timezone >/dev/null
        sudo ln -sf "/usr/share/zoneinfo/$expected_tz" /etc/localtime
        echo "✅ Zona horaria actualizada manualmente"
    fi
fi

# Mostrar información de fecha y hora actual
echo ""
echo "📅 Información de fecha y hora:"
echo "Fecha actual: $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "Zona horaria: $(date '+%z %Z')"

# Verificar variable de entorno TZ
if [[ "${TZ:-}" == "$expected_tz" ]]; then
    echo "✅ Variable de entorno TZ configurada correctamente: $TZ"
else
    echo "⚠️  Variable de entorno TZ: ${TZ:-'no configurada'}"
    export TZ="$expected_tz"
    echo "✅ Variable TZ actualizada a: $TZ"
fi

echo ""
echo "🎯 Configuración de zona horaria completada"
