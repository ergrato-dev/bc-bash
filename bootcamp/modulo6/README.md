<div align="center">
  <img src="../assets/module-6-logo.svg" alt="Módulo 6: Herramientas del Sistema" width="300">
</div>

# MÓDULO 6: HERRAMIENTAS DEL SISTEMA

**Bootcamp Bash Scripting - Semana 6**

## 🎯 VISIÓN GENERAL DEL MÓDULO

El Módulo 6 marca una transición fundamental en tu desarrollo como programador de bash. Hasta ahora has aprendido a procesar y analizar datos. Ahora aprenderás a **controlar y monitorear sistemas completos**. Es la diferencia entre ser un analista de datos y ser el arquitecto que diseña y mantiene toda la infraestructura.

### 🎯 Objetivos de Aprendizaje

Al completar este módulo, serás capaz de:

- **Gestionar procesos** de manera avanzada con monitoreo y control automatizado
- **Automatizar tareas** con programación temporal y cron jobs inteligentes
- **Monitorear sistemas** proactivamente con alertas y métricas en tiempo real
- **Controlar servicios** y demonios del sistema de manera profesional
- **Implementar logging** avanzado y sistemas de auditoría
- **Crear herramientas** de administración de sistemas robustas y escalables

### 🌟 ¿Por qué es crucial este módulo?

En el mundo profesional, no basta con saber programar. Los **administradores de sistemas**, **DevOps engineers**, y **SREs** (Site Reliability Engineers) necesitan herramientas que mantengan los sistemas funcionando 24/7. Este módulo te enseña a crear esas herramientas.

### 📚 Estructura del Módulo

#### **Lección 6.1: Gestión Avanzada de Procesos**

- Monitoreo de procesos en tiempo real
- Control avanzado con señales y estados
- Automatización de gestión de recursos
- Creación de supervisores de procesos

#### **Lección 6.2: Automatización Temporal y Cron Jobs**

- Programación avanzada con cron
- Scripts de mantenimiento automatizado
- Gestión de logs rotativos
- Backup y sincronización automática

#### **Lección 6.3: Monitoreo de Sistema y Alertas**

- Métricas de sistema en tiempo real
- Sistemas de alertas inteligentes
- Dashboards de monitoreo
- Integración con herramientas de notificación

#### **Proyecto Práctico 6: Sistema de Monitoreo Empresarial**

- Monitor completo de infraestructura
- Alertas automáticas por email/Slack
- Dashboard web en tiempo real
- Reportes automatizados
  El Módulo 6 marca una transición fundamental en tu desarrollo. Hasta ahora has aprendido a procesar y analizar datos. Ahora aprenderás a controlar y monitorear sistemas completos. Es la diferencia entre ser un analista de datos y ser el arquitecto que diseña y mantiene toda la infraestructura.

Imagina que eres el capitán de un barco. Los módulos anteriores te enseñaron a leer mapas, interpretar instrumentos, y analizar datos meteorológicos. El Módulo 6 te enseñará a controlar todos los sistemas del barco: motores, navegación, comunicaciones, y monitoreo en tiempo real de cada componente crítico.

Lo que vas a dominar:
🔧 Gestión Avanzada de Procesos: Controlar, monitorear y orquestar procesos como un director de orquesta
⏰ Automatización Temporal: Programar tareas para que tu sistema funcione solo, 24/7
📊 Monitoreo Proactivo: Crear sistemas que detecten problemas antes de que ocurran
🚨 Alertas Inteligentes: Configurar notificaciones que te mantengan informado sin abrumarte

La Progresión Lógica
Mira cómo cada módulo ha construido sobre el anterior:

Módulo 3: Variables y control de flujo (fundamentos)
Módulo 4: Funciones y estructuras (organización)
Módulo 5: Manipulación de datos (análisis)
Módulo 6: Herramientas del sistema (control y monitoreo)
Es una progresión natural desde entender datos hasta controlar sistemas completos.

---

## 🚀 LECCIÓN 6.1: GESTIÓN AVANZADA DE PROCESOS

### Introducción Conceptual: Los Procesos como Ciudadanos del Sistema

Un sistema Unix/Linux es como una ciudad vibrante donde los **procesos son los ciudadanos**. Cada proceso tiene:

