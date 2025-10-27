#!/bin/bash
# Ejercicio 03: Arrays Asociativos (Diccionarios)
# Módulo: 4 | Dificultad: Media
# Objetivo: Dominar arrays asociativos (key-value pairs)

echo "🗂️  Ejercicio 03: Arrays Asociativos"
echo "====================================="
echo ""

# Arrays asociativos requieren declaración explícita
declare -A usuario
declare -A colores
declare -A config

# ============================================================================
# TAREA 1: Crear y poblar array asociativo
# ============================================================================
echo "📋 TAREA 1: Crear diccionario de usuario"
echo "-----------------------------------------"

# TU CÓDIGO AQUÍ:
# Crear array asociativo con datos de usuario
usuario[nombre]="Juan Pérez"
usuario[edad]=30
usuario[email]="juan@example.com"
usuario[ciudad]="Madrid"

echo "Usuario creado:"
echo "  Nombre: ${usuario[nombre]}"
echo "  Edad: ${usuario[edad]}"
echo "  Email: ${usuario[email]}"
echo "  Ciudad: ${usuario[ciudad]}"

echo ""

# ============================================================================
# TAREA 2: Iterar sobre claves
# ============================================================================
echo "📋 TAREA 2: Mostrar todas las claves"
echo "-------------------------------------"

# TU CÓDIGO AQUÍ:
echo "Claves del diccionario usuario:"
for clave in "${!usuario[@]}"; do
    echo "  - $clave"
done

echo ""

# ============================================================================
# TAREA 3: Iterar sobre valores
# ============================================================================
echo "📋 TAREA 3: Mostrar todos los valores"
echo "--------------------------------------"

# TU CÓDIGO AQUÍ:
echo "Valores del diccionario usuario:"
for valor in "${usuario[@]}"; do
    echo "  → $valor"
done

echo ""

# ============================================================================
# TAREA 4: Iterar sobre pares clave-valor
# ============================================================================
echo "📋 TAREA 4: Mostrar pares clave-valor"
echo "--------------------------------------"

# TU CÓDIGO AQUÍ:
echo "Datos completos del usuario:"
for clave in "${!usuario[@]}"; do
    echo "  $clave = ${usuario[$clave]}"
done

echo ""

# ============================================================================
# TAREA 5: Verificar si existe una clave
# ============================================================================
echo "📋 TAREA 5: Verificar existencia de claves"
echo "-------------------------------------------"

# TU CÓDIGO AQUÍ:
if [[ -v usuario[email] ]]; then
    echo "✓ La clave 'email' existe: ${usuario[email]}"
fi

if [[ -v usuario[telefono] ]]; then
    echo "✓ La clave 'telefono' existe"
else
    echo "✗ La clave 'telefono' NO existe"
fi

echo ""

# ============================================================================
# TAREA 6: Agregar y modificar elementos
# ============================================================================
echo "📋 TAREA 6: Agregar y modificar elementos"
echo "------------------------------------------"

# TU CÓDIGO AQUÍ:
# Agregar nueva clave
usuario[telefono]="+34 600 123 456"
echo "✓ Agregado teléfono: ${usuario[telefono]}"

# Modificar existente
usuario[edad]=31
echo "✓ Edad actualizada: ${usuario[edad]}"

echo ""

# ============================================================================
# TAREA 7: Eliminar elementos
# ============================================================================
echo "📋 TAREA 7: Eliminar elemento"
echo "------------------------------"

# TU CÓDIGO AQUÍ:
unset usuario[telefono]
echo "✓ Teléfono eliminado"

if [[ -v usuario[telefono] ]]; then
    echo "  Teléfono aún existe"
else
    echo "  Teléfono ya no existe"
fi

echo ""

# ============================================================================
# TAREA 8: Tamaño del array asociativo
# ============================================================================
echo "📋 TAREA 8: Tamaño del diccionario"
echo "-----------------------------------"

# TU CÓDIGO AQUÍ:
echo "Número de elementos: ${#usuario[@]}"
echo "Claves: ${!usuario[@]}"

echo ""

# ============================================================================
# TAREA 9: Array asociativo de colores RGB
# ============================================================================
echo "📋 TAREA 9: Diccionario de colores"
echo "-----------------------------------"

# TU CÓDIGO AQUÍ:
colores[rojo]="#FF0000"
colores[verde]="#00FF00"
colores[azul]="#0000FF"
colores[amarillo]="#FFFF00"
colores[negro]="#000000"
colores[blanco]="#FFFFFF"

echo "Tabla de colores:"
for color in "${!colores[@]}"; do
    printf "  %-10s → %s\n" "$color" "${colores[$color]}"
done

echo ""

# ============================================================================
# TAREA 10: Configuración de aplicación
# ============================================================================
echo "📋 TAREA 10: Diccionario de configuración"
echo "------------------------------------------"

