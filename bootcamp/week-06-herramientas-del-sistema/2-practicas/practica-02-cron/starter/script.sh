#!/bin/bash
# ============================================
# PRÁCTICA 02: Automatización con Cron
# Semana 6 - Herramientas del Sistema
# ============================================

set -euo pipefail

echo "========================================"
echo "⏰ PRÁCTICA 02: Automatización con Cron"
echo "========================================"
echo ""

# ============================================
# PASO 1: Sintaxis Básica de Cron
# ============================================
echo "--- Paso 1: Sintaxis Básica ---"

# La sintaxis de cron tiene 5 campos de tiempo
# seguidos del comando a ejecutar

# Descomenta las siguientes líneas:
# echo "Estructura de una entrada cron:"
# echo ""
# echo "┌─────── minuto (0-59)"
# echo "│ ┌───── hora (0-23)"
# echo "│ │ ┌─── día del mes (1-31)"
# echo "│ │ │ ┌─ mes (1-12)"
# echo "│ │ │ │ ┌ día semana (0-7, dom=0,7)"
# echo "│ │ │ │ │"
# echo "* * * * * comando"
# echo ""
# echo "Ejemplo: '30 14 * * *' = 14:30 todos los días"

echo ""

# ============================================
# PASO 2: Operadores de Cron
# ============================================
echo "--- Paso 2: Operadores de Cron ---"

# Operadores: * (todos), , (lista), - (rango), / (intervalo)

# Descomenta las siguientes líneas:
# echo "Operadores disponibles:"
# echo ""
# echo "  *     Todos los valores"
# echo "        '* * * * *' = cada minuto"
# echo ""
# echo "  ,     Lista de valores"
# echo "        '0,30 * * * *' = minuto 0 y 30"
# echo ""
# echo "  -     Rango de valores"  
# echo "        '0 9-17 * * *' = cada hora de 9am a 5pm"
# echo ""
# echo "  /     Intervalo"
# echo "        '*/5 * * * *' = cada 5 minutos"
# echo "        '0 */2 * * *' = cada 2 horas"

echo ""

# ============================================
# PASO 3: Atajos de Cron
# ============================================
echo "--- Paso 3: Atajos Especiales ---"

# Cron incluye atajos para expresiones comunes

# Descomenta las siguientes líneas:
# echo "Atajos de cron:"
# echo ""
# echo "  @reboot   Al iniciar el sistema"
# echo "  @yearly   Una vez al año     (0 0 1 1 *)"
# echo "  @monthly  Una vez al mes     (0 0 1 * *)"
# echo "  @weekly   Una vez a la semana (0 0 * * 0)"
# echo "  @daily    Una vez al día     (0 0 * * *)"
# echo "  @hourly   Una vez por hora   (0 * * * *)"
# echo ""
# echo "Ejemplo: '@daily /scripts/backup.sh'"

echo ""

# ============================================
# PASO 4: Validar Expresiones Cron
# ============================================
echo "--- Paso 4: Validar Expresiones ---"

# Función para explicar una expresión cron simple

# Descomenta las siguientes líneas:
# explain_cron() {
#     local expr="$1"
#     local minute hour day_month month day_week
#     
#     read minute hour day_month month day_week <<< "$expr"
#     
#     echo "Expresión: $expr"
#     echo "  Minuto:        $minute"
#     echo "  Hora:          $hour"
#     echo "  Día del mes:   $day_month"
#     echo "  Mes:           $month"
#     echo "  Día semana:    $day_week"
# }
# 
# echo "Analizando expresiones cron:"
# echo ""
# explain_cron "0 3 * * *"
# echo "→ Todos los días a las 3:00 AM"
# echo ""
# explain_cron "*/15 * * * *"
# echo "→ Cada 15 minutos"
# echo ""
# explain_cron "0 9 * * 1-5"
# echo "→ Lunes a viernes a las 9:00 AM"

echo ""

# ============================================
# PASO 5: Gestión de Crontab
# ============================================
echo "--- Paso 5: Gestión de Crontab ---"

# Comandos para gestionar tu crontab

