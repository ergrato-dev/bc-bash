# 📚 Teoría - Semana 7: Optimización y Debugging

> **Objetivo**: Crear scripts eficientes, debuggear problemas y aplicar mejores prácticas

## 🎯 ¿Qué es la Optimización y Debugging?

Técnicas para **mejorar el rendimiento**, **detectar errores** y **mantener código de calidad profesional**.

## 🤔 ¿Para qué sirve?

### Casos de Uso Profesionales

- 🐛 **Debugging**: Encontrar y corregir errores rápidamente
- ⚡ **Performance**: Scripts que manejan millones de registros
- 🛡️ **Seguridad**: Código robusto y seguro
- 📝 **Mantenibilidad**: Código fácil de entender y modificar
- 🎯 **Producción**: Scripts confiables 24/7

## 📖 Conceptos Clave

### 1. Debugging Básico

**¿Qué es?** Técnicas para identificar y resolver errores.

**¿Para qué?** Desarrollar scripts sin bugs y fáciles de mantener.

```bash
# Modo debug (-x muestra cada comando)
bash -x script.sh

# Debug en el script
set -x  # Activar debug
comando1
comando2
set +x  # Desactivar debug

# Trace de funciones
set -T
trap 'echo "Ejecutando: $BASH_COMMAND"' DEBUG
```

### 2. Manejo de Errores

**¿Qué es?** Estrategias para capturar y gestionar fallos.

**¿Para qué?** Scripts robustos que no fallan silenciosamente.

```bash
#!/bin/bash

# Modo estricto
set -euo pipefail

# Manejador de errores
trap 'echo "Error en línea $LINENO"' ERR

# Validación de comandos
if ! comando; then
    echo "Error: comando falló"
    exit 1
fi

# Verificar código de salida
comando
if [ $? -ne 0 ]; then
    echo "Error detectado"
fi
```

### 3. Logging

**¿Qué es?** Registro de eventos y operaciones del script.

**¿Para qué?** Auditoría, debugging, monitoreo.

```bash
# Logger simple
log() {
    local nivel=$1
    shift
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$nivel] $*" >> script.log
}

log INFO "Iniciando proceso"
log ERROR "Falló operación X"
log DEBUG "Variable: $valor"
```

### 4. Optimización de Performance

**¿Qué es?** Técnicas para hacer scripts más rápidos.

**¿Para qué?** Procesar grandes volúmenes de datos eficientemente.

```bash
# ❌ Lento: Crear proceso por iteración
for i in {1..1000}; do
    echo $i > /dev/null
done

# ✅ Rápido: Operaciones internas
for i in {1..1000}; do
    : # Operación interna
done

# ❌ Lento: Múltiples pipes
cat file | grep pattern | awk '{print $1}'

# ✅ Rápido: Menos procesos
awk '/pattern/ {print $1}' file
```

### 5. Profiling

**¿Qué es?** Medir dónde se gasta tiempo en el script.

**¿Para qué?** Identificar cuellos de botella.

```bash
# Medir tiempo de ejecución
time script.sh

# Profiling detallado
PS4='+ $(date "+%s.%N")\011 '
set -x
# código a analizar
set +x

# Medir sección específica
inicio=$(date +%s.%N)
# operación
fin=$(date +%s.%N)
echo "Tiempo: $(bc <<< "$fin - $inicio")s"
```

### 6. Mejores Prácticas

**¿Qué son?** Estándares de código profesional.

**¿Para qué?** Código mantenible, seguro y eficiente.

```bash
#!/bin/bash
# Script profesional

# 1. Shebang y configuración
set -euo pipefail

# 2. Constantes en mayúsculas
readonly LOG_FILE="/var/log/script.log"
readonly MAX_RETRIES=3

# 3. Funciones documentadas
# Descripción: Procesa un archivo
# Argumentos: $1 - archivo de entrada
# Retorno: 0 si éxito, 1 si error
procesar_archivo() {
    local archivo=$1

    if [ ! -f "$archivo" ]; then
        return 1
    fi

    # lógica...
    return 0
}

# 4. Validar argumentos
if [ $# -lt 1 ]; then
    echo "Uso: $0 <archivo>"
    exit 1
fi

# 5. Main con gestión de errores
main() {
    if ! procesar_archivo "$1"; then
        log ERROR "Falló procesamiento"
        exit 1
    fi
    log INFO "Completado exitosamente"
}

main "$@"
```

### 7. Testing

**¿Qué es?** Validar que el script funciona correctamente.

**¿Para qué?** Confianza en cambios, prevenir regresiones.

```bash
#!/bin/bash
# Script de tests

test_suma() {
    resultado=$(suma 2 3)
    if [ "$resultado" -eq 5 ]; then
        echo "✓ test_suma passed"
    else
        echo "✗ test_suma failed"
        return 1
    fi
}

test_validacion() {
    if validar_email "test@example.com"; then
        echo "✓ test_validacion passed"
    else
        echo "✗ test_validacion failed"
        return 1
    fi
}

# Ejecutar tests
test_suma
test_validacion
```