# TU CÓDIGO AQUÍ:
config[host]="localhost"
config[port]="8080"
config[debug]="true"
config[max_connections]="100"
config[timeout]="30"

echo "Configuración de la aplicación:"
for key in "${!config[@]}"; do
    printf "  %-20s = %s\n" "$key" "${config[$key]}"
done

echo ""

# ============================================================================
# PROYECTO PRÁCTICO: Base de datos simple de contactos
# ============================================================================
echo "📋 PROYECTO: Base de datos de contactos"
echo "========================================="

# Crear múltiples contactos con arrays asociativos
declare -A contacto1 contacto2 contacto3

contacto1[nombre]="Ana García"
contacto1[email]="ana@example.com"
contacto1[telefono]="+34 600 111 111"

contacto2[nombre]="Pedro López"
contacto2[email]="pedro@example.com"
contacto2[telefono]="+34 600 222 222"

contacto3[nombre]="María Sánchez"
contacto3[email]="maria@example.com"
contacto3[telefono]="+34 600 333 333"

# Función para mostrar contacto
mostrar_contacto() {
    local -n contacto=$1
    local id=$2
    
    echo "Contacto #$id:"
    echo "  Nombre:   ${contacto[nombre]}"
    echo "  Email:    ${contacto[email]}"
    echo "  Teléfono: ${contacto[telefono]}"
    echo ""
}

# Mostrar todos los contactos
mostrar_contacto contacto1 1
mostrar_contacto contacto2 2
mostrar_contacto contacto3 3

echo "✅ Ejercicio completado!"


# ============================================================================
# SOLUCIONES Y EXPLICACIONES
# ============================================================================

: '
📚 CONCEPTOS CLAVE DE ARRAYS ASOCIATIVOS:

1. DECLARACIÓN:
   declare -A nombre_array
   # ¡IMPORTANTE! Declaración obligatoria para arrays asociativos

2. ASIGNACIÓN:
   array[clave]="valor"
   array[otra_clave]="otro valor"

3. ACCESO:
   ${array[clave]}           # Obtener valor por clave
   ${!array[@]}              # Todas las claves
   ${array[@]}               # Todos los valores
   ${#array[@]}              # Número de elementos

4. VERIFICACIÓN:
   [[ -v array[clave] ]]     # Verifica si clave existe

5. MODIFICACIÓN:
   array[clave]="nuevo valor"  # Actualizar
   unset array[clave]          # Eliminar

6. ITERACIÓN:
   # Sobre claves
   for key in "${!array[@]}"; do
       echo "$key"
   done
   
   # Sobre valores
   for value in "${array[@]}"; do
       echo "$value"
   done
   
   # Sobre pares
   for key in "${!array[@]}"; do
       echo "$key = ${array[$key]}"
   done

7. DIFERENCIAS CON ARRAYS INDEXADOS:
   
   Array Indexado:           Array Asociativo:
   array[0]="valor"         array["clave"]="valor"
   array=(a b c)            declare -A array
   Índices numéricos        Claves string
   No requiere declare      Requiere declare -A

8. CASOS DE USO:
   ✓ Configuraciones
   ✓ Diccionarios de traducción
   ✓ Mapeo de datos
   ✓ Contadores por categoría
   ✓ Cache de resultados
   ✓ Estructuras de datos complejas

9. LIMITACIONES:
   ✗ No se pueden anidar (no hay arrays de arrays)
   ✗ No mantienen orden de inserción
   ✗ Sólo disponibles en Bash 4.0+
   ✗ No se pueden exportar a subshells

10. BUENAS PRÁCTICAS:
    ✓ Siempre usar declare -A
    ✓ Quote claves con espacios: array["mi clave"]="valor"
    ✓ Verificar existencia antes de acceder
    ✓ Usar names refs (-n) para pasar a funciones
    ✓ Nombrar claves descriptivamente

💡 TIPS:
   - Para pasar array asociativo a función: use nameref (local -n)
   - Para copiar: no hay forma directa, iterar y copiar
   - Para debugear: declare -p array_name
   - Bash 4.2+ soporta declare -g para scope global
   - Para JSON-like data, considerar jq si disponible

EJEMPLOS PRÁCTICOS:

# Contador de palabras
declare -A contador
while read palabra; do
    ((contador[$palabra]++))
done < archivo.txt

# Traducción
declare -A traduccion
traduccion[hello]="hola"
traduccion[goodbye]="adiós"
echo "${traduccion[hello]}"

# Configuración
declare -A db_config
db_config[host]="localhost"
db_config[user]="admin"
db_config[pass]="secret"

# Cache de resultados
declare -A cache
key="user_123"
if [[ -v cache[$key] ]]; then
    echo "Cache hit: ${cache[$key]}"
else
    result=$(expensive_operation)
    cache[$key]=$result
fi
'
