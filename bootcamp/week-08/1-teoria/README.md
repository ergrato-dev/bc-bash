# 📚 Teoría - Semana 8: Proyectos Avanzados y Automatización

> **Objetivo**: Integrar todo lo aprendido en proyectos empresariales y sistemas de automatización

## 🎯 ¿Qué son los Proyectos Avanzados?

Aplicaciones **completas y profesionales** que combinan múltiples conceptos, similar a lo que encontrarás en entornos de producción.

## 🤔 ¿Para qué sirven?

### Casos de Uso Empresariales

- 🚀 **CI/CD**: Pipelines de integración y despliegue continuo
- 📦 **Backup & Recovery**: Sistemas de respaldo automatizados
- 🔄 **Sincronización**: Replicación de datos entre sistemas
- 📊 **Reporting**: Generación automática de reportes
- 🛠️ **Tooling**: Herramientas internas de desarrollo
- 🔐 **Security**: Auditoría y hardening automático

## 📖 Conceptos Clave

### 1. Arquitectura de Scripts

**¿Qué es?** Organización modular y escalable del código.

**¿Para qué?** Proyectos grandes, mantenibles y testeables.

```bash
# Estructura de proyecto
proyecto/
├── bin/              # Scripts ejecutables
│   └── main.sh
├── lib/              # Bibliotecas/funciones
│   ├── logger.sh
│   ├── config.sh
│   └── utils.sh
├── config/           # Configuraciones
│   └── settings.conf
├── tests/            # Tests
│   └── test_main.sh
└── README.md

# main.sh
#!/bin/bash
source "$(dirname "$0")/../lib/logger.sh"
source "$(dirname "$0")/../lib/config.sh"
```

### 2. Gestión de Configuración

**¿Qué es?** Externalizar parámetros del script.

**¿Para qué?** Flexibilidad sin modificar código.

```bash
# config/settings.conf
BACKUP_DIR="/backup"
RETENTION_DAYS=30
MAX_RETRIES=3
LOG_LEVEL="INFO"

# Cargar configuración
load_config() {
    local config_file="${1:-config/settings.conf}"

    if [ -f "$config_file" ]; then
        source "$config_file"
    else
        echo "Error: Config file not found"
        exit 1
    fi
}
```

### 3. Sistema de Plugins

**¿Qué es?** Arquitectura extensible mediante módulos.

**¿Para qué?** Agregar funcionalidad sin modificar código base.

```bash
# Cargar plugins
load_plugins() {
    local plugin_dir="plugins"

    if [ -d "$plugin_dir" ]; then
        for plugin in "$plugin_dir"/*.sh; do
            [ -f "$plugin" ] && source "$plugin"
        done
    fi
}

# plugins/notifier.sh
notify() {
    echo "Notificación: $1"
    # Lógica de notificación
}
```

### 4. Cron y Scheduling

**¿Qué es?** Ejecución automática y programada.

**¿Para qué?** Tareas periódicas sin intervención manual.

```bash
# Instalar cron job
install_cron() {
    local script_path=$(realpath "$0")

    # Backup diario a las 2 AM
    (crontab -l 2>/dev/null; echo "0 2 * * * $script_path backup") | \
        crontab -

    echo "Cron job instalado"
}

# Verificar si se ejecuta desde cron
if [ -t 0 ]; then
    echo "Ejecutado interactivamente"
else
    echo "Ejecutado desde cron"
fi
```

### 5. Paralelización

**¿Qué es?** Ejecutar múltiples tareas simultáneamente.

**¿Para qué?** Acelerar procesamiento de datos masivos.

```bash
# Procesamiento paralelo simple
for archivo in *.txt; do
    procesar "$archivo" &
done
wait  # Esperar a que terminen todos

# Con control de concurrencia
MAX_JOBS=4
for archivo in *.txt; do
    # Esperar si hay demasiados jobs
    while [ $(jobs -r | wc -l) -ge $MAX_JOBS ]; do
        sleep 0.1
    done
    procesar "$archivo" &
done
wait

# GNU Parallel (si está disponible)
parallel procesar ::: *.txt
```

