# 🔗 Pipes y Redirección

## 🎯 Objetivos

- Entender los flujos de datos: stdin, stdout, stderr
- Dominar la redirección de salida (`>`, `>>`)
- Controlar la redirección de errores (`2>`, `&>`)
- Conectar comandos con pipes (`|`)

## 📋 Contenido

![Pipes y Redirección](../0-assets/01-pipes-redireccion.svg)

### 1. Los Tres Flujos de Datos

Todo programa en Unix/Linux tiene tres canales de comunicación:

| Flujo      | Descriptor | Descripción      | Por defecto |
| ---------- | ---------- | ---------------- | ----------- |
| **stdin**  | 0          | Entrada estándar | Teclado     |
| **stdout** | 1          | Salida estándar  | Pantalla    |
| **stderr** | 2          | Errores estándar | Pantalla    |

```bash
# stdout: salida normal
ls /home          # Muestra contenido por stdout

# stderr: errores
ls /inexistente   # Muestra error por stderr

# stdin: entrada
read nombre       # Lee del teclado (stdin)
```

### 2. Redirección de Salida (stdout)

#### Sobrescribir con `>`

```bash
# Crear/sobrescribir archivo con salida
ls -la > listado.txt

# ⚠️ CUIDADO: sobrescribe completamente
echo "Línea 1" > archivo.txt
echo "Línea 2" > archivo.txt   # Borra línea 1
cat archivo.txt                 # Solo muestra "Línea 2"
```

#### Añadir con `>>`

```bash
# Añadir al final sin sobrescribir
echo "Primera línea" > archivo.txt
echo "Segunda línea" >> archivo.txt
echo "Tercera línea" >> archivo.txt

cat archivo.txt
# Primera línea
# Segunda línea
# Tercera línea
```

### 3. Redirección de Errores (stderr)

```bash
# Redirigir errores a archivo
ls /inexistente 2> errores.txt

# Separar salida normal de errores
ls /home /inexistente > salida.txt 2> errores.txt

# Descartar errores (enviar a /dev/null)
ls /home /inexistente 2>/dev/null
```

### 4. Redirección Combinada

```bash
# Método 1: stdout y stderr al mismo archivo
comando > todo.txt 2>&1

# Método 2: sintaxis moderna (Bash 4+)
comando &> todo.txt

# Método 3: añadir ambos
comando >> todo.txt 2>&1
comando &>> todo.txt
```

> 💡 **Nota**: `2>&1` significa "redirige stderr (2) al mismo destino que stdout (1)"

### 5. Redirección de Entrada (stdin)

```bash
# Leer desde archivo en lugar de teclado
sort < desordenado.txt

# Equivalente a:
cat desordenado.txt | sort

# Here Document: entrada multilínea
cat << EOF
Línea 1
Línea 2
Línea 3
EOF

# Here String: entrada de una línea
cat <<< "Texto directo"
```

### 6. Pipes: Conectar Comandos

El pipe (`|`) conecta la salida de un comando con la entrada del siguiente:

```bash
# Sin pipes (archivos temporales)
ls > temp.txt
sort temp.txt > resultado.txt
rm temp.txt

# Con pipes (directo)
ls | sort > resultado.txt
```

#### Ejemplos Prácticos

```bash
# Contar archivos en directorio
ls | wc -l

# Buscar proceso específico
ps aux | grep nginx

# Top 5 archivos más grandes
ls -lS | head -5

# Usuarios únicos ordenados
cut -d: -f1 /etc/passwd | sort | uniq

# Pipeline complejo
cat access.log | grep "404" | awk '{print $1}' | sort | uniq -c | sort -rn | head -10
```

### 7. Comando `tee`: Dividir el Flujo

`tee` permite ver la salida Y guardarla en archivo simultáneamente:

```bash
# Ver y guardar al mismo tiempo
ls -la | tee listado.txt

# Continuar el pipeline después de guardar
ls -la | tee listado.txt | wc -l

# Añadir en lugar de sobrescribir
echo "Nueva línea" | tee -a registro.txt
```

### 8. Comando `xargs`: Construir Comandos

`xargs` convierte la entrada en argumentos para otro comando:

```bash
# Crear múltiples archivos
echo "a.txt b.txt c.txt" | xargs touch

# Buscar y eliminar archivos .tmp
find . -name "*.tmp" | xargs rm

# Con nombres que tienen espacios
find . -name "*.txt" -print0 | xargs -0 ls -la

# Ejecutar comando por cada línea
cat urls.txt | xargs -I {} curl -O {}
```

## 📚 Tabla Resumen

| Operador | Función             | Ejemplo                     |
| -------- | ------------------- | --------------------------- | ----- | ------- |
| `>`      | Sobrescribir stdout | `ls > archivo.txt`          |
| `>>`     | Añadir stdout       | `echo "más" >> archivo.txt` |
| `2>`     | Redirigir stderr    | `cmd 2> errores.txt`        |
| `2>>`    | Añadir stderr       | `cmd 2>> errores.txt`       |
| `&>`     | stdout + stderr     | `cmd &> todo.txt`           |
| `2>&1`   | stderr a stdout     | `cmd > todo.txt 2>&1`       |
| `<`      | Leer de archivo     | `sort < datos.txt`          |
| `        | `                   | Pipe (conectar)             | `cmd1 | cmd2`   |
| `        | &`                  | Pipe stdout+stderr          | `cmd1 | & cmd2` |

## ✅ Checklist de Verificación

- [ ] Entiendo la diferencia entre stdout y stderr
- [ ] Puedo redirigir salida a archivos con `>` y `>>`
- [ ] Puedo capturar errores con `2>`
- [ ] Puedo combinar stdout y stderr con `&>`
- [ ] Puedo crear pipelines con `|`
- [ ] Sé usar `tee` para dividir el flujo
- [ ] Entiendo cómo funciona `xargs`

---

[← Volver al índice](README.md) | [Siguiente: grep y Filtrado →](02-grep-filtrado.md)
