# 📖 Glosario - Semana 6

> **Términos clave de Herramientas del Sistema**

---

## B

### Background Process

Proceso que se ejecuta sin bloquear la terminal. Se lanza con `&` al final del comando.

```bash
./script.sh &
```

---

## C

### Cron

Demonio que ejecuta tareas programadas en intervalos regulares. Configurado mediante crontab.

### Crontab

Archivo de configuración para tareas cron. Contiene líneas con formato de tiempo y comando.

```bash
# minuto hora día mes día_semana comando
0 3 * * * /scripts/backup.sh
```

---

## D

### Daemon

Proceso que se ejecuta en segundo plano, generalmente iniciado al boot del sistema. Ejemplos: sshd, crond, systemd.

### df (disk free)

Comando para mostrar espacio disponible en sistemas de archivos montados.

```bash
df -h  # Formato legible por humanos
```

### du (disk usage)

Comando para mostrar espacio usado por archivos y directorios.

```bash
du -sh /home  # Resumen del directorio
```

---

## F

### Foreground Process

Proceso que se ejecuta en primer plano, ocupando la terminal hasta completar.

### free

Comando para mostrar uso de memoria RAM y swap.

```bash
free -h  # Formato legible
```

---

## J

### Job

Proceso iniciado desde el shell actual. Puede moverse entre foreground y background.

```bash
jobs     # Listar jobs
fg %1    # Traer job 1 a foreground
bg %1    # Enviar job 1 a background
```

### journalctl

Herramienta para consultar logs del journal de systemd.

```bash
journalctl -f           # Seguir en tiempo real
journalctl -u nginx     # Logs de un servicio
journalctl -p err       # Solo errores
```

---

## K

### Kill

Comando para enviar señales a procesos. Por defecto envía SIGTERM.

```bash
kill PID      # SIGTERM
kill -9 PID   # SIGKILL (forzado)
kill -l       # Listar señales
```

---

## L

### Load Average

Métrica que indica cuántos procesos están esperando CPU. Se muestra con `uptime`.

- **1.00** en sistema de 1 CPU = 100% utilizado
- **4.00** en sistema de 4 CPUs = 100% utilizado

### Log

Archivo que registra eventos del sistema o aplicaciones. Típicamente en `/var/log/`.

### logrotate

Utilidad para rotar, comprimir y eliminar logs antiguos automáticamente.

---

## N

### nohup

Comando que permite que un proceso continúe ejecutándose después de cerrar la terminal.

```bash
nohup ./script.sh &
```

---

## P

### PID (Process ID)

Identificador único numérico asignado a cada proceso por el kernel.

### pgrep

Busca procesos por nombre y devuelve sus PIDs.

```bash
pgrep -a nginx  # PIDs y comandos de nginx
```

### pkill

Envía señales a procesos encontrados por nombre.

```bash
pkill -f "pattern"  # Matar por patrón
```

### Process

Instancia en ejecución de un programa. Tiene PID, memoria asignada y estado.

### ps

Comando para listar procesos activos.

```bash
ps aux              # Todos los procesos
ps -ef --forest     # Árbol de procesos
```

---

## S

### Signal (Señal)

Mecanismo de comunicación entre procesos. Tipos comunes:

| Señal   | Número | Descripción              |
| ------- | ------ | ------------------------ |
| SIGTERM | 15     | Terminar limpiamente     |
| SIGKILL | 9      | Matar forzadamente       |
| SIGHUP  | 1      | Hangup / Recargar config |
| SIGSTOP | 19     | Pausar proceso           |
| SIGCONT | 18     | Continuar proceso        |

### ss (socket statistics)

Herramienta moderna para investigar sockets de red. Reemplaza a netstat.

```bash
ss -tuln  # Puertos TCP/UDP escuchando
```

### systemctl

Herramienta para controlar systemd y servicios del sistema.

```bash
systemctl status nginx    # Estado
systemctl start nginx     # Iniciar
systemctl enable nginx    # Habilitar al boot
```

### systemd

Sistema de inicio moderno para Linux. Gestiona servicios, logs y recursos del sistema.

---

## T

### top

Herramienta interactiva para monitorear procesos en tiempo real. Muestra CPU, memoria y más.

### Threshold (Umbral)

Valor límite para generar alertas en monitoreo. Ejemplo: alerta si disco > 80%.

---

## U

### Uptime

Tiempo transcurrido desde el último reinicio del sistema.

```bash
uptime  # Muestra tiempo y load average
```

### Unit (systemd)

Recurso que systemd puede gestionar: services, sockets, timers, targets, etc.

---

## Z

### Zombie Process

Proceso que ha terminado pero su padre no ha leído su código de salida. Aparece como `Z` en ps.

```bash
ps aux | awk '$8=="Z"'  # Listar zombies
```

---

## 🔗 Navegación

← [Recursos](../4-recursos/) | [README →](../README.md)
