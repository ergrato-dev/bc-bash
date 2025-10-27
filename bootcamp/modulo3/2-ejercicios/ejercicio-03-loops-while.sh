#!/bin/bash
# Ejercicio 03: Loops while y until
# Módulo: 3 | Dificultad: Media
# Objetivo: Dominar loops while y until, diferencias con for

# ============================================================================
# INSTRUCCIONES
# ============================================================================
# while ejecuta mientras la condición sea verdadera
# until ejecuta hasta que la condición sea verdadera
# Son perfectos cuando no sabes cuántas iteraciones necesitas
#
# TAREAS:
# 1. Contador simple con while
# 2. Leer archivo línea por línea
# 3. Loop infinito controlado
# 4. Loop until (opuesto a while)
# 5. while con break y continue
# 6. Menú interactivo
# 7. Procesar entrada hasta condición
#
# CRITERIOS DE ÉXITO:
# ✓ Entender diferencia while vs until
# ✓ Usar while para lectura de archivos
# ✓ Controlar loops con break/continue

echo "🔁 Ejercicio 03: Loops while y until"
echo "====================================="
echo ""

# ============================================================================
# TAREA 1: Contador simple con while
# ============================================================================
echo "📋 TAREA 1: Contador del 1 al 5 con while"
echo "------------------------------------------"

# TU CÓDIGO AQUÍ:
# contador=1
# while [[ $contador -le 5 ]]; do
#     echo "Contador: $contador"
#     ((contador++))
# done


echo ""

# ============================================================================
# TAREA 2: Leer archivo línea por línea
# ============================================================================
echo "📋 TAREA 2: Leer /etc/passwd línea por línea (primeras 5)"
echo "----------------------------------------------------------"

# TU CÓDIGO AQUÍ:
# contador=0
# while IFS=: read -r usuario x uid resto; do
#     echo "Usuario: $usuario (UID: $uid)"
#     ((contador++))
#     [[ $contador -ge 5 ]] && break
# done < /etc/passwd


echo ""

# ============================================================================
# TAREA 3: Loop infinito controlado
# ============================================================================
echo "📋 TAREA 3: Loop infinito con salida controlada"
echo "------------------------------------------------"

# TU CÓDIGO AQUÍ:
# contador=0
# while true; do
#     echo "Iteración $contador"
#     ((contador++))
#     [[ $contador -ge 3 ]] && break
# done


echo ""

# ============================================================================
# TAREA 4: Loop until (ejecuta hasta que condición sea verdadera)
# ============================================================================
echo "📋 TAREA 4: Cuenta con until"
echo "-----------------------------"

# TU CÓDIGO AQUÍ:
# contador=1
# until [[ $contador -gt 5 ]]; do
#     echo "Until contador: $contador"
#     ((contador++))
# done


echo ""

# ============================================================================
# TAREA 5: while con continue
# ============================================================================
echo "📋 TAREA 5: Números impares del 1 al 10 (con continue)"
echo "-------------------------------------------------------"

# TU CÓDIGO AQUÍ:
# num=0
# while [[ $num -lt 10 ]]; do
#     ((num++))
#     [[ $((num % 2)) -eq 0 ]] && continue
#     echo "Impar: $num"
# done


echo ""

# ============================================================================
# PREPARACIÓN: Crear archivo de prueba
# ============================================================================
cat > /tmp/numeros.txt << 'EOF'
10
25
30
-5
0
45
EOF

# ============================================================================
# TAREA 6: Sumar números de archivo hasta encontrar negativo
# ============================================================================
echo "📋 TAREA 6: Sumar hasta encontrar número negativo"
echo "--------------------------------------------------"

# TU CÓDIGO AQUÍ:
# suma=0
# while read -r numero; do
#     if [[ $numero -lt 0 ]]; then
#         echo "Número negativo encontrado: $numero"
#         break
#     fi
#     suma=$((suma + numero))
#     echo "Sumando $numero... Total: $suma"
# done < /tmp/numeros.txt


