# Lab 07 — cron y timers de systemd

⏱ Duración estimada: ~60 min

## Objetivo

Programar un script para que se ejecute solo con una línea de cron y con un timer de systemd, comprobando antes que funciona en el entorno vacío en el que lo lanzan y que dos ejecuciones no se pisan.

## Contexto

- **cron** es un servicio que lee la tabla de cada usuario (su *crontab*) y ejecuta cada línea a la hora que dice. Está en casi cualquier servidor Linux desde hace décadas.
- Un **timer de systemd** hace lo mismo con dos archivos: un `.service` que dice qué ejecutar y un `.timer` que dice cuándo. Da más: guarda el log de cada ejecución, se puede pedir que recupere una ejecución perdida si la máquina estaba apagada, y `systemctl` enseña cuándo toca la siguiente.
- El laboratorio no tiene en marcha ni el servicio de cron ni systemd: puedes escribir y comprobar los dos, pero no esperar a que se ejecuten. `starter/backup-notes.sh` guarda una copia de `notas/` en `copias/`. Funciona desde su carpeta, y falla justo donde lo lanzaría cron.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-13-procesos_y_concurrencia/2-practicas/lab-07-cron-y-timers-de-systemd
   ```
   (sin salida).

1. **Una línea de cron.** Cinco campos de tiempo y el comando: minuto (0–59), hora (0–23), día del mes (1–31), mes (1–12) y día de la semana (0–7; 0 y 7 son domingo). `*` es "cualquiera", `*/15` "cada 15", `9-18` un rango y `1,15` una lista. Esta línea es "cada 15 minutos, de 9 a 18, de lunes a viernes". `crontab -` instala lo que le llega por stdin, `crontab -l` lo enseña y `crontab -r` lo borra:
   ```bash
   echo "*/15 9-18 * * 1-5 date" | crontab -
   crontab -l
   echo "0 25 * * * date" | crontab -; echo "código: $?"
   crontab -r
   ```
   ```text
   */15 9-18 * * 1-5 date
   "-":0: bad hour
   errors in crontab file, can't install.
   código: 1
   ```
   `crontab` comprueba cada línea: la hora 25 no existe. En tu equipo, `crontab -e` abre tu tabla en un editor; `crontab -` la reemplaza entera.

2. **El script, tal cual.** Abre `starter/backup-notes.sh` en tu editor y ejecútalo desde aquí:
   ```bash
   ls notas
   bash starter/backup-notes.sh; echo "código: $?"
   ls copias
   rm -r copias
   ```
   ```text
   ideas.txt  tareas.txt
   backup-notes.sh: copia en copias/notas-20261110-042341.tar.gz
   código: 0
   notas-20261110-042341.tar.gz
   ```
   La fecha del nombre cambia. Funciona.

3. **Como lo lanzaría cron.** cron no abre una terminal ni lee tu configuración: empieza en tu home, con `PATH=/usr/bin:/bin` y casi ninguna variable más. `env -i` ejecuta un comando con el entorno vacío y le das solo esas dos. `sh -c` lo ejecuta con `sh`, como cron:
   ```bash
   env -i HOME="$HOME" PATH=/usr/bin:/bin sh -c "cd && $PWD/starter/backup-notes.sh"; echo "código: $?"
   ls ~
   rm -r ~/copias
   ```
   ```text
   tar: notas: Cannot stat: No such file or directory
   tar: Exiting with failure status due to previous errors
   código: 2
   copias
   ```
   Desde el home, `notas` no existe, y además ha creado una carpeta `copias/` vacía en tu home (la del laboratorio, no la de tu equipo). Un script para cron no puede depender de la carpeta desde la que lo lanzan.

4. **TODO 1: rutas desde el script.** `BASH_SOURCE[0]` es la ruta del script (semana 08); `/..` sube a la carpeta del lab. Cambia el comentario del `TODO 1` y las dos variables por:
   ```bash
   # cron empieza en tu home, no en la carpeta del script: con rutas relativas, tar buscaría
   # notas/ en el home. La carpeta del lab sale de dónde está el script (BASH_SOURCE, semana 08).
   base="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
   backups="$base/copias"
   ```
   y la línea del `tar` por:
   ```bash
   # -C: tar entra en la carpeta del lab antes de guardar notas, y la copia no lleva la ruta entera.
   tar -czf "$file" -C "$base" notas
   ```
   Repite la prueba. `tar -tzf` lista lo que hay dentro de la copia:
   ```bash
   env -i HOME="$HOME" PATH=/usr/bin:/bin sh -c "cd && $PWD/starter/backup-notes.sh"; echo "código: $?"
   ls copias
   tar -tzf copias/*.tar.gz
   rm -r copias
   ```
   ```text
   backup-notes.sh: copia en /bc-bash/bootcamp/week-13-procesos_y_concurrencia/2-practicas/lab-07-cron-y-timers-de-systemd/copias/notas-20261110-042341.tar.gz
   código: 0
   notas-20261110-042341.tar.gz
   notas/
   notas/tareas.txt
   notas/ideas.txt
   ```

5. **El `%` en cron.** En una línea de cron, `%` no es un `%`: `man 5 crontab` lo dice así:
   ```text
   Percent-signs (%) in the  command,
   unless escaped with backslash (\), will be changed into newline charac‐
   ters,  and  all  data  after the first % will be sent to the command as
   standard input.
   ```
   Una línea con `tar -czf copia-$(date +%F).tar.gz notas` se cortaría en el primer `%`. Por eso la fecha va dentro del script y no en la línea de cron: así no hay que escribir `\%`.

6. **Dos ejecuciones a la vez: `flock -n`.** Si una copia tarda más de lo previsto, cron lanza la siguiente igual, y las dos escriben a la vez. `flock` (semana 11) bloquea un archivo mientras dura el comando; con `-n`, si ya está bloqueado, no espera: sale con `1`.
   ```bash
   flock -n /tmp/demo.lock sleep 3 &
   sleep 0.5; flock -n /tmp/demo.lock echo segundo; echo "código: $?"
   wait; flock -n /tmp/demo.lock echo tercero; echo "código: $?"
   ```
   ```text
   [1] 52
   código: 1
   [1]+  Done                    flock -n /tmp/demo.lock sleep 3
   tercero
   código: 0
   ```
   `segundo` no se ejecuta: el `sleep` tiene el bloqueo. Cuando termina, `tercero` sí.

7. **TODO 3: la línea de cron.** Abre `starter/crontab.txt` y cambia el comentario del `TODO 3` por la línea que ejecuta la copia de lunes a viernes a las 09:00, con `flock -n` delante y la salida y los avisos a `backup.log` (cron no tiene terminal donde enseñarlos). Las rutas, enteras. En el laboratorio, la carpeta del lab es `/bc-bash/bootcamp/week-13-procesos_y_concurrencia/2-practicas/lab-07-cron-y-timers-de-systemd`:
   ```text
   # De lunes a viernes a las 09:00. flock -n: si la copia anterior sigue en marcha, esta no empieza.
   0 9 * * 1-5 flock -n /tmp/backup-notes.lock /bc-bash/bootcamp/week-13-procesos_y_concurrencia/2-practicas/lab-07-cron-y-timers-de-systemd/starter/backup-notes.sh >> /bc-bash/bootcamp/week-13-procesos_y_concurrencia/2-practicas/lab-07-cron-y-timers-de-systemd/backup.log 2>&1
   ```
   `crontab archivo` instala un archivo entero (las líneas con `#` son comentarios). `cut -c 1-60` corta la línea para que quepa en pantalla:
   ```bash
   crontab starter/crontab.txt; crontab -l | tail -n 1 | cut -c 1-60
   crontab -r
   ```
   ```text
   0 9 * * 1-5 flock -n /tmp/backup-notes.lock /bc-bash/bootcam
   ```
   Si `crontab` acepta el archivo, la línea es válida. En un servidor, con cron en marcha, se ejecutaría el próximo día laborable a las 09:00.

8. **Cuándo, para systemd.** Un timer dice cuándo con `OnCalendar=`, en otra sintaxis: `día-de-la-semana año-mes-día hora:minuto:segundo`. `systemd-analyze calendar` la comprueba y dice cuándo toca la próxima vez:
   ```bash
   systemd-analyze calendar "Mon..Fri *-*-* 09:00:00"
   systemd-analyze calendar --iterations=3 "*:0/15"
   systemd-analyze calendar "lunes 9:00"; echo "código: $?"
   ```
   ```text
   Normalized form: Mon..Fri *-*-* 09:00:00
       Next elapse: Tue 2026-11-10 09:00:00 UTC
          From now: 4h 36min left
     Original form: *:0/15
   Normalized form: *-*-* *:00/15:00
       Next elapse: Tue 2026-11-10 04:30:00 UTC
          From now: 6min left
      Iteration #2: Tue 2026-11-10 04:45:00 UTC
          From now: 21min left
      Iteration #3: Tue 2026-11-10 05:00:00 UTC
          From now: 36min left
   Failed to parse calendar specification 'lunes 9:00': Invalid argument
   código: 1
   ```
   Las fechas cambian. `Mon..Fri` es de lunes a viernes; `*:0/15`, cada 15 minutos. Los días van en inglés: `lunes` no lo entiende.

9. **TODO 2: el timer.** Abre `starter/systemd/backup-notes.service` (ya hecho: `Type=oneshot` es "un comando que termina", y `ExecStart` la ruta entera del script) y `starter/systemd/backup-notes.timer`. Un `.timer` activa el `.service` que se llama igual. `systemd-analyze verify` comprueba los dos sin instalarlos:
   ```bash
   systemd-analyze verify starter/systemd/backup-notes.timer; echo "código: $?"
   ```
   ```text
   backup-notes.timer: Timer unit lacks value setting. Refusing.
   Unit backup-notes.timer has a bad unit file setting.
   código: 1
   ```
   Le falta el cuándo. Cambia el comentario del `TODO 2` por:
   ```ini
   OnCalendar=Mon..Fri *-*-* 09:00:00
   ```
   `Persistent=true`, que ya está, hace que si la máquina estaba apagada a las 09:00, la copia se haga al encender. Comprueba:
   ```bash
   systemd-analyze verify starter/systemd/backup-notes.timer; echo "código: $?"
   ```
   ```text
   código: 0
   ```

10. **En una máquina con systemd.** En el laboratorio no hay systemd en marcha:
    ```bash
    systemctl --user list-timers; echo "código: $?"
    ```
    ```text
    Failed to connect to bus: No medium found
    código: 1
    ```
    En un servidor (o en tu Ubuntu), los dos archivos van a `~/.config/systemd/user/`, con la ruta de `ExecStart` cambiada a la de tu equipo, y se activan con `systemctl --user daemon-reload` y `systemctl --user enable --now backup-notes.timer`. Después, `systemctl --user list-timers` dice cuándo toca, y `journalctl --user -u backup-notes.service` enseña lo que escribió cada ejecución. No lo hagas en el laboratorio: aquí solo saldría el error de arriba.

11. **shellcheck.**
    ```bash
    shellcheck starter/backup-notes.sh; echo $?
    ```
    ```text
    0
    ```

## Criterios de éxito

- [ ] Lees en voz alta qué significa `*/15 9-18 * * 1-5` (paso 1)
- [ ] `env -i HOME="$HOME" PATH=/usr/bin:/bin sh -c "cd && $PWD/starter/backup-notes.sh"` sale con `0` y la copia tiene `notas/` dentro (paso 4)
- [ ] Explicas qué pasa con un `%` en una línea de cron y qué evita `flock -n` (pasos 5 y 6)
- [ ] `crontab starter/crontab.txt` acepta tu línea (paso 7)
- [ ] `systemd-analyze verify starter/systemd/backup-notes.timer` sale con `0` (paso 9)

## Reto extra

Compara los dos: escribe en `starter/systemd/` un timer que haga la copia cada 15 minutos de 9 a 18 en días laborables, como la línea del paso 1, y compruébalo con `systemd-analyze calendar --iterations=5`. ¿Qué tiene systemd que cron no (piensa en `Persistent=`, en `journalctl` y en qué pasa si el script se cuelga, con `TimeoutStartSec=` en el `.service`)?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 06 — Señales a los hijos](../lab-06-senales-a-los-hijos/README.md) | [Proyecto — `bashkit healthcheck`: comprobaciones en paralelo](../../3-proyecto/README.md) → |

[↑ Semana 13](../../README.md)
