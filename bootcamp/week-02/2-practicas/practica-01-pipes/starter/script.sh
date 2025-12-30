#!/bin/bash
# ============================================
# PRÁCTICA 01: Pipes y Redirección
# Semana 02 - Bash Bootcamp
# ============================================
set -euo pipefail

echo "🔗 Práctica 01: Pipes y Redirección"
echo "===================================="
echo ""

# ============================================
# PASO 1: Pipes Básicos
# ============================================
echo "--- Paso 1: Pipes Básicos ---"

# Un pipe (|) conecta la salida de un comando
# con la entrada del siguiente.
# Ejemplo: ls | wc -l cuenta las líneas de ls

# Descomenta las siguientes líneas:
# echo "Archivos en /usr/bin que contienen 'zip':"
# ls /usr/bin | grep zip

echo ""

# ============================================
# PASO 2: Múltiples Pipes
# ============================================
echo "--- Paso 2: Múltiples Pipes ---"

# Puedes encadenar varios comandos.
# Cada | pasa la salida al siguiente comando.

# Descomenta las siguientes líneas:
# echo "Top 5 usuarios de /etc/passwd (ordenados):"
# cut -d: -f1 /etc/passwd | sort | head -5

echo ""

# ============================================
# PASO 3: Redirección de Salida (>)
# ============================================
echo "--- Paso 3: Redirección de Salida ---"

# El operador > envía stdout a un archivo.
# ⚠️ Sobrescribe el contenido existente.

# Descomenta las siguientes líneas:
# echo "Guardando lista de usuarios en /tmp/usuarios.txt..."
# cut -d: -f1 /etc/passwd > /tmp/usuarios.txt
# echo "Archivo creado. Contenido (primeras 5 líneas):"
# head -5 /tmp/usuarios.txt

echo ""

# ============================================
# PASO 4: Añadir a Archivo (>>)
# ============================================
echo "--- Paso 4: Añadir a Archivo ---"

# El operador >> añade al final sin sobrescribir.
# Útil para logs y acumular datos.

# Descomenta las siguientes líneas:
# echo "Primera línea" > /tmp/registro.txt
# echo "Segunda línea" >> /tmp/registro.txt
# echo "Tercera línea" >> /tmp/registro.txt
# echo "Contenido del registro:"
# cat /tmp/registro.txt

echo ""

# ============================================
# PASO 5: Redirigir Errores (2>)
# ============================================
echo "--- Paso 5: Redirigir Errores ---"

# stdout = 1 (salida normal)
# stderr = 2 (errores)
# 2> redirige solo los errores

# Descomenta las siguientes líneas:
# echo "Listando directorio existente e inexistente:"
# ls /tmp /directorio_inexistente 2> /tmp/errores.txt
# echo "Errores capturados:"
# cat /tmp/errores.txt

echo ""

# ============================================
# PASO 6: Combinar stdout y stderr (&>)
# ============================================
echo "--- Paso 6: Combinar stdout y stderr ---"

# &> redirige tanto stdout como stderr al mismo archivo.
# Equivalente a > archivo 2>&1

# Descomenta las siguientes líneas:
# echo "Capturando todo (stdout + stderr):"
# ls /tmp /inexistente &> /tmp/todo.txt
# echo "Contenido completo:"
# cat /tmp/todo.txt

echo ""

# ============================================
# PASO 7: Comando tee
# ============================================
echo "--- Paso 7: Comando tee ---"

# tee muestra en pantalla Y guarda en archivo.
# Útil para ver el progreso mientras guardas.

# Descomenta las siguientes líneas:
# echo "Usando tee para ver y guardar:"
# echo "Mensaje importante" | tee /tmp/mensaje.txt
# echo "También se guardó en /tmp/mensaje.txt"

echo ""

# ============================================
# PASO 8: tee con Pipes
# ============================================
echo "--- Paso 8: tee con Pipes ---"

# tee puede estar en medio de un pipeline.
# Guarda en ese punto y continúa el flujo.

# Descomenta las siguientes líneas:
# echo "Pipeline con tee intermedio:"
# ls /usr/bin | tee /tmp/todos_binarios.txt | grep "^z" | tee /tmp/binarios_z.txt | wc -l
# echo "Binarios que empiezan con 'z' guardados en /tmp/binarios_z.txt"

echo ""

# ============================================
# PASO 9: Descartar Salida (/dev/null)
# ============================================
echo "--- Paso 9: Descartar Salida ---"

# /dev/null es un "agujero negro" - descarta todo.
# Útil cuando no necesitas la salida.

# Descomenta las siguientes líneas:
# echo "Ejecutando comando silenciosamente:"
# ls /usr/bin > /dev/null
# echo "El comando se ejecutó pero no mostró nada"
# echo ""
# echo "Descartando solo errores:"
# ls /tmp /inexistente 2>/dev/null
# echo "(solo vemos stdout, stderr fue descartado)"

echo ""

# ============================================
# PASO 10: Pipeline Completo
# ============================================
echo "--- Paso 10: Pipeline Completo ---"

# Combinemos todo en un ejemplo práctico:
# Encontrar los 3 shells más usados en el sistema

# Descomenta las siguientes líneas:
# echo "Top 3 shells más usados:"
# cut -d: -f7 /etc/passwd | sort | uniq -c | sort -rn | head -3

echo ""

# ============================================
# LIMPIEZA
# ============================================
echo "--- Limpieza ---"
# rm -f /tmp/usuarios.txt /tmp/registro.txt /tmp/errores.txt
# rm -f /tmp/todo.txt /tmp/mensaje.txt /tmp/todos_binarios.txt /tmp/binarios_z.txt
echo "Archivos temporales limpiados (descomenta para activar)"
echo ""

echo "✅ Práctica completada!"
echo ""
echo "📚 Resumen de operadores:"
echo "   |    Pipe: conecta stdout con stdin"
echo "   >    Redirige stdout (sobrescribe)"
echo "   >>   Redirige stdout (añade)"
echo "   2>   Redirige stderr"
echo "   &>   Redirige stdout + stderr"
echo "   tee  Divide el flujo (pantalla + archivo)"
