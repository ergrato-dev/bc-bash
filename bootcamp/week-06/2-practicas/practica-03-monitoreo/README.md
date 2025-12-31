# 📊 Práctica 03: Monitoreo de Sistema

> **Objetivo**: Crear scripts de monitoreo para disco, memoria, CPU y red

---

## 📚 Recursos Visuales

![Monitoreo de Sistema](../../0-assets/03-monitoreo-sistema.svg)

---

## 📋 Contenido

### Paso 1: Monitoreo de Disco

Comandos para verificar uso de disco:

```bash
df -h              # Uso de particiones
du -sh /path       # Tamaño de directorio
lsblk              # Lista de dispositivos
```

**Abre `starter/script.sh`** y descomenta la sección correspondiente.

---

### Paso 2: Monitoreo de Memoria

Verificar RAM y swap disponibles:

```bash
free -h            # RAM en formato legible
free -m            # RAM en megabytes
cat /proc/meminfo  # Información detallada
```

**Descomenta el Paso 2** en el script.

---

### Paso 3: Monitoreo de CPU

Verificar carga del sistema:

```bash
uptime             # Load average
nproc              # Número de CPUs
top -bn1           # Snapshot de procesos
```

**Descomenta el Paso 3** en el script.

---

### Paso 4: Monitoreo de Red

Verificar conexiones y puertos:

```bash
ss -tuln           # Puertos escuchando
ip addr            # Interfaces de red
ss -s              # Resumen de conexiones
```

**Descomenta el Paso 4** en el script.

---

### Paso 5: Script de Health Check

Crear función que combine todas las métricas:

```bash
# Verificar umbrales
# Alertar si algo excede límites
# Generar reporte consolidado
```

**Descomenta el Paso 5** en el script.

---

### Paso 6: Alertas por Umbrales

Implementar lógica de alertas:

```bash
# Si disco > 80% → ALERTA
# Si memoria > 90% → ALERTA
# Si load > núcleos → ALERTA
```

**Descomenta el Paso 6** en el script.

---

## ✅ Verificación

```bash
cd starter && chmod +x script.sh && ./script.sh
```

El script mostrará métricas del sistema y alertas si hay problemas.

---

## 🔗 Navegación

← [Práctica 02](../practica-02-cron/) | [Práctica 04 →](../practica-04-logging/)
