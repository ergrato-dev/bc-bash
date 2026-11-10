# Lab 06 — Señales a los hijos

⏱ Duración estimada: ~60 min

## Objetivo

Comprobar que una señal llega al proceso al que se la mandas y no a sus hijos, y hacer que un script que lanza trabajos en segundo plano los pare con `trap`, `kill` y `wait` antes de salir.

## Contexto

- Una **señal** es un aviso que el sistema entrega a un proceso: `TERM` ("termina, por favor"), `INT` (la que manda Ctrl-C), `KILL` (muere ya, sin opción a nada). `kill` las manda; `TERM` si no dices otra. Con `trap` (semana 11), un script decide qué hacer al recibir una.
- Un script que lanza hijos con `&` es su **padre**. Si el padre muere, los hijos no se enteran: siguen trabajando, ahora **huérfanos**, y nadie los para. Pasa con un `kill` desde otra terminal, o cuando otro script para el tuyo.
- `starter/workers.sh` lanza varios workers que trabajan sin fin: cada medio segundo, una línea en `out/worker-N.log`. Pararlo bien es cosa tuya.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-13-procesos_y_concurrencia/2-practicas/lab-06-senales-a-los-hijos
   ```
   (sin salida).

1. **Las señales.** `kill -l` las lista con su número:
   ```bash
   kill -l | head -n 2
   ```
   ```text
    1) SIGHUP	 2) SIGINT	 3) SIGQUIT	 4) SIGILL	 5) SIGTRAP
    6) SIGABRT	 7) SIGBUS	 8) SIGFPE	 9) SIGKILL	10) SIGUSR1
   ```
   `INT` es la 2, `KILL` la 9 y `TERM` la 15 (en la línea siguiente). Un proceso que muere por una señal sale con 128 + su número: `130` por `INT`, `137` por `KILL`, `143` por `TERM`.

2. **Un `trap` espera al comando que corre.** Mira cuánto tarda en reaccionar un script con un `trap` de `TERM` mientras hace un `sleep 5`. `SECONDS` cuenta los segundos desde que le das valor:
   ```bash
   bash -c 'trap "echo recibido TERM; exit 143" TERM; sleep 5; echo fin' &
   sleep 0.5; SECONDS=0; kill $!; wait $!; echo "código: $? a los $SECONDS s"
   ```
   ```text
   [1] 17
   recibido TERM
   [1]+  Exit 143                bash -c 'trap "echo recibido TERM; exit 143" TERM; sleep 5; echo fin'
   código: 143 a los 4 s
   ```
   La señal llegó enseguida, pero bash ejecuta el `trap` cuando termina el comando en primer plano: el `sleep 5` entero. `wait`, en cambio, se corta en cuanto llega una señal con `trap`:
   ```bash
   bash -c 'trap "echo recibido TERM; exit 143" TERM; sleep 5 & wait $!; echo fin' &
   sleep 0.5; SECONDS=0; kill $!; wait $!; echo "código: $? a los $SECONDS s"
   pkill -x sleep
   ```
   ```text
   [1] 20
   recibido TERM
   [1]+  Exit 143                bash -c 'trap "echo recibido TERM; exit 143" TERM; sleep 5 & wait $!; echo fin'
   código: 143 a los 0 s
   ```
   Al momento. Pero el `sleep 5` ha quedado vivo, sin padre: por eso el `pkill -x sleep` (mata los procesos que se llaman exactamente `sleep`). Es el problema de este lab en pequeño.

3. **Ignorar una señal.** `trap '' TERM` (comillas vacías) la ignora:
   ```bash
   bash -c 'trap "" TERM; sleep 3; echo sigo vivo' &
   sleep 0.5; kill $!; wait $!; echo "código: $?"
   ```
   ```text
   [1] 24
   sigo vivo
   [1]+  Done                    bash -c 'trap "" TERM; sleep 3; echo sigo vivo'
   código: 0
   ```
   Para esos casos está `KILL`, que no se puede ignorar ni atrapar (y `timeout -k`, lab 02).

4. **El script y sus hijos.** Abre `starter/workers.sh` en tu editor. Lánzalo en segundo plano y mira los procesos con `ps -o pid,ppid,pgid,cmd`: `PPID` es el pid del padre y `PGID` el grupo de procesos (lo explica el paso 6):
   ```bash
   bash starter/workers.sh 3 &
   sleep 1.2
   ps -o pid,ppid,pgid,cmd
   ```
   ```text
   [1] 15
   workers.sh: 3 workers en marcha (pid 15)
       PID    PPID    PGID CMD
         7       1       7 sh -c bash -i
         8       7       8 bash -i
        15       8      15 bash starter/workers.sh 3
        18      15      15 bash starter/workers.sh 3
        19      15      15 bash starter/workers.sh 3
        20      15      15 bash starter/workers.sh 3
        27      18      15 sleep 0.5
        28      19      15 sleep 0.5
        29      20      15 sleep 0.5
        30       8      30 ps -o pid,ppid,pgid,cmd
   ```
   Los pids cambian en tu equipo. El 15 es el script; 18, 19 y 20 son sus workers (subshells con la función `worker`, de ahí que tengan el mismo nombre), cada uno con su `sleep`.

5. **`kill` al script: huérfanos.** Mata solo al script, por su pid:
   ```bash
   kill $!
   sleep 1
   ps -o pid,ppid,pgid,cmd
   tail -n 1 out/worker-1.log; sleep 1; tail -n 1 out/worker-1.log
   ```
   ```text
   [1]+  Terminated              bash starter/workers.sh 3
       PID    PPID    PGID CMD
         7       1       7 sh -c bash -i
         8       7       8 bash -i
        18       1      15 bash starter/workers.sh 3
        19       1      15 bash starter/workers.sh 3
        20       1      15 bash starter/workers.sh 3
        35      19      15 sleep 0.5
        36      18      15 sleep 0.5
        37      20      15 sleep 0.5
        38       8      38 ps -o pid,ppid,pgid,cmd
   ```
   ```text
   worker 1: vuelta 5
   worker 1: vuelta 7
   ```
   El 15 ya no está, pero sus tres workers siguen, ahora con `PPID 1`: el proceso 1 adopta a los huérfanos. Y siguen escribiendo. Para matarlos a todos, `pkill -f` busca en la línea de comandos entera:
   ```bash
   pkill -f workers.sh; sleep 0.6; rm -r out
   ```
   (sin salida).

6. **`kill %1`: el grupo entero.** Desde tu terminal, cada trabajo va en su **grupo de procesos** (el `PGID` del paso 4), y los hijos del script entran en el mismo. `kill %1` manda la señal al grupo, no a un proceso. Ctrl-C hace lo mismo con el trabajo en primer plano.
   ```bash
   bash starter/workers.sh 3 &
   sleep 1.2
   kill %1
   sleep 1
   pgrep -fa workers.sh; echo "código: $?"
   tail -n 1 out/worker-1.log
   rm -r out
   ```
   ```text
   [1] 51
   workers.sh: 3 workers en marcha (pid 51)
   [1]+  Terminated              bash starter/workers.sh 3
   código: 1
   worker 1: vuelta 3
   ```
   Ahora mueren todos (`pgrep` no encuentra nada y sale con `1`). Pero no cuentes con eso: un `kill <pid>` desde otra terminal o desde otro script manda la señal a un proceso, como en el paso 5. Y un programa que el script lanza con `&` ignora el `INT` de Ctrl-C (lo viste en el lab 02, con `sleep 60`). El script tiene que encargarse de sus hijos.

7. **TODO 1: parar a los hijos.** `jobs -p` da los pids de los trabajos del script. Cambia el comentario del `TODO 1` por:
   ```bash
   # stop: manda TERM a los workers que sigan vivos y espera a que terminen.
   # Sin esto, un Ctrl-C o un kill al script los deja vivos: la señal llega al script y no a
   # sus hijos, y un programa que el script lanza con & ignora el INT de Ctrl-C.
   stop() {
     local pids
     pids="$(jobs -p)"
     if [[ -n $pids ]]; then
       # Sin comillas a propósito: un pid por palabra.
       # shellcheck disable=SC2086
       kill $pids 2> /dev/null || true
     fi
     wait || true
     echo "workers.sh: workers parados" >&2
   }
   # exit con 128 + el número de la señal: quien lanzó el script sabe por qué terminó.
   trap 'stop; exit 130' INT
   trap 'stop; exit 143' TERM
   ```
   El script espera con `wait` al final: por el paso 2, el `trap` salta al momento. Repite el paso 5:
   ```bash
   bash starter/workers.sh 3 &
   sleep 1.2
   ls out
   kill $!
   sleep 1
   pgrep -fa workers.sh; echo "código: $?"
   tail -n 1 out/worker-1.log
   rm -r out
   ```
   ```text
   [1] 15
   workers.sh: 3 workers en marcha (pid 15)
   worker-1.log  worker-2.log  worker-3.log
   workers.sh: workers parados
   [1]+  Exit 143                bash starter/workers.sh 3
   código: 1
   worker 1: vuelta 3
   ```
   Sin huérfanos, y el script sale con `143`.

8. **TODO 2: que cada worker pare con orden.** Ahora un worker muere a mitad de lo que hace. Un worker de verdad terminaría la tarea, cerraría su conexión o al menos diría hasta dónde llegó. Cambia el comentario del `TODO 2` (dentro de `worker`) por:
   ```bash
     # Con TERM (el kill de stop) o INT (Ctrl-C llega a todo el grupo), apunta en su log en qué
     # vuelta paró y sale. Comillas simples: $id y $n se leen al llegar la señal.
     trap 'echo "worker $id: parado en la vuelta $n" >> "$out/worker-$id.log"; exit 0' TERM INT
   ```
   El `trap` va dentro de la función: un subshell no hereda los `trap` del script. `INT` también, porque Ctrl-C le llega a cada worker a la vez que al script (paso 6), y sin él mueren sin apuntar nada. Prueba con `kill $!`:
   ```bash
   bash starter/workers.sh 3 &
   sleep 1.2
   kill $!
   sleep 1
   tail -n 2 out/worker-1.log
   rm -r out
   ```
   ```text
   [1] 15
   workers.sh: 3 workers en marcha (pid 15)
   workers.sh: workers parados
   [1]+  Exit 143                bash starter/workers.sh 3
   worker 1: vuelta 3
   worker 1: parado en la vuelta 3
   ```
   Y con Ctrl-C:
   ```bash
   bash starter/workers.sh 3
   ```
   Pulsa Ctrl-C pasado un segundo, y después:
   ```bash
   echo "código: $?"
   pgrep -fa workers.sh
   tail -n 1 out/worker-*.log
   rm -r out
   ```
   ```text
   workers.sh: 3 workers en marcha (pid 15)
   ^Cworkers.sh: workers parados
   código: 130
   ==> out/worker-1.log <==
   worker 1: parado en la vuelta 3

   ==> out/worker-2.log <==
   worker 2: parado en la vuelta 3

   ==> out/worker-3.log <==
   worker 3: parado en la vuelta 3
   ```
   Los pids y el número de vueltas cambian. Cada worker deja dicho dónde paró, y el script sale con `130`.

9. **shellcheck.**
   ```bash
   shellcheck starter/workers.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas por qué el `trap` del paso 2 tardó 4 segundos con `sleep` y nada con `wait` (paso 2)
- [ ] Señalas en el `ps` del paso 5 la columna que dice que los workers son huérfanos
- [ ] Explicas por qué `kill %1` los mató a todos y `kill <pid>` no (pasos 5 y 6)
- [ ] Tras `kill $!` o Ctrl-C, `pgrep -fa workers.sh` no encuentra nada y cada log acaba en `parado en la vuelta N` (pasos 7 y 8)

## Reto extra

Haz que `stop` espere como mucho 3 segundos a los workers y, si alguno sigue vivo, le mande `KILL`. Pista: `timeout` no sirve con `wait` (es un builtin), pero sí un bucle que mira `jobs -rp` cada décima de segundo. Pruébalo con un worker que ignore `TERM`, como en el paso 3.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 05 — coproc: una conversación con otro proceso](../lab-05-coproc/README.md) | [Lab 07 — cron y timers de systemd](../lab-07-cron-y-timers-de-systemd/README.md) → |

[↑ Semana 13](../../README.md)
