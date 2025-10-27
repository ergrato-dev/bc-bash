#!/bin/bash
# Ejercicio 03: Transformación con sed
# Módulo: 2 | Dificultad: Media
# Objetivo: Aprender a usar sed para buscar y reemplazar texto

# ============================================================================
# INSTRUCCIONES
# ============================================================================
# sed (Stream EDitor) es una herramienta poderosa para editar texto.
# Se usa principalmente para buscar y reemplazar, pero puede hacer mucho más.
#
# TAREAS:
# 1. Reemplazar texto simple en una línea
# 2. Reemplazar todas las ocurrencias en un archivo
# 3. Reemplazar solo en líneas específicas
# 4. Eliminar líneas que coincidan con un patrón
# 5. Insertar y agregar líneas
# 6. Transformaciones complejas con expresiones regulares
#
# CRITERIOS DE ÉXITO:
# ✓ Usar diferentes comandos de sed (s, d, i, a)
# ✓ Entender la diferencia entre -i y salida estándar
# ✓ Dominar el uso de separadores y flags (g, i)

echo "✂️  Ejercicio 03: Transformación con sed"
echo "========================================"
echo ""

# ============================================================================
# PREPARACIÓN: Crear archivos de prueba
# ============================================================================
echo "📝 Preparando archivos de prueba..."

# Archivo de datos
cat > /tmp/datos.txt << 'EOF'
nombre=Juan
apellido=Perez
email=juan@example.com
telefono=123-456-789
ciudad=Madrid
pais=España
EOF

# Archivo HTML simple
cat > /tmp/pagina.html << 'EOF'
<html>
<head>
    <title>Mi Pagina</title>
</head>
<body>
    <h1>Bienvenido</h1>
    <p>Este es un parrafo de prueba.</p>
    <p>Otro parrafo aqui.</p>
</body>
</html>
EOF

# Archivo de logs
cat > /tmp/server.log << 'EOF'
2024-10-26 10:00:00 INFO Server started
2024-10-26 10:01:00 DEBUG Connection opened
2024-10-26 10:02:00 ERROR Connection failed
2024-10-26 10:03:00 INFO Request processed
2024-10-26 10:04:00 ERROR Timeout
2024-10-26 10:05:00 INFO Server stopped
EOF

echo "✓ Archivos de prueba creados en /tmp/"
echo ""

# ============================================================================
# TAREA 1: Reemplazo simple
# ============================================================================
echo "📋 TAREA 1: Reemplazar 'Juan' por 'Pedro' en datos.txt"
echo "-------------------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: sed 's/patron_buscar/patron_reemplazar/' archivo


echo ""

# ============================================================================
# TAREA 2: Reemplazo global (todas las ocurrencias)
# ============================================================================
echo "📋 TAREA 2: Reemplazar todas las 'a' por 'A' en datos.txt"
echo "----------------------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: sed 's/a/A/g' archivo


echo ""

# ============================================================================
# TAREA 3: Reemplazo case-insensitive
# ============================================================================
echo "📋 TAREA 3: Reemplazar 'info' por 'INFORMATION' (ignorando mayúsculas)"
echo "-----------------------------------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: sed 's/info/INFORMATION/gi' server.log


echo ""

# ============================================================================
# TAREA 4: Eliminar líneas
# ============================================================================
echo "📋 TAREA 4: Eliminar líneas que contienen 'ERROR' de server.log"
echo "----------------------------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: sed '/ERROR/d' archivo


echo ""

# ============================================================================
# TAREA 5: Eliminar líneas vacías
# ============================================================================
echo "📋 TAREA 5: Eliminar líneas vacías de pagina.html"
echo "--------------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: sed '/^$/d' archivo


echo ""

# ============================================================================
# TAREA 6: Reemplazar solo en línea específica
# ============================================================================
echo "📋 TAREA 6: Reemplazar 'Madrid' por 'Barcelona' solo en línea 5"
echo "----------------------------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: sed '5s/Madrid/Barcelona/' datos.txt


echo ""

# ============================================================================
# TAREA 7: Insertar línea antes
# ============================================================================
echo "📋 TAREA 7: Insertar '# DATOS PERSONALES' antes de la primera línea"
echo "---------------------------------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: sed '1i\# DATOS PERSONALES' datos.txt


echo ""

# ============================================================================
# TAREA 8: Agregar línea después
# ============================================================================
echo "📋 TAREA 8: Agregar 'codigo_postal=28001' después de línea con 'ciudad'"
echo "------------------------------------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: sed '/ciudad/a\codigo_postal=28001' datos.txt


echo ""

# ============================================================================
# TAREA 9: Múltiples reemplazos encadenados
# ============================================================================
echo "📋 TAREA 9: Reemplazar 'example.com' por 'empresa.com' Y 'Juan' por 'Pedro'"
echo "-----------------------------------------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: sed -e 's/pattern1/replace1/' -e 's/pattern2/replace2/' archivo


