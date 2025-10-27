<div align="center">
  <img src="../assets/module-3-logo.svg" alt="Módulo 3: Variables y Control de Flujo" width="300">
</div>

# MÓDULO 3: Variables y Control de Flujo

Bootcamp bash scripting /
de acuerdo con el contexto, vamos con: MÓDULO 3: Primer Script y Variables (Semana 3)

Editar

Planificó módulo de Bash Scripting con lecciones detalladas.
4s

¡Perfecto! Vamos a desarrollar en profundidad el MÓDULO 3: Primer Script y Variables de nuestro bootcamp de Bash Scripting. Este módulo es fundamental porque marca la transición de usar comandos individuales a crear programas completos.

MÓDULO 3: Primer Script y Variables (Semana 3)
Lección 3.1: Creación del Primer Script
Conceptos Fundamentales
Antes de escribir nuestro primer script, necesitamos entender qué hace especial a un archivo de texto para que se convierta en un programa ejecutable en Bash.

El Shebang: La Puerta de Entrada
El shebang es la primera línea de nuestro script y le dice al sistema qué intérprete debe usar para ejecutar el archivo. Es como el "ADN" de nuestro script.

bash
#!/bin/bash

# Este es nuestro primer script de Bash

# El shebang de arriba le dice al sistema: "usa bash para ejecutar este archivo"

echo "¡Hola Mundo! Este es mi primer script en Bash"
¿Por qué es importante el shebang?

Sin él, el sistema no sabrá cómo interpretar nuestro archivo
Garantiza que nuestro script se ejecute con el intérprete correcto
Es una convención universal en sistemas Unix/Linux
Creando Nuestro Primer Script
Vamos a crear paso a paso nuestro primer script:

bash

# Paso 1: Crear el archivo

nano mi_primer_script.sh

# Paso 2: Escribir el contenido

#!/bin/bash

# Script: Mi primer programa en Bash

# Autor: [Tu nombre]

# Fecha: [Fecha actual]

# Descripción: Script introductorio que demuestra conceptos básicos

echo "==========================================="
echo " BIENVENIDO A MI PRIMER SCRIPT BASH"
echo "==========================================="
echo
echo "Hoy es: $(date)"
echo "Estás en el directorio: $(pwd)"
echo "Tu usuario es: $(whoami)"
echo
echo "¡Felicitaciones! Has ejecutado tu primer script."
Permisos de Ejecución: Dando Vida a Nuestro Script
Un archivo de texto no es ejecutable por defecto. Necesitamos otorgarle permisos de ejecución:

bash

# Otorgar permisos de ejecución

chmod +x mi_primer_script.sh

# Verificar los permisos

ls -la mi_primer_script.sh

# Salida esperada: -rwxr-xr-x ... mi_primer_script.sh

# ^^^

# Estos son los permisos de ejecución

Explicación de los permisos:

r (read): Permiso de lectura
w (write): Permiso de escritura
x (execute): Permiso de ejecución
Los permisos se muestran para: propietario, grupo, otros
Formas de Ejecutar Nuestro Script
Existen varias maneras de ejecutar un script en Bash:

bash

# Método 1: Ejecución directa (requiere permisos de ejecución)

./mi_primer_script.sh

# Método 2: Usando el intérprete explícitamente

bash mi_primer_script.sh

# Método 3: Usando el comando source (ejecuta en el shell actual)

source mi_primer_script.sh

# Método 4: Usando el punto (equivalente a source)

. mi_primer_script.sh
¿Cuál método usar?

Método 1: Ideal para scripts de producción
Método 2: Útil para testing y debugging
Métodos 3 y 4: Para scripts que modifican el entorno actual
Buenas Prácticas en la Estructura
Un script bien estructurado es más fácil de mantener y debuggear:

bash
#!/bin/bash

# =============================================================================

# SCRIPT: gestion_sistema.sh

# AUTOR: [Tu nombre]

# FECHA: [Fecha]

# VERSIÓN: 1.0

# DESCRIPCIÓN: Script para gestión básica del sistema

# USO: ./gestion_sistema.sh

# =============================================================================

# Configuración de debugging (opcional)

set -e # Termina el script si algún comando falla
set -u # Termina el script si se usa una variable no definida

# CONSTANTES (siempre en mayúsculas)

readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly LOG_FILE="/tmp/${SCRIPT_NAME%.sh}.log"

# FUNCIONES (las definiremos en próximas lecciones)

# mostrar_menu() { ... }

# procesar_opcion() { ... }

# PROGRAMA PRINCIPAL

echo "Iniciando ${SCRIPT_NAME}..."
echo "Directorio del script: ${SCRIPT_DIR}"
echo "Log guardado en: ${LOG_FILE}"

# Aquí va la lógica principal del script

echo "¡Script ejecutado exitosamente!"
Ejercicio Práctico: Tu Primer Script Personalizado
Crea un script llamado info_sistema.sh que muestre información detallada del sistema:

bash
#!/bin/bash

# =============================================================================

# SCRIPT: info_sistema.sh

# DESCRIPCIÓN: Muestra información detallada del sistema

# =============================================================================

echo "======================================"
echo " INFORMACIÓN DEL SISTEMA"
echo "======================================"
echo

# Información del sistema operativo

echo "🖥️ SISTEMA OPERATIVO:"
echo " Distribución: $(lsb_release -d 2>/dev/null | cut -f2 || echo 'No disponible')"
echo " Kernel: $(uname -r)"
echo " Arquitectura: $(uname -m)"
echo

# Información del usuario

echo "👤 USUARIO ACTUAL:"
echo " Usuario: $(whoami)"
echo " Directorio home: $HOME"
echo " Shell actual: $SHELL"
echo

# Información de fecha y hora

echo "📅 FECHA Y HORA:"
echo " Fecha actual: $(date '+%d/%m/%Y')"
echo " Hora actual: $(date '+%H:%M:%S')"
echo " Zona horaria: $(date '+%Z')"
echo

# Información de red

echo "🌐 RED:"
echo " Hostname: $(hostname)"
echo " IP local: $(hostname -I 2>/dev/null | awk '{print $1}' || echo 'No disponible')"
echo

echo "======================================"
echo " ¡INFORMACIÓN RECOPILADA!"
echo "======================================"
Lección 3.2: Variables y Tipos de Datos
Entendiendo las Variables en Bash
Las variables en Bash son como "cajas" donde almacenamos información que podemos usar posteriormente en nuestro script. A diferencia de otros lenguajes, Bash no tiene tipos de datos estrictos, pero sí tiene diferentes formas de manejar la información.

