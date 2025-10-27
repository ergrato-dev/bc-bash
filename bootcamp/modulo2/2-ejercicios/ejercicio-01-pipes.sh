#!/bin/bash
# Ejercicio 01: Pipes y Redirección
# Módulo: 2 | Dificultad: Básica
# Objetivo: Dominar el uso de pipes para encadenar comandos

# ============================================================================
# INSTRUCCIONES
# ============================================================================
# En este ejercicio aprenderás a usar pipes (|) para conectar comandos.
# Los pipes toman la salida de un comando y la pasan como entrada al siguiente.
#
# TAREAS:
# 1. Lista todos los archivos .sh del directorio actual y cuenta cuántos hay
# 2. Muestra solo las 5 líneas más largas del archivo /etc/passwd
# 3. Lista procesos y muestra solo los que contienen "bash"
# 4. Cuenta cuántos usuarios únicos hay en /etc/passwd
# 5. Ordena alfabéticamente y muestra los 3 primeros directorios de /usr
#
# CRITERIOS DE ÉXITO:
# ✓ Usar al menos 2 comandos conectados con pipe en cada tarea
# ✓ Los resultados deben ser precisos y formateados
# ✓ No usar archivos temporales

echo "🔧 Ejercicio 01: Pipes y Redirección"
echo "===================================="
echo ""

# ============================================================================
# TAREA 1: Contar archivos .sh
# ============================================================================
echo "📋 TAREA 1: Contar archivos .sh en el directorio actual"
echo "--------------------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: ls | grep | wc -l


echo ""

# ============================================================================
# TAREA 2: Líneas más largas de /etc/passwd
# ============================================================================
echo "📋 TAREA 2: Mostrar las 5 líneas más largas de /etc/passwd"
echo "-----------------------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: cat | awk | sort | head


echo ""

# ============================================================================
# TAREA 3: Procesos con "bash"
# ============================================================================
echo "📋 TAREA 3: Listar procesos que contienen 'bash'"
echo "-------------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: ps aux | grep bash


echo ""

# ============================================================================
# TAREA 4: Usuarios únicos
# ============================================================================
echo "📋 TAREA 4: Contar usuarios únicos en /etc/passwd"
echo "--------------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: cut -d: -f1 /etc/passwd | sort | uniq | wc -l


echo ""

# ============================================================================
# TAREA 5: Primeros directorios de /usr
# ============================================================================
echo "📋 TAREA 5: Top 3 directorios de /usr (ordenados alfabéticamente)"
echo "------------------------------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: ls /usr | sort | head -3


echo ""
echo "✅ Ejercicio completado!"


# ============================================================================
# SOLUCIÓN COMPLETA (descomenta para ver)
# ============================================================================

: '
# TAREA 1: Contar archivos .sh
echo "Total de archivos .sh:"
ls -1 *.sh 2>/dev/null | wc -l

# TAREA 2: Líneas más largas
echo "Las 5 líneas más largas de /etc/passwd:"
cat /etc/passwd | awk "{ print length, \$0 }" | sort -rn | head -5 | cut -d" " -f2-

# TAREA 3: Procesos bash
echo "Procesos con bash:"
ps aux | grep bash | grep -v grep

# TAREA 4: Usuarios únicos
echo "Número de usuarios:"
cut -d: -f1 /etc/passwd | sort -u | wc -l

# TAREA 5: Top 3 directorios
echo "Primeros 3 directorios de /usr:"
ls -1 /usr | sort | head -3
'

# ============================================================================
# EXPLICACIÓN DE CONCEPTOS
# ============================================================================

: '
📚 CONCEPTOS CLAVE:

1. PIPE (|):
   - Conecta la salida (stdout) de un comando con la entrada (stdin) del siguiente
   - Sintaxis: comando1 | comando2 | comando3

2. REDIRECCIÓN:
   - > : Redirige stdout a un archivo (sobrescribe)
   - >> : Redirige stdout a un archivo (añade)
   - 2> : Redirige stderr (errores)
   - &> : Redirige stdout y stderr

3. COMANDOS ÚTILES CON PIPES:
   - grep: Filtrar líneas
   - sort: Ordenar
   - uniq: Eliminar duplicados
   - wc: Contar (líneas, palabras, caracteres)
   - head/tail: Primeras/últimas líneas
   - cut: Extraer columnas
   - awk: Procesamiento de texto avanzado

4. BUENAS PRÁCTICAS:
   - Usar 2>/dev/null para suprimir errores cuando sea apropiado
   - Combinar sort | uniq en lugar de solo uniq (uniq requiere entrada ordenada)
   - Usar grep -v para excluir patrones
   - Preferir pipelines simples y legibles

💡 TIPS:
   - Prueba cada comando por separado antes de encadenarlos
   - Usa echo para verificar variables antes de pasarlas a pipes
   - Los pipes son más eficientes que archivos temporales
   - Puedes encadenar tantos comandos como necesites
'
