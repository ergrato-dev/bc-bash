# 📚 Ejemplos - Módulo 1: Fundamentos de Bash

Colección de scripts ejecutables que demuestran los conceptos básicos de Bash.

## 🎯 Cómo usar estos ejemplos

```bash
# Hacer ejecutables
chmod +x *.sh

# Ejecutar un ejemplo
./01-hola-mundo.sh

# Ver el código
cat 01-hola-mundo.sh
```

## 📋 Lista de Ejemplos

### 01 - Hola Mundo

**Archivo**: `01-hola-mundo.sh`  
**Concepto**: Primer script, uso de `echo`, comillas  
**Ejecutar**: `./01-hola-mundo.sh`

```bash
# Muestra mensajes básicos
# Diferencia entre comillas simples y dobles
# Uso de variables en echo
```

### 02 - Variables

**Archivo**: `02-variables.sh`  
**Concepto**: Declaración, tipos, operaciones con variables  
**Ejecutar**: `./02-variables.sh`

```bash
# Variables de texto y números
# Variables del sistema ($USER, $HOME)
# Operaciones aritméticas
# Variables de solo lectura
```

### 03 - Argumentos

**Archivo**: `03-argumentos.sh`  
**Concepto**: Parámetros del script, $1, $2, $@  
**Ejecutar**: `./03-argumentos.sh Juan 25 Madrid`

```bash
# $0, $1, $2, ... $N
# $# (número de argumentos)
# $@ (todos los argumentos)
# Valores por defecto
```

### 04 - Archivos Básicos

**Archivo**: `04-archivos-basicos.sh`  
**Concepto**: Crear, leer, copiar, mover archivos  
**Ejecutar**: `./04-archivos-basicos.sh`

```bash
# touch, echo >, echo >>
# cat, head, tail
# cp, mv, rm
# Información de archivos
```

### 05 - Permisos

**Archivo**: `05-permisos.sh`  
**Concepto**: chmod, permisos numéricos y simbólicos  
**Ejecutar**: `./05-permisos.sh`

```bash
# chmod +x
# Permisos numéricos (755, 644, 600)
# Permisos simbólicos (u+x, g+r)
# Verificar permisos (-r, -w, -x)
```

## 🎓 Orden Recomendado

1. `01-hola-mundo.sh` - Empezar aquí
2. `02-variables.sh` - Variables básicas
3. `03-argumentos.sh` - Parámetros
4. `04-archivos-basicos.sh` - Operaciones con archivos
5. `05-permisos.sh` - Sistema de permisos

## 💡 Tips

- **Lee el código**: Cada script está comentado
- **Experimenta**: Modifica los scripts
- **Practica**: Crea tus propias variaciones
- **Depura**: Usa `bash -x script.sh` para debug

## 🔗 Siguiente Paso

Una vez dominados estos ejemplos, continúa con:

- **[../2-ejercicios/](../../2-ejercicios/README.md)**: Ejercicios prácticos
- **[../3-proyectos/](../../3-proyectos/README.md)**: Proyectos completos
