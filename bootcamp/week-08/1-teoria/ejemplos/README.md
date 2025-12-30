# 📚 Ejemplos - Módulo 8: Proyectos Avanzados y Automatización

Scripts completos que demuestran patrones de automatización profesional y proyectos del mundo real.

## 🎯 Cómo usar estos ejemplos

```bash
# Hacer ejecutables
chmod +x *.sh

# Backup (requiere configuración)
./01-sistema-backup.sh

# Monitor (modo único o continuo)
./02-monitor-sistema.sh
./02-monitor-sistema.sh continuous

# Deployment (requiere sudo)
sudo ./03-deployment-automatizado.sh
```

## 📋 Lista de Ejemplos

### 01 - Sistema de Backup Completo

**Archivo**: `01-sistema-backup.sh`  
**Concepto**: Backup robusto con rotación  
**Características**:

- Compresión con tar/gzip
- Rotación automática por días
- Verificación de integridad
- Logging estructurado
- Manejo de errores completo

```bash
# Variables clave
BACKUP_SOURCE="${HOME}/Documents"
BACKUP_DEST="${HOME}/backups"
RETENTION_DAYS=7

# Ejecución
./01-sistema-backup.sh
```

**Funcionalidades**:

- ✅ Verificación de dependencias
- ✅ Backup incremental
- ✅ Validación de integridad
- ✅ Limpieza automática de backups antiguos
- ✅ Reportes detallados

### 02 - Monitor de Sistema

**Archivo**: `02-monitor-sistema.sh`  
**Concepto**: Monitoreo de recursos en tiempo real  
**Características**:

- CPU, memoria, disco
- Alertas por umbrales
- Modo continuo o single-run
- Output con colores
- Logging de eventos

```bash
# Reporte único
./02-monitor-sistema.sh

# Monitoreo continuo
./02-monitor-sistema.sh continuous

# Configurar umbrales
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=85
```

**Métricas monitoreadas**:

- 📊 Uso de CPU (%)
- 💾 Uso de memoria (%)
- 💿 Uso de disco (%)
- ⚡ Carga del sistema
- 👥 Usuarios conectados
- ⏱️ Uptime

### 03 - Deployment Automatizado

**Archivo**: `03-deployment-automatizado.sh`  
**Concepto**: Pipeline de despliegue con validaciones  
**Características**:

- Pre-deployment checks
- Backup antes de deploy
- Git pull/clone
- Health checks
- Rollback automático

```bash
# Deployment completo
sudo ./03-deployment-automatizado.sh

# Variables principales
APP_NAME="mi-aplicacion"
DEPLOY_DIR="/opt/${APP_NAME}"
BRANCH="main"
```

**Pipeline de Deployment**:

1. ✅ Validar ambiente
2. ✅ Pre-deployment checks
3. ✅ Crear backup
4. ✅ Detener servicio
5. ✅ Desplegar código
6. ✅ Configurar aplicación
7. ✅ Iniciar servicio
8. ✅ Health check
9. ❌ Rollback si falla

## 🎓 Patrones Implementados

### Error Handling Robusto

```bash
set -euo pipefail

error_exit() {
    log_error "$1"
    exit 1
}

# Usar
[ -f "$archivo" ] || error_exit "Archivo no encontrado"
```

### Logging Estructurado

```bash
log() {
    local nivel=$1
    shift
    echo "[$(date)] [$nivel] $*" | tee -a "$LOG_FILE"
}

log_info "Proceso iniciado"
log_error "Falló operación"
```

### Verificaciones Pre-ejecución

```bash
verificar_dependencias() {
    for cmd in "${dependencias[@]}"; do
        command -v "$cmd" &> /dev/null || error_exit "$cmd no encontrado"
    done
}
```

### Rollback Seguro

```bash
rollback() {
    echo "Iniciando rollback..."
    restaurar_backup "$ultimo_backup"
    reiniciar_servicio
}

trap rollback INT TERM ERR
```

## 💡 Mejores Prácticas Implementadas

### Seguridad

1. ✅ Verificar permisos de usuario
2. ✅ Validar entrada de datos
3. ✅ Usar rutas absolutas
4. ✅ No hardcodear credenciales
5. ✅ Logging de acciones

### Robustez

1. ✅ `set -euo pipefail` en todos los scripts
2. ✅ Verificar dependencias antes de ejecutar
3. ✅ Backups automáticos
4. ✅ Health checks después de cambios
5. ✅ Rollback automático en fallos

### Mantenibilidad

1. ✅ Código modular (funciones)
2. ✅ Configuración en constantes
3. ✅ Comentarios descriptivos
4. ✅ Logging detallado
5. ✅ Salidas de error claras

### Performance

1. ✅ Operaciones paralelas cuando es posible
2. ✅ Caché de resultados costosos
3. ✅ Limpieza de recursos
4. ✅ Timeouts configurables
5. ✅ Verificaciones de espacio en disco

## 🚀 Casos de Uso Real

### Backup Automatizado con Cron

```bash
# Crontab: Backup diario a las 2 AM
0 2 * * * /ruta/01-sistema-backup.sh >> /var/log/backup.log 2>&1
```

### Monitor con Alertas

```bash
# Monitorear y alertar si excede umbrales
while true; do
    ./02-monitor-sistema.sh | grep "ALERTA" && \
        notify-send "Sistema" "Alerta de recursos"
    sleep 300
done
```

### Deployment CI/CD

```bash
# Hook post-receive de Git
#!/bin/bash
cd /opt/mi-aplicacion
./03-deployment-automatizado.sh
```

## 🔧 Personalización

### Sistema de Backup

```bash
# Ajustar en el script
BACKUP_SOURCE="${HOME}/Documents"     # Cambiar origen
RETENTION_DAYS=7                       # Días a mantener
BACKUP_DEST="${HOME}/backups"         # Destino
```

### Monitor

```bash
# Umbrales personalizados
CPU_THRESHOLD=80      # % CPU para alertar
MEM_THRESHOLD=80      # % Memoria para alertar
CHECK_INTERVAL=5      # Segundos entre checks
```

### Deployment

```bash
# Configurar para tu app
APP_NAME="mi-app"
REPO_URL="https://github.com/user/repo.git"
BRANCH="main"
SERVICE_NAME="mi-app.service"
```

## 🔗 Integración con Herramientas

### Systemd

```ini
[Unit]
Description=Monitor de Sistema

[Service]
ExecStart=/path/02-monitor-sistema.sh continuous
Restart=always

[Install]
WantedBy=multi-user.target
```

### Ansible

```yaml
- name: Deploy application
  command: /path/03-deployment-automatizado.sh
  become: yes
```

### Docker

```dockerfile
COPY scripts/ /scripts/
RUN chmod +x /scripts/*.sh
CMD ["/scripts/01-sistema-backup.sh"]
```

## 📚 Referencias

- [Bash Best Practices](https://kvz.io/bash-best-practices.html)
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [ShellCheck](https://www.shellcheck.net/)

## 🔗 Siguiente Paso

- **[../../2-practicas/](../../2-practicas/README.md)**: Práctica avanzada
- **[../../3-proyecto/](../../3-proyecto/README.md)**: Proyectos completos del bootcamp