Declaración y Asignación de Variables
bash
#!/bin/bash

# DECLARACIÓN BÁSICA DE VARIABLES

nombre="Juan Pérez" # Variable de texto (string)
edad=25 # Variable numérica (tratada como string)
activo=true # Variable booleana (tratada como string)

# REGLAS IMPORTANTES:

# 1. NO debe haber espacios alrededor del signo =

# 2. Los nombres de variables son case-sensitive

# 3. Pueden contener letras, números y guiones bajos

# 4. No pueden empezar con un número

# EJEMPLOS DE DECLARACIÓN:

mi_variable="valor" # ✅ Correcto
\_variable_privada="secreto" # ✅ Correcto
CONSTANTE="VALOR_FIJO" # ✅ Correcto (convención para constantes)

# mi variable="valor" # ❌ Error: espacios alrededor del =

# 2variable="valor" # ❌ Error: empieza con número

# mi-variable="valor" # ❌ Error: guión medio no permitido

Acceso a Variables
bash
#!/bin/bash

# Declaración de variables

nombre="María"
apellido="García"
edad=30

# FORMAS DE ACCEDER A VARIABLES:

# Forma básica

echo $nombre # Salida: María

# Forma recomendada (con llaves)

echo ${nombre} # Salida: María

# Concatenación de variables

nombre_completo="${nombre} ${apellido}"
echo $nombre_completo # Salida: María García

# Uso en contextos complejos

archivo="documento"
extension="txt"
archivo_completo="${archivo}.${extension}"
echo $archivo_completo # Salida: documento.txt

# Evitar ambigüedades

echo "$nombre_completo tiene $edad años"

# Salida: María García tiene 30 años

Variables Locales vs Globales
bash
#!/bin/bash

# VARIABLES GLOBALES (disponibles en todo el script)

variable_global="Soy global"

function mi_funcion() { # VARIABLES LOCALES (solo disponibles en la función)
local variable_local="Soy local"

    echo "Dentro de la función:"
    echo "  Global: $variable_global"
    echo "  Local: $variable_local"

    # Modificar variable global desde la función
    variable_global="Modificada desde función"

}

echo "Antes de la función:"
echo " Global: $variable_global"

mi_funcion

echo "Después de la función:"
echo " Global: $variable_global"

# echo " Local: $variable_local" # ❌ Error: variable no definida

Variables Especiales Importantes
Bash proporciona variables especiales que contienen información útil:

bash
#!/bin/bash

echo "=== VARIABLES ESPECIALES DE BASH ==="
echo

# Variables sobre el script

echo "📝 INFORMACIÓN DEL SCRIPT:"
echo " Nombre del script: $0"
echo "   Primer parámetro: $1"
echo "   Segundo parámetro: $2"
echo "   Todos los parámetros: $@"
echo "   Cantidad de parámetros: $#"
echo "   Código de salida del último comando: $?"
echo "   PID del proceso actual: $$"
echo

# Variables de entorno importantes

echo "🌍 VARIABLES DE ENTORNO:"
echo " Usuario actual: $USER"
echo " Directorio home: $HOME"
echo " Directorio actual: $PWD"
echo " Path de comandos: $PATH"
echo " Shell actual: $SHELL"
echo

# Ejemplo de uso de parámetros

