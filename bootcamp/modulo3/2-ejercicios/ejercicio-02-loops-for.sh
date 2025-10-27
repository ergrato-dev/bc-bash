#!/bin/bash
# Ejercicio 02: Loops con for
# Módulo: 3 | Dificultad: Básica
# Objetivo: Dominar diferentes formas de usar loops for en Bash

# ============================================================================
# INSTRUCCIONES
# ============================================================================
# El loop for te permite iterar sobre listas, rangos, archivos y más.
# Es una de las estructuras más útiles en scripting.
#
# TAREAS:
# 1. Iterar sobre una lista de valores
# 2. Iterar sobre un rango numérico
# 3. Iterar sobre archivos en un directorio
# 4. For con estilo C
# 5. Iterar sobre elementos de un array
# 6. Procesar argumentos de línea de comandos
# 7. Iterar sobre resultados de un comando
#
# CRITERIOS DE ÉXITO:
# ✓ Usar diferentes sintaxis de for
# ✓ Aplicar for en casos prácticos
# ✓ Combinar for con condicionales

echo "🔄 Ejercicio 02: Loops con for"
echo "==============================="
echo ""

# ============================================================================
# TAREA 1: Iterar sobre lista de valores
# ============================================================================
echo "📋 TAREA 1: Iterar sobre frutas"
echo "--------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: for fruta in manzana naranja plátano; do echo "Me gusta la $fruta"; done


echo ""

# ============================================================================
# TAREA 2: Iterar sobre rango numérico con {inicio..fin}
# ============================================================================
echo "📋 TAREA 2: Imprimir números del 1 al 10"
echo "-----------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: for i in {1..10}; do echo "Número: $i"; done


echo ""

# ============================================================================
# TAREA 3: Iterar sobre archivos
# ============================================================================
echo "📋 TAREA 3: Listar archivos .sh en el directorio actual"
echo "--------------------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: for archivo in *.sh; do echo "Archivo: $archivo"; done


echo ""

# ============================================================================
# TAREA 4: For estilo C con (( ))
# ============================================================================
echo "📋 TAREA 4: Tabla de multiplicar del 5"
echo "---------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: for ((i=1; i<=10; i++)); do echo "5 x $i = $((5*i))"; done


echo ""

# ============================================================================
# TAREA 5: Iterar sobre array
# ============================================================================
echo "📋 TAREA 5: Procesar array de nombres"
echo "--------------------------------------"

nombres=("Juan" "María" "Pedro" "Ana" "Luis")

# TU CÓDIGO AQUÍ:
# Pista: for nombre in "${nombres[@]}"; do echo "Hola, $nombre"; done


echo ""

# ============================================================================
# TAREA 6: Iterar con índices de array
# ============================================================================
echo "📋 TAREA 6: Mostrar nombres con su posición"
echo "--------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: for i in "${!nombres[@]}"; do echo "[$i] ${nombres[$i]}"; done


echo ""

# ============================================================================
# TAREA 7: Iterar sobre salida de comando
# ============================================================================
echo "📋 TAREA 7: Procesar usuarios del sistema"
echo "------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: for user in $(cut -d: -f1 /etc/passwd | head -5); do echo "Usuario: $user"; done


echo ""

# ============================================================================
# TAREA 8: For con saltos (step)
# ============================================================================
echo "📋 TAREA 8: Números pares del 0 al 20"
echo "--------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: for i in {0..20..2}; do echo "Par: $i"; done


echo ""

# ============================================================================
# TAREA 9: For con break y continue
# ============================================================================
echo "📋 TAREA 9: Buscar primer número divisible por 7"
echo "-------------------------------------------------"

# TU CÓDIGO AQUÍ:
# Iterar del 1 al 100, mostrar solo los divisibles por 7, parar en el primero > 50


echo ""

# ============================================================================
# TAREA 10: For anidado (nested)
# ============================================================================
echo "📋 TAREA 10: Tabla de multiplicar (3x3)"
echo "----------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: for i in {1..3}; do for j in {1..3}; do echo -n "$((i*j)) "; done; echo; done


echo ""

# ============================================================================
# PREPARACIÓN: Crear archivos de prueba para TAREA AVANZADA
# ============================================================================
mkdir -p /tmp/ejercicio_for
cd /tmp/ejercicio_for
touch archivo1.txt archivo2.log archivo3.txt archivo4.sh script.sh
echo ""

# ============================================================================
# TAREA AVANZADA: Renombrar archivos en lote
# ============================================================================
echo "📋 TAREA AVANZADA: Renombrar archivos .txt a .backup"
echo "-----------------------------------------------------"

# TU CÓDIGO AQUÍ:
# En /tmp/ejercicio_for, renombrar todos los .txt a .backup
# Usar for + mv


# Limpiar
cd - > /dev/null
rm -rf /tmp/ejercicio_for

echo ""
echo "✅ Ejercicio completado!"


# ============================================================================
# SOLUCIÓN COMPLETA (descomenta para ver)
# ============================================================================

