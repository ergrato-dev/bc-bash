# 📚 Ejemplos - Semana 7: Optimización y Debugging

Scripts que demuestran técnicas profesionales de debugging, logging y optimización.

## 🎯 Cómo usar estos ejemplos

```bash
# Hacer ejecutables
chmod +x *.sh

# Ejecutar con debug activo
bash -x 01-debugging-basico.sh

# Ejecutar con nivel de log específico
LOG_LEVEL=DEBUG ./02-logging-profesional.sh
```

## 📋 Lista de Ejemplos

### 01 - Debugging Básico

**Archivo**: `01-debugging-basico.sh`  
**Concepto**: Técnicas de depuración  
**Aprenderás**: set -x, PS4, trap ERR

```bash
# Debug mode
set -x
comandos
set +x

# Trap de errores
trap 'echo "Error en línea $LINENO"' ERR
```

### 02 - Logging Profesional

**Archivo**: `02-logging-profesional.sh`  
**Concepto**: Sistema de logs estructurado  
**Aprenderás**: Niveles de log, formato, rotación

```bash
# Logging con niveles
log_info "Mensaje informativo"
log_error "Mensaje de error"

# Con contexto
log_with_context INFO "Modulo" "mensaje"
```

### 03 - Optimización Performance

**Archivo**: `03-optimizacion-performance.sh`  
**Concepto**: Hacer scripts más rápidos  
**Aprenderás**: Evitar subshells, caché, paralelización

```bash
# Operaciones internas vs externas
resultado=$((5 + 3))          # Rápido
resultado=$(echo $((5 + 3)))  # Lento

# Paralelización
for file in *.txt; do
    procesar "$file" &
done
wait
```

## 🎓 Técnicas Clave

### Debugging

```bash
# Trace de comandos
bash -x script.sh

# Debug personalizado
PS4='[${LINENO}]: '
set -x

# Trap de errores
trap 'echo "Error en línea $LINENO"' ERR
set -e
```

### Logging

```bash
# Función de log
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$1] $2" | tee -a app.log
}

log INFO "Mensaje"
log ERROR "Fallo"
```

### Optimización

```bash
# ✅ Rápido
resultado=$((a + b))
nombre="${archivo%.txt}"

# ❌ Lento
resultado=$(expr $a + $b)
nombre=$(echo "$archivo" | sed 's/.txt//')
```

## 💡 Mejores Prácticas

### Debugging

1. Usa `set -euo pipefail` siempre
2. Activa trace solo en secciones críticas
3. Usa `trap` para cleanup
4. Valida argumentos y entradas
5. Prueba con datos reales

### Logging

1. Define niveles claros (DEBUG, INFO, WARN, ERROR)
2. Incluye timestamp en cada log
3. Usa contexto/módulo en mensajes
4. Rota logs periódicamente
5. Separa logs por severidad si es necesario

### Performance

1. Evita subshells innecesarios
2. Usa operaciones internas de Bash
3. Cachea resultados costosos
4. Considera paralelización
5. Profilea antes de optimizar

## 🔧 Herramientas

### Debug

- `bash -x` - Trace de comandos
- `set -x` / `set +x` - Toggle debug
- `trap` - Capturar señales
- `$LINENO` - Número de línea actual

### Performance

- `time` - Medir tiempo de ejecución
- `date +%s%N` - Timestamp en nanosegundos
- `SECONDS` - Variable de tiempo de Bash

## 🚀 Casos de Uso

### Script con Debug Mode

```bash
#!/bin/bash
DEBUG=${DEBUG:-false}

debug() {
    [ "$DEBUG" = true ] && echo "[DEBUG] $*" >&2
}

debug "Iniciando proceso..."
```

### Script con Logging

```bash
#!/bin/bash
readonly LOG_FILE="app.log"

log() {
    echo "[$(date)] [$1] $2" | tee -a "$LOG_FILE"
}

log INFO "App iniciada"
```

## 🔗 Siguiente Paso

- **[../../2-practicas/](../../2-practicas/README.md)**: Práctica de debugging
- **[../../3-proyecto/](../../3-proyecto/README.md)**: Monitor robusto con logging
