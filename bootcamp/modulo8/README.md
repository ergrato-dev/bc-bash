# MÓDULO 8: PROYECTOS AVANZADOS Y AUTOMATIZACIÓN

![Módulo 8 Logo](../assets/module-8-logo.svg)

## 🎯 VISIÓN GENERAL DEL MÓDULO

El **Módulo 8** representa la culminación del Bootcamp Bash Scripting. Aquí integrarás todo lo aprendido en los módulos anteriores para crear **sistemas de automatización complejos** y **proyectos de nivel empresarial**. Este módulo transforma a los participantes en **arquitectos de automatización** capaces de diseñar e implementar soluciones robustas para entornos de producción.

### 🏆 Lo que Lograrás

Al completar este módulo serás capaz de:

- Diseñar arquitecturas de automatización escalables y mantenibles
- Implementar sistemas de orquestación de procesos complejos
- Crear herramientas de DevOps y CI/CD usando Bash
- Desarrollar sistemas de monitoreo y alertas automatizadas
- Integrar Bash con APIs, bases de datos y servicios externos
- Construir frameworks reutilizables para automatización empresarial

---

## 📚 ESTRUCTURA DEL MÓDULO

### 📖 Lecciones Principales

#### **Lección 8.1: Arquitectura de Sistemas de Automatización**

- Diseño de arquitecturas escalables y modulares
- Patrones de diseño para automatización
- Gestión de configuración centralizada
- Manejo de dependencias y versionado

#### **Lección 8.2: Orquestación de Procesos y Workflows**

- Diseño de workflows complejos y pipeline automation
- Manejo de estados y transiciones
- Sistemas de colas y procesamiento asíncrono
- Gestión de errores y recovery automático

#### **Lección 8.3: Integración con Ecosistemas Externos**

- Integración con APIs REST y GraphQL
- Conectores de bases de datos y sistemas externos
- Automatización de servicios cloud (AWS, GCP, Azure)
- Herramientas de contenedores y orquestación

#### **Lección 8.4: Frameworks y Herramientas Empresariales**

- Desarrollo de frameworks reutilizables
- Sistemas de configuración y templating
- Herramientas de DevOps y CI/CD
- Automatización de infraestructura como código

---

## 🎯 OBJETIVOS DE APRENDIZAJE

### Competencias Técnicas

- **Arquitectura de Software**: Diseñar sistemas modulares y escalables
- **Orquestación**: Coordinar procesos complejos y workflows
- **Integración**: Conectar sistemas heterogéneos de manera robusta
- **DevOps**: Implementar pipelines de CI/CD y automatización de infraestructura
- **Monitoreo**: Crear sistemas de observabilidad y alertas inteligentes

### Competencias Profesionales

- **Pensamiento Sistémico**: Analizar problemas complejos de automatización
- **Documentación Técnica**: Crear documentación de nivel empresarial
- **Gestión de Proyectos**: Planificar y ejecutar proyectos de automatización
- **Colaboración**: Trabajar en equipos de DevOps y desarrollo
- **Resolución de Problemas**: Debuggear sistemas complejos de producción

---

## 🛠️ HERRAMIENTAS Y TECNOLOGÍAS

### Tecnologías Core

- **Bash Advanced**: Arrays asociativos, coprocessos, networking
- **JSON/YAML**: Parsing y generación de configuraciones
- **Git Hooks**: Automatización de workflows de desarrollo
- **Cron/Systemd**: Scheduling y servicios del sistema

### Integraciones

- **APIs**: curl, jq, webhook handling
- **Databases**: Conectores MySQL/PostgreSQL/MongoDB
- **Cloud Services**: AWS CLI, gcloud, az
- **Containers**: Docker, Kubernetes integration
- **Monitoring**: Prometheus, Grafana, custom metrics

### Herramientas de Desarrollo

- **Testing**: Framework de testing avanzado
- **Documentation**: Generación automática de docs
- **Deployment**: Sistemas de deployment automatizado
- **Security**: Escáneo y validación de seguridad

---

## 🔧 LECCIÓN 8.1: ARQUITECTURA DE SISTEMAS DE AUTOMATIZACIÓN

### Concepto: De Scripts Aislados a Sistemas Coherentes

La diferencia entre un conjunto de scripts y un **sistema de automatización** radica en el diseño arquitectural. Un sistema bien diseñado es modular, mantenible, escalable y resiliente.

### 8.1.1 Patrones de Arquitectura para Automatización

#### **Patrón MVC para Scripts Complejos**