echo ""

# ============================================================================
# TAREA 7: Menú interactivo simple
# ============================================================================
echo "📋 TAREA 7: Menú con while (simulado)"
echo "--------------------------------------"

# TU CÓDIGO AQUÍ:
# Simular selección de opción (en ejercicio real sería con read)
# opcion=0
# iteraciones=0
# while [[ $opcion != 3 ]]; do
#     ((iteraciones++))
#     echo "1. Opción 1"
#     echo "2. Opción 2"
#     echo "3. Salir"
#     # Simular: alternar entre opciones
#     opcion=$((iteraciones % 4))
#     [[ $iteraciones -ge 3 ]] && opcion=3
#     echo "Opción seleccionada: $opcion"
# done


echo ""

# ============================================================================
# TAREA 8: Esperar hasta que archivo exista
# ============================================================================
echo "📋 TAREA 8: Esperar hasta que archivo exista (simulado)"
echo "--------------------------------------------------------"

# TU CÓDIGO AQUÍ:
# archivo="/tmp/test_file_$$.txt"
# intentos=0
# until [[ -f "$archivo" ]] || [[ $intentos -ge 3 ]]; do
#     echo "Esperando archivo... intento $((intentos+1))"
#     sleep 1  # En real esperaría
#     ((intentos++))
#     # Simular: crear en intento 2
#     [[ $intentos -eq 2 ]] && touch "$archivo"
# done


# Limpiar
rm -f /tmp/numeros.txt /tmp/test_file_*.txt

echo ""
echo "✅ Ejercicio completado!"


# ============================================================================
# SOLUCIÓN COMPLETA (descomenta para ver)
# ============================================================================

: '
# TAREA 1: Contador simple
contador=1
while [[ $contador -le 5 ]]; do
    echo "Contador: $contador"
    ((contador++))
done

# TAREA 2: Leer archivo
echo "Primeros 5 usuarios:"
contador=0
while IFS=: read -r usuario x uid resto; do
    echo "  $usuario (UID: $uid)"
    ((contador++))
    [[ $contador -ge 5 ]] && break
done < /etc/passwd

# TAREA 3: Loop infinito
contador=0
while true; do
    echo "Iteración $contador"
    ((contador++))
    [[ $contador -ge 3 ]] && {
        echo "Saliendo del loop infinito"
        break
    }
done

# TAREA 4: Until
contador=1
until [[ $contador -gt 5 ]]; do
    echo "Until: $contador"
    ((contador++))
done

# TAREA 5: Continue
num=0
while [[ $num -lt 10 ]]; do
    ((num++))
    [[ $((num % 2)) -eq 0 ]] && continue
    echo "Impar: $num"
done

# TAREA 6: Sumar hasta negativo
suma=0
while read -r numero; do
    if [[ $numero -lt 0 ]]; then
        echo "⛔ Número negativo encontrado: $numero"
        break
    fi
    suma=$((suma + numero))
    echo "➕ $numero | Total: $suma"
done < /tmp/numeros.txt
echo "Suma final: $suma"

# TAREA 7: Menú
opcion=""
while [[ "$opcion" != "3" ]]; do
    echo ""
    echo "=== MENÚ ==="
    echo "1. Ver fecha"
    echo "2. Ver usuario"
    echo "3. Salir"
    read -p "Selecciona opción: " opcion
    
    case $opcion in
        1) date ;;
        2) whoami ;;
        3) echo "👋 Saliendo..." ;;
        *) echo "❌ Opción inválida" ;;
    esac
done

# TAREA 8: Esperar archivo
archivo="/tmp/test_file_$RANDOM.txt"
intentos=0
echo "Esperando creación de: $archivo"

until [[ -f "$archivo" ]] || [[ $intentos -ge 5 ]]; do
    echo "⏳ Esperando... intento $((intentos+1))"
    sleep 1
    ((intentos++))
    # Simulación: crear en intento 3
    [[ $intentos -eq 3 ]] && touch "$archivo" && echo "✓ Archivo creado"
