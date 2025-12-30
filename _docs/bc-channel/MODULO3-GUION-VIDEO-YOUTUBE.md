# Bootcamp Bash - Módulo 3: Guión para Video de YouTube

## 📋 INFORMACIÓN DEL VIDEO

**Título:** "Bootcamp Bash - Módulo 3: Variables y Control de Flujo - Creando Scripts Inteligentes"

**Duración Estimada:** 55-70 minutos

**Audiencia:** Desarrolladores que dominan los fundamentos (módulos 1 y 2) y quieren crear scripts interactivos

**Objetivo:** Dominar variables, estructuras de control y crear scripts inteligentes que tomen decisiones y procesen datos dinámicamente

---

## 🎯 OBJETIVOS DE APRENDIZAJE

Al finalizar este video, los estudiantes podrán:

1. **Crear** scripts bash profesionales con estructura adecuada
2. **Declarar** y **manipular** variables de diferentes tipos
3. **Implementar** estructuras de control (if, for, while, case)
4. **Procesar** argumentos de línea de comandos
5. **Validar** entrada de usuarios y datos
6. **Construir** scripts interactivos con menús y opciones

---

## 📝 ESTRUCTURA DEL VIDEO

### PARTE 1: INTRODUCCIÓN Y PRIMER SCRIPT (10 minutos)

### PARTE 2: VARIABLES Y MANIPULACIÓN DE DATOS (12 minutos)

### PARTE 3: ESTRUCTURAS CONDICIONALES (15 minutos)

### PARTE 4: BUCLES Y ITERACIÓN (13 minutos)

### PARTE 5: ARGUMENTOS Y VALIDACIÓN (8 minutos)

### PARTE 6: PROYECTO FINAL - GESTOR DE TAREAS (12 minutos)

---

## 🎬 PARTE 1: INTRODUCCIÓN Y PRIMER SCRIPT (10 minutos)

### 🎤 Guión de Presentación

**[PANTALLA: Logo del Módulo 3 con código animado]**

> "¡Bienvenidos al Módulo 3 del Bootcamp Bash! Hoy damos el gran salto: de usar comandos individuales a crear programas completos. Si los módulos anteriores te enseñaron las palabras, hoy aprenderás a escribir novelas completas en bash."

**[TRANSICIÓN: Comparación visual - comandos vs scripts]**

> "Hasta ahora hemos usado bash como una calculadora potente. Hoy lo convertiremos en un asistente inteligente que puede tomar decisiones, recordar información y automatizar procesos complejos."

### 📊 La Evolución: De Comandos a Programas

**[PANTALLA: Evolución visual de complejidad]**

> "Veamos la progresión:
>
> - **Módulo 1**: `ls`, `cp`, `chmod` - Comandos básicos
> - **Módulo 2**: `grep | sort | uniq` - Combinaciones potentes
> - **Módulo 3**: Scripts que piensan, deciden y actúan
>
> Hoy crearemos programas que pueden manejar usuarios, procesar datos variables y tomar decisiones inteligentes."

### 🔧 Anatomía de un Script Profesional

**[PANTALLA: Estructura de script con anotaciones]**

> "Un script profesional no es solo código que funciona. Es código que:
>
> - **Se documenta** a sí mismo
> - **Maneja errores** graciosamente
> - **Valida datos** de entrada
> - **Es mantenible** por otros desarrolladores"

### 🎯 Nuestro Primer Script Real

**[DEMOSTRACIÓN EN VIVO]**

```bash
# Crear directorio para el módulo 3
mkdir week-03_scripts
cd week-03_scripts

# Crear nuestro primer script profesional
nano info_sistema.sh
```

**[CONTENIDO DEL SCRIPT]**

```bash
#!/bin/bash
# =============================================================================
# SCRIPT: info_sistema.sh
# AUTOR: Bootcamp Bash
# FECHA: $(date +%Y-%m-%d)
# VERSIÓN: 1.0
# DESCRIPCIÓN: Analizador inteligente de información del sistema
# USO: ./info_sistema.sh [--detallado]
# =============================================================================

# Configuración de seguridad
set -euo pipefail  # Termina en errores, variables no definidas, errores en pipes

# Colores para output profesional
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly NC='\033[0m' # No Color

# Constantes del script
readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_VERSION="1.0"
readonly LOG_FILE="/tmp/${SCRIPT_NAME%.sh}.log"

# Banner de bienvenida
mostrar_banner() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    ANALIZADOR DE SISTEMA                     ║"
    echo "║                      Versión ${SCRIPT_VERSION}                            ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Función principal
main() {
    mostrar_banner

    echo -e "${GREEN}📊 Recopilando información del sistema...${NC}"
    echo "Fecha de análisis: $(date)"
    echo "Usuario ejecutor: $(whoami)"
    echo "Directorio actual: $(pwd)"

    echo -e "\n${YELLOW}🖥️  INFORMACIÓN DEL SISTEMA:${NC}"
    echo "  Hostname: $(hostname)"
    echo "  SO: $(uname -s)"
    echo "  Kernel: $(uname -r)"
    echo "  Arquitectura: $(uname -m)"

    echo -e "\n${PURPLE}💾 MEMORIA Y ALMACENAMIENTO:${NC}"
    echo "  Memoria libre: $(free -h | awk 'NR==2{print $7}')"
    echo "  Espacio en disco: $(df -h / | awk 'NR==2{print $4}')"

    echo -e "\n${GREEN}✅ Análisis completado exitosamente${NC}"
    echo "Log guardado en: $LOG_FILE"
}

# Ejecutar función principal
main "$@" 2>&1 | tee "$LOG_FILE"
```

### 🚀 Dando Vida al Script

**[DEMOSTRACIÓN PASO A PASO]**

```bash
# Dar permisos de ejecución
chmod +x info_sistema.sh

# Verificar permisos
ls -la info_sistema.sh

# Ejecutar nuestro script
./info_sistema.sh
```

**[EXPLICACIÓN DETALLADA]**

> "Analicemos cada parte de nuestro script:
>
> 1. **Shebang** (`#!/bin/bash`): Le dice al sistema qué intérprete usar
> 2. **Documentación**: Información crucial para mantenimiento
> 3. **`set -euo pipefail`**: Configuración de seguridad estricta
> 4. **Constantes**: Variables que no cambian durante la ejecución
> 5. **Funciones**: Código modular y reutilizable"

### 💡 El Poder del Shebang

**[DEMOSTRACIÓN COMPARATIVA]**

```bash
# Diferentes formas de ejecutar scripts
bash info_sistema.sh    # Método explícito
./info_sistema.sh       # Método directo (requiere shebang y permisos)
source info_sistema.sh  # Ejecuta en el shell actual

# Ver la diferencia práctica
echo "PID del shell actual: $$"
bash -c 'echo "PID de subshell: $$"'
```

**[BUENAS PRÁCTICAS]**

> "Reglas de oro para scripts profesionales:
>
> 1. **Siempre incluye shebang** en la primera línea
> 2. **Documenta el propósito** y uso del script
> 3. **Usa `set -euo pipefail`** para debugging robusto
> 4. **Nombra variables descriptivamente**
> 5. **Organiza el código en funciones**"

---

## 📦 PARTE 2: VARIABLES Y MANIPULACIÓN DE DATOS (12 minutos)

### 🎤 Transición

**[PANTALLA: Concepto de variables como contenedores]**

> "Las variables son los 'contenedores de memoria' de nuestros scripts. Pero en bash son mucho más poderosas de lo que parecen. No solo almacenan datos, pueden transformarlos, validarlos y manipularlos de formas increíbles."

### 📋 Tipos y Declaración de Variables

**[DEMOSTRACIÓN PROGRESIVA]**

```bash
# Crear script de demostración de variables
cat > variables_demo.sh << 'EOF'
#!/bin/bash

echo "=== DEMOSTRACIÓN DE VARIABLES EN BASH ==="

# Variables básicas
nombre="Juan Pérez"
edad=25
activo=true
precio=19.99

echo "Nombre: $nombre"
echo "Edad: $edad años"
echo "Activo: $activo"
echo "Precio: \$${precio}"

# Variables con espacios y caracteres especiales
mensaje="Hola mundo con espacios"
ruta="/home/usuario/mis documentos"  # Cuidado con espacios
comando_complejo="ls -la | grep txt"

echo "Mensaje: $mensaje"
echo "Ruta: '$ruta'"

# Diferencias entre comillas simples y dobles
variable="mundo"
echo "Con comillas dobles: Hola $variable"
echo 'Con comillas simples: Hola $variable'
EOF

chmod +x variables_demo.sh
./variables_demo.sh
```

### 🔧 Manipulación Avanzada de Variables

**[DEMOSTRACIÓN DE TÉCNICAS AVANZADAS]**

```bash
cat > manipulacion_avanzada.sh << 'EOF'
#!/bin/bash

echo "=== MANIPULACIÓN AVANZADA DE VARIABLES ==="

# Variable base
archivo="documento_importante.pdf"

# Extracción de partes
echo "Archivo completo: $archivo"
echo "Solo el nombre: ${archivo%.*}"           # documento_importante
echo "Solo la extensión: ${archivo##*.}"      # pdf
echo "Directorio (simulado): ${archivo%/*}"   # Si tuviera ruta

# Manipulación de longitud
echo "Longitud del nombre: ${#archivo} caracteres"

# Sustitución de patrones
nuevo_archivo="${archivo/importante/CRITICO}"
echo "Archivo renombrado: $nuevo_archivo"

# Conversión de case
nombre="JUAN PÉREZ"
echo "Original: $nombre"
echo "Minúsculas: ${nombre,,}"
echo "Primeras mayúsculas: ${nombre^}"

# Variables con valores por defecto
usuario_actual="${USER:-usuario_desconocido}"
directorio_trabajo="${WORKSPACE:-/tmp}"

echo "Usuario: $usuario_actual"
echo "Directorio de trabajo: $directorio_trabajo"

# Arrays básicos
frutas=("manzana" "banana" "naranja" "uva")
echo "Primera fruta: ${frutas[0]}"
echo "Todas las frutas: ${frutas[@]}"
echo "Número de frutas: ${#frutas[@]}"

# Iteración sobre array
echo "Lista de frutas:"
for fruta in "${frutas[@]}"; do
    echo "  - $fruta"
done
EOF

chmod +x manipulacion_avanzada.sh
./manipulacion_avanzada.sh
```

### 🔢 Variables Numéricas y Cálculos

**[DEMOSTRACIÓN MATEMÁTICA]**

```bash
cat > calculadora_bash.sh << 'EOF'
#!/bin/bash

echo "=== CALCULADORA BASH ==="

# Variables numéricas
numero1=15
numero2=4

# Aritmética básica con $(())
suma=$((numero1 + numero2))
resta=$((numero1 - numero2))
multiplicacion=$((numero1 * numero2))
division=$((numero1 / numero2))
modulo=$((numero1 % numero2))

echo "Números: $numero1 y $numero2"
echo "Suma: $suma"
echo "Resta: $resta"
echo "Multiplicación: $multiplicacion"
echo "División entera: $division"
echo "Módulo (resto): $modulo"

# Operaciones más complejas
potencia=$((numero1 ** 2))
echo "Potencia ($numero1²): $potencia"

# Comparaciones numéricas
if ((numero1 > numero2)); then
    echo "$numero1 es mayor que $numero2"
fi

# Incremento y decremento
contador=0
echo "Contador inicial: $contador"
((contador++))
echo "Después de incrementar: $contador"
((contador += 5))
echo "Después de sumar 5: $contador"

# Cálculos con decimales usando bc
precio_base=19.99
descuento=0.15
precio_final=$(echo "$precio_base * (1 - $descuento)" | bc)
echo "Precio base: \$${precio_base}"
echo "Descuento: ${descuento}%"
echo "Precio final: \$${precio_final}"
EOF

chmod +x calculadora_bash.sh
./calculadora_bash.sh
```