- Una **identidad** (PID - Process ID)
- Una **familia** (proceso padre e hijos)
- Una **ocupación** (el comando que ejecuta)
- **Recursos** que consume (CPU, memoria, archivos abiertos)

Como administrador de sistemas, eres el **alcalde de esta ciudad digital**. Tu trabajo es:

- Identificar ciudadanos problemáticos (procesos que consumen demasiados recursos)
- Mediar conflictos (procesos que compiten por recursos)
- Mantener el orden general (asegurar que el sistema funcione eficientemente)

### 🔧 Herramientas Fundamentales

#### **ps - El Censo de Procesos**

```bash
# Procesos básicos
ps aux

# Procesos en formato de árbol (familia)
ps auxf

# Procesos específicos por usuario
ps -u username

# Procesos ordenados por uso de CPU
ps aux --sort=-%cpu

# Procesos ordenados por uso de memoria
ps aux --sort=-%mem

# Formato personalizado
ps -eo pid,ppid,cmd,%cpu,%mem,user
```

#### **top/htop - El Monitor en Tiempo Real**

```bash
# Monitor básico
top

# Monitor mejorado (si está instalado)
htop

# Top con filtros específicos
top -p 1234,5678  # Solo PIDs específicos
top -u username   # Solo procesos de un usuario
```

#### **pgrep/pkill - Búsqueda y Control Inteligente**

```bash
# Encontrar procesos por nombre
pgrep firefox
pgrep -f "python script.py"

# Encontrar procesos con información adicional
pgrep -l nginx
pgrep -u username

# Terminar procesos de manera inteligente
pkill firefox
pkill -f "python.*script"
pkill -u username
```

### 📊 Script Práctico: Monitor de Procesos Avanzado

Vamos a crear un script que monitorea procesos de manera inteligente:

```bash
#!/bin/bash
# process_monitor.sh - Monitor avanzado de procesos
set -euo pipefail

# Configuración
readonly SCRIPT_NAME="$(basename "$0")"
readonly LOG_FILE="/var/log/${SCRIPT_NAME}.log"
readonly CONFIG_FILE="/etc/${SCRIPT_NAME}.conf"

# Umbrales por defecto
declare -A THRESHOLDS=(
    ["cpu_warning"]="80"
    ["cpu_critical"]="95"
    ["memory_warning"]="80"
    ["memory_critical"]="95"
    ["max_processes"]="1000"
)

# Colores para output
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly GREEN='\033[0;32m'
readonly NC='\033[0m'

# Función de logging
log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

# Cargar configuración
load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
        log_message "INFO" "Configuración cargada desde $CONFIG_FILE"
    fi
}

# Obtener información del sistema
get_system_info() {
    local cpu_usage
    local memory_usage
    local total_processes

    # CPU usage (promedio de 1 minuto)
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)

    # Memory usage
    memory_usage=$(free | grep Mem | awk '{printf "%.1f", ($3/$2) * 100.0}')

    # Total de procesos
    total_processes=$(ps aux | wc -l)

    echo "$cpu_usage:$memory_usage:$total_processes"
}

# Función principal
main() {
    echo "🖥️  MONITOR DE PROCESOS AVANZADO"
    echo "================================"
    echo ""

    # Cargar configuración
    load_config

    # Obtener información del sistema
    local system_info
    system_info=$(get_system_info)
    IFS=':' read -r cpu_usage memory_usage total_processes <<< "$system_info"

    echo "📊 ESTADO ACTUAL DEL SISTEMA:"
    echo "  CPU: ${cpu_usage}%"
    echo "  Memoria: ${memory_usage}%"
    echo "  Procesos: $total_processes"
    echo ""
}

# Verificar si se ejecuta como script principal
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
```

### 🎯 Casos de Uso Prácticos

#### **1. Automatizar la gestión de procesos problemáticos**

