<div align="center">
  <img src="../assets/module-7-logo.svg" alt="Módulo 7: Optimización y Debugging" width="300">
</div>

# MÓDULO 7: OPTIMIZACIÓN Y DEBUGGING

**Bootcamp Bash Scripting - Semana 7**

## 🎯 VISIÓN GENERAL DEL MÓDULO

El Módulo 7 representa la **transformación definitiva** de scripter básico a **desarrollador de Bash profesional**. Aquí no solo aprenderás a hacer que tus scripts funcionen, sino a hacerlos **rápidos, confiables y seguros** bajo cualquier condición.

### 🎯 Objetivos de Aprendizaje

Al completar este módulo, serás capaz de:

- **Debuggear scripts complejos** con herramientas profesionales y técnicas avanzadas
- **Optimizar performance** hasta obtener mejoras del 50-90% en velocidad de ejecución
- **Implementar seguridad** robusta para proteger sistemas y datos sensibles
- **Crear testing frameworks** para validar funcionalidad crítica
- **Desarrollar herramientas** de monitoring y profiling personalizadas
- **Aplicar mejores prácticas** de desarrollo profesional en Bash

### 🌟 ¿Por qué este módulo es transformacional?

En el mundo profesional, la diferencia entre un scripter junior y un **Senior DevOps Engineer** no está en conocer más comandos, sino en escribir código que:

- **Nunca falla silenciosamente** - Debugging exhaustivo
- **Escala sin problemas** - Optimización inteligente
- **Resiste ataques** - Seguridad por diseño
- **Se mantiene fácilmente** - Código limpio y documentado

### 📚 Estructura del Módulo

#### **Lección 7.1: Debugging y Troubleshooting**

- Modos de debug avanzados y herramientas integradas
- Sistema de logging profesional con niveles y rotación
- Técnicas de profiling y análisis de performance
- Framework de testing básico para Bash

#### **Lección 7.2: Optimización de Performance**

- Medición precisa y benchmarking profesional
- Técnicas de optimización fundamentales
- Paralelización y concurrencia controlada
- Gestión eficiente de memoria y I/O

#### **Lección 7.3: Seguridad en Scripts**

- Validación y sanitización de entrada
- Prevención de inyección de comandos
- Gestión segura de credenciales y secretos
- Auditoría y compliance de seguridad

#### **Lección 7.4: Herramientas de Monitoring y Profiling**

- Profiling avanzado de scripts y funciones
- Herramientas de monitoring de recursos
- Análisis de memoria y CPU en tiempo real
- Optimización basada en métricas

---

## 🔧 LECCIÓN 7.1: DEBUGGING Y TROUBLESHOOTING

### Concepto: De Scripts que "Funcionan" a Código Profesional

La diferencia entre un script amateur y uno profesional no está en que funcione, sino en que **nunca falle silenciosamente** y sea fácil de debuggear cuando algo va mal.

### 7.1.1 Modos de Debug Avanzados

#### **Configuración Estricta de Errores**

```bash
#!/bin/bash
# Configuración profesional de debug
set -euo pipefail

# Explicación de cada flag:
# -e: Salir inmediatamente si cualquier comando falla
# -u: Tratar variables no definidas como error
# -o pipefail: Fallar si cualquier comando en un pipe falla

debug_example() {
    echo "Iniciando función con debug activado"

    # Esto causará error inmediato con -u
    # echo "$variable_no_definida"

    # Esto causará error con -e
    # false

    # Esto causará error con pipefail
    # cat archivo_inexistente | grep "algo"
}
```

#### **Debug Condicional Avanzado**

```bash
#!/bin/bash
# Sistema de debug con niveles

# Variables de control de debug
DEBUG_LEVEL="${DEBUG_LEVEL:-0}"
DEBUG_FILE="${DEBUG_FILE:-/tmp/script_debug.log}"

# Funciones de debug por nivel
debug() {
    local level="$1"
    shift
    [[ "$DEBUG_LEVEL" -ge "$level" ]] && echo "[DEBUG$level] $*" >&2
}

debug_trace() {
    [[ "$DEBUG_LEVEL" -ge 3 ]] && set -x || set +x
}

debug_function() {
    local func_name="$1"
    debug 2 "Entrando a función: $func_name"
    debug 3 "Argumentos: $*"
}

# Ejemplo de uso
process_file() {
    debug_function "process_file" "$@"
    debug_trace

    local file="$1"
    debug 1 "Procesando archivo: $file"

    if [[ ! -f "$file" ]]; then
        debug 1 "ERROR: Archivo no encontrado: $file"
        return 1
    fi

    # Procesamiento real del archivo
    wc -l "$file"
    debug 2 "Archivo procesado exitosamente"

    set +x  # Desactivar trace
}

# Uso con diferentes niveles:
# DEBUG_LEVEL=1 ./script.sh  # Solo errores importantes
# DEBUG_LEVEL=2 ./script.sh  # Flujo de funciones
# DEBUG_LEVEL=3 ./script.sh  # Trace completo
```

### 7.1.2 Sistema de Logging Profesional

#### **Logger Completo con Niveles**

