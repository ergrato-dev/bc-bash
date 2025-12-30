#!/bin/bash
# Ejercicio 01: Condicionales if/elif/else
# Módulo: 3 | Dificultad: Básica
# Objetivo: Dominar las estructuras condicionales en Bash

# ============================================================================
# INSTRUCCIONES
# ============================================================================
# Las estructuras condicionales te permiten tomar decisiones en tus scripts.
# Aprenderás a usar if, elif, else y diferentes tipos de comparaciones.
#
# TAREAS:
# 1. Verificar si un número es positivo, negativo o cero
# 2. Comprobar si un archivo existe
# 3. Validar permisos de un archivo
# 4. Comparar dos números
# 5. Validar entrada de usuario
# 6. Condiciones múltiples con AND y OR
#
# CRITERIOS DE ÉXITO:
# ✓ Usar correctamente if/elif/else
# ✓ Aplicar operadores de comparación apropiados
# ✓ Manejar casos edge (valores límite)

echo "🔀 Ejercicio 01: Condicionales if/elif/else"
echo "==========================================="
echo ""

# ============================================================================
# TAREA 1: Clasificar un número
# ============================================================================
echo "📋 TAREA 1: Clasificar número (positivo/negativo/cero)"
echo "-------------------------------------------------------"

numero=15

# TU CÓDIGO AQUÍ:
# Pista: if [[ $numero -gt 0 ]]; then ... elif ... else ... fi


echo ""

# ============================================================================
# TAREA 2: Verificar existencia de archivo
# ============================================================================
echo "📋 TAREA 2: Verificar si existe /etc/passwd"
echo "--------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: if [[ -f "/etc/passwd" ]]; then ...


echo ""

# ============================================================================
# TAREA 3: Verificar permisos de archivo
# ============================================================================
echo "📋 TAREA 3: Verificar si /tmp es escribible"
echo "--------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: if [[ -w "/tmp" ]]; then ...


echo ""

# ============================================================================
# TAREA 4: Comparar dos números
# ============================================================================
echo "📋 TAREA 4: Comparar dos números"
echo "---------------------------------"

num1=25
num2=30

# TU CÓDIGO AQUÍ:
# Pista: Comparar y mostrar cuál es mayor o si son iguales


echo ""

# ============================================================================
# TAREA 5: Validar entrada de usuario
# ============================================================================
echo "📋 TAREA 5: Validar nombre (no vacío, solo letras)"
echo "---------------------------------------------------"

nombre="Juan"

# TU CÓDIGO AQUÍ:
# Pista: [[ -n $nombre ]] para no vacío, [[ $nombre =~ ^[a-zA-Z]+$ ]] para letras


echo ""

# ============================================================================
# TAREA 6: Condiciones múltiples con AND (&&) y OR (||)
# ============================================================================
echo "📋 TAREA 6: Verificar rango de edad (18-65)"
echo "--------------------------------------------"

edad=30

# TU CÓDIGO AQUÍ:
# Pista: if [[ $edad -ge 18 && $edad -le 65 ]]; then ...


echo ""

# ============================================================================
# TAREA 7: Verificar tipo de archivo
# ============================================================================
echo "📋 TAREA 7: Identificar tipo de elemento en /tmp"
echo "-------------------------------------------------"

ruta="/tmp"

# TU CÓDIGO AQUÍ:
# Pista: -f archivo regular, -d directorio, -L enlace simbólico


echo ""

# ============================================================================
# TAREA 8: Comparación de strings
# ============================================================================
echo "📋 TAREA 8: Verificar contraseña"
echo "---------------------------------"

password="secreto123"
password_correcta="secreto123"

# TU CÓDIGO AQUÍ:
# Pista: if [[ "$password" == "$password_correcta" ]]; then ...


echo ""

# ============================================================================
# TAREA AVANZADA: Sistema de login simple
# ============================================================================
echo "📋 TAREA AVANZADA: Sistema de login"
echo "------------------------------------"

usuario="admin"
pass="admin123"
intentos=0
max_intentos=3

# TU CÓDIGO AQUÍ:
# Simula un sistema de login con límite de intentos
# Verifica usuario Y contraseña
# Cuenta intentos fallidos


echo ""
echo "✅ Ejercicio completado!"


# ============================================================================
# SOLUCIÓN COMPLETA (descomenta para ver)
# ============================================================================

: '
# TAREA 1: Clasificar número
if [[ $numero -gt 0 ]]; then
    echo "✓ $numero es POSITIVO"
elif [[ $numero -lt 0 ]]; then
    echo "✓ $numero es NEGATIVO"
else
    echo "✓ $numero es CERO"
fi

# TAREA 2: Verificar archivo
if [[ -f "/etc/passwd" ]]; then
    echo "✓ El archivo /etc/passwd existe"