```bash
#!/bin/bash
# auto_process_manager.sh - Gestión automática de procesos

# Terminar procesos que usan más del 90% de CPU por más de 5 minutos
kill_cpu_hogs() {
    local threshold=90
    local duration=300  # 5 minutos

    ps -eo pid,pcpu,etime,cmd --no-headers | while read -r pid cpu etime cmd; do
        # Convertir etime a segundos (simplificado)
        if [[ $(echo "$cpu > $threshold" | bc) -eq 1 ]] && [[ "$etime" =~ ([0-9]+):([0-9]+) ]]; then
            local minutes=${BASH_REMATCH[1]}
            local seconds=${BASH_REMATCH[2]}
            local total_seconds=$((minutes * 60 + seconds))

            if [[ $total_seconds -gt $duration ]]; then
                echo "Terminando proceso PID $pid (CPU: ${cpu}%, tiempo: $etime)"
                kill -TERM "$pid"
                sleep 10
                kill -KILL "$pid" 2>/dev/null || true
            fi
        fi
    done
}
```

#### **2. Monitor de servicios críticos**

```bash
#!/bin/bash
# service_monitor.sh - Monitor de servicios críticos

monitor_services() {
    local services=("sshd" "nginx" "mysql" "postgresql")
    local alerts=()

    for service in "${services[@]}"; do
        if ! systemctl is-active --quiet "$service"; then
            alerts+=("$service")
            echo "🚨 SERVICIO CAÍDO: $service"

            # Intentar reiniciar
            if systemctl restart "$service"; then
                echo "✅ $service reiniciado exitosamente"
            else
                echo "❌ Error al reiniciar $service"
            fi
        fi
    done

    # Enviar alerta si hay servicios caídos
    if [[ ${#alerts[@]} -gt 0 ]]; then
        local message="Servicios caídos: ${alerts[*]}"
        echo "$message" | mail -s "ALERTA: Servicios críticos" admin@empresa.com
    fi
}
```

---

## 🕐 LECCIÓN 6.2: AUTOMATIZACIÓN TEMPORAL Y CRON JOBS

### Introducción Conceptual: El Tiempo como Aliado

La automatización temporal es como tener un **asistente personal que nunca duerme**. Mientras tú descansas, tu sistema puede estar:

- Realizando backups automáticos
- Limpiando archivos temporales
- Actualizando bases de datos
- Enviando reportes programados
- Monitoreando el estado del sistema

### 🔧 Cron: El Programador Maestro

#### **Sintaxis de Crontab**

```bash
# Formato: minuto hora día mes día_semana comando
# * * * * * comando_a_ejecutar
# | | | | |
# | | | | +--- Día de la semana (0-7, donde 0 y 7 = domingo)
# | | | +----- Mes (1-12)
# | | +------- Día del mes (1-31)
# | +--------- Hora (0-23)
# +----------- Minuto (0-59)

# Ejemplos básicos
0 2 * * * /path/to/backup.sh           # Cada día a las 2:00 AM
30 14 * * 1 /path/to/weekly.sh         # Cada lunes a las 2:30 PM
0 0 1 * * /path/to/monthly.sh          # Primer día de cada mes a medianoche
*/15 * * * * /path/to/check.sh         # Cada 15 minutos
0 9-17 * * 1-5 /path/to/business.sh    # Cada hora de 9 AM a 5 PM, lunes a viernes
```

#### **Gestión de Crontab**

```bash
# Ver crontab actual
crontab -l

# Editar crontab
crontab -e

# Eliminar crontab
crontab -r

# Instalar crontab desde archivo
crontab archivo_cron.txt

# Ver crontab de otro usuario (como root)
crontab -u username -l
```

### 📊 Script Práctico: Sistema de Backup Automatizado

