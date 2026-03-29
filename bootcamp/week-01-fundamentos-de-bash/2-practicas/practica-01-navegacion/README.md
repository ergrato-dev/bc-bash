# 🧭 Práctica 01: Navegación del Sistema de Archivos

## 🎯 Objetivos

- Usar `pwd` para conocer la ubicación actual
- Navegar con `cd` entre directorios
- Listar contenidos con `ls` y sus opciones
- Entender rutas absolutas vs relativas

## ⏱️ Duración Estimada

~30 minutos

## 📋 Instrucciones

### Paso 1: Conocer tu Ubicación (pwd)

El comando `pwd` (Print Working Directory) muestra dónde estás:

```bash
pwd
# Salida: /home/usuario/bootcamp/week-01-fundamentos-de-bash/2-practicas
```

**Abre `starter/script.sh`** y descomenta la sección del Paso 1.

---

### Paso 2: Listar Contenidos (ls)

El comando `ls` muestra el contenido de un directorio:

```bash
# Listado simple
ls

# Listado detallado
ls -l

# Mostrar archivos ocultos
ls -a

# Combinar opciones
ls -la
```

**Descomenta** la sección del Paso 2 en `starter/script.sh`.

---

### Paso 3: Cambiar de Directorio (cd)

Navega entre directorios con `cd`:

```bash
# Ir al home
cd ~

# Ir a una ruta absoluta
cd /tmp

# Subir un nivel
cd ..

# Volver al directorio anterior
cd -
```

**Descomenta** la sección del Paso 3 en `starter/script.sh`.

---

### Paso 4: Rutas Absolutas vs Relativas

```bash
# Ruta absoluta (empieza con /)
cd /home/usuario/documentos

# Ruta relativa (desde ubicación actual)
cd documentos/proyectos

# Combinaciones útiles
cd ../..     # Subir dos niveles
cd ./carpeta # Entrar a subcarpeta (el ./ es opcional)
```

**Descomenta** la sección del Paso 4 en `starter/script.sh`.

---

### Paso 5: Crear Estructura de Prueba

Vamos a crear una estructura para practicar:

```bash
# Crear directorios anidados
mkdir -p ~/practica-nav/nivel1/nivel2/nivel3

# Navegar y verificar
cd ~/practica-nav
ls -R   # Listado recursivo
```

**Descomenta** la sección del Paso 5 en `starter/script.sh`.

---

## ✅ Verificación

Ejecuta el script y verifica que funciona:

```bash
./starter/script.sh
```

Deberías ver la salida de cada paso correctamente.

## 📚 Comandos Aprendidos

| Comando  | Descripción               |
| -------- | ------------------------- |
| `pwd`    | Muestra directorio actual |
| `ls`     | Lista contenidos          |
| `ls -l`  | Listado detallado         |
| `ls -a`  | Muestra ocultos           |
| `ls -la` | Detallado + ocultos       |
| `ls -R`  | Listado recursivo         |
| `cd`     | Cambia directorio         |
| `cd ~`   | Va al home                |
| `cd ..`  | Sube un nivel             |
| `cd -`   | Vuelve al anterior        |

## 🎯 Reto Extra

Intenta responder:

1. ¿Cuál es la diferencia entre `ls -l` y `ls -la`?
2. ¿Qué hace `cd` sin argumentos?
3. ¿Cómo llegarías a `/etc` desde cualquier ubicación?

---

[← Volver al índice](../README.md) | [Siguiente: Permisos →](../practica-02-permisos/)