```bash
#!/bin/bash
# Framework MVC para automatización
# Estructura: Model-View-Controller adaptada a Bash

# === MODEL: Gestión de datos y estado ===
source "$(dirname "${BASH_SOURCE[0]}")/lib/model.sh"
source "$(dirname "${BASH_SOURCE[0]}")/lib/config.sh"

# === VIEW: Presentación y logging ===
source "$(dirname "${BASH_SOURCE[0]}")/lib/view.sh"
source "$(dirname "${BASH_SOURCE[0]}")/lib/logger.sh"

# === CONTROLLER: Lógica de negocio ===
source "$(dirname "${BASH_SOURCE[0]}")/lib/controller.sh"
source "$(dirname "${BASH_SOURCE[0]}")/lib/workflow.sh"

# Punto de entrada principal
main() {
    # Inicializar componentes
    config_load "$@"
    logger_init
    view_init

    # Ejecutar workflow
    controller_execute_workflow

    # Cleanup
    cleanup_all
}

# Ejecutar solo si es llamado directamente
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
```

#### **Sistema de Configuración Centralizada**

```bash
#!/bin/bash
# lib/config.sh - Sistema de configuración avanzado

declare -A CONFIG
declare -A CONFIG_METADATA

# Configuración con validación y tipos
config_define() {
    local key="$1"
    local default_value="$2"
    local type="${3:-string}"
    local description="$4"
    local required="${5:-false}"

    CONFIG["$key"]="$default_value"
    CONFIG_METADATA["${key}_type"]="$type"
    CONFIG_METADATA["${key}_desc"]="$description"
    CONFIG_METADATA["${key}_required"]="$required"
}

config_load_from_file() {
    local config_file="$1"

    [[ ! -f "$config_file" ]] && return 1

    # Cargar configuración de forma segura
    while IFS='=' read -r key value; do
        # Ignorar comentarios y líneas vacías
        [[ "$key" =~ ^[[:space:]]*# ]] && continue
        [[ -z "$key" ]] && continue

        # Validar que la configuración existe
        if [[ -n "${CONFIG_METADATA[${key}_type]}" ]]; then
            config_set "$key" "$value"
        else
            logger_warn "Configuración desconocida: $key"
        fi
    done < "$config_file"
}

config_set() {
    local key="$1"
    local value="$2"
    local type="${CONFIG_METADATA[${key}_type]:-string}"

    # Validar tipo
    case "$type" in
        "int")
            [[ "$value" =~ ^[0-9]+$ ]] || {
                logger_error "Valor inválido para $key: debe ser entero"
                return 1
            }
            ;;
        "bool")
            [[ "$value" =~ ^(true|false|yes|no|1|0)$ ]] || {
                logger_error "Valor inválido para $key: debe ser booleano"
                return 1
            }
            ;;
        "file")
            [[ -f "$value" ]] || {
                logger_error "Archivo no encontrado para $key: $value"
                return 1
            }
            ;;
        "dir")
            [[ -d "$value" ]] || {
                logger_error "Directorio no encontrado para $key: $value"
                return 1
            }
            ;;
    esac

    CONFIG["$key"]="$value"
    logger_debug "Configuración actualizada: $key=$value"
}

config_get() {
    local key="$1"
    local default="$2"

    echo "${CONFIG[$key]:-$default}"
}

# Ejemplo de configuración
config_init() {
    # Configuraciones del sistema
    config_define "app.name" "AutomationSystem" "string" "Nombre de la aplicación"
    config_define "app.version" "1.0.0" "string" "Versión de la aplicación"
    config_define "app.debug" "false" "bool" "Modo debug activado"

    # Configuraciones de logging
    config_define "log.level" "INFO" "string" "Nivel de logging"
    config_define "log.file" "/tmp/automation.log" "string" "Archivo de log"
    config_define "log.max_size" "100" "int" "Tamaño máximo del log en MB"

    # Configuraciones de ejecución
    config_define "exec.timeout" "3600" "int" "Timeout en segundos"
    config_define "exec.max_parallel" "5" "int" "Procesos paralelos máximos"
    config_define "exec.retry_count" "3" "int" "Intentos de reintento"

    # Cargar configuraciones de archivos
    local config_files=(
        "/etc/automation/config"
        "$HOME/.automation/config"
        "./config/automation.conf"
    )

    for config_file in "${config_files[@]}"; do
        [[ -f "$config_file" ]] && config_load_from_file "$config_file"
    done
}
```

### 8.1.2 Sistema de Módulos y Dependencias

#### **Gestor de Módulos Dinámico**

