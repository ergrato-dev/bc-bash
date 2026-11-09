# Rúbrica de Evaluación — Semana 11

> Scripts robustos. Se evalúan tres evidencias por separado y hace falta **70% en cada una**. Que `bk-run` funcione cuando lo lanzas tú no basta: tiene que aguantar dos copias a la vez, un log bloqueado, un comando que falla y una opción mal escrita, y tienes que poder explicar por qué.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 7 labs, con sus criterios de éxito comprobados en el laboratorio |
| 📦 Producto | 30% | `bin/bk-run` y `lib/core.sh`: 60 pts de autograding + 40 pts de calidad |

**Mínimo 70% en cada evidencia.** No en el promedio.

| Calificación | Rango |
|---|:--:|
| Sobresaliente | 90-100% |
| Notable | 80-89% |
| Aprobado | 70-79% |
| No aprobado | < 70% |

---

## 🧠 Conocimiento (30%)

Diez preguntas, 3 puntos cada una. No se pide recordar sintaxis: se pide explicar por qué.

| # | Pregunta |
|:--:|---|
| 1 | Una función tiene un `cp` que falla y, debajo, un `echo "copiado"`. Llamada sola, `set -e` para el script; llamada como `if copiar; then`, escribe `copiado` y devuelve 0. ¿Por qué? ¿Cómo lo arreglas? |
| 2 | ¿Por qué `((n++))` para un script con `set -e` cuando `n` vale 0, y por qué `local x=$(comando)` no lo para aunque el comando falle? |
| 3 | ¿Qué tres problemas tiene escribir los temporales de un script en `/tmp/mi-script`? ¿Qué resuelve `mktemp -d`? |
| 4 | ¿Por qué el `trap 'rm -rf -- "$work"' EXIT` va justo después del `mktemp`, y por qué con comillas simples? ¿Cambia el código de salida del script? |
| 5 | Un script muere con código 143, otro con 130 y otro con 137. ¿Qué les pasó? ¿En cuál de los tres no corrió el `trap ... EXIT`, y por qué? |
| 6 | Con `trap 'echo cancelado' INT` (sin `exit`), pulsas `Ctrl-C` y el script sigue. ¿Por qué? ¿Y por qué un `kill` a un script que está en `sleep 30` tarda en hacer efecto? |
| 7 | En `while getopts ":ql:h" opt`, ¿qué significan los dos puntos de `l:` y los del principio? ¿Qué valen `opt` y `OPTARG` con `-x` y con una `-l` sin valor? |
| 8 | ¿Qué hace `shift $((OPTIND - 1))` y qué pasa si lo olvidas? ¿Por qué `bk-run -q ls -l` no toma la `-l` de `ls` por la suya? |
| 9 | ¿Por qué `flock` es mejor que un archivo con el PID para que un script no corra dos veces? ¿Cuándo se suelta el bloqueo, y por qué en el lab 05 siguió después de un `kill -9`? |
| 10 | En `bk-run`, ¿por qué la salida del comando va primero a un temporal y el log solo se bloquea para copiar el bloque, en lugar de bloquearlo desde el principio o escribir directo en él? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** Cuando el código de un comando lo va a mirar alguien (un `if`, un `||`, un `&&`), bash apaga `set -e` para ese comando y todo lo que ejecuta dentro: el `cp` falla, el `echo` corre, y la función devuelve el código del `echo`. Se arregla con `cp ... || return` dentro de la función: devuelve el código del `cp`.

**2.** `(( ))` sale con 1 cuando la cuenta da 0, y `n++` da el valor de antes de sumar: 0. No es un error, pero `set -e` lo ve como uno; `n=$((n + 1))` es una asignación y sale con 0. En `local x=$(comando)`, el código que se mira es el de `local`, que siempre sale bien. Se separa: `local x` y `x=$(comando)`.

**3.** Se quedan ahí al terminar; dos ejecuciones a la vez escriben en los mismos archivos; y si otro usuario crea antes esa ruta, el script no puede escribir (o escribe donde el otro quiere). `mktemp -d` crea una carpeta nueva en cada ejecución, con un nombre que no existía y permisos solo para ti.