if [ $# -eq 0 ]; then
echo "⚠️ No se proporcionaron parámetros"
echo " Uso: $0 <nombre> <edad>"
else
echo "✅ Parámetros recibidos:"
echo " Nombre: $1"
echo " Edad: $2"
fi
Tipos de Datos en Bash
Aunque Bash no tiene tipos de datos estrictos, podemos trabajar con diferentes tipos de información:

bash
#!/bin/bash

# =============================================================================

# MANEJO DE DIFERENTES TIPOS DE DATOS

# =============================================================================

# 1. CADENAS DE TEXTO (STRINGS)

echo "=== TRABAJANDO CON STRINGS ==="
texto="Hola Mundo"
texto_con_espacios=" Texto con espacios "
texto_multilinea="Primera línea
Segunda línea
Tercera línea"

echo "Texto simple: $texto"
echo "Longitud del texto: ${#texto}"
echo "Texto en mayúsculas: ${texto^^}"
echo "Texto en minúsculas: ${texto,,}"
echo

# 2. NÚMEROS

echo "=== TRABAJANDO CON NÚMEROS ==="
numero1=10
numero2=5

# Operaciones aritméticas

suma=$((numero1 + numero2))
resta=$((numero1 - numero2))
multiplicacion=$((numero1 * numero2))
division=$((numero1 / numero2))

echo "Número 1: $numero1"
echo "Número 2: $numero2"
echo "Suma: $suma"
echo "Resta: $resta"
echo "Multiplicación: $multiplicacion"
echo "División: $division"
echo

# 3. ARRAYS (ARREGLOS)

echo "=== TRABAJANDO CON ARRAYS ==="

# Array indexado

frutas=("manzana" "banana" "naranja" "uva")
echo "Todas las frutas: ${frutas[@]}"
echo "Primera fruta: ${frutas[0]}"
echo "Cantidad de frutas: ${#frutas[@]}"

# Agregar elementos

frutas[4]="kiwi"
frutas+=("mango")
echo "Frutas después de agregar: ${frutas[@]}"
echo

# 4. VARIABLES BOOLEANAS

echo "=== TRABAJANDO CON BOOLEANOS ==="
activo=true
debug=false

if [ "$activo" = true ]; then
echo "El sistema está activo"
fi

if [ "$debug" = false ]; then
echo "El modo debug está desactivado"
fi
Variables de Entorno
Las variables de entorno son variables especiales que están disponibles para todos los procesos:

bash
#!/bin/bash

# =============================================================================

# TRABAJANDO CON VARIABLES DE ENTORNO

# =============================================================================

echo "=== VARIABLES DE ENTORNO IMPORTANTES ==="
echo

# Mostrar variables de entorno comunes

echo "🏠 HOME: $HOME"
echo "👤 USER: $USER"
echo "🖥️ HOSTNAME: $HOSTNAME"
echo "📁 PWD: $PWD"
echo "🐚 SHELL: $SHELL"
echo "🛤️ PATH: $PATH"
echo

# Crear nuestras propias variables de entorno

echo "=== CREANDO VARIABLES DE ENTORNO ==="

# Variable normal (solo disponible en el script actual)

mi_variable="valor local"

# Variable de entorno (disponible para procesos hijos)

export MI_VARIABLE_ENV="valor de entorno"

# Mostrar todas las variables de entorno

echo "Todas las variables de entorno:"
env | grep "MI_VARIABLE" || echo "No se encontraron variables personalizadas"

# Crear un archivo de configuración

cat > config_entorno.sh << 'EOF'
#!/bin/bash

# Archivo de configuración de variables de entorno

export APP_NAME="Mi Aplicación Bash"
export APP_VERSION="1.0.0"
export APP_DEBUG="false"
export APP_LOG_LEVEL="INFO"

echo "Variables de entorno configuradas:"
echo " APP_NAME: $APP_NAME"
echo " APP_VERSION: $APP_VERSION"
echo " APP_DEBUG: $APP_DEBUG"  
echo " APP_LOG_LEVEL: $APP_LOG_LEVEL"
EOF

chmod +x config_entorno.sh
echo "Archivo de configuración creado: config_entorno.sh"
¿Te gustaría que continúe con la Lección 3.3: Entrada y Salida o prefieres que profundicemos más en algún aspecto específico de las variables antes de avanzar?

Preparando lecciones 3.3 y Proyecto Práctico 3
5s

Reintentar
vamos con la lección 3.3

Editar

Mapped out detailed Bash lesson on input and output techniques.
6s

¡Excelente! Ahora vamos a adentrarnos en la Lección 3.3: Entrada y Salida, que es donde nuestros scripts realmente cobran vida al poder interactuar con el usuario y el sistema de manera dinámica.

Lección 3.3: Entrada y Salida
Entendiendo la Comunicación en Bash
Imagina que tu script es como una persona que necesita comunicarse: debe poder escuchar lo que le dicen (entrada) y responder de manera clara y útil (salida). En Bash, esta comunicación se realiza a través de flujos de datos que conectan nuestro programa con el mundo exterior.

Lectura de Entrada con read
El comando read es nuestra herramienta principal para capturar información del usuario. Es como tener una conversación directa con quien ejecuta nuestro script.

Uso Básico de read
Comencemos con los conceptos fundamentales:

bash
#!/bin/bash

# =============================================================================

# INTRODUCCIÓN A LA LECTURA DE ENTRADA

# =============================================================================

echo "=== BIENVENIDO AL SISTEMA DE REGISTRO ==="
echo

# Lectura básica de entrada

echo "Por favor, ingresa tu nombre:"
read nombre

echo "¡Hola, $nombre! Es un placer conocerte."
echo

# Lectura con prompt personalizado

read -p "¿Cuál es tu edad? " edad

echo "Entiendo, tienes $edad años."
echo

# Lectura silenciosa (útil para contraseñas)

echo "Configuración de seguridad:"
read -s -p "Ingresa una contraseña: " password
echo # Salto de línea después del input silencioso
echo "Contraseña configurada correctamente (no se mostrará por seguridad)."
Técnicas Avanzadas de Lectura
El comando read tiene muchas opciones que nos permiten crear experiencias de usuario más sofisticadas:

bash
#!/bin/bash

# =============================================================================

# TÉCNICAS AVANZADAS DE LECTURA

# =============================================================================

echo "=== CONFIGURADOR AVANZADO DEL SISTEMA ==="
echo

# Lectura con timeout (útil para scripts automatizados)

echo "Configuración de red (presiona Enter para usar configuración por defecto):"
if read -t 10 -p "IP del servidor [192.168.1.100]: " ip_servidor; then # Si el usuario ingresó algo, usamos ese valor
ip_servidor=${ip_servidor:-"192.168.1.100"}
echo "IP configurada: $ip_servidor"
else # Si se agotó el timeout, usamos valor por defecto
ip_servidor="192.168.1.100"
echo
echo "⏰ Tiempo agotado. Usando IP por defecto: $ip_servidor"
fi

echo

# Lectura de múltiples valores en una línea

echo "Ingresa tu nombre completo (nombre apellido):"
read nombre apellido
echo "Nombre: $nombre"
echo "Apellido: $apellido"

echo

# Lectura en un array (útil para listas)

echo "Ingresa tus hobbies favoritos (separados por espacios):"
read -a hobbies
echo "Tus hobbies son:"
for i in "${!hobbies[@]}"; do
    echo "  $((i+1)). ${hobbies[$i]}"
done

echo

# Lectura línea por línea (útil para texto multilinea)

echo "Ingresa una descripción de tu proyecto (termina con línea vacía):"
descripcion=""
while IFS= read -r linea; do
if [[-z "$linea"]]; then
break
fi
descripcion="$descripcion$linea"$'\n'
done

echo "Tu descripción:"
echo "$descripcion"
Validación de Entrada
Una de las mejores prácticas más importantes es validar siempre la entrada del usuario. Esto previene errores y mejora la experiencia de usuario:

bash
#!/bin/bash

# =============================================================================

# VALIDACIÓN DE ENTRADA DE USUARIO

# =============================================================================

# Función para validar email

validar*email() {
local email=$1
if [[ $email =~ ^[a-zA-Z0-9.*%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
return 0 # Email válido
else
return 1 # Email inválido
fi
}

# Función para validar número

validar_numero() {
local numero=$1
    if [[ $numero =~ ^[0-9]+$ ]]; then
return 0 # Número válido
else
return 1 # No es un número
fi
}

echo "=== FORMULARIO DE REGISTRO CON VALIDACIÓN ==="
echo

# Validación de nombre (no puede estar vacío)

while true; do
read -p "Ingresa tu nombre: " nombre
if [[-n "$nombre"]]; then
break
else
echo "❌ El nombre no puede estar vacío. Inténtalo de nuevo."
fi
done

# Validación de email

while true; do
read -p "Ingresa tu email: " email
if validar_email "$email"; then
break
else
echo "❌ Email inválido. Formato correcto: usuario@dominio.com"
fi
done

# Validación de edad

while true; do
read -p "Ingresa tu edad: " edad
if validar_numero "$edad" && [ "$edad" -ge 0 ] && [ "$edad" -le 120 ]; then
break
else
echo "❌ Edad inválida. Debe ser un número entre 0 y 120."
fi
done

echo
echo "✅ Registro completado exitosamente:"
echo " Nombre: $nombre"
echo " Email: $email"
echo " Edad: $edad años"
Salida Formateada con echo y printf
La salida es tan importante como la entrada. Una buena presentación de información hace que nuestros scripts sean más profesionales y fáciles de usar.

Dominando echo
El comando echo es nuestra herramienta básica para mostrar información, pero tiene muchas capacidades ocultas:

bash
#!/bin/bash

# =============================================================================

# TÉCNICAS AVANZADAS DE SALIDA CON ECHO

# =============================================================================

echo "=== DEMOSTRANDO CAPACIDADES DE ECHO ==="
echo

# Echo básico

echo "Mensaje simple"

# Echo con variables

nombre="Ana"
echo "Hola, $nombre"

# Echo con caracteres especiales

echo "Línea 1"
echo "Línea 2"
echo # Línea vacía

# Echo con colores (usando códigos ANSI)

echo -e "\033[32mTexto en verde\033[0m" # Verde
echo -e "\033[31mTexto en rojo\033[0m" # Rojo
echo -e "\033[34mTexto en azul\033[0m" # Azul
echo -e "\033[33mTexto en amarillo\033[0m" # Amarillo

# Echo con formato

echo -e "Texto en \033[1mnegrita\033[0m"
echo -e "Texto \033[4msubrayado\033[0m"

# Echo sin salto de línea

echo -n "Cargando"
for i in {1..5}; do
echo -n "."
sleep 1
done
echo " ¡Completado!"

# Echo con tabulaciones

echo -e "Columna 1\tColumna 2\tColumna 3"
echo -e "Dato 1\t\tDato 2\t\tDato 3"
Creando Funciones para Salida Formateada
Para hacer nuestros scripts más profesionales, podemos crear funciones que manejen la salida de manera consistente:

bash
#!/bin/bash

# =============================================================================

# FUNCIONES PARA SALIDA FORMATEADA

# =============================================================================

# Códigos de color

readonly COLOR_ROJO='\033[31m'
readonly COLOR_VERDE='\033[32m'
readonly COLOR_AMARILLO='\033[33m'
readonly COLOR_AZUL='\033[34m'
readonly COLOR_MAGENTA='\033[35m'
readonly COLOR_CYAN='\033[36m'
readonly COLOR_RESET='\033[0m'

# Función para mostrar mensajes de éxito

mostrar_exito() {
echo -e "${COLOR_VERDE}✅ $1${COLOR_RESET}"
}

# Función para mostrar mensajes de error

mostrar_error() {
echo -e "${COLOR_ROJO}❌ $1${COLOR_RESET}"
}

# Función para mostrar advertencias

mostrar_advertencia() {
echo -e "${COLOR_AMARILLO}⚠️  $1${COLOR_RESET}"
}

# Función para mostrar información

mostrar_info() {
echo -e "${COLOR_AZUL}ℹ️  $1${COLOR_RESET}"
}

# Función para mostrar encabezados

mostrar_encabezado() {
local titulo=$1
    local longitud=${#titulo}
local separador=$(printf "=%.0s" $(seq 1 $((longitud + 4))))

    echo -e "${COLOR_CYAN}$separador${COLOR_RESET}"
    echo -e "${COLOR_CYAN}  $titulo${COLOR_RESET}"
    echo -e "${COLOR_CYAN}$separador${COLOR_RESET}"

}

# Función para mostrar progress bar

mostrar_progreso() {
local actual=$1
    local total=$2
    local porcentaje=$((actual \* 100 / total))
local completado=$((porcentaje / 2))
    local restante=$((50 - completado))

    printf "\rProgreso: ["
    printf "%${completado}s" | tr ' ' '='
    printf "%${restante}s" | tr ' ' '-'
    printf "] %d%%" $porcentaje

}

# Demostración de las funciones

mostrar_encabezado "SISTEMA DE MENSAJES FORMATEADOS"
echo

mostrar_info "Iniciando proceso de demostración..."
mostrar_exito "Conexión establecida correctamente"
mostrar_advertencia "Memoria disponible: 75% (considera liberar espacio)"
mostrar_error "No se pudo conectar al servidor de respaldos"

echo
echo "Simulando proceso de descarga:"
for i in {1..100}; do
mostrar_progreso $i 100
sleep 0.05
done
echo
echo

mostrar_exito "Demostración completada exitosamente"
Poderío de printf
El comando printf nos ofrece un control mucho más preciso sobre el formato de salida, similar a otros lenguajes de programación:

bash
#!/bin/bash

# =============================================================================

# FORMATEO AVANZADO CON PRINTF

# =============================================================================

echo "=== DEMOSTRANDO PRINTF ==="
echo

# Formateo básico

printf "Hola %s, tienes %d años.\n" "María" 25

# Formateo de números

numero=42
printf "Número entero: %d\n" $numero
printf "Número hexadecimal: %x\n" $numero
printf "Número octal: %o\n" $numero
printf "Número flotante: %.2f\n" 3.14159

# Formateo con ancho fijo

printf "%-15s | %10s | %5s\n" "Nombre" "Edad" "Score"
printf "%-15s | %10s | %5s\n" "---------------" "----------" "-----"
printf "%-15s | %10d | %5.1f\n" "Ana García" 28 95.5
printf "%-15s | %10d | %5.1f\n" "Luis López" 34 87.2
printf "%-15s | %10d | %5.1f\n" "María Rodríguez" 22 92.8

echo

# Formateo con ceros a la izquierda

printf "ID: %04d\n" 42
printf "Código: %06d\n" 123

# Formateo de fecha y hora

fecha_actual=$(date '+%Y-%m-%d %H:%M:%S')
printf "Fecha actual: %s\n" "$fecha_actual"

# Crear una tabla formateada

printf "\n=== REPORTE DE VENTAS ===\n"
printf "%-12s | %-10s | %8s | %10s\n" "Producto" "Vendedor" "Cantidad" "Total"
printf "%-12s | %-10s | %8s | %10s\n" "------------" "----------" "--------" "----------"
printf "%-12s | %-10s | %8d | %10.2f\n" "Laptop" "Juan" 5 2500.00
printf "%-12s | %-10s | %8d | %10.2f\n" "Mouse" "Ana" 15 225.75
printf "%-12s | %-10s | %8d | %10.2f\n" "Teclado" "Luis" 8 400.00
printf "%-12s | %-10s | %8s | %10s\n" "------------" "----------" "--------" "----------"
printf "%-12s | %-10s | %8d | %10.2f\n" "TOTAL" "" 28 3125.75
Códigos de Salida y Manejo de Errores
Los códigos de salida son fundamentales para que nuestros scripts puedan comunicarse efectivamente con otros programas y scripts:

bash
#!/bin/bash

# =============================================================================

# MANEJO DE CÓDIGOS DE SALIDA

# =============================================================================

# Definir códigos de salida estándar

readonly EXITO=0
readonly ERROR_PARAMETROS=1
readonly ERROR_ARCHIVO=2
readonly ERROR_PERMISOS=3
readonly ERROR_RED=4

# Función para mostrar ayuda

mostrar_ayuda() {
echo "Uso: $0 <archivo> <operacion>"
echo "Operaciones disponibles:"
echo " - leer: Lee el contenido del archivo"
echo " - crear: Crea un nuevo archivo"
echo " - eliminar: Elimina el archivo"
echo "Ejemplo: $0 documento.txt leer"
}

# Función para validar parámetros

validar_parametros() {
if [ $# -ne 2 ]; then
echo "❌ Error: Se requieren exactamente 2 parámetros"
mostrar_ayuda
exit $ERROR_PARAMETROS
fi
}

# Función para procesar archivo

procesar_archivo() {
local archivo=$1
local operacion=$2

    case $operacion in
        "leer")
            if [ ! -f "$archivo" ]; then
                echo "❌ Error: El archivo '$archivo' no existe"
                exit $ERROR_ARCHIVO
            fi

            if [ ! -r "$archivo" ]; then
                echo "❌ Error: No tienes permisos para leer '$archivo'"
                exit $ERROR_PERMISOS
            fi

            echo "📖 Leyendo archivo: $archivo"
            cat "$archivo"
            echo "✅ Archivo leído exitosamente"
            ;;

        "crear")
            if [ -f "$archivo" ]; then
                echo "⚠️  El archivo '$archivo' ya existe"
                read -p "¿Deseas sobrescribirlo? (s/n): " respuesta
                if [[ ! "$respuesta" =~ ^[Ss]$ ]]; then
                    echo "Operación cancelada"
                    exit $EXITO
                fi
            fi

            if ! touch "$archivo" 2>/dev/null; then
                echo "❌ Error: No se pudo crear el archivo '$archivo'"
                exit $ERROR_PERMISOS
            fi

            echo "✅ Archivo '$archivo' creado exitosamente"
            ;;

        "eliminar")
            if [ ! -f "$archivo" ]; then
                echo "❌ Error: El archivo '$archivo' no existe"
                exit $ERROR_ARCHIVO
            fi

            read -p "¿Estás seguro de eliminar '$archivo'? (s/n): " respuesta
            if [[ "$respuesta" =~ ^[Ss]$ ]]; then
                if rm "$archivo" 2>/dev/null; then
                    echo "✅ Archivo '$archivo' eliminado exitosamente"
                else
                    echo "❌ Error: No se pudo eliminar el archivo '$archivo'"
                    exit $ERROR_PERMISOS
                fi
            else
                echo "Operación cancelada"
                exit $EXITO
            fi
            ;;

        *)
            echo "❌ Error: Operación '$operacion' no válida"
            mostrar_ayuda
            exit $ERROR_PARAMETROS
            ;;
    esac

}

# Programa principal

echo "=== GESTOR DE ARCHIVOS ==="
echo

# Validar parámetros

validar_parametros "$@"

# Procesar archivo

procesar_archivo "$1" "$2"

# Si llegamos aquí, todo salió bien

exit $EXITO
Logging Básico: Guardando Información Importante
El logging es una práctica esencial para mantener un registro de lo que hace nuestro script:

bash
#!/bin/bash

# =============================================================================

# SISTEMA DE LOGGING BÁSICO

# =============================================================================

# Configuración de logging

readonly LOG_DIR="/tmp/mi_aplicacion"
readonly LOG_FILE="$LOG_DIR/aplicacion.log"
readonly LOG_LEVEL_INFO="INFO"
readonly LOG_LEVEL_WARN="WARN"
readonly LOG_LEVEL_ERROR="ERROR"
readonly LOG_LEVEL_DEBUG="DEBUG"

# Crear directorio de logs si no existe

mkdir -p "$LOG_DIR"

# Función para escribir en log

escribir_log() {
local nivel=$1
    local mensaje=$2
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # Escribir al archivo de log
    echo "[$timestamp] [$nivel] $mensaje" >> "$LOG_FILE"

    # También mostrar en pantalla según el nivel
    case $nivel in
        "$LOG_LEVEL_INFO")
            echo -e "\033[32m[INFO]\033[0m $mensaje"
            ;;
        "$LOG_LEVEL_WARN")
            echo -e "\033[33m[WARN]\033[0m $mensaje"
            ;;
        "$LOG_LEVEL_ERROR")
            echo -e "\033[31m[ERROR]\033[0m $mensaje"
            ;;
        "$LOG_LEVEL_DEBUG")
            echo -e "\033[36m[DEBUG]\033[0m $mensaje"
            ;;
    esac

}