```bash
#!/bin/bash
# automated_backup.sh - Sistema de backup inteligente
set -euo pipefail

# Configuración
readonly BACKUP_DIR="/backups"
readonly SOURCE_DIRS=("/home" "/etc" "/var/www")
readonly RETENTION_DAYS=30
readonly LOG_FILE="/var/log/backup.log"
readonly EMAIL="admin@empresa.com"

# Función de logging
log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

# Crear directorio de backup
create_backup_dir() {
    local date_str=$(date '+%Y-%m-%d_%H-%M-%S')
    local backup_path="${BACKUP_DIR}/${date_str}"

    mkdir -p "$backup_path"
    echo "$backup_path"
}

# Realizar backup
perform_backup() {
    local backup_path="$1"
    local total_size=0
    local success_count=0
    local error_count=0

    log_message "INFO" "Iniciando backup en: $backup_path"

    for source_dir in "${SOURCE_DIRS[@]}"; do
        if [[ -d "$source_dir" ]]; then
            local dir_name=$(basename "$source_dir")
            local backup_file="${backup_path}/${dir_name}.tar.gz"

            log_message "INFO" "Respaldando: $source_dir -> $backup_file"

            if tar -czf "$backup_file" -C "$(dirname "$source_dir")" "$(basename "$source_dir")" 2>/dev/null; then
                local size=$(stat -f%z "$backup_file" 2>/dev/null || stat -c%s "$backup_file" 2>/dev/null)
                total_size=$((total_size + size))
                success_count=$((success_count + 1))
                log_message "INFO" "Backup exitoso: $backup_file ($(numfmt --to=iec "$size"))"
            else
                error_count=$((error_count + 1))
                log_message "ERROR" "Error al respaldar: $source_dir"
            fi
        else
            log_message "WARN" "Directorio no encontrado: $source_dir"
        fi
    done

    # Resumen
    log_message "INFO" "Backup completado - Exitosos: $success_count, Errores: $error_count, Tamaño total: $(numfmt --to=iec "$total_size")"
}

# Limpiar backups antiguos
cleanup_old_backups() {
    log_message "INFO" "Limpiando backups antiguos (> $RETENTION_DAYS días)"

    find "$BACKUP_DIR" -type d -mtime +$RETENTION_DAYS -exec rm -rf {} \; 2>/dev/null || true

    local remaining=$(find "$BACKUP_DIR" -type d -maxdepth 1 | wc -l)
    log_message "INFO" "Backups restantes: $remaining"
}

# Enviar notificación
send_notification() {
    local status="$1"
    local details="$2"

    local subject="Backup $status - $(hostname) - $(date)"
    local body="
Backup Report
=============
Host: $(hostname)
Date: $(date)
Status: $status

Details:
$details

Log file: $LOG_FILE
"

    echo "$body" | mail -s "$subject" "$EMAIL" 2>/dev/null || log_message "WARN" "No se pudo enviar email de notificación"
}

# Función principal
main() {
    log_message "INFO" "=== INICIO DE BACKUP AUTOMATIZADO ==="

    # Verificar dependencias
    if ! command -v tar &> /dev/null; then
        log_message "ERROR" "tar no está instalado"
        exit 1
    fi

    # Crear directorio de backup
    local backup_path
    backup_path=$(create_backup_dir)

    # Realizar backup
    perform_backup "$backup_path"

    # Limpiar backups antiguos
    cleanup_old_backups

    # Enviar notificación
    send_notification "COMPLETED" "Backup realizado exitosamente en: $backup_path"

    log_message "INFO" "=== FIN DE BACKUP AUTOMATIZADO ==="
}

# Ejecutar si es el script principal
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
```

### 🎯 Casos de Uso Avanzados

#### **1. Mantenimiento automático del sistema**

```bash
#!/bin/bash
# system_maintenance.sh - Mantenimiento automático

# Crontab: 0 3 * * 0 /path/to/system_maintenance.sh

system_cleanup() {
    # Limpiar archivos temporales
    find /tmp -type f -mtime +7 -delete
    find /var/tmp -type f -mtime +30 -delete

    # Limpiar logs antiguos
    find /var/log -name "*.log" -mtime +90 -delete

    # Limpiar cache de paquetes
    apt-get clean 2>/dev/null || yum clean all 2>/dev/null || true

    echo "Sistema limpiado: $(date)"
}

update_system() {
    # Actualizar índice de paquetes
    apt-get update 2>/dev/null || yum check-update 2>/dev/null || true

    # Actualizar paquetes de seguridad
    unattended-upgrades 2>/dev/null || yum update -y --security 2>/dev/null || true

    echo "Sistema actualizado: $(date)"
}

main() {
    system_cleanup
    update_system
}

main "$@"
```

## Esta es la **Parte 1** del README regenerado del Módulo 6. ¿Te gustaría que continúe con la **Parte 2** que incluirá la **Lección 6.3: Monitoreo de Sistema y Alertas** y el **Proyecto Práctico 6**?

## 📊 LECCIÓN 6.3: MONITOREO DE SISTEMA Y ALERTAS

### Concepto: Vigilancia Proactiva del Sistema

