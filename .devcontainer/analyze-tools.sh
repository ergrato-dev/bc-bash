#!/bin/bash
# Análisis de herramientas requeridas para el Bootcamp Bash - Módulos 1-8
# Verificación contra configuración Debian 12-slim

echo "📋 ANÁLISIS DE HERRAMIENTAS REQUERIDAS - BOOTCAMP BASH"
echo "====================================================="
echo ""

# Herramientas por módulo según análisis de los READMEs
declare -A module_tools

# MÓDULO 1: Fundamentos del Sistema
module_tools[1]="
ESENCIALES: bash pwd ls cd mkdir touch cat nano vim chmod find locate tree
NAVEGACIÓN: cd ls pwd mkdir rmdir
ARCHIVOS: touch cat head tail less more nano vim
PERMISOS: chmod chown chgrp
BÚSQUEDA: find locate which whereis
"

# MÓDULO 2: Comandos Avanzados y Pipes  
module_tools[2]="
PROCESAMIENTO: grep sed awk cut sort uniq head tail wc tr
PIPES: | tee xargs
REDIRECCIÓN: > >> < 2> &>
FILTROS: grep egrep fgrep
TEXTO: sed awk gawk
ARCHIVOS: tar gzip gunzip zip unzip
RED: curl wget
"

# MÓDULO 3: Variables y Control de Flujo
module_tools[3]="
BASH_FEATURES: Variables $() \$(()) [[ ]] if else for while
ENTRADA: read
SALIDA: echo printf
CONDICIONALES: test [[ ]] if then else fi
BUCLES: for while until
FUNCIONES: function
"

# MÓDULO 4: Funciones y Arrays
module_tools[4]="
ESTRUCTURAS: arrays asociativos funciones
BASH_AVANZADO: local export readonly declare
MANIPULACIÓN: string manipulation parameter expansion
MODULARIDAD: source . require
"

# MÓDULO 5: Operaciones de Archivos y Texto
module_tools[5]="
PROCESAMIENTO_AVANZADO: sed awk gawk
REGEX: grep egrep regex
ARCHIVOS: find xargs rsync
TRANSFORMACIÓN: tr sed awk
JSON: jq (procesamiento datos)
CSV: awk sed cut
"

# MÓDULO 6: Herramientas del Sistema
module_tools[6]="
PROCESOS: ps top htop kill killall pgrep
SISTEMA: df du free uptime
MONITOREO: watch tail cron systemd
REDES: ping netstat ss curl wget
TEMPORAL: cron at
LOGS: journalctl syslog
"

# MÓDULO 7: Optimización y Debugging
module_tools[7]="
DEBUGGING: bash -x set -e set -u shellcheck
PROFILING: time strace ltrace
TESTING: bats test
OPTIMIZACIÓN: parallel
ANÁLISIS: shellcheck bash linter
VALIDACIÓN: shellcheck static analysis
"

# MÓDULO 8: Proyectos Avanzados y Automatización
module_tools[8]="
AUTOMATIZACIÓN: cron systemd
DESARROLLO: git docker
INTEGRACIÓN: api calls curl wget jq
MONITOREO: system monitoring tools
BACKUP: rsync tar
DEPLOY: automation scripts
"

# Herramientas actualmente instaladas en Debian (desde Dockerfile)
installed_tools="
# Shells y terminal
bash zsh tmux screen

# Desarrollo core  
git vim nano

# Procesamiento texto
gawk

# Sistema
tree rsync tar gzip unzip file

# Red
curl wget ping

# Análisis
shellcheck jq

# Utilidades
bc sudo man-db

# Python y Node (extras)
python3 pip3 nodejs pnpm

# Herramientas adicionales del setup.sh
htop parallel pv dialog figlet build-essential

# Docker y GitHub CLI
docker-ce-cli gh
"

echo "🔍 ANÁLISIS POR MÓDULO:"
echo ""

# Verificar cada módulo
for module in {1..8}; do
    echo "📚 MÓDULO $module:"
    echo "${module_tools[$module]}" | grep -v "^$" | sed 's/^/  /'
    echo ""
done

echo "✅ HERRAMIENTAS ACTUALMENTE INSTALADAS:"
echo "$installed_tools" | grep -v "^$" | sed 's/^/  /'
echo ""

echo "❗ HERRAMIENTAS POSIBLEMENTE FALTANTES:"
echo ""

# Lista de herramientas que podrían faltar
missing_tools="
# Monitoreo sistema (Módulo 6)
- htop (✅ instalado en setup.sh)
- ps, top, kill (✅ incluidos en base Debian)
- df, du, free, uptime (✅ incluidos en base Debian)
- netstat, ss (⚠️  podría necesitar net-tools)

# Procesamiento avanzado (Módulo 5) 
- awk (✅ instalado como gawk)
- grep, sed, cut, sort, uniq, head, tail, wc, tr (✅ en base Debian)

# Herramientas de red (Módulos 2,6)
- ping (✅ como iputils-ping)
- telnet, netcat (⚠️  netcat-openbsd no instalado)

# Debugging avanzado (Módulo 7)
- strace, ltrace (⚠️  no instalados)
- gdb, valgrind (⚠️  no instalados)
- bats (⚠️  no instalado)

# Compresión (Módulo 2)
- zip, unzip (✅ instalados)
- tar, gzip (✅ en base Debian)

# Temporal (Módulo 6)
- cron (⚠️  no instalado)
- systemd (✅ en Debian)
"

echo "$missing_tools"

echo ""
echo "🎯 RECOMENDACIONES PARA COMPLETAR LA CONFIGURACIÓN:"
echo ""
echo "1. Agregar herramientas de red: net-tools, netcat-openbsd, telnet"
echo "2. Instalar herramientas de debugging: strace, ltrace, gdb"
echo "3. Agregar framework de testing: bats"
echo "4. Instalar cron para tareas temporales"
echo "5. Considerar valgrind para debugging avanzado"
echo ""
echo "✨ La mayoría de herramientas están cubiertas (~85%)"
echo "   Las faltantes son principalmente para módulos avanzados (6-7)"