# Funciones de conveniencia

log_info() {
escribir_log "$LOG_LEVEL_INFO" "$1"
}

log_warn() {
escribir_log "$LOG_LEVEL_WARN" "$1"
}

log_error() {
escribir_log "$LOG_LEVEL_ERROR" "$1"
}

log_debug() {
escribir_log "$LOG_LEVEL_DEBUG" "$1"
}

# Demostración del sistema de logging

log_info "Iniciando aplicación..."
log_debug "Variables de entorno cargadas"

# Simular algunas operaciones

log_info "Conectando a base de datos..."
sleep 1
log_info "Conexión establecida exitosamente"

log_warn "Espacio en disco por debajo del 20%"

log_info "Procesando archivos..."
for i in {1..5}; do
log_debug "Procesando archivo $i de 5"
sleep 0.5
done

log_error "Error al procesar archivo 'datos_corruptos.txt'"
log_info "Continuando con el siguiente archivo..."

log_info "Proceso completado"
log_info "Logs guardados en: $LOG_FILE"

# Mostrar resumen del log

echo
echo "=== RESUMEN DEL LOG ==="
echo "Archivo de log: $LOG_FILE"
echo "Líneas totales: $(wc -l < "$LOG_FILE")"
echo "Errores: $(grep -c "ERROR" "$LOG_FILE")"
echo "Advertencias: $(grep -c "WARN" "$LOG_FILE")"
echo "Información: $(grep -c "INFO" "$LOG_FILE")"
Ejercicio Práctico: Sistema de Gestión de Tareas
Ahora vamos a crear un proyecto práctico que integre todos los conceptos aprendidos:

bash
#!/bin/bash

# =============================================================================

# PROYECTO PRÁCTICO: GESTOR DE TAREAS

# Integra lectura de entrada, salida formateada y logging

# =============================================================================

# Configuración

readonly ARCHIVO_TAREAS="tareas.txt"
readonly LOG_FILE="gestor_tareas.log"

# Colores para la salida

readonly COLOR_VERDE='\033[32m'
readonly COLOR_ROJO='\033[31m'
readonly COLOR_AZUL='\033[34m'
readonly COLOR_AMARILLO='\033[33m'
readonly COLOR_RESET='\033[0m'

# Función de logging

log_evento() {
local mensaje=$1
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
echo "[$timestamp] $mensaje" >> "$LOG_FILE"
}

# Función para mostrar el menú

mostrar_menu() {
echo -e "${COLOR_AZUL}=================================${COLOR_RESET}"
echo -e "${COLOR_AZUL}       GESTOR DE TAREAS${COLOR_RESET}"
echo -e "${COLOR_AZUL}=================================${COLOR_RESET}"
echo "1. Agregar tarea"
echo "2. Listar tareas"
echo "3. Marcar tarea como completada"
echo "4. Eliminar tarea"
echo "5. Buscar tarea"
echo "6. Mostrar estadísticas"
echo "7. Salir"
echo -e "${COLOR_AZUL}=================================${COLOR_RESET}"
}

