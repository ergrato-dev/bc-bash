# 📚 Teoría - Semana 1: Fundamentos de Bash

## 📋 Contenido

Esta carpeta contiene el material teórico de la Semana 1, organizado en 4 temas principales.

## 🗂️ Archivos de Teoría

| #   | Archivo                                                    | Tema                             | Duración |
| --- | ---------------------------------------------------------- | -------------------------------- | -------- |
| 01  | [01-introduccion-terminal.md](01-introduccion-terminal.md) | Introducción al Terminal y Shell | 20 min   |
| 02  | [02-sistema-archivos.md](02-sistema-archivos.md)           | Sistema de Archivos Unix/Linux   | 25 min   |
| 03  | [03-permisos.md](03-permisos.md)                           | Sistema de Permisos              | 25 min   |
| 04  | [04-comandos-basicos.md](04-comandos-basicos.md)           | Comandos Básicos de Manipulación | 20 min   |

**Tiempo total estimado**: ~1.5 horas

## 🎯 Objetivos de Aprendizaje

Al completar esta sección teórica, serás capaz de:

- ✅ Entender la diferencia entre terminal, consola y shell
- ✅ Navegar el sistema de archivos con confianza
- ✅ Dominar el sistema de permisos Unix/Linux
- ✅ Crear y manipular archivos y directorios
- ✅ Buscar archivos en el sistema

## 📖 Orden de Estudio Recomendado

```
01-introduccion-terminal.md
         ↓
02-sistema-archivos.md
         ↓
03-permisos.md
         ↓
04-comandos-basicos.md
         ↓
   [Prácticas]
```

## 📁 Carpeta de Ejemplos

La carpeta `ejemplos/` contiene scripts de demostración que complementan la teoría.

## 📚 Recursos Adicionales