El monitoreo no es solo observar; es **prevenir problemas antes de que ocurran**. Como un médico que hace chequeos regulares, tu sistema necesita diagnósticos constantes.

### 6.3.1 Métricas de Sistema en Tiempo Real

#### **Script: Monitor de Recursos (`resource_monitor.sh`)**

```bash
#!/bin/bash
# Monitor de recursos del sistema
# Autor: Bootcamp Bash
# Uso: ./resource_monitor.sh [intervalo_segundos]

set -euo pipefail

INTERVAL="${1:-5}"
LOG_FILE="/var/log/system_monitor.log"

get_cpu_usage() {
    grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$3+$4+$5)} END {print usage "%"}'
}

get_memory_usage() {
    free | grep Mem | awk '{printf "%.1f%%", $3/$2 * 100.0}'
}

get_disk_usage() {
    df -h / | awk 'NR==2 {print $5}'
}

get_load_average() {
    uptime | awk -F'load average:' '{print $2}' | sed 's/^ *//'
}

get_network_connections() {
    netstat -an | grep ESTABLISHED | wc -l
}

monitor_system() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local cpu=$(get_cpu_usage)
    local memory=$(get_memory_usage)
    local disk=$(get_disk_usage)
    local load=$(get_load_average)
    local connections=$(get_network_connections)

    # Formato de salida
    printf "%s | CPU: %s | MEM: %s | DISK: %s | LOAD: %s | CONN: %d\n" \
        "$timestamp" "$cpu" "$memory" "$disk" "$load" "$connections"

    # Log a archivo
    printf "%s,%s,%s,%s,%s,%d\n" \
        "$timestamp" "$cpu" "$memory" "$disk" "$load" "$connections" >> "$LOG_FILE"
}

main() {
    echo "🔍 Monitor de Sistema Iniciado (Intervalo: ${INTERVAL}s)"
    echo "📁 Logs: $LOG_FILE"
    echo "⏹️  Detener con Ctrl+C"
    echo

    while true; do
        monitor_system
        sleep "$INTERVAL"
    done
}

main "$@"
```

### 6.3.2 Sistema de Alertas Inteligentes

#### **Script: Sistema de Alertas (`alert_system.sh`)**

