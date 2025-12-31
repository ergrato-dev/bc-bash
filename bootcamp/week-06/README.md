# 🔧 Semana 6: Herramientas del Sistema

> **Domina la gestión de procesos, automatización con cron, monitoreo y logs**

---

## 🎯 Objetivos de Aprendizaje

Al finalizar esta semana, podrás:

- ✅ Gestionar procesos del sistema (ps, top, kill, señales)
- ✅ Programar tareas automáticas con cron
- ✅ Monitorear recursos del sistema (disco, memoria, CPU, red)
- ✅ Analizar logs y gestionar servicios con systemd

---

## 📋 Requisitos Previos

- Semanas 1-5 completadas
- Conocimiento de comandos básicos de Linux
- Familiaridad con scripting Bash

---

## 🗂️ Estructura de la Semana

```
week-06/
├── 0-assets/           # Recursos visuales (4 SVGs)
├── 1-teoria/           # Conceptos de herramientas del sistema
├── 2-practicas/        # 4 prácticas guiadas
├── 3-proyecto/         # Proyecto: SysMon CLI
├── 4-recursos/         # Material adicional
└── 5-glosario/         # Términos clave
```

---

## 📚 Contenidos

### 1. Teoría

| Tema                                                                      | Descripción                    |
| ------------------------------------------------------------------------- | ------------------------------ |
| [Gestión de Procesos](./1-teoria/README.md#1-gestión-de-procesos)         | ps, pgrep, kill, señales, jobs |
| [Automatización con Cron](./1-teoria/README.md#2-automatización-con-cron) | Sintaxis, operadores, ejemplos |
| [Monitoreo de Sistema](./1-teoria/README.md#3-monitoreo-de-sistema)       | df, free, uptime, ss           |
| [Logs y Servicios](./1-teoria/README.md#4-logs-y-servicios)               | journalctl, systemctl          |

### 2. Prácticas

| #   | Práctica                                                     | Tema                      | Duración  |
| --- | ------------------------------------------------------------ | ------------------------- | --------- |
| 01  | [Gestión de Procesos](./2-practicas/practica-01-procesos/)   | ps, pgrep, kill, jobs     | 30-40 min |
| 02  | [Automatización con Cron](./2-practicas/practica-02-cron/)   | crontab, scheduling       | 30-40 min |
| 03  | [Monitoreo de Sistema](./2-practicas/practica-03-monitoreo/) | df, free, uptime, scripts | 40-50 min |
| 04  | [Logs y Servicios](./2-practicas/practica-04-logging/)       | journalctl, systemctl     | 30-40 min |

### 3. Proyecto

| Proyecto                | Descripción                             |
| ----------------------- | --------------------------------------- |
| [SysMon](./3-proyecto/) | Herramienta CLI de monitoreo de sistema |

---

## ⏱️ Distribución del Tiempo (4-6 horas)

| Actividad | Tiempo      |
| --------- | ----------- |
| Teoría    | 1-1.5 horas |
| Prácticas | 2-2.5 horas |
| Proyecto  | 1.5-2 horas |

---

## 📌 Entregables

1. **Prácticas**: Scripts completados (código descomentado y funcional)
2. **Proyecto**: SysMon CLI con funcionalidades básicas implementadas
3. **Comprensión**: Capacidad de explicar conceptos clave

---

## 🎨 Recursos Visuales

| Recurso                                                             | Tema                           |
| ------------------------------------------------------------------- | ------------------------------ |
| [01-procesos-gestion.svg](./0-assets/01-procesos-gestion.svg)       | Comandos de procesos y señales |
| [02-cron-automatizacion.svg](./0-assets/02-cron-automatizacion.svg) | Sintaxis y ejemplos de cron    |
| [03-monitoreo-sistema.svg](./0-assets/03-monitoreo-sistema.svg)     | Métricas del sistema           |
| [04-logging-servicios.svg](./0-assets/04-logging-servicios.svg)     | journalctl y systemctl         |

---

## 💡 Consejos para esta Semana

1. **Practica en tu sistema real**: Los comandos de esta semana son muy prácticos
2. **Ten cuidado con kill -9**: Siempre intenta SIGTERM primero
3. **Usa cron con cautela**: Prueba scripts manualmente antes de programarlos
4. **Lee los logs**: Son tu mejor amigo para debugging

---

## 🔗 Navegación

← [Semana 5: Procesamiento de Texto](../week-05/) | [Semana 7: Debugging y Optimización →](../week-07/)

---

## 📖 Referencias Rápidas

```bash
# Procesos
ps aux                    # Listar todos
pgrep -a nombre           # Buscar por nombre
kill -15 PID              # Terminar limpio
kill -9 PID               # Forzar muerte

# Cron
crontab -e                # Editar crontab
crontab -l                # Listar tareas
# */5 * * * * /script.sh  # Cada 5 minutos

# Monitoreo
df -h                     # Uso de disco
free -h                   # Uso de memoria
uptime                    # Load average

# Logs/Servicios
journalctl -f             # Seguir logs
journalctl -u servicio    # Logs de servicio
systemctl status nginx    # Estado servicio
```
