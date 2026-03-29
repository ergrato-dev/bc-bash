# 🔄 Práctica 01: Gestión de Procesos

> **Objetivo**: Dominar comandos de gestión y control de procesos

---

## 📚 Recursos Visuales

![Gestión de Procesos](../../0-assets/01-procesos-gestion.svg)

---

## 📋 Contenido

### Paso 1: Listar Procesos con ps

El comando `ps` muestra información sobre procesos activos:

```bash
# Formato estándar UNIX
ps -ef

# Formato BSD (más común)
ps aux

# Solo mis procesos
ps -u $USER
```

**Abre `starter/script.sh`** y descomenta la sección correspondiente.

---

### Paso 2: Árbol de Procesos

Visualiza la jerarquía de procesos:

```bash
# Árbol con ps
ps -ef --forest

# Con pstree (si está disponible)
pstree -p

# Procesos de un usuario
pstree -u $USER
```

**Descomenta el Paso 2** en el script.

---

### Paso 3: Buscar Procesos con pgrep

Busca procesos por nombre o patrón:

```bash
# Buscar por nombre
pgrep bash

# Con nombre completo
pgrep -a bash

# Por usuario
pgrep -u root
```

**Descomenta el Paso 3** en el script.

---

### Paso 4: Información Detallada con top

Obtener snapshot de procesos más consumidores:

```bash
# Snapshot sin interactivo
top -bn1 | head -20

# Solo procesos ordenados por CPU
ps aux --sort=-%cpu | head -10

# Ordenados por memoria
ps aux --sort=-%mem | head -10
```

**Descomenta el Paso 4** en el script.

---

### Paso 5: Jobs y Background

Gestiona procesos en background:

```bash
# Ejecutar en background
sleep 60 &

# Listar jobs
jobs

# Ver PID de último background
echo $!

# Traer al foreground
fg %1
```

**Descomenta el Paso 5** en el script.

---

### Paso 6: Señales y kill

Envía señales a procesos:

```bash
# SIGTERM (terminar limpio)
kill PID

# SIGKILL (forzar)
kill -9 PID

# Matar por nombre
pkill -f "patrón"

# Listar señales
kill -l
```

**Descomenta el Paso 6** en el script.

---

## ✅ Verificación

```bash
cd starter && chmod +x script.sh && ./script.sh
```

Deberías ver la salida de cada paso mostrando información de procesos.

---

## 🔗 Navegación

← [Índice](../) | [Práctica 02 →](../practica-02-cron/)
