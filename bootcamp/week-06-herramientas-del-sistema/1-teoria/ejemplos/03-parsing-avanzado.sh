#!/bin/bash
# Ejemplo 03: Parsing Avanzado con Regex y AWK
# Descripción: Técnicas avanzadas de parsing y extracción

echo "=== Parsing Avanzado con Regex y AWK ==="

# === 1. Parsing de logs ===
echo -e "\n=== 1. Parsing de Logs de Apache ==="

cat > access.log << 'EOF'
192.168.1.100 - - [01/Jan/2024:10:15:30 +0000] "GET /index.html HTTP/1.1" 200 1234
192.168.1.101 - - [01/Jan/2024:10:16:45 +0000] "POST /api/users HTTP/1.1" 201 567
192.168.1.102 - - [01/Jan/2024:10:17:20 +0000] "GET /images/logo.png HTTP/1.1" 200 4567
192.168.1.100 - - [01/Jan/2024:10:18:55 +0000] "GET /about.html HTTP/1.1" 404 0
192.168.1.103 - - [01/Jan/2024:10:19:30 +0000] "GET /api/products HTTP/1.1" 200 8901
EOF

echo "Archivo de log:"
cat access.log

echo -e "\nExtraer IPs únicas:"
awk '{print $1}' access.log | sort -u

echo -e "\nContar requests por IP:"
awk '{print $1}' access.log | sort | uniq -c | sort -rn

echo -e "\nExtraer URLs:"
awk '{match($0, /"[A-Z]+ ([^ ]+)/, arr); print arr[1]}' access.log

echo -e "\nContar códigos de estado:"
awk '{print $(NF-1)}' access.log | sort | uniq -c

echo -e "\nRequests con error (4xx, 5xx):"
awk '$(NF-1) ~ /^[45]/ {print $0}' access.log

# === 2. Parsing de emails ===
echo -e "\n=== 2. Extraer Emails ==="

cat > texto_emails.txt << 'EOF'
Contacta con soporte@empresa.com para ayuda.
El equipo de ventas (ventas@empresa.com) está disponible.
Escribe a info@example.org o admin@test.co.uk
Email inválido: noesunmail@
EOF

echo "Texto:"
cat texto_emails.txt

echo -e "\nEmails encontrados:"
grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' texto_emails.txt

# === 3. Parsing de URLs ===
echo -e "\n=== 3. Extraer Componentes de URL ==="

url="https://usuario:pass@www.ejemplo.com:8080/ruta/archivo.html?param1=valor1&param2=valor2#seccion"

echo "URL: $url"

# Extraer protocolo
protocolo=$(echo "$url" | sed -n 's/^\([^:]*\):\/\/.*/\1/p')
echo "Protocolo: $protocolo"

# Extraer dominio
dominio=$(echo "$url" | sed -n 's/.*\/\/\([^:@]*@\)\?\([^:\/]*\).*/\2/p')
echo "Dominio: $dominio"

# Extraer puerto
puerto=$(echo "$url" | sed -n 's/.*:\([0-9]\+\)\/.*/\1/p')
echo "Puerto: ${puerto:-80}"

# Extraer path
path=$(echo "$url" | sed -n 's/[^\/]*\/\/[^\/]*\(\/[^?#]*\).*/\1/p')
echo "Path: $path"

# Extraer query params
query=$(echo "$url" | sed -n 's/.*?\([^#]*\).*/\1/p')
echo "Query: $query"

# === 4. Parsing de XML simple ===
echo -e "\n=== 4. Parsing de XML Simple ==="

cat > datos.xml << 'EOF'
<usuarios>
  <usuario>
    <id>1</id>
    <nombre>Juan</nombre>
    <edad>28</edad>
  </usuario>
  <usuario>
    <id>2</id>
    <nombre>María</nombre>
    <edad>32</edad>
  </usuario>
</usuarios>
EOF

echo "XML:"
cat datos.xml

echo -e "\nExtraer nombres:"
grep -oP '(?<=<nombre>).*(?=</nombre>)' datos.xml 2>/dev/null || \
    sed -n 's/.*<nombre>\(.*\)<\/nombre>.*/\1/p' datos.xml

echo -e "\nExtraer edades:"
sed -n 's/.*<edad>\(.*\)<\/edad>.*/\1/p' datos.xml

# === 5. Parsing de configuración INI ===
echo -e "\n=== 5. Parsing de Archivo INI ==="

cat > config.ini << 'EOF'
[database]
host=localhost
port=5432
user=admin
password=secret123

[server]
host=0.0.0.0
port=8080
workers=4
EOF

echo "Archivo INI:"
cat config.ini

echo -e "\nLeer configuración:"
leer_ini() {
    local archivo=$1
    local seccion=$2
    local clave=$3
    
    awk -v sec="$seccion" -v key="$key" '
    /^\[.*\]$/ { current = substr($0, 2, length($0)-2) }
    /^[^#[]/ && current == sec {
        split($0, arr, "=")
        if (arr[1] ~ key) {
            gsub(/^[ \t]+|[ \t]+$/, "", arr[2])
            print arr[2]
            exit
        }
    }' "$archivo"
}

# Leer valor específico
db_host=$(awk '/^\[database\]/,/^\[/ {if ($0 ~ /^host=/) {split($0, a, "="); print a[2]}}' config.ini)
echo "Database host: $db_host"

db_port=$(awk '/^\[database\]/,/^\[/ {if ($0 ~ /^port=/) {split($0, a, "="); print a[2]}}' config.ini)
echo "Database port: $db_port"

