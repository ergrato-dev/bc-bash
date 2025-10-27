#!/bin/bash
# Ejercicio 04: Case Statement - Menús y Decisiones Múltiples
# Módulo: 3 | Dificultad: Media
# Objetivo: Dominar case para decisiones múltiples de manera elegante

# ============================================================================
# INSTRUCCIONES
# ============================================================================
# case es perfecto cuando tienes múltiples condiciones basadas en un valor
# Es más legible y eficiente que múltiples if/elif cuando comparas un valor
#
# TAREAS:
# 1. Case básico con opciones simples
# 2. Case con patrones (wildcards)
# 3. Múltiples patrones por opción
# 4. Case con rangos
# 5. Menú interactivo con case
# 6. Validación de entrada
# 7. Case para extensiones de archivo
#
# CRITERIOS DE ÉXITO:
# ✓ Usar case en lugar de if/elif largos
# ✓ Aplicar pattern matching
# ✓ Combinar case con loops para menús

echo "🎯 Ejercicio 04: Case Statement"
echo "================================"
echo ""

# ============================================================================
# TAREA 1: Case básico - Días de la semana
# ============================================================================
echo "📋 TAREA 1: Identificar tipo de día"
echo "------------------------------------"

dia="lunes"

# TU CÓDIGO AQUÍ:
# case $dia in
#     lunes|martes|miércoles|jueves|viernes)
#         echo "Día laboral"
#         ;;
#     sábado|domingo)
#         echo "Fin de semana"
#         ;;
#     *)
#         echo "Día desconocido"
#         ;;
# esac


echo ""

# ============================================================================
# TAREA 2: Case con patrones - Validar comando
# ============================================================================
echo "📋 TAREA 2: Identificar tipo de comando"
echo "----------------------------------------"

comando="ls"

# TU CÓDIGO AQUÍ:
# case $comando in
#     ls|dir)
#         echo "Comando de listado"
#         ;;
#     cd|pushd|popd)
#         echo "Comando de navegación"
#         ;;
#     cp|mv|rm)
#         echo "Comando de manejo de archivos"
#         ;;
#     *)
#         echo "Otro comando"
#         ;;
# esac


echo ""

# ============================================================================
# TAREA 3: Case con wildcards - Extensiones de archivo
# ============================================================================
echo "📋 TAREA 3: Identificar tipo de archivo por extensión"
echo "------------------------------------------------------"

archivo="documento.pdf"

# TU CÓDIGO AQUÍ:
# case $archivo in
#     *.txt|*.md)
#         echo "Archivo de texto"
#         ;;
#     *.jpg|*.png|*.gif)
#         echo "Archivo de imagen"
#         ;;
#     *.pdf)
#         echo "Documento PDF"
#         ;;
#     *)
#         echo "Tipo desconocido"
#         ;;
# esac


echo ""

# ============================================================================
# TAREA 4: Case con rangos - Calificación
# ============================================================================
echo "📋 TAREA 4: Convertir nota numérica a letra"
echo "--------------------------------------------"

nota=85

# TU CÓDIGO AQUÍ:
# case $nota in
#     [9][0-9]|100)
#         echo "Calificación: A (Excelente)"
#         ;;
#     [8][0-9])
#         echo "Calificación: B (Muy bien)"
#         ;;
#     [7][0-9])
#         echo "Calificación: C (Bien)"
#         ;;
#     [6][0-9])
#         echo "Calificación: D (Suficiente)"
#         ;;
#     *)
#         echo "Calificación: F (Insuficiente)"
#         ;;
# esac


echo ""

# ============================================================================
# TAREA 5: Menú de calculadora simple
# ============================================================================
echo "📋 TAREA 5: Calculadora simple con case"
echo "----------------------------------------"

operacion="suma"
num1=10
num2=5

# TU CÓDIGO AQUÍ:
# case $operacion in
#     suma|+)
#         resultado=$((num1 + num2))
#         echo "$num1 + $num2 = $resultado"
#         ;;
#     resta|-)
#         resultado=$((num1 - num2))
#         echo "$num1 - $num2 = $resultado"
#         ;;
#     multiplicacion|*)
#         resultado=$((num1 * num2))
#         echo "$num1 * $num2 = $resultado"
#         ;;
#     division|/)
#         if [[ $num2 -ne 0 ]]; then
#             resultado=$((num1 / num2))
#             echo "$num1 / $num2 = $resultado"
#         else
#             echo "Error: División por cero"
#         fi
#         ;;
#     *)
#         echo "Operación no válida"
#         ;;
# esac