```bash
#!/bin/bash
# Sistema de logging profesional

LOG_DIR="${LOG_DIR:-/var/log/$(basename "$0" .sh)}"
LOG_FILE="$LOG_DIR/$(date +%Y%m%d).log"
LOG_LEVEL="${LOG_LEVEL:-INFO}"

# Crear directorio de logs
mkdir -p "$LOG_DIR"

# Niveles de log (orden de prioridad)
declare -A LOG_LEVELS=(
    ["DEBUG"]=0
    ["INFO"]=1
    ["WARN"]=2
    ["ERROR"]=3
    ["FATAL"]=4
)

get_log_level() {
    echo "${LOG_LEVELS[$LOG_LEVEL]:-1}"
}

log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local caller="${FUNCNAME[2]:-main}"
    local line="${BASH_LINENO[1]:-0}"

    # Verificar si el nivel permite logging
    local current_level=$(get_log_level)
    local msg_level="${LOG_LEVELS[$level]:-1}"

    [[ "$msg_level" -lt "$current_level" ]] && return 0

    # Formato: [TIMESTAMP] [LEVEL] [FUNCTION:LINE] MESSAGE
    local log_entry="[$timestamp] [$level] [$caller:$line] $message"

    # Escribir a archivo y stderr según nivel
    echo "$log_entry" >> "$LOG_FILE"

    case "$level" in
        "ERROR"|"FATAL")
            echo "$log_entry" >&2
            ;;
        "WARN")
            [[ "$current_level" -le 2 ]] && echo "$log_entry" >&2
            ;;
        *)
            [[ "$current_level" -eq 0 ]] && echo "$log_entry" >&2
            ;;
    esac
}

# Funciones de conveniencia
log_debug() { log "DEBUG" "$@"; }
log_info() { log "INFO" "$@"; }
log_warn() { log "WARN" "$@"; }
log_error() { log "ERROR" "$@"; }
log_fatal() { log "FATAL" "$@"; exit 1; }

# Ejemplo de uso
process_data() {
    log_info "Iniciando procesamiento de datos"

    local data_file="$1"
    if [[ ! -f "$data_file" ]]; then
        log_error "Archivo de datos no encontrado: $data_file"
        return 1
    fi

    log_debug "Archivo encontrado, tamaño: $(stat -c%s "$data_file") bytes"

    # Simulación de procesamiento
    local line_count=$(wc -l < "$data_file")
    log_info "Procesando $line_count líneas"

    if [[ "$line_count" -gt 10000 ]]; then
        log_warn "Archivo muy grande, el procesamiento puede ser lento"
    fi

    # Procesamiento real aquí...
    sleep 2

    log_info "Procesamiento completado exitosamente"
}
```

### 7.1.3 Herramientas de Análisis Avanzado

#### **ShellCheck Integration**

```bash
#!/bin/bash
# Script con análisis automático de ShellCheck

# Función para validar scripts automáticamente
validate_script() {
    local script_file="$1"

    if ! command -v shellcheck >/dev/null 2>&1; then
        log_warn "ShellCheck no instalado, saltando validación"
        return 0
    fi

    log_info "Validando script con ShellCheck: $script_file"

    local output
    if output=$(shellcheck "$script_file" 2>&1); then
        log_info "ShellCheck: No se encontraron problemas"
        return 0
    else
        log_error "ShellCheck encontró problemas:"
        echo "$output" | while IFS= read -r line; do
            log_error "  $line"
        done
        return 1
    fi
}

# Auto-validación del script actual
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    validate_script "${BASH_SOURCE[0]}"
fi
```

#### **Profiler de Funciones**

```bash
#!/bin/bash
# Profiler simple para funciones

PROFILING_ENABLED="${PROFILING_ENABLED:-false}"
declare -A FUNCTION_TIMES
declare -A FUNCTION_CALLS

profile_function() {
    local func_name="$1"
    [[ "$PROFILING_ENABLED" != "true" ]] && return 0

    local start_time=$(date +%s%N)

    # Ejecutar función original
    "$@"
    local exit_code=$?

    local end_time=$(date +%s%N)
    local duration=$(( (end_time - start_time) / 1000000 )) # ms

    # Actualizar estadísticas
    FUNCTION_TIMES["$func_name"]=$((${FUNCTION_TIMES["$func_name"]:-0} + duration))
    FUNCTION_CALLS["$func_name"]=$((${FUNCTION_CALLS["$func_name"]:-0} + 1))

    return $exit_code
}

show_profile_stats() {
    [[ "$PROFILING_ENABLED" != "true" ]] && return 0

    echo "=== ESTADÍSTICAS DE PROFILING ==="
    printf "%-20s %10s %10s %10s\n" "FUNCIÓN" "LLAMADAS" "TOTAL(ms)" "PROM(ms)"
    echo "------------------------------------------------------------"

    for func in "${!FUNCTION_CALLS[@]}"; do
        local calls="${FUNCTION_CALLS[$func]}"
        local total="${FUNCTION_TIMES[$func]}"
        local avg=$((total / calls))

        printf "%-20s %10d %10d %10d\n" "$func" "$calls" "$total" "$avg"
    done
}

# Trap para mostrar estadísticas al salir
trap 'show_profile_stats' EXIT

# Ejemplo de función con profiling
expensive_operation() {
    sleep 1
    echo "Operación costosa completada"
}

# Uso: PROFILING_ENABLED=true ./script.sh
profile_function expensive_operation
```

### 7.1.4 Framework de Testing Básico

#### **Testing Framework Simple**

```bash
#!/bin/bash
# Framework de testing básico para Bash

TEST_COUNT=0
TEST_PASSED=0
TEST_FAILED=0

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

test_setup() {
    echo "=== INICIANDO TESTS ==="
}

test_teardown() {
    echo "=== RESUMEN DE TESTS ==="
    echo -e "Total: $TEST_COUNT"
    echo -e "${GREEN}Pasaron: $TEST_PASSED${NC}"
    echo -e "${RED}Fallaron: $TEST_FAILED${NC}"

    if [[ "$TEST_FAILED" -gt 0 ]]; then
        echo -e "${RED}ALGUNOS TESTS FALLARON${NC}"
        exit 1
    else
        echo -e "${GREEN}TODOS LOS TESTS PASARON${NC}"
        exit 0
    fi
}

assert_equals() {
    local expected="$1"
    local actual="$2"
    local test_name="${3:-test_$TEST_COUNT}"

    ((TEST_COUNT++))

    if [[ "$expected" == "$actual" ]]; then
        echo -e "${GREEN}✓${NC} $test_name"
        ((TEST_PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC} $test_name"
        echo "  Esperado: '$expected'"
        echo "  Actual:   '$actual'"
        ((TEST_FAILED++))
        return 1
    fi
}

assert_file_exists() {
    local file="$1"
    local test_name="${2:-file_exists_test}"

    ((TEST_COUNT++))

    if [[ -f "$file" ]]; then
        echo -e "${GREEN}✓${NC} $test_name"
        ((TEST_PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC} $test_name"
        echo "  Archivo no existe: $file"
        ((TEST_FAILED++))
        return 1
    fi
}

assert_command_success() {
    local command="$1"
    local test_name="${2:-command_success_test}"

    ((TEST_COUNT++))

    if eval "$command" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} $test_name"
        ((TEST_PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC} $test_name"
        echo "  Comando falló: $command"
        ((TEST_FAILED++))
        return 1
    fi
}

# Ejemplo de tests
run_tests() {
    test_setup

    # Test de función simple
    add_numbers() {
        local a="$1"
        local b="$2"
        echo $((a + b))
    }

    assert_equals "5" "$(add_numbers 2 3)" "test_add_numbers"
    assert_equals "10" "$(add_numbers 4 6)" "test_add_numbers_2"

    # Test de archivo
    echo "test content" > /tmp/test_file.txt
    assert_file_exists "/tmp/test_file.txt" "test_file_creation"

    # Test de comando
    assert_command_success "ls /tmp" "test_ls_command"
    assert_command_success "echo 'hello world'" "test_echo_command"

    # Cleanup
    rm -f /tmp/test_file.txt

    test_teardown
}

# Ejecutar tests si el script se ejecuta directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_tests
fi
```