```bash
#!/bin/bash
# lib/module_manager.sh - Sistema de gestión de módulos

declare -A LOADED_MODULES
declare -A MODULE_DEPENDENCIES
declare -A MODULE_VERSIONS

module_define() {
    local module_name="$1"
    local module_path="$2"
    local version="${3:-1.0.0}"
    local dependencies="$4"  # "mod1,mod2,mod3"

    MODULE_DEPENDENCIES["$module_name"]="$dependencies"
    MODULE_VERSIONS["$module_name"]="$version"

    logger_debug "Módulo definido: $module_name v$version"
}

module_load() {
    local module_name="$1"
    local force_reload="${2:-false}"

    # Verificar si ya está cargado
    if [[ "${LOADED_MODULES[$module_name]}" == "true" && "$force_reload" != "true" ]]; then
        return 0
    fi

    logger_info "Cargando módulo: $module_name"

    # Cargar dependencias primero
    local dependencies="${MODULE_DEPENDENCIES[$module_name]}"
    if [[ -n "$dependencies" ]]; then
        IFS=',' read -ra deps <<< "$dependencies"
        for dep in "${deps[@]}"; do
            module_load "$dep" || {
                logger_error "Error cargando dependencia: $dep"
                return 1
            }
        done
    fi

    # Cargar el módulo
    local module_path="modules/${module_name}.sh"
    if [[ -f "$module_path" ]]; then
        source "$module_path" || {
            logger_error "Error cargando módulo: $module_name"
            return 1
        }

        # Ejecutar función de inicialización si existe
        if declare -f "${module_name}_init" &>/dev/null; then
            "${module_name}_init" || {
                logger_error "Error inicializando módulo: $module_name"
                return 1
            }
        fi

        LOADED_MODULES["$module_name"]="true"
        logger_info "Módulo cargado exitosamente: $module_name"
        return 0
    else
        logger_error "Módulo no encontrado: $module_path"
        return 1
    fi
}

module_unload() {
    local module_name="$1"

    # Ejecutar función de cleanup si existe
    if declare -f "${module_name}_cleanup" &>/dev/null; then
        "${module_name}_cleanup"
    fi

    unset LOADED_MODULES["$module_name"]
    logger_info "Módulo descargado: $module_name"
}

module_list() {
    echo "=== MÓDULOS CARGADOS ==="
    for module in "${!LOADED_MODULES[@]}"; do
        local version="${MODULE_VERSIONS[$module]}"
        echo "  $module v$version"
    done
}

# Definir módulos del sistema
module_system_init() {
    module_define "logger" "lib/logger.sh" "2.0.0" ""
    module_define "config" "lib/config.sh" "1.5.0" "logger"
    module_define "database" "lib/database.sh" "1.0.0" "logger,config"
    module_define "api_client" "lib/api_client.sh" "1.2.0" "logger,config"
    module_define "workflow" "lib/workflow.sh" "1.0.0" "logger,config,database"
}
```

### 8.1.3 Sistema de Versionado y Distribución

#### **Gestor de Versiones Automático**

```bash
#!/bin/bash
# tools/version_manager.sh - Sistema de versionado semántico

VERSION_FILE="VERSION"
CHANGELOG_FILE="CHANGELOG.md"

version_get_current() {
    [[ -f "$VERSION_FILE" ]] && cat "$VERSION_FILE" || echo "0.0.0"
}

version_parse() {
    local version="$1"
    local parts

    IFS='.' read -ra parts <<< "$version"
    echo "${parts[0]:-0}" "${parts[1]:-0}" "${parts[2]:-0}"
}

version_increment() {
    local type="$1"  # major, minor, patch
    local current_version
    current_version=$(version_get_current)

    read -r major minor patch <<< "$(version_parse "$current_version")"

    case "$type" in
        "major")
            ((major++))
            minor=0
            patch=0
            ;;
        "minor")
            ((minor++))
            patch=0
            ;;
        "patch")
            ((patch++))
            ;;
        *)
            logger_error "Tipo de versión inválido: $type"
            return 1
            ;;
    esac

    local new_version="$major.$minor.$patch"
    echo "$new_version" > "$VERSION_FILE"

    logger_info "Versión actualizada: $current_version → $new_version"
    echo "$new_version"
}

version_tag_release() {
    local version="$1"
    local message="${2:-Release version $version}"

    # Crear tag de git
    git tag -a "v$version" -m "$message"

    # Generar release notes
    version_generate_release_notes "$version"

    logger_info "Release tagged: v$version"
}

version_generate_release_notes() {
    local version="$1"
    local since_tag
    since_tag=$(git describe --tags --abbrev=0 HEAD^ 2>/dev/null || echo "")

    local output_file="releases/v${version}.md"
    mkdir -p "releases"

    {
        echo "# Release v$version"
        echo ""
        echo "Release Date: $(date '+%Y-%m-%d')"
        echo ""
        echo "## Changes"
        echo ""

        if [[ -n "$since_tag" ]]; then
            git log --pretty=format:"- %s" "$since_tag..HEAD"
        else
            git log --pretty=format:"- %s"
        fi

        echo ""
        echo ""
        echo "## Files Changed"
        echo ""

        if [[ -n "$since_tag" ]]; then
            git diff --name-only "$since_tag..HEAD" | sed 's/^/- /'
        fi

    } > "$output_file"

    logger_info "Release notes generadas: $output_file"
}
```

