#!/bin/bash
# Ejemplo 02: Procesamiento de JSON
# Descripción: Manipulación de JSON con y sin jq

echo "=== Procesamiento de JSON ==="

# === 1. Crear JSON de ejemplo ===
echo -e "\n=== 1. Crear JSON de Ejemplo ==="

cat > datos.json << 'EOF'
{
  "empresa": "TechCorp",
  "fundacion": 2010,
  "activa": true,
  "empleados": [
    {
      "id": 1,
      "nombre": "Juan Pérez",
      "edad": 28,
      "departamento": "IT",
      "salario": 35000,
      "habilidades": ["Python", "Bash", "Docker"]
    },
    {
      "id": 2,
      "nombre": "María García",
      "edad": 32,
      "departamento": "Marketing",
      "salario": 42000,
      "habilidades": ["SEO", "Analytics", "Content"]
    },
    {
      "id": 3,
      "nombre": "Carlos López",
      "edad": 25,
      "departamento": "IT",
      "salario": 28000,
      "habilidades": ["JavaScript", "React", "Node.js"]
    }
  ],
  "oficinas": {
    "madrid": {"empleados": 15, "tamaño": "grande"},
    "barcelona": {"empleados": 8, "tamaño": "mediano"},
    "valencia": {"empleados": 5, "tamaño": "pequeño"}
  }
}
EOF

echo "✓ Archivo datos.json creado"

# === 2. Parsear JSON con grep/sed (sin jq) ===
echo -e "\n=== 2. Parsear sin JQ (método básico) ==="

# Extraer valor simple
empresa=$(grep -o '"empresa"[^,]*' datos.json | sed 's/"empresa": *"\(.*\)"/\1/')
echo "Empresa: $empresa"

# Extraer número
fundacion=$(grep -o '"fundacion"[^,]*' datos.json | sed 's/"fundacion": *\([0-9]*\)/\1/')
echo "Fundación: $fundacion"

# === 3. Función para extraer valores JSON ===
echo -e "\n=== 3. Función Personalizada para JSON ==="

json_extract() {
    local json=$1
    local key=$2
    echo "$json" | grep -o "\"$key\"[^,}]*" | sed "s/\"$key\": *\"\?\([^\"]*\)\"\?/\1/" | head -1
}

json_content=$(cat datos.json)
echo "Empresa: $(json_extract "$json_content" "empresa")"
echo "Activa: $(json_extract "$json_content" "activa")"

# === 4. Contar elementos en array ===
echo -e "\n=== 4. Contar Empleados ==="

num_empleados=$(grep -c '"id":' datos.json)
echo "Total de empleados en JSON: $num_empleados"

# === 5. Extraer array de nombres ===
echo -e "\n=== 5. Lista de Nombres ==="

grep -o '"nombre": *"[^"]*"' datos.json | sed 's/"nombre": *"\([^"]*\)"/\1/'

# === 6. Filtrar por condición ===
echo -e "\n=== 6. Empleados de IT ==="

# Extraer empleados con awk
awk '
/"departamento": "IT"/ {
    match($0, /"nombre": "([^"]*)"/, arr)
    if (arr[1]) print arr[1]
}
' datos.json

# === 7. Calcular estadísticas ===
echo -e "\n=== 7. Estadísticas de Salarios ==="

grep -o '"salario": [0-9]*' datos.json | cut -d' ' -f2 | awk '
{
    sum += $1
    count++
    if (NR == 1 || $1 > max) max = $1
    if (NR == 1 || $1 < min) min = $1
}
END {
    print "Promedio: " sum/count
    print "Máximo: " max
    print "Mínimo: " min
}'

# === 8. Verificar si existe jq ===
echo -e "\n=== 8. Ejemplos con JQ (si está disponible) ==="

if command -v jq &> /dev/null; then
    echo "✓ jq está instalado"
    
    # Extraer valor simple
    echo -e "\nEmpresa con jq:"
    jq -r '.empresa' datos.json
    
    # Extraer array
    echo -e "\nNombres con jq:"
    jq -r '.empleados[].nombre' datos.json
    
    # Filtrar
    echo -e "\nEmpleados de IT con jq:"
    jq -r '.empleados[] | select(.departamento == "IT") | .nombre' datos.json
    
    # Transformar
    echo -e "\nSalarios aumentados 10%:"
    jq '.empleados[].salario *= 1.1' datos.json | grep -o '"salario": [0-9]*' | head -3
    
    # Consulta compleja
    echo -e "\nSalario promedio con jq:"
    jq '[.empleados[].salario] | add / length' datos.json
    