**4.** Si algo falla entre el `mktemp` y el `trap`, `set -e` para el script y la carpeta se queda. Con comillas simples, `$work` se lee al salir; con dobles, se pone al escribir el `trap` (aquí da igual, pero es la costumbre que no falla). No cambia el código: el script sale con el que tenía (0, el del fallo, 130...).

**5.** 143 = 128 + 15: lo paró `TERM` (`kill`, systemd, `timeout`). 130 = 128 + 2: `INT`, un `Ctrl-C`. 137 = 128 + 9: `KILL`, `kill -9`. Con `KILL` no corre nada: el sistema mata el proceso sin entregarle la señal, así que ni el `trap ... EXIT` ni ninguno.

**6.** Un `trap` para `INT` sustituye lo que haría la señal (terminar) por sus comandos; si no hay `exit`, al acabar el script sigue donde estaba. Bash atiende las señales entre comando y comando: mientras espera a un `sleep 30` en primer plano, el `trap` no corre hasta que el `sleep` termina.

**7.** `l:` lleva valor, que llega en `OPTARG`. Los dos puntos del principio hacen que `getopts` no avise por su cuenta y deje los errores al script. Con `-x`, `opt` vale `?` y `OPTARG` es `x`; con `-l` sin valor, `opt` vale `:` y `OPTARG` es `l`.

**8.** `OPTIND` es la posición del primer argumento que no se ha leído: el `shift` quita las opciones y deja en `$@` el resto. Sin él, `$1` sigue siendo la primera opción. `getopts` para en lo primero que no empieza por `-`: en `ls`. Lo que va detrás es del comando.

**9.** El archivo con el PID se queda si el script muere con `kill -9`, y entre "mirar si existe" y "crearlo" otra copia puede colarse. `flock` lo comprueba el sistema de una vez, y el bloqueo se suelta solo cuando nadie tiene el archivo abierto. En el lab 05, el `sleep` hijo había heredado el descriptor: el bloqueo siguió hasta que el `sleep` terminó.