---

## 🔧 LECCIÓN 8.2: ORQUESTACIÓN DE PROCESOS Y WORKFLOWS

### Concepto: Coordinación Inteligente de Procesos

La orquestación va más allá de ejecutar scripts en secuencia. Implica gestión de estado, manejo de errores sofisticado, recuperación automática y coordinación de procesos distribuidos.

### 8.2.1 Engine de Workflows Avanzado

#### **Workflow Engine con Estados**

```bash
#!/bin/bash
# lib/workflow_engine.sh - Motor de workflows con estados

declare -A WORKFLOW_STEPS
declare -A WORKFLOW_STATE
declare -A WORKFLOW_METADATA

# Estados posibles: pending, running, completed, failed, skipped
workflow_define_step() {
    local workflow_id="$1"
    local step_id="$2"
    local command="$3"
    local dependencies="$4"
    local timeout="${5:-300}"
    local retry_count="${6:-1}"

    local step_key="${workflow_id}.${step_id}"

    WORKFLOW_STEPS["$step_key"]="$command"
    WORKFLOW_STATE["${step_key}.status"]="pending"
    WORKFLOW_STATE["${step_key}.dependencies"]="$dependencies"
    WORKFLOW_STATE["${step_key}.timeout"]="$timeout"
    WORKFLOW_STATE["${step_key}.retry_count"]="$retry_count"
    WORKFLOW_STATE["${step_key}.current_retry"]="0"

    logger_debug "Workflow step definido: $step_key"
}

workflow_can_execute() {
    local workflow_id="$1"
    local step_id="$2"
    local step_key="${workflow_id}.${step_id}"

    # Verificar que el step esté pendiente
    local status="${WORKFLOW_STATE[${step_key}.status]}"
    [[ "$status" != "pending" ]] && return 1

    # Verificar dependencias
    local dependencies="${WORKFLOW_STATE[${step_key}.dependencies]}"
    if [[ -n "$dependencies" ]]; then
        IFS=',' read -ra deps <<< "$dependencies"
        for dep in "${deps[@]}"; do
            local dep_status="${WORKFLOW_STATE[${workflow_id}.${dep}.status]}"
            if [[ "$dep_status" != "completed" ]]; then
                return 1
            fi
        done
    fi

    return 0
}

workflow_execute_step() {
    local workflow_id="$1"
    local step_id="$2"
    local step_key="${workflow_id}.${step_id}"

    local command="${WORKFLOW_STEPS[$step_key]}"
    local timeout="${WORKFLOW_STATE[${step_key}.timeout]}"
    local max_retries="${WORKFLOW_STATE[${step_key}.retry_count]}"
    local current_retry="${WORKFLOW_STATE[${step_key}.current_retry]}"

    logger_info "Ejecutando step: $step_key (intento $((current_retry + 1))/$max_retries)"

    # Marcar como running
    WORKFLOW_STATE["${step_key}.status"]="running"
    WORKFLOW_STATE["${step_key}.start_time"]=$(date +%s)

    # Ejecutar con timeout
    local output_file="/tmp/workflow_${workflow_id}_${step_id}_output"
    local exit_code

    if timeout "$timeout" bash -c "$command" &> "$output_file"; then
        # Éxito
        WORKFLOW_STATE["${step_key}.status"]="completed"
        WORKFLOW_STATE["${step_key}.end_time"]=$(date +%s)
        WORKFLOW_STATE["${step_key}.output"]="$output_file"

        logger_info "Step completado: $step_key"
        return 0
    else
        exit_code=$?

        # Incrementar contador de reintentos
        ((current_retry++))
        WORKFLOW_STATE["${step_key}.current_retry"]="$current_retry"

        if [[ "$current_retry" -lt "$max_retries" ]]; then
            # Reintentar
            WORKFLOW_STATE["${step_key}.status"]="pending"
            logger_warn "Step falló, reintentando: $step_key ($current_retry/$max_retries)"
            sleep $((current_retry * 2))  # Backoff exponencial
            workflow_execute_step "$workflow_id" "$step_id"
        else
            # Fallo definitivo
            WORKFLOW_STATE["${step_key}.status"]="failed"
            WORKFLOW_STATE["${step_key}.error_code"]="$exit_code"
            WORKFLOW_STATE["${step_key}.error_output"]="$output_file"

            logger_error "Step falló definitivamente: $step_key (código: $exit_code)"
            return 1
        fi
    fi
}

workflow_execute() {
    local workflow_id="$1"
    local max_parallel="${2:-3}"

    logger_info "Iniciando workflow: $workflow_id (max_parallel: $max_parallel)"

    local running_jobs=0
    local completed_steps=0
    local failed_steps=0
    local total_steps

    # Contar total de steps
    total_steps=$(printf '%s\n' "${!WORKFLOW_STEPS[@]}" | grep "^${workflow_id}\." | wc -l)

    while [[ $((completed_steps + failed_steps)) -lt $total_steps ]]; do
        # Buscar steps que pueden ejecutarse
        for step_key in "${!WORKFLOW_STEPS[@]}"; do
            [[ "$step_key" =~ ^${workflow_id}\.(.+)$ ]] || continue
            local step_id="${BASH_REMATCH[1]}"

            # Verificar si puede ejecutarse y no hay demasiados jobs
            if workflow_can_execute "$workflow_id" "$step_id" && [[ $running_jobs -lt $max_parallel ]]; then
                # Ejecutar en background
                (
                    workflow_execute_step "$workflow_id" "$step_id"
                    echo "$step_key:$?" > "/tmp/workflow_${workflow_id}_${step_id}_result"
                ) &

                ((running_jobs++))
                logger_debug "Job iniciado para step: $step_key (running: $running_jobs)"
            fi
        done

        # Verificar jobs completados
        for step_key in "${!WORKFLOW_STEPS[@]}"; do
            [[ "$step_key" =~ ^${workflow_id}\.(.+)$ ]] || continue
            local step_id="${BASH_REMATCH[1]}"
            local result_file="/tmp/workflow_${workflow_id}_${step_id}_result"

            if [[ -f "$result_file" ]]; then
                local result
                result=$(cat "$result_file")
                rm "$result_file"

                local exit_code="${result#*:}"

                ((running_jobs--))

                if [[ "$exit_code" == "0" ]]; then
                    ((completed_steps++))
                else
                    ((failed_steps++))
                fi

                logger_debug "Job terminado: $step_key (exit: $exit_code, running: $running_jobs)"
            fi
        done

        # Evitar busy wait
        sleep 1
    done

    # Esperar jobs restantes
    wait

    if [[ $failed_steps -gt 0 ]]; then
        logger_error "Workflow completado con errores: $workflow_id ($failed_steps fallos)"
        return 1
    else
        logger_info "Workflow completado exitosamente: $workflow_id ($completed_steps steps)"
        return 0
    fi
}

workflow_status() {
    local workflow_id="$1"

    echo "=== ESTADO DEL WORKFLOW: $workflow_id ==="
    printf "%-20s %-10s %-10s %-10s\n" "STEP" "ESTADO" "REINTENTOS" "TIEMPO"
    echo "--------------------------------------------------------"

    for step_key in "${!WORKFLOW_STEPS[@]}"; do
        [[ "$step_key" =~ ^${workflow_id}\.(.+)$ ]] || continue
        local step_id="${BASH_REMATCH[1]}"

        local status="${WORKFLOW_STATE[${step_key}.status]}"
        local retries="${WORKFLOW_STATE[${step_key}.current_retry]}"
        local start_time="${WORKFLOW_STATE[${step_key}.start_time]}"
        local end_time="${WORKFLOW_STATE[${step_key}.end_time]}"

        local duration=""
        if [[ -n "$start_time" && -n "$end_time" ]]; then
            duration="$((end_time - start_time))s"
        elif [[ -n "$start_time" ]]; then
            duration="$(($(date +%s) - start_time))s"
        fi

        printf "%-20s %-10s %-10s %-10s\n" "$step_id" "$status" "$retries" "$duration"
    done
}
```

