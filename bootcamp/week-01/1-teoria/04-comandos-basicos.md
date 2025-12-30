# 04 - Comandos Básicos de Manipulación

## 🎯 Objetivos

- Dominar la creación y edición de archivos
- Usar comandos de copia, movimiento y eliminación
- Visualizar contenido de archivos eficientemente
- Buscar archivos y contenido en el sistema

## 📋 Contenido

### 1. Creación de Archivos

#### touch - Crear archivos vacíos

```bash
# Crear un archivo vacío
touch archivo.txt

# Crear múltiples archivos
touch archivo1.txt archivo2.txt archivo3.txt

# Si el archivo existe, actualiza la fecha de modificación
touch archivo_existente.txt
```

> 💡 **Tip**: `touch` nunca sobrescribe contenido existente.

#### Crear archivos con contenido

```bash
# Crear con echo (sobrescribe)
echo "Hola mundo" > archivo.txt

# Agregar contenido (append)
echo "Nueva línea" >> archivo.txt

# Crear archivo multilínea con cat
cat > notas.txt << EOF
Línea 1
Línea 2
Línea 3
EOF
```

### 2. Editores de Texto

#### nano - Editor amigable para principiantes

```bash
nano archivo.txt
```

**Comandos dentro de nano:**

| Tecla    | Acción       |
| -------- | ------------ |
| `Ctrl+O` | Guardar      |
| `Ctrl+X` | Salir        |
| `Ctrl+K` | Cortar línea |
| `Ctrl+U` | Pegar línea  |
| `Ctrl+W` | Buscar       |

#### vim - Editor poderoso

```bash
vim archivo.txt
```

**Modos de vim:**

| Modo      | Cómo entrar | Propósito             |
| --------- | ----------- | --------------------- |
| Normal    | `Esc`       | Navegación y comandos |
| Inserción | `i`         | Escribir texto        |
| Comando   | `:`         | Ejecutar comandos     |

**Comandos esenciales:**

| Comando | Acción            |
| ------- | ----------------- |
| `:w`    | Guardar           |
| `:q`    | Salir             |
| `:wq`   | Guardar y salir   |
| `:q!`   | Salir sin guardar |
| `dd`    | Eliminar línea    |
| `yy`    | Copiar línea      |
| `p`     | Pegar             |

### 3. Copiar, Mover y Eliminar

#### cp - Copiar

```bash
# Copiar archivo
cp original.txt copia.txt

# Copiar a otro directorio
cp archivo.txt /ruta/destino/

# Copiar directorio (recursivo)
cp -r directorio/ directorio_copia/

# Copiar preservando atributos
cp -p archivo.txt copia.txt

# Copiar con confirmación
cp -i archivo.txt destino/
```

#### mv - Mover y renombrar

```bash
# Mover archivo
mv archivo.txt /nueva/ubicacion/

# Renombrar archivo
mv nombre_viejo.txt nombre_nuevo.txt

# Mover y renombrar
mv archivo.txt /destino/nuevo_nombre.txt

# Mover múltiples archivos
mv *.txt directorio/
```

#### rm - Eliminar

```bash
# Eliminar archivo
rm archivo.txt

# Eliminar con confirmación
rm -i archivo.txt

# Eliminar directorio vacío
rmdir directorio/

# Eliminar directorio con contenido
rm -r directorio/

# Forzar eliminación (¡cuidado!)
rm -rf directorio/
```

> ⚠️ **Advertencia**: `rm -rf` es irreversible. ¡Úsalo con extremo cuidado!

### 4. Visualización de Contenido

#### cat - Mostrar todo el contenido

```bash
# Mostrar archivo completo
cat archivo.txt

# Con números de línea
cat -n archivo.txt

# Concatenar múltiples archivos
cat archivo1.txt archivo2.txt > combinado.txt
```

#### less - Navegación por páginas

```bash
less archivo_grande.txt
```

**Navegación en less:**