done

[[ -f "$archivo" ]] && echo "✅ Archivo existe" || echo "❌ Timeout alcanzado"
rm -f "$archivo"
'

# ============================================================================
# EXPLICACIÓN DE CONCEPTOS
# ============================================================================

: '
📚 CONCEPTOS CLAVE:

1. SINTAXIS WHILE:
   while [[ condición ]]; do
       comandos
   done

2. SINTAXIS UNTIL:
   until [[ condición ]]; do
       comandos
   done

3. DIFERENCIAS CLAVE:
   
   while: Ejecuta MIENTRAS condición es verdadera
   until: Ejecuta HASTA QUE condición sea verdadera
   
   Ejemplo:
   i=0
   while [[ $i -lt 5 ]]; do     # Mientras i < 5
       echo $i
       ((i++))
   done
   
   i=0
   until [[ $i -ge 5 ]]; do     # Hasta que i >= 5
       echo $i
       ((i++))
   done
   
   Ambos producen el mismo resultado!

4. LOOPS INFINITOS:
   while true; do       # Siempre verdadero
       # código
       [[ condición ]] && break
   done
   
   while :; do          # : es alias de true
       # código
   done

5. LEER ARCHIVOS LÍNEA POR LÍNEA:
   
   # Método preferido
   while IFS= read -r linea; do
       echo "$linea"
   done < archivo.txt
   
   # Con campos separados
   while IFS=: read -r campo1 campo2 resto; do
       echo "$campo1 | $campo2"
   done < archivo.txt
   
   # ¿Por qué IFS= y -r?
   IFS= : Preserva espacios al inicio/fin
   -r   : No interpreta backslashes

6. CONTROL DE FLUJO:
   break     : Sale del loop inmediatamente
   continue  : Salta a siguiente iteración
   break n   : Sale de n loops anidados
   continue n: Continúa en el n-ésimo loop

7. WHILE VS FOR:
   
   FOR: Usa cuando...
   - Sabes cuántas iteraciones
   - Iteras sobre lista conocida
   - Necesitas índices
   
   WHILE: Usa cuando...
   - Condición variable
   - No sabes cuántas iteraciones
   - Lees archivos línea por línea
   - Esperas evento o condición

8. PATRONES COMUNES:
   
   # Contador
   i=0
   while [[ $i -lt 10 ]]; do
       echo $i
       ((i++))
   done
   
   # Leer archivo
   while read -r line; do
       process "$line"
   done < file
   
   # Menú
   while true; do
       read -p "Opción: " opt
       case $opt in
           q) break ;;
           *) echo "Procesando $opt" ;;
       esac
   done
   
   # Esperar condición
   until [[ -f /tmp/ready ]]; do
       sleep 1
   done
   
   # Reintentos
   intentos=0
   until comando_exitoso || [[ $intentos -ge 3 ]]; do
       ((intentos++))
       sleep 1
   done

9. LECTURA SEGURA:
   
   # ✓ CORRECTO
   while IFS= read -r line; do
       echo "$line"
   done < archivo
   
   # ✗ INCORRECTO (pierde última línea sin \n)
   while read line; do
       echo $line
   done < archivo
   
   # ✓ MEJOR (maneja última línea)
   while IFS= read -r line || [[ -n "$line" ]]; do
       echo "$line"
   done < archivo

10. BUENAS PRÁCTICAS:
    ✓ Usa while para lectura de archivos
    ✓ Usa until cuando condición de salida es más clara
    ✓ Siempre provee salida en loops infinitos
    ✓ Quote variables en comparaciones
    ✓ Usa [[ ]] en vez de [ ]
    ✓ IFS= y -r para lectura precisa
    ✓ Considera timeout en loops de espera

💡 TIPS:
    - while true es más claro que while :
    - until es menos común pero a veces más legible
    - Para menús, considera select en vez de while
    - En loops de espera, añade timeout
    - read sin -r interpreta \ como escape
    - $? tiene el exit code del último comando
'