### 6. Lock Files

**¿Qué son?** Prevenir ejecución simultánea del mismo script.

**¿Para qué?** Evitar conflictos en scripts críticos.

```bash
#!/bin/bash

readonly LOCK_FILE="/var/run/$(basename "$0").lock"

acquire_lock() {
    if [ -f "$LOCK_FILE" ]; then
        local pid=$(cat "$LOCK_FILE")
        if kill -0 "$pid" 2>/dev/null; then
            echo "Error: Script ya en ejecución (PID: $pid)"
            exit 1
        else
            echo "Removiendo lock antiguo"
            rm -f "$LOCK_FILE"
        fi
    fi

    echo $$ > "$LOCK_FILE"
    trap "rm -f $LOCK_FILE" EXIT
}

acquire_lock
# Script principal...
```

### 7. Notificaciones y Alertas

**¿Qué son?** Informar sobre eventos importantes.

**¿Para qué?** Monitoreo, alertas de errores, reportes.

```bash
# Email
enviar_email() {
    local asunto=$1
    local mensaje=$2
    local destinatario=$3

    echo "$mensaje" | mail -s "$asunto" "$destinatario"
}

# Slack/Discord webhook
enviar_slack() {
    local mensaje=$1
    local webhook_url=$2

    curl -X POST -H 'Content-type: application/json' \
        --data "{\"text\":\"$mensaje\"}" \
        "$webhook_url"
}

# Desktop notification
notify_desktop() {
    if command -v notify-send &> /dev/null; then
        notify-send "Script" "$1"
    fi
}
```

### 8. Backup y Recovery

**¿Qué es?** Sistemas de respaldo confiables.

**¿Para qué?** Proteger datos críticos.

```bash
#!/bin/bash
# Sistema de backup completo

readonly BACKUP_ROOT="/backup"
readonly RETENTION_DAYS=30
readonly DATE=$(date +%Y%m%d_%H%M%S)

backup() {
    local source=$1
    local name=$(basename "$source")
    local backup_dir="$BACKUP_ROOT/$name"
    local backup_file="$backup_dir/${name}_${DATE}.tar.gz"

    mkdir -p "$backup_dir"

    log INFO "Iniciando backup de $source"

    if tar -czf "$backup_file" -C "$(dirname "$source")" "$name"; then
        log INFO "Backup completado: $backup_file"

        # Limpiar backups antiguos
        find "$backup_dir" -name "*.tar.gz" \
            -mtime +$RETENTION_DAYS -delete

        return 0
    else
        log ERROR "Falló backup de $source"
        return 1
    fi
}

restore() {
    local backup_file=$1
    local dest_dir=$2

    if [ ! -f "$backup_file" ]; then
        log ERROR "Backup no encontrado: $backup_file"
        return 1
    fi

    log INFO "Restaurando $backup_file a $dest_dir"
    tar -xzf "$backup_file" -C "$dest_dir"
}
```

## 🎨 Ejemplos de Proyectos Completos

### 1. Sistema de Deployment

```bash
#!/bin/bash
# deploy.sh - Sistema de deployment automatizado

set -euo pipefail

readonly APP_NAME="mi-app"
readonly DEPLOY_DIR="/var/www/$APP_NAME"
readonly BACKUP_DIR="/backup/deploys"
readonly GIT_REPO="https://github.com/user/repo.git"

deploy() {
    local version=$1

    log INFO "Iniciando deployment de $APP_NAME v$version"

    # 1. Backup del estado actual
    backup_current

    # 2. Obtener nueva versión
    fetch_version "$version"

    # 3. Ejecutar tests
    if ! run_tests; then
        log ERROR "Tests fallaron, abortando"
        rollback
        return 1
    fi

    # 4. Deploy
    install_version

    # 5. Verificar health
    if ! health_check; then
        log ERROR "Health check falló"
        rollback
        return 1
    fi

    log INFO "Deployment completado exitosamente"
}

rollback() {
    log WARN "Ejecutando rollback..."
    restore_backup
}

# Uso
case ${1:-} in
    deploy)
        deploy "${2:-latest}"
        ;;
    rollback)
        rollback
        ;;
    status)
        show_status
        ;;
    *)
        echo "Uso: $0 {deploy|rollback|status}"
        exit 1
        ;;
esac
```