```bash
#!/bin/bash
# Sistema de alertas inteligente
# Autor: Bootcamp Bash
# Monitorea métricas y envía alertas cuando hay problemas

set -euo pipefail

CONFIG_FILE="/etc/monitor/alerts.conf"
ALERT_LOG="/var/log/alerts.log"

# Umbrales por defecto
CPU_THRESHOLD=80
MEMORY_THRESHOLD=85
DISK_THRESHOLD=90
LOAD_THRESHOLD=5.0

# Configuración de notificaciones
SLACK_WEBHOOK=""
EMAIL_TO="admin@empresa.com"
TELEGRAM_BOT_TOKEN=""
TELEGRAM_CHAT_ID=""

load_config() {
    [[ -f "$CONFIG_FILE" ]] && source "$CONFIG_FILE"
}

log_alert() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    echo "[$timestamp] [$level] $message" | tee -a "$ALERT_LOG"
}

send_slack_alert() {
    local message="$1"
    [[ -z "$SLACK_WEBHOOK" ]] && return 0

    curl -s -X POST -H 'Content-type: application/json' \
        --data "{\"text\":\"🚨 ALERTA: $message\"}" \
        "$SLACK_WEBHOOK" >/dev/null
}

send_email_alert() {
    local subject="$1"
    local message="$2"

    echo "$message" | mail -s "🚨 $subject" "$EMAIL_TO" 2>/dev/null || true
}

send_telegram_alert() {
    local message="$1"
    [[ -z "$TELEGRAM_BOT_TOKEN" || -z "$TELEGRAM_CHAT_ID" ]] && return 0

    curl -s -X POST \
        "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
        -d "chat_id=${TELEGRAM_CHAT_ID}" \
        -d "text=🚨 ALERTA: $message" >/dev/null
}

notify_alert() {
    local level="$1"
    local message="$2"

    log_alert "$level" "$message"

    case "$level" in
        "CRITICAL")
            send_slack_alert "$message"
            send_email_alert "ALERTA CRÍTICA" "$message"
            send_telegram_alert "$message"
            ;;
        "WARNING")
            send_slack_alert "$message"
            ;;
    esac
}

check_cpu() {
    local cpu_usage=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$3+$4+$5)} END {print usage}')

    if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
        notify_alert "WARNING" "CPU alta: ${cpu_usage}% (límite: ${CPU_THRESHOLD}%)"
    fi
}

check_memory() {
    local memory_percent=$(free | grep Mem | awk '{printf "%.1f", $3/$2 * 100.0}')

    if (( $(echo "$memory_percent > $MEMORY_THRESHOLD" | bc -l) )); then
        notify_alert "WARNING" "Memoria alta: ${memory_percent}% (límite: ${MEMORY_THRESHOLD}%)"
    fi
}

check_disk() {
    while IFS= read -r line; do
        local usage=$(echo "$line" | awk '{print $5}' | sed 's/%//')
        local mount=$(echo "$line" | awk '{print $6}')

        if [[ "$usage" -gt "$DISK_THRESHOLD" ]]; then
            notify_alert "CRITICAL" "Disco lleno: $mount ${usage}% (límite: ${DISK_THRESHOLD}%)"
        fi
    done < <(df -h | grep -vE '^Filesystem|tmpfs|cdrom')
}

check_load() {
    local load_1min=$(uptime | awk -F'load average:' '{print $2}' | awk -F, '{print $1}' | tr -d ' ')

    if (( $(echo "$load_1min > $LOAD_THRESHOLD" | bc -l) )); then
        notify_alert "WARNING" "Carga alta: $load_1min (límite: $LOAD_THRESHOLD)"
    fi
}

check_services() {
    local critical_services=("sshd" "nginx" "mysql" "docker")

    for service in "${critical_services[@]}"; do
        if ! systemctl is-active --quiet "$service" 2>/dev/null; then
            notify_alert "CRITICAL" "Servicio caído: $service"
        fi
    done
}

main() {
    load_config

    echo "🚨 Sistema de Alertas - $(date)"

    check_cpu
    check_memory
    check_disk
    check_load
    check_services

    echo "✅ Verificación completada"
}

main "$@"
```

### 6.3.3 Dashboard de Monitoreo

#### **Script: Dashboard Web Simple (`dashboard.sh`)**

```bash
#!/bin/bash
# Dashboard web simple para monitoreo
# Autor: Bootcamp Bash
# Genera página HTML con métricas del sistema

set -euo pipefail

HTML_FILE="/var/www/html/dashboard.html"
PORT=8080

generate_html() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local uptime=$(uptime -p)
    local cpu=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$3+$4+$5)} END {printf "%.1f", usage}')
    local memory=$(free | grep Mem | awk '{printf "%.1f", $3/$2 * 100.0}')
    local disk=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    local load=$(uptime | awk -F'load average:' '{print $2}' | awk -F, '{print $1}' | tr -d ' ')

cat > "$HTML_FILE" << EOF
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard del Sistema</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .header {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }
        .metrics {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .metric-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            border-left: 4px solid #007acc;
        }
        .metric-title {
            font-size: 14px;
            color: #666;
            text-transform: uppercase;
            margin-bottom: 10px;
        }
        .metric-value {
            font-size: 32px;
            font-weight: bold;
            color: #333;
        }
        .metric-unit {
            font-size: 16px;
            color: #888;
        }
        .status-good { border-left-color: #28a745; }
        .status-warning { border-left-color: #ffc107; }
        .status-critical { border-left-color: #dc3545; }
        .last-update {
            text-align: center;
            color: #666;
            font-size: 14px;
        }
    </style>
    <meta http-equiv="refresh" content="30">
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🖥️ Dashboard del Sistema</h1>
            <p>$uptime</p>
        </div>

        <div class="metrics">
            <div class="metric-card $(get_status_class "$cpu" 80 90)">
                <div class="metric-title">CPU Usage</div>
                <div class="metric-value">$cpu<span class="metric-unit">%</span></div>
            </div>

            <div class="metric-card $(get_status_class "$memory" 80 90)">
                <div class="metric-title">Memory Usage</div>
                <div class="metric-value">$memory<span class="metric-unit">%</span></div>
            </div>

            <div class="metric-card $(get_status_class "$disk" 80 90)">
                <div class="metric-title">Disk Usage</div>
                <div class="metric-value">$disk<span class="metric-unit">%</span></div>
            </div>

            <div class="metric-card status-good">
                <div class="metric-title">Load Average</div>
                <div class="metric-value">$load</div>
            </div>
        </div>

        <div class="last-update">
            Última actualización: $timestamp
        </div>
    </div>
</body>
</html>
EOF
}

get_status_class() {
    local value="$1"
    local warning_threshold="$2"
    local critical_threshold="$3"

    if (( $(echo "$value >= $critical_threshold" | bc -l) )); then
        echo "status-critical"
    elif (( $(echo "$value >= $warning_threshold" | bc -l) )); then
        echo "status-warning"
    else
        echo "status-good"
    fi
}

start_server() {
    echo "🚀 Iniciando servidor web en puerto $PORT"
    echo "📊 Dashboard: http://localhost:$PORT/dashboard.html"

    # Crear directorio si no existe
    mkdir -p "$(dirname "$HTML_FILE")"

    # Generar dashboard inicial
    generate_html

    # Actualizar cada 30 segundos
    while true; do
        sleep 30
        generate_html
    done &

    # Servidor web simple
    cd "$(dirname "$HTML_FILE")"
    python3 -m http.server "$PORT" 2>/dev/null || python -m SimpleHTTPServer "$PORT"
}

main() {
    case "${1:-start}" in
        "start")
            start_server
            ;;
        "generate")
            generate_html
            echo "✅ Dashboard generado: $HTML_FILE"
            ;;
        *)
            echo "Uso: $0 {start|generate}"
            exit 1
            ;;
    esac
}

main "$@"
```