# Función para agregar tarea

agregar_tarea() {
echo -e "${COLOR_AZUL}=== AGREGAR NUEVA TAREA ===${COLOR_RESET}"

    read -p "Describe la tarea: " descripcion

    if [[ -z "$descripcion" ]]; then
        echo -e "${COLOR_ROJO}❌ La descripción no puede estar vacía${COLOR_RESET}"
        return 1
    fi

    read -p "Prioridad (alta/media/baja) [media]: " prioridad
    prioridad=${prioridad:-"media"}

    local fecha=$(date '+%Y-%m-%d %H:%M:%S')
    local id=$(date +%s)

    echo "$id|$fecha|$descripcion|$prioridad|pendiente" >> "$ARCHIVO_TAREAS"

    echo -e "${COLOR_VERDE}✅ Tarea agregada exitosamente${COLOR_RESET}"
    log_evento "Tarea agregada: $descripcion (ID: $id)"

}

# Función para listar tareas

listar_tareas() {
echo -e "${COLOR_AZUL}=== LISTA DE TAREAS ===${COLOR_RESET}"

    if [[ ! -f "$ARCHIVO_TAREAS" ]] || [[ ! -s "$ARCHIVO_TAREAS" ]]; then
        echo -e "${COLOR_AMARILLO}No hay tareas registradas${COLOR_RESET}"
        return 0
    fi

    printf "%-12s | %-19s | %-30s | %-10s | %-10s\n" "ID" "Fecha" "Descripción" "Prioridad" "Estado"
    printf "%-12s | %-19s | %-30s | %-10s | %-10s\n" "------------" "-------------------" "------------------------------" "----------" "----------"

    while IFS='|' read -r id fecha descripcion prioridad estado; do
        # Limitar la descripción a 30 caracteres
        descripcion_corta=$(echo "$descripcion" | cut -c1-30)

        # Colorear según el estado
        if [[ "$estado" == "completada" ]]; then
            printf "${COLOR_VERDE}%-12s | %-19s | %-30s | %-10s | %-10s${COLOR_RESET}\n" "$id" "$fecha" "$descripcion_corta" "$prioridad" "$estado"
        else
            printf "%-12s | %-19s | %-30s | %-10s | %-10s\n" "$id" "$fecha" "$descripcion_corta" "$prioridad" "$estado"
        fi
    done < "$ARCHIVO_TAREAS"

}

# Función para marcar como completada

completar_tarea() {
echo -e "${COLOR_AZUL}=== COMPLETAR TAREA ===${COLOR_RESET}"

    listar_tareas
    echo

    read -p "Ingresa el ID de la tarea a completar: " id_tarea

    if [[ -z "$id_tarea" ]]; then
        echo -e "${COLOR_ROJO}❌ Debes ingresar un ID válido${COLOR_RESET}"
        return 1
    fi

    # Crear archivo temporal
    local temp_file=$(mktemp)
    local encontrada=false

    while IFS='|' read -r id fecha descripcion prioridad estado; do
        if [[ "$id" == "$id_tarea" ]]; then
            echo "$id|$fecha|$descripcion|$prioridad|completada" >> "$temp_file"
            encontrada=true
            log_evento "Tarea completada: $descripcion (ID: $id)"
        else
            echo "$id|$fecha|$descripcion|$prioridad|$estado" >> "$temp_file"
        fi
    done < "$ARCHIVO_TAREAS"

    if [[ "$encontrada" == true ]]; then
        mv "$temp_file" "$ARCHIVO_TAREAS"
        echo -e "${COLOR_VERDE}✅ Tarea marcada como completada${COLOR_RESET}"
    else
        rm "$temp_file"
        echo -e "${COLOR_ROJO}❌ No se encontró una tarea con ID: $id_tarea${COLOR_RESET}"
    fi

}

# Función para mostrar estadísticas

mostrar_estadisticas() {
echo -e "${COLOR_AZUL}=== ESTADÍSTICAS ===${COLOR_RESET}"

    if [[ ! -f "$ARCHIVO_TAREAS" ]] || [[ ! -s "$ARCHIVO_TAREAS" ]]; then
        echo -e "${COLOR_AMARILLO}No hay tareas para mostrar estadísticas${COLOR_RESET}"
        return 0
    fi

    local total=$(wc -l < "$ARCHIVO_TAREAS")
    local completadas=$(grep -c "completada" "$ARCHIVO_TAREAS" 2>/dev/null || echo 0)
    local pendientes=$(grep -c "pendiente" "$ARCHIVO_TAREAS" 2>/dev/null || echo 0)
    local alta_prioridad=$(grep -c "alta" "$ARCHIVO_TAREAS" 2>/dev/null || echo 0)

    echo "📊 Resumen de tareas:"
    echo "   Total: $total"
    echo "   Completadas: $completadas"
    echo "   Pendientes: $pendientes"
    echo "   Alta prioridad: $alta_prioridad"

    if [[ $total -gt 0 ]]; then
        local porcentaje_completadas=$((completadas * 100 / total))
        echo "   Progreso: $porcentaje_completadas%"
    fi

}

