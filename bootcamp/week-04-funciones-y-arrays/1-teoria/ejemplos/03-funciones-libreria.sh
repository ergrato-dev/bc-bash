#!/bin/bash
# Ejemplo 03: Biblioteca de Funciones Reutilizables
# Descripción: Crear y usar librerías de funciones

echo "=== Biblioteca de Funciones Reutilizables ==="

# === SECCIÓN: UTILIDADES DE STRINGS ===

# Convertir a mayúsculas
to_upper() {
    echo "${1^^}"
}

# Convertir a minúsculas
to_lower() {
    echo "${1,,}"
}

# Capitalizar primera letra
capitalize() {
    local str="$1"
    echo "${str^}"
}

# Invertir string
reverse_string() {
    echo "$1" | rev
}

# Contar caracteres
count_chars() {
    echo "${#1}"
}

# Repetir string N veces
repeat_string() {
    local str=$1
    local times=$2
    printf "$str%.0s" $(seq 1 "$times")
}

echo -e "\n=== Utilidades de Strings ==="
echo "Mayúsculas: $(to_upper "hola mundo")"
echo "Minúsculas: $(to_lower "HOLA MUNDO")"
echo "Capitalizar: $(capitalize "hola mundo")"
echo "Invertir: $(reverse_string "hola")"
echo "Contar chars: $(count_chars "hello") caracteres"
echo "Repetir: $(repeat_string "ab" 5)"

# === SECCIÓN: VALIDACIONES ===

# Validar si es número
is_number() {
    [[ "$1" =~ ^[0-9]+$ ]]
}

# Validar si es email
is_email() {
    [[ "$1" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]
}

# Validar si archivo existe
file_exists() {
    [ -f "$1" ]
}

# Validar si directorio existe
dir_exists() {
    [ -d "$1" ]
}

# Validar rango numérico
in_range() {
    local num=$1
    local min=$2
    local max=$3
    [ "$num" -ge "$min" ] && [ "$num" -le "$max" ]
}

echo -e "\n=== Validaciones ==="
is_number "123" && echo "✓ '123' es número" || echo "✗ No es número"
is_number "abc" && echo "✓ Es número" || echo "✗ 'abc' no es número"
is_email "user@example.com" && echo "✓ Email válido" || echo "✗ Email inválido"
is_email "invalid-email" && echo "✓ Email válido" || echo "✗ Email inválido"
in_range 5 1 10 && echo "✓ 5 está en rango [1-10]" || echo "✗ Fuera de rango"

# === SECCIÓN: MATEMÁTICAS ===

# Sumar array de números
sum_array() {
    local sum=0
    for num in "$@"; do
        sum=$((sum + num))
    done
    echo $sum
}

# Promedio
average() {
    local sum=$(sum_array "$@")
    local count=$#
    echo $((sum / count))
}

# Máximo
max() {
    local max=$1
    shift
    for num in "$@"; do
        [ "$num" -gt "$max" ] && max=$num
    done
    echo $max
}

# Mínimo
min() {
    local min=$1
    shift
    for num in "$@"; do
        [ "$num" -lt "$min" ] && min=$num
    done
    echo $min
}

# Potencia
power() {
    local base=$1
    local exp=$2
    echo $((base ** exp))
}

echo -e "\n=== Matemáticas ==="
echo "Suma de 1 2 3 4 5: $(sum_array 1 2 3 4 5)"
echo "Promedio de 10 20 30: $(average 10 20 30)"
echo "Máximo de 5 12 8 3: $(max 5 12 8 3)"
echo "Mínimo de 5 12 8 3: $(min 5 12 8 3)"
echo "2^8: $(power 2 8)"

# === SECCIÓN: COLORES Y FORMATO ===

# Colores
color_rojo() { echo -e "\033[0;31m$1\033[0m"; }
color_verde() { echo -e "\033[0;32m$1\033[0m"; }
color_amarillo() { echo -e "\033[1;33m$1\033[0m"; }
color_azul() { echo -e "\033[0;34m$1\033[0m"; }

# Estilos
texto_negrita() { echo -e "\033[1m$1\033[0m"; }
texto_subrayado() { echo -e "\033[4m$1\033[0m"; }

# Iconos
icono_ok() { echo "✓"; }
icono_error() { echo "✗"; }
icono_warning() { echo "⚠"; }
icono_info() { echo "ℹ"; }

echo -e "\n=== Colores y Formato ==="
color_rojo "Texto en rojo"
color_verde "Texto en verde"
color_amarillo "Texto en amarillo"
color_azul "Texto en azul"
texto_negrita "Texto en negrita"
texto_subrayado "Texto subrayado"
echo "$(icono_ok) Operación exitosa"
echo "$(icono_error) Error encontrado"

# === SECCIÓN: FECHA Y HORA ===

# Timestamp actual
get_timestamp() {
    date +%s
}

# Fecha formateada
get_date() {
    date '+%Y-%m-%d'
}

# Hora formateada
get_time() {
    date '+%H:%M:%S'
}

# Fecha y hora completa
get_datetime() {
    date '+%Y-%m-%d %H:%M:%S'
}

# Días desde epoch
days_since_epoch() {
    echo $(($(date +%s) / 86400))
}

echo -e "\n=== Fecha y Hora ==="
echo "Timestamp: $(get_timestamp)"
echo "Fecha: $(get_date)"
echo "Hora: $(get_time)"
echo "Fecha y hora: $(get_datetime)"
echo "Días desde epoch: $(days_since_epoch)"

# === SECCIÓN: ARCHIVOS ===

# Obtener extensión
get_extension() {
    echo "${1##*.}"
}

# Obtener nombre sin extensión
get_basename() {
    local filename=$(basename "$1")
    echo "${filename%.*}"
}

# Tamaño de archivo en KB
get_file_size() {
    if [ -f "$1" ]; then
        du -k "$1" | cut -f1
    else
        echo 0
    fi
}

# Crear backup de archivo
backup_file() {
    local archivo=$1
    if [ -f "$archivo" ]; then
        local backup="${archivo}.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$archivo" "$backup"
        echo "$backup"
    fi
}

echo -e "\n=== Utilidades de Archivos ==="
echo "Extensión de 'script.sh': $(get_extension 'script.sh')"
echo "Nombre sin ext de 'script.sh': $(get_basename 'script.sh')"

# === SECCIÓN: LOGGING ===

# Variable global de nivel de log
LOG_LEVEL=${LOG_LEVEL:-INFO}

# Función de log con niveles
log_msg() {
    local nivel=$1
    shift
    local mensaje="$*"
    echo "[$(get_datetime)] [$nivel] $mensaje"
}

log_debug() {
    [ "$LOG_LEVEL" = "DEBUG" ] && log_msg DEBUG "$@"
}

log_info() {
    log_msg INFO "$@"
}

log_warn() {
    log_msg WARN "$@" >&2
}

log_error() {
    log_msg ERROR "$@" >&2
}

echo -e "\n=== Sistema de Logging ==="
log_info "Este es un mensaje informativo"
log_warn "Este es un warning"
log_error "Este es un error"

# === SECCIÓN: SISTEMA ===

# Obtener uso de CPU
get_cpu_usage() {
    top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}' 2>/dev/null || echo "N/A"
}

