#!/bin/bash
# Script de verificación para migración a Debian 12-slim
# Bootcamp Bash - Dev Container

set -euo pipefail

echo "🔍 VERIFICACIÓN DE MIGRACIÓN A DEBIAN 12-slim"
echo "=============================================="
echo ""

# Verificar información del sistema
echo "📋 Información del sistema base:"
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    echo "  Distribución: $NAME"
    echo "  Versión: $VERSION"
    echo "  ID: $ID"
    echo "  Versión ID: $VERSION_ID"
else
    echo "  ⚠️  No se pudo determinar la distribución"
fi
echo ""

# Verificar versión de Bash
echo "🐚 Verificación de Bash:"
bash_version=$(bash --version | head -n1)
echo "  $bash_version"
if [[ $bash_version == *"5."* ]]; then
    echo "  ✅ Bash 5.x instalado correctamente"
else
    echo "  ⚠️  Versión de Bash inesperada"
fi
echo ""

# Verificar herramientas esenciales instaladas
echo "🔧 Verificación de herramientas esenciales:"
tools=("git" "curl" "wget" "vim" "nano" "tree" "jq" "shellcheck")

for tool in "${tools[@]}"; do
    if command -v "$tool" >/dev/null 2>&1; then
        version=$($tool --version 2>/dev/null | head -n1 || echo "disponible")
        echo "  ✅ $tool: $version"
    else
        echo "  ❌ $tool: no encontrado"
    fi
done
echo ""

# Verificar configuración de timezone
echo "🌍 Verificación de zona horaria:"
current_tz=$(cat /etc/timezone 2>/dev/null || echo "no configurada")
echo "  Zona horaria: $current_tz"
echo "  Fecha actual: $(date '+%Y-%m-%d %H:%M:%S %Z')"
if [[ "$current_tz" == "America/Bogota" ]]; then
    echo "  ✅ Zona horaria configurada correctamente"
else
    echo "  ⚠️  Zona horaria no es la esperada"
fi
echo ""

# Verificar usuario y permisos
echo "👤 Verificación de usuario:"
echo "  Usuario actual: $(whoami)"
echo "  UID: $(id -u)"
echo "  GID: $(id -g)"
echo "  Grupos: $(groups)"
if [[ "$(whoami)" == "vscode" ]]; then
    echo "  ✅ Usuario vscode configurado correctamente"
else
    echo "  ⚠️  Usuario inesperado"
fi
echo ""

# Verificar tamaño de la imagen (aproximado)
echo "💾 Información de espacio:"
echo "  Uso de disco en /:"
df -h / | tail -1 | awk '{print "    Usado: " $3 " de " $2 " (" $5 ")"}'

echo "  Packages instalados:"
if command -v dpkg >/dev/null 2>&1; then
    package_count=$(dpkg -l | grep "^ii" | wc -l)
    echo "    Paquetes Debian: $package_count"
else
    echo "    ⚠️  dpkg no disponible"
fi
echo ""

# Verificar configuración de desarrollo
echo "🛠️  Verificación de entorno de desarrollo:"
if [[ -n "${BOOTCAMP_ENV:-}" ]]; then
    echo "  ✅ Variable BOOTCAMP_ENV: $BOOTCAMP_ENV"
else
    echo "  ⚠️  Variable BOOTCAMP_ENV no configurada"
fi

if [[ -n "${TZ:-}" ]]; then
    echo "  ✅ Variable TZ: $TZ"
else
    echo "  ⚠️  Variable TZ no configurada"
fi
echo ""

# Verificar shells disponibles
echo "🐚 Shells disponibles:"
while IFS= read -r shell; do
    shell_name=$(basename "$shell")
    if command -v "$shell_name" >/dev/null 2>&1; then
        echo "  ✅ $shell"
    else
        echo "  ❌ $shell (no funcional)"
    fi
done < /etc/shells
echo ""

echo "🎯 Verificación de migración a Debian completada"
echo ""
echo "💡 Beneficios de Debian 12-slim:"
echo "   • Imagen base más ligera (~27MB vs ~72MB Ubuntu)"
echo "   • Misma compatibilidad de paquetes (apt)"
echo "   • Mayor estabilidad y seguridad"
echo "   • Bash 5.x nativo y optimizado"
echo "   • Ideal para aprendizaje de scripting"