---

## 🚀 PROYECTO PRÁCTICO 6: SISTEMA DE MONITOREO EMPRESARIAL

### Descripción del Proyecto

Vas a crear un **Sistema de Monitoreo Empresarial** completo que incluye:

- Monitoreo continuo de múltiples servidores
- Sistema de alertas multi-canal (email, Slack, Telegram)
- Dashboard web en tiempo real
- Reportes automatizados
- Sistema de backup y recuperación

### Arquitectura del Sistema

```
📁 monitoring-system/
├── 📄 monitor.sh              # Script principal
├── 📄 alerts.sh               # Sistema de alertas
├── 📄 dashboard.sh            # Dashboard web
├── 📄 reports.sh              # Generador de reportes
├── 📄 backup.sh               # Sistema de backup
├── 📁 config/
│   ├── 📄 servers.conf        # Lista de servidores
│   ├── 📄 alerts.conf         # Configuración de alertas
│   └── 📄 thresholds.conf     # Umbrales de métricas
├── 📁 logs/
├── 📁 reports/
└── 📁 web/
    ├── 📄 dashboard.html
    ├── 📄 style.css
    └── 📄 script.js
```

### Fase 1: Script Principal del Monitor

Crea el archivo `monitor.sh`:

```bash
#!/bin/bash
# Sistema de Monitoreo Empresarial
# Autor: [Tu nombre]
# Fecha: $(date '+%Y-%m-%d')

set -euo pipefail

# Configuración
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$BASE_DIR/config"
LOGS_DIR="$BASE_DIR/logs"
WEB_DIR="$BASE_DIR/web"

# Crear directorios necesarios
mkdir -p "$LOGS_DIR" "$WEB_DIR" "$CONFIG_DIR"

# Configuración de servidores
SERVERS_FILE="$CONFIG_DIR/servers.conf"
ALERTS_SCRIPT="$BASE_DIR/alerts.sh"
DASHBOARD_SCRIPT="$BASE_DIR/dashboard.sh"

# Tu implementación aquí...
```

### Requisitos del Proyecto

#### **Funcionalidades Obligatorias:**

1. **Monitoreo Multi-servidor**

   - SSH a servidores remotos
   - Recolección de métricas en paralelo
   - Manejo de errores de conexión

2. **Sistema de Alertas**

   - Múltiples canales de notificación
   - Escalamiento de alertas
   - Prevención de spam de alertas

3. **Dashboard Web**

   - Visualización en tiempo real
   - Gráficos de tendencias
   - Estado de servicios críticos

