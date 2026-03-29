# ✏️ sed - Stream Editor

## 🎯 Objetivos

- Entender qué es sed y cómo funciona
- Dominar sustituciones básicas y avanzadas
- Eliminar, insertar y transformar líneas
- Usar sed en pipelines de procesamiento

## 📋 Contenido

![sed - Stream Editor](../0-assets/03-sed-transformacion.svg)

### 1. ¿Qué es sed?

**S**tream **Ed**itor - Editor de flujo que procesa texto línea por línea, aplicando transformaciones sin abrir el archivo en un editor.

```bash
# Sintaxis básica
sed 'comando' archivo.txt

# Desde stdin
echo "hola mundo" | sed 's/hola/hello/'

# Múltiples comandos
sed -e 'cmd1' -e 'cmd2' archivo.txt
sed 'cmd1; cmd2' archivo.txt
```

### 2. Sustitución: El Comando `s`

La operación más común en sed es la sustitución:

```bash
# Sintaxis: s/patrón/reemplazo/flags
sed 's/antiguo/nuevo/' archivo.txt
```

#### Flags de Sustitución

| Flag       | Descripción                    | Ejemplo                 |
| ---------- | ------------------------------ | ----------------------- |
| `g`        | Global (todas las ocurrencias) | `s/a/A/g`               |
| `i`        | Ignorar mayúsculas/minúsculas  | `s/hello/hola/i`        |
| `p`        | Imprimir línea modificada      | `s/error/ERROR/p`       |
| `1,2,3...` | N-ésima ocurrencia             | `s/a/A/2` (solo la 2da) |

```bash
# Solo primera ocurrencia por línea
echo "aaa" | sed 's/a/X/'        # Xaa

# Todas las ocurrencias
echo "aaa" | sed 's/a/X/g'       # XXX

# Solo la segunda ocurrencia
echo "aaa" | sed 's/a/X/2'       # aXa

# Ignorar mayúsculas
echo "Hola HOLA hola" | sed 's/hola/hello/gi'  # hello hello hello
```

### 3. Delimitadores Alternativos

Cuando el patrón contiene `/`, usa otro delimitador:

```bash
# Problema: rutas con /
sed 's/\/home\/user/\/opt\/app/' archivo.txt  # Confuso

# Solución: usar otro delimitador
sed 's|/home/user|/opt/app|' archivo.txt      # Más claro
sed 's#/home/user#/opt/app#' archivo.txt      # También válido
sed 's@/home/user@/opt/app@' archivo.txt      # Cualquier carácter
```

### 4. Ejemplos Prácticos de Sustitución

```bash
# Crear archivo de prueba
cat > datos.txt << 'EOF'
nombre: Juan Pérez
email: juan@ejemplo.com
ciudad: Madrid
nombre: María García
email: maria@ejemplo.com
ciudad: Barcelona
EOF

# Cambiar dominio de email
sed 's/@ejemplo.com/@empresa.com/g' datos.txt

# Poner nombres en mayúsculas (con & = texto coincidente)
sed 's/nombre: .*/\U&/' datos.txt

# Eliminar espacios al inicio de línea
sed 's/^[[:space:]]*//' archivo.txt

# Eliminar espacios al final de línea
sed 's/[[:space:]]*$//' archivo.txt

# Eliminar espacios al inicio Y final
sed 's/^[[:space:]]*//; s/[[:space:]]*$//' archivo.txt
```

### 5. Grupos de Captura

Usa `\(` y `\)` para capturar partes del patrón:

```bash
# Intercambiar orden: "apellido, nombre" → "nombre apellido"
echo "Pérez, Juan" | sed 's/\(.*\), \(.*\)/\2 \1/'
# Resultado: Juan Pérez

# Extraer partes de una fecha
echo "2024-01-15" | sed 's/\([0-9]*\)-\([0-9]*\)-\([0-9]*\)/Año:\1 Mes:\2 Día:\3/'

# Duplicar palabra
echo "hola" | sed 's/\(.*\)/\1 \1/'
# Resultado: hola hola

# Añadir prefijo a números
echo "archivo123.txt" | sed 's/\([0-9]\+\)/NUM_\1/'
# Resultado: archivoNUM_123.txt
```

### 6. Eliminar Líneas: Comando `d`

```bash
# Eliminar líneas que contienen patrón
sed '/ERROR/d' log.txt

# Eliminar líneas vacías
sed '/^$/d' archivo.txt

# Eliminar comentarios (líneas que empiezan con #)
sed '/^#/d' config.txt

# Eliminar línea específica por número
sed '5d' archivo.txt           # Elimina línea 5
sed '1,3d' archivo.txt         # Elimina líneas 1 a 3
sed '$d' archivo.txt           # Elimina última línea

# Eliminar desde patrón hasta el final
sed '/INICIO/,$d' archivo.txt
```

### 7. Imprimir Líneas: Comando `p`