: '
# TAREA 1: Lista de valores
for fruta in manzana naranja plátano uva pera; do
    echo "🍎 Me gusta la $fruta"
done

# TAREA 2: Rango numérico
for i in {1..10}; do
    echo "Número: $i"
done

# TAREA 3: Archivos
for archivo in *.sh; do
    if [[ -f "$archivo" ]]; then
        echo "📄 Archivo: $archivo"
    fi
done

# TAREA 4: Estilo C
echo "Tabla del 5:"
for ((i=1; i<=10; i++)); do
    resultado=$((5 * i))
    printf "5 x %2d = %3d\n" $i $resultado
done

# TAREA 5: Array
for nombre in "${nombres[@]}"; do
    echo "👋 Hola, $nombre!"
done

# TAREA 6: Con índices
for i in "${!nombres[@]}"; do
    echo "Posición $i: ${nombres[$i]}"
done

# TAREA 7: Salida de comando
contador=1
for user in $(cut -d: -f1 /etc/passwd | head -5); do
    echo "$contador. Usuario: $user"
    ((contador++))
done

# TAREA 8: Con saltos
echo "Números pares:"
for i in {0..20..2}; do
    echo -n "$i "
done
echo

# TAREA 9: Break y continue
for num in {1..100}; do
    if [[ $((num % 7)) -eq 0 ]]; then
        echo "Divisible por 7: $num"
        if [[ $num -gt 50 ]]; then
            echo "Primer número > 50 encontrado. Saliendo..."
            break
        fi
    fi
done

# TAREA 10: For anidado
echo "Tabla 3x3:"
for i in {1..3}; do
    for j in {1..3}; do
        printf "%3d " $((i * j))
    done
    echo
done

# TAREA AVANZADA: Renombrar
echo "Renombrando archivos .txt a .backup..."
for archivo in /tmp/ejercicio_for/*.txt; do
    if [[ -f "$archivo" ]]; then
        nuevo="${archivo%.txt}.backup"
        mv "$archivo" "$nuevo"
        echo "✓ Renombrado: $(basename $archivo) → $(basename $nuevo)"
    fi
done
'

# ============================================================================
# EXPLICACIÓN DE CONCEPTOS
# ============================================================================

: '
📚 CONCEPTOS CLAVE:

1. SINTAXIS BÁSICA DE FOR:
   for variable in lista; do
       comandos
   done

2. FOR SOBRE LISTAS:
   for item in item1 item2 item3; do
       echo $item
   done

3. FOR SOBRE RANGOS:
   {inicio..fin}         : 1..10 → 1 2 3 ... 10
   {inicio..fin..step}   : 0..20..2 → 0 2 4 ... 20
   {a..z}                : Letras de a-z
   {Z..A}                : Orden inverso

4. FOR ESTILO C:
   for ((inicialización; condición; incremento)); do
       comandos
   done
   
   Ejemplo:
   for ((i=0; i<10; i++)); do
       echo $i
   done

5. FOR SOBRE ARCHIVOS:
   for file in *.txt; do       # Archivos .txt
   for file in /ruta/*; do     # Todos en directorio
   for file in **/*.sh; do     # Recursivo (con shopt -s globstar)

6. FOR SOBRE ARRAYS:
   for item in "${array[@]}"; do    # Elementos
   for i in "${!array[@]}"; do      # Índices

7. FOR SOBRE COMANDO:
   for item in $(comando); do
       # Procesa cada palabra de salida
   done
   
   ⚠️  Cuidado: Word splitting puede causar problemas

8. CONTROL DE FLUJO:
   break      : Sale del loop inmediatamente
   continue   : Salta a la siguiente iteración
   break n    : Sale de n loops anidados

9. PATRONES COMUNES:
   
   # Procesar archivos con extensión
   for file in *.log; do
       [[ -f "$file" ]] || continue
       # procesar...
   done
   
   # Contador manual
   contador=0
   for item in lista; do
       ((contador++))
       echo "$contador: $item"
   done
   
   # Múltiples valores por iteración
   for nombre edad in Juan 25 María 30 Pedro 28; do
       echo "$nombre tiene $edad años"
   done

10. DIFERENCIAS FOR vs WHILE:
    FOR:
    - Para iteraciones conocidas
    - Sobre listas/rangos definidos
    - Más legible para conteos

    WHILE:
    - Para condiciones variables
    - Cuando no sabes cuántas iteraciones
    - Lectura de archivos línea por línea

11. BUENAS PRÁCTICAS:
    ✓ Quote expansiones de variables: "$var"
    ✓ Verifica existencia de archivos: [[ -f "$file" ]]
    ✓ Usa for estilo C para contadores
    ✓ Prefiere arrays para listas complejas
    ✓ Evita word splitting con IFS o quotes
    ✓ Usa continue en vez de if-then anidados

💡 TIPS:
    - {1..10} es más eficiente que seq 1 10
    - for i in $(ls) es problemático, usa for i in *
    - for sobre $(comando) crea word splitting
    - Para archivos con espacios: IFS=$\n
    - $((expresión)) para aritmética en el loop
    - printf para formato consistente en loops
'
