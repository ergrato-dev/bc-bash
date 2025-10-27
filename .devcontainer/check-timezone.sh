#!/bin/bash
# Utilidad para verificar y mostrar información de zona horaria
# Bootcamp Bash - Dev Container

echo "🌍 INFORMACIÓN DE ZONA HORARIA - BOGOTÁ"
echo "======================================="
echo ""

# Información básica de fecha y hora
echo "📅 Fecha y hora actual:"
echo "  $(date '+%A, %B %d, %Y')"
echo "  $(date '+%H:%M:%S %Z (UTC%z)')"
echo ""

# Información de zona horaria
echo "🌐 Configuración de zona horaria:"
echo "  Zona horaria del sistema: $(cat /etc/timezone 2>/dev/null || echo 'No disponible')"
echo "  Variable TZ: ${TZ:-'No configurada'}"
echo "  Enlace simbólico: $(readlink /etc/localtime 2>/dev/null || echo 'No disponible')"
echo ""

# Verificar si timedatectl está disponible
if command -v timedatectl >/dev/null 2>&1; then
    echo "⚙️  Información de timedatectl:"
    timedatectl show --property=Timezone,LocalRTC,NTP | sed 's/^/  /'
    echo ""
fi

# Información adicional útil para desarrollo
echo "🔧 Información adicional:"
echo "  Locale actual: ${LANG:-'No configurado'}"
echo "  LC_ALL: ${LC_ALL:-'No configurado'}"
echo "  Entorno: ${BOOTCAMP_ENV:-'No configurado'}"
echo ""

# Comparación con UTC
utc_time=$(TZ=UTC date '+%H:%M:%S')
local_time=$(date '+%H:%M:%S')
echo "⏰ Comparación de horarios:"
echo "  Hora UTC: $utc_time"
echo "  Hora local (Bogotá): $local_time"
echo ""

# Test de zona horaria específica
if [[ "$(date +%z)" == "-0500" ]]; then
    echo "✅ Zona horaria configurada correctamente para Bogotá (UTC-5)"
else
    echo "⚠️  Posible problema con la configuración de zona horaria"
    echo "   Offset actual: $(date +%z)"
    echo "   Esperado: -0500"
fi