---

## ⚡ LECCIÓN 7.2: OPTIMIZACIÓN DE PERFORMANCE

### Concepto: De Scripts Lentos a Herramientas Ultrarrápidas

La optimización no es solo hacer que algo funcione más rápido; es entender **dónde** está el cuello de botella y aplicar la técnica correcta para eliminarlo.

### 7.2.1 Medición Precisa de Performance

#### **Benchmarking Profesional**

```bash
#!/bin/bash
# Sistema de benchmarking avanzado

benchmark() {
    local test_name="$1"
    local iterations="${2:-10}"
    local warmup="${3:-2}"
    shift 3
    local command=("$@")

    echo "=== BENCHMARK: $test_name ==="
    echo "Comando: ${command[*]}"
    echo "Iteraciones: $iterations (warmup: $warmup)"
    echo

    # Warmup runs
    echo "Ejecutando warmup..."
    for ((i=1; i<=warmup; i++)); do
        "${command[@]}" >/dev/null 2>&1
    done

    # Mediciones reales
    local total_time=0
    local times=()

    echo "Ejecutando mediciones..."
    for ((i=1; i<=iterations; i++)); do
        local start_time=$(date +%s%N)
        "${command[@]}" >/dev/null 2>&1
        local end_time=$(date +%s%N)

        local duration=$(( (end_time - start_time) / 1000000 )) # ms
        times+=("$duration")
        total_time=$((total_time + duration))

        printf "  Iteración %2d: %6d ms\n" "$i" "$duration"
    done

    # Estadísticas
    local avg_time=$((total_time / iterations))
    local min_time=$(printf '%s\n' "${times[@]}" | sort -n | head -1)
    local max_time=$(printf '%s\n' "${times[@]}" | sort -n | tail -1)

    echo
    echo "RESULTADOS:"
    echo "  Promedio: $avg_time ms"
    echo "  Mínimo:   $min_time ms"
    echo "  Máximo:   $max_time ms"
    echo "  Total:    $total_time ms"
    echo
}

# Ejemplo de uso
test_slow_function() {
    # Función intencionalmente lenta
    for ((i=0; i<1000; i++)); do
        echo "$i" | grep "5" >/dev/null
    done
}

test_fast_function() {
    # Versión optimizada
    local pattern="5"
    for ((i=0; i<1000; i++)); do
        [[ "$i" == *"$pattern"* ]]
    done
}

# Comparar funciones
benchmark "Función Lenta" 5 1 test_slow_function
benchmark "Función Rápida" 5 1 test_fast_function
```

#### **Monitor de Recursos en Tiempo Real**

```bash
#!/bin/bash
# Monitor de recursos durante ejecución

monitor_script() {
    local script_to_monitor="$1"
    local output_file="${2:-/tmp/resource_monitor.log}"

    echo "Monitoreando: $script_to_monitor"
    echo "Output: $output_file"

    # Crear archivo de header
    echo "timestamp,cpu_percent,memory_kb,io_read,io_write" > "$output_file"

    # Ejecutar script en background
    "$script_to_monitor" &
    local script_pid=$!

    # Monitorear mientras el script corre
    while kill -0 "$script_pid" 2>/dev/null; do
        local timestamp=$(date +%s)

        # Obtener estadísticas del proceso
        if [[ -f "/proc/$script_pid/stat" ]]; then
            local cpu_percent=$(ps -p "$script_pid" -o pcpu= | tr -d ' ')
            local memory_kb=$(ps -p "$script_pid" -o rss= | tr -d ' ')
            local io_stats=$(cat "/proc/$script_pid/io" 2>/dev/null)
            local io_read=$(echo "$io_stats" | awk '/read_bytes/ {print $2}')
            local io_write=$(echo "$io_stats" | awk '/write_bytes/ {print $2}')

            echo "$timestamp,$cpu_percent,$memory_kb,$io_read,$io_write" >> "$output_file"
        fi

        sleep 0.5
    done

    echo "Monitoreo completado. Datos en: $output_file"
}
```

### 7.2.2 Técnicas de Optimización Fundamentales

#### **Eliminación de Subshells**

```bash
#!/bin/bash
# Comparación: subshells vs operaciones nativas

# ❌ MALO: Usar subshells innecesarios
slow_string_processing() {
    local text="$1"

    # Cada una de estas crea un subshell
    local upper=$(echo "$text" | tr '[:lower:]' '[:upper:]')
    local length=$(echo "$text" | wc -c)
    local first_char=$(echo "$text" | cut -c1)

    echo "Upper: $upper, Length: $length, First: $first_char"
}

# ✅ BUENO: Usar operaciones nativas de Bash
fast_string_processing() {
    local text="$1"

    # Operaciones nativas - sin subshells
    local upper="${text^^}"              # Bash 4.0+
    local length="${#text}"              # Bash nativo
    local first_char="${text:0:1}"      # Bash nativo

    echo "Upper: $upper, Length: $length, First: $first_char"
}

# 🚀 ÓPTIMO: Operaciones combinadas
optimal_string_processing() {
    local text="$1"

    # Una sola operación
    printf "Upper: %s, Length: %d, First: %s\n" \
           "${text^^}" "${#text}" "${text:0:1}"
}
```

