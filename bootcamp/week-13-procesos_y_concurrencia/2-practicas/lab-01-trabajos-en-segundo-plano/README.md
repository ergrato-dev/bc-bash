# Lab 01 — Trabajos en segundo plano: &, jobs y wait

⏱ Duración estimada: ~60 min

## Objetivo

Lanzar comandos en segundo plano con `&`, manejarlos desde la terminal con `jobs`, `fg`, `bg` y `kill %N`, y recoger el código de cada uno con `wait <pid>` para que ningún fallo pase sin aviso.

## Contexto

- Hasta ahora, la shell esperaba a que cada comando terminara antes de darte el prompt. Con `&` al final, el comando se queda trabajando en **segundo plano** y la shell sigue: puedes lanzar varios a la vez. Cada uno es un **trabajo** (*job*) con un número (`%1`, `%2`) y un pid.
- Lanzar a la vez sirve cuando cada tarea pasa casi todo el tiempo esperando (una descarga, una consulta a otra máquina): tres esperas de 2, 3 y 1 segundos tardan 3, no 6.
- `starter/fetch-mirrors.sh` "descarga" un paquete de tres espejos. La descarga se simula con `sleep`, y `datos/espejos.txt` dice cuánto tarda cada una y con qué código acaba: `paris` falla con `22`.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-13-procesos_y_concurrencia/2-practicas/lab-01-trabajos-en-segundo-plano
   ```
   (sin salida).

1. **Un trabajo en segundo plano.** `sleep 30` espera 30 segundos. Con `&`, la shell te devuelve el prompt enseguida y escribe el número del trabajo entre corchetes y su pid. `$!` guarda el pid del último trabajo lanzado; `jobs` lista los de tu shell, y `jobs -l` añade el pid:
   ```bash
   sleep 30 &
   echo $!
   jobs
   jobs -l
   ```
   ```text
   [1] 15
   15
   [1]+  Running                 sleep 30 &
   [1]+    15 Running                 sleep 30 &
   ```
   El pid cambia en tu equipo. `Running`: sigue trabajando mientras tú escribes otros comandos.

2. **Varios trabajos y `kill %N`.** Lanza otro y mata ese con `kill %2` (`%2` es "el trabajo 2" de esta shell; también vale su pid). El `+` marca el trabajo más reciente, el que usan `fg` y `bg` si no dices otro; el `-`, el anterior:
   ```bash
   sleep 20 &
   jobs
   kill %2
   jobs
   jobs
   ```
   ```text
   [2] 16
   [1]-  Running                 sleep 30 &
   [2]+  Running                 sleep 20 &
   [1]-  Running                 sleep 30 &
   [2]+  Terminated              sleep 20
   [1]+  Running                 sleep 30 &
   ```
   El primer `jobs` tras el `kill` avisa de que el trabajo 2 terminó; el segundo ya no lo lista.

3. **`fg`, Ctrl-Z y `bg`.** `fg` trae el trabajo al primer plano: la shell vuelve a esperarlo y no te da el prompt. Pulsa **Ctrl-Z**: lo detiene (no lo mata) y te devuelve el prompt. `bg` lo deja seguir, pero en segundo plano. Es lo que haces cuando lanzas algo largo y olvidas el `&`:
   ```bash
   fg
   ```
   Pulsa Ctrl-Z, y después:
   ```bash
   jobs
   bg
   jobs
   kill %1
   ```
   ```text
   sleep 30
   ^Z
   [1]+  Stopped                 sleep 30
   [1]+  Stopped                 sleep 30
   [1]+ sleep 30 &
   [1]+  Running                 sleep 30 &
   ```
   El aviso `[1]+  Terminated              sleep 30` aparece cuando la shell se da cuenta, antes de tu siguiente prompt.

4. **`wait`: esperar a los trabajos.** `wait` sin argumentos espera a todos y sale con `0`. `wait <pid>` espera a ese y sale **con su código**, aunque ya hubiera terminado. `(exit 3)` es un subshell que solo sale con `3`:
   ```bash
   sleep 2 & sleep 1 &
   wait; echo "wait: $?"
   (exit 3) & pid=$!
   sleep 1; wait "$pid"; echo "wait $pid: $?"
   wait; echo "wait: $?"
   ```
   ```text
   [1] 17
   [2] 18
   [1]-  Done                    sleep 2
   [2]+  Done                    sleep 1
   wait: 0
   [1] 19
   [1]+  Exit 3                  ( exit 3 )
   wait 19: 3
   wait: 0
   ```
   Fíjate en el último: con un trabajo que falló, `wait` a secas dice `0`. Solo `wait <pid>` devuelve el código.

5. **El script, tal cual.** Abre `starter/fetch-mirrors.sh` en tu editor. `time` (semana 12) dice cuánto tarda:
   ```bash
   cat datos/espejos.txt
   time bash starter/fetch-mirrors.sh datos/espejos.txt; echo "código: $?"
   ```
   ```text
   madrid 2 0
   paris 3 22
   berlin 1 0
   madrid: descargado
   paris: falló con código 22

   real	0m5.005s
   user	0m0.002s
   sys	0m0.003s
   código: 22
   ```
   Una detrás de otra: 2 + 3 segundos, y `set -e` para el script en `paris`, así que `berlin` ni se intenta. Los tiempos cambian un poco en tu equipo.

6. **TODO 1: todas a la vez.** Cambia el comentario del `TODO 1` y el bucle por:
   ```bash
   # Con & cada descarga va en segundo plano y el bucle sigue sin esperar: tardan lo que la
   # más lenta, no la suma. $! es el pid del último trabajo lanzado.
   pids=()
   while read -r name seconds code; do
     download "$name" "$seconds" "$code" &
     pids+=("$!")
   done < "$list"
   ```
   Una función también se puede lanzar con `&`: corre en un subshell, y `$!` es su pid. Prueba:
   ```bash
   time bash starter/fetch-mirrors.sh datos/espejos.txt; echo "código: $?"
   ```
   ```text
   berlin: descargado
   madrid: descargado
   paris: falló con código 22
   todas las descargas terminadas

   real	0m3.004s
   user	0m0.006s
   sys	0m0.000s
   código: 0
   ```
   3 segundos, lo que tarda `paris`. Los mensajes salen en el orden en que terminan. Pero el script dice que todo ha ido bien y sale con `0`: el `wait` a secas se tragó el fallo de `paris` (paso 4). `set -e` tampoco salta: un fallo en segundo plano no para el script.

7. **TODO 2: el código de cada una.** Cambia el comentario del `TODO 2` y el `wait` por:
   ```bash
   # wait sin argumentos sale siempre con 0: un fallo pasaría sin aviso. wait <pid> sale con
   # el código de ese trabajo, aunque haya terminado antes. || evita que set -e pare aquí.
   failed=0
   for pid in "${pids[@]}"; do
     wait "$pid" || failed=$((failed + 1))
   done
   if ((failed > 0)); then
     echo "fetch-mirrors.sh: fallaron $failed de ${#pids[@]} descargas" >&2
     exit 1
   fi
   ```
   Deja la última línea, el `echo "todas las descargas terminadas"`. Prueba:
   ```bash
   time bash starter/fetch-mirrors.sh datos/espejos.txt; echo "código: $?"
   ```
   ```text
   berlin: descargado
   madrid: descargado
   paris: falló con código 22
   fetch-mirrors.sh: fallaron 1 de 3 descargas

   real	0m3.005s
   user	0m0.003s
   sys	0m0.008s
   código: 1
   ```
   Igual de rápido, y ahora el fallo se ve en el aviso y en el código.

8. **shellcheck.**
   ```bash
   shellcheck starter/fetch-mirrors.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas qué son `[1]`, el `+` y el `-` de `jobs`, y qué hacen `fg`, Ctrl-Z y `bg` (pasos 1 a 3)
- [ ] Explicas por qué `wait` a secas dice `0` aunque un trabajo falle (paso 4)
- [ ] `time bash starter/fetch-mirrors.sh datos/espejos.txt` tarda unos 3 segundos, no 5 (paso 6)
- [ ] Con un espejo que falla, el script avisa `fallaron 1 de 3 descargas` y sale con `1` (paso 7)

## Reto extra

Haz que el aviso diga **qué** espejos fallaron, no solo cuántos: guarda el nombre de cada uno en otro array con el mismo índice que su pid. ¿Por qué no basta con leer `$name` después del bucle?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Índice de labs](../README.md) | [Lab 02 — Un límite de trabajos a la vez, y timeout](../lab-02-limite-de-trabajos-y-timeout/README.md) → |

[↑ Semana 13](../../README.md)