```bash
# Por defecto sed imprime todo; -n suprime esto
sed -n '5p' archivo.txt        # Solo línea 5
sed -n '1,10p' archivo.txt     # Líneas 1 a 10
sed -n '/ERROR/p' archivo.txt  # Solo líneas con ERROR

# Imprimir rango entre patrones
sed -n '/INICIO/,/FIN/p' archivo.txt

# Imprimir líneas pares
sed -n '2~2p' archivo.txt

# Imprimir líneas impares
sed -n '1~2p' archivo.txt
```

### 8. Insertar y Añadir Texto

```bash
# Insertar ANTES de la línea (i)
sed '3i\Texto insertado' archivo.txt

# Añadir DESPUÉS de la línea (a)
sed '3a\Texto añadido' archivo.txt

# Insertar antes de líneas que coinciden
sed '/ERROR/i\=== ATENCIÓN ===' log.txt

# Añadir después de líneas que coinciden
sed '/ERROR/a\--- Fin del error ---' log.txt
```

### 9. Modificar Archivos In-Place

```bash
# Modificar archivo directamente
sed -i 's/antiguo/nuevo/g' archivo.txt

# Con backup automático
sed -i.bak 's/antiguo/nuevo/g' archivo.txt
# Crea archivo.txt.bak con el original

# macOS requiere extensión explícita
sed -i '' 's/antiguo/nuevo/g' archivo.txt  # Sin backup en macOS
```

> ⚠️ **Cuidado**: `-i` modifica el archivo original. Siempre haz backup o prueba primero sin `-i`.

### 10. Direcciones y Rangos

```bash
# Por número de línea
sed '5s/foo/bar/' archivo.txt      # Solo línea 5
sed '1,10s/foo/bar/' archivo.txt   # Líneas 1 a 10

# Por patrón
sed '/inicio/s/foo/bar/' archivo.txt           # Líneas con "inicio"
sed '/inicio/,/fin/s/foo/bar/' archivo.txt     # Desde "inicio" hasta "fin"

# Negación (!)
sed '/comentario/!s/foo/bar/' archivo.txt      # Excepto líneas con "comentario"

# Última línea
sed '$s/foo/bar/' archivo.txt
```

### 11. Múltiples Comandos

```bash
# Con -e
sed -e 's/uno/1/' -e 's/dos/2/' -e 's/tres/3/' archivo.txt

# Con punto y coma
sed 's/uno/1/; s/dos/2/; s/tres/3/' archivo.txt

# Con archivo de script
cat > transformaciones.sed << 'EOF'
s/uno/1/g
s/dos/2/g
s/tres/3/g
/eliminar/d
EOF
sed -f transformaciones.sed archivo.txt
```

## 📊 Casos de Uso Reales

### Procesar Configuraciones

```bash
# Cambiar puerto en config
sed -i 's/port=8080/port=3000/' config.ini

# Descomentar línea
sed -i 's/^#ServerName/ServerName/' apache.conf

# Comentar línea
sed -i 's/^ServerName/#ServerName/' apache.conf
```

### Procesar Logs

```bash
# Anonimizar IPs
sed 's/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/XXX.XXX.XXX.XXX/g' access.log

# Extraer solo timestamps
sed -n 's/^\[\([^]]*\)\].*/\1/p' log.txt

# Convertir formato de fecha
sed 's/\([0-9]\{2\}\)\/\([0-9]\{2\}\)\/\([0-9]\{4\}\)/\3-\1-\2/g' fechas.txt
```

### Procesar CSV

```bash
# Cambiar delimitador de coma a tab
sed 's/,/\t/g' datos.csv

# Eliminar primera columna
sed 's/^[^,]*,//' datos.csv

# Añadir comillas a campos
sed 's/\([^,]*\)/"\1"/g' datos.csv
```

## 📚 Referencia Rápida

| Comando      | Función                      |
| ------------ | ---------------------------- |
| `s/a/b/`     | Sustituir primera ocurrencia |
| `s/a/b/g`    | Sustituir todas              |
| `d`          | Eliminar línea               |
| `p`          | Imprimir línea               |
| `i\texto`    | Insertar antes               |
| `a\texto`    | Añadir después               |
| `c\texto`    | Reemplazar línea completa    |
| `y/abc/ABC/` | Transliterar caracteres      |

## ✅ Checklist de Verificación

- [ ] Puedo hacer sustituciones con `s/old/new/`
- [ ] Conozco los flags g, i, p
- [ ] Puedo usar delimitadores alternativos
- [ ] Sé usar grupos de captura `\(...\)`
- [ ] Puedo eliminar líneas con `d`
- [ ] Entiendo `-i` para edición in-place
- [ ] Puedo aplicar comandos a rangos de líneas

---

[← Anterior: grep](02-grep-filtrado.md) | [Siguiente: awk →](04-awk-procesamiento.md)