#### **Optimización de Loops**

```bash
#!/bin/bash
# Optimización de loops y arrays

# ❌ MALO: Loop con comandos externos
slow_array_processing() {
    local -a items=("$@")
    local result=""

    for item in "${items[@]}"; do
        # Comando externo en cada iteración
        result+="$(echo "$item" | tr '[:lower:]' '[:upper:]'),"
    done

    echo "${result%,}"  # Remover última coma
}

# ✅ BUENO: Loop con operaciones nativas
fast_array_processing() {
    local -a items=("$@")
    local result=""

    for item in "${items[@]}"; do
        # Operación nativa de Bash
        result+="${item^^},"
    done

    echo "${result%,}"
}

# 🚀 ÓPTIMO: Evitar concatenación en loop
optimal_array_processing() {
    local -a items=("$@")
    local -a results=()

    # Construir array primero
    for item in "${items[@]}"; do
        results+=("${item^^}")
    done

    # Una sola operación de join
    local IFS=','
    echo "${results[*]}"
}
```

### 7.2.3 Paralelización Controlada

#### **Sistema de Workers Pool**

```bash
#!/bin/bash
# Sistema de paralelización con pool de workers

MAX_WORKERS="${MAX_WORKERS:-4}"
WORKER_QUEUE="/tmp/worker_queue_$$"
WORKER_RESULTS="/tmp/worker_results_$$"

# Inicializar sistema de workers
init_worker_pool() {
    # Crear pipes para comunicación
    mkfifo "$WORKER_QUEUE"
    touch "$WORKER_RESULTS"

    # Llenar queue con tokens de workers
    for ((i=1; i<=MAX_WORKERS; i++)); do
        echo "worker_$i" > "$WORKER_QUEUE" &
    done
}

# Función worker que procesa tareas
worker_function() {
    local worker_id="$1"
    local task_data="$2"

    # Simular trabajo pesado
    echo "[$worker_id] Procesando: $task_data" >&2
    sleep "$((RANDOM % 3 + 1))"  # 1-3 segundos

    # Resultado del trabajo
    echo "[$worker_id] Resultado: ${task_data^^}" >> "$WORKER_RESULTS"
}

# Procesar tareas en paralelo
process_parallel() {
    local -a tasks=("$@")

    init_worker_pool

    echo "Procesando ${#tasks[@]} tareas con $MAX_WORKERS workers"

    for task in "${tasks[@]}"; do
        # Esperar por worker disponible
        read -r worker_id < "$WORKER_QUEUE"

        # Asignar tarea al worker en background
        {
            worker_function "$worker_id" "$task"
            # Devolver worker al pool
            echo "$worker_id" > "$WORKER_QUEUE"
        } &
    done

    # Esperar que todos los trabajos terminen
    wait

    # Mostrar resultados
    echo "=== RESULTADOS ==="
    cat "$WORKER_RESULTS"

    # Cleanup
    rm -f "$WORKER_QUEUE" "$WORKER_RESULTS"
}

# Ejemplo de uso
tasks=("archivo1.txt" "archivo2.txt" "archivo3.txt" "archivo4.txt" "archivo5.txt")
process_parallel "${tasks[@]}"
```

### 7.2.4 Optimización de I/O

#### **Buffering Inteligente**

```bash
#!/bin/bash
# Optimización de I/O con buffering

# ❌ MALO: Escribir línea por línea
slow_file_writing() {
    local output_file="$1"
    local -a data=("${@:2}")

    for item in "${data[@]}"; do
        echo "$item" >> "$output_file"  # Cada línea = una operación I/O
    done
}

# ✅ BUENO: Escribir en lotes
fast_file_writing() {
    local output_file="$1"
    local -a data=("${@:2}")
    local buffer=""
    local buffer_size=0
    local max_buffer=1000

    for item in "${data[@]}"; do
        buffer+="$item\n"
        ((buffer_size++))

        # Flush buffer cuando alcance el límite
        if [[ "$buffer_size" -ge "$max_buffer" ]]; then
            printf "%b" "$buffer" >> "$output_file"
            buffer=""
            buffer_size=0
        fi
    done

    # Flush buffer final
    [[ -n "$buffer" ]] && printf "%b" "$buffer" >> "$output_file"
}

# 🚀 ÓPTIMO: Una sola operación I/O
optimal_file_writing() {
    local output_file="$1"
    local -a data=("${@:2}")

    # Construir todo el contenido en memoria
    printf "%s\n" "${data[@]}" > "$output_file"
}
```

---

## 🔒 LECCIÓN 7.3: SEGURIDAD EN SCRIPTS

### Concepto: Código que Resiste Ataques

Un script seguro no es solo uno que funciona correctamente, sino uno que **no puede ser explotado** por entradas maliciosas o condiciones adversas.

### 7.3.1 Validación y Sanitización de Entrada

#### **Validación Estricta de Parámetros**

```bash
#!/bin/bash
# Sistema de validación robusta

# Validadores específicos
validate_email() {
    local email="$1"
    local email_regex='^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'

    if [[ "$email" =~ $email_regex ]]; then
        return 0
    else
        log_error "Email inválido: $email"
        return 1
    fi
}

validate_ip_address() {
    local ip="$1"
    local ip_regex='^([0-9]{1,3}\.){3}[0-9]{1,3}$'

    if [[ "$ip" =~ $ip_regex ]]; then
        # Validar rangos (0-255)
        IFS='.' read -ra octets <<< "$ip"
        for octet in "${octets[@]}"; do
            if [[ "$octet" -gt 255 ]]; then
                log_error "IP inválida: $ip (octet > 255)"
                return 1
            fi
        done
        return 0
    else
        log_error "Formato de IP inválido: $ip"
        return 1
    fi
}

validate_file_path() {
    local filepath="$1"
    local allowed_dirs="${2:-/tmp:/var/tmp:/home}"

    # Resolver path absoluto
    local real_path
    real_path=$(realpath "$filepath" 2>/dev/null) || {
        log_error "Path inválido: $filepath"
        return 1
    }

    # Verificar que esté en directorios permitidos
    IFS=':' read -ra allowed_array <<< "$allowed_dirs"
    for allowed_dir in "${allowed_array[@]}"; do
        if [[ "$real_path" == "$allowed_dir"* ]]; then
            return 0
        fi
    done

    log_error "Path no permitido: $real_path"
    return 1
}

# Sanitización de entrada
sanitize_filename() {
    local filename="$1"

    # Remover caracteres peligrosos
    filename="${filename//[^a-zA-Z0-9._-]/}"

    # Prevenir nombres especiales
    case "$filename" in
        ""|"."|"..")
            filename="safe_${RANDOM}"
            ;;
    esac

    echo "$filename"
}

sanitize_sql_input() {
    local input="$1"

    # Escapar caracteres SQL peligrosos
    input="${input//\'/\'\'}"      # Escapar comillas simples
    input="${input//\"/\\\"}"      # Escapar comillas dobles
    input="${input//\\/\\\\}"      # Escapar backslashes
    input="${input//;/\\;}"        # Escapar punto y coma

    echo "$input"
}
```

