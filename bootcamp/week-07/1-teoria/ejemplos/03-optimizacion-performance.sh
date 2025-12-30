#!/bin/bash
# Ejemplo 03: Optimización de Performance
# Descripción: Técnicas para scripts más rápidos

echo "=== Optimización de Performance ==="

# === 1. Evitar subshells innecesarios ===
echo -e "\n=== 1. Subshells vs Operaciones Internas ==="

# ❌ Lento: Usa subshell
tiempo_inicio=$SECONDS
for i in {1..1000}; do
    resultado=$(echo $((i * 2)))
done
tiempo_lento=$((SECONDS - tiempo_inicio))

# ✅ Rápido: Operación interna
tiempo_inicio=$SECONDS
for i in {1..1000}; do
    resultado=$((i * 2))
done
tiempo_rapido=$((SECONDS - tiempo_inicio))

echo "Con subshell: ${tiempo_lento}s"
echo "Sin subshell: ${tiempo_rapido}s"

# === 2. Uso eficiente de cat ===
echo -e "\n=== 2. Cat Innecesario ==="

# Crear archivo de prueba
echo "línea 1\nlínea 2\nlínea 3" > temp_test.txt

# ❌ Ineficiente
echo "Ineficiente:"
time cat temp_test.txt | grep "línea"

# ✅ Eficiente
echo -e "\nEficiente:"
time grep "línea" temp_test.txt

# === 3. Operaciones de strings internas ===
echo -e "\n=== 3. Manipulación de Strings ==="

texto="archivo.txt"

# ❌ Lento: Usar comandos externos
tiempo_inicio=$(date +%s%N)
for i in {1..100}; do
    resultado=$(echo "$texto" | sed 's/.txt/.log/')
done
tiempo_sed=$(($(date +%s%N) - tiempo_inicio))

# ✅ Rápido: Bash interno
tiempo_inicio=$(date +%s%N)
for i in {1..100}; do
    resultado="${texto%.txt}.log"
done
tiempo_bash=$(($(date +%s%N) - tiempo_inicio))

echo "Con sed: ${tiempo_sed}ns"
echo "Bash interno: ${tiempo_bash}ns"

# === 4. Arrays vs bucles múltiples ===
echo -e "\n=== 4. Arrays para Datos ==="

# Crear datos de prueba
cat > temp_datos.txt << EOF
dato1
dato2
dato3
dato4
dato5
EOF

# ✅ Cargar en array una vez
mapfile -t datos < temp_datos.txt

echo "Datos en array:"
for dato in "${datos[@]}"; do
    echo "  - $dato"
done

# === 5. Caché de resultados ===
echo -e "\n=== 5. Memoización/Caché ==="

declare -A cache

factorial_con_cache() {
    local n=$1
    
    # Verificar caché
    if [ -n "${cache[$n]}" ]; then
        echo "${cache[$n]}"
        return
    fi
    
    # Calcular
    if [ "$n" -le 1 ]; then
        cache[$n]=1
        echo 1
    else
        local temp=$((n - 1))
        local resultado_previo=$(factorial_con_cache "$temp")
        local resultado=$((n * resultado_previo))
        cache[$n]=$resultado
        echo "$resultado"
    fi
}

echo "Factorial 5: $(factorial_con_cache 5)"
echo "Factorial 6 (usa caché): $(factorial_con_cache 6)"

# === 6. Paralelización simple ===
echo -e "\n=== 6. Procesamiento Paralelo ==="

procesar_archivo() {
    local archivo=$1
    sleep 0.1  # Simular procesamiento
    echo "Procesado: $archivo"
}

# Crear archivos de prueba
for i in {1..5}; do
    echo "contenido" > "temp_file_$i.txt"
done

echo "Procesamiento secuencial:"
tiempo_inicio=$SECONDS
for archivo in temp_file_*.txt; do
    procesar_archivo "$archivo"
done
tiempo_secuencial=$((SECONDS - tiempo_inicio))
echo "Tiempo: ${tiempo_secuencial}s"

echo -e "\nProcesamiento paralelo:"
tiempo_inicio=$SECONDS
for archivo in temp_file_*.txt; do
    procesar_archivo "$archivo" &
done
wait
tiempo_paralelo=$((SECONDS - tiempo_inicio))
echo "Tiempo: ${tiempo_paralelo}s"

# Limpiar
rm -f temp_test.txt temp_datos.txt temp_file_*.txt

echo -e "\n✓ Optimización demostrada"
echo "💡 Tip: Usa operaciones internas de Bash cuando sea posible"
