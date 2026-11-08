# Rúbrica de Evaluación — Semana 08

> Funciones, alcance y librerías. Se evalúan tres evidencias por separado y hace falta **70% en cada una**. Que una función funcione hoy no basta: tiene que seguir funcionando cuando la llamas desde otro bucle, desde otra carpeta o capturando su salida, y tienes que poder explicar por qué.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 7 labs, con sus criterios de éxito comprobados en el laboratorio |
| 📦 Producto | 30% | `lib/core.sh` y `bin/bashkit`: 60 pts de autograding + 40 pts de calidad |

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
| 1 | Un script llama a `check_file` en la línea 5 y la define en la línea 20. ¿Qué pasa y por qué? ¿Por qué `main "$@"` en la última línea lo evita? |
| 2 | Un script recibe `a b c`. Dentro de `show() { echo "$#"; }`, llamada como `show uno`, ¿qué imprime? ¿Y llamada como `show`? |
| 3 | ¿Para qué sirve el código de salida de una función y para qué lo que imprime? ¿Por qué `return 256` no sirve para devolver un total? |
| 4 | `is_log() { [[ $1 == *.log ]] \|\| exit 1; }`. ¿Qué pasa cuando un script la llama con `notas.txt` dentro de un `if !`? ¿Qué cambia `return 1`? |
| 5 | `n=$(count_errors "$f")` da `contando en app.log 2` en lugar de `2`. ¿Por qué? ¿Cómo se arregla sin quitar el mensaje? |
| 6 | Un bucle `for ((i = 0; i < 5; i++))` llama a una función que también usa `i` en un `for`. ¿Qué puede pasar y por qué shellcheck no avisa? |
| 7 | `local port=$(port_of "$name")`, y `port_of` falla. ¿Lo ve `set -e`? ¿Por qué se escribe en dos líneas? |
| 8 | ¿Qué hace `local -n out=$1`? ¿Por qué una función que la usa no puede recibir el nombre `out`? |
| 9 | ¿Qué diferencia hay entre `bash lib/core.sh` y `source lib/core.sh`? ¿Por qué `source lib/core.sh` dentro de un script falla si lo llamas desde otra carpeta, y cómo lo evita `BASH_SOURCE`? |
| 10 | En `bin/bashkit`, ¿por qué se valida el nombre del subcomando con una regex, y qué cambia `exec` frente a llamar a `bk-$sub` sin él? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** bash lee el script de arriba abajo, y una función solo existe a partir de su definición: en la línea 5, `check_file` da `command not found` (código `127`). Si todo el trabajo va dentro de funciones y la única llamada es `main "$@"` en la última línea, cuando bash llega a ella ya ha leído todas las definiciones, sea cual sea su orden.

**2.** `1`: dentro de una función, `$#`, `$1` y `"$@"` son los argumentos de la llamada, no los del script. Llamada como `show`, imprime `0`. Para que una función vea los argumentos del script hay que pasárselos: `show "$@"`.

**3.** El código (`0` sí, de `1` a `255` no) responde a una pregunta y lo usan `if`, `||` y `$?`. Lo que imprime es el dato, y se recoge con `$( )`. El código es un número de 0 a 255: `256` da la vuelta a `0`, y un total, un nombre o una ruta no caben ahí.

**4.** `exit` termina el script entero, aunque esté dentro de una función: el `if !` nunca recibe la respuesta y el script para en `notas.txt` con código `1`, sin mensaje. `return 1` termina solo la función con código `1`; el `if !` lo ve como "no es un log" y el script sigue.

**5.** `$( )` recoge todo lo que la función imprime por stdout, también un `echo` de depuración. El mensaje va a stderr (`echo "contando en $1" >&2`), que `$( )` no recoge: sigue saliendo en la terminal y la variable solo tiene el número.

**6.** Sin `local`, la `i` de la función es la misma que la del bucle: cada llamada la cambia, y el bucle de fuera se salta vueltas, termina antes o no termina nunca. shellcheck no avisa porque el script es correcto: no puede saber qué variables querías compartir. Por eso toda variable de una función va con `local`.

**7.** No. La línea sale con el código de `local`, que es `0`: el fallo de `port_of` se pierde, y ni `set -e` ni un `if` lo ven (`SC2155`). En dos líneas, `local port` y después `port=$(port_of "$name")`, la asignación sale con el código de `port_of`.

**8.** Hace que `out` sea otro nombre para la variable que se llama como `$1`: asignar a `out` cambia esa variable de quien llama. Si quien llama pasa `out`, queda `local -n out=out`, una referencia a sí misma (`circular name reference`). Por eso las referencias llevan nombres que nadie usaría fuera.

**9.** `bash lib/core.sh` lo ejecuta en otra bash, que define las funciones y termina: tu shell no las tiene. `source` lee el archivo dentro de la shell actual. Una ruta relativa en `source` se busca desde la carpeta en la que estás, no desde la del script. `${BASH_SOURCE[0]}` es la ruta del script, y `dirname` da su carpeta: `source "$(dirname "${BASH_SOURCE[0]}")/../lib/core.sh"` la encuentra desde cualquier sitio.