echo ""

# ============================================================================
# TAREA 10: Extraer y transformar
# ============================================================================
echo "📋 TAREA 10: Mostrar solo emails, eliminando 'email=' del inicio"
echo "-----------------------------------------------------------------"

# TU CÓDIGO AQUÍ:
# Pista: sed -n 's/^email=//p' datos.txt


echo ""

# Limpiar archivos temporales
rm -f /tmp/datos.txt /tmp/pagina.html /tmp/server.log
echo "🧹 Archivos temporales eliminados"
echo ""
echo "✅ Ejercicio completado!"


# ============================================================================
# SOLUCIÓN COMPLETA (descomenta para ver)
# ============================================================================

: '
# TAREA 1: Reemplazo simple
sed "s/Juan/Pedro/" /tmp/datos.txt

# TAREA 2: Reemplazo global
sed "s/a/A/g" /tmp/datos.txt

# TAREA 3: Case-insensitive
sed "s/info/INFORMATION/gi" /tmp/server.log

# TAREA 4: Eliminar líneas con ERROR
sed "/ERROR/d" /tmp/server.log

# TAREA 5: Eliminar líneas vacías
sed "/^$/d" /tmp/pagina.html

# TAREA 6: Reemplazar en línea específica
sed "5s/Madrid/Barcelona/" /tmp/datos.txt

# TAREA 7: Insertar antes
sed "1i\\# DATOS PERSONALES" /tmp/datos.txt

# TAREA 8: Agregar después
sed "/ciudad/a\\codigo_postal=28001" /tmp/datos.txt

# TAREA 9: Múltiples reemplazos
sed -e "s/example.com/empresa.com/" -e "s/Juan/Pedro/" /tmp/datos.txt

# TAREA 10: Extraer y transformar
sed -n "s/^email=//p" /tmp/datos.txt
'

# ============================================================================
# EXPLICACIÓN DE CONCEPTOS
# ============================================================================

: '
📚 CONCEPTOS CLAVE:

1. SINTAXIS BÁSICA:
   sed "comando" archivo
   sed -e "comando1" -e "comando2" archivo
   sed -f script.sed archivo

2. COMANDO DE SUSTITUCIÓN (s):
   s/buscar/reemplazar/       : Primera ocurrencia
   s/buscar/reemplazar/g      : Todas las ocurrencias (global)
   s/buscar/reemplazar/i      : Ignorar mayúsculas
   s/buscar/reemplazar/gi     : Global + case-insensitive
   s/buscar/reemplazar/2      : Solo segunda ocurrencia

3. SEPARADORES ALTERNATIVOS:
   s/buscar/reemplazar/       : Separador estándar /
   s|buscar|reemplazar|       : Útil cuando hay / en el patrón
   s:buscar:reemplazar:       : Otro separador válido
   s#buscar#reemplazar#       : Común para rutas

4. OTROS COMANDOS:
   d   : Eliminar línea
   p   : Imprimir línea
   i\  : Insertar antes
   a\  : Agregar después
   c\  : Cambiar línea completa

5. DIRECCIONAMIENTO:
   número         : Línea específica (ej: 5s/a/b/)
   /patron/       : Líneas que coinciden con patrón
   número,número  : Rango de líneas (ej: 2,5d)
   /pat1/,/pat2/  : Desde primera hasta segunda coincidencia

6. FLAGS ÚTILES:
   -n : Modo silencioso (solo imprime con p)
   -i : Editar archivo in-place (¡CUIDADO!)
   -e : Múltiples comandos
   -f : Leer comandos desde archivo

7. EXPRESIONES REGULARES:
   ^   : Inicio de línea
   $   : Fin de línea
   .   : Cualquier carácter
   .*  : Cualquier secuencia
   \+  : Una o más veces
   \?  : Cero o una vez
   \( \) : Grupos de captura
   &   : Texto coincidente completo

8. CASOS DE USO COMUNES:
   # Eliminar líneas vacías
   sed "/^$/d" archivo
   
   # Eliminar espacios al final
   sed "s/ *$//" archivo
   
   # Comentar líneas
   sed "s/^/#/" archivo
   
   # Descomentar
   sed "s/^#//" archivo
   
   # Reemplazar múltiples espacios por uno
   sed "s/  */ /g" archivo
   
   # Extraer valor después de =
   sed "s/.*=//" archivo
   
   # Cambiar rutas
   sed "s#/old/path#/new/path#g" archivo

💡 TIPS:
   - Prueba sin -i primero para ver el resultado
   - Usa comillas simples para evitar expansión del shell
   - Los separadores pueden ser casi cualquier carácter
   - sed procesa línea por línea
   - Para cambios complejos, considera awk
   - Haz backup antes de usar -i (o usa -i.bak)
'