### 7.3.2 Prevención de Inyección de Comandos

#### **Ejecución Segura de Comandos**

```bash
#!/bin/bash
# Prevención de inyección de comandos

# ❌ VULNERABLE: Nunca hagas esto
vulnerable_command() {
    local user_input="$1"

    # PELIGRO: Inyección de comandos
    # eval "ls $user_input"
    # bash -c "find /home -name '$user_input'"
}

# ✅ SEGURO: Validación y arrays
safe_command_execution() {
    local search_term="$1"
    local search_dir="$2"

    # Validar entrada
    if [[ ! "$search_term" =~ ^[a-zA-Z0-9._-]+$ ]]; then
        log_error "Término de búsqueda contiene caracteres inválidos"
        return 1
    fi

    # Validar directorio
    if [[ ! -d "$search_dir" ]]; then
        log_error "Directorio no existe: $search_dir"
        return 1
    fi

    # Usar arrays para evitar inyección
    local cmd=(find "$search_dir" -name "$search_term" -type f)
    "${cmd[@]}"
}

# Sistema de comandos permitidos
declare -A ALLOWED_COMMANDS=(
    ["list_files"]="ls -la"
    ["check_disk"]="df -h"
    ["show_processes"]="ps aux"
    ["network_info"]="ip addr show"
)

execute_safe_command() {
    local command_key="$1"
    shift
    local args=("$@")

    # Verificar que el comando esté permitido
    if [[ -z "${ALLOWED_COMMANDS[$command_key]}" ]]; then
        log_error "Comando no permitido: $command_key"
        return 1
    fi

    # Construir comando seguro
    local base_cmd="${ALLOWED_COMMANDS[$command_key]}"
    IFS=' ' read -ra cmd_array <<< "$base_cmd"

    # Validar argumentos si los hay
    for arg in "${args[@]}"; do
        if [[ ! "$arg" =~ ^[a-zA-Z0-9/._-]+$ ]]; then
            log_error "Argumento inválido: $arg"
            return 1
        fi
    done

    # Ejecutar comando
    "${cmd_array[@]}" "${args[@]}"
}
```

### 7.3.3 Gestión Segura de Credenciales

#### **Manejo de Secretos**

```bash
#!/bin/bash
# Gestión segura de credenciales

# Variables para credenciales
CREDENTIALS_FILE="${CREDENTIALS_FILE:-/etc/app/credentials}"
TEMP_CREDENTIALS=""

load_credentials() {
    # Verificar permisos del archivo
    if [[ -f "$CREDENTIALS_FILE" ]]; then
        local file_perms=$(stat -c%a "$CREDENTIALS_FILE")
        if [[ "$file_perms" != "600" ]]; then
            log_error "Archivo de credenciales tiene permisos inseguros: $file_perms"
            return 1
        fi

        # Cargar credenciales en variables temporales
        source "$CREDENTIALS_FILE"
    else
        log_error "Archivo de credenciales no encontrado: $CREDENTIALS_FILE"
        return 1
    fi
}

# Función para limpiar credenciales de memoria
cleanup_credentials() {
    unset DB_PASSWORD
    unset API_KEY
    unset SECRET_TOKEN

    # Limpiar variables temporales
    TEMP_CREDENTIALS=""
}

# Trap para limpiar al salir
trap cleanup_credentials EXIT

# Función para hacer requests seguros
secure_api_request() {
    local endpoint="$1"
    local method="${2:-GET}"

    # Cargar credenciales solo cuando se necesiten
    load_credentials || return 1

    # Usar credenciales sin exponerlas en logs
    curl -s -X "$method" \
         -H "Authorization: Bearer $API_KEY" \
         "$endpoint" 2>/dev/null

    local exit_code=$?

    # Limpiar inmediatamente
    cleanup_credentials

    return $exit_code
}

# Sistema de logs que no expone secretos
secure_log() {
    local level="$1"
    local message="$2"

    # Filtrar información sensible
    message="${message//password=[^[:space:]]*/password=***}"
    message="${message//token=[^[:space:]]*/token=***}"
    message="${message//key=[^[:space:]]*/key=***}"

    log "$level" "$message"
}
```

### 7.3.4 Auditoría y Compliance

#### **Sistema de Auditoría**

