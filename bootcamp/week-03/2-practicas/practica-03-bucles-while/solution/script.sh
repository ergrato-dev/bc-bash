#!/bin/bash
# ============================================
# Práctica 03: Bucles while y until
# Semana 3 - Variables y Control de Flujo
# SOLUCIÓN COMPLETA
# ============================================

echo "=== Práctica 03: Bucles while y until ==="
echo ""

# ============================================
# PASO 1: Contador con while
# ============================================
echo "--- Paso 1: Contador ---"

contador=1
while [[ $contador -le 5 ]]; do
    echo "Contador: $contador"
    ((contador++))
done

echo ""

# ============================================
# PASO 2: Cuenta Regresiva
# ============================================
echo "--- Paso 2: Cuenta Regresiva ---"

cuenta=5
while [[ $cuenta -gt 0 ]]; do
    echo "$cuenta..."
    ((cuenta--))
    sleep 0.2  # Pequeña pausa para efecto visual
done
echo "🚀 ¡Despegue!"

echo ""

# ============================================
# PASO 3: until - Hasta que sea verdadero
# ============================================
echo "--- Paso 3: until ---"

intentos=0
until [[ $intentos -ge 3 ]]; do
    echo "Intento: $((intentos + 1))"
    ((intentos++))
done
echo "Máximo de intentos alcanzado"

echo ""

# ============================================
# PASO 4: Acumulador - Suma de Números
# ============================================
echo "--- Paso 4: Acumulador ---"

suma=0
i=1
while [[ $i -le 10 ]]; do
    ((suma += i))
    ((i++))
done
echo "Suma de 1 a 10: $suma"

echo ""

# ============================================
# PASO 5: Leer Archivo Línea por Línea
# ============================================
echo "--- Paso 5: Leer Archivo ---"

# Creamos un archivo temporal para el ejemplo
cat > /tmp/ejemplo_lectura.txt << 'EOF'
Primera línea
Segunda línea
Tercera línea
EOF

echo "Contenido del archivo:"
while IFS= read -r linea; do
    echo "  > $linea"
done < /tmp/ejemplo_lectura.txt

echo ""

# ============================================
# PASO 6: while con Pipe
# ============================================
echo "--- Paso 6: while con Pipe ---"

echo -e "manzana\nnaranja\nplátano" | while read fruta; do
    echo "Fruta: $fruta"
done

echo ""

# ============================================
# PASO 7: Bucle Infinito Controlado
# ============================================
echo "--- Paso 7: Bucle Infinito ---"

contador=0
while true; do
    ((contador++))
    echo "Iteración: $contador"
    if [[ $contador -ge 5 ]]; then
        echo "Límite alcanzado, saliendo..."
        break
    fi
done

echo ""

# ============================================
# PASO 8: continue en while
# ============================================
echo "--- Paso 8: continue ---"

echo "Números impares del 1 al 10:"
num=0
while [[ $num -lt 10 ]]; do
    ((num++))
    if [[ $((num % 2)) -eq 0 ]]; then
        continue  # Saltar números pares
    fi
    echo -n "$num "
done
echo ""  # Nueva línea

echo ""

# ============================================
# PASO 9: Simulación de Validación
# ============================================
echo "--- Paso 9: Validación ---"

entrada=""
intentos=0
max_intentos=3

while [[ -z "$entrada" && $intentos -lt $max_intentos ]]; do
    ((intentos++))
    # Simulamos entrada en el intento 2
    if [[ $intentos -eq 2 ]]; then
        entrada="dato_válido"
        echo "Intento $intentos: Dato ingresado ✓"
    else
        echo "Intento $intentos: Sin dato..."
    fi
done

if [[ -n "$entrada" ]]; then
    echo "Resultado: $entrada"
else
    echo "Se agotaron los intentos"
fi

echo ""

# ============================================
# PASO 10: Comparación while vs until
# ============================================
echo "--- Paso 10: Comparación ---"

echo -n "while (i <= 3): "
i=1
while [[ $i -le 3 ]]; do
    echo -n "$i "
    ((i++))
done
echo ""

echo -n "until (j > 3):  "
j=1
until [[ $j -gt 3 ]]; do
    echo -n "$j "
    ((j++))
done
echo ""
echo "Mismo resultado, diferente lógica"

echo ""
echo "✅ ¡Práctica completada!"

# Limpieza
rm -f /tmp/ejemplo_lectura.txt 2>/dev/null