### 2. Monitor de Servicios

```bash
#!/bin/bash
# monitor.sh - Monitoreo de servicios

readonly SERVICES=("nginx" "mysql" "redis")
readonly CHECK_INTERVAL=60
readonly ALERT_EMAIL="admin@ejemplo.com"

check_service() {
    local service=$1

    if systemctl is-active --quiet "$service"; then
        return 0
    else
        return 1
    fi
}

monitor_loop() {
    while true; do
        for service in "${SERVICES[@]}"; do
            if ! check_service "$service"; then
                alert "$service está caído"
                restart_service "$service"
            fi
        done
        sleep $CHECK_INTERVAL
    done
}

restart_service() {
    local service=$1
    log WARN "Reiniciando $service"
    systemctl restart "$service"

    if check_service "$service"; then
        log INFO "$service reiniciado exitosamente"
    else
        alert "$service falló al reiniciar"
    fi
}

alert() {
    local mensaje=$1
    log ERROR "$mensaje"
    echo "$mensaje" | mail -s "Alerta: $mensaje" "$ALERT_EMAIL"
}

# Ejecutar como daemon
monitor_loop
```

### 3. Automatización de Reportes

```bash
#!/bin/bash
# report_generator.sh

generate_daily_report() {
    local date=$(date +%Y-%m-%d)
    local report_file="report_${date}.html"

    cat > "$report_file" << EOF
<!DOCTYPE html>
<html>
<head><title>Reporte Diario - $date</title></head>
<body>
<h1>Reporte del Sistema - $date</h1>

<h2>Estadísticas de Servidores</h2>
$(get_server_stats)

<h2>Análisis de Logs</h2>
$(analyze_logs)

<h2>Uso de Recursos</h2>
$(get_resource_usage)

<p>Generado: $(date)</p>
</body>
</html>
EOF

    log INFO "Reporte generado: $report_file"

    # Enviar por email
    send_report "$report_file"
}

# Cron: 0 6 * * * /path/to/report_generator.sh
generate_daily_report
```

## 🚀 Integración CI/CD

### GitLab CI Example

```yaml
# .gitlab-ci.yml
stages:
  - test
  - deploy

test_scripts:
  stage: test
  script:
    - shellcheck **/*.sh
    - ./run_tests.sh

deploy_production:
  stage: deploy
  script:
    - ./deploy.sh production
  only:
    - main
```

## 🎓 Checklist de Proyecto Profesional

### Estructura

- [ ] Arquitectura modular
- [ ] Configuración externa
- [ ] Logging completo
- [ ] Documentación README

### Funcionalidad

- [ ] Manejo robusto de errores
- [ ] Validación de entrada
- [ ] Lock files para scripts críticos
- [ ] Retry logic

### Operación

- [ ] Instalación automatizada
- [ ] Scripts de deployment
- [ ] Backup y recovery
- [ ] Monitoreo y alertas

### Calidad

- [ ] Tests automatizados
- [ ] ShellCheck sin warnings
- [ ] Code review
- [ ] Versionado (git tags)

## ➡️ Siguiente Paso

- **[2-practicas](../2-practicas/README.md)**: Ejercicios de integración
- **[3-proyecto](../3-proyecto/README.md)**: Proyectos empresariales completos

---

**💡 Tip Final**: Los proyectos de esta semana son tu portfolio. Impleméntalos con calidad profesional y úsalos para demostrar tus habilidades en entrevistas técnicas.

**🎓 Has llegado al final del bootcamp. ¡Ahora eres un Bash scripter profesional!**