| Tecla    | Acción                 |
| -------- | ---------------------- |
| `Space`  | Avanzar página         |
| `b`      | Retroceder página      |
| `/texto` | Buscar hacia adelante  |
| `?texto` | Buscar hacia atrás     |
| `n`      | Siguiente coincidencia |
| `q`      | Salir                  |

#### head y tail - Principio y final

```bash
# Primeras 10 líneas (por defecto)
head archivo.txt

# Primeras 20 líneas
head -n 20 archivo.txt

# Últimas 10 líneas
tail archivo.txt

# Últimas 5 líneas
tail -n 5 archivo.txt

# Seguir archivo en tiempo real (logs)
tail -f /var/log/syslog
```

### 5. Búsqueda de Archivos

#### find - Búsqueda potente

```bash
# Buscar por nombre
find /ruta -name "*.txt"

# Buscar ignorando mayúsculas
find /ruta -iname "*.TXT"

# Buscar solo archivos
find /ruta -type f -name "*.sh"

# Buscar solo directorios
find /ruta -type d -name "proyecto*"

# Buscar por tamaño
find /ruta -size +1M      # Mayor a 1MB
find /ruta -size -100k    # Menor a 100KB

# Buscar por fecha de modificación
find /ruta -mtime -7      # Últimos 7 días
find /ruta -mtime +30     # Más de 30 días

# Ejecutar comando en resultados
find /ruta -name "*.tmp" -exec rm {} \;
```

#### locate - Búsqueda rápida (usa índice)

```bash
# Buscar archivo
locate archivo.txt

# Actualizar base de datos (requiere sudo)
sudo updatedb
```

#### which y whereis - Encontrar comandos

```bash
# Ubicación del ejecutable
which bash
# /bin/bash

# Archivos relacionados con un comando
whereis bash
# bash: /bin/bash /usr/share/man/man1/bash.1.gz
```

### 6. Enlaces

#### Enlace simbólico (soft link)

```bash
# Crear enlace simbólico
ln -s /ruta/original archivo_enlace

# Ver a dónde apunta
ls -l archivo_enlace
```

#### Enlace duro (hard link)

```bash
# Crear enlace duro
ln archivo_original enlace_duro
```

**Diferencias:**

| Simbólico                          | Duro                       |
| ---------------------------------- | -------------------------- |
| Puede apuntar a directorios        | Solo archivos              |
| Puede cruzar sistemas de archivos  | Mismo sistema de archivos  |
| Se rompe si el original se elimina | Independiente del original |

### 7. Tabla de Referencia Rápida

| Comando | Propósito          | Ejemplo                  |
| ------- | ------------------ | ------------------------ |
| `touch` | Crear archivo      | `touch nuevo.txt`        |
| `cp`    | Copiar             | `cp a.txt b.txt`         |
| `mv`    | Mover/renombrar    | `mv viejo.txt nuevo.txt` |
| `rm`    | Eliminar           | `rm archivo.txt`         |
| `cat`   | Ver contenido      | `cat archivo.txt`        |
| `less`  | Ver con paginación | `less grande.txt`        |
| `head`  | Ver inicio         | `head -n 5 archivo.txt`  |
| `tail`  | Ver final          | `tail -f log.txt`        |
| `find`  | Buscar archivos    | `find . -name "*.sh"`    |
| `ln -s` | Crear enlace       | `ln -s original enlace`  |

## 📚 Recursos Adicionales

- [GNU Coreutils Manual](https://www.gnu.org/software/coreutils/manual/)
- [Vim Tutorial](https://www.openvim.com/)
- [Find Command Examples](https://www.tecmint.com/35-practical-examples-of-linux-find-command/)

## ✅ Checklist de Verificación

- [ ] Puedo crear archivos con `touch` y `echo`
- [ ] Sé usar `cp`, `mv`, `rm` de forma segura
- [ ] Puedo visualizar archivos con `cat`, `less`, `head`, `tail`
- [ ] Sé buscar archivos con `find`
- [ ] Entiendo la diferencia entre enlaces simbólicos y duros

---

**Anterior**: [03-permisos.md](03-permisos.md) | **Índice**: [README.md](../README.md)
