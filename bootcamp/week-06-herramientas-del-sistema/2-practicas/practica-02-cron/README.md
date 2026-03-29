# ⏰ Práctica 02: Automatización con Cron

> **Objetivo**: Dominar la sintaxis de cron y programar tareas automáticas

---

## 📚 Recursos Visuales

![Cron y Automatización](../../0-assets/02-cron-automatizacion.svg)

---

## 📋 Contenido

### Paso 1: Sintaxis Básica de Cron

Cada línea de crontab tiene 5 campos de tiempo:

```
┌─────── minuto (0-59)
│ ┌───── hora (0-23)
│ │ ┌─── día del mes (1-31)
│ │ │ ┌─ mes (1-12)
│ │ │ │ ┌ día de la semana (0-7)
│ │ │ │ │
* * * * * comando
```

**Abre `starter/script.sh`** y descomenta la sección correspondiente.

---

### Paso 2: Operadores de Cron

Los operadores permiten expresiones más complejas:

```bash
# * = todos los valores
# , = lista de valores (1,5,10)
# - = rango (1-5)
# / = intervalo (*/5)
```

**Descomenta el Paso 2** en el script.

---

### Paso 3: Atajos de Cron

Cron incluye atajos especiales:

```bash
@reboot    # Al iniciar el sistema
@yearly    # Una vez al año (0 0 1 1 *)
@monthly   # Una vez al mes (0 0 1 * *)
@weekly    # Una vez a la semana (0 0 * * 0)
@daily     # Una vez al día (0 0 * * *)
@hourly    # Una vez por hora (0 * * * *)
```

**Descomenta el Paso 3** en el script.

---

### Paso 4: Validar Expresiones Cron

Crear funciones para validar y explicar expresiones cron:

```bash
# Verificar que cada campo está en rango válido
# minuto: 0-59, hora: 0-23, día: 1-31, etc.
```

**Descomenta el Paso 4** en el script.

---

### Paso 5: Gestión de Crontab

Comandos para gestionar el crontab:

```bash
crontab -l    # Listar tareas
crontab -e    # Editar crontab
crontab -r    # Eliminar crontab
```

**Descomenta el Paso 5** en el script.

---

### Paso 6: Simular Ejecución de Cron

Crear scripts que simulen el comportamiento de cron:

```bash
# Script que verifica si es hora de ejecutar
# basándose en expresión cron
```

**Descomenta el Paso 6** en el script.

---

## ⚠️ Nota Importante

Esta práctica **simula** y **explica** el comportamiento de cron.
No modifica tu crontab real del sistema.

Para usar cron real:

```bash
# Ver tu crontab actual
crontab -l

# Editar (con cuidado)
crontab -e
```

---

## ✅ Verificación

```bash
cd starter && chmod +x script.sh && ./script.sh
```

El script explicará la sintaxis de cron y mostrará ejemplos válidos.

---

## 🔗 Navegación

← [Práctica 01](../practica-01-procesos/) | [Práctica 03 →](../practica-03-monitoreo/)