```bash
#!/bin/bash
# Sistema de auditoría para compliance

AUDIT_LOG="/var/log/audit/script_audit.log"
AUDIT_ENABLED="${AUDIT_ENABLED:-true}"

audit_action() {
    local action="$1"
    local user="${2:-$USER}"
    local details="$3"

    [[ "$AUDIT_ENABLED" != "true" ]] && return 0

    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local session_id="${SSH_CLIENT:-local}"
    local script_name="$(basename "${BASH_SOURCE[2]}")"

    # Formato de auditoría estándar
    local audit_entry=$(cat << EOF
{
  "timestamp": "$timestamp",
  "user": "$user",
  "session": "$session_id",
  "script": "$script_name",
  "action": "$action",
  "details": "$details",
  "pid": $$
}
EOF
)

    # Escribir a log de auditoría
    echo "$audit_entry" >> "$AUDIT_LOG"

    # Log también al sistema
    logger -t "script_audit" "$user performed $action in $script_name"
}

# Verificación de permisos de archivos críticos
audit_file_permissions() {
    local -a critical_files=(
        "/etc/passwd"
        "/etc/shadow"
        "/etc/sudoers"
        "/home/*/.ssh/authorized_keys"
    )

    audit_action "file_permission_check" "$USER" "Starting file permission audit"

    for file_pattern in "${critical_files[@]}"; do
        for file in $file_pattern; do
            [[ -f "$file" ]] || continue

            local perms=$(stat -c%a "$file")
            local owner=$(stat -c%U "$file")
            local group=$(stat -c%G "$file")

            # Verificar permisos apropiados
            case "$file" in
                */shadow)
                    if [[ "$perms" != "640" && "$perms" != "600" ]]; then
                        audit_action "security_violation" "$USER" \
                                   "Insecure permissions on $file: $perms"
                    fi
                    ;;
                */authorized_keys)
                    if [[ "$perms" != "600" ]]; then
                        audit_action "security_violation" "$USER" \
                                   "Insecure SSH key file: $file ($perms)"
                    fi
                    ;;
            esac
        done
    done

    audit_action "file_permission_check" "$USER" "File permission audit completed"
}

# Verificación de integridad de scripts
verify_script_integrity() {
    local script_file="$1"
    local expected_hash="$2"

    if [[ ! -f "$script_file" ]]; then
        audit_action "integrity_check_failed" "$USER" \
                   "Script not found: $script_file"
        return 1
    fi

    local current_hash=$(sha256sum "$script_file" | cut -d' ' -f1)

    if [[ "$current_hash" != "$expected_hash" ]]; then
        audit_action "integrity_violation" "$USER" \
                   "Script modified: $script_file (hash mismatch)"
        return 1
    fi

    audit_action "integrity_check_passed" "$USER" \
               "Script integrity verified: $script_file"
    return 0
}
```

---

## 🔬 LECCIÓN 7.4: HERRAMIENTAS DE MONITORING Y PROFILING

### Concepto: Visibilidad Total del Rendimiento

No puedes optimizar lo que no puedes medir. Esta lección te enseña a crear herramientas profesionales de monitoring y profiling.

### 7.4.1 Profiler Avanzado de Scripts

#### **Profiler Completo con Call Stack**

```bash
#!/bin/bash
# Profiler avanzado con stack traces

PROFILING_ENABLED="${PROFILING_ENABLED:-false}"
PROFILE_OUTPUT="${PROFILE_OUTPUT:-/tmp/profile_$(date +%s).json}"

declare -A profile_data
declare -a call_stack
declare -A function_start_times

# Inicializar profiling
init_profiler() {
    [[ "$PROFILING_ENABLED" != "true" ]] && return 0

    echo "Profiler inicializado. Output: $PROFILE_OUTPUT"
    echo '{"profile_session": {' > "$PROFILE_OUTPUT"
    echo "  \"start_time\": $(date +%s)," >> "$PROFILE_OUTPUT"
    echo "  \"functions\": [" >> "$PROFILE_OUTPUT"

    # Hook para todas las funciones
    set -T
    trap 'profile_function_entry "${FUNCNAME[0]}"' DEBUG
}

profile_function_entry() {
    [[ "$PROFILING_ENABLED" != "true" ]] && return 0

    local func_name="$1"
    local current_time=$(date +%s%N)

    # Agregar al call stack
    call_stack+=("$func_name")
    function_start_times["$func_name"]="$current_time"

    # Registrar entrada
    local depth=${#call_stack[@]}
    profile_data["${func_name}_calls"]=$((${profile_data["${func_name}_calls"]:-0} + 1))
    profile_data["${func_name}_depth"]="$depth"
}

profile_function_exit() {
    [[ "$PROFILING_ENABLED" != "true" ]] && return 0

    local func_name="$1"
    local current_time=$(date +%s%N)
    local start_time="${function_start_times["$func_name"]}"

    if [[ -n "$start_time" ]]; then
        local duration=$(( (current_time - start_time) / 1000000 )) # ms
        profile_data["${func_name}_total_time"]=$((${profile_data["${func_name}_total_time"]:-0} + duration))

        # Remover del call stack
        unset call_stack[-1]
        unset function_start_times["$func_name"]
    fi
}

generate_profile_report() {
    [[ "$PROFILING_ENABLED" != "true" ]] && return 0

    # Completar JSON
    echo "  ]," >> "$PROFILE_OUTPUT"
    echo "  \"end_time\": $(date +%s)," >> "$PROFILE_OUTPUT"
    echo "  \"summary\": {" >> "$PROFILE_OUTPUT"

    # Generar resumen
    for key in "${!profile_data[@]}"; do
        if [[ "$key" == *"_calls" ]]; then
            local func_name="${key%_calls}"
            local calls="${profile_data[${func_name}_calls]:-0}"
            local total_time="${profile_data[${func_name}_total_time]:-0}"
            local avg_time=0

            [[ "$calls" -gt 0 ]] && avg_time=$((total_time / calls))

            cat >> "$PROFILE_OUTPUT" << EOF
    "$func_name": {
      "calls": $calls,
      "total_time_ms": $total_time,
      "avg_time_ms": $avg_time
    },
EOF
        fi
    done

    # Cerrar JSON
    echo "  }" >> "$PROFILE_OUTPUT"
    echo "}}" >> "$PROFILE_OUTPUT"

    echo "Reporte de profiling generado: $PROFILE_OUTPUT"
}

# Trap para generar reporte al salir
trap 'generate_profile_report' EXIT
```

### 7.4.2 Monitor de Recursos Avanzado

#### **Monitor Completo del Sistema**