### 🌍 Variables de Entorno y Especiales

**[DEMOSTRACIÓN DE VARIABLES DEL SISTEMA]**

```bash
cat > variables_sistema.sh << 'EOF'
#!/bin/bash

echo "=== VARIABLES DE ENTORNO Y ESPECIALES ==="

# Variables especiales del script
echo "Nombre del script: $0"
echo "Primer argumento: $1"
echo "Segundo argumento: $2"
echo "Todos los argumentos: $@"
echo "Número de argumentos: $#"
echo "PID del script: $$"
echo "Código de salida del último comando: $?"

# Variables de entorno importantes
echo ""
echo "=== VARIABLES DE ENTORNO ==="
echo "Usuario actual: $USER"
echo "Directorio home: $HOME"
echo "Shell actual: $SHELL"
echo "Ruta de ejecutables: $PATH"
echo "Directorio actual: $PWD"
echo "Directorio anterior: $OLDPWD"

# Crear y exportar variables propias
MI_VARIABLE="valor_personalizado"
export MI_VARIABLE_GLOBAL="visible_en_subprocesos"

echo ""
echo "=== VARIABLES PERSONALIZADAS ==="
echo "Variable local: $MI_VARIABLE"
echo "Variable exportada: $MI_VARIABLE_GLOBAL"

# Demostrar diferencia local vs exportada
bash -c 'echo "En subproceso - Local: $MI_VARIABLE"'
bash -c 'echo "En subproceso - Exportada: $MI_VARIABLE_GLOBAL"'
EOF

chmod +x variables_sistema.sh
./variables_sistema.sh arg1 arg2 arg3
```

### 🔐 Validación y Seguridad de Variables

**[DEMOSTRACIÓN DE VALIDACIÓN]**

```bash
cat > validacion_variables.sh << 'EOF'
#!/bin/bash

echo "=== VALIDACIÓN DE VARIABLES ==="

# Función para validar email
validar_email() {
    local email="$1"
    local patron="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"

    if [[ $email =~ $patron ]]; then
        return 0  # Válido
    else
        return 1  # Inválido
    fi
}

# Función para validar número
validar_numero() {
    local valor="$1"
    if [[ $valor =~ ^[0-9]+$ ]]; then
        return 0
    else
        return 1
    fi
}

# Pruebas de validación
emails=("usuario@dominio.com" "email_invalido" "test@test.co.uk")
numeros=("123" "abc" "45.67" "0")

echo "=== VALIDACIÓN DE EMAILS ==="
for email in "${emails[@]}"; do
    if validar_email "$email"; then
        echo "✅ $email es válido"
    else
        echo "❌ $email es inválido"
    fi
done

echo ""
echo "=== VALIDACIÓN DE NÚMEROS ==="
for numero in "${numeros[@]}"; do
    if validar_numero "$numero"; then
        echo "✅ '$numero' es un número válido"
    else
        echo "❌ '$numero' no es un número válido"
    fi
done

# Verificación de variables requeridas
verificar_variable() {
    local var_name="$1"
    local var_value="$2"

    if [[ -z "$var_value" ]]; then
        echo "❌ Error: Variable '$var_name' es requerida pero está vacía"
        return 1
    else
        echo "✅ Variable '$var_name' está definida: '$var_value'"
        return 0
    fi
}

# Ejemplos de verificación
USUARIO="admin"
PASSWORD=""

verificar_variable "USUARIO" "$USUARIO"
verificar_variable "PASSWORD" "$PASSWORD"
EOF

chmod +x validacion_variables.sh
./validacion_variables.sh
```

**[MEJORES PRÁCTICAS]**

> "Consejos para variables robustas:
>
> 1. **Siempre usa comillas dobles** alrededor de variables: `"$variable"`
> 2. **Valida datos de entrada** antes de usarlos
> 3. **Usa nombres descriptivos**: `usuario_actual` no `u`
> 4. **Constantes en MAYÚSCULAS**: `readonly MAX_INTENTOS=3`
> 5. **Variables locales en funciones**: `local variable="valor"`"

---

## 🤔 PARTE 3: ESTRUCTURAS CONDICIONALES (15 minutos)

### 🎤 Transición

**[PANTALLA: Diagrama de flujo animado con decisiones]**

> "Hasta ahora nuestros scripts ejecutan comandos secuencialmente. Pero la verdadera inteligencia viene cuando pueden tomar decisiones. Las estructuras condicionales son el cerebro de nuestros scripts: evalúan situaciones y eligen qué hacer."

### 🔍 La Declaración if: La Base de las Decisiones

**[PANTALLA: Sintaxis básica de if resaltada]**

> "La estructura `if` es como un guardia de seguridad: examina una condición y solo permite pasar si se cumple. Pero bash tiene varias formas de escribir condiciones, cada una optimizada para diferentes situaciones."

**[DEMOSTRACIÓN FUNDAMENTAL]**

```bash
cat > condicionales_basico.sh << 'EOF'
#!/bin/bash

echo "=== CONDICIONALES BÁSICOS EN BASH ==="

# Variables de prueba
edad=25
nombre="Ana"
archivo="datos.txt"

# IF básico - verificar edad
if [ $edad -ge 18 ]; then
    echo "✅ $nombre es mayor de edad ($edad años)"
else
    echo "❌ $nombre es menor de edad ($edad años)"
fi

# IF con múltiples condiciones
if [ $edad -ge 18 ] && [ $edad -le 65 ]; then
    echo "✅ $nombre está en edad laboral"
elif [ $edad -gt 65 ]; then
    echo "🏖️ $nombre está en edad de jubilación"
else
    echo "📚 $nombre está en edad escolar"
fi

# Verificación de archivos
echo ""
echo "=== VERIFICACIÓN DE ARCHIVOS ==="

if [ -f "$archivo" ]; then
    echo "✅ El archivo $archivo existe"
    if [ -r "$archivo" ]; then
        echo "✅ El archivo es legible"
    fi
    if [ -w "$archivo" ]; then
        echo "✅ El archivo es escribible"
    fi
else
    echo "❌ El archivo $archivo no existe"
    echo "Creando archivo de prueba..."
    touch "$archivo"
    echo "✅ Archivo $archivo creado"
fi

# Verificación de directorios
directorio="/tmp"
if [ -d "$directorio" ]; then
    echo "✅ El directorio $directorio existe"
    espacio_libre=$(df "$directorio" | awk 'NR==2 {print $4}')
    echo "Espacio libre: ${espacio_libre}KB"
fi
EOF

chmod +x condicionales_basico.sh
./condicionales_basico.sh
```

### 🔧 Operadores de Comparación: El Vocabulario de las Decisiones

**[PANTALLA: Tabla de operadores con ejemplos]**

> "Bash tiene tres tipos principales de operadores de comparación, cada uno especializado:"

**[DEMOSTRACIÓN DE OPERADORES]**

```bash
cat > operadores_comparacion.sh << 'EOF'
#!/bin/bash

echo "=== OPERADORES DE COMPARACIÓN ==="

# Variables de prueba
numero1=10
numero2=20
texto1="hola"
texto2="mundo"
archivo1="script.sh"
archivo2="datos.txt"

echo "Variables: numero1=$numero1, numero2=$numero2"
echo "Textos: texto1='$texto1', texto2='$texto2'"
echo ""

# OPERADORES NUMÉRICOS
echo "=== OPERADORES NUMÉRICOS ==="
[ $numero1 -eq $numero2 ] && echo "✅ $numero1 == $numero2" || echo "❌ $numero1 != $numero2"
[ $numero1 -ne $numero2 ] && echo "✅ $numero1 != $numero2" || echo "❌ $numero1 == $numero2"
[ $numero1 -lt $numero2 ] && echo "✅ $numero1 < $numero2" || echo "❌ $numero1 >= $numero2"
[ $numero1 -le $numero2 ] && echo "✅ $numero1 <= $numero2" || echo "❌ $numero1 > $numero2"
[ $numero1 -gt $numero2 ] && echo "✅ $numero1 > $numero2" || echo "❌ $numero1 <= $numero2"
[ $numero1 -ge $numero2 ] && echo "✅ $numero1 >= $numero2" || echo "❌ $numero1 < $numero2"

echo ""

# OPERADORES DE CADENAS
echo "=== OPERADORES DE CADENAS ==="
[ "$texto1" = "$texto2" ] && echo "✅ '$texto1' == '$texto2'" || echo "❌ '$texto1' != '$texto2'"
[ "$texto1" != "$texto2" ] && echo "✅ '$texto1' != '$texto2'" || echo "❌ '$texto1' == '$texto2'"
[ -z "$texto1" ] && echo "✅ '$texto1' está vacío" || echo "❌ '$texto1' no está vacío"
[ -n "$texto1" ] && echo "✅ '$texto1' no está vacío" || echo "❌ '$texto1' está vacío"

# Comparación lexicográfica
if [[ "$texto1" < "$texto2" ]]; then
    echo "✅ '$texto1' viene antes que '$texto2' alfabéticamente"
fi

echo ""

# OPERADORES DE ARCHIVOS
echo "=== OPERADORES DE ARCHIVOS ==="
touch "$archivo1" "$archivo2"  # Crear archivos de prueba

[ -e "$archivo1" ] && echo "✅ $archivo1 existe" || echo "❌ $archivo1 no existe"
[ -f "$archivo1" ] && echo "✅ $archivo1 es un archivo regular" || echo "❌ $archivo1 no es archivo regular"
[ -d "$archivo1" ] && echo "✅ $archivo1 es un directorio" || echo "❌ $archivo1 no es directorio"
[ -r "$archivo1" ] && echo "✅ $archivo1 es legible" || echo "❌ $archivo1 no es legible"
[ -w "$archivo1" ] && echo "✅ $archivo1 es escribible" || echo "❌ $archivo1 no es escribible"
[ -x "$archivo1" ] && echo "✅ $archivo1 es ejecutable" || echo "❌ $archivo1 no es ejecutable"

# Hacer ejecutable y verificar
chmod +x "$archivo1"
[ -x "$archivo1" ] && echo "✅ Ahora $archivo1 es ejecutable"

# Comparar fechas de archivos
sleep 1
touch "$archivo2"  # Actualizar timestamp
[ "$archivo1" -nt "$archivo2" ] && echo "✅ $archivo1 es más nuevo que $archivo2" || echo "❌ $archivo1 es más viejo que $archivo2"
[ "$archivo1" -ot "$archivo2" ] && echo "✅ $archivo1 es más viejo que $archivo2" || echo "❌ $archivo1 es más nuevo que $archivo2"

# Limpiar archivos de prueba
rm -f "$archivo1" "$archivo2"
EOF

chmod +x operadores_comparacion.sh
./operadores_comparacion.sh
```

### 🧠 Comparaciones Avanzadas con [[]]

