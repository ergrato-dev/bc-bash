# 📚 Teoría - Módulo 6: Manipulación Avanzada de Datos

> **Objetivo**: Procesar formatos de datos complejos y crear pipelines de transformación

## 🎯 ¿Qué es la Manipulación Avanzada de Datos?

Técnicas para **procesar, transformar y analizar** datos en formatos estructurados (JSON, XML, YAML) y realizar operaciones complejas.

## 🤔 ¿Para qué sirve?

### Casos de Uso Profesionales

- 🔄 **Integración de APIs**: Consumir y transformar datos JSON
- 📊 **ETL Empresarial**: Extraer, transformar, cargar datos
- 📈 **Análisis de Datos**: Generar reportes y métricas
- 🔧 **DevOps**: Procesar configuraciones y deployments
- 🧪 **Testing**: Validar formatos y estructuras de datos

## 📖 Conceptos Clave

### 1. JSON Processing

**¿Qué es?** Manejo del formato de datos más usado en APIs.

**¿Para qué?** Extraer datos, transformar estructuras, validar.

```bash
# Con jq (herramienta especializada)
jq '.' datos.json                    # Pretty print
jq '.usuarios[0].nombre' datos.json  # Extraer campo
jq '.[] | select(.edad > 18)' datos.json  # Filtrar

# Sin jq (métodos básicos)
grep -o '"nombre":"[^"]*"' datos.json | cut -d'"' -f4
```

### 2. Arrays Multidimensionales

**¿Qué son?** Estructuras de datos complejas en Bash.

**¿Para qué?** Almacenar y procesar datos relacionales.

```bash
# Simulación de array 2D
declare -A matriz

matriz[0,0]="A1"
matriz[0,1]="A2"
matriz[1,0]="B1"
matriz[1,1]="B2"

# Acceder
echo ${matriz[0,1]}  # A2
```

### 3. Data Pipelines

**¿Qué son?** Secuencias de transformaciones de datos.

**¿Para qué?** Procesar datos en múltiples etapas.

```bash
# Pipeline completo
cat datos_raw.txt | \
    # 1. Limpiar
    sed 's/[[:space:]]*$//' | \
    # 2. Filtrar
    grep -v "^#" | \
    # 3. Transformar
    awk '{print toupper($0)}' | \
    # 4. Ordenar
    sort -u \
    > datos_procesados.txt
```

### 4. Agregaciones y Estadísticas

**¿Qué es?** Calcular métricas sobre conjuntos de datos.

**¿Para qué?** Reportes, análisis, monitoreo.

```bash
# Estadísticas básicas
awk '{
    sum+=$1
    count++
    if($1>max) max=$1
    if(min=="" || $1<min) min=$1
}
END {
    print "Suma:", sum
    print "Promedio:", sum/count
    print "Máximo:", max
    print "Mínimo:", min
}' numeros.txt
```

### 5. Joins y Merges

**¿Qué son?** Combinar datos de múltiples fuentes.

**¿Para qué?** Relacionar información de diferentes archivos.

```bash
# Join por campo común
join -t',' -1 1 -2 1 usuarios.csv pedidos.csv

# Merge de archivos
paste -d',' archivo1.txt archivo2.txt
```

### 6. Transformaciones Complejas

**¿Qué son?** Conversiones entre formatos y estructuras.

**¿Para qué?** Adaptar datos entre sistemas.

```bash
# CSV to JSON
awk -F',' 'NR>1 {
    printf "{\\"id\\":%d,\\"nombre\\":\\"%s\\",\\"edad\\":%d},\n",
           $1, $2, $3
}' datos.csv | sed '$ s/,$//'

# JSON to CSV
jq -r '.[] | [.id, .nombre, .edad] | @csv' datos.json
```

## 🎨 Ejemplos Prácticos

### 1. Procesador de Datos de Ventas

```bash
#!/bin/bash

# Archivo: ventas.csv (fecha,producto,cantidad,precio)

echo "=== Análisis de Ventas ==="

# Total de ventas por producto
echo -e "\nVentas por Producto:"
awk -F',' 'NR>1 {
    producto[$2]+=$3
}
END {
    for(p in producto) {
        printf "%s: %d unidades\n", p, producto[p]
    }
}' ventas.csv | sort -t':' -k2 -nr

# Ingresos por día
echo -e "\nIngresos Diarios:"
awk -F',' 'NR>1 {
    ingresos[$1]+=$3*$4
}
END {
    for(fecha in ingresos) {
        printf "%s: $%.2f\n", fecha, ingresos[fecha]
    }
}' ventas.csv | sort
```

### 2. Integración de API