else
    echo "✗ El archivo /etc/passwd NO existe"
fi

# TAREA 3: Verificar permisos
if [[ -w "/tmp" ]]; then
    echo "✓ /tmp es escribible"
else
    echo "✗ /tmp NO es escribible"
fi

# TAREA 4: Comparar números
if [[ $num1 -gt $num2 ]]; then
    echo "✓ $num1 es mayor que $num2"
elif [[ $num1 -lt $num2 ]]; then
    echo "✓ $num1 es menor que $num2"
else
    echo "✓ $num1 es igual a $num2"
fi

# TAREA 5: Validar nombre
if [[ -z "$nombre" ]]; then
    echo "✗ El nombre está vacío"
elif [[ ! "$nombre" =~ ^[a-zA-Z]+$ ]]; then
    echo "✗ El nombre debe contener solo letras"
else
    echo "✓ Nombre válido: $nombre"
fi

# TAREA 6: Verificar rango
if [[ $edad -ge 18 && $edad -le 65 ]]; then
    echo "✓ Edad $edad está en rango laboral (18-65)"
else
    echo "✗ Edad $edad fuera del rango laboral"
fi

# TAREA 7: Tipo de archivo
if [[ -L "$ruta" ]]; then
    echo "✓ $ruta es un enlace simbólico"
elif [[ -d "$ruta" ]]; then
    echo "✓ $ruta es un directorio"
elif [[ -f "$ruta" ]]; then
    echo "✓ $ruta es un archivo regular"
else
    echo "✗ $ruta no existe o es de tipo desconocido"
fi

# TAREA 8: Comparar strings
if [[ "$password" == "$password_correcta" ]]; then
    echo "✓ Contraseña correcta"
else
    echo "✗ Contraseña incorrecta"
fi

# TAREA AVANZADA: Sistema de login
usuario_input="admin"
pass_input="admin123"

if [[ "$usuario_input" == "$usuario" && "$pass_input" == "$pass" ]]; then
    echo "✓ Login exitoso. Bienvenido $usuario"
else
    echo "✗ Credenciales incorrectas"
    ((intentos++))
    if [[ $intentos -ge $max_intentos ]]; then
        echo "✗ Máximo de intentos alcanzado. Cuenta bloqueada."
    fi
fi
'

# ============================================================================
# EXPLICACIÓN DE CONCEPTOS
# ============================================================================

: '
📚 CONCEPTOS CLAVE:

1. SINTAXIS BÁSICA:
   if [[ condición ]]; then
       comandos
   elif [[ otra_condición ]]; then
       otros_comandos
   else
       comandos_alternativos
   fi

2. OPERADORES NUMÉRICOS:
   -eq : Igual a (equal)
   -ne : No igual (not equal)
   -gt : Mayor que (greater than)
   -ge : Mayor o igual (greater or equal)
   -lt : Menor que (less than)
   -le : Menor o igual (less or equal)

3. OPERADORES DE STRINGS:
   ==  : Igual
   !=  : Diferente
   <   : Menor (orden alfabético)
   >   : Mayor (orden alfabético)
   -z  : String vacío (zero length)
   -n  : String no vacío (non-zero)

4. TESTS DE ARCHIVOS:
   -e  : Existe
   -f  : Es archivo regular
   -d  : Es directorio
   -L  : Es enlace simbólico
   -r  : Es legible
   -w  : Es escribible
   -x  : Es ejecutable
   -s  : Existe y no está vacío

5. OPERADORES LÓGICOS:
   &&  : AND lógico
   ||  : OR lógico
   !   : NOT lógico

6. [[ ]] vs [ ]:
   [[ ]] : Sintaxis moderna, más segura
   - Soporta && y || dentro
   - Soporta pattern matching
   - No requiere quotes en variables
   - Recomendado para Bash

   [ ] : Sintaxis POSIX, compatible
   - Requiere -a y -o para AND/OR
   - Más estricto con espacios
   - Mejor para portabilidad

7. EXPRESIONES REGULARES:
   =~  : Coincide con regex
   Ejemplo: [[ $var =~ ^[0-9]+$ ]]

8. BUENAS PRÁCTICAS:
   ✓ Usa [[ ]] en Bash
   ✓ Quote variables en [ ]
   ✓ Usa elif en vez de múltiples if
   ✓ Comprueba errores primero
   ✓ Mantén condiciones simples y legibles

💡 TIPS:
   - Usa -z y -n para verificar strings vacíos
   - Combina tests con && y ||
   - [[ ]] es más forgiving que [ ]
   - Para números, usa operadores -eq, -gt, etc.
   - Para strings, usa == y !=
   - Siempre quote expansiones de variables en [ ]
'
