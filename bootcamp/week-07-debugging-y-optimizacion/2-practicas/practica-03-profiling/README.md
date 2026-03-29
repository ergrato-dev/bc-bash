# ⚡ Práctica 03: Profiling y Optimización

> **Objetivo**: Medir rendimiento y optimizar scripts Bash

---

## 📚 Recursos Visuales

![Profiling](../../0-assets/03-profiling-optimizacion.svg)

---

## 📋 Contenido

### Paso 1: Medir con time

El comando `time` mide el tiempo de ejecución:

```bash
time ./script.sh

# real: tiempo total (wall clock)
# user: tiempo CPU en modo usuario
# sys:  tiempo CPU en modo kernel
```

**Abre `starter/script.sh`** y descomenta la sección correspondiente.

---

### Paso 2: Variable SECONDS

Medir tiempo dentro del script:

```bash
start=$SECONDS
# ... código ...
duration=$((SECONDS - start))
echo "Duración: ${duration}s"
```

**Descomenta el Paso 2** en el script.

---

### Paso 3: Profiling con PS4

Agregar timestamps a cada línea:

```bash
PS4='+$SECONDS:$LINENO: '
set -x
# Los comandos mostrarán tiempo y línea
```

**Descomenta el Paso 3** en el script.

---

### Paso 4: Comparar Rendimiento

Medir diferentes implementaciones:

```bash
# Comparar subshell vs built-in
benchmark "subshell" cmd1
benchmark "builtin"  cmd2
```

**Descomenta el Paso 4** en el script.

---

### Paso 5: Optimización - Evitar Subshells

Usar built-ins en lugar de comandos externos:

```bash
# ❌ Lento
result=$(echo "$var" | cut -d: -f1)

# ✅ Rápido
result="${var%%:*}"
```

**Descomenta el Paso 5** en el script.

---

### Paso 6: Optimización - Evitar UUOC

Useless Use of Cat - un antipatrón común:

```bash
# ❌ cat innecesario
cat file | grep pattern

# ✅ grep directo
grep pattern file
```

**Descomenta el Paso 6** en el script.

---

## ✅ Verificación

```bash
cd starter && chmod +x script.sh && ./script.sh
```

---

## 🔗 Navegación

← [Práctica 02](../practica-02-traps/) | [Práctica 04 →](../practica-04-testing/)