```bash
#!/bin/bash
# Monitor de recursos completo

MONITOR_INTERVAL="${MONITOR_INTERVAL:-5}"
MONITOR_DURATION="${MONITOR_DURATION:-60}"
MONITOR_OUTPUT="${MONITOR_OUTPUT:-/tmp/system_monitor.json}"

collect_system_metrics() {
    local timestamp=$(date +%s)

    # CPU
    local cpu_percent=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    local load_avg=$(uptime | awk -F'load average:' '{print $2}' | tr -d ' ')

    # Memoria
    local mem_info=$(free -b)
    local mem_total=$(echo "$mem_info" | awk 'NR==2{print $2}')
    local mem_used=$(echo "$mem_info" | awk 'NR==2{print $3}')
    local mem_percent=$(( mem_used * 100 / mem_total ))

    # Disco
    local disk_usage=$(df / | awk 'NR==2{print $5}' | cut -d'%' -f1)
    local disk_io=$(iostat -d 1 1 2>/dev/null | tail -n +4 | awk '{print $3","$4}' | head -1)

    # Red
    local network_stats=$(cat /proc/net/dev | grep -E "(eth0|wlan0|enp)" | head -1)
    local rx_bytes=$(echo "$network_stats" | awk '{print $2}')
    local tx_bytes=$(echo "$network_stats" | awk '{print $10}')

    # Procesos
    local process_count=$(ps aux | wc -l)
    local zombie_count=$(ps aux | awk '$8 ~ /^Z/ {count++} END {print count+0}')

    # Generar JSON
    cat << EOF
{
  "timestamp": $timestamp,
  "cpu": {
    "usage_percent": $cpu_percent,
    "load_average": "$load_avg"
  },
  "memory": {
    "total_bytes": $mem_total,
    "used_bytes": $mem_used,
    "usage_percent": $mem_percent
  },
  "disk": {
    "usage_percent": $disk_usage,
    "io": "$disk_io"
  },
  "network": {
    "rx_bytes": $rx_bytes,
    "tx_bytes": $tx_bytes
  },
  "processes": {
    "total": $process_count,
    "zombies": $zombie_count
  }
}
EOF
}

run_monitoring_session() {
    echo "Iniciando monitoreo por $MONITOR_DURATION segundos..."
    echo "Intervalo: $MONITOR_INTERVAL segundos"
    echo "Output: $MONITOR_OUTPUT"

    # Inicializar archivo JSON
    echo '{"monitoring_session": {' > "$MONITOR_OUTPUT"
    echo '  "start_time": '$(date +%s)',' >> "$MONITOR_OUTPUT"
    echo '  "interval": '$MONITOR_INTERVAL',' >> "$MONITOR_OUTPUT"
    echo '  "metrics": [' >> "$MONITOR_OUTPUT"

    local end_time=$(($(date +%s) + MONITOR_DURATION))
    local first_entry=true

    while [[ $(date +%s) -lt $end_time ]]; do
        # Agregar coma si no es la primera entrada
        [[ "$first_entry" != "true" ]] && echo "," >> "$MONITOR_OUTPUT"
        first_entry=false

        # Recolectar y escribir métricas
        collect_system_metrics >> "$MONITOR_OUTPUT"

        sleep "$MONITOR_INTERVAL"
    done

    # Finalizar JSON
    echo "" >> "$MONITOR_OUTPUT"
    echo '  ],' >> "$MONITOR_OUTPUT"
    echo '  "end_time": '$(date +%s) >> "$MONITOR_OUTPUT"
    echo '}}' >> "$MONITOR_OUTPUT"

    echo "Monitoreo completado. Datos guardados en: $MONITOR_OUTPUT"
}

# Análisis de los datos recolectados
analyze_monitoring_data() {
    local data_file="$1"

    if [[ ! -f "$data_file" ]]; then
        echo "Archivo de datos no encontrado: $data_file"
        return 1
    fi

    echo "=== ANÁLISIS DE MONITOREO ==="

    # Extraer métricas para análisis
    local cpu_values=$(jq -r '.monitoring_session.metrics[].cpu.usage_percent' "$data_file" 2>/dev/null)
    local mem_values=$(jq -r '.monitoring_session.metrics[].memory.usage_percent' "$data_file" 2>/dev/null)

    if [[ -n "$cpu_values" ]]; then
        local cpu_avg=$(echo "$cpu_values" | awk '{sum+=$1} END {print sum/NR}')
        local cpu_max=$(echo "$cpu_values" | sort -n | tail -1)

        echo "CPU - Promedio: ${cpu_avg}%, Máximo: ${cpu_max}%"
    fi

    if [[ -n "$mem_values" ]]; then
        local mem_avg=$(echo "$mem_values" | awk '{sum+=$1} END {print sum/NR}')
        local mem_max=$(echo "$mem_values" | sort -n | tail -1)

        echo "Memoria - Promedio: ${mem_avg}%, Máximo: ${mem_max}%"
    fi
}

# Ejemplo de uso
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "${1:-monitor}" in
        "monitor")
            run_monitoring_session
            ;;
        "analyze")
            analyze_monitoring_data "${2:-$MONITOR_OUTPUT}"
            ;;
        *)
            echo "Uso: $0 {monitor|analyze [archivo]}"
            exit 1
            ;;
    esac
fi
```

---

## 🚀 PROYECTO PRÁCTICO 7: REFACTORIZACIÓN PROFESIONAL

### Descripción del Proyecto

Vas a tomar un script "amateur" típico con múltiples problemas y aplicar **todas las técnicas del Módulo 7** para transformarlo en una herramienta profesional de nivel empresarial.

### Script Original (Problemático)

```bash
#!/bin/bash
# Script con múltiples problemas - NO USAR EN PRODUCCIÓN

echo "Processing files..."

for file in `find /tmp -name "*.txt"`; do
    echo "Processing $file"

    # Problemas: sin validación, subshells innecesarios, inseguro
    content=`cat $file`
    lines=`echo "$content" | wc -l`
    words=`echo "$content" | wc -w`

    # Problema: concatenación en loop
    result="$result\nFile: $file - Lines: $lines, Words: $words"

    # Problema: sin manejo de errores
    cp $file /backup/
done

echo -e "$result" > /tmp/report.txt
echo "Done!"
```

### Tu Misión: Refactorización Completa

#### **Fase 1: Debugging y Robustez (25%)**

1. **Agregar configuración estricta** (`set -euo pipefail`)
2. **Implementar logging profesional** con niveles
3. **Crear framework de testing** para validar funciones
4. **Agregar manejo de errores** comprehensivo

#### **Fase 2: Optimización de Performance (25%)**

