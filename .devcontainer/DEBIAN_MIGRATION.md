# Migración a Debian 12-slim - Bootcamp Bash

## ✅ Migración Completada

El entorno de desarrollo del Bootcamp Bash ha sido migrado exitosamente de **Ubuntu 22.04** a **Debian 12-slim**.

## 🎯 Beneficios de la Migración

### Optimización de Tamaño

- **Antes (Ubuntu 22.04)**: ~72MB imagen base
- **Después (Debian 12-slim)**: ~27MB imagen base
- **Reducción**: ~62% menor tamaño

### Ventajas Técnicas

- ✅ **Bash 5.x nativo**: Versión más reciente y optimizada
- ✅ **Misma compatibilidad**: Usa `apt` como gestor de paquetes
- ✅ **Mayor estabilidad**: Base Debian conocida por su solidez
- ✅ **Mejor seguridad**: Menor superficie de ataque
- ✅ **Optimizado para containers**: Diseñado para entornos containerizados

## 🔧 Cambios Implementados

### Dockerfile

```dockerfile
# Antes
FROM ubuntu:22.04

# Después
FROM debian:12-slim
```

### Optimizaciones de Instalación

- Uso de `--no-install-recommends` para reducir tamaño
- Repositorios actualizados para Debian
- Eliminación de paquetes redundantes ya presentes en la base

### Configuración de Timezone

- Mantenida configuración para `America/Bogota`
- Scripts de validación incluidos

## 🛠️ Herramientas Incluidas

### Shells y Terminal

- `bash` (shell principal para el bootcamp)
- `zsh` (con Oh My Zsh configurado)
- `tmux` y `screen` para sesiones

### Desarrollo

- `git` (control de versiones)
- `vim`, `nano` (editores)
- `shellcheck` (análisis de código Bash)
- `jq` (procesamiento JSON)

### Procesamiento de Texto

- `gawk` (GNU awk)
- Herramientas estándar Unix (grep, sed, cut, etc.)

### Red y Utilidades

- `curl`, `wget` (descarga de archivos)
- `tree` (visualización de directorios)
- `docker-ce-cli` (Docker CLI)
- `gh` (GitHub CLI)

## 🌍 Configuración de Zona Horaria

```bash
# Configurada para Bogotá, Colombia
TZ=America/Bogota
```

## 🚀 Cómo Usar

### Construir el Contenedor

```bash
# Desde el directorio del proyecto
docker-compose build
```

### Iniciar el Entorno

```bash
# Con Docker Compose
docker-compose up -d

# O usando VS Code Dev Containers
# Command Palette: "Dev Containers: Reopen in Container"
```

### Verificar la Migración

```bash
# Dentro del contenedor
bash .devcontainer/verify-debian.sh
```

## 📋 Scripts de Verificación

### `verify-debian.sh`

Verifica que todos los componentes estén correctamente instalados y configurados en Debian.

### `validate-timezone.sh`

Confirma que la zona horaria esté configurada correctamente para Bogotá.

### `check-timezone.sh`

Utilidad para mostrar información detallada de fecha y hora en cualquier momento.

## 🔍 Verificaciones Post-Migración

- [x] Sistema base: Debian 12-slim
- [x] Bash versión 5.x instalado
- [x] Zona horaria: America/Bogota
- [x] Usuario: vscode (no-root)
- [x] Herramientas de desarrollo instaladas
- [x] Docker CLI configurado para Debian
- [x] GitHub CLI instalado
- [x] Scripts de verificación funcionando

## 💡 Comandos Útiles

```bash
# Verificar información del sistema
cat /etc/os-release

# Verificar versión de Bash
bash --version

# Verificar zona horaria
date
cat /etc/timezone

# Listar paquetes instalados
dpkg -l | grep "^ii" | wc -l
```

## 🎓 Impacto en el Bootcamp

Esta migración mejora la experiencia de aprendizaje:

1. **Arranque más rápido**: Contenedor más ligero
2. **Menos recursos**: Menor uso de memoria y disco
3. **Bash optimizado**: Mejor rendimiento para scripting
4. **Entorno limpio**: Menos distracciones, foco en Bash
5. **Mejores prácticas**: Uso de imagen slim y optimizada

---

**✨ El entorno está listo para comenzar el Bootcamp de Bash con máximo rendimiento y mínimos recursos.**