## 🎨 Ejemplos Prácticos

### 1. Script con Logging Profesional

```bash
#!/bin/bash

readonly LOG_FILE="app.log"
readonly LOG_LEVEL="${LOG_LEVEL:-INFO}"

log() {
    local nivel=$1
    shift
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # Niveles: DEBUG < INFO < WARN < ERROR
    case $LOG_LEVEL in
        DEBUG) ;;
        INFO) [[ "$nivel" == "DEBUG" ]] && return ;;
        WARN) [[ "$nivel" =~ ^(DEBUG|INFO)$ ]] && return ;;
        ERROR) [[ "$nivel" != "ERROR" ]] && return ;;
    esac

    echo "[$timestamp] [$nivel] $*" | tee -a "$LOG_FILE"
}

# Uso
log DEBUG "Iniciando proceso"
log INFO "Procesando archivo X"
log WARN "Advertencia: espacio bajo"
log ERROR "Falló operación crítica"
```

### 2. Monitor de Sistema con Alertas

```bash
#!/bin/bash

# Thresholds
readonly CPU_THRESHOLD=80
readonly MEM_THRESHOLD=90
readonly DISK_THRESHOLD=85

monitorear() {
    # CPU
    cpu_uso=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    if (( $(echo "$cpu_uso > $CPU_THRESHOLD" | bc -l) )); then
        alertar "CPU" "$cpu_uso%"
    fi

    # Memoria
    mem_uso=$(free | awk '/Mem:/ {printf "%.0f", $3/$2*100}')
    if [ "$mem_uso" -gt "$MEM_THRESHOLD" ]; then
        alertar "MEMORIA" "$mem_uso%"
    fi

    # Disco
    disk_uso=$(df -h / | awk 'NR==2 {print $5}' | cut -d'%' -f1)
    if [ "$disk_uso" -gt "$DISK_THRESHOLD" ]; then
        alertar "DISCO" "$disk_uso%"
    fi
}

alertar() {
    local tipo=$1
    local valor=$2
    log ERROR "$tipo alto: $valor"
    # Enviar notificación
    # mail -s "Alerta $tipo" admin@ejemplo.com
}

# Loop de monitoreo
while true; do
    monitorear
    sleep 60
done
```

### 3. Script con Retry Logic

```bash
#!/bin/bash

readonly MAX_RETRIES=3
readonly RETRY_DELAY=5

ejecutar_con_retry() {
    local comando=$1
    local intentos=0

    while [ $intentos -lt $MAX_RETRIES ]; do
        if eval "$comando"; then
            log INFO "Comando exitoso"
            return 0
        fi

        ((intentos++))
        log WARN "Intento $intentos/$MAX_RETRIES falló"

        if [ $intentos -lt $MAX_RETRIES ]; then
            log INFO "Reintentando en ${RETRY_DELAY}s..."
            sleep $RETRY_DELAY
        fi
    done

    log ERROR "Falló después de $MAX_RETRIES intentos"
    return 1
}

# Uso
ejecutar_con_retry "curl -f https://api.ejemplo.com/data"
```

## 🔧 Herramientas de Debugging

### ShellCheck

```bash
# Análisis estático de scripts
shellcheck script.sh

# Ignorar advertencias específicas
# shellcheck disable=SC2034
variable_no_usada="valor"
```

### Bash Debugger (bashdb)

```bash
# Instalar: apt-get install bashdb
bashdb script.sh

# Comandos en bashdb:
# n - next line
# s - step into
# c - continue
# p variable - print variable
# l - list code
```

## 🎓 Checklist de Mejores Prácticas

### Seguridad

- [ ] Usar `set -euo pipefail`
- [ ] Validar toda entrada de usuario
- [ ] Comillas en variables: `"$var"`
- [ ] Evitar `eval` con entrada no confiable
- [ ] Permisos correctos en scripts sensibles

### Performance

- [ ] Evitar subshells innecesarios
- [ ] Usar operaciones internas de bash
- [ ] Minimizar uso de `cat`
- [ ] Cachear resultados costosos
- [ ] Considerar paralelización

### Mantenibilidad

- [ ] Comentarios útiles
- [ ] Nombres descriptivos
- [ ] Funciones pequeñas y enfocadas
- [ ] Constantes en mayúsculas
- [ ] Documentar funciones

### Robustez

- [ ] Manejo de errores completo
- [ ] Logging apropiado
- [ ] Validación de prerequisites
- [ ] Limpieza en caso de error (trap EXIT)
- [ ] Testing básico

## ➡️ Siguiente Paso

- **[2-practicas](../2-practicas/README.md)**: Debugging y optimización
- **[3-proyecto](../3-proyecto/README.md)**: Monitor de sistema robusto

---

**💡 Tip**: La diferencia entre un script amateur y uno profesional está en el manejo de errores, logging y testing. Invierte tiempo en estas áreas.
