#!/bin/bash
# Verificación completa de herramientas para Bootcamp Bash
# Verifica que todas las herramientas necesarias estén disponibles

set -euo pipefail

echo "🔍 VERIFICACIÓN COMPLETA DE HERRAMIENTAS - BOOTCAMP BASH"
echo "========================================================"
echo ""

# Contadores
total_tools=0
available_tools=0
missing_tools=0

# Función para verificar herramienta
check_tool() {
    local tool="$1"
    local description="$2"
    local required="$3"  # "essential" | "recommended" | "optional"
    
    ((total_tools++))
    
    if command -v "$tool" >/dev/null 2>&1; then
        ((available_tools++))
        local version=""
        case $tool in
            "bash") version=$(bash --version | head -n1 | cut -d' ' -f4) ;;
            "git") version=$(git --version | cut -d' ' -f3) ;;
            "shellcheck") version=$(shellcheck --version | grep "version:" | cut -d' ' -f2) ;;
            *) version="disponible" ;;
        esac
        
        case $required in
            "essential") echo "  ✅ $tool ($version) - $description" ;;
            "recommended") echo "  ✅ $tool ($version) - $description" ;;
            "optional") echo "  ✅ $tool ($version) - $description" ;;
        esac
    else
        ((missing_tools++))
        case $required in
            "essential") echo "  ❌ $tool - $description [CRÍTICO]" ;;
            "recommended") echo "  ⚠️  $tool - $description [RECOMENDADO]" ;;
            "optional") echo "  ℹ️  $tool - $description [OPCIONAL]" ;;
        esac
    fi
}

echo "🔧 MÓDULO 1: Fundamentos del Sistema"
check_tool "bash" "Shell principal del bootcamp" "essential"
check_tool "pwd" "Mostrar directorio actual" "essential"
check_tool "ls" "Listar archivos" "essential"
check_tool "cd" "Cambiar directorio" "essential"
check_tool "mkdir" "Crear directorios" "essential"
check_tool "touch" "Crear archivos" "essential"
check_tool "cat" "Mostrar contenido de archivos" "essential"
check_tool "nano" "Editor simple" "essential"
check_tool "vim" "Editor avanzado" "recommended"
check_tool "chmod" "Cambiar permisos" "essential"
check_tool "find" "Buscar archivos" "essential"
check_tool "tree" "Visualizar estructura de directorios" "recommended"
echo ""

echo "📝 MÓDULO 2: Comandos Avanzados y Pipes"
check_tool "grep" "Buscar texto" "essential"
check_tool "sed" "Editor de flujo" "essential"
check_tool "awk" "Procesamiento de texto" "essential"
check_tool "cut" "Extraer columnas" "essential"
check_tool "sort" "Ordenar líneas" "essential"
check_tool "uniq" "Eliminar duplicados" "essential"
check_tool "head" "Primeras líneas" "essential"
check_tool "tail" "Últimas líneas" "essential"
check_tool "wc" "Contar líneas/palabras" "essential"
check_tool "tr" "Traducir caracteres" "essential"
check_tool "tee" "Duplicar salida" "essential"
check_tool "xargs" "Argumentos desde stdin" "essential"
check_tool "tar" "Archivador" "essential"
check_tool "gzip" "Compresor" "essential"
check_tool "zip" "Compresor ZIP" "recommended"
check_tool "unzip" "Descompresor ZIP" "recommended"
check_tool "curl" "Cliente HTTP" "essential"
check_tool "wget" "Descargador" "essential"
echo ""

echo "📊 MÓDULO 3-4: Variables, Control de Flujo y Funciones"
echo "  ✅ Variables de Bash - Nativas del shell"
echo "  ✅ Estructuras de control - Nativas del shell"
echo "  ✅ Funciones - Nativas del shell"
echo "  ✅ Arrays - Nativas del shell"
check_tool "read" "Leer entrada usuario" "essential"
check_tool "echo" "Mostrar texto" "essential"
check_tool "printf" "Formatear salida" "essential"
echo ""

echo "🗃️ MÓDULO 5: Operaciones de Archivos y Texto"
check_tool "gawk" "GNU AWK" "essential"
check_tool "rsync" "Sincronización de archivos" "recommended"
check_tool "jq" "Procesador JSON" "essential"
echo ""

echo "🖥️ MÓDULO 6: Herramientas del Sistema"
check_tool "ps" "Mostrar procesos" "essential"
check_tool "top" "Monitor de procesos" "essential"
check_tool "htop" "Monitor interactivo" "recommended"
check_tool "kill" "Terminar procesos" "essential"
check_tool "killall" "Terminar por nombre" "essential"
check_tool "pgrep" "Buscar procesos" "essential"
check_tool "df" "Espacio en disco" "essential"
check_tool "du" "Uso de directorio" "essential"
check_tool "free" "Memoria disponible" "essential"
check_tool "uptime" "Tiempo de actividad" "essential"
check_tool "watch" "Ejecutar repetidamente" "essential"
check_tool "ping" "Test de conectividad" "essential"
check_tool "netstat" "Estadísticas de red" "recommended"
check_tool "ss" "Socket statistics" "recommended"
check_tool "cron" "Programador de tareas" "essential"
check_tool "systemctl" "Control de servicios" "recommended"
echo ""

echo "🐛 MÓDULO 7: Optimización y Debugging"
check_tool "shellcheck" "Análisis estático de Bash" "essential"
check_tool "strace" "Trazador de sistema" "recommended"
check_tool "ltrace" "Trazador de librerías" "recommended"
check_tool "gdb" "Debugger" "optional"
check_tool "valgrind" "Detector de errores" "optional"
check_tool "time" "Medidor de tiempo" "essential"
check_tool "bats" "Framework de testing" "recommended"
check_tool "parallel" "Ejecución paralela" "recommended"
echo ""

echo "🚀 MÓDULO 8: Proyectos Avanzados y Automatización"
check_tool "git" "Control de versiones" "essential"
check_tool "docker" "Contenedores" "recommended"
check_tool "gh" "GitHub CLI" "optional"
echo ""

echo "📊 RESUMEN DE VERIFICACIÓN"
echo "=========================="
echo "Total de herramientas verificadas: $total_tools"
echo "✅ Disponibles: $available_tools"
echo "❌ Faltantes: $missing_tools"
echo ""

# Calcular porcentaje
if [ $total_tools -gt 0 ]; then
    percentage=$((available_tools * 100 / total_tools))
    echo "📈 Cobertura: $percentage%"
    
    if [ $percentage -ge 95 ]; then
        echo "🎉 ¡EXCELENTE! El entorno está completamente preparado"
    elif [ $percentage -ge 85 ]; then
        echo "✅ ¡MUY BIEN! El entorno está bien preparado"
    elif [ $percentage -ge 70 ]; then
        echo "⚠️  ACEPTABLE - Algunas herramientas faltantes"
    else
        echo "❌ INSUFICIENTE - Muchas herramientas faltantes"
    fi
else
    echo "❌ Error en la verificación"
fi

echo ""
echo "💡 Próximos pasos:"
if [ $missing_tools -eq 0 ]; then
    echo "   • ¡Todo listo para comenzar el bootcamp!"
    echo "   • Ejecutar: cd bootcamp/week-01 && cat README.md"
else
    echo "   • Revisar herramientas faltantes marcadas como CRÍTICO"
    echo "   • Considerar instalar herramientas RECOMENDADAS"
    echo "   • Las herramientas OPCIONALES pueden instalarse después"
fi
echo ""