else
    echo "⚠ jq no está instalado"
    echo "  Instalar: sudo apt install jq (Ubuntu/Debian)"
    echo "           sudo yum install jq (CentOS/RHEL)"
    echo "           brew install jq (macOS)"
fi

# === 9. Crear JSON desde Bash ===
echo -e "\n=== 9. Generar JSON desde Variables ==="

generar_json() {
    local nombre=$1
    local edad=$2
    local activo=$3
    
    cat << EOF
{
  "nombre": "$nombre",
  "edad": $edad,
  "activo": $activo,
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
}

echo "JSON generado:"
generar_json "Pedro" 30 true

# === 10. Construir JSON con array ===
echo -e "\n=== 10. Construir JSON con Array ==="

crear_json_array() {
    local items=("$@")
    
    echo "["
    for i in "${!items[@]}"; do
        [ $i -gt 0 ] && echo ","
        echo "  {"
        echo "    \"id\": $((i + 1)),"
        echo "    \"valor\": \"${items[$i]}\""
        echo -n "  }"
    done
    echo ""
    echo "]"
}

echo "Array JSON:"
crear_json_array "uno" "dos" "tres"

# === 11. Validar JSON ===
echo -e "\n=== 11. Validar JSON ==="

validar_json() {
    local archivo=$1
    
    # Método 1: Con jq (si existe)
    if command -v jq &> /dev/null; then
        if jq empty "$archivo" 2>/dev/null; then
            echo "✓ JSON válido (verificado con jq)"
            return 0
        else
            echo "✗ JSON inválido"
            return 1
        fi
    fi
    
    # Método 2: Con Python (si existe)
    if command -v python3 &> /dev/null; then
        if python3 -c "import json; json.load(open('$archivo'))" 2>/dev/null; then
            echo "✓ JSON válido (verificado con Python)"
            return 0
        else
            echo "✗ JSON inválido"
            return 1
        fi
    fi
    
    # Método 3: Verificación básica
    local abre=$(grep -o '{' "$archivo" | wc -l)
    local cierra=$(grep -o '}' "$archivo" | wc -l)
    
    if [ "$abre" -eq "$cierra" ]; then
        echo "✓ JSON aparentemente válido (llaves balanceadas)"
        return 0
    else
        echo "✗ JSON posiblemente inválido (llaves desbalanceadas)"
        return 1
    fi
}

validar_json datos.json

# === 12. Modificar JSON ===
echo -e "\n=== 12. Modificar Valores en JSON ==="

# Cambiar valor con sed
echo "Cambiar empresa a 'NewTech':"
sed 's/"empresa": "TechCorp"/"empresa": "NewTech"/' datos.json | grep -o '"empresa"[^,]*'

# === 13. Merge de JSONs ===
echo -e "\n=== 13. Combinar JSONs ==="

cat > extra.json << 'EOF'
{
  "pais": "España",
  "moneda": "EUR"
}
EOF

if command -v jq &> /dev/null; then
    echo "Merge con jq:"
    jq -s '.[0] * .[1]' datos.json extra.json | head -10
else
    echo "Merge manual (básico):"
    echo "{"
    grep -v '^{$\|^}$' datos.json | sed '$ s/$/,/'
    grep -v '^{$\|^}$' extra.json
    echo "}"
fi

# === 14. Pretty print JSON ===
echo -e "\n=== 14. Formatear JSON ==="

# JSON en una línea
echo '{"nombre":"Juan","edad":30,"ciudad":"Madrid"}' > compacto.json

if command -v jq &> /dev/null; then
    echo "Formateado con jq:"
    jq '.' compacto.json
elif command -v python3 &> /dev/null; then
    echo "Formateado con Python:"
    python3 -m json.tool compacto.json
else
    echo "Formateado manual (básico):"
    sed 's/,/,\n  /g; s/{/{\n  /g; s/}/\n}/g' compacto.json
fi

# === 15. Convertir JSON a CSV ===
echo -e "\n=== 15. Convertir JSON a CSV ==="

if command -v jq &> /dev/null; then
    echo "CSV generado:"
    jq -r '.empleados[] | [.id, .nombre, .edad, .departamento, .salario] | @csv' datos.json | head -3
else
    echo "Conversión manual:"
    echo "id,nombre,edad,departamento,salario"
    grep -A 5 '"id":' datos.json | grep -E '"(id|nombre|edad|departamento|salario)"' | \
        sed 's/.*": //; s/[",]//g; s/ *$//' | paste -sd ',' | head -1
fi

# Limpiar archivos temporales
rm -f datos.json extra.json compacto.json

echo -e "\n✓ Script completado"
