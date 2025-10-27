# 📚 Ejemplos - Módulo 2: Comandos Avanzados y Pipes

Colección de scripts que demuestran el poder de los pipes y comandos de procesamiento de texto.

## 🎯 Cómo usar estos ejemplos

```bash
# Hacer ejecutables
chmod +x *.sh

# Ejecutar un ejemplo
./01-pipes-basicos.sh

# Ver el código
cat 01-pipes-basicos.sh
```

## 📋 Lista de Ejemplos

### 01 - Pipes Básicos

**Archivo**: `01-pipes-basicos.sh`  
**Concepto**: Conectar comandos con | (pipe)  
**Aprenderás**: cat | grep | cut | sort | wc

```bash
# Pipeline simple
cat archivo | grep "patrón" | wc -l

# Pipeline multi-línea legible
cat archivo | \
    filtro1 | \
    filtro2 | \
    resultado
```

### 02 - Grep (Búsqueda)

**Archivo**: `02-grep-busqueda.sh`  
**Concepto**: Buscar patrones en texto  
**Aprenderás**: grep, grep -i, grep -v, grep -E

```bash
# Buscar texto
grep "ERROR" log.txt

# Con regex
grep -E "[0-9]{3}" archivo.txt

# Invertir búsqueda
grep -v "INFO" log.txt
```

### 03 - Sed (Editor)

**Archivo**: `03-sed-editor.sh`  
**Concepto**: Transformar texto  
**Aprenderás**: sed 's//', sed '/d', sed -i

```bash
# Reemplazar
sed 's/viejo/nuevo/g' archivo.txt

# Eliminar líneas
sed '/patrón/d' archivo.txt

# Modificar archivo
sed -i 's/foo/bar/g' archivo.txt
```

### 04 - Awk (Columnas)

**Archivo**: `04-awk-columnas.sh`  
**Concepto**: Procesar datos tabulares  
**Aprenderás**: awk '{print}', awk condiciones, agregaciones

```bash
# Imprimir columna
awk '{print $1}' datos.csv

# Filtrar y calcular
awk '$3 > 100 {sum+=$2} END {print sum}' datos.txt

# Formatear salida
awk '{printf "%-10s %5d\n", $1, $2}' datos.txt
```

### 05 - Pipeline Completo

**Archivo**: `05-pipeline-completo.sh`  
**Concepto**: Análisis real de logs  
**Aprenderás**: Combinar grep | awk | sort | uniq

```bash
# Análisis complejo
cat access.log | \
    awk '{print $1}' | \
    sort | \
    uniq -c | \
    sort -nr | \
    head -10
```

## 🎓 Orden Recomendado

1. `01-pipes-basicos.sh` - Fundamentos de pipes
2. `02-grep-busqueda.sh` - Buscar texto
3. `03-sed-editor.sh` - Transformar texto
4. `04-awk-columnas.sh` - Procesar columnas
5. `05-pipeline-completo.sh` - Todo integrado

## 💡 Comandos Clave

### Pipes y Redirección

```bash
comando1 | comando2     # Pipe
comando > archivo       # Sobrescribir
comando >> archivo      # Agregar
comando < archivo       # Input desde archivo
```

### Grep

```bash
grep "patrón" archivo   # Buscar
grep -i "texto"         # Case-insensitive
grep -v "excluir"       # Invertir
grep -E "regex"         # Expresiones regulares
grep -c "contar"        # Contar coincidencias
```

### Sed

```bash
sed 's/old/new/'        # Primera ocurrencia
sed 's/old/new/g'       # Todas las ocurrencias
sed '/patrón/d'         # Eliminar líneas
sed -n '10,20p'         # Líneas 10-20
```

### Awk

```bash
awk '{print $1}'        # Primera columna
awk -F',' '{print $2}'  # Delimitador personalizado
awk '$3>100'            # Filtrar
awk '{sum+=$1} END {print sum}'  # Sumar
```

## 🔧 Herramientas Complementarias

- **cut**: Extraer columnas
- **sort**: Ordenar líneas
- **uniq**: Líneas únicas
- **head/tail**: Primeras/últimas líneas
- **wc**: Contar líneas/palabras/caracteres
- **tr**: Traducir caracteres

## 🚀 Casos de Uso Reales

### Análisis de Logs

```bash
# Top 10 IPs
awk '{print $1}' access.log | sort | uniq -c | sort -nr | head -10

# Errores del día
grep "$(date +%Y-%m-%d)" /var/log/syslog | grep ERROR
```

### Procesamiento de Datos

```bash
# CSV a tabla
column -t -s',' data.csv

# Suma de columna
awk -F',' '{sum+=$3} END {print sum}' ventas.csv
```

## 🔗 Siguiente Paso

- **[../../2-ejercicios/](../../2-ejercicios/README.md)**: Ejercicios prácticos
- **[../../3-proyectos/](../../3-proyectos/README.md)**: Analizador de logs avanzado
