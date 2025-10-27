# 📚 Teoría - Módulo 5: Operaciones de Archivos y Procesamiento de Texto

> **Objetivo**: Dominar la manipulación de archivos y procesamiento avanzado de texto

## 🎯 ¿Qué son las Operaciones de Archivos?

Conjunto de técnicas para **crear, modificar, analizar y transformar** archivos y su contenido.

## 🤔 ¿Para qué sirven?

### Casos de Uso Reales

- 📊 **Análisis de Logs**: Extraer métricas de millones de líneas
- 🔄 **ETL**: Extraer, transformar y cargar datos
- 📝 **Generación de Reportes**: Crear documentos automáticamente
- 🧹 **Limpieza de Datos**: Normalizar y validar información
- 🔍 **Auditoría**: Inspeccionar y validar archivos de configuración

## 📖 Conceptos Clave

### 1. Manipulación Básica

**¿Qué es?** Operaciones CRUD en archivos.

**¿Para qué?** Gestión fundamental del sistema de archivos.

```bash
# Crear
touch archivo.txt
echo "contenido" > archivo.txt

# Leer
cat archivo.txt
head -n 10 archivo.txt
tail -f log.txt

# Actualizar
echo "nueva línea" >> archivo.txt
sed -i 's/viejo/nuevo/' archivo.txt

# Eliminar
rm archivo.txt
```

### 2. Expresiones Regulares

**¿Qué son?** Patrones para buscar y manipular texto.

**¿Para qué?** Búsquedas complejas, validación, extracción.

```bash
# Buscar emails
grep -E "[a-zA-Z0-9]+@[a-zA-Z]+\.[a-z]+" archivo.txt

# Buscar IPs
grep -E "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" log.txt

# Validar formato
if [[ "$email" =~ ^[a-z]+@[a-z]+\.[a-z]+$ ]]; then
    echo "Email válido"
fi
```

### 3. sed - Stream Editor

**¿Qué es?** Editor no interactivo para transformar texto.

**¿Para qué?** Reemplazos masivos, filtrado, transformación.

```bash
# Reemplazar primera ocurrencia
sed 's/foo/bar/' archivo.txt

# Reemplazar todas
sed 's/foo/bar/g' archivo.txt

# Eliminar líneas vacías
sed '/^$/d' archivo.txt

# Rango de líneas
sed -n '10,20p' archivo.txt

# Múltiples comandos
sed -e 's/foo/bar/' -e 's/baz/qux/' archivo.txt
```

### 4. awk - Procesamiento Columnar

**¿Qué es?** Lenguaje para procesar datos estructurados.

**¿Para qué?** Análisis de CSV, logs, reportes.

```bash
# Imprimir columnas
awk '{print $1, $3}' datos.txt

# Filtrar por condición
awk '$3 > 100 {print $1}' datos.txt

# Sumar columna
awk '{sum+=$2} END {print "Total:", sum}' numeros.txt

# Usar delimitador
awk -F',' '{print $1}' datos.csv

# Formatear salida
awk '{printf "%-10s %5d\n", $1, $2}' datos.txt
```

### 5. find - Búsqueda de Archivos

**¿Qué es?** Busca archivos según criterios.

**¿Para qué?** Localizar archivos, operaciones masivas.

```bash
# Por nombre
find . -name "*.txt"

# Por tipo
find . -type f  # archivos
find . -type d  # directorios

# Por tamaño
find . -size +10M

# Por fecha
find . -mtime -7  # modificados últimos 7 días

# Ejecutar comando
find . -name "*.log" -exec rm {} \;
```

### 6. Procesamiento de CSV

**¿Qué es?** Manejo de datos en formato CSV.

**¿Para qué?** Análisis de datos exportados, reportes.

```bash
# Extraer columna
cut -d',' -f2 datos.csv

# Filtrar filas
awk -F',' '$3 > 1000' ventas.csv

# Estadísticas
awk -F',' '{sum+=$2; count++} END {print sum/count}' datos.csv

# Convertir a JSON
awk -F',' '{printf "{\\"name\\":\\"%s\\",\\"value\\":%d}\\n", $1, $2}' datos.csv
```

### 7. Procesamiento de JSON

**¿Qué es?** Extraer y manipular datos JSON.

**¿Para qué?** APIs, configuración, datos estructurados.

