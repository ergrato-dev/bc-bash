#!/bin/bash
# Ejemplo 05: Pipeline Completo
# Descripción: Combinar múltiples comandos en un pipeline profesional

# Crear archivo de log de servidor web
cat > temp_access.log << EOF
192.168.1.100 - - [15/Jan/2025:10:23:45] "GET /index.html HTTP/1.1" 200 1234
192.168.1.101 - - [15/Jan/2025:10:24:12] "GET /about.html HTTP/1.1" 200 2345
192.168.1.100 - - [15/Jan/2025:10:24:30] "POST /login HTTP/1.1" 500 456
192.168.1.102 - - [15/Jan/2025:10:25:01] "GET /index.html HTTP/1.1" 200 1234
192.168.1.101 - - [15/Jan/2025:10:25:45] "GET /products.html HTTP/1.1" 404 789
192.168.1.103 - - [15/Jan/2025:10:26:10] "GET /index.html HTTP/1.1" 200 1234
192.168.1.100 - - [15/Jan/2025:10:27:33] "GET /contact.html HTTP/1.1" 200 3456
192.168.1.102 - - [15/Jan/2025:10:28:00] "POST /api/data HTTP/1.1" 500 234
EOF

echo "=== Log de Servidor Web ==="
cat temp_access.log
echo

# === Análisis 1: Top 3 IPs más activas ===
echo "=== Top 3 IPs más activas ==="
cat temp_access.log | \
    awk '{print $1}' | \
    sort | \
    uniq -c | \
    sort -nr | \
    head -3

# === Análisis 2: Errores 4xx y 5xx ===
echo -e "\n=== Errores del servidor ==="
cat temp_access.log | \
    grep -E '" [45][0-9]{2} ' | \
    awk '{print $9, $7}' | \
    sort

# === Análisis 3: URLs más visitadas ===
echo -e "\n=== URLs más visitadas ==="
cat temp_access.log | \
    awk '{print $7}' | \
    sort | \
    uniq -c | \
    sort -nr

# === Análisis 4: Bytes transferidos por IP ===
echo -e "\n=== Bytes transferidos por IP ==="
cat temp_access.log | \
    awk '{ip=$1; bytes=$10; total[ip]+=bytes} 
         END {for(i in total) printf "%s: %d bytes\n", i, total[i]}' | \
    sort -t':' -k2 -nr

# === Análisis 5: Tasa de error por hora ===
echo -e "\n=== Requests por código de respuesta ==="
cat temp_access.log | \
    awk '{print $9}' | \
    sort | \
    uniq -c | \
    awk '{printf "Código %s: %d requests\n", $2, $1}'

# === Análisis 6: Métodos HTTP usados ===
echo -e "\n=== Métodos HTTP ==="
cat temp_access.log | \
    awk '{print $6}' | \
    tr -d '"' | \
    sort | \
    uniq -c

# === Análisis 7: Reporte completo ===
echo -e "\n=== REPORTE COMPLETO ==="
{
    echo "Total de requests:"
    wc -l < temp_access.log
    
    echo -e "\nRequests exitosos (200):"
    grep '" 200 ' temp_access.log | wc -l
    
    echo -e "\nRequests fallidos (4xx/5xx):"
    grep -E '" [45][0-9]{2} ' temp_access.log | wc -l
    
    echo -e "\nTotal bytes transferidos:"
    awk '{sum+=$10} END {printf "%d bytes (%.2f KB)\n", sum, sum/1024}' temp_access.log
}

# Limpiar
rm -f temp_access.log
echo -e "\n✓ Limpieza completada"