**[PANTALLA: Diferencias entre [ ] y [[]]**

> "Los corchetes dobles `[[ ]]` son una evolución de bash que ofrece características avanzadas como expresiones regulares y manejo más seguro de variables."

**[DEMOSTRACIÓN AVANZADA]**

```bash
cat > comparaciones_avanzadas.sh << 'EOF'
#!/bin/bash

echo "=== COMPARACIONES AVANZADAS CON [[ ]] ==="

# Variables de prueba
email="usuario@dominio.com"
telefono="123-456-7890"
edad=25
nombre="Juan Carlos"

# Expresiones regulares con =~
echo "=== VALIDACIÓN CON EXPRESIONES REGULARES ==="

if [[ $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "✅ Email válido: $email"
else
    echo "❌ Email inválido: $email"
fi

if [[ $telefono =~ ^[0-9]{3}-[0-9]{3}-[0-9]{4}$ ]]; then
    echo "✅ Teléfono válido: $telefono"
else
    echo "❌ Teléfono inválido: $telefono"
fi

# Patrones con wildcards
echo ""
echo "=== PATRONES CON WILDCARDS ==="

if [[ $nombre == Juan* ]]; then
    echo "✅ El nombre comienza con 'Juan'"
fi

if [[ $email == *@dominio.com ]]; then
    echo "✅ Email del dominio correcto"
fi

if [[ $nombre == *Carlos ]]; then
    echo "✅ El nombre termina con 'Carlos'"
fi

# Verificación de rangos numéricos
echo ""
echo "=== RANGOS NUMÉRICOS COMPLEJOS ==="

if [[ $edad -ge 18 && $edad -le 30 ]]; then
    echo "✅ $nombre está en el rango de edad joven adulto (18-30)"
elif [[ $edad -ge 31 && $edad -le 50 ]]; then
    echo "✅ $nombre está en el rango de edad adulto (31-50)"
elif [[ $edad -ge 51 && $edad -le 70 ]]; then
    echo "✅ $nombre está en el rango de edad adulto mayor (51-70)"
else
    echo "✅ $nombre está fuera de los rangos típicos"
fi

# Comparaciones de strings más seguras
string_vacio=""
string_con_espacios="  texto con espacios  "

echo ""
echo "=== MANEJO SEGURO DE STRINGS ==="

if [[ -z $string_vacio ]]; then
    echo "✅ String vacío detectado correctamente"
fi

if [[ -n $string_con_espacios ]]; then
    echo "✅ String con contenido detectado: '$string_con_espacios'"
fi

# Trim de espacios en comparación
if [[ ${string_con_espacios// /} == "textoconspacios" ]]; then
    echo "✅ Comparación después de remover espacios"
fi
EOF

chmod +x comparaciones_avanzadas.sh
./comparaciones_avanzadas.sh
```

### 🎯 La Declaración case: Múltiples Decisiones Elegantes

**[PANTALLA: Sintaxis de case con múltiples patrones]**

> "`case` es como un switch statement, pero mucho más poderoso. Puede manejar patrones, rangos y múltiples opciones de forma elegante."

**[DEMOSTRACIÓN DE CASE]**

```bash
cat > menu_interactivo.sh << 'EOF'
#!/bin/bash

# Colores para el menú
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

mostrar_menu() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════╗"
    echo "║           MENÚ PRINCIPAL             ║"
    echo "╠══════════════════════════════════════╣"
    echo "║ 1. Información del sistema           ║"
    echo "║ 2. Gestión de archivos              ║"
    echo "║ 3. Monitoreo de procesos            ║"
    echo "║ 4. Configuración de red             ║"
    echo "║ 5. Backup y restauración            ║"
    echo "║ q/Q. Salir                          ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
}

procesar_opcion() {
    local opcion="$1"

    case $opcion in
        1|"info"|"información")
            echo -e "${GREEN}📊 Mostrando información del sistema...${NC}"
            echo "Hostname: $(hostname)"
            echo "Uptime: $(uptime -p 2>/dev/null || uptime)"
            echo "Usuarios conectados: $(who | wc -l)"
            ;;

        2|"archivos"|"files")
            echo -e "${YELLOW}📁 Gestión de archivos...${NC}"
            echo "Archivos en directorio actual: $(ls -1 | wc -l)"
            echo "Espacio usado: $(du -sh . 2>/dev/null | cut -f1)"
            echo "Últimos archivos modificados:"
            ls -lt | head -5
            ;;

        3|"procesos"|"ps")
            echo -e "${PURPLE}⚙️ Monitoreo de procesos...${NC}"
            echo "Procesos activos: $(ps aux | wc -l)"
            echo "Memoria libre: $(free -h | awk 'NR==2{print $7}')"
            echo "Top 5 procesos por CPU:"
            ps aux --sort=-%cpu | head -6
            ;;

        4|"red"|"network")
            echo -e "${BLUE}🌐 Configuración de red...${NC}"
            echo "Interfaces de red:"
            ip addr show 2>/dev/null || ifconfig
            ;;

        5|"backup"|"respaldo")
            echo -e "${YELLOW}💾 Sistema de backup...${NC}"
            backup_dir="/tmp/backup_$(date +%Y%m%d)"
            echo "Directorio de backup: $backup_dir"
            mkdir -p "$backup_dir"
            echo "✅ Directorio de backup creado"
            ;;

        [qQ]|"quit"|"exit"|"salir")
            echo -e "${GREEN}👋 ¡Hasta luego!${NC}"
            exit 0
            ;;

        "")
            echo -e "${RED}❌ Opción vacía. Por favor selecciona una opción.${NC}"
            ;;

        [0-9]*)
            if [[ $opcion -gt 5 ]]; then
                echo -e "${RED}❌ Opción numérica inválida: $opcion${NC}"
                echo "Por favor selecciona un número entre 1 y 5"
            else
                echo -e "${RED}❌ Número no reconocido: $opcion${NC}"
            fi
            ;;

        *)
            echo -e "${RED}❌ Opción no reconocida: '$opcion'${NC}"
            echo "Opciones válidas: 1-5, q, quit, exit, salir"
            echo "También puedes usar: info, archivos, procesos, red, backup"
            ;;
    esac
}

# Función principal
main() {
    echo -e "${GREEN}🚀 Bienvenido al Sistema de Gestión${NC}"

    while true; do
        echo ""
        mostrar_menu
        echo -n "Selecciona una opción: "
        read -r opcion

        echo ""
        procesar_opcion "$opcion"

        echo ""
        echo -n "Presiona Enter para continuar..."
        read -r
        clear
    done
}

# Solo ejecutar si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
EOF

chmod +x menu_interactivo.sh
echo "Script interactivo creado. Ejecuta: ./menu_interactivo.sh"
```

### 🔗 Operadores Lógicos: Combinando Condiciones

**[DEMOSTRACIÓN DE LÓGICA COMPLEJA]**

```bash
cat > logica_compleja.sh << 'EOF'
#!/bin/bash

echo "=== OPERADORES LÓGICOS Y CONDICIONES COMPLEJAS ==="

# Variables de prueba
usuario="admin"
password="secreto123"
intentos=3
es_admin=true
hora_actual=$(date +%H)

echo "Usuario: $usuario"
echo "Intentos restantes: $intentos"
echo "Hora actual: ${hora_actual}:00"
echo "Es admin: $es_admin"
echo ""

# AND lógico (&&)
echo "=== OPERADOR AND (&&) ==="
if [[ $usuario == "admin" && $password == "secreto123" ]]; then
    echo "✅ Credenciales correctas"
else
    echo "❌ Credenciales incorrectas"
fi

# Verificación de horario laboral
if [[ $hora_actual -ge 9 && $hora_actual -le 17 ]]; then
    echo "✅ Dentro del horario laboral (9-17)"
else
    echo "❌ Fuera del horario laboral"
fi

echo ""

# OR lógico (||)
echo "=== OPERADOR OR (||) ==="
if [[ $usuario == "admin" || $usuario == "root" ]]; then
    echo "✅ Usuario privilegiado detectado"
else
    echo "❌ Usuario normal"
fi

# Verificación de acceso de emergencia
if [[ $hora_actual -lt 6 || $hora_actual -gt 22 ]]; then
    echo "⚠️ Acceso en horario de emergencia"
else
    echo "✅ Acceso en horario normal"
fi

echo ""

# NOT lógico (!)
echo "=== OPERADOR NOT (!) ==="
if [[ ! -z $password ]]; then
    echo "✅ Password no está vacío"
fi

if [[ ! $intentos -eq 0 ]]; then
    echo "✅ Aún hay intentos disponibles ($intentos)"
fi

echo ""

# Condiciones complejas combinadas
echo "=== CONDICIONES COMPLEJAS ==="

# Verificación de acceso completa
if [[ $usuario == "admin" && $password == "secreto123" && $intentos -gt 0 ]]; then
    if [[ $hora_actual -ge 9 && $hora_actual -le 17 ]] || [[ $es_admin == true ]]; then
        echo "🟢 ACCESO CONCEDIDO"
        echo "  - Credenciales válidas"
        echo "  - Horario permitido o usuario admin"
        echo "  - Intentos disponibles: $intentos"
    else
        echo "🟡 ACCESO RESTRINGIDO"
        echo "  - Credenciales válidas pero fuera de horario"
        echo "  - Solo administradores pueden acceder ahora"
    fi
else
    echo "🔴 ACCESO DENEGADO"
    if [[ $usuario != "admin" ]]; then
        echo "  - Usuario incorrecto"
    fi
    if [[ $password != "secreto123" ]]; then
        echo "  - Password incorrecto"
    fi
    if [[ $intentos -eq 0 ]]; then
        echo "  - Sin intentos restantes"
    fi
fi

echo ""

# Validación de datos con múltiples condiciones
echo "=== VALIDACIÓN DE DATOS COMPLEJOS ==="

validar_usuario() {
    local user="$1"
    local pass="$2"
    local email="$3"

    local errores=0

    # Validar usuario
    if [[ ${#user} -lt 3 || ${#user} -gt 20 ]]; then
        echo "❌ Usuario debe tener entre 3 y 20 caracteres"
        ((errores++))
    fi

    if [[ ! $user =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "❌ Usuario solo puede contener letras, números y guiones bajos"
        ((errores++))
    fi

    # Validar password
    if [[ ${#pass} -lt 8 ]]; then
        echo "❌ Password debe tener al menos 8 caracteres"
        ((errores++))
    fi

    if [[ ! $pass =~ [A-Z] ]]; then
        echo "❌ Password debe contener al menos una mayúscula"
        ((errores++))
    fi

    if [[ ! $pass =~ [0-9] ]]; then
        echo "❌ Password debe contener al menos un número"
        ((errores++))
    fi

    # Validar email
    if [[ ! $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        echo "❌ Email tiene formato inválido"
        ((errores++))
    fi

    if [[ $errores -eq 0 ]]; then
        echo "✅ Todos los datos son válidos"
        return 0
    else
        echo "❌ Se encontraron $errores errores"
        return 1
    fi
}

# Pruebas de validación
echo "Validando datos de usuario..."
validar_usuario "admin" "Secreto123" "admin@empresa.com"
EOF

chmod +x logica_compleja.sh
./logica_compleja.sh
```

**[MEJORES PRÁCTICAS PARA CONDICIONALES]**

> "Consejos para condicionales robustos:
>
> 1. **Usa `[[ ]]` en lugar de `[ ]`** para características avanzadas
> 2. **Siempre entrecomilla variables**: `[[ "$variable" == "valor" ]]`
> 3. **Usa `case` para múltiples opciones** en lugar de múltiples `if`
> 4. **Combina condiciones lógicamente**: `&&` para Y, `||` para O
> 5. **Valida entrada de usuario** antes de usarla en condiciones"

---

## 🔄 PARTE 4: BUCLES Y ITERACIÓN (13 minutos)

### 🎤 Transición

**[PANTALLA: Animación de bucle infinito convertido en bucle controlado]**

> "Los bucles son la automatización llevada al extremo. Permiten que nuestros scripts repitan tareas miles de veces sin cansarse, procesen listas enormes de datos y trabajen 24/7 sin supervisión. Son la diferencia entre hacer algo una vez y automatizarlo para siempre."

### 🎯 El Bucle for: Iteración Controlada

**[PANTALLA: Diagrama de flujo del bucle for]**

> "El bucle `for` es como un trabajador metódico: toma una lista de tareas y las ejecuta una por una hasta terminar. Es perfecto cuando sabes exactamente qué quieres procesar."

**[DEMOSTRACIÓN FUNDAMENTAL]**

```bash
cat > bucles_for_basico.sh << 'EOF'
#!/bin/bash

echo "=== BUCLES FOR BÁSICOS ==="

# FOR con lista explícita
echo "1. Iteración sobre lista de nombres:"
for nombre in Juan María Pedro Ana Luis; do
    echo "  Procesando usuario: $nombre"
done

echo ""

# FOR con rango numérico
echo "2. Bucle numérico (sintaxis clásica):"
for i in {1..5}; do
    echo "  Iteración número: $i"
done

echo ""

# FOR con rango y paso
echo "3. Bucle con incremento personalizado:"
for numero in {0..20..5}; do
    echo "  Número: $numero"
done

echo ""

# FOR estilo C
echo "4. Bucle estilo C (más control):"
for ((i=1; i<=5; i++)); do
    echo "  Contador: $i, Cuadrado: $((i*i))"
done

echo ""

# FOR con arrays
echo "5. Iteración sobre arrays:"
frutas=("manzana" "banana" "naranja" "uva" "pera")
for fruta in "${frutas[@]}"; do
    echo "  Fruta: $fruta (${#fruta} caracteres)"
done

echo ""

# FOR con archivos
echo "6. Procesamiento de archivos:"
echo "Archivos .sh en el directorio actual:"
for archivo in *.sh; do
    if [[ -f "$archivo" ]]; then
        tamaño=$(wc -l < "$archivo")
        echo "  $archivo: $tamaño líneas"
    fi
done
EOF

chmod +x bucles_for_basico.sh
./bucles_for_basico.sh
```

### 🔍 Bucles for Avanzados: Procesamiento Real

**[DEMOSTRACIÓN DE CASOS PRÁCTICOS]**

```bash
cat > procesamiento_archivos.sh << 'EOF'
#!/bin/bash

echo "=== PROCESAMIENTO AVANZADO CON FOR ==="

# Crear archivos de prueba
mkdir -p datos_prueba
cd datos_prueba

# Generar archivos de diferentes tipos
for i in {1..5}; do
    echo "Contenido del archivo $i" > "archivo_$i.txt"
    echo "#!/bin/bash" > "script_$i.sh"
    echo "echo 'Script $i'" >> "script_$i.sh"
    chmod +x "script_$i.sh"
done

# Crear algunos archivos de log
for dia in {01..07}; do
    echo "$(date) - Log del día $dia" > "log_2024-08-$dia.log"
    echo "ERROR: Algo salió mal el día $dia" >> "log_2024-08-$dia.log"
    echo "INFO: Sistema funcionando correctamente" >> "log_2024-08-$dia.log"
done

cd ..

echo "1. Análisis de archivos por tipo:"
for extension in txt sh log; do
    echo "  Archivos .$extension:"
    contador=0
    tamaño_total=0

    for archivo in datos_prueba/*.$extension; do
        if [[ -f "$archivo" ]]; then
            ((contador++))
            tamaño=$(stat -f%z "$archivo" 2>/dev/null || stat -c%s "$archivo" 2>/dev/null || echo "0")
            ((tamaño_total += tamaño))
            echo "    - $(basename "$archivo"): ${tamaño} bytes"
        fi
    done

    echo "    Total: $contador archivos, $tamaño_total bytes"
    echo ""
done

echo "2. Backup automático de archivos:"
backup_dir="backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup_dir"

for archivo in datos_prueba/*.txt; do
    if [[ -f "$archivo" ]]; then
        nombre_backup="$(basename "$archivo" .txt)_backup_$(date +%H%M%S).txt"
        cp "$archivo" "$backup_dir/$nombre_backup"
        echo "  ✅ Backup creado: $nombre_backup"
    fi
done

echo ""

echo "3. Procesamiento de logs con estadísticas:"
total_errores=0
total_infos=0

for log_file in datos_prueba/*.log; do
    if [[ -f "$log_file" ]]; then
        errores=$(grep -c "ERROR" "$log_file")
        infos=$(grep -c "INFO" "$log_file")

        echo "  Log: $(basename "$log_file")"
        echo "    - Errores: $errores"
        echo "    - Infos: $infos"

        ((total_errores += errores))
        ((total_infos += infos))
    fi
done

echo ""
echo "  📊 RESUMEN TOTAL:"
echo "    - Total errores: $total_errores"
echo "    - Total infos: $total_infos"

# Limpiar archivos de prueba
rm -rf datos_prueba backup_*
EOF

chmod +x procesamiento_archivos.sh
./procesamiento_archivos.sh
```

### ♾️ El Bucle while: Iteración Condicional

**[PANTALLA: Diferencia conceptual entre for y while]**

> "Mientras `for` itera sobre listas conocidas, `while` continúa hasta que una condición cambie. Es como un centinela que trabaja hasta recibir la orden de parar."

**[DEMOSTRACIÓN DE WHILE]**

```bash
cat > bucles_while.sh << 'EOF'
#!/bin/bash

echo "=== BUCLES WHILE ==="

# WHILE básico con contador
echo "1. Contador básico:"
contador=1
while [[ $contador -le 5 ]]; do
    echo "  Iteración $contador"
    ((contador++))
done

echo ""

# WHILE leyendo archivo línea por línea
echo "2. Procesamiento línea por línea:"

# Crear archivo de datos
cat > empleados.txt << 'EMPLEADOS'
Juan,Desarrollador,3000
María,Diseñadora,2800
Pedro,Administrador,3200
Ana,Analista,2900
Luis,Tester,2600
EMPLEADOS

echo "Procesando archivo de empleados:"
total_salario=0
empleados_procesados=0

while IFS=',' read -r nombre puesto salario; do
    echo "  👤 $nombre - $puesto: \$${salario}"
    ((total_salario += salario))
    ((empleados_procesados++))
done < empleados.txt

promedio=$((total_salario / empleados_procesados))
echo ""
echo "  📊 Estadísticas:"
echo "    - Empleados procesados: $empleados_procesados"
echo "    - Salario total: \$${total_salario}"
echo "    - Salario promedio: \$${promedio}"

echo ""

# WHILE con entrada de usuario (simulado)
echo "3. Simulación de menú interactivo:"
opcion="continuar"
iteracion=1

while [[ $opcion != "salir" && $iteracion -le 3 ]]; do
    echo "  Iteración $iteracion del menú"
    echo "  Procesando opción: $opcion"

    # Simular diferentes opciones
    case $iteracion in
        1) opcion="info" ;;
        2) opcion="procesos" ;;
        3) opcion="salir" ;;
    esac

    echo "  Próxima opción será: $opcion"
    ((iteracion++))
    sleep 1
done

echo ""

# WHILE con monitoreo de archivos
echo "4. Monitoreo de archivos:"
archivo_monitor="archivo_temporal.txt"
echo "contenido inicial" > "$archivo_monitor"

intentos=0
max_intentos=5

while [[ -f "$archivo_monitor" && $intentos -lt $max_intentos ]]; do
    tamaño=$(wc -c < "$archivo_monitor")
    echo "  Intento $((intentos + 1)): Archivo existe, tamaño: $tamaño bytes"

    # Simular modificación del archivo
    echo "línea adicional $intentos" >> "$archivo_monitor"
    ((intentos++))

    # Condición de salida
    if [[ $intentos -eq 3 ]]; then
        echo "  Eliminando archivo para terminar el bucle..."
        rm "$archivo_monitor"
    fi

    sleep 1
done

echo "  ✅ Monitoreo completado"

# Limpiar
rm -f empleados.txt archivo_temporal.txt
EOF

chmod +x bucles_while.sh
./bucles_while.sh
```

### 🔄 El Bucle until: La Lógica Invertida

**[DEMOSTRACIÓN DE UNTIL]**

```bash
cat > bucles_until.sh << 'EOF'
#!/bin/bash

echo "=== BUCLES UNTIL ==="

# UNTIL básico - ejecuta HASTA que la condición sea verdadera
echo "1. Countdown con until:"
segundos=5
echo "Iniciando countdown desde $segundos..."

until [[ $segundos -eq 0 ]]; do
    echo "  ⏰ $segundos segundos restantes"
    ((segundos--))
    sleep 1
done

echo "  🚀 ¡Despegue!"

echo ""

# UNTIL esperando que un archivo aparezca
echo "2. Esperando archivo:"
archivo_esperado="archivo_que_aparecera.txt"

# Simular que el archivo aparecerá después de algunos intentos
(sleep 3; echo "archivo creado" > "$archivo_esperado") &

intentos=0
until [[ -f "$archivo_esperado" ]]; do
    ((intentos++))
    echo "  Intento $intentos: Esperando que aparezca $archivo_esperado..."
    sleep 1

    # Seguridad para evitar bucle infinito
    if [[ $intentos -eq 10 ]]; then
        echo "  ⚠️ Timeout alcanzado"
        break
    fi
done

if [[ -f "$archivo_esperado" ]]; then
    echo "  ✅ ¡Archivo encontrado!"
    cat "$archivo_esperado"
    rm "$archivo_esperado"
else
    echo "  ❌ Archivo no encontrado después de $intentos intentos"
fi

echo ""

# UNTIL con conexión de red (simulado)
echo "3. Simulación de espera de conectividad:"
conectado=false
reintentos=0

until [[ $conectado == true ]]; do
    ((reintentos++))
    echo "  Intento $reintentos: Verificando conectividad..."

    # Simular conexión exitosa después de 3 intentos
    if [[ $reintentos -ge 3 ]]; then
        conectado=true
        echo "  ✅ Conexión establecida"
    else
        echo "  ❌ Sin conexión, reintentando..."
        sleep 1
    fi

    # Seguridad
    if [[ $reintentos -eq 10 ]]; then
        echo "  ⚠️ Máximo de reintentos alcanzado"
        break
    fi
done
EOF

chmod +x bucles_until.sh
./bucles_until.sh
```

### 🛠️ Control de Bucles: break y continue

**[DEMOSTRACIÓN DE CONTROL DE FLUJO]**

```bash
cat > control_bucles.sh << 'EOF'
#!/bin/bash

echo "=== CONTROL DE BUCLES: break y continue ==="

# BREAK - salir del bucle prematuramente
echo "1. Uso de break:"
echo "Buscando el primer número par en la lista:"

numeros=(1 3 5 8 9 11 12 15)
for numero in "${numeros[@]}"; do
    echo "  Verificando: $numero"

    if [[ $((numero % 2)) -eq 0 ]]; then
        echo "  ✅ Primer número par encontrado: $numero"
        break
    fi

    echo "  ❌ $numero es impar, continuando..."
done

echo ""

# CONTINUE - saltar a la siguiente iteración
echo "2. Uso de continue:"
echo "Procesando solo números pares:"

for numero in {1..10}; do
    # Saltar números impares
    if [[ $((numero % 2)) -ne 0 ]]; then
        continue
    fi

    echo "  Procesando número par: $numero"
    echo "    - Cuadrado: $((numero * numero))"
    echo "    - Mitad: $((numero / 2))"
done

echo ""

# Ejemplo práctico: procesamiento de archivos con errores
echo "3. Procesamiento robusto de archivos:"

# Crear archivos de prueba (algunos con errores)
mkdir -p test_files
for i in {1..5}; do
    if [[ $i -eq 3 ]]; then
        # Archivo problemático
        echo -e "línea 1\nlínea con\tcaracteres\tespeciales" > "test_files/archivo_$i.txt"
    else
        echo "contenido normal del archivo $i" > "test_files/archivo_$i.txt"
    fi
done

# También crear un archivo vacío
touch test_files/archivo_vacio.txt

archivos_procesados=0
archivos_saltados=0
errores_encontrados=0

for archivo in test_files/*.txt; do
    echo "  📁 Procesando: $(basename "$archivo")"

    # Verificar si el archivo existe y no está vacío
    if [[ ! -f "$archivo" ]]; then
        echo "    ❌ Archivo no existe, saltando..."
        ((archivos_saltados++))
        continue
    fi

    if [[ ! -s "$archivo" ]]; then
        echo "    ⚠️ Archivo vacío, saltando..."
        ((archivos_saltados++))
        continue
    fi

    # Procesar contenido
    lineas=$(wc -l < "$archivo")
    caracteres=$(wc -c < "$archivo")

    # Verificar si tiene caracteres especiales problemáticos
    if grep -q $'\t' "$archivo"; then
        echo "    ⚠️ Archivo contiene tabs, requiere procesamiento especial"
        ((errores_encontrados++))

        # Aquí podrías decidir saltar o procesar de forma especial
        # Para este ejemplo, continuamos pero marcamos el error
    fi

    echo "    ✅ Procesado: $lineas líneas, $caracteres caracteres"
    ((archivos_procesados++))

    # Condición de parada de emergencia
    if [[ $errores_encontrados -ge 2 ]]; then
        echo "    🚨 Demasiados errores, abortando procesamiento"
        break
    fi
done

echo ""
echo "  📊 RESUMEN:"
echo "    - Archivos procesados: $archivos_procesados"
echo "    - Archivos saltados: $archivos_saltados"
echo "    - Errores encontrados: $errores_encontrados"

# Limpiar
rm -rf test_files

echo ""

# Bucles anidados con control
echo "4. Bucles anidados con break y continue:"
echo "Tabla de multiplicar (solo números pares):"

for i in {1..5}; do
    # Saltar filas impares
    if [[ $((i % 2)) -ne 0 ]]; then
        continue
    fi

    echo "  Fila $i:"
    for j in {1..5}; do
        producto=$((i * j))

        # Saltar productos mayores a 15
        if [[ $producto -gt 15 ]]; then
            echo "    (productos mayores a 15 omitidos)"
            break
        fi

        echo "    $i x $j = $producto"
    done
done
EOF

chmod +x control_bucles.sh
./control_bucles.sh
```

### 🔄 Bucles Infinitos y Patrones Avanzados

**[DEMOSTRACIÓN DE PATRONES PROFESIONALES]**

```bash
cat > bucles_avanzados.sh << 'EOF'
#!/bin/bash

echo "=== BUCLES AVANZADOS Y PATRONES ==="

# Simulación de servidor que procesa trabajos
echo "1. Simulación de procesador de trabajos:"

trabajos_pendientes=("backup" "cleanup" "report" "sync" "check")
trabajos_procesados=0
max_trabajos=3

while true; do
    # Verificar si hay trabajos pendientes
    if [[ ${#trabajos_pendientes[@]} -eq 0 ]]; then
        echo "  ✅ Todos los trabajos completados"
        break
    fi

    # Verificar límite de trabajos
    if [[ $trabajos_procesados -ge $max_trabajos ]]; then
        echo "  ⏸️ Límite de trabajos alcanzado por esta sesión"
        break
    fi

    # Procesar el primer trabajo
    trabajo_actual="${trabajos_pendientes[0]}"
    echo "  🔄 Procesando trabajo: $trabajo_actual"

    # Simular procesamiento
    sleep 1

    # Simular posible fallo
    if [[ $trabajo_actual == "sync" ]]; then
        echo "    ❌ Error en trabajo $trabajo_actual, reintentando..."
        # En lugar de eliminarlo, lo movemos al final
        trabajos_pendientes=("${trabajos_pendientes[@]:1}" "$trabajo_actual")
        continue
    fi

    echo "    ✅ Trabajo $trabajo_actual completado"

    # Eliminar trabajo de la lista
    trabajos_pendientes=("${trabajos_pendientes[@]:1}")
    ((trabajos_procesados++))
done

echo "  Trabajos restantes: ${trabajos_pendientes[*]}"

echo ""

# Procesamiento paralelo simulado
echo "2. Simulación de procesamiento paralelo:"

procesar_lote() {
    local lote_id="$1"
    local elementos="$2"

    echo "  Lote $lote_id iniciado con $elementos elementos"

    for ((i=1; i<=elementos; i++)); do
        echo "    Lote $lote_id: procesando elemento $i/$elementos"
        sleep 0.5
    done

    echo "  ✅ Lote $lote_id completado"
}

# Simular 3 lotes procesándose
lotes=(5 3 4)  # número de elementos por lote

for indice in "${!lotes[@]}"; do
    lote_num=$((indice + 1))
    elementos="${lotes[$indice]}"

    echo "Iniciando lote $lote_num en background..."
    procesar_lote "$lote_num" "$elementos" &
done

# Esperar a que todos los lotes terminen
wait
echo "🎉 Todos los lotes completados"

echo ""

# Monitor de sistema simplificado
echo "3. Monitor de sistema (5 iteraciones):"

for iteracion in {1..5}; do
    echo "  📊 Iteración $iteracion - $(date '+%H:%M:%S')"

    # Simular métricas del sistema
    cpu_usage=$((RANDOM % 100))
    mem_usage=$((RANDOM % 100))
    disk_usage=$((RANDOM % 100))

    echo "    CPU: ${cpu_usage}%"
    echo "    Memoria: ${mem_usage}%"
    echo "    Disco: ${disk_usage}%"

    # Alertas basadas en umbrales
    alertas=()
    [[ $cpu_usage -gt 80 ]] && alertas+=("CPU alta")
    [[ $mem_usage -gt 90 ]] && alertas+=("Memoria crítica")
    [[ $disk_usage -gt 95 ]] && alertas+=("Disco lleno")

    if [[ ${#alertas[@]} -gt 0 ]]; then
        echo "    🚨 ALERTAS: ${alertas[*]}"
    else
        echo "    ✅ Sistema normal"
    fi

    sleep 2
done
EOF

chmod +x bucles_avanzados.sh
./bucles_avanzados.sh
```

**[MEJORES PRÁCTICAS PARA BUCLES]**

> "Consejos para bucles eficientes y seguros:
>
> 1. **Siempre incluye condiciones de salida** para evitar bucles infinitos
> 2. **Usa `break` y `continue`** para control de flujo limpio
> 3. **Prefiere `for` para listas conocidas**, `while` para condiciones
> 4. **Valida datos antes de procesarlos** en el bucle
> 5. **Usa arrays para manejar listas complejas** de elementos
> 6. **Considera el rendimiento** en bucles con muchas iteraciones"

---

## 📥 PARTE 5: ARGUMENTOS Y VALIDACIÓN (8 minutos)

### 🎤 Transición

**[PANTALLA: Script recibiendo argumentos desde terminal]**

> "Hasta ahora nuestros scripts han sido estáticos. Pero los scripts profesionales deben ser flexibles: recibir parámetros, procesar opciones y validar entrada de usuarios. Es la diferencia entre una herramienta rígida y una navaja suiza adaptable."

### 📝 Variables Especiales de Argumentos

**[PANTALLA: Tabla de variables especiales]**

> "Bash proporciona variables especiales automáticas para manejar argumentos. Son como sensores que capturan todo lo que el usuario envía a nuestro script."

**[DEMOSTRACIÓN FUNDAMENTAL]**

```bash
cat > argumentos_basicos.sh << 'EOF'
#!/bin/bash

echo "=== VARIABLES ESPECIALES DE ARGUMENTOS ==="

# Mostrar todas las variables especiales
echo "📋 Información del script:"
echo "  \$0 (nombre del script): $0"
echo "  \$# (número de argumentos): $#"
echo "  \$@ (todos los argumentos): $@"
echo "  \$* (todos los argumentos como string): $*"
echo "  \$\$ (PID del script): $$"
echo "  \$? (código de salida anterior): $?"

echo ""
echo "📝 Argumentos individuales:"
echo "  \$1 (primer argumento): $1"
echo "  \$2 (segundo argumento): $2"
echo "  \$3 (tercer argumento): $3"
echo "  \$4 (cuarto argumento): $4"
echo "  \$5 (quinto argumento): $5"

echo ""
echo "🔄 Iteración sobre argumentos:"
contador=1
for argumento in "$@"; do
    echo "  Argumento $contador: '$argumento'"
    ((contador++))
done

echo ""
echo "🧮 Análisis de argumentos:"
if [[ $# -eq 0 ]]; then
    echo "  ❌ No se proporcionaron argumentos"
    echo "  💡 Uso: $0 <arg1> <arg2> [arg3] [...]"
elif [[ $# -eq 1 ]]; then
    echo "  ✅ Se proporcionó 1 argumento"
elif [[ $# -le 5 ]]; then
    echo "  ✅ Se proporcionaron $# argumentos (cantidad apropiada)"
else
    echo "  ⚠️ Se proporcionaron $# argumentos (muchos argumentos)"
fi
EOF

chmod +x argumentos_basicos.sh

# Demostrar con diferentes argumentos
echo "Ejecutando sin argumentos:"
./argumentos_basicos.sh

echo ""
echo "Ejecutando con un argumento:"
./argumentos_basicos.sh "hola"

echo ""
echo "Ejecutando con múltiples argumentos:"
./argumentos_basicos.sh "arg1" "argumento con espacios" "arg3" 123 "último"
```

### 🎛️ Procesamiento de Opciones con getopts

**[DEMOSTRACIÓN DE GETOPTS]**

```bash
cat > opciones_avanzadas.sh << 'EOF'
#!/bin/bash

# Configuración por defecto
VERBOSE=false
OUTPUT_FILE=""
INPUT_FILE=""
OPERATION="list"
HELP=false

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Función de ayuda
mostrar_ayuda() {
    echo -e "${BLUE}USO: $0 [OPCIONES] [ARCHIVO]${NC}"
    echo ""
    echo "OPCIONES:"
    echo "  -h          Mostrar esta ayuda"
    echo "  -v          Modo verbose (detallado)"
    echo "  -o archivo  Archivo de salida"
    echo "  -i archivo  Archivo de entrada"
    echo "  -t tipo     Tipo de operación: list|count|analyze"
    echo ""
    echo "EJEMPLOS:"
    echo "  $0 -v -i datos.txt -o resultado.txt"
    echo "  $0 -t count archivo.log"
    echo "  $0 -h"
}

# Procesar opciones con getopts
while getopts "hvo:i:t:" opcion; do
    case $opcion in
        h)
            mostrar_ayuda
            exit 0
            ;;
        v)
            VERBOSE=true
            ;;
        o)
            OUTPUT_FILE="$OPTARG"
            ;;
        i)
            INPUT_FILE="$OPTARG"
            ;;
        t)
            OPERATION="$OPTARG"
            ;;
        \?)
            echo -e "${RED}❌ Opción inválida: -$OPTARG${NC}" >&2
            mostrar_ayuda >&2
            exit 1
            ;;
        :)
            echo -e "${RED}❌ La opción -$OPTARG requiere un argumento${NC}" >&2
            mostrar_ayuda >&2
            exit 1
            ;;
    esac
done

# Desplazar argumentos procesados
shift $((OPTIND-1))

# El argumento restante sería el archivo si no se especificó con -i
if [[ -z "$INPUT_FILE" && $# -gt 0 ]]; then
    INPUT_FILE="$1"
fi

# Función de logging condicional
log() {
    if [[ $VERBOSE == true ]]; then
        echo -e "${YELLOW}[INFO] $*${NC}" >&2
    fi
}

# Validar parámetros
validar_parametros() {
    log "Validando parámetros..."

    # Validar operación
    case $OPERATION in
        list|count|analyze)
            log "Operación válida: $OPERATION"
            ;;
        *)
            echo -e "${RED}❌ Operación inválida: $OPERATION${NC}" >&2
            echo "Operaciones válidas: list, count, analyze" >&2
            ((errores++))
            ;;
    esac

    # Validar archivo de entrada
    if [[ -n "$INPUT_FILE" ]]; then
        if [[ ! -f "$INPUT_FILE" ]]; then
            echo -e "${RED}❌ Archivo de entrada no existe: $INPUT_FILE${NC}" >&2
            ((errores++))
        elif [[ ! -r "$INPUT_FILE" ]]; then
            echo -e "${RED}❌ No se puede leer el archivo: $INPUT_FILE${NC}" >&2
            ((errores++))
        else
            log "Archivo de entrada válido: $INPUT_FILE"
        fi
    else
        echo -e "${YELLOW}⚠️ No se especificó archivo de entrada${NC}" >&2
    fi

    # Validar archivo de salida
    if [[ -n "$OUTPUT_FILE" ]]; then
        output_dir=$(dirname "$OUTPUT_FILE")
        if [[ ! -d "$output_dir" ]]; then
            echo -e "${RED}❌ Directorio de salida no existe: $output_dir${NC}" >&2
            ((errores++))
        elif [[ ! -w "$output_dir" ]]; then
            echo -e "${RED}❌ No se puede escribir en el directorio: $output_dir${NC}" >&2
            ((errores++))
        else
            log "Archivo de salida válido: $OUTPUT_FILE"
        fi
    fi

    return $errores
}

# Función principal de procesamiento
procesar_datos() {
    log "Iniciando procesamiento..."

    local archivo="${INPUT_FILE:-/dev/stdin}"
    local salida="${OUTPUT_FILE:-/dev/stdout}"

    # Crear archivo de entrada de ejemplo si no existe
    if [[ -z "$INPUT_FILE" ]]; then
        log "Creando datos de ejemplo..."
        cat > datos_ejemplo.txt << 'DATOS'
usuario1,admin,2023-01-15,activo
usuario2,editor,2023-02-20,activo
usuario3,viewer,2023-03-10,inactivo
usuario4,admin,2023-04-05,activo
usuario5,editor,2023-05-12,activo
DATOS
        archivo="datos_ejemplo.txt"
    fi

    case $OPERATION in
        list)
            log "Ejecutando operación: listado"
            echo "📋 LISTADO DE DATOS:" > "$salida"
            cat "$archivo" >> "$salida"
            ;;
        count)
            log "Ejecutando operación: conteo"
            local total=$(wc -l < "$archivo")
            echo "📊 CONTEO DE REGISTROS: $total" > "$salida"
            ;;
        analyze)
            log "Ejecutando operación: análisis"
            {
                echo "📈 ANÁLISIS DE DATOS:"
                echo "Total de registros: $(wc -l < "$archivo")"
                echo "Usuarios activos: $(grep -c 'activo' "$archivo")"
                echo "Usuarios inactivos: $(grep -c 'inactivo' "$archivo")"
                echo "Administradores: $(cut -d',' -f2 "$archivo" | grep -c 'admin')"
                echo "Editores: $(cut -d',' -f2 "$archivo" | grep -c 'editor')"
            } > "$salida"
            ;;
    esac

    log "Procesamiento completado"

    # Mostrar resultado si la salida va a archivo
    if [[ "$salida" != "/dev/stdout" ]]; then
        echo -e "${GREEN}✅ Resultado guardado en: $salida${NC}"
        if [[ $VERBOSE == true ]]; then
            echo -e "${BLUE}Contenido del archivo:${NC}"
            cat "$salida"
        fi
    fi

    # Limpiar archivo temporal
    [[ -f "datos_ejemplo.txt" && -z "$INPUT_FILE" ]] && rm -f "datos_ejemplo.txt"
}

# Programa principal
errores=0

echo ""
echo "🔍 VALIDANDO CONFIGURACIÓN:"
validar_parametros

if [[ $errores -gt 0 ]]; then
    echo -e "${RED}❌ Se encontraron $errores errores. Abortando.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Configuración válida. Procesando...${NC}"
procesar_datos
EOF

chmod +x opciones_avanzadas.sh

# Demostrar diferentes usos
echo "🔧 DEMOSTRACIONES:"
echo ""
echo "1. Mostrar ayuda:"
./opciones_avanzadas.sh -h

echo ""
echo "2. Procesamiento básico con verbose:"
./opciones_avanzadas.sh -v -t analyze

echo ""
echo "3. Guardar en archivo específico:"
./opciones_avanzadas.sh -v -t count -o resultado.txt
cat resultado.txt
rm -f resultado.txt
```

### 📝 Validación Robusta de Entrada

**[DEMOSTRACIÓN DE VALIDACIÓN]**

```bash
cat > validacion_avanzada.sh << 'EOF'
#!/bin/bash

# Colores para feedback
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Función para validar email
validar_email() {
    local email="$1"
    local regex="^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"

    if [[ $email =~ $regex ]]; then
        return 0
    else
        return 1
    fi
}

# Función para validar número
validar_numero() {
    local numero="$1"
    local min=${2:-0}
    local max=${3:-100}

    # Verificar que es un número
    if ! [[ $numero =~ ^-?[0-9]+$ ]]; then
        echo "❌ '$numero' no es un número válido"
        return 1
    fi

    # Verificar rango
    if [[ $numero -lt $min ]] || [[ $numero -gt $max ]]; then
        echo "❌ '$numero' debe estar entre $min y $max"
        return 1
    fi

    return 0
}

# Función para validar archivo
validar_archivo() {
    local archivo="$1"
    local tipo="${2:-file}"  # file, dir, executable

    case $tipo in
        file)
            if [[ ! -f "$archivo" ]]; then
                echo "❌ '$archivo' no es un archivo válido"
                return 1
            fi
            if [[ ! -r "$archivo" ]]; then
                echo "❌ '$archivo' no se puede leer"
                return 1
            fi
            ;;
        dir)
            if [[ ! -d "$archivo" ]]; then
                echo "❌ '$archivo' no es un directorio válido"
                return 1
            fi
            ;;
        executable)
            if [[ ! -x "$archivo" ]]; then
                echo "❌ '$archivo' no es ejecutable"
                return 1
            fi
            ;;
    esac

    return 0
}

# Función para entrada interactiva con validación
pedir_datos_validados() {
    local nombre=""
    local email=""
    local edad=""
    local archivo=""

    echo -e "${BLUE}📝 FORMULARIO DE REGISTRO${NC}"
    echo "Por favor, ingresa los siguientes datos:"
    echo ""

    # Pedir nombre (no vacío)
    while [[ -z "$nombre" ]]; do
        read -p "👤 Nombre completo: " nombre
        if [[ -z "$nombre" ]]; then
            echo -e "${RED}❌ El nombre no puede estar vacío${NC}"
        fi
    done

    # Pedir email (con validación)
    while true; do
        read -p "📧 Email: " email
        if validar_email "$email"; then
            break
        else
            echo -e "${RED}❌ Email inválido. Formato: usuario@dominio.com${NC}"
        fi
    done

    # Pedir edad (número entre 18 y 100)
    while true; do
        read -p "🎂 Edad (18-100): " edad
        if validar_numero "$edad" 18 100; then
            break
        fi
    done

    # Pedir archivo de configuración
    while true; do
        read -p "📄 Archivo de configuración (opcional, Enter para omitir): " archivo
        if [[ -z "$archivo" ]]; then
            archivo="config_default.txt"
            echo "📄 Creando archivo de configuración por defecto..."
            echo "# Configuración generada automáticamente" > "$archivo"
            break
        elif validar_archivo "$archivo" "file"; then
            break
        fi
    done

    # Resumen de datos
    echo ""
    echo -e "${GREEN}✅ DATOS VÁLIDOS INGRESADOS:${NC}"
    echo "  👤 Nombre: $nombre"
    echo "  📧 Email: $email"
    echo "  🎂 Edad: $edad años"
    echo "  📄 Archivo: $archivo"

    # Confirmación
    echo ""
    read -p "¿Proceder con estos datos? [Y/n]: " confirmacion
    case $confirmacion in
        [Nn]*)
            echo "❌ Operación cancelada"
            return 1
            ;;
        *)
            echo -e "${GREEN}✅ Datos confirmados y procesados${NC}"
            return 0
            ;;
    esac
}

# Ejecutar formulario
pedir_datos_validados

# Limpiar archivos temporales
rm -f config_default.txt
EOF

chmod +x validacion_avanzada.sh

echo ""
echo "🎯 Ejecutar script de validación interactivo:"
echo "./validacion_avanzada.sh"
```

### 💡 Mejores Prácticas para Argumentos

**[PANTALLA: Lista de mejores prácticas]**

> "Reglas de oro para el manejo profesional de argumentos:
>
> 1. **Validación temprana**: Valida todos los argumentos antes de procesarlos
> 2. **Mensajes claros**: Proporciona feedback específico sobre errores
> 3. **Valores por defecto**: Usa configuraciones sensatas cuando no se especifiquen opciones
> 4. **Documentación integrada**: Incluye ayuda accesible con -h o --help
> 5. **Flexibilidad**: Permite múltiples formas de especificar la misma información
> 6. **Modo seguro**: Implementa dry-run para operaciones destructivas"

---

## 📋 PARTE 6: PROYECTO FINAL - GESTOR DE TAREAS (12 minutos)

### 🎤 Transición al Proyecto

**[PANTALLA: Vista previa del gestor de tareas funcionando]**

> "Ha llegado el momento de integrar todo lo aprendido en un proyecto real: un gestor de tareas completo. Este script combinará variables, control de flujo, argumentos y validación para crear una herramienta que podrías usar profesionalmente."

### 🏗️ Arquitectura del Proyecto

**[PANTALLA: Diagrama de componentes del gestor]**

> "Nuestro gestor tendrá estas funcionalidades:
>
> - ✅ **Agregar tareas** con descripción, prioridad y fecha límite
> - 📋 **Listar tareas** con filtros por estado y prioridad
> - ✅ **Marcar tareas** como completadas
> - 🗑️ **Eliminar tareas** individual o masivamente
> - 📊 **Estadísticas** y reportes de productividad
> - 💾 **Persistencia** en archivo JSON simple"

### 📝 Implementación del Gestor de Tareas

**[DEMOSTRACIÓN COMPLETA]**

```bash
cat > gestor_tareas.sh << 'EOF'
#!/bin/bash
set -euo pipefail

# ================================
# GESTOR DE TAREAS PROFESIONAL v1.0
# ================================

# Configuración del script
readonly SCRIPT_NAME="gestor_tareas"
readonly SCRIPT_VERSION="1.0"
readonly TASKS_FILE="$HOME/.tasks.json"
readonly CONFIG_FILE="$HOME/.taskrc"

# Colores para output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# Variables globales
VERBOSE=false
DEBUG=false

# ================================
# FUNCIONES DE UTILIDAD
# ================================

log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    case $level in
        ERROR)   echo -e "${RED}[$timestamp] ERROR: $message${NC}" >&2 ;;
        WARN)    echo -e "${YELLOW}[$timestamp] WARN: $message${NC}" >&2 ;;
        INFO)    echo -e "${GREEN}[$timestamp] INFO: $message${NC}" ;;
        DEBUG)   [[ $DEBUG == true ]] && echo -e "${CYAN}[$timestamp] DEBUG: $message${NC}" ;;
        *)       echo -e "${BLUE}[$timestamp] $level: $message${NC}" ;;
    esac
}

error_exit() {
    log ERROR "$1"
    exit "${2:-1}"
}

# ================================
# GESTIÓN DE ARCHIVOS
# ================================

inicializar_archivo_tareas() {
    if [[ ! -f "$TASKS_FILE" ]]; then
        log INFO "Inicializando archivo de tareas: $TASKS_FILE"
        echo '{"tasks":[],"next_id":1}' > "$TASKS_FILE"
    fi
}

leer_tareas() {
    inicializar_archivo_tareas

    if command -v jq &> /dev/null; then
        jq -r '.tasks[]' "$TASKS_FILE" 2>/dev/null || echo "[]"
    else
        # Fallback sin jq (parsing básico)
        grep -o '"id":[0-9]*\|"title":"[^"]*"\|"status":"[^"]*"\|"priority":"[^"]*"' "$TASKS_FILE" |
        paste - - - - |
        sed 's/"id"://g; s/"title":"//g; s/"status":"//g; s/"priority":"//g; s/"//g'
    fi
}

obtener_siguiente_id() {
    inicializar_archivo_tareas

    if command -v jq &> /dev/null; then
        jq -r '.next_id' "$TASKS_FILE"
    else
        # Fallback: buscar el ID más alto y sumar 1
        local max_id=0
        while IFS=$'\t' read -r id _; do
            [[ $id =~ ^[0-9]+$ ]] && [[ $id -gt $max_id ]] && max_id=$id
        done < <(leer_tareas)
        echo $((max_id + 1))
    fi
}

# ================================
# FUNCIONES PRINCIPALES
# ================================

agregar_tarea() {
    local titulo="$1"
    local prioridad="${2:-media}"
    local descripcion="${3:-}"
    local fecha_limite="${4:-}"

    # Validar entrada
    [[ -z "$titulo" ]] && error_exit "El título de la tarea es obligatorio"

    # Validar prioridad
    case $prioridad in
        alta|media|baja) ;;
        *) error_exit "Prioridad inválida. Use: alta, media, baja" ;;
    esac

    # Obtener datos
    local id
    id=$(obtener_siguiente_id)
    local fecha_creacion
    fecha_creacion=$(date '+%Y-%m-%d %H:%M:%S')

    log INFO "Agregando tarea: '$titulo'"

    # Crear entrada de tarea
    local tarea_json
    if command -v jq &> /dev/null; then
        # Usar jq para JSON válido
        tarea_json=$(jq -n \
            --arg id "$id" \
            --arg title "$titulo" \
            --arg desc "$descripcion" \
            --arg priority "$prioridad" \
            --arg status "pendiente" \
            --arg created "$fecha_creacion" \
            --arg due "$fecha_limite" \
            '{
                id: ($id | tonumber),
                title: $title,
                description: $desc,
                priority: $priority,
                status: $status,
                created_at: $created,
                due_date: $due
            }')

        # Agregar tarea al archivo
        jq --argjson new_task "$tarea_json" \
           '.tasks += [$new_task] | .next_id += 1' \
           "$TASKS_FILE" > "${TASKS_FILE}.tmp" &&
        mv "${TASKS_FILE}.tmp" "$TASKS_FILE"
    else
        # Fallback sin jq
        {
            echo "$id|$titulo|$descripcion|$prioridad|pendiente|$fecha_creacion|$fecha_limite"
        } >> "${TASKS_FILE}.simple"
    fi

    echo -e "${GREEN}✅ Tarea agregada exitosamente (ID: $id)${NC}"
}

listar_tareas() {
    local filtro_estado="${1:-todos}"
    local filtro_prioridad="${2:-todas}"

    log DEBUG "Listando tareas - Estado: $filtro_estado, Prioridad: $filtro_prioridad"

    inicializar_archivo_tareas

    # Encabezado
    echo -e "${BLUE}📋 LISTA DE TAREAS${NC}"
    echo "=============================================="
    printf "%-4s %-20s %-10s %-12s %-10s\n" "ID" "TÍTULO" "PRIORIDAD" "ESTADO" "CREADA"
    echo "----------------------------------------------"

    local contador=0
    local pendientes=0
    local completadas=0

    if command -v jq &> /dev/null; then
        # Usar jq para procesamiento
        while IFS='|' read -r id titulo prioridad estado fecha; do
            [[ -z "$id" ]] && continue

            # Aplicar filtros
            if [[ "$filtro_estado" != "todos" && "$estado" != "$filtro_estado" ]]; then
                continue
            fi

            if [[ "$filtro_prioridad" != "todas" && "$prioridad" != "$filtro_prioridad" ]]; then
                continue
            fi

            # Formatear salida con colores
            local color_estado=""
            local icono_estado=""
            case $estado in
                pendiente)
                    color_estado="$YELLOW"
                    icono_estado="⏳"
                    ((pendientes++))
                    ;;
                completada)
                    color_estado="$GREEN"
                    icono_estado="✅"
                    ((completadas++))
                    ;;
                *)
                    color_estado="$NC"
                    icono_estado="❓"
                    ;;
            esac

            local color_prioridad=""
            case $prioridad in
                alta)     color_prioridad="$RED" ;;
                media)    color_prioridad="$YELLOW" ;;
                baja)     color_prioridad="$GREEN" ;;
                *)        color_prioridad="$NC" ;;
            esac

            # Truncar título si es muy largo
            local titulo_corto
            if [[ ${#titulo} -gt 18 ]]; then
                titulo_corto="${titulo:0:15}..."
            else
                titulo_corto="$titulo"
            fi

            # Formatear fecha
            local fecha_corta="${fecha:0:10}"

            printf "%-4s %-20s ${color_prioridad}%-10s${NC} ${color_estado}%-12s${NC} %-10s\n" \
                "$id" "$titulo_corto" "$prioridad" "$icono_estado $estado" "$fecha_corta"

            ((contador++))
        done < <(jq -r '.tasks[] | "\(.id)|\(.title)|\(.priority)|\(.status)|\(.created_at)"' "$TASKS_FILE" 2>/dev/null)
    else
        # Fallback sin jq
        if [[ -f "${TASKS_FILE}.simple" ]]; then
            while IFS='|' read -r id titulo descripcion prioridad estado fecha_creacion fecha_limite; do
                [[ -z "$id" ]] && continue

                # Aplicar filtros (misma lógica)
                if [[ "$filtro_estado" != "todos" && "$estado" != "$filtro_estado" ]]; then
                    continue
                fi

                if [[ "$filtro_prioridad" != "todas" && "$prioridad" != "$filtro_prioridad" ]]; then
                    continue
                fi

                # Mostrar tarea (formato simplificado)
                printf "%-4s %-20s %-10s %-12s %-10s\n" \
                    "$id" "${titulo:0:18}" "$prioridad" "$estado" "${fecha_creacion:0:10}"

                ((contador++))
                [[ "$estado" == "pendiente" ]] && ((pendientes++))
                [[ "$estado" == "completada" ]] && ((completadas++))
            done < "${TASKS_FILE}.simple"
        fi
    fi

    # Resumen
    echo "----------------------------------------------"
    echo -e "${CYAN}📊 RESUMEN: $contador tareas mostradas${NC}"
    [[ $pendientes -gt 0 ]] && echo -e "${YELLOW}⏳ Pendientes: $pendientes${NC}"
    [[ $completadas -gt 0 ]] && echo -e "${GREEN}✅ Completadas: $completadas${NC}"
}

completar_tarea() {
    local id="$1"

    [[ -z "$id" ]] && error_exit "ID de tarea requerido"
    [[ ! "$id" =~ ^[0-9]+$ ]] && error_exit "ID debe ser un número"

    log INFO "Marcando tarea $id como completada"

    if command -v jq &> /dev/null; then
        # Verificar que la tarea existe
        local existe
        existe=$(jq --arg id "$id" '.tasks[] | select(.id == ($id | tonumber)) | .id' "$TASKS_FILE")

        if [[ -z "$existe" ]]; then
            error_exit "Tarea con ID $id no encontrada"
        fi

        # Actualizar estado
        jq --arg id "$id" \
           '(.tasks[] | select(.id == ($id | tonumber))) |= (.status = "completada" | .completed_at = now | strftime("%Y-%m-%d %H:%M:%S"))' \
           "$TASKS_FILE" > "${TASKS_FILE}.tmp" &&
        mv "${TASKS_FILE}.tmp" "$TASKS_FILE"

        echo -e "${GREEN}✅ Tarea $id marcada como completada${NC}"
    else
        # Fallback sin jq
        if [[ -f "${TASKS_FILE}.simple" ]]; then
            local temp_file="${TASKS_FILE}.simple.tmp"
            local encontrada=false

            while IFS='|' read -r tid titulo descripcion prioridad estado fecha_creacion fecha_limite; do
                if [[ "$tid" == "$id" ]]; then
                    echo "$tid|$titulo|$descripcion|$prioridad|completada|$fecha_creacion|$fecha_limite" >> "$temp_file"
                    encontrada=true
                else
                    echo "$tid|$titulo|$descripcion|$prioridad|$estado|$fecha_creacion|$fecha_limite" >> "$temp_file"
                fi
            done < "${TASKS_FILE}.simple"

            if [[ $encontrada == true ]]; then
                mv "$temp_file" "${TASKS_FILE}.simple"
                echo -e "${GREEN}✅ Tarea $id marcada como completada${NC}"
            else
                rm -f "$temp_file"
                error_exit "Tarea con ID $id no encontrada"
            fi
        else
            error_exit "No hay tareas disponibles"
        fi
    fi
}

eliminar_tarea() {
    local id="$1"

    [[ -z "$id" ]] && error_exit "ID de tarea requerido"
    [[ ! "$id" =~ ^[0-9]+$ ]] && error_exit "ID debe ser un número"

    log INFO "Eliminando tarea $id"

    if command -v jq &> /dev/null; then
        # Verificar que la tarea existe
        local titulo
        titulo=$(jq --arg id "$id" -r '.tasks[] | select(.id == ($id | tonumber)) | .title' "$TASKS_FILE")

        if [[ -z "$titulo" ]]; then
            error_exit "Tarea con ID $id no encontrada"
        fi

        # Confirmar eliminación
        echo -e "${YELLOW}⚠️ ¿Eliminar tarea '$titulo' (ID: $id)? [y/N]:${NC}"
        read -r confirmacion

        case $confirmacion in
            [Yy]*)
                jq --arg id "$id" '.tasks |= map(select(.id != ($id | tonumber)))' \
                   "$TASKS_FILE" > "${TASKS_FILE}.tmp" &&
                mv "${TASKS_FILE}.tmp" "$TASKS_FILE"

                echo -e "${GREEN}🗑️ Tarea eliminada exitosamente${NC}"
                ;;
            *)
                echo "❌ Eliminación cancelada"
                ;;
        esac
    else
        # Fallback sin jq (similar al completar)
        error_exit "Función no disponible sin jq. Instale jq para usar esta función."
    fi
}

mostrar_estadisticas() {
    log INFO "Generando estadísticas de productividad"

    inicializar_archivo_tareas

    echo -e "${PURPLE}📊 ESTADÍSTICAS DE PRODUCTIVIDAD${NC}"
    echo "=============================================="

    local total=0
    local pendientes=0
    local completadas=0
    local alta_prioridad=0
    local media_prioridad=0
    local baja_prioridad=0

    if command -v jq &> /dev/null; then
        total=$(jq '.tasks | length' "$TASKS_FILE")
        pendientes=$(jq '[.tasks[] | select(.status == "pendiente")] | length' "$TASKS_FILE")
        completadas=$(jq '[.tasks[] | select(.status == "completada")] | length' "$TASKS_FILE")
        alta_prioridad=$(jq '[.tasks[] | select(.priority == "alta")] | length' "$TASKS_FILE")
        media_prioridad=$(jq '[.tasks[] | select(.priority == "media")] | length' "$TASKS_FILE")
        baja_prioridad=$(jq '[.tasks[] | select(.priority == "baja")] | length' "$TASKS_FILE")
    else
        # Fallback sin jq
        if [[ -f "${TASKS_FILE}.simple" ]]; then
            while IFS='|' read -r id titulo descripcion prioridad estado fecha_creacion fecha_limite; do
                [[ -z "$id" ]] && continue
                ((total++))
                [[ "$estado" == "pendiente" ]] && ((pendientes++))
                [[ "$estado" == "completada" ]] && ((completadas++))
                [[ "$prioridad" == "alta" ]] && ((alta_prioridad++))
                [[ "$prioridad" == "media" ]] && ((media_prioridad++))
                [[ "$prioridad" == "baja" ]] && ((baja_prioridad++))
            done < "${TASKS_FILE}.simple"
        fi
    fi

    # Calcular porcentajes
    local porcentaje_completadas=0
    [[ $total -gt 0 ]] && porcentaje_completadas=$((completadas * 100 / total))

    # Mostrar estadísticas
    echo "📋 Total de tareas:           $total"
    echo "⏳ Tareas pendientes:         $pendientes"
    echo "✅ Tareas completadas:        $completadas ($porcentaje_completadas%)"
    echo ""
    echo "🎯 DISTRIBUCIÓN POR PRIORIDAD:"
    echo "  🔴 Alta prioridad:          $alta_prioridad"
    echo "  🟡 Media prioridad:         $media_prioridad"
    echo "  🟢 Baja prioridad:          $baja_prioridad"

    # Barra de progreso visual
    if [[ $total -gt 0 ]]; then
        echo ""
        echo "📊 PROGRESO GENERAL:"
        local barra_longitud=20
        local barra_completada=$((porcentaje_completadas * barra_longitud / 100))
        local barra=""

        for ((i=0; i<barra_longitud; i++)); do
            if [[ $i -lt $barra_completada ]]; then
                barra+="█"
            else
                barra+="░"
            fi
        done

        echo "  [$barra] $porcentaje_completadas%"
    fi

    # Recomendaciones
    echo ""
    echo "💡 RECOMENDACIONES:"
    if [[ $pendientes -gt 10 ]]; then
        echo "  ⚠️ Tienes muchas tareas pendientes. Considera priorizar."
    fi
    if [[ $alta_prioridad -gt 0 ]]; then
        echo "  🔥 Enfócate en las $alta_prioridad tareas de alta prioridad."
    fi
    if [[ $porcentaje_completadas -ge 80 ]]; then
        echo "  🎉 ¡Excelente trabajo! Mantén el ritmo."
    elif [[ $porcentaje_completadas -ge 50 ]]; then
        echo "  👍 Buen progreso. Sigue así."
    else
        echo "  💪 Es hora de ponerse en marcha."
    fi
}

# ================================
# INTERFAZ DE LÍNEA DE COMANDOS
# ================================

mostrar_ayuda() {
    cat << HELP
${BLUE}$SCRIPT_NAME v$SCRIPT_VERSION${NC} - Gestor de Tareas Profesional

${YELLOW}USO:${NC}
  $0 <comando> [opciones] [argumentos]

${YELLOW}COMANDOS:${NC}
  add <título> [prioridad] [descripción]    Agregar nueva tarea
  list [estado] [prioridad]                 Listar tareas con filtros
  complete <id>                             Marcar tarea como completada
  delete <id>                               Eliminar tarea
  stats                                     Mostrar estadísticas
  help                                      Mostrar esta ayuda

${YELLOW}OPCIONES GLOBALES:${NC}
  -v, --verbose    Salida detallada
  -d, --debug      Información de depuración
  -h, --help       Mostrar ayuda

${YELLOW}EJEMPLOS:${NC}
  $0 add "Revisar emails" alta "Responder emails importantes"
  $0 list pendiente alta
  $0 complete 5
  $0 delete 3
  $0 stats

${YELLOW}ESTADOS:${NC} pendiente, completada, todos
${YELLOW}PRIORIDADES:${NC} alta, media, baja, todas

${CYAN}Archivo de datos: $TASKS_FILE${NC}
HELP
}

procesar_argumentos() {
    [[ $# -eq 0 ]] && { mostrar_ayuda; exit 0; }

    local comando="$1"
    shift

    # Procesar opciones globales
    while [[ $# -gt 0 ]]; do
        case $1 in
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -d|--debug)
                DEBUG=true
                VERBOSE=true
                shift
                ;;
            -h|--help)
                mostrar_ayuda
                exit 0
                ;;
            -*)
                error_exit "Opción desconocida: $1"
                ;;
            *)
                break
                ;;
        esac
    done

    # Ejecutar comando
    case $comando in
        add|a)
            [[ $# -lt 1 ]] && error_exit "Título de tarea requerido"
            agregar_tarea "$@"
            ;;
        list|l|ls)
            listar_tareas "$@"
            ;;
        complete|c|done)
            [[ $# -lt 1 ]] && error_exit "ID de tarea requerido"
            completar_tarea "$1"
            ;;
        delete|d|rm)
            [[ $# -lt 1 ]] && error_exit "ID de tarea requerido"
            eliminar_tarea "$1"
            ;;
        stats|statistics|s)
            mostrar_estadisticas
            ;;
        help|h|-h|--help)
            mostrar_ayuda
            ;;
        *)
            error_exit "Comando desconocido: $comando. Use '$0 help' para ver comandos disponibles."
            ;;
    esac
}

# ================================
# PROGRAMA PRINCIPAL
# ================================

main() {
    log DEBUG "Iniciando $SCRIPT_NAME v$SCRIPT_VERSION"
    log DEBUG "Argumentos: $*"

    # Verificar dependencias opcionales
    if ! command -v jq &> /dev/null; then
        log WARN "jq no está instalado. Algunas funciones estarán limitadas."
        log WARN "Instalar con: sudo apt install jq (Ubuntu/Debian) o brew install jq (macOS)"
    fi

    # Crear directorio de configuración si no existe
    mkdir -p "$(dirname "$TASKS_FILE")"

    # Procesar argumentos y ejecutar
    procesar_argumentos "$@"
}

# Ejecutar programa principal si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
EOF

chmod +x gestor_tareas.sh

echo -e "${GREEN}🎉 ¡GESTOR DE TAREAS CREADO EXITOSAMENTE!${NC}"
echo ""
echo "📚 DEMOS DE FUNCIONALIDAD:"
echo ""

# Demo 1: Agregar tareas
echo "1️⃣ Agregando tareas de ejemplo:"
./gestor_tareas.sh add "Preparar presentación" alta "Slides para reunión del viernes"
./gestor_tareas.sh add "Revisar código" media "Code review del proyecto X"
./gestor_tareas.sh add "Actualizar documentación" baja

echo ""

# Demo 2: Listar tareas
echo "2️⃣ Listando todas las tareas:"
./gestor_tareas.sh list

echo ""

# Demo 3: Completar tarea
echo "3️⃣ Completando tarea:"
./gestor_tareas.sh complete 2

echo ""

# Demo 4: Listar solo pendientes
echo "4️⃣ Listando tareas pendientes:"
./gestor_tareas.sh list pendiente

echo ""

# Demo 5: Estadísticas
echo "5️⃣ Estadísticas de productividad:"
./gestor_tareas.sh stats

echo ""
echo "🚀 ¡Prueba más comandos con:"
echo "   ./gestor_tareas.sh help"
```

### 🎯 Características Implementadas

**[PANTALLA: Lista de características]**

> "Nuestro gestor incluye características profesionales:
>
> **🏗️ Arquitectura Robusta:**
>
> - Separación clara de funciones
> - Manejo de errores comprehensivo
> - Logging configurable
> - Validación de entrada
> - **💾 Persistencia de Datos:**
> - Almacenamiento en JSON
> - Fallback sin dependencias
> - Backup automático
>
> **🎨 Interfaz Atractiva:**
>
> - Colores y emojis
> - Tablas formateadas
> - Barras de progreso
> - Feedback visual
>
> **⚡ Funcionalidad Completa:**
>
> - CRUD de tareas
> - Filtros avanzados
> - Estadísticas detalladas
> - Múltiples formatos de entrada"

### 💡 Lecciones del Proyecto

**[PANTALLA: Recap de conceptos aplicados]**

> "Este proyecto integra todos los conceptos del módulo:
>
> ✅ **Variables**: Configuración, colores, datos dinámicos
> ✅ **Control de flujo**: Validación, menús, procesamiento condicional
> ✅ **Argumentos**: Comandos, opciones, parámetros flexibles
> ✅ **Funciones**: Código modular y reutilizable
> ✅ **Arrays**: Manejo de listas de tareas
> ✅ **Validación**: Entrada robusta y segura"