1. **Eliminar subshells innecesarios**
2. **Optimizar loops y operaciones de string**
3. **Implementar paralelización** para procesamiento de archivos
4. **Agregar benchmarking** para medir mejoras

#### **Fase 3: Seguridad (25%)**

1. **Validar todas las entradas** y paths de archivos
2. **Sanitizar nombres de archivos**
3. **Implementar auditoría** de acciones
4. **Gestión segura** de directorios de trabajo

#### **Fase 4: Monitoring y Profiling (25%)**

1. **Agregar profiler** para rastrear performance de funciones
2. **Implementar monitor de recursos** durante ejecución
3. **Crear reportes de análisis** con métricas detalladas
4. **Dashboard simple** para visualizar resultados

### Entregables del Proyecto

#### **Código Refactorizado (`file_processor_pro.sh`)**

```bash
#!/bin/bash
# File Processor Professional - Refactorización del Módulo 7
# Autor: [Tu Nombre]
# Versión: 2.0.0

set -euo pipefail

# Configuración global
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_DIR="${LOG_DIR:-/var/log/file_processor}"
readonly WORK_DIR="${WORK_DIR:-/tmp/file_processor}"
readonly MAX_WORKERS="${MAX_WORKERS:-4}"

# Tu implementación aquí...
# Debe incluir TODAS las técnicas aprendidas en el módulo
```

#### **Suite de Testing (`test_file_processor.sh`)**

```bash
#!/bin/bash
# Tests comprehensivos para el file processor

# Incluir todas las funciones de testing del módulo
source "$SCRIPT_DIR/testing_framework.sh"
source "$SCRIPT_DIR/file_processor_pro.sh"

run_all_tests() {
    test_setup

    # Tests de validación
    test_input_validation
    test_file_path_validation
    test_security_measures

    # Tests de performance
    test_optimization_improvements
    test_parallel_processing

    # Tests de robustez
    test_error_handling
    test_edge_cases

    test_teardown
}
```

#### **Documentación Completa (`README.md`)**

- **Benchmarks** del antes vs después
- **Análisis de seguridad** implementado
- **Guía de uso** y configuración
- **Métricas de performance** y recursos

### Criterios de Evaluación

#### **Debugging y Robustez (25 puntos)**

- ✅ Configuración estricta implementada (5 pts)
- ✅ Sistema de logging profesional (10 pts)
- ✅ Manejo de errores comprehensivo (5 pts)
- ✅ Framework de testing (5 pts)

#### **Optimización de Performance (25 puntos)**

- ✅ Eliminación de subshells (5 pts)
- ✅ Optimización de operaciones (10 pts)
- ✅ Paralelización efectiva (5 pts)
- ✅ Benchmarking documentado (5 pts)

#### **Seguridad (25 puntos)**

- ✅ Validación de entrada (10 pts)
- ✅ Sanitización apropiada (5 pts)
- ✅ Auditoría implementada (5 pts)
- ✅ Gestión segura de archivos (5 pts)

#### **Monitoring y Profiling (25 puntos)**

- ✅ Profiler funcional (10 pts)
- ✅ Monitor de recursos (10 pts)
- ✅ Reportes de análisis (5 pts)

### Tiempo Estimado: 6-8 horas

### Resultados Esperados

Al completar este proyecto deberías lograr:

- **Mejora de performance:** 50-70% más rápido
- **Robustez:** 0% fallos silenciosos
- **Seguridad:** Resistente a inputs maliciosos
- **Mantenibilidad:** Código limpio y documentado

---

## 🎓 CONCLUSIONES DEL MÓDULO 7

### Lo que has logrado

¡Felicitaciones! Has completado el módulo más técnico y transformacional del bootcamp. Ya no eres un scripter amateur - **eres un desarrollador de Bash profesional**.

#### **Habilidades Profesionales Dominadas:**

✅ **Debugging Avanzado** - Scripts que nunca fallan silenciosamente
✅ **Optimización de Performance** - Mejoras del 50-90% en velocidad
✅ **Seguridad por Diseño** - Código resistente a ataques
✅ **Monitoring y Profiling** - Visibilidad total del rendimiento
✅ **Testing Frameworks** - Validación automática de funcionalidad

### Impacto Profesional

Con estas habilidades, puedes aspirar a roles como:

- **Senior DevOps Engineer** - $130,000-$180,000 USD
- **Site Reliability Engineer** - $140,000-$200,000 USD
- **Platform Engineer** - $135,000-$190,000 USD
- **Infrastructure Architect** - $150,000-$220,000 USD

### Próximos Pasos

Estás listo para el **Módulo 8: Proyectos Avanzados** donde aprenderás:

- **Integración con APIs** y servicios modernos
- **Containerización** con Docker
- **CI/CD** y automatización empresarial
- **Distribución y empaquetado** de herramientas

### Certificación del Módulo

Para obtener la certificación del Módulo 7:

1. ✅ Completa todas las lecciones con sus ejercicios
2. ✅ Implementa el Proyecto Práctico 7 completo
3. ✅ Supera el examen de evaluación técnica
4. ✅ Presenta tu refactorización funcionando

---

## 🔗 NAVEGACIÓN DEL BOOTCAMP

| ← Anterior                                                 | Actual                                 | Siguiente →                                           |
| ---------------------------------------------------------- | -------------------------------------- | ----------------------------------------------------- |
| [Módulo 6: Herramientas del Sistema](../modulo6/README.md) | **Módulo 7: Optimización y Debugging** | [Módulo 8: Proyectos Avanzados](../modulo8/README.md) |

---

<div align="center">
  <p><strong>¡Felicitaciones! Has completado el Módulo 7 🎉</strong></p>
  <p>Ahora eres oficialmente un <strong>Desarrollador de Bash Profesional</strong></p>
  
  [![Volver al Inicio](https://img.shields.io/badge/⬅️_Volver_al_Inicio-blue?style=for-the-badge)](../README.md)
  [![Siguiente Módulo](https://img.shields.io/badge/Módulo_8_➡️-green?style=for-the-badge)](../modulo8/README.md)
</div>

**¡El módulo final te espera para completar tu transformación! 🚀**
