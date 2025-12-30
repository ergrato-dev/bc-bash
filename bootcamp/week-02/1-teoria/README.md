# 📚 Teoría - Módulo 2: Comandos Avanzados y Pipes

> **Objetivo**: Dominar el encadenamiento de comandos y el procesamiento de datos

## 🎯 ¿Qué son los Pipes y Comandos Avanzados?

Los **pipes** (`|`) y comandos avanzados permiten:

- Conectar la salida de un comando con la entrada de otro
- Procesar grandes volúmenes de datos
- Crear flujos de transformación complejos
- Filtrar, ordenar y analizar información

## 🤔 ¿Para qué sirven?

### Casos de Uso Reales

- 📊 **Análisis de Logs**: Buscar errores en miles de líneas
- 🔍 **Filtrado de Datos**: Extraer información específica
- 📈 **Reportes**: Generar estadísticas automáticas
- 🧹 **Limpieza**: Procesar y normalizar datos

## 📖 Conceptos Clave

### 1. Pipes (|)

**¿Qué es?** Conecta la salida de un comando con la entrada de otro.

**¿Para qué?** Crear flujos de procesamiento secuenciales.

```bash
# Ver procesos y filtrar
ps aux | grep nginx

# Contar archivos
ls -la | wc -l
```

### 2. Redirección

**¿Qué es?** Controla hacia dónde va la salida de comandos.

**¿Para qué?** Guardar resultados, combinar archivos, descartar errores.

```bash
# Guardar salida
comando > salida.txt

# Agregar a archivo
comando >> archivo.txt

# Redirigir entrada
comando < entrada.txt
```

### 3. grep - Búsqueda

**¿Qué es?** Busca patrones en texto.

**¿Para qué?** Filtrar líneas que contienen texto específico.

```bash
# Buscar en archivo
grep "error" log.txt

# Buscar recursivamente
grep -r "función" *.sh

# Ignorar mayúsculas
grep -i "WARNING" *.log
```

### 4. sed - Edición de Texto

**¿Qué es?** Editor de stream para transformar texto.

**¿Para qué?** Buscar y reemplazar, eliminar líneas, insertar texto.

```bash
# Reemplazar texto
sed 's/antiguo/nuevo/g' archivo.txt

# Eliminar líneas vacías
sed '/^$/d' archivo.txt

# Reemplazar en archivo
sed -i 's/foo/bar/g' archivo.txt
```

### 5. awk - Procesamiento de Columnas

**¿Qué es?** Lenguaje de procesamiento de patrones y texto.

**¿Para qué?** Trabajar con datos tabulares, calcular, filtrar columnas.

```bash
# Imprimir columna
awk '{print $1}' archivo.txt

# Filtrar por condición
awk '$3 > 100' datos.txt

# Sumar columna
awk '{sum+=$2} END {print sum}' numeros.txt
```

### 6. sort - Ordenamiento

**¿Qué es?** Ordena líneas de texto.

**¿Para qué?** Organizar datos alfabéticamente o numéricamente.

```bash
# Ordenar alfabéticamente
sort archivo.txt

# Ordenar números
sort -n numeros.txt

# Ordenar inverso
sort -r archivo.txt
```

### 7. uniq - Líneas Únicas

**¿Qué es?** Filtra líneas duplicadas consecutivas.

**¿Para qué?** Obtener valores únicos, contar ocurrencias.

```bash
# Líneas únicas
sort archivo.txt | uniq

# Contar duplicados
sort archivo.txt | uniq -c

# Solo duplicados
sort archivo.txt | uniq -d
```

### 8. cut - Cortar Columnas

**¿Qué es?** Extrae secciones de cada línea.

**¿Para qué?** Obtener columnas específicas de datos delimitados.

```bash
# Extraer campo
cut -d':' -f1 /etc/passwd

# Columnas 1 y 3
cut -d',' -f1,3 datos.csv

# Caracteres
cut -c1-10 archivo.txt
```

## 🎨 Ejemplos Prácticos

### 1. Top 10 IPs en un Log

```bash
cat access.log | \
    awk '{print $1}' | \
    sort | \
    uniq -c | \
    sort -nr | \
    head -10
```

### 2. Buscar Errores del Día

```bash
grep "$(date +%Y-%m-%d)" /var/log/syslog | \
    grep -i "error" | \
    wc -l
```

### 3. Estadísticas de Archivos

```bash
ls -l | \
    awk '{sum+=$5} END {print "Total:", sum/1024/1024, "MB"}'
```

### 4. Usuarios del Sistema

```bash
cut -d':' -f1 /etc/passwd | \
    sort | \
    head -10
```

## 🔧 Herramientas Complementarias

- **find**: Buscar archivos
- **xargs**: Construir comandos desde entrada
- **tee**: Duplicar salida (archivo + pantalla)
- **head/tail**: Primeras/últimas líneas
- **wc**: Contar líneas, palabras, caracteres

## 🎓 Mejores Prácticas

1. **Usa pipes para legibilidad**: Cada paso en una línea
2. **Combina herramientas**: grep + awk + sort
3. **Valida resultados**: Prueba cada paso del pipe
4. **Documenta pipelines complejos**: Añade comentarios

## ➡️ Siguiente Paso

- **[2-practicas](../2-practicas/README.md)**: Práctica con pipes y filtros
- **[3-proyecto](../3-proyecto/README.md)**: Analizador de logs avanzado

---

**💡 Tip**: Dominar pipes es como dominar el arte de combinar herramientas simples para crear soluciones poderosas.
