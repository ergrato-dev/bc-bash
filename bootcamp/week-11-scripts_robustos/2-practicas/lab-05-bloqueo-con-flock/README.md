# Lab 05 — Bloqueo con flock

⏱ Duración estimada: ~60 min

## Objetivo

Impedir que un script corra dos veces a la vez bloqueando un archivo con `flock`, rindiéndose enseguida o esperando un máximo de segundos.

## Contexto

- Un cron lanza el informe de la noche a las 02:00. Un día tarda más de lo normal, el cron vuelve a lanzarlo y hay dos copias trabajando a la vez sobre los mismos archivos.
- Un archivo con el PID (lab 03) no basta: con `kill -9` se queda, y entre "mirar si existe" y "crearlo" otra copia puede colarse. `flock` pide al sistema un **bloqueo** sobre un archivo abierto: solo un proceso lo tiene, el sistema lo comprueba de una vez, y se suelta solo cuando nadie tiene el archivo abierto.
- `starter/nightly-report.sh` simula ese informe: apunta en `report.log` cuándo empieza y cuándo termina, con su PID, y entre medias espera 3 segundos.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-11-scripts_robustos/2-practicas/lab-05-bloqueo-con-flock
   ```
   (sin salida).

1. **Dos a la vez.** Abre `starter/nightly-report.sh` en tu editor. Dentro de un `bash -c`, el primero corre de fondo (`&`) y el segundo empieza un segundo después; `wait` espera al de fondo (lab 03):
   ```bash
   bash -c 'bash starter/nightly-report.sh & sleep 1; bash starter/nightly-report.sh; wait'
   cat report.log
   rm report.log
   ```
   Algo como (cambian las horas y los PID):
   ```text
   informe hecho (8)
   informe hecho (12)
   02:56:35 inicio 8
   02:56:36 inicio 12
   02:56:38 fin 8
   02:56:39 fin 12
   ```
   Los dos trabajaron a la vez: el segundo empezó antes de que el primero terminara.

2. **`flock` con un comando.** `flock archivo comando` bloquea el archivo (lo crea si no existe), ejecuta el comando y suelta el bloqueo al acabar. `-n` (*nonblock*): si otro lo tiene, no espera y sale con 1. `-w N`: espera como mucho N segundos.
   ```bash
   bash -c 'flock demo.lock sleep 3 & sleep 0.5; flock -n demo.lock echo dentro; echo "código: $?"; flock -w 5 demo.lock echo "dentro, tras esperar"; wait'
   rm demo.lock
   ```
   ```text
   código: 1
   dentro, tras esperar
   ```
   El `sleep 3` tiene el bloqueo: `-n` se rinde enseguida, y `-w 5` espera los 2,5 segundos que le quedan.

3. **Un descriptor para el script entero.** Para bloquear un script entero, y no un solo comando, se abre el archivo en un descriptor con `exec` (semana 03) y se le pasa a `flock` su número. `{fd}` le pide a bash un descriptor libre y guarda su número en `fd`:
   ```bash
   exec {fd}> demo.lock
   echo "fd=$fd"
   exec {fd}>&-
   rm demo.lock
   ```
   ```text
   fd=10
   ```
   `exec {fd}>&-` cierra el descriptor. En un script no hace falta: todos se cierran al terminar.

4. **TODO 1: rendirse si otro lo tiene.** Cambia los dos comentarios del `TODO 1` por:
   ```bash
   exec {lock_fd}> nightly-report.lock
   if ! flock -n "$lock_fd"; then
     echo "nightly-report.sh: ya hay otro informe en marcha" >&2
     exit 1
   fi
   ```
   Prueba como en el paso 1:
   ```bash
   bash -c 'bash starter/nightly-report.sh & sleep 1; bash starter/nightly-report.sh; echo "código: $?"; wait'
   cat report.log
   rm report.log
   ls
   ```
   Algo como:
   ```text
   nightly-report.sh: ya hay otro informe en marcha
   código: 1
   informe hecho (31)
   02:56:42 inicio 31
   02:56:45 fin 31
   README.md
   nightly-report.lock
   solucion
   starter
   ```
   El segundo se rindió y el log tiene un solo informe. `nightly-report.lock` se queda, vacío: no pasa nada, lo que cuenta es el bloqueo, no el archivo.

5. **TODO 2: esperar un poco.** A veces es mejor esperar a que termine el otro que rendirse. Cambia la línea del `flock` por:
   ```bash
   if ! flock -w "${WAIT:-0}" "$lock_fd"; then
   ```
   y borra el comentario del `TODO 2`. Con `-w 0` es lo mismo que `-n`. Explica en un comentario cuándo se suelta el bloqueo. Prueba:
   ```bash
   bash -c 'bash starter/nightly-report.sh & sleep 1; WAIT=5 bash starter/nightly-report.sh; wait'
   cat report.log
   rm report.log
   ```
   Algo como:
   ```text
   informe hecho (43)
   informe hecho (48)
   02:56:45 inicio 43
   02:56:48 fin 43
   02:56:48 inicio 48
   02:56:51 fin 48
   ```
   El segundo esperó: empieza cuando termina el primero, nunca a la vez.

6. **Con `kill -9`.** `pgrep -a -x sleep` busca los procesos que se llaman exactamente `sleep` y enseña su PID y su línea:
   ```bash
   bash -c 'bash starter/nightly-report.sh & sleep 1; kill -KILL $!; wait $!; echo "código: $?"; bash starter/nightly-report.sh; pgrep -a -x sleep; sleep 2.5; bash starter/nightly-report.sh'
   cat report.log
   rm report.log nightly-report.lock
   ```
   Algo como:
   ```text
   bash: line 1:     9 Killed                  bash starter/nightly-report.sh
   código: 137
   nightly-report.sh: ya hay otro informe en marcha
   13 sleep 3
   informe hecho (8)
   02:57:19 inicio 9
   02:57:23 inicio 8
   02:57:26 fin 8
   ```
   El script murió, pero su `sleep 3` sigue vivo: un hijo hereda los descriptores abiertos, y con ellos el bloqueo. En cuanto el `sleep` termina, el bloqueo se suelta solo, sin `trap` y sin archivos viejos que limpiar. (El primer informe se queda sin `fin`: `kill -9` no deja terminar nada.)

7. **shellcheck.**
   ```bash
   shellcheck starter/nightly-report.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas la diferencia entre `flock -n` y `flock -w 5` (paso 2)
- [ ] Con dos copias a la vez, la segunda escribe `ya hay otro informe en marcha` y sale con `1` (paso 4)
- [ ] Con `WAIT=5`, los dos informes van uno detrás de otro en `report.log` (paso 5)
- [ ] Explicas por qué el bloqueo siguió después del `kill -9` y cuándo se soltó (paso 6)
- [ ] `shellcheck starter/nightly-report.sh` no imprime nada

## Reto extra

En un crontab, la línea `0 2 * * * flock -n /tmp/informe.lock /ruta/nightly-report.sh` consigue lo mismo sin tocar el script. ¿Qué ventaja tiene meter el bloqueo dentro del script? ¿Y qué pasa si dos scripts distintos usan el mismo archivo de bloqueo?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 04 — Opciones con getopts](../lab-04-opciones-con-getopts/README.md) | [Lab 06 — Logging por niveles](../lab-06-logging-por-niveles/README.md) → |

[↑ Semana 11](../../README.md)
