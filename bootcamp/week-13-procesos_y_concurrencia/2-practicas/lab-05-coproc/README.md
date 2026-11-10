# Lab 05 — coproc: una conversación con otro proceso

⏱ Duración estimada: ~60 min

## Objetivo

Mantener vivo un proceso ayudante con `coproc`, hacerle una pregunta y leer su respuesta en cada vuelta de un bucle, evitar que se quede callado por el búfer y cerrarlo al terminar.

## Contexto

- Un pipe va en una sola dirección: `a | b`. Con `coproc`, bash lanza un comando en segundo plano y te da **dos** descriptores: uno para escribirle y otro para leer lo que contesta. Es una conversación: preguntas, esperas la respuesta y decides qué preguntar después.
- Si todo el trabajo cabe en un pipe (leer un archivo entero y resumirlo), un pipe es más simple y mejor. `coproc` es para cuando el script necesita **cada respuesta antes de seguir**.
- `starter/make-data.sh` crea una tarifa de 50 000 precios y un pedido de 1000 líneas. `starter/checkout.sh` suma el pedido y para en cuanto pasa del presupuesto, pero busca cada precio lanzando un `grep` que lee la tarifa entera, 1000 veces.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-13-procesos_y_concurrencia/2-practicas/lab-05-coproc
   ```
   (sin salida).

1. **Un coproc.** `coproc NOMBRE { comando; }` lanza el comando en segundo plano. `NOMBRE[1]` es el descriptor para escribirle y `NOMBRE[0]` el de leer lo que escribe; `NOMBRE_PID`, su pid. `tr a-z A-Z` pasa a mayúsculas lo que lee:
   ```bash
   coproc UPPER { tr a-z A-Z; }
   declare -p UPPER UPPER_PID
   ```
   ```text
   [1] 15
   declare -a UPPER=([0]="63" [1]="60")
   declare -- UPPER_PID="15"
   ```
   Es un trabajo de tu shell, como los del lab 01 (los números cambian). Ahora pregunta: `>&"${UPPER[1]}"` manda la salida de `echo` a ese descriptor, y `<&"${UPPER[0]}"` hace que `read` lea del otro. `read -t 2` se rinde a los 2 segundos:
   ```bash
   echo hola >&"${UPPER[1]}"
   read -t 2 -r line <&"${UPPER[0]}"; echo "código: $?"
   ```
   ```text
   código: 142
   ```
   `142` (más de 128) es que se acabó el tiempo: no llegó ninguna respuesta.

2. **El búfer.** Cuando un programa escribe en un pipe y no en la terminal, guarda lo que escribe en un **búfer** y lo suelta de golpe, en trozos de unos KB o al terminar. `tr` tiene `HOLA` guardado y espera más texto antes de soltarlo; `read` espera a `tr`: nadie avanza. `stdbuf -oL` hace que el comando suelte cada línea al acabarla. Mata el coproc y lánzalo otra vez así:
   ```bash
   kill "$UPPER_PID"; sleep 0.2
   coproc UPPER { stdbuf -oL tr a-z A-Z; }
   echo hola >&"${UPPER[1]}"
   read -t 2 -r line <&"${UPPER[0]}"; echo "código: $? línea: $line"
   echo adios >&"${UPPER[1]}"; read -r line <&"${UPPER[0]}"; echo "$line"
   ```
   ```text
   [1]+  Terminated              coproc UPPER { tr a-z A-Z; }
   [1] 18
   código: 0 línea: HOLA
   ADIOS
   ```
   El mismo `tr` contesta a cada pregunta, sin lanzar otro. En `awk`, lo mismo se consigue con `fflush()` después de cada `print`.

3. **Cerrar el coproc.** `tr` termina cuando su entrada se acaba, y su entrada es el descriptor `UPPER[1]`. `exec {UPPER[1]}>&-` lo cierra (`>&-`, semana 11):
   ```bash
   exec {UPPER[1]}>&-
   sleep 0.2
   jobs
   ```
   ```text
   [1]+  Done                    coproc UPPER { stdbuf -oL tr a-z A-Z; }
   ```
   `tr` vio el final, terminó, y bash quita el array `UPPER`.

4. **El script, tal cual.** Crea los datos (unos 700 KB; el paso 9 los borra) y abre `starter/checkout.sh` en tu editor. El tercer argumento es el presupuesto en céntimos:
   ```bash
   bash starter/make-data.sh datos
   wc -l datos/*
   head -n 2 datos/precios.txt datos/pedido.txt
   ```
   ```text
     1000 datos/pedido.txt
    50000 datos/precios.txt
    51000 total
   ==> datos/precios.txt <==
   P00001 137
   P00002 174

   ==> datos/pedido.txt <==
   P07920 1
   P15839 3
   ```
   ```bash
   time bash starter/checkout.sh datos/pedido.txt datos/precios.txt 20000000; echo "código: $?"
   bash starter/checkout.sh datos/pedido.txt datos/precios.txt 500000; echo "código: $?"
   ```
   ```text
   total: 10059041 céntimos en 1000 líneas

   real	0m1.676s
   user	0m1.198s
   sys	0m0.567s
   código: 0
   checkout.sh: presupuesto superado en la línea 53: 503762 > 500000
   código: 1
   ```
   Funciona, pero cada línea lanza un `grep`, un `cut` y un subshell (`$( )`): 3000 procesos y 1000 lecturas de la tarifa (semana 12). Los tiempos cambian en tu equipo.

5. **¿Por qué no un pipe?** Podrías pasar el pedido entero por un solo `awk` con la tarifa. Pero el script **para** al pasar del presupuesto: con 500 000 céntimos, solo pregunta 53 precios de 1000. Y con otras reglas (pedir confirmación, cambiar de tarifa a mitad) la siguiente pregunta depende de la respuesta. Para eso, un ayudante que se queda vivo y contesta: un `coproc`.

6. **TODO 1: el ayudante.** `awk` con dos archivos: el primero es la tarifa, que guarda en un array (`NR == FNR` solo es verdad mientras lee el primero), y el segundo es `-`, su stdin, por donde le llegan las preguntas. Cambia el primer comentario del `TODO 1` por:
   ```bash
   # Un solo awk para todo el pedido: lee la tarifa una vez (NR == FNR: el primer archivo) y
   # después contesta a cada código que le llega por stdin (-) con su precio, o con ? si no está.
   # fflush(): awk escribe a un pipe y guardaría las respuestas en su búfer; sin él, el read de
   # abajo esperaría para siempre una respuesta que no llega.
   coproc PRICES {
     awk 'NR == FNR { price[$1] = $2; next } { print (($1 in price) ? price[$1] : "?"); fflush() }' "$prices" -
   }
   ```
   Y dentro del bucle, cambia el segundo comentario del `TODO 1`, la línea del `grep` y el `if [[ -z $price ]]` por:
   ```bash
     # Pregunta y respuesta: una línea al coproc por PRICES[1], una de vuelta por PRICES[0].
     echo "$code" >&"${PRICES[1]}"
     read -r price <&"${PRICES[0]}"
     if [[ $price == "?" ]]; then
   ```

7. **TODO 2: cerrarlo.** Si el script terminara sin más, `awk` acabaría igual al cerrarse todo; pero así queda claro, y `wait` recoge su código. Cambia el comentario del `TODO 2` por:
   ```bash
   # Cerrar su entrada es decirle a awk que no hay más preguntas: termina, y wait lo recoge.
   # exec {var}>&- cierra el descriptor cuyo número guarda var. Con {PRICES[1]} también
   # funciona, pero shellcheck no lo entiende: por eso se copia antes a una variable.
   to_prices="${PRICES[1]}"
   exec {to_prices}>&-
   wait "$PRICES_PID"
   ```
   Prueba con los dos presupuestos y con un código que no existe:
   ```bash
   time bash starter/checkout.sh datos/pedido.txt datos/precios.txt 20000000; echo "código: $?"
   bash starter/checkout.sh datos/pedido.txt datos/precios.txt 500000; echo "código: $?"
   echo "P99999 1" > raro.txt
   bash starter/checkout.sh raro.txt datos/precios.txt 100; echo "código: $?"
   rm raro.txt
   ```
   ```text
   total: 10059041 céntimos en 1000 líneas

   real	0m0.074s
   user	0m0.050s
   sys	0m0.036s
   código: 0
   checkout.sh: presupuesto superado en la línea 53: 503762 > 500000
   código: 1
   checkout.sh: 'P99999' no está en la tarifa
   código: 1
   ```
   Los mismos resultados, unas 20 veces más rápido: un `awk` en total y la tarifa leída una vez.

8. **Sin `fflush()`.** Para verlo con tus ojos: quita `; fflush()` del `awk` y ejecuta el script con `timeout 5` (lab 02) delante:
   ```bash
   timeout 5 bash starter/checkout.sh datos/pedido.txt datos/precios.txt 20000000; echo "código: $?"
   ```
   ```text
   código: 124
   ```
   Se queda colgado hasta que `timeout` lo para: el paso 2 otra vez. Vuelve a poner `; fflush()`.

9. **shellcheck y limpieza.**
   ```bash
   shellcheck starter/checkout.sh; echo $?
   rm -r datos
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas qué guardan `UPPER[0]`, `UPPER[1]` y `UPPER_PID` (paso 1)
- [ ] Explicas por qué `read` no recibe respuesta de `tr` sin `stdbuf -oL`, ni de `awk` sin `fflush()` (pasos 2 y 8)
- [ ] Explicas por qué aquí un `coproc` y no un pipe (paso 5)
- [ ] `bash starter/checkout.sh datos/pedido.txt datos/precios.txt 20000000` da `total: 10059041 céntimos en 1000 líneas` en mucho menos tiempo que al principio (paso 7)

## Reto extra

Un `coproc` sin nombre se llama `COPROC` (y su pid, `COPROC_PID`). ¿Qué pasa si lanzas dos coprocs a la vez con el mismo nombre? Mira el aviso que da bash 5.2. ¿Cómo tendrías dos ayudantes, uno con la tarifa de hoy y otro con la de mañana?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 04 — Process substitution: <( ) y >( )](../lab-04-process-substitution/README.md) | [Lab 06 — Señales a los hijos](../lab-06-senales-a-los-hijos/README.md) → |

[↑ Semana 13](../../README.md)