# === 6. Parsing de fechas ===
echo -e "\n=== 6. Parsing y Conversión de Fechas ==="

fechas=(
    "2024-01-15"
    "15/01/2024"
    "Jan 15, 2024"
    "15-Jan-2024"
)

echo "Fechas originales:"
printf '%s\n' "${fechas[@]}"

echo -e "\nConvertir a formato YYYY-MM-DD:"
for fecha in "${fechas[@]}"; do
    # Diferentes formatos
    if [[ "$fecha" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        echo "$fecha (ya en formato correcto)"
    elif [[ "$fecha" =~ ^([0-9]{2})/([0-9]{2})/([0-9]{4})$ ]]; then
        echo "${BASH_REMATCH[3]}-${BASH_REMATCH[2]}-${BASH_REMATCH[1]}"
    else
        echo "$fecha (formato no soportado en este ejemplo)"
    fi
done

# === 7. Parsing de tablas de texto ===
echo -e "\n=== 7. Parsing de Tablas de Texto ==="

cat > tabla.txt << 'EOF'
ID    NOMBRE      EDAD    CIUDAD
1     Juan        28      Madrid
2     María       32      Barcelona
3     Carlos      25      Valencia
EOF

echo "Tabla:"
cat tabla.txt

echo -e "\nExtraer columna NOMBRE:"
awk 'NR > 1 {print $2}' tabla.txt

echo -e "\nFiltrar EDAD > 27:"
awk 'NR == 1 || $3 > 27' tabla.txt

# === 8. Parsing de números y unidades ===
echo -e "\n=== 8. Extraer Números con Unidades ==="

texto="El servidor tiene 16GB de RAM, 500GB de disco y usa 2.5GHz de CPU"

echo "Texto: $texto"

echo -e "\nExtraer números con unidades:"
echo "$texto" | grep -oE '[0-9]+\.?[0-9]*[A-Za-z]+' | while read valor; do
    numero=$(echo "$valor" | grep -oE '[0-9]+\.?[0-9]*')
    unidad=$(echo "$valor" | grep -oE '[A-Za-z]+')
    echo "  $numero $unidad"
done

# === 9. Parsing de código fuente ===
echo -e "\n=== 9. Extraer Funciones de Script ==="

cat > script_ejemplo.sh << 'EOF'
#!/bin/bash
# Script de ejemplo

function saludar() {
    echo "Hola"
}

procesar_datos() {
    local datos=$1
    echo "Procesando..."
}

main() {
    echo "Principal"
}
EOF

echo "Script:"
cat script_ejemplo.sh

echo -e "\nFunciones encontradas:"
grep -oE '(function +)?[a-zA-Z_][a-zA-Z0-9_]* *\(\)' script_ejemplo.sh | \
    sed 's/function //; s/()$//'

# === 10. Parsing de rutas de archivos ===
echo -e "\n=== 10. Descomponer Rutas de Archivos ==="

ruta="/home/usuario/documentos/proyecto/archivo.tar.gz"

echo "Ruta: $ruta"
echo "Directorio: $(dirname "$ruta")"
echo "Nombre completo: $(basename "$ruta")"
echo "Nombre sin extensión: $(basename "$ruta" .tar.gz)"
echo "Extensión: ${ruta##*.}"
echo "Todas las extensiones: ${ruta#*.}"

# === 11. Parsing con AWK avanzado ===
echo -e "\n=== 11. AWK Avanzado: Procesamiento de Logs ==="

cat > app.log << 'EOF'
2024-01-15 10:30:15 INFO Usuario juan inició sesión
2024-01-15 10:31:20 ERROR Fallo en conexión a base de datos
2024-01-15 10:32:45 INFO Usuario maría inició sesión
2024-01-15 10:33:10 WARNING Espacio en disco bajo
2024-01-15 10:34:25 ERROR Timeout en servicio API
EOF

echo "Log:"
cat app.log

echo -e "\nEstadísticas por nivel:"
awk '{count[$4]++} END {for (nivel in count) print nivel ": " count[nivel]}' app.log

echo -e "\nSolo errores:"
awk '$4 == "ERROR"' app.log

# === 12. Regex avanzadas ===
echo -e "\n=== 12. Patrones Regex Complejos ==="

validar_patron() {
    local texto=$1
    local patron=$2
    local descripcion=$3
    
    if [[ "$texto" =~ $patron ]]; then
        echo "✓ $descripcion: '$texto' válido"
    else
        echo "✗ $descripcion: '$texto' inválido"
    fi
}

# IP v4
validar_patron "192.168.1.1" '^([0-9]{1,3}\.){3}[0-9]{1,3}$' "IP"
validar_patron "256.1.1.1" '^([0-9]{1,3}\.){3}[0-9]{1,3}$' "IP"

# Teléfono
validar_patron "+34 666 123 456" '^\+?[0-9]{2} ?[0-9]{3} ?[0-9]{3} ?[0-9]{3}$' "Teléfono"

# Código postal España
validar_patron "28001" '^[0-5][0-9]{4}$' "CP España"

# === 13. Extraer datos entre delimitadores ===
echo -e "\n=== 13. Extraer Datos entre Delimitadores ==="

texto_marcado="Inicio [dato1] medio [dato2] y [dato3] final"

echo "Texto: $texto_marcado"
echo "Extraer entre [ ]:"
echo "$texto_marcado" | grep -oE '\[[^]]+\]' | tr -d '[]'

# Limpiar archivos temporales
rm -f access.log texto_emails.txt datos.xml config.ini tabla.txt
rm -f script_ejemplo.sh app.log

echo -e "\n✓ Script completado"
