# Glosario — Semana 13

| Término | Definición en una línea | Ejemplo |
|---------|-------------------------|---------|
| Trabajo (*job*) | Comando lanzado desde la shell, con un número de trabajo y un pid | `sleep 30 &` da `[1] 15` |
| `&` | Lanza un comando en segundo plano y la shell sigue sin esperarlo | `check "$host" &` |
| `$!` | El pid del último trabajo lanzado en segundo plano | `pids+=("$!")` |
| `jobs -rp` | Los pids de los trabajos que siguen en marcha, uno por línea | `jobs -rp \| wc -l` |
| `wait` | Espera a trabajos en segundo plano; con un pid, sale con el código de ese trabajo | `wait "$pid" \|\| failed=$((failed + 1))` |
| `wait -n` | Espera a que termine un trabajo cualquiera; sirve para dejar sitio en un límite | `wait -n \|\| true` |
| `timeout` | Ejecuta un programa y lo corta si tarda más de lo indicado (sale con 124) | `timeout -k 2 5 curl -s "$url"` |
| `xargs -P` | Convierte lo que lee en argumentos y lanza hasta N comandos a la vez | `find . -print0 \| xargs -0 -P 4 -n 1 gzip` |
| Process substitution | `<( )` da la salida de un comando como si fuera un archivo; `>( )`, al revés | `diff <(sort a.txt) <(sort b.txt)` |
| `coproc` | Lanza un comando en segundo plano con un descriptor para escribirle y otro para leerle | `coproc UPPER { stdbuf -oL tr a-z A-Z; }` |
| Búfer | Lo que un programa guarda antes de escribirlo a un pipe, en trozos de varios KB | `awk '{ print; fflush() }'` |
| Señal | Aviso que el sistema entrega a un proceso: `INT`, `TERM`, `KILL`... | `kill -TERM "$pid"` |
| Proceso huérfano | Hijo cuyo padre murió sin pararlo; lo adopta el proceso 1 (`PPID 1`) | `ps -o pid,ppid,cmd` |
| `crontab` | Tabla de tareas programadas de cron: cinco campos de tiempo y un comando | `*/5 * * * * /ruta/script >> log 2>&1` |
| Timer de systemd | Par de archivos `.timer` y `.service` que dicen cuándo y qué ejecutar | `OnCalendar=Mon..Fri *-*-* 09:00:00` |

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Recursos — web](../4-recursos/webgrafia/README.md) | — |

[↑ Semana 13](../README.md)