**10.** Escribiendo directo, las líneas de dos `bk-run` a la vez se mezclan y `bk-report` cuenta mal. Bloqueando desde el principio, un comando largo haría esperar a todos los demás, aunque no tengan nada que ver. Con el temporal, cada comando corre a su ritmo y solo la copia del bloque, que dura un momento, va de uno en uno.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 70, llevada a porcentaje. Cada criterio de éxito se comprueba ejecutando el comando en el laboratorio.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — Los límites de set -e](2-practicas/lab-01-limites-de-set-e/README.md) | Las tres excepciones explicadas; `backup-notes.sh` avisa del archivo que no copió y del origen que no existe, con código `1` | 10 |
| [02 — trap EXIT y mktemp](2-practicas/lab-02-trap-exit-y-mktemp/README.md) | `mktemp` y las comillas del `trap` explicadas; `top-words.sh` no deja nada en `TMPDIR`, ni bien ni con error | 10 |
| [03 — Señales: INT, TERM y KILL](2-practicas/lab-03-senales-int-y-term/README.md) | Los códigos 130, 143 y 137 explicados; `wait-for-file.sh` avisa, sale con su código y borra el PID | 10 |
| [04 — Opciones con getopts](2-practicas/lab-04-opciones-con-getopts/README.md) | `opt`, `OPTARG`, `OPTIND` y los dos puntos explicados; `grep-log.sh` con `-ic`, `-n` y errores con código `2` | 10 |
| [05 — Bloqueo con flock](2-practicas/lab-05-bloqueo-con-flock/README.md) | `-n`, `-w` y el bloqueo tras `kill -9` explicados; `nightly-report.sh` se rinde o espera según `WAIT` | 10 |
| [06 — Logging por niveles](2-practicas/lab-06-logging-por-niveles/README.md) | Por qué stderr explicado; `check-disk.sh` filtra por `LOG_LEVEL`, avisa de un nivel mal escrito y copia a `LOG_FILE` | 10 |
| [07 — Un script idempotente](2-practicas/lab-07-script-idempotente/README.md) | Los tres fallos explicados; dos ejecuciones de `setup-app.sh` dejan lo mismo | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con tus palabras por qué funciona; 8 si se cumplen todos; 7 si falla uno; menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 11`. Es binario: pasa o no pasa. 4 puntos por comprobación.

| Comprobación | Puntos |
|---|:--:|
| `run-piezas` — bk-run lee sus opciones con getopts y usa mktemp, trap y flock | 4 |
| `run-ayuda` — bk-run -h escribe el uso en stdout y sale con código 0 | 4 |
| `run-opcion-mal` — una opción desconocida o una -l sin valor avisan en stderr y salen con código 2 | 4 |
| `run-sin-comando` — sin comando, o con un -w que no es un número de segundos, avisa en stderr y sale con código 2 | 4 |
| `run-opcion-l` — -l elige el log: el bloque va a ese archivo y no a bk-run.log | 4 |
| `run-quiet` — -q no enseña la salida del comando, pero la guarda en el log | 4 |
| `run-doble-guion` — las opciones que van detrás del comando (o de --) son del comando, no de bk-run | 4 |
| `run-log-no-escribible` — si no puede escribir en el log, avisa con su nombre, sale con 1 y no ejecuta el comando | 4 |
| `run-temporal` — -v cuenta en stderr qué temporal usa (de mktemp); al terminar, bien o con un fallo, ya no existe y sale con el código del comando | 4 |
| `run-bloques-enteros` — dos bk-run a la vez con el mismo log no mezclan sus líneas: cada bloque va entero | 4 |
| `run-bloqueo` — si otro proceso tiene el log bloqueado más de -w segundos, avisa, sale con 1 y dice dónde dejó la salida | 4 |
| `run-niveles` — un fallo avisa con nivel warn, y con BK_LOG_LEVEL=error ese aviso no sale | 4 |
| `run-nivel-invalido` — un BK_LOG_LEVEL que no es debug, info, warn ni error para bk-run con código 2 | 4 |
| `kit-limpio` — el kit sin TODOs y limpio para shellcheck -x | 4 |
| `readme-completo` — README.md sin TODOs, documenta las opciones de bk-run y tiene la bitácora de la semana 11 | 4 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **Opciones** | `getopts` con los dos puntos del principio, valores por defecto antes del bucle, `-h` a stdout y errores a stderr con código `2` | Funciona, pero algún error sale con el aviso en inglés de `getopts` o con código `1` | 10 |
| **Limpieza** | El `trap` justo después del `mktemp`, con comillas simples y `--`; el temporal se conserva solo cuando es lo único que queda | El temporal se borra, pero el `trap` va lejos del `mktemp` | 10 |
| **Bloqueo y niveles** | El log se bloquea solo para copiar el bloque; los avisos usan `log_debug`/`log_warn`, nunca `echo ... >&2` sueltos | Bloquea bien, pero con avisos sin nivel | 10 |
| **Comentarios del porqué** | Explican los dos puntos de `getopts`, el `shift`, el temporal, el `trap - EXIT` y el `return 0` de `log_at`; no repiten el código | Comentarios que repiten el código | 10 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| Un temporal con ruta fija (`/tmp/bk-run.tmp`) en lugar de `mktemp` | −10 pts |
| `rm -rf` de una variable sin comillas o sin `--` | −10 pts |

---

## 📋 Checklist de entrega

- [ ] Los 7 labs con sus criterios de éxito comprobados
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/` sin ningún `TODO`
- [ ] `./scripts/verificar-semana.sh 11` con las 15 comprobaciones en verde

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Proyecto — bk-run robusto: opciones, temporales y bloqueo](3-proyecto/README.md) | [Recursos — ebooks](4-recursos/ebooks-free/README.md) → |

[↑ Semana 11](README.md)