**10.** El nombre llega de quien escribe en la terminal y acaba dentro de una ruta: con `/` o `..` podría salir de `bin/`. La regex solo deja minúsculas y guiones. `exec` sustituye `bashkit` por `bk-$sub` sin volver: no queda un proceso esperando, y el código de salida que ve quien llamó es directamente el del subcomando.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 70, llevada a porcentaje. Cada criterio de éxito se comprueba ejecutando el comando en el laboratorio.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — Funciones](2-practicas/lab-01-funciones/README.md) | `$#` dentro y fuera y `main "$@"` explicados; `check-files.sh` con las cuatro líneas y shellcheck limpio | 10 |
| [02 — return y salida](2-practicas/lab-02-return-y-salida/README.md) | `return 256` y `exit` en `$( )` explicados; `lookup-port.sh` responde y rechaza bien | 10 |
| [03 — local y alcance](2-practicas/lab-03-local-y-alcance/README.md) | La `i` y el `count` explicados; `histogram.sh` con los cinco días y `5 días` | 10 |
| [04 — declare -n](2-practicas/lab-04-declare-n/README.md) | La referencia y el nombre circular explicados; `split-targets.sh` con el puerto 22 y shellcheck limpio | 10 |
| [05 — source y librerías](2-practicas/lab-05-source-y-librerias/README.md) | `bash` frente a `source` y la ruta relativa explicados; `make-slug.sh` funciona desde cualquier carpeta | 10 |
| [06 — Dispatcher](2-practicas/lab-06-dispatcher/README.md) | El `shift` y el uso por stderr explicados; `notes.sh` con `add`, `list`, `count` y código `2` | 10 |
| [07 — Funciones rotas](2-practicas/lab-07-funciones-rotas/README.md) | Los cuatro fallos explicados; `log-summary.sh` correcto y shellcheck limpio | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con tus palabras por qué funciona; 8 si se cumplen todos; 7 si falla uno; menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 08`. Es binario: pasa o no pasa.

| Comprobación | Puntos |
|---|:--:|
| `core-libreria` — `lib/core.sh` sin bit de ejecución; cargarlo no imprime nada ni cambia opciones | 4 |
| `core-log` — `log` escribe `nombre: mensaje` en stderr | 4 |
| `core-die` — `die` avisa y para con código `1` o el que recibe | 4 |
| `core-require` — `require` calla si existen; si falta uno, lo nombra y sale con `1` | 4 |
| `core-local` — `require` no pisa variables del script | 4 |
| `bashkit-ejecutable` — `bin/bashkit` con permisos `755` y shebang | 3 |
| `bashkit-ayuda` — `help`, `-h` y `--help`: uso y subcomandos por stdout, código `0` | 4 |
| `bashkit-uso` — sin argumentos: uso por stderr y código `2` | 3 |
| `bashkit-desconocido` — nombre inexistente, con `/` o con mayúsculas: aviso con el nombre y código `2` | 4 |
| `bashkit-ejecuta` — ejecuta `bk-check` y sale con su código | 4 |
| `bashkit-argumentos` — los argumentos llegan enteros | 4 |
| `bashkit-por-path` — funciona desde otra carpeta, por el `PATH` | 4 |
| `clean-usa-core` — `bk-clean` carga `core.sh`, usa `die` y avisa igual | 4 |
| `kit-limpio` — kit sin TODOs y limpio para `shellcheck -x` | 4 |
| `inventario-al-dia` — `docs/inventario.txt` incluye `./bin/bashkit` y `./lib/core.sh` | 3 |
| `readme-completo` — README sin TODOs, con `bashkit`, `core.sh` y la bitácora de la semana 08 | 3 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **Funciones** | Pequeñas, con un solo trabajo; toda variable `local`; `main "$@"` al final | Funcionan, pero alguna variable de función sin `local` | 10 |
| **Librería** | `core.sh` solo define funciones; se busca con `BASH_SOURCE`; `shellcheck shell=bash` y `source=` para shellcheck | Funciona, pero solo desde la raíz del kit | 10 |
| **Códigos y salidas** | Avisos con `log`/`die` a stderr; `2` para un uso mal hecho; `exec` y `"$@"` en el dispatcher | Algún mensaje en el canal equivocado | 10 |
| **Comentarios del porqué** | Explican `exec`, `BASH_SOURCE`, la validación del nombre y por qué `core.sh` no pone `set -e`; no repiten el código | Comentarios que repiten el código | 10 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| `bashkit` construye la ruta del subcomando sin validar el nombre | −10 pts |
| `lib/core.sh` ejecuta algo al cargarse (imprime, sale o cambia opciones) | −10 pts |

---

## 📋 Checklist de entrega

- [ ] Los 7 labs con sus criterios de éxito comprobados
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/` sin ningún `TODO`
- [ ] `./scripts/verificar-semana.sh 08` con las 16 comprobaciones en verde

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Proyecto — lib/core.sh y bashkit: un kit, un comando](3-proyecto/README.md) | [Recursos — ebooks](4-recursos/ebooks-free/README.md) → |

[↑ Semana 08](README.md)