```bash
#!/bin/bash

# Obtener datos de API
response=$(curl -s "https://api.ejemplo.com/usuarios")

# Procesar JSON
echo "$response" | jq -r '.usuarios[] |
    select(.activo == true) |
    "\(.id),\(.nombre),\(.email)"' > usuarios_activos.csv

echo "Usuarios activos exportados"
```

### 3. Conversor de Formatos

```bash
#!/bin/bash

# CSV a formato de tabla Markdown
csv_to_markdown() {
    local archivo=$1

    # Header
    head -1 "$archivo" | awk -F',' '{
        for(i=1; i<=NF; i++) printf "| %s ", $i
        printf "|\n"
        for(i=1; i<=NF; i++) printf "|---"
        printf "|\n"
    }'

    # Datos
    tail -n +2 "$archivo" | awk -F',' '{
        for(i=1; i<=NF; i++) printf "| %s ", $i
        printf "|\n"
    }'
}

csv_to_markdown datos.csv > tabla.md
```

### 4. Validador de Datos

```bash
#!/bin/bash

validar_csv() {
    local archivo=$1
    local errores=0

    # Verificar columnas
    columnas=$(head -1 "$archivo" | awk -F',' '{print NF}')

    tail -n +2 "$archivo" | while IFS=',' read -r campos; do
        local num=$(echo "$campos" | awk -F',' '{print NF}')

        if [ "$num" -ne "$columnas" ]; then
            echo "Error: Línea con $num columnas (esperadas: $columnas)"
            ((errores++))
        fi
    done

    if [ $errores -eq 0 ]; then
        echo "✓ Validación exitosa"
    else
        echo "✗ $errores errores encontrados"
    fi
}
```

## 🔧 Técnicas Avanzadas

### 1. Memoización

```bash
# Cache de resultados
declare -A cache

calcular_con_cache() {
    local key=$1

    if [ -n "${cache[$key]}" ]; then
        echo "${cache[$key]}"
    else
        # Cálculo costoso
        local resultado=$(operacion_compleja "$key")
        cache[$key]=$resultado
        echo "$resultado"
    fi
}
```

### 2. Procesamiento Paralelo

```bash
# Procesar archivos en paralelo
for archivo in *.csv; do
    procesar_archivo "$archivo" &
done
wait
echo "Todos los archivos procesados"
```

### 3. Stream Processing

```bash
# Procesar datos en tiempo real
tail -f log.txt | while read linea; do
    if [[ "$linea" =~ ERROR ]]; then
        echo "[ALERTA] $linea" | mail -s "Error" admin@ejemplo.com
    fi
done
```

## 📊 Patrones de Diseño

### ETL Pattern

```bash
# Extract
extraer_datos() {
    curl -s "$API_URL" > raw_data.json
}

# Transform
transformar_datos() {
    jq '.resultados[] | {id, nombre, valor}' raw_data.json > transformed.json
}

# Load
cargar_datos() {
    jq -r '.[] | [.id, .nombre, .valor] | @csv' transformed.json > final.csv
}

# Pipeline
extraer_datos && transformar_datos && cargar_datos
```

### Data Aggregation Pattern

```bash
agregar_por_categoria() {
    awk -F',' '{
        categoria=$2
        suma[categoria]+=$3
        count[categoria]++
    }
    END {
        for(cat in suma) {
            promedio=suma[cat]/count[cat]
            printf "%s: total=%d, promedio=%.2f\n",
                   cat, suma[cat], promedio
        }
    }' "$1"
}
```

## 🎓 Mejores Prácticas

1. **Valida entrada**: Siempre verifica formato de datos
2. **Maneja errores**: Usa `set -e` y validaciones
3. **Documenta transformaciones**: Comenta cada paso
4. **Usa herramientas especializadas**: jq para JSON, xmllint para XML
5. **Testing**: Prueba con datos reales y edge cases
6. **Performance**: Considera volumen de datos

## 🔍 Herramientas Especializadas

- **jq**: Procesador JSON (imprescindible)
- **xmllint**: Procesador XML
- **yq**: Procesador YAML
- **csvkit**: Suite completa para CSV
- **miller**: Procesador de datos similar a sed/awk

## ➡️ Siguiente Paso

- **[ejemplos/](./ejemplos/)**: Scripts de procesamiento avanzado
- **[recursos/](./recursos/)**: Datasets de práctica
- **[2-practicas](../2-practicas/README.md)**: Ejercicios con datos reales
- **[3-proyecto](../3-proyecto/README.md)**: Sistema ETL empresarial

---

**💡 Tip**: La manipulación avanzada de datos es lo que diferencia scripts simples de herramientas profesionales. Dominar JSON y pipelines complejos abre las puertas al mundo DevOps.