### 8.2.2 Sistema de Colas y Procesamiento Asíncrono

#### **Queue Manager con Prioridades**

```bash
#!/bin/bash
# lib/queue_manager.sh - Sistema de colas con prioridades

QUEUE_DIR="${QUEUE_DIR:-/tmp/automation_queues}"
QUEUE_WORKERS="${QUEUE_WORKERS:-3}"

queue_init() {
    mkdir -p "$QUEUE_DIR"/{high,normal,low,processing,completed,failed}

    # Crear archivo de control de workers
    echo "0" > "$QUEUE_DIR/active_workers"
}

queue_add_job() {
    local job_id="$1"
    local command="$2"
    local priority="${3:-normal}"  # high, normal, low
    local metadata="$4"

    local job_file="$QUEUE_DIR/$priority/${job_id}.job"

    {
        echo "ID=$job_id"
        echo "PRIORITY=$priority"
        echo "CREATED=$(date +%s)"
        echo "COMMAND=$command"
        echo "METADATA=$metadata"
        echo "STATUS=queued"
    } > "$job_file"

    logger_info "Job añadido a cola: $job_id (prioridad: $priority)"
}

queue_get_next_job() {
    local priorities=("high" "normal" "low")

    for priority in "${priorities[@]}"; do
        local job_file
        job_file=$(find "$QUEUE_DIR/$priority" -name "*.job" -type f | head -n1)

        if [[ -n "$job_file" ]]; then
            local job_id
            job_id=$(basename "$job_file" .job)

            # Mover a processing
            mv "$job_file" "$QUEUE_DIR/processing/"

            echo "$job_id"
            return 0
        fi
    done

    return 1
}

queue_process_job() {
    local job_id="$1"
    local job_file="$QUEUE_DIR/processing/${job_id}.job"

    [[ ! -f "$job_file" ]] && {
        logger_error "Job no encontrado: $job_id"
        return 1
    }

    # Cargar información del job
    source "$job_file"

    logger_info "Procesando job: $job_id"

    # Actualizar estado
    sed -i 's/STATUS=.*/STATUS=running/' "$job_file"
    echo "STARTED=$(date +%s)" >> "$job_file"

    # Ejecutar comando
    local output_file="$QUEUE_DIR/processing/${job_id}.output"
    local exit_code

    if eval "$COMMAND" &> "$output_file"; then
        # Éxito
        echo "COMPLETED=$(date +%s)" >> "$job_file"
        echo "EXIT_CODE=0" >> "$job_file"
        sed -i 's/STATUS=.*/STATUS=completed/' "$job_file"

        # Mover a completed
        mv "$job_file" "$QUEUE_DIR/completed/"
        mv "$output_file" "$QUEUE_DIR/completed/${job_id}.output"

        logger_info "Job completado: $job_id"
        return 0
    else
        exit_code=$?

        # Fallo
        echo "COMPLETED=$(date +%s)" >> "$job_file"
        echo "EXIT_CODE=$exit_code" >> "$job_file"
        sed -i 's/STATUS=.*/STATUS=failed/' "$job_file"

        # Mover a failed
        mv "$job_file" "$QUEUE_DIR/failed/"
        mv "$output_file" "$QUEUE_DIR/failed/${job_id}.output"

        logger_error "Job falló: $job_id (código: $exit_code)"
        return 1
    fi
}

queue_status() {
    echo "=== ESTADO DE COLAS ==="

    local priorities=("high" "normal" "low")
    for priority in "${priorities[@]}"; do
        local count
        count=$(find "$QUEUE_DIR/$priority" -name "*.job" | wc -l)
        echo "Cola $priority: $count jobs"
    done

    local processing
    processing=$(find "$QUEUE_DIR/processing" -name "*.job" | wc -l)
    echo "Procesando: $processing jobs"

    local completed
    completed=$(find "$QUEUE_DIR/completed" -name "*.job" | wc -l)
    echo "Completados: $completed jobs"

    local failed
    failed=$(find "$QUEUE_DIR/failed" -name "*.job" | wc -l)
    echo "Fallidos: $failed jobs"

    local active_workers
    active_workers=$(cat "$QUEUE_DIR/active_workers" 2>/dev/null || echo "0")
    echo "Workers activos: $active_workers"
}
```

