# 📁 Práctica 03: Comandos Básicos de Archivos

## 🎯 Objetivos

- Crear archivos con `touch` y contenido con `echo`
- Copiar con `cp` y mover/renombrar con `mv`
- Eliminar con `rm` y `rmdir`
- Ver contenido con `cat`, `head`, `tail`
- Buscar archivos con `find`

## ⏱️ Duración Estimada

~45 minutos

## 📋 Instrucciones

### Paso 1: Crear Archivos (touch y echo)

```bash
# touch crea archivos vacíos o actualiza fecha
touch archivo.txt

# echo puede crear archivos con contenido
echo "Hola mundo" > saludo.txt      # Sobrescribe
echo "Más texto" >> saludo.txt      # Añade al final

# Crear múltiples archivos
touch file1.txt file2.txt file3.txt
```

**Abre `starter/script.sh`** y descomenta la sección del Paso 1.

---

### Paso 2: Copiar Archivos (cp)

```bash
# Copiar archivo
cp origen.txt destino.txt

# Copiar a directorio
cp archivo.txt carpeta/

# Copiar manteniendo atributos
cp -p original.txt copia.txt

# Copiar directorio recursivamente
cp -r carpeta_origen/ carpeta_destino/

# Copiar con confirmación
cp -i archivo.txt destino.txt
```

**Descomenta** la sección del Paso 2 en `starter/script.sh`.

---

### Paso 3: Mover y Renombrar (mv)

```bash
# Mover archivo
mv archivo.txt carpeta/

# Renombrar archivo
mv nombre_viejo.txt nombre_nuevo.txt

# Mover múltiples archivos
mv *.txt carpeta_destino/

# Mover con confirmación
mv -i archivo.txt destino/
```

**Descomenta** la sección del Paso 3 en `starter/script.sh`.

---

### Paso 4: Eliminar (rm y rmdir)

```bash
# Eliminar archivo
rm archivo.txt

# Eliminar con confirmación
rm -i archivo.txt

# Eliminar directorio vacío
rmdir carpeta_vacia/

# Eliminar directorio con contenido
rm -r carpeta/

# ⚠️ CUIDADO: Forzar eliminación (peligroso)
rm -rf carpeta/
```

**Descomenta** la sección del Paso 4 en `starter/script.sh`.

---

### Paso 5: Ver Contenido (cat, head, tail)

```bash
# Ver archivo completo
cat archivo.txt

# Ver con números de línea
cat -n archivo.txt

# Ver primeras 10 líneas
head archivo.txt

# Ver primeras N líneas
head -n 5 archivo.txt

# Ver últimas 10 líneas
tail archivo.txt

# Ver últimas N líneas
tail -n 5 archivo.txt

# Seguir archivo en tiempo real (logs)
tail -f /var/log/syslog
```

**Descomenta** la sección del Paso 5 en `starter/script.sh`.

---

### Paso 6: Buscar Archivos (find)

```bash
# Buscar por nombre
find /home -name "*.txt"

# Buscar por tipo (f=archivo, d=directorio)
find . -type f -name "*.sh"

# Buscar por tamaño
find . -size +1M      # Mayor a 1MB
find . -size -100k    # Menor a 100KB

# Buscar por fecha de modificación
find . -mtime -7      # Modificados últimos 7 días

# Ejecutar comando en resultados
find . -name "*.tmp" -exec rm {} \;
```

**Descomenta** la sección del Paso 6 en `starter/script.sh`.

---

## ✅ Verificación

```bash
./starter/script.sh
./solution/script.sh
```

## 📚 Resumen de Comandos

| Comando | Uso                | Opciones Comunes          |
| ------- | ------------------ | ------------------------- |
| `touch` | Crear/actualizar   | -                         |
| `cp`    | Copiar             | `-r`, `-p`, `-i`          |
| `mv`    | Mover/renombrar    | `-i`                      |
| `rm`    | Eliminar           | `-r`, `-f`, `-i`          |
| `rmdir` | Eliminar dir vacío | -                         |
| `cat`   | Ver contenido      | `-n`                      |
| `head`  | Ver inicio         | `-n N`                    |
| `tail`  | Ver final          | `-n N`, `-f`              |
| `find`  | Buscar             | `-name`, `-type`, `-exec` |

## ⚠️ Advertencias de Seguridad

```bash
# ❌ NUNCA ejecutar esto:
rm -rf /           # Borra todo el sistema
rm -rf ~           # Borra tu home
rm -rf *           # Borra directorio actual

# ✅ SIEMPRE verificar antes:
ls archivo.txt     # Verificar que existe
rm -i archivo.txt  # Pedir confirmación
```

## 🎯 Reto Extra

1. Crea una estructura de carpetas para un proyecto
2. Copia archivos entre carpetas
3. Usa `find` para localizar archivos `.sh`
4. Limpia archivos temporales con `find -exec rm`

---

[← Anterior: Permisos](../practica-02-permisos/) | [Volver al índice →](../README.md)
