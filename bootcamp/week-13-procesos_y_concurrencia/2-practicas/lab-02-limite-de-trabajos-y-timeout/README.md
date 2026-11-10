# Lab 02 — Un límite de trabajos a la vez, y timeout

⏱ Duración estimada: ~60 min

## Objetivo

Lanzar una lista de tareas sin pasar de N a la vez con `jobs -rp` y `wait -n`, y cortar con `timeout` (y `timeout -k`) la que se cuelga, para que una sola no pare el resto.

## Contexto

- En el lab 01, las tres descargas iban a la vez. Con 300 sería un problema: 300 conexiones contra el mismo servidor, o 300 procesos peleando por la CPU. Lo normal es un límite: como mucho N a la vez y, cuando acaba una, entra la siguiente.
- La otra amenaza es una tarea que no termina nunca (un servidor que no contesta): el script la esperaría para siempre. `timeout segundos comando` la para cuando se pasa del tiempo.
- `starter/task.sh <nombre> <segundos>` simula una llamada a un servicio con `sleep`; `starter/run-batch.sh` lanza las tareas de una lista. `datos/` tiene tres listas: `seis.txt` (seis tareas de 1 s), `colgada.txt` (una de 60 s) y `terca.txt` (una que, además, no se deja parar).

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-13-procesos_y_concurrencia/2-practicas/lab-02-limite-de-trabajos-y-timeout
   ```
   (sin salida).

1. **El script, tal cual.** Abre `starter/run-batch.sh` en tu editor. Es el patrón del lab 01: `&`, el pid en un array y `wait <pid>` al final. Además, tras lanzar cada tarea escribe en stderr cuántas van en marcha: `jobs -rp` lista los pids de los trabajos que siguen corriendo (`-r`, *running*; `-p`, solo pids) y `wc -l` los cuenta:
   ```bash
   time bash starter/run-batch.sh datos/seis.txt; echo "código: $?"
   ```
   ```text
   en marcha: 1
   en marcha: 2
   en marcha: 3
   en marcha: 4
   en marcha: 5
   en marcha: 6
   a: hecha en 1 s
   b: hecha en 1 s
   c: hecha en 1 s
   d: hecha en 1 s
   e: hecha en 1 s
   f: hecha en 1 s

   real	0m1.014s
   user	0m0.022s
   sys	0m0.008s
   código: 0
   ```
   Las seis a la vez. El `-j 3` que acepta el script todavía no hace nada. Los tiempos cambian un poco en tu equipo.

2. **`wait -n` y su trampa.** `wait -n` espera a que termine **un** trabajo cualquiera y sale con su código: justo lo que hace falta para "cuando acabe una, lanza otra". Pero mira qué pasa, dentro de un script, si el trabajo ya había terminado al llamarlo. `bash -c '...'` ejecuta las comillas como un script aparte:
   ```bash
   bash -c '(exit 3) & sleep 0.5; wait -n; echo "wait -n: $?"'
   bash -c '(exit 3) & p=$!; sleep 0.5; wait "$p"; echo "wait pid: $?"'
   bash -c '(sleep 1; exit 3) & wait -n; echo "wait -n: $?"'
   ```
   ```text
   wait -n: 127
   wait pid: 3
   wait -n: 3
   ```
   En bash 5.2, si el trabajo terminó mientras el script hacía otra cosa (aquí, el `sleep 0.5`), `wait -n` no lo ve: sale con `127`, "no hay trabajos que esperar", y su código se pierde. `wait <pid>` sí lo guarda. Solo cuando el trabajo sigue en marcha (tercera línea), `wait -n` da su código. Conclusión: `wait -n` para **dejar sitio**, `wait <pid>` para los **códigos**.

3. **TODO 1: como mucho `max_jobs` a la vez.** Cambia el comentario del `TODO 1` por:
   ```bash
     # No más de max_jobs a la vez: jobs -rp da los pids de las que siguen en marcha, y
     # wait -n espera a que acabe una cualquiera. Su código no sirve: en bash 5.2, wait -n no
     # ve una tarea que ya terminó. El de cada una lo da wait <pid>, al final.
     while (($(jobs -rp | wc -l) >= max_jobs)); do
       wait -n || true
     done
   ```
   Un `while` y no un `if`: tras `wait -n` se vuelve a contar, y si `wait -n` salió con `127` porque la tarea ya había acabado, la cuenta lo dice igual. `|| true`: una tarea que falla no debe parar el script por `set -e`. Prueba con el límite de siempre (3) y con 2:
   ```bash
   time bash starter/run-batch.sh datos/seis.txt; echo "código: $?"
   time bash starter/run-batch.sh -j 2 datos/seis.txt 2>&1 | grep -c hecha
   ```
   ```text
   en marcha: 1
   en marcha: 2
   en marcha: 3
   a: hecha en 1 s
   b: hecha en 1 s
   en marcha: 3
   c: hecha en 1 s
   en marcha: 3
   en marcha: 3
   d: hecha en 1 s
   e: hecha en 1 s
   f: hecha en 1 s

   real	0m2.020s
   user	0m0.021s
   sys	0m0.013s
   código: 0
   6

   real	0m3.025s
   user	0m0.028s
   sys	0m0.019s
   ```
   Nunca pasa de 3: dos tandas de 1 segundo. Con `-j 2`, tres tandas y las seis hechas (`grep -c` cuenta las líneas). El orden de las líneas puede cambiar.

4. **Una tarea colgada.** `colgada.txt` tiene una tarea de 60 segundos. Lánzalo y, cuando veas `otra: hecha en 2 s`, pulsa **Ctrl-C**:
   ```bash
   bash starter/run-batch.sh datos/colgada.txt
   ```
   ```text
   en marcha: 1
   en marcha: 2
   en marcha: 3
   rapida: hecha en 1 s
   otra: hecha en 2 s
   ^C
   ```
   Sin Ctrl-C te habría tenido un minuto esperando. Y mira qué ha quedado:
   ```bash
   echo "código: $?"
   pgrep -a sleep
   pkill -x sleep
   ```
   ```text
   código: 130
   32 sleep 60
   Terminated
   ```
   `pgrep -a sleep` busca los procesos llamados `sleep` y enseña su comando: el script murió, pero su tarea sigue viva. Lo arreglas en el lab 06. `pkill -x sleep` la mata (el pid cambia).

5. **`timeout`.** `timeout segundos comando` ejecuta el comando y, si pasa de ese tiempo, le manda la señal `TERM` y sale con `124`. Necesita un programa: una función de tu shell no le vale, porque `timeout` es otro proceso y no la conoce:
   ```bash
   timeout 1 sleep 5; echo "código: $?"
   f() { sleep 1; }
   timeout 2 f; echo "código: $?"
   ```
   ```text
   código: 124
   timeout: failed to run command ‘f’: No such file or directory
   código: 127
   ```
   Por eso las tareas de este lab son un script aparte, `task.sh`, y no una función.

6. **TODO 2: ninguna tarea pasa de `limit` segundos.** Cambia el comentario del `TODO 2` y la línea que lanza la tarea por:
   ```bash
     # timeout para la tarea si pasa de limit segundos, y entonces sale con 124.
     timeout "$limit" "$task" "$name" "$seconds" &
   ```
   Prueba con 3 segundos de límite:
   ```bash
   time bash starter/run-batch.sh -t 3 datos/colgada.txt; echo "código: $?"
   ```
   ```text
   en marcha: 1
   en marcha: 2
   en marcha: 3
   rapida: hecha en 1 s
   otra: hecha en 2 s
   run-batch.sh: colgada salió con código 124

   real	0m3.012s
   user	0m0.011s
   sys	0m0.014s
   código: 1
   ```
   `124` es "se acabó el tiempo". En algunos equipos `timeout` tarda un par de segundos más en saltar: lo que importa es que no espera los 60.

7. **Una tarea que ignora `TERM`: `timeout -k`.** `task.sh` hace que la tarea `terca` ignore `TERM` (`trap '' TERM`, lab 06), como un programa que no sabe parar a medias:
   ```bash
   time bash starter/run-batch.sh -t 3 datos/terca.txt; echo "código: $?"
   ```
   ```text
   en marcha: 1
   en marcha: 2
   rapida: hecha en 1 s
   terca: hecha en 60 s
   run-batch.sh: terca salió con código 124

   real	1m6.019s
   user	0m0.015s
   sys	0m0.019s
   código: 1
   ```
   Algo más de un minuto: `timeout` le avisó a los 3 segundos y la tarea siguió como si nada. `-k segundos` añade un segundo aviso que no se puede ignorar: si sigue viva ese tiempo después del `TERM`, la mata con `KILL`. Cambia la línea del `timeout` y su comentario por:
   ```bash
     # timeout para la tarea si pasa de limit segundos, y entonces sale con 124.
     # -k 2: si 2 segundos después sigue viva (ignora TERM), la mata con KILL (código 137).
     timeout -k 2 "$limit" "$task" "$name" "$seconds" &
   ```
   ```bash
   time bash starter/run-batch.sh -t 3 datos/terca.txt; echo "código: $?"
   ```
   ```text
   en marcha: 1
   en marcha: 2
   rapida: hecha en 1 s
   starter/run-batch.sh: line 44:    21 Killed                  timeout -k 2 "$limit" "$task" "$name" "$seconds"
   run-batch.sh: terca salió con código 137

   real	0m5.012s
   user	0m0.011s
   sys	0m0.007s
   código: 1
   ```
   3 + 2 segundos. `137` = 128 + 9, el número de `KILL`. La línea `Killed` la escribe bash al ver que un trabajo murió por esa señal (el pid cambia). `KILL` no da opción a limpiar nada: es el último recurso, por eso va después de `TERM`.

8. **shellcheck.**
   ```bash
   shellcheck starter/run-batch.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas por qué `wait -n` dio `127` en el paso 2 y por qué el script usa `wait <pid>` para los códigos
- [ ] `bash starter/run-batch.sh datos/seis.txt` nunca dice más de `en marcha: 3` y tarda unos 2 segundos (paso 3)
- [ ] Explicas por qué `timeout` no puede ejecutar una función (paso 5)
- [ ] Con `-t 3`, `colgada` sale con `124` sin esperar 60 segundos (paso 6)
- [ ] Con `-k 2`, `terca` sale con `137` en unos 5 segundos (paso 7)

## Reto extra

Cambia el mensaje del final para que diga `tiempo agotado` con el código `124` y `matada` con el `137`, en lugar del número. ¿Qué código saldría si `task.sh` terminara con `exit 124` por su cuenta? ¿Cómo lo distinguirías?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 01 — Trabajos en segundo plano: &, jobs y wait](../lab-01-trabajos-en-segundo-plano/README.md) | [Lab 03 — xargs en paralelo](../lab-03-xargs-en-paralelo/README.md) → |

[↑ Semana 13](../../README.md)
