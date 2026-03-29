# 📚 Recursos - Semana 6

> **Herramientas del Sistema**: Referencias y materiales adicionales

---

## 📖 Documentación Oficial

### Procesos y Señales

- [GNU Coreutils - ps](https://www.gnu.org/software/coreutils/manual/html_node/ps-invocation.html)
- [Signal(7) - Linux Manual](https://man7.org/linux/man-pages/man7/signal.7.html)
- [Kill(1) - Linux Manual](https://man7.org/linux/man-pages/man1/kill.1.html)

### Cron y Automatización

- [Crontab(5) - Linux Manual](https://man7.org/linux/man-pages/man5/crontab.5.html)
- [Cron Guru](https://crontab.guru/) - Generador visual de expresiones cron
- [systemd.timer](https://www.freedesktop.org/software/systemd/man/systemd.timer.html) - Alternativa moderna a cron

### Monitoreo de Sistema

- [/proc filesystem](https://man7.org/linux/man-pages/man5/proc.5.html)
- [Free(1) - Linux Manual](https://man7.org/linux/man-pages/man1/free.1.html)
- [Df(1) - Linux Manual](https://man7.org/linux/man-pages/man1/df.1.html)

### Logs y Servicios

- [Journalctl - ArchWiki](https://wiki.archlinux.org/title/Systemd/Journal)
- [Systemctl - Man Page](https://www.freedesktop.org/software/systemd/man/systemctl.html)
- [Rsyslog Documentation](https://www.rsyslog.com/doc/)

---

## 🎥 Videos Recomendados

### En Español

- [Procesos en Linux - Curso completo](https://www.youtube.com/results?search_query=procesos+linux+bash)
- [Cron y Crontab explicado](https://www.youtube.com/results?search_query=crontab+linux+tutorial)
- [Monitoreo de servidores Linux](https://www.youtube.com/results?search_query=monitoreo+linux+bash)

### En Inglés

- [Linux Process Management](https://www.youtube.com/results?search_query=linux+process+management)
- [Cron Jobs Tutorial](https://www.youtube.com/results?search_query=cron+jobs+linux+tutorial)
- [System Monitoring with Bash](https://www.youtube.com/results?search_query=bash+system+monitoring)

---

## 📚 Libros y Guías

### Gratuitos

- [The Linux Command Line](https://linuxcommand.org/tlcl.php) - Capítulo de procesos
- [Linux System Administration](https://www.tldp.org/LDP/sag/html/) - TLDP Guide
- [Bash Guide for Beginners](https://tldp.org/LDP/Bash-Beginners-Guide/html/)

### De Pago (Recomendados)

- "How Linux Works" - Brian Ward
- "UNIX and Linux System Administration Handbook"
- "Linux Bible" - Christopher Negus

---

## 🛠️ Herramientas Útiles

### Monitoreo Interactivo

- **htop** - Mejor alternativa a top
- **btop** - Monitor moderno con gráficos
- **glances** - Dashboard completo del sistema

### Análisis de Logs

- **lnav** - Navegador de logs avanzado
- **multitail** - Múltiples logs simultáneos
- **goaccess** - Análisis de logs web

### Automatización

- **anacron** - Cron para máquinas que no están siempre encendidas
- **at** - Programar tareas únicas
- **systemd timers** - Alternativa moderna a cron

---

## 🔧 Cheatsheets

### Procesos

```bash
# Listar todos los procesos
ps aux

# Árbol de procesos
ps -ef --forest

# Buscar proceso
pgrep -a nombre

# Matar proceso
kill PID
kill -9 PID
pkill nombre

# Background/Foreground
comando &
jobs
fg %1
bg %1
```

### Cron

```bash
# Editar crontab
crontab -e

# Listar tareas
crontab -l

# Sintaxis
# min hora día mes día_semana comando
*/5 * * * * /script.sh        # Cada 5 min
0 3 * * * /backup.sh          # 3am diario
0 0 * * 0 /weekly.sh          # Domingo medianoche
```

### Monitoreo

```bash
# Disco
df -h
du -sh /path

# Memoria
free -h

# CPU
uptime
nproc

# Red
ss -tuln
ip addr
```

### Logs

```bash
# Journalctl
journalctl -f              # Seguir
journalctl -u servicio     # Por servicio
journalctl -p err          # Solo errores
journalctl --since today   # Desde hoy

# Systemctl
systemctl status servicio
systemctl start/stop/restart servicio
systemctl enable/disable servicio
```

---

## 🔗 Navegación

← [Proyecto](../3-proyecto/) | [Glosario →](../5-glosario/)