echo ""

# ============================================================================
# TAREA 6: Case con comandos - Sistema de gestión
# ============================================================================
echo "📋 TAREA 6: Sistema de gestión de servicios (simulado)"
echo "-------------------------------------------------------"

accion="start"
servicio="nginx"

# TU CÓDIGO AQUÍ:
# case $accion in
#     start|inicio)
#         echo "▶️  Iniciando servicio $servicio..."
#         ;;
#     stop|parar)
#         echo "⏹️  Deteniendo servicio $servicio..."
#         ;;
#     restart|reiniciar)
#         echo "🔄 Reiniciando servicio $servicio..."
#         ;;
#     status|estado)
#         echo "📊 Estado del servicio $servicio: activo"
#         ;;
#     *)
#         echo "❌ Acción desconocida: $accion"
#         echo "Acciones válidas: start, stop, restart, status"
#         ;;
# esac


echo ""

# ============================================================================
# TAREA 7: Validación de opciones con case
# ============================================================================
echo "📋 TAREA 7: Validar respuesta Sí/No"
echo "------------------------------------"

respuesta="si"

# TU CÓDIGO AQUÍ:
# case ${respuesta,,} in  # ${var,,} convierte a minúsculas
#     s|si|sí|y|yes)
#         echo "✅ Respuesta afirmativa"
#         ;;
#     n|no)
#         echo "❌ Respuesta negativa"
#         ;;
#     *)
#         echo "⚠️  Respuesta no válida"
#         ;;
# esac


echo ""

# ============================================================================
# TAREA 8: Menú interactivo completo (simulado)
# ============================================================================
echo "📋 TAREA 8: Menú principal de aplicación"
echo "-----------------------------------------"

echo "=== MENÚ PRINCIPAL ==="
echo "1) Ver información del sistema"
echo "2) Listar archivos"
echo "3) Mostrar fecha y hora"
echo "4) Ver usuarios conectados"
echo "5) Salir"
echo ""

opcion="1"  # Simular selección

# TU CÓDIGO AQUÍ:
# case $opcion in
#     1)
#         echo "📊 Información del sistema:"
#         echo "  OS: $(uname -s)"
#         echo "  Hostname: $(hostname)"
#         ;;
#     2)
#         echo "📁 Archivos en directorio actual:"
#         ls -lh | head -5
#         ;;
#     3)
#         echo "🕐 Fecha y hora: $(date '+%Y-%m-%d %H:%M:%S')"
#         ;;
#     4)
#         echo "👥 Usuarios conectados:"
#         who
#         ;;
#     5)
#         echo "👋 Saliendo..."
#         exit 0
#         ;;
#     *)
#         echo "❌ Opción inválida. Seleccione 1-5"
#         ;;
# esac


echo ""

# ============================================================================
# TAREA AVANZADA: Script de backup con opciones
# ============================================================================
echo "📋 TAREA AVANZADA: Script de backup"
echo "------------------------------------"

modo="completo"
destino="/tmp/backup"

# TU CÓDIGO AQUÍ:
# case $modo in
#     completo|full)
#         echo "🔄 Iniciando backup COMPLETO..."
#         echo "  → Destino: $destino"
#         echo "  → Incluyendo todos los archivos"
#         ;;
#     incremental|inc)
#         echo "📊 Iniciando backup INCREMENTAL..."
#         echo "  → Destino: $destino"
#         echo "  → Solo archivos modificados"
#         ;;
#     diferencial|diff)
#         echo "📈 Iniciando backup DIFERENCIAL..."
#         echo "  → Destino: $destino"
#         echo "  → Desde último backup completo"
#         ;;
#     *)
#         echo "❌ Modo de backup no válido: $modo"
#         echo "Modos disponibles: completo, incremental, diferencial"
#         exit 1
#         ;;
# esac


echo ""
echo "✅ Ejercicio completado!"


# ============================================================================
# SOLUCIÓN COMPLETA (descomenta para ver)
# ============================================================================

: '
# Ver soluciones en las secciones "TU CÓDIGO AQUÍ" de arriba
# Todas están comentadas y listas para descomentar
'

# ============================================================================
# EXPLICACIÓN DE CONCEPTOS
# ============================================================================

: '
📚 CONCEPTOS CLAVE:

1. SINTAXIS BÁSICA:
   case $variable in
       patrón1)
           comandos
           ;;
       patrón2)
           comandos
           ;;
       *)
           comandos_por_defecto
           ;;
   esac

2. PATRONES:
   literal       : Coincidencia exacta
   patrón1|patrón2 : OR (uno u otro)
   *.txt         : Wildcard (cualquier .txt)
   [abc]         : Cualquier carácter en el conjunto
   [0-9]         : Rango de caracteres
   *)            : Cualquier cosa (default/else)

3. TERMINADORES:
   ;;  : Rompe y sale del case (más común)
   ;&  : Continúa ejecutando siguiente bloque (fall-through)
   ;;&  : Continúa evaluando patrones

4. PATRONES COMUNES:
   
   # Múltiples valores
   case $dia in
       lun|mar|mie|jue|vie) echo "Laboral" ;;
       sab|dom) echo "Fin de semana" ;;
   esac
   
   # Wildcards
   case $archivo in
       *.txt) echo "Texto" ;;
       *.jpg|*.png) echo "Imagen" ;;
       *) echo "Otro" ;;
   esac
   
   # Rangos
   case $letra in
       [a-z]) echo "Minúscula" ;;
       [A-Z]) echo "Mayúscula" ;;
       [0-9]) echo "Número" ;;
   esac

5. CASE VS IF/ELIF:
   
   ✓ USA CASE cuando:
   - Comparas UNA variable con múltiples valores
   - Necesitas pattern matching
   - Quieres código más legible
   - Trabajas con menús
   
   ✓ USA IF/ELIF cuando:
   - Comparas DIFERENTES variables
   - Necesitas condiciones complejas (AND/OR)
   - Comparas rangos numéricos (< >)
   - Usas operadores de test (-f, -d, etc.)

6. EXPANSIONES ÚTILES:
   ${var,,}  : Convertir a minúsculas
   ${var^^}  : Convertir a mayúsculas
   
   case ${respuesta,,} in
       yes|y|si|s) echo "Sí" ;;
   esac

7. MENÚS CON CASE:
   
   while true; do
       echo "1) Opción 1"
       echo "2) Opción 2"
       echo "3) Salir"
       read -p "Selecciona: " opcion
       
       case $opcion in
           1) accion1 ;;
           2) accion2 ;;
           3) break ;;
           *) echo "Inválido" ;;
       esac
   done

8. VALIDACIÓN DE ENTRADA:
   
   # Validar formato
   case $email in
       *@*.*)
           echo "Email válido (formato básico)"
           ;;
       *)
           echo "Email inválido"
           ;;
   esac
   
   # Validar extensión
   case ${archivo##*.} in
       sh|bash)
           echo "Script de shell"
           ;;
       py)
           echo "Script de Python"
           ;;
   esac

9. BUENAS PRÁCTICAS:
   ✓ Siempre incluye caso default (*)
   ✓ Quote variables: case "$var" in
   ✓ Usa | para múltiples patrones similares
   ✓ Agrupa patrones relacionados
   ✓ Termina cada bloque con ;;
   ✓ Usa ${var,,} para comparaciones case-insensitive
   ✓ Mantén cases simples, usa funciones para lógica compleja

10. EJEMPLOS PRÁCTICOS:
    
    # Script de instalación
    case $OS in
        linux) apt-get install $package ;;
        darwin) brew install $package ;;
        *) echo "OS no soportado" ;;
    esac
    
    # Procesador de archivos
    case $archivo in
        *.tar.gz|*.tgz) tar xzf "$archivo" ;;
        *.zip) unzip "$archivo" ;;
        *.rar) unrar x "$archivo" ;;
    esac
    
    # Parser de argumentos
    case $1 in
        -h|--help) mostrar_ayuda ;;
        -v|--version) mostrar_version ;;
        -*) echo "Opción desconocida: $1" ;;
        *) archivo=$1 ;;
    esac

💡 TIPS:
    - case es más eficiente que múltiples if para muchos valores
    - Perfecto para menús y opciones de línea de comandos
    - Pattern matching es poderoso pero no tan flexible como regex
    - Para regex completo, usa [[ $var =~ patrón ]]
    - case no puede comparar rangos numéricos (<, >)
    - El orden de patrones importa (primero que coincide gana)
    - ;& y ;;& son bash 4.0+, usa ;; para compatibilidad
'