```bash
# Con jq (si está disponible)
jq '.nombre' datos.json
jq '.usuarios[] | .email' datos.json

# Sin jq (básico)
grep -o '"nombre":"[^"]*"' datos.json
```

### 8. Procesamiento de Logs

**¿Qué es?** Análisis de archivos de registro.

**¿Para qué?** Debugging, monitoreo, auditoría.

```bash
# Errores del día
grep "$(date +%Y-%m-%d)" /var/log/syslog | grep ERROR

# Top errores
grep ERROR app.log | \
    awk '{print $NF}' | \
    sort | uniq -c | sort -nr | head -10

# Estadísticas por hora
awk '{print $1}' access.log | \
    cut -d':' -f2 | \
    sort | uniq -c
```

## 🎨 Ejemplos Prácticos

### 1. Analizador de Logs Apache

```bash
#!/bin/bash

log_file="access.log"

echo "=== Análisis de Log Apache ==="

# Total de requests
total=$(wc -l < "$log_file")
echo "Total requests: $total"

# Top 10 IPs
echo -e "\nTop 10 IPs:"
awk '{print $1}' "$log_file" | \
    sort | uniq -c | sort -nr | head -10

# Códigos de respuesta
echo -e "\nCódigos de respuesta:"
awk '{print $9}' "$log_file" | \
    sort | uniq -c | sort -nr

# URLs más visitadas
echo -e "\nTop URLs:"
awk '{print $7}' "$log_file" | \
    sort | uniq -c | sort -nr | head -10
```

### 2. Procesador de CSV a HTML

```bash
#!/bin/bash

csv_file="$1"
html_file="${csv_file%.csv}.html"

echo "<table>" > "$html_file"

# Header
head -1 "$csv_file" | awk -F',' '
{
    print "<tr>"
    for(i=1; i<=NF; i++) print "<th>" $i "</th>"
    print "</tr>"
}' >> "$html_file"

# Datos
tail -n +2 "$csv_file" | awk -F',' '
{
    print "<tr>"
    for(i=1; i<=NF; i++) print "<td>" $i "</td>"
    print "</tr>"
}' >> "$html_file"

echo "</table>" >> "$html_file"
echo "Generado: $html_file"
```

### 3. Limpiador de Datos

```bash
#!/bin/bash

# Eliminar líneas duplicadas
sort -u datos.txt > datos_limpios.txt

# Eliminar líneas vacías
sed -i '/^$/d' datos_limpios.txt

# Normalizar espacios
sed -i 's/  */ /g' datos_limpios.txt

# Eliminar espacios inicio/fin
sed -i 's/^[[:space:]]*//; s/[[:space:]]*$//' datos_limpios.txt

echo "Limpieza completada"
```

## 🔧 Herramientas Complementarias

- **jq**: Procesador JSON
- **xmllint**: Procesador XML
- **tr**: Traducir/eliminar caracteres
- **paste**: Combinar archivos
- **join**: Join de archivos por campo común
- **comm**: Comparar archivos ordenados
- **diff**: Diferencias entre archivos

## 🎓 Mejores Prácticas

1. **Backup antes de modificar**: Siempre copia antes de `-i`
2. **Prueba con head**: Verifica comando con primeras líneas
3. **Usa pipes**: Encadena comandos para legibilidad
4. **Maneja errores**: Verifica existencia de archivos
5. **Documenta regex**: Comenta expresiones regulares complejas

## 📊 Patrones Comunes

### Pipeline de Procesamiento

```bash
# Extraer → Filtrar → Transformar → Agregar
cat datos.txt | \
    grep "patrón" | \
    awk '{print $2}' | \
    sort | uniq -c | \
    sort -nr
```

### Validación de Datos

```bash
# Validar email
validar_email() {
    [[ "$1" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]
}
```

## ➡️ Siguiente Paso

- **[ejemplos/](./ejemplos/)**: Scripts de ejemplo completos
- **[recursos/](./recursos/)**: Datos de práctica
- **[2-ejercicios](../2-ejercicios/README.md)**: Ejercicios prácticos
- **[3-proyectos](../3-proyectos/README.md)**: Analizador de logs profesional

---

**💡 Tip**: El procesamiento de texto es una de las fortalezas de Bash. Dominar sed, awk y grep te convierte en un profesional del procesamiento de datos.