# Descomenta las siguientes líneas:
# echo "Comandos de crontab:"
# echo ""
# echo "  crontab -l    Listar tareas actuales"
# echo "  crontab -e    Editar crontab"
# echo "  crontab -r    Eliminar crontab"
# echo ""
# echo "Tu crontab actual:"
# if crontab -l 2>/dev/null; then
#     echo "(tareas listadas arriba)"
# else
#     echo "(sin tareas programadas)"
# fi

echo ""

# ============================================
# PASO 6: Ejemplos Prácticos
# ============================================
echo "--- Paso 6: Ejemplos Prácticos ---"

# Ejemplos de tareas cron comunes

# Descomenta las siguientes líneas:
# echo "Ejemplos de tareas cron comunes:"
# echo ""
# echo "# Backup diario a las 3am"
# echo "0 3 * * * /scripts/backup.sh >> /var/log/backup.log 2>&1"
# echo ""
# echo "# Limpieza semanal (domingo medianoche)"
# echo "0 0 * * 0 /scripts/cleanup.sh"
# echo ""
# echo "# Monitoreo cada 5 minutos"
# echo "*/5 * * * * /scripts/check-health.sh"
# echo ""
# echo "# Reporte mensual (día 1 a las 8am)"
# echo "0 8 1 * * /scripts/monthly-report.sh"
# echo ""
# echo "# Script al reiniciar"
# echo "@reboot /scripts/startup.sh"

echo ""

# ============================================
# PASO 7: Buenas Prácticas
# ============================================
echo "--- Paso 7: Buenas Prácticas ---"

# Tips para trabajar con cron

# Descomenta las siguientes líneas:
# echo "Buenas prácticas con cron:"
# echo ""
# echo "1. Usar rutas ABSOLUTAS en scripts"
# echo "   ✗ script.sh"
# echo "   ✓ /home/user/scripts/script.sh"
# echo ""
# echo "2. Redirigir output a logs"
# echo "   comando >> /var/log/cron.log 2>&1"
# echo ""
# echo "3. Probar scripts manualmente primero"
# echo "   chmod +x script.sh && ./script.sh"
# echo ""
# echo "4. Documentar cada tarea"
# echo "   # Backup diario de database"
# echo "   0 3 * * * /scripts/db-backup.sh"
# echo ""
# echo "5. Usar variables de entorno si es necesario"
# echo "   PATH=/usr/local/bin:/usr/bin:/bin"

echo ""

# ============================================
# PASO 8: Simulador de Cron Schedule
# ============================================
echo "--- Paso 8: Simulador ---"

# Función que determina próxima ejecución aproximada

# Descomenta las siguientes líneas:
# simulate_next_run() {
#     local desc="$1"
#     local minute hour day_month month day_week
#     
#     case "$desc" in
#         "cada_minuto")
#             echo "Próxima: en menos de 1 minuto"
#             ;;
#         "cada_5_min")
#             local current_min=$(date +%M)
#             local next=$((5 - (current_min % 5)))
#             echo "Próxima: en ~$next minutos"
#             ;;
#         "cada_hora")
#             local current_min=$(date +%M)
#             local next=$((60 - current_min))
#             echo "Próxima: en ~$next minutos"
#             ;;
#         "diario_3am")
#             echo "Próxima: mañana a las 3:00 AM"
#             ;;
#         *)
#             echo "Descripción no reconocida"
#             ;;
#     esac
# }
# 
# echo "Simulando próximas ejecuciones:"
# echo ""
# echo "'* * * * *' (cada minuto):"
# simulate_next_run "cada_minuto"
# echo ""
# echo "'*/5 * * * *' (cada 5 minutos):"
# simulate_next_run "cada_5_min"
# echo ""
# echo "'0 * * * *' (cada hora):"
# simulate_next_run "cada_hora"
# echo ""
# echo "'0 3 * * *' (diario 3am):"
# simulate_next_run "diario_3am"

echo ""

echo "========================================"
echo "✅ Práctica 02 completada"
echo "========================================"
echo ""
echo "💡 Para practicar cron real:"
echo "   - Visita https://crontab.guru para validar expresiones"
echo "   - Usa 'crontab -e' para editar tu crontab"