- [GNU Bash Manual](https://www.gnu.org/software/bash/manual/)
- [Linux Command Line Basics](https://ubuntu.com/tutorials/command-line-for-beginners)
- [ShellCheck](https://www.shellcheck.net/) - Validador de scripts

---

**Siguiente paso**: [2-practicas/](../2-practicas/README.md)
nombre="Juan"
echo "Hola $nombre" # Usa la variable

````

### 3. Comandos Básicos

**¿Qué son?** Instrucciones que le damos al sistema.

**¿Para qué?** Realizar operaciones como listar archivos, crear carpetas, mover datos.

```bash
ls        # Listar archivos
pwd       # Mostrar directorio actual
cd dir    # Cambiar de directorio
mkdir dir # Crear directorio
````

### 4. Scripts

**¿Qué son?** Archivos de texto con una secuencia de comandos.

**¿Para qué?** Automatizar tareas que requieren múltiples pasos.

```bash
#!/bin/bash
# Mi primer script

echo "Iniciando proceso..."
fecha=$(date)
echo "Fecha actual: $fecha"
echo "Proceso completado!"
```

### 5. Permisos

**¿Qué son?** Controles de acceso a archivos y directorios.

**¿Para qué?** Seguridad y control sobre quién puede leer, escribir o ejecutar archivos.

```bash
# Hacer un script ejecutable
chmod +x mi_script.sh

# Ver permisos
ls -l mi_script.sh
```

## 🎨 Casos de Uso Reales

### 1. Backup Automatizado

**Problema**: Necesito hacer copias de seguridad diarias  
**Solución**: Script que copia archivos importantes

```bash
#!/bin/bash
backup_dir="/backup/$(date +%Y%m%d)"
mkdir -p "$backup_dir"
cp -r /ruta/importante/* "$backup_dir/"
echo "Backup completado en $backup_dir"
```

### 2. Limpieza de Archivos Temporales

**Problema**: Los archivos temp ocupan mucho espacio  
**Solución**: Script que elimina archivos antiguos

```bash
#!/bin/bash
find /tmp -type f -mtime +7 -delete
echo "Archivos temporales eliminados"
```

### 3. Reporte de Sistema

**Problema**: Necesito revisar el estado del servidor  
**Solución**: Script que genera reporte rápido

```bash
#!/bin/bash
echo "=== Reporte del Sistema ==="
echo "Fecha: $(date)"
echo "Espacio en disco:"
df -h /
echo "Memoria:"
free -h
```

## 🔑 Conceptos Fundamentales

### Entrada y Salida

- **stdin** (0): Entrada estándar (teclado)
- **stdout** (1): Salida estándar (pantalla)
- **stderr** (2): Salida de errores

```bash
# Redirigir salida a archivo
echo "Hola" > archivo.txt

# Redirigir errores
comando 2> errores.log

# Redirigir todo
comando &> todo.log
```

### Variables Especiales

```bash
$0  # Nombre del script
$1  # Primer argumento
$#  # Número de argumentos
$@  # Todos los argumentos
$?  # Código de salida del último comando
$$  # PID del proceso actual
```

## 🎓 Principios de Buenas Prácticas

### 1. Siempre usar Shebang

```bash
#!/bin/bash
# Indica qué intérprete usar
```

### 2. Comentar el código

```bash
# Esto explica qué hace el código
# Es esencial para mantenimiento
```

### 3. Usar nombres descriptivos

```bash
# ❌ Mal
x="archivo"

# ✅ Bien
nombre_archivo="datos.txt"
```

### 4. Validar errores

```bash
# Detener si hay error
set -e

# Validar que existe un archivo
if [ ! -f "$archivo" ]; then
    echo "Error: archivo no existe"
    exit 1
fi
```

### 5. Usar comillas

```bash
# ❌ Puede fallar si hay espacios
echo $variable

# ✅ Seguro
echo "$variable"
```

## 📝 Sintaxis Básica

### Estructura de un Script

```bash
#!/bin/bash
# Título: Mi Script
# Descripción: Qué hace el script
# Autor: Tu nombre
# Fecha: 2025-01-01

# Configuración
set -euo pipefail  # Modo estricto

# Variables
variable="valor"

# Lógica principal
echo "Inicio del script"

# Más código...

echo "Fin del script"
exit 0
```

## 🚀 Ventajas de Dominar Bash

1. **Productividad**: Automatiza tareas tediosas
2. **Portabilidad**: Funciona en casi todos los sistemas Unix/Linux
3. **Poder**: Acceso completo al sistema
4. **Eficiencia**: Scripts ligeros y rápidos
5. **Demanda**: Habilidad muy valorada en el mercado

## 🎯 Lo que Aprenderás

Al finalizar esta semana podrás:

- ✅ Escribir scripts básicos de Bash
- ✅ Usar variables y comandos fundamentales
- ✅ Gestionar archivos y directorios
- ✅ Entender permisos y ejecución
- ✅ Crear herramientas simples pero útiles

## 📚 Recursos Adicionales

### Comandos Esenciales a Memorizar

- `echo` - Mostrar texto
- `ls` - Listar contenido
- `cd` - Cambiar directorio
- `pwd` - Directorio actual
- `mkdir` - Crear directorio
- `rm` - Eliminar
- `cp` - Copiar
- `mv` - Mover/Renombrar
- `cat` - Ver contenido
- `chmod` - Cambiar permisos

### Archivos Importantes

- `/etc/` - Configuración del sistema
- `/home/` - Directorios de usuarios
- `/tmp/` - Archivos temporales
- `/var/log/` - Logs del sistema

## ➡️ Siguiente Paso

Una vez comprendida la teoría, continúa con:

- **[2-practicas](../2-practicas/README.md)**: Práctica guiada paso a paso
- **[3-proyecto](../3-proyecto/README.md)**: Aplicación en proyectos reales

---

**💡 Recuerda**: La teoría es la base, pero la práctica es lo que consolida el conocimiento. ¡Avanza a los ejercicios cuando te sientas listo!