# Obtener uso de memoria
get_memory_usage() {
    free | grep Mem | awk '{printf "%.0f", $3/$2 * 100.0}' 2>/dev/null || echo "N/A"
}

# Verificar si comando existe
command_exists() {
    command -v "$1" &> /dev/null
}

# Obtener nombre de OS
get_os() {
    uname -s
}

echo -e "\n=== Información del Sistema ==="
echo "Sistema operativo: $(get_os)"
command_exists git && echo "✓ Git está instalado" || echo "✗ Git no está instalado"
command_exists python && echo "✓ Python está instalado" || echo "✗ Python no está instalado"

# === SECCIÓN: ARRAYS ===

# Unir array con delimitador
join_array() {
    local delimiter=$1
    shift
    local arr=("$@")
    local result=""
    
    for i in "${!arr[@]}"; do
        if [ $i -eq 0 ]; then
            result="${arr[$i]}"
        else
            result="${result}${delimiter}${arr[$i]}"
        fi
    done
    
    echo "$result"
}

# Verificar si elemento está en array
in_array() {
    local buscar=$1
    shift
    local arr=("$@")
    
    for elemento in "${arr[@]}"; do
        [ "$elemento" = "$buscar" ] && return 0
    done
    return 1
}

# Obtener elemento aleatorio
random_element() {
    local arr=("$@")
    local size=${#arr[@]}
    local index=$((RANDOM % size))
    echo "${arr[$index]}"
}

echo -e "\n=== Utilidades de Arrays ==="
echo "Unir array: $(join_array ", " "uno" "dos" "tres" "cuatro")"

mi_array=("perro" "gato" "loro")
in_array "gato" "${mi_array[@]}" && echo "✓ 'gato' está en el array" || echo "✗ No está"
in_array "pez" "${mi_array[@]}" && echo "✓ 'pez' está en el array" || echo "✗ No está"

echo "Elemento aleatorio: $(random_element "a" "b" "c" "d" "e")"

# === EXPORTAR FUNCIONES ===
echo -e "\n=== Uso como Librería ==="
echo "Para usar estas funciones en otros scripts:"
echo "  source ./03-funciones-libreria.sh"
echo ""
echo "Ejemplo:"
echo '  #!/bin/bash'
echo '  source ./03-funciones-libreria.sh'
echo '  log_info "Usando la librería"'
echo '  resultado=$(sum_array 1 2 3 4 5)'
echo '  echo "Suma: $resultado"'

echo -e "\n✓ Script completado"