---

## 🔧 LECCIÓN 8.3: INTEGRACIÓN CON ECOSISTEMAS EXTERNOS

### 8.3.1 Cliente de APIs Avanzado

#### **HTTP Client con Autenticación y Retry**

```bash
#!/bin/bash
# lib/api_client.sh - Cliente HTTP avanzado

API_BASE_URL=""
API_TOKEN=""
API_TIMEOUT="${API_TIMEOUT:-30}"
API_MAX_RETRIES="${API_MAX_RETRIES:-3}"

api_init() {
    local base_url="$1"
    local token="$2"

    API_BASE_URL="$base_url"
    API_TOKEN="$token"

    logger_debug "API client inicializado: $base_url"
}

api_request() {
    local method="$1"
    local endpoint="$2"
    local data="$3"
    local content_type="${4:-application/json}"
    local retry_count=0

    local url="${API_BASE_URL}${endpoint}"
    local response_file="/tmp/api_response_$$"
    local headers_file="/tmp/api_headers_$$"

    # Preparar headers
    local curl_args=(
        --silent
        --show-error
        --location
        --max-time "$API_TIMEOUT"
        --write-out "%{http_code}"
        --dump-header "$headers_file"
        --output "$response_file"
    )

    # Autenticación
    if [[ -n "$API_TOKEN" ]]; then
        curl_args+=(--header "Authorization: Bearer $API_TOKEN")
    fi

    # Content-Type
    if [[ -n "$data" ]]; then
        curl_args+=(
            --header "Content-Type: $content_type"
            --data "$data"
        )
    fi

    # Método HTTP
    curl_args+=(--request "$method")

    while [[ $retry_count -le $API_MAX_RETRIES ]]; do
        logger_debug "API request: $method $url (intento $((retry_count + 1)))"

        local http_code
        http_code=$(curl "${curl_args[@]}" "$url" 2>/dev/null)
        local curl_exit_code=$?

        if [[ $curl_exit_code -eq 0 ]]; then
            # Verificar código HTTP
            case "$http_code" in
                2[0-9][0-9])
                    # Éxito
                    logger_debug "API response: $http_code"

                    # Retornar respuesta
                    cat "$response_file"

                    # Cleanup
                    rm -f "$response_file" "$headers_file"
                    return 0
                    ;;
                4[0-9][0-9])
                    # Error del cliente (no reintentar)
                    logger_error "API error $http_code: $(cat "$response_file")"
                    rm -f "$response_file" "$headers_file"
                    return 1
                    ;;
                5[0-9][0-9])
                    # Error del servidor (reintentar)
                    logger_warn "API server error $http_code, reintentando..."
                    ;;
                *)
                    logger_warn "API response desconocida: $http_code"
                    ;;
            esac
        else
            logger_warn "Error de conexión (código curl: $curl_exit_code)"
        fi

        ((retry_count++))

        if [[ $retry_count -le $API_MAX_RETRIES ]]; then
            local wait_time=$((retry_count * 2))
            logger_debug "Esperando ${wait_time}s antes del siguiente intento"
            sleep $wait_time
        fi
    done

    # Falló después de todos los reintentos
    logger_error "API request falló después de $API_MAX_RETRIES reintentos"
    rm -f "$response_file" "$headers_file"
    return 1
}

# Métodos HTTP convenientes
api_get() {
    api_request "GET" "$1"
}

api_post() {
    api_request "POST" "$1" "$2" "${3:-application/json}"
}

api_put() {
    api_request "PUT" "$1" "$2" "${3:-application/json}"
}

api_delete() {
    api_request "DELETE" "$1"
}

api_patch() {
    api_request "PATCH" "$1" "$2" "${3:-application/json}"
}

# Helper para JSON
api_post_json() {
    local endpoint="$1"
    local json_data="$2"

    api_post "$endpoint" "$json_data" "application/json"
}

# Helper para form data
api_post_form() {
    local endpoint="$1"
    local form_data="$2"

    api_post "$endpoint" "$form_data" "application/x-www-form-urlencoded"
}

# Ejemplo de uso con autenticación OAuth2
api_oauth2_login() {
    local client_id="$1"
    local client_secret="$2"
    local auth_url="$3"

    local auth_data="grant_type=client_credentials&client_id=$client_id&client_secret=$client_secret"

    local response
    response=$(api_post_form "/oauth/token" "$auth_data")

    if [[ $? -eq 0 ]]; then
        local token
        token=$(echo "$response" | jq -r '.access_token')

        if [[ "$token" != "null" && -n "$token" ]]; then
            API_TOKEN="$token"
            logger_info "Autenticación OAuth2 exitosa"
            return 0
        fi
    fi

    logger_error "Error en autenticación OAuth2"
    return 1
}
```

---

## 🎯 PROYECTO PRÁCTICO: SISTEMA DE AUTOMATIZACIÓN EMPRESARIAL

### Desafío: "DevOps Automation Hub"

Desarrollarás un **sistema completo de automatización** que integre todas las técnicas aprendidas en el módulo. Este proyecto simula un entorno empresarial real donde necesitas coordinar múltiples procesos, integrar sistemas externos y mantener alta disponibilidad.

#### **Requerimientos del Sistema:**

1. **Dashboard de Control**

   - Interfaz web simple para monitorear workflows
   - Estado en tiempo real de todos los procesos
   - Métricas de performance y alertas

2. **Pipeline de CI/CD**

   - Detección automática de cambios en Git
   - Ejecución de tests y validaciones
   - Deployment automatizado a múltiples entornos

3. **Sistema de Monitoreo**

   - Recolección de métricas de sistema
   - Alertas inteligentes por email/Slack
   - Reportes automáticos de performance

4. **Backup y Recovery**
   - Backup automático de bases de datos
   - Sincronización con cloud storage
   - Procedimientos de recovery automatizados

### 📋 Criterios de Evaluación

#### **Excelencia Técnica (40%)**

- **Arquitectura Modular**: Sistema bien estructurado y mantenible
- **Gestión de Errores**: Manejo robusto de fallos y recovery
- **Performance**: Optimización para alta carga y eficiencia
- **Seguridad**: Implementación de mejores prácticas de seguridad

#### **Integración y Automatización (35%)**

- **APIs**: Integración fluida con servicios externos
- **Workflows**: Orquestación compleja de procesos
- **Monitoring**: Sistema de observabilidad completo
- **Escalabilidad**: Capacidad de manejar carga creciente

#### **Documentación y Mantenibilidad (25%)**

- **Documentación Técnica**: Guías claras de instalación y uso
- **Código Limpio**: Estándares de codificación y comentarios
- **Testing**: Suite de tests automatizados
- **Operabilidad**: Facilidad de deployment y mantenimiento

---

## 🎓 CONCLUSIONES DEL MÓDULO

### Lo que Has Logrado

Al completar este módulo has alcanzado el nivel de **Arquitecto de Automatización**, capaz de:

- ✅ Diseñar sistemas complejos de automatización
- ✅ Integrar múltiples tecnologías y servicios
- ✅ Implementar patrones empresariales en Bash
- ✅ Crear herramientas reutilizables y escalables
- ✅ Manejar workflows distribuidos y concurrentes

### Competencias Profesionales Desarrolladas

**Técnicas:**

- Arquitectura de software para automatización
- Integración de sistemas heterogéneos
- Orquestación de procesos complejos
- Desarrollo de frameworks empresariales

**Metodológicas:**

- Análisis de requerimientos de automatización
- Diseño de soluciones escalables
- Gestión de proyectos técnicos
- Documentación de sistemas complejos

**Personales:**

- Pensamiento sistémico y arquitectural
- Resolución de problemas complejos
- Comunicación técnica efectiva
- Liderazgo en equipos de automatización

---

## 🧭 NAVEGACIÓN DEL BOOTCAMP

### ⬅️ Módulo Anterior

**[MÓDULO 7: Optimización y Debugging](../modulo7/README.md)**

- Debugging y troubleshooting profesional
- Optimización de performance avanzada
- Seguridad y auditoría de scripts
- Herramientas de monitoring y profiling

### 📚 Recursos Adicionales

#### **Documentación Técnica**

- [Guías de Automatización](../_docs/automation/)
- [Patrones de Arquitectura](../_docs/patterns/)
- [Casos de Uso Empresariales](../_docs/enterprise/)

#### **Herramientas y Scripts**

- [Framework de Automatización](./tools/automation-framework/)
- [Templates de Proyectos](./templates/)
- [Ejemplos de Integración](./examples/)

#### **Proyecto Final**

- [Especificaciones del Proyecto](./proyectos/devops-automation-hub/)
- [Criterios de Evaluación](./proyectos/evaluation-criteria.md)
- [Entrega y Presentación](./proyectos/submission-guide.md)

---

## 🏆 CERTIFICACIÓN

### Requisitos para Certificación

Para obtener la **certificación oficial del Bootcamp Bash Scripting** debes completar:

1. ✅ Todos los ejercicios de los 8 módulos
2. ✅ Los 8 proyectos prácticos modulares
3. ✅ El proyecto final del Módulo 8
4. ✅ La evaluación técnica final

### Próximos Pasos

**¡Felicitaciones por completar el bootcamp!** 🎉

Como **Bash Scripting Expert** certificado, estás preparado para:

- Liderar proyectos de automatización empresarial
- Diseñar arquitecturas DevOps robustas
- Mentorear equipos en scripting avanzado
- Contribuir a proyectos open source de automatización

---

_¡Has completado un viaje extraordinario desde scripts básicos hasta arquitecturas empresariales complejas! Tu expertise en Bash scripting te abre puertas a roles avanzados en DevOps, SRE, y Arquitectura de Sistemas._

**¡Ahora eres oficialmente un Bash Hero!** 🦸‍♂️🦸‍♀️