4. **Reportes Automatizados**

   - Reportes diarios/semanales/mensuales
   - Análisis de tendencias
   - Recomendaciones automáticas

5. **Sistema de Backup**
   - Backup de configuraciones
   - Rotación de logs
   - Recuperación automática

#### **Criterios de Evaluación:**

- **Funcionalidad** (30%): El sistema debe monitorear al menos 3 métricas diferentes
- **Robustez** (25%): Manejo adecuado de errores y fallos de red
- **Escalabilidad** (20%): Capacidad de agregar nuevos servidores fácilmente
- **Interfaz** (15%): Dashboard claro y fácil de usar
- **Documentación** (10%): README completo con instrucciones de instalación

### Casos de Uso Empresariales

#### **Caso 1: Empresa de E-commerce**

```bash
# Monitorear:
# - Servidores web (nginx/apache)
# - Bases de datos (MySQL/PostgreSQL)
# - Cache (Redis/Memcached)
# - Colas de trabajo (RabbitMQ)
```

#### **Caso 2: Startup de SaaS**

```bash
# Monitorear:
# - Microservicios en contenedores
# - APIs y tiempo de respuesta
# - Uso de memoria y CPU
# - Logs de errores
```

#### **Caso 3: Infraestructura DevOps**

```bash
# Monitorear:
# - Pipelines de CI/CD
# - Deployments automáticos
# - Métricas de aplicaciones
# - Costos de cloud
```

### Entregables

1. **Código fuente** completo del sistema
2. **Documentación** de instalación y uso
3. **Configuraciones** de ejemplo para diferentes entornos
4. **Video demo** (opcional) mostrando el sistema funcionando

### Tiempo Estimado: 4-6 horas

### Recursos Adicionales

- [Guía de SSH sin contraseña](../docs/ssh-keys-guide.md)
- [APIs de notificación](../docs/notification-apis.md)
- [Monitoreo con systemd](../docs/systemd-monitoring.md)

---

## 🎓 CONCLUSIONES DEL MÓDULO 6

### Lo que has aprendido

Al completar este módulo, has desarrollado habilidades de **nivel profesional** en:

1. **Gestión de Procesos**: Control total sobre los procesos del sistema
2. **Automatización**: Programación temporal y mantenimiento automático
3. **Monitoreo**: Vigilancia proactiva y sistemas de alertas
4. **Administración**: Herramientas de gestión de sistemas empresariales

### Aplicaciones en el Mundo Real

Estas habilidades te preparan para roles como:

- **Site Reliability Engineer (SRE)**
- **DevOps Engineer**
- **System Administrator**
- **Infrastructure Engineer**
- **Platform Engineer**

### Próximos Pasos

Con estas bases sólidas, estás listo para:

- **Módulo 7**: Optimización y Debugging Avanzado
- **Módulo 8**: Proyectos Avanzados y Automatización Empresarial

### Certificación del Módulo

Para obtener la certificación del Módulo 6:

1. ✅ Completa todos los ejercicios de las lecciones
2. ✅ Implementa el Proyecto Práctico 6
3. ✅ Supera el quiz de evaluación
4. ✅ Presenta tu sistema de monitoreo funcionando

---

## 🔗 NAVEGACIÓN DEL BOOTCAMP

| ← Anterior                                                        | Actual                                 | Siguiente →                                                |
| ----------------------------------------------------------------- | -------------------------------------- | ---------------------------------------------------------- |
| [Módulo 5: Procesamiento Avanzado de Datos](../modulo5/README.md) | **Módulo 6: Herramientas del Sistema** | [Módulo 7: Optimización y Debugging](../modulo7/README.md) |

---

<div align="center">
  <p><strong>¡Felicitaciones! Has completado el Módulo 6 🎉</strong></p>
  <p>Ahora eres capaz de crear sistemas de monitoreo y herramientas de administración de nivel empresarial.</p>
  
  [![Volver al Inicio](https://img.shields.io/badge/⬅️_Volver_al_Inicio-blue?style=for-the-badge)](../README.md)
  [![Siguiente Módulo](https://img.shields.io/badge/Módulo_7_➡️-green?style=for-the-badge)](../modulo7/README.md)
</div>

**¡Tu viaje hacia la maestría en Bash scripting continúa! 🚀**
