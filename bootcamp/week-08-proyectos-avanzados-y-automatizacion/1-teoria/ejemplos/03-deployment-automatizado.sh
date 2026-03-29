#!/bin/bash
# Ejemplo 03: Deployment Automatizado
# Descripción: Script de despliegue con validaciones

set -euo pipefail

# === Configuración ===
readonly APP_NAME="mi-aplicacion"
readonly DEPLOY_DIR="/opt/${APP_NAME}"
readonly REPO_URL="https://github.com/usuario/${APP_NAME}.git"
readonly BRANCH="main"
readonly BACKUP_DIR="${DEPLOY_DIR}/backups"
readonly SERVICE_NAME="${APP_NAME}.service"

# === Colores ===
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# === Funciones de Output ===
step() { echo -e "${BLUE}▶ $*${NC}"; }
success() { echo -e "${GREEN}✓ $*${NC}"; }
warning() { echo -e "${YELLOW}⚠ $*${NC}"; }
error() { echo -e "${RED}✗ $*${NC}" >&2; }

# === Funciones de Validación ===
validar_ambiente() {
    step "Validando ambiente de despliegue"
    
    # Verificar que se ejecuta como usuario adecuado
    if [ "$EUID" -ne 0 ]; then 
        error "Este script debe ejecutarse con sudo"
        exit 1
    fi
    
    # Verificar dependencias
    local dependencias=("git" "systemctl" "tar")
    for cmd in "${dependencias[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            error "Dependencia no encontrada: $cmd"
            exit 1
        fi
    done
    
    success "Ambiente validado"
}

# === Pre-deployment Checks ===
pre_deployment_checks() {
    step "Ejecutando verificaciones pre-despliegue"
    
    # Verificar conectividad
    if ! ping -c 1 github.com &> /dev/null; then
        error "Sin conectividad a internet"
        return 1
    fi
    
    # Verificar espacio en disco
    local espacio_disponible=$(df "${DEPLOY_DIR}" | awk 'NR==2 {print $4}')
    local espacio_requerido=1048576  # 1GB en KB
    
    if [ "$espacio_disponible" -lt "$espacio_requerido" ]; then
        error "Espacio insuficiente en disco"
        return 1
    fi
    
    success "Verificaciones pre-despliegue completadas"
}

# === Backup ===
crear_backup() {
    step "Creando backup de la versión actual"
    
    if [ ! -d "$DEPLOY_DIR" ]; then
        warning "No existe instalación previa para respaldar"
        return 0
    fi
    
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_file="${BACKUP_DIR}/backup_${timestamp}.tar.gz"
    
    mkdir -p "$BACKUP_DIR"
    
    if tar -czf "$backup_file" -C "$(dirname "$DEPLOY_DIR")" "$(basename "$DEPLOY_DIR")" 2>/dev/null; then
        success "Backup creado: $backup_file"
        
        # Mantener solo los últimos 5 backups
        ls -t "${BACKUP_DIR}"/backup_*.tar.gz | tail -n +6 | xargs -r rm
    else
        error "Falló la creación del backup"
        return 1
    fi
}

# === Detener Servicio ===
detener_servicio() {
    step "Deteniendo servicio: $SERVICE_NAME"
    
    if systemctl is-active --quiet "$SERVICE_NAME"; then
        systemctl stop "$SERVICE_NAME"
        success "Servicio detenido"
    else
        warning "Servicio no estaba ejecutándose"
    fi
}

# === Deployment ===
desplegar_aplicacion() {
    step "Desplegando aplicación desde $BRANCH"
    
    # Clonar o actualizar repositorio
    if [ -d "${DEPLOY_DIR}/.git" ]; then
        cd "$DEPLOY_DIR"
        git fetch origin
        git reset --hard "origin/${BRANCH}"
        success "Repositorio actualizado"
    else
        mkdir -p "$DEPLOY_DIR"
        git clone -b "$BRANCH" "$REPO_URL" "$DEPLOY_DIR"
        success "Repositorio clonado"
    fi
    
    # Instalar dependencias (ejemplo con npm/node)
    if [ -f "${DEPLOY_DIR}/package.json" ]; then
        step "Instalando dependencias"
        cd "$DEPLOY_DIR"
        npm install --production
        success "Dependencias instaladas"
    fi
    
    # Build (si es necesario)
    if [ -f "${DEPLOY_DIR}/Makefile" ]; then
        step "Compilando aplicación"
        cd "$DEPLOY_DIR"
        make build
        success "Aplicación compilada"
    fi
}

# === Configuración ===
configurar_aplicacion() {
    step "Configurando aplicación"
    
    # Copiar archivos de configuración
    local config_ejemplo="${DEPLOY_DIR}/config.example.json"
    local config="${DEPLOY_DIR}/config.json"
    
    if [ -f "$config_ejemplo" ] && [ ! -f "$config" ]; then
        cp "$config_ejemplo" "$config"
        warning "Configuración creada desde ejemplo. Revisar: $config"
    fi
    
    # Ajustar permisos
    chown -R www-data:www-data "$DEPLOY_DIR"
    chmod -R 755 "$DEPLOY_DIR"
    
    success "Configuración aplicada"
}

# === Iniciar Servicio ===
iniciar_servicio() {
    step "Iniciando servicio: $SERVICE_NAME"
    
    systemctl daemon-reload
    systemctl start "$SERVICE_NAME"
    systemctl enable "$SERVICE_NAME"
    
    # Verificar que inició correctamente
    sleep 2
    if systemctl is-active --quiet "$SERVICE_NAME"; then
        success "Servicio iniciado correctamente"
    else
        error "Servicio no inició correctamente"
        return 1
    fi
}

# === Health Check ===
verificar_salud() {
    step "Verificando salud de la aplicación"
    
    local max_intentos=5
    local intento=0
    
    while [ $intento -lt $max_intentos ]; do
        if curl -f -s http://localhost:3000/health > /dev/null 2>&1; then
            success "Aplicación respondiendo correctamente"
            return 0
        fi
        
        intento=$((intento + 1))
        warning "Intento $intento/$max_intentos - Esperando..."
        sleep 2
    done
    
    error "La aplicación no responde"
    return 1
}

# === Rollback ===
rollback() {
    error "Iniciando rollback"
    
    local ultimo_backup=$(ls -t "${BACKUP_DIR}"/backup_*.tar.gz 2>/dev/null | head -1)
    
    if [ -z "$ultimo_backup" ]; then
        error "No hay backups disponibles para rollback"
        return 1
    fi
    
    step "Restaurando desde: $ultimo_backup"
    
    detener_servicio
    rm -rf "$DEPLOY_DIR"
    tar -xzf "$ultimo_backup" -C "$(dirname "$DEPLOY_DIR")"
    iniciar_servicio
    
    success "Rollback completado"
}

# === Main ===
main() {
    echo "╔══════════════════════════════════════╗"
    echo "║   🚀 Deployment Automatizado        ║"
    echo "║   Aplicación: $APP_NAME             ║"
    echo "╚══════════════════════════════════════╝"
    echo ""
    
    validar_ambiente
    pre_deployment_checks
    crear_backup
    detener_servicio
    
    # Intentar deployment
    if desplegar_aplicacion && configurar_aplicacion && iniciar_servicio; then
        if verificar_salud; then
            success "✅ Deployment completado exitosamente"
            exit 0
        else
            error "Health check falló"
            rollback
            exit 1
        fi
    else
        error "Deployment falló"
        rollback
        exit 1
    fi
}

# Trap para cleanup
trap 'error "Deployment interrumpido"; rollback' INT TERM

# Ejecutar solo si no se está sourcing el script
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi
