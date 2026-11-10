# Rúbrica de Evaluación — Semana 13

> Procesos y concurrencia. Se evalúan tres evidencias por separado y hace falta **70% en cada una**. Que las comprobaciones vayan a la vez no basta: ningún fallo puede perderse por el camino, ninguna colgada puede parar al resto, ningún hijo puede quedar vivo cuando el kit termina, y tienes que poder explicar por qué.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 7 labs, con sus criterios de éxito comprobados en el laboratorio |
| 📦 Producto | 30% | `bashkit healthcheck`: 60 pts de autograding + 40 pts de calidad |

**Bandas:** Sobresaliente 90–100 · Notable 80–89 · Aprobado 70–79 · No aprobado < 70 en cualquiera de las tres.

---

## 🧠 Conocimiento (30%)

Diez preguntas, 3 puntos cada una. No se pide recordar sintaxis: se pide explicar por qué.

| # | Pregunta |
|:--:|---|
| 1 | Tres descargas de 2, 3 y 1 segundos tardan 3 segundos en paralelo y no 6. ¿Por qué, si la máquina no trabaja más deprisa? ¿En qué caso lanzar más trabajos a la vez ya no acelera nada? |
| 2 | Un script lanza tres trabajos con `&`, uno falla y el script termina con `wait` a secas y `set -e`. ¿Con qué código sale y por qué? ¿Qué cambia si guardas cada `$!` y haces `wait "$pid"` uno a uno? |
| 3 | ¿Por qué un script con 300 tareas no debe lanzarlas todas a la vez? En el límite con `jobs -rp` y `wait -n`, ¿por qué `wait -n` solo deja sitio y los códigos se recogen con `wait <pid>`? |
| 4 | `timeout 5 mi_funcion` sale con `127`. ¿Por qué? ¿Qué códigos dan `timeout 5 programa` y `timeout -k 2 5 programa` cuando cortan, y qué señal manda cada uno? |
| 5 | `ls \| xargs gzip` rompe `app 2026-11-01.log`. ¿Por qué, y qué arreglan `find -print0` y `xargs -0`? Con `-P 4`, `real` baja a la cuarta parte y `user` no cambia: ¿qué dice eso? |
| 6 | ¿Qué es `/dev/fd/63` cuando escribes `echo <(true)`? ¿Por qué `count` vale `0` tras `join ... \| while read ...; do count=...; done`, y por qué con `done < <(join ...)` vale lo que debe? |
| 7 | ¿Cuándo usarías `coproc` y no un pipe? En el lab 05, ¿por qué `read` se queda esperando la respuesta de `tr` si no lo lanzas con `stdbuf -oL`? |
| 8 | Haces `kill <pid>` a un script que lanzó workers con `&`, y los workers siguen escribiendo. ¿Por qué? ¿Qué columna de `ps` lo delata? ¿Por qué `kill %1` o Ctrl-C en su terminal sí los paran a todos? |
| 9 | Un script con `trap 'exit 143' TERM` está dentro de un `sleep 30` y tarda 30 segundos en hacer caso a un `kill`. ¿Por qué? ¿Qué cambia si escribes `sleep 30 & wait $!`? |
| 10 | Un script que funciona en tu terminal falla desde cron. Di tres diferencias del entorno de cron que lo pueden romper, cómo lo pruebas antes con `env -i`, y qué evita `flock -n` en la línea de cron. |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** Porque casi todo el tiempo las descargas **esperan** (a la red, al otro servidor), y mientras una espera, las otras también pueden esperar: el total es el de la más lenta. Cuando el trabajo es de CPU y ya están ocupados todos los núcleos, más trabajos solo se reparten el mismo tiempo: con 8 núcleos, 50 `gzip` a la vez no van más rápido que 8.

**2.** Sale con `0`: un fallo en segundo plano no dispara `set -e`, y `wait` sin argumentos espera a todos y devuelve `0` aunque alguno falle. `wait "$pid"` devuelve el código de **ese** trabajo, aunque ya hubiera terminado antes, así que puedes contar los fallos (`wait "$pid" || failed=$((failed + 1))`) y salir con `1`.

**3.** Satura la máquina o el servicio al que llaman (300 conexiones a la vez, 300 procesos compitiendo por la CPU). En bash 5.2, `wait -n` no ve un trabajo que ya había terminado cuando lo llamas: devuelve `127` y ese código se pierde. Por eso `jobs -rp` cuenta los que siguen en marcha, `wait -n` solo espera a que acabe alguno, y `wait <pid>`, que siempre guarda el código, da el de cada uno al final.

**4.** `timeout` lanza un **programa** nuevo; una función solo existe dentro de tu bash, y el programa `mi_funcion` no existe (`127`, comando no encontrado). Al cortar, `timeout 5` manda `TERM` y sale con `124`; con `-k 2`, si el programa sigue vivo 2 segundos después, le manda `KILL`, que no se puede ignorar, y sale con `137`.

**5.** `xargs` parte por espacios lo que lee: `app` y `2026-11-01.log` llegan como dos archivos que no existen, y como alguno falla, `xargs` sale con `123`. `-print0` separa los nombres con el carácter nulo, que no puede ir en un nombre, y `-0` le dice a `xargs` que parta solo por él. `user` es el tiempo de CPU sumado de todos los procesos: el trabajo es el mismo, pero repartido entre 4 núcleos, el reloj (`real`) avanza 4 veces menos.

**6.** Un pipe que bash conecta a la salida de `true` y que se lee como si fuera un archivo: por eso `diff` y `comm`, que piden archivos, pueden leerlo. Detrás de un `|`, el `while` corre en un subshell y su `count` se pierde al terminar. Con `< <( )` el `while` lee de una redirección y corre en la shell del script: lo que cuenta sigue ahí después.

**7.** Cuando el script necesita **cada respuesta antes de seguir**: parar en cuanto pasa del presupuesto, decidir la siguiente pregunta según la anterior. Si todo cabe en un pipe, el pipe es más simple. `tr` escribe a un pipe, no a una terminal, y guarda la salida en un búfer que suelta en trozos de varios KB o al terminar: `HOLA` se queda dentro y `read` espera para siempre. `stdbuf -oL` le hace soltar cada línea.

**8.** La señal le llega al proceso al que se la mandas, no a sus hijos: el script muere y los workers siguen, ahora huérfanos. Lo delata `PPID`: pasa a `1`, el proceso que los adopta. Desde la terminal, cada trabajo es un grupo de procesos con sus hijos dentro, y `kill %1` y Ctrl-C mandan la señal al grupo entero. Por eso el script tiene que pararlos él con `trap`, `kill $(jobs -rp)` y `wait`.

**9.** bash ejecuta el `trap` cuando termina el comando que tiene en primer plano, y el `sleep` no sabe nada del `trap`: hay que esperar a que acabe. `wait` es un builtin que se corta en cuanto llega la señal, así que con `sleep 30 & wait $!` el `trap` corre al momento.

**10.** cron arranca desde tu home y no desde la carpeta del script, con `PATH=/usr/bin:/bin`, sin tus variables, sin terminal (nadie ve la salida) y cambiando cada `%` por un salto de línea. `env -i HOME="$HOME" PATH=/usr/bin:/bin sh -c 'cd && /ruta/script'` lo ejecuta igual que cron: si ahí sale con `0`, desde cron también. `flock -n` no deja empezar una ejecución mientras la anterior sigue en marcha: sin él, una que tarda más de 5 minutos se pisa con la siguiente.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 70, llevada a porcentaje. Cada criterio de éxito se comprueba ejecutando el comando en el laboratorio.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — Trabajos en segundo plano](2-practicas/lab-01-trabajos-en-segundo-plano/README.md) | `jobs`, `fg`, Ctrl-Z, `bg` y el `0` de `wait` a secas explicados; `fetch-mirrors.sh` tarda unos 3 s y con un espejo roto avisa `fallaron 1 de 3 descargas` y sale con `1` | 10 |
| [02 — Límite de trabajos y timeout](2-practicas/lab-02-limite-de-trabajos-y-timeout/README.md) | El `127` de `wait -n` y el de `timeout` con una función explicados; `run-batch.sh` nunca pasa de `en marcha: 3`, `colgada` sale con `124` y `terca` con `137` | 10 |
| [03 — xargs en paralelo](2-practicas/lab-03-xargs-en-paralelo/README.md) | `-print0`/`-0`, el `123` y `real` frente a `user` explicados; `compress-logs.sh` comprime los 8 logs y la segunda vez avisa y sale con `1` | 10 |
| [04 — Process substitution](2-practicas/lab-04-process-substitution/README.md) | `/dev/fd/63` y el `sleep` tras `>( )` explicados; `compare-packages.sh` no deja nada en `/tmp` y dice `total con otra versión: 1` | 10 |
| [05 — coproc](2-practicas/lab-05-coproc/README.md) | `UPPER[0]`, `UPPER[1]`, `UPPER_PID`, el búfer y por qué no un pipe explicados; `checkout.sh` da `total: 10059041 céntimos en 1000 líneas` mucho más rápido que al principio | 10 |
| [06 — Señales a los hijos](2-practicas/lab-06-senales-a-los-hijos/README.md) | El `trap` con `sleep` frente a `wait`, el `PPID 1` y `kill %1` frente a `kill <pid>` explicados; tras `kill $!` o Ctrl-C no queda ningún worker y cada log acaba en `parado en la vuelta N` | 10 |
| [07 — cron y timers de systemd](2-practicas/lab-07-cron-y-timers-de-systemd/README.md) | `*/15 9-18 * * 1-5`, el `%` y `flock -n` explicados; `backup-notes.sh` sale con `0` bajo `env -i`, `crontab` acepta la línea y `systemd-analyze verify` sale con `0` | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con tus palabras por qué funciona; 8 si se cumplen todos; 7 si falla uno; menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 13`. Es binario: pasa o no pasa. 4 puntos por comprobación.

| Comprobación | Puntos |
|---|:--:|
| `hc-ayuda` — bashkit healthcheck -h enseña el uso con código 0; -j 0 avisa y sale con código 2 | 4 |
| `hc-archivo` — un archivo que no existe y una línea sin comando avisan y salen con código 2 | 4 |
| `hc-ok` — con todo bien: una línea ok por comprobación, sin contar comentarios ni líneas vacías, el resumen a stderr y código 0 | 4 |
| `hc-fallo` — una comprobación que falla sale como FAIL con su código y su error, y bk-healthcheck sale con 1 | 4 |
| `hc-orden` — el informe sigue el orden del archivo, no el orden en que terminan | 4 |
| `hc-paralelo` — sin -j van 4 a la vez: cuatro comprobaciones de 1 s tardan menos de 2 s | 4 |
| `hc-limite` — con -j 2 nunca van más de dos a la vez: cuatro de 1 s tardan entre 2 y 3 s | 4 |
| `hc-timeout` — -t corta una comprobación colgada y dice que se le acabó el tiempo | 4 |
| `hc-senal` — un kill a bk-healthcheck para también sus comprobaciones y borra su carpeta temporal; sale con 143 | 4 |
| `hc-cron` — lanzado como lo haría cron (otra carpeta, entorno vacío, PATH mínimo) usa el healthcheck.conf del kit y sale con 0 | 4 |
| `tests-pasan` — bats tests pasa entero, con 3 tests o más de bk-healthcheck | 4 |
| `mut-fallo` — los tests de bk-healthcheck fallan si da por buena una comprobación que falla | 4 |
| `mut-paralelo` — los tests de bk-healthcheck fallan si las comprobaciones van una detrás de otra | 4 |
| `kit-limpio` — el kit pasa bk-lint (shellcheck y shfmt) y no le quedan TODOs | 4 |
| `readme-completo` — README.md sin TODOs, documenta bk-healthcheck con -j y -t, la línea de cron y la bitácora de la semana 13 | 4 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **Ningún fallo se pierde** | Cada pid guardado y su código recogido con `wait <pid>`; `wait -n` solo para dejar sitio; cada salida en su archivo de la carpeta temporal | Recoge los códigos, pero mezcla las salidas o depende de `wait -n` para algún código | 10 |
| **Nada queda vivo** | `trap` en `EXIT`, `INT` y `TERM`; la limpieza para los hijos con `kill`, los espera con `wait` y borra la carpeta temporal; sale con 130 o 143 | Para a los hijos, pero deja la carpeta temporal o sale con 0 tras una señal | 10 |
| **Apto para cron** | Encuentra `healthcheck.conf` desde `BASH_SOURCE`, sin depender de la carpeta ni del `PATH`; resumen a stderr; la línea de cron documentada con su log | Funciona desde cron, pero solo con la ruta del archivo escrita a mano | 10 |
| **Comentarios del porqué** | Explican por qué `wait <pid>` y no `wait -n`, por qué el `kill` sin comillas y qué pasa sin la limpieza; no repiten el código | Comentarios que repiten el código | 10 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| Un `wait` a secas decide el código de salida (un fallo pasa como bueno) | −10 pts |
| La limpieza usa `kill -9` sin probar antes con `TERM` | −5 pts |

---

## 📋 Checklist de entrega

- [ ] Los 7 labs con sus criterios de éxito comprobados
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/` sin ningún `TODO`
- [ ] `./scripts/verificar-semana.sh 13` con las 15 comprobaciones en verde

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Proyecto — `bashkit healthcheck`: comprobaciones en paralelo](3-proyecto/README.md) | [Recursos — ebooks](4-recursos/ebooks-free/README.md) → |

[↑ Semana 13](README.md)