# Función principal

main() {
log_evento "Iniciando gestor de tareas"

    while true; do
        echo
        mostrar_menu
        read -p "Selecciona una opción (1-7): " opcion

        case $opcion in
            1)
                agregar_tarea
                ;;
            2)
                listar_tareas
                ;;
            3)
                completar_tarea
                ;;
            4)
                echo -e "${COLOR_AMARILLO}Función en desarrollo...${COLOR_RESET}"
                ;;
            5)
                echo -e "${COLOR_AMARILLO}Función en desarrollo...${COLOR_RESET}"
                ;;
            6)
                mostrar_estadisticas
                ;;
            7)
                echo -e "${COLOR_VERDE}¡Hasta luego!${COLOR_RESET}"
                log_evento "Gestor de tareas cerrado"
                exit 0
                ;;
            *)
                echo -e "${COLOR_ROJO}❌ Opción no válida. Intenta de nuevo.${COLOR_RESET}"
                ;;
        esac

        echo
        read -p "Presiona Enter para continuar..."
    done

}

# Ejecutar el programa principal

main "$@"
Resumen de Mejores Prácticas
Para cerrar esta lección, recordemos las mejores prácticas que hemos aprendido:

Para entrada de datos:

Siempre valida la entrada del usuario
Usa prompts claros y descriptivos
Implementa timeouts cuando sea apropiado
Maneja casos especiales como entradas vacías
Para salida de datos:

Usa colores y formato para mejorar la experiencia
Crea funciones reutilizables para mensajes
Mantén consistencia en el formato
Usa printf para formateo preciso
Para códigos de salida:

Define constantes para códigos de error
Usa códigos estándar cuando sea posible
Documenta el significado de cada código
Siempre termina con exit explícito
Para logging:

Registra eventos importantes
Incluye timestamps en todos los logs
Usa niveles de log apropiados
Mantén los logs organizados y legibles
¿Te gustaría que continuemos con el Proyecto Práctico 3 donde integraremos todos estos conceptos en un script interactivo más complejo, o prefieres profundizar en algún aspecto específico de esta lección?

Explicando lección 3.3 sobre entrada y salida en Bash
6s

Reintentar
vamos con el proyecto práctico 3

Editar

Planificó proyecto interactivo de gestión de archivos en script
6s

¡Excelente elección! El Proyecto Práctico 3 va a ser el momento donde realmente consolidamos todo lo que hemos aprendido en este módulo. Vamos a crear un Script Interactivo para Gestión de Archivos que será como construir una navaja suiza digital: una herramienta versátil que nos permita manejar archivos de manera eficiente y profesional.

Proyecto Práctico 3: Gestor Interactivo de Archivos
Entendiendo el Objetivo
Imagina que necesitas crear una herramienta que permita a cualquier usuario, desde principiantes hasta administradores de sistema, gestionar archivos de manera intuitiva sin necesidad de recordar docenas de comandos diferentes. Nuestro script será como tener un asistente personal que nos guía paso a paso en cada operación.

Arquitectura del Proyecto
Antes de escribir código, pensemos como arquitectos de software. Nuestro gestor tendrá estas capacidades principales:

Funciones de Exploración: Como un explorador de archivos, podremos navegar por directorios, ver contenidos detallados y obtener información sobre archivos y carpetas.

Funciones de Manipulación: Como herramientas de construcción, podremos crear, copiar, mover, renombrar y eliminar archivos y directorios.

Funciones de Búsqueda: Como un detective digital, podremos localizar archivos por nombre, tipo, tamaño o fecha de modificación.

Funciones de Seguridad: Como un guardián responsable, implementaremos respaldos automáticos y confirmaciones para operaciones destructivas.

Ahora vamos a construir este proyecto paso a paso, como si estuviéramos enseñando a un aprendiz cada técnica de carpintería.

Gestor Interactivo de Archivos - Proyecto Práctico 3
Código

Preparó explicación detallada del proyecto práctico 3.
6s

¡Perfecto! Acabamos de crear nuestro proyecto más ambicioso hasta ahora. Este Gestor Interactivo de Archivos es como construir una navaja suiza digital que demuestra todo lo que hemos aprendido en el Módulo 3. Permíteme explicarte paso a paso cómo está construido este proyecto y por qué cada decisión técnica fue tomada.

Anatomía del Proyecto: Entendiendo la Arquitectura
La Filosofía del Diseño
Cuando diseñamos este gestor, pensamos como arquitectos de software. No queríamos simplemente crear un script que funcionara, sino una herramienta que fuera mantenible, extensible y profesional. Es como la diferencia entre construir una casa de madera improvisada versus diseñar una estructura que pueda crecer y adaptarse con el tiempo.

Estructura Modular: Dividir para Conquistar
El script está organizado en secciones lógicas, cada una con un propósito específico. Esta organización no es accidental, sino que refleja principios de ingeniería de software que te servirán en proyectos mucho más complejos.

Sección de Configuración y Constantes: Aquí definimos todos los valores que no cambian durante la ejecución del programa. Es como tener un panel de control centralizado donde puedes ajustar el comportamiento del programa sin buscar valores mágicos dispersos por todo el código. Las constantes de colores, por ejemplo, nos permiten cambiar toda la paleta visual del programa desde un solo lugar.

Funciones de Utilidad y Logging: Esta es nuestra caja de herramientas básicas. Imagina que estás construyendo una casa y necesitas tener siempre a mano martillo, destornillador y nivel. Estas funciones son nuestras herramientas fundamentales que usamos a lo largo de todo el programa.

Funciones de Validación: En el mundo real, los usuarios cometen errores, los archivos se corrompen y los permisos cambian. Estas funciones son como tener un equipo de control de calidad que verifica que todo esté en orden antes de proceder.

Funciones Especializadas: Cada grupo de funciones maneja un aspecto específico del programa, como navegación, manipulación de archivos, búsqueda y backup. Es como tener diferentes departamentos en una empresa, cada uno especializado en su área.

Integración de Conceptos del Módulo 3
Este proyecto es un laboratorio vivo donde aplicamos todo lo aprendido:

Variables y Tipos de Datos: Observa cómo usamos variables globales para mantener el estado del programa (como directorio_actual y modo_debug), constantes para valores inmutables, y variables locales dentro de las funciones para evitar contaminación del espacio de nombres.

Entrada y Salida Sofisticada: No nos conformamos con un simple echo. Implementamos un sistema de mensajes con colores, iconos y formato consistente. Es como la diferencia entre enviar un telegrama en texto plano versus diseñar una presentación profesional.

Manejo de Códigos de Salida: Cada función retorna códigos apropiados, permitiendo que otras partes del programa tomen decisiones basadas en el éxito o fracaso de las operaciones.

Técnicas Avanzadas Implementadas
Sistema de Logging: La Memoria del Programa
El sistema de logging que implementamos es sofisticado pero elegante. Cada acción importante se registra con timestamp, usuario y nivel de severidad. Es como tener una caja negra que nos permite entender qué pasó cuando algo sale mal.

bash

# Ejemplo de cómo usamos el logging

log_info "Usuario cambió al directorio: $nuevo_directorio"
log_error "Falló la operación de copia: $archivo_origen -> $archivo_destino"
Esta técnica te será invaluable cuando administres servidores en producción. Los logs bien estructurados son la diferencia entre resolver un problema en minutos versus horas de investigación.

Validación Robusta: Prevenir Antes que Curar
Implementamos múltiples capas de validación, desde verificar que los archivos existen hasta confirmar que tenemos permisos adecuados. Es como tener varios puntos de control de seguridad en un aeropuerto: cada uno cumple una función específica para garantizar que todo esté en orden.

Sistema de Backup Automático: Seguridad sin Esfuerzo
Antes de cualquier operación destructiva, el programa automáticamente crea un backup. Esta funcionalidad demuestra pensamiento proactivo en el desarrollo de software. No esperamos a que algo salga mal; anticipamos problemas y creamos soluciones.

Interfaz de Usuario Intuitiva: La Experiencia Importa
El menú del programa no es simplemente una lista de opciones. Está organizado por categorías lógicas, usa colores para facilitar la navegación y proporciona feedback visual constante. Es como diseñar una tienda donde los clientes encuentran fácilmente lo que buscan.

Conceptos de Programación Avanzados
Manejo de Señales
bash
trap 'echo -e "\n${COLOR_AMARILLO}Interrupción detectada..."; exit 130' INT TERM
Esta línea puede parecer simple, pero demuestra un concepto sofisticado: el manejo graceful de interrupciones. Cuando el usuario presiona Ctrl+C, no queremos que el programa termine abruptamente, sino que se despida elegantemente.

Funciones con Múltiples Responsabilidades
Observa cómo la función mostrar_info_archivo no solo muestra información, sino que también valida permisos, formatea datos y registra la actividad. Es un ejemplo de cohesión funcional: todo lo relacionado con mostrar información de archivos está en un solo lugar.

Programación Defensiva
A lo largo del código, asumimos que las cosas pueden salir mal. Verificamos que los comandos existen antes de usarlos, validamos entrada de usuario, y proporcionamos mensajes de error informativos. Es como conducir defensivamente: asumes que otros conductores pueden cometer errores.

Cómo Usar y Probar el Proyecto
Preparación del Entorno
Antes de ejecutar el programa, asegúrate de que tienes los permisos necesarios y un entorno de terminal apropiado. El programa detectará automáticamente qué herramientas tienes disponibles y se adaptará en consecuencia.

Ejecución Paso a Paso
Cuando ejecutes el programa, comenzará con una pantalla de bienvenida que establece el contexto. Luego te presentará un menú organizado por categorías. Te recomiendo comenzar con las funciones de navegación para familiarizarte con la interfaz.

Explorando las Funcionalidades
Comienza Simple: Usa las opciones de listado para ver cómo el programa presenta la información. Observa los iconos, colores y formato.

Prueba Operaciones Seguras: Crea algunos archivos de prueba para experimentar con las funciones de copia y movimiento.

Explora Búsquedas: Las funciones de búsqueda te mostrarán el poder de combinar múltiples comandos Unix en una interfaz amigable.

Experimenta con Backups: Elimina un archivo (después de crear un backup) y luego practique restaurándolo. Esta experiencia te dará confianza en las funciones de seguridad.

Análisis del Comportamiento
Mientras usas el programa, observa cómo cada acción genera entradas en el log. Abre otra terminal y usa tail -f ~/.gestor_archivos.log para ver en tiempo real cómo se registran las actividades.

Lecciones Profesionales del Proyecto
Pensamiento Modular
Este proyecto demuestra cómo dividir un problema complejo en componentes manejables. Cada función tiene una responsabilidad clara, lo que facilita mantenimiento y debugging.

Experiencia de Usuario
No es suficiente que un programa funcione; debe ser agradable de usar. Los colores, iconos y mensajes informativos transforman una herramienta técnica en una experiencia amigable.

Robustez Operacional
En entornos de producción, los programas deben manejar errores gracefully, proporcionar logs detallados y recuperarse de situaciones inesperadas. Este proyecto implementa estos principios desde el diseño.

Escalabilidad de Diseño
Aunque es un script de práctica, está estructurado de manera que podrías añadir nuevas funcionalidades fácilmente. Quieres agregar sincronización con servicios en la nube? El diseño modular lo permite sin reescribir código existente.

Ejercicios de Extensión
Una vez que domines el funcionamiento básico, puedes expandir el proyecto agregando:

Integración con Git: Funciones para inicializar repositorios y realizar commits automáticos de cambios importantes.

Compresión y Archivado: Opciones para crear y extraer archivos tar y zip.

Sincronización de Red: Capacidades para transferir archivos via SCP o rsync.

Análisis de Contenido: Funciones para analizar tipos de archivos y generar reportes detallados.

Este proyecto no es solo una demostración de técnicas de Bash, sino una fundación sobre la cual puedes construir herramientas cada vez más sofisticadas. Cada línea de código refleja principios que aplicarás en tu carrera profesional, desde scripts simples hasta sistemas complejos de automatización.
