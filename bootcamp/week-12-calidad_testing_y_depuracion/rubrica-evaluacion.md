# Rúbrica de Evaluación — Semana 12

> Calidad, testing y depuración. Se evalúan tres evidencias por separado y hace falta **70% en cada una**. Que los tests pasen no basta: tienen que fallar cuando el comando se rompe, no dejar rastro y comprobar lo que ve quien usa el kit, y tienes que poder explicar por qué.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 7 labs, con sus criterios de éxito comprobados en el laboratorio |
| 📦 Producto | 30% | `tests/`, `bin/bk-lint`, `BK_TRACE` y el arreglo de `bk-report`: 60 pts de autograding + 40 pts de calidad |

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
| 1 | shellcheck marca `cp $src/$f $dest/` como `info` y `for f in $(ls $src)` como `error`. Con un archivo llamado `enero 2026.txt`, ¿qué hace mal cada una? ¿Por qué el arreglo que propone `Did you mean:` para la segunda no basta? |
| 2 | ¿Cuándo está bien escribir `# shellcheck disable=SC2016`, y por qué tiene que llevar un comentario con el motivo? Pon un ejemplo de un fallo que shellcheck no puede ver. |
| 3 | `shfmt -l` y `shfmt -d` encuentran los mismos archivos. ¿Por qué un CI usa `-d`? ¿Puede `shfmt -w` cambiar lo que hace un script? |
| 4 | ¿Por qué un test que llama a un script que tiene que fallar usa `run`? ¿Qué pasa si no lo usa? ¿Qué guardan `$status`, `$output` y `$stderr`? |
| 5 | Unos tests pasan la primera vez y fallan la segunda, sin cambiar nada. ¿Qué está pasando? ¿Qué hace bats con `$BATS_TEST_TMPDIR` y qué tiene que hacer tu `setup`? |
| 6 | ¿Para qué sirve `teardown`, si bats ya borra la carpeta temporal? Pon el ejemplo del lab 04. |
| 7 | ¿Por qué un test de regresión se escribe antes de arreglar el fallo? ¿Y cómo compruebas que tus tests de `bk-check` sirven para algo? |
| 8 | En la traza del lab 05, `total=4100` aparece con `[subshell 1]` y el `echo` final con `[subshell 0]`. ¿Qué te dice eso del fallo? ¿Por qué `PS4` se escribe con comillas simples? |
| 9 | ¿Para qué sirve `BASH_XTRACEFD`? ¿Qué problema tiene una traza que va a stderr, y por qué se puede dejar `BK_TRACE` en `core.sh` sin que moleste? |
| 10 | `count-ext.sh` tardaba 8 segundos y, con dos expansiones, 0,02. ¿Qué cuesta tanto? ¿Por qué `x=$(printf ...)` es lento aunque `printf` sea un builtin, y por qué un pipe de `sed`, `sort` y `uniq` es rapidísimo? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** Sin comillas, `$f` con `enero 2026.txt` se parte en dos argumentos, `enero` y `2026.txt`, y `cp` busca dos archivos que no existen. En `for f in $(ls $src)`, la salida de `ls` se parte por los espacios antes de llegar al `for`: el bucle recibe `enero` y `2026.txt` por separado. Citar `"$src"` arregla la carpeta, no los nombres que salen de `ls`; el arreglo es un glob, `for f in "$src"/*.txt`, que da cada nombre entero.

**2.** Cuando sabes por qué el aviso no es un fallo: en el lab 01, el `$HOME` del uso va entre comillas simples a propósito, para que se lea tal cual. El motivo escrito evita que alguien lo quite sin pensar o que crea que esconde un fallo. shellcheck no sabe qué hay en tus carpetas y archivos: un glob sin coincidencias (`carpeta/*.txt` en una carpeta vacía) o un `\r` de Windows solo salen al ejecutar.

**3.** `-l` sale con `0` aunque haya archivos por formatear; `-d` sale con `1`, y un CI necesita un código distinto de 0 para fallar. Además `-d` enseña qué cambiar. `shfmt -w` solo cambia espacios, saltos de línea y sangrías: el script hace lo mismo.

**4.** bats ejecuta cada test con `set -e`: un comando que sale con un código distinto de 0 para el test ahí, y no podrías comprobar que falla con el código y el aviso correctos. `run` lo ejecuta y guarda el código en `$status` y la salida en `$output` (stdout y stderr juntos); con `run --separate-stderr`, stderr va a `$stderr` y `$output` solo tiene stdout.

**5.** Los tests escriben archivos (un log, un inventario) en la carpeta desde la que lanzas bats, y la segunda vez empiezan con lo que dejó la primera. bats crea para cada test una carpeta vacía, `$BATS_TEST_TMPDIR`, y la borra al acabar, pero no entra en ella: el `setup` tiene que hacer `cd "$BATS_TEST_TMPDIR"`.

**6.** Para deshacer lo que impediría limpiar o lo que queda fuera de la carpeta temporal. En el lab 04, el test quita el permiso de escritura a `almacen/`; sin devolverlo, bats no puede borrar la carpeta y sale con `1` aunque todos los tests pasen. `teardown` corre siempre, también si el test falla.

**7.** Si el test no falla con el fallo, no lo está comprobando: verlo fallar demuestra que comprueba lo que crees, y verlo pasar después, que el arreglo funciona. Para saber si tus tests sirven, rompe `bk-check` en una copia (que salga siempre con 0) y pásalos: algún test tiene que fallar.

**8.** Que el bucle suma bien, pero en una copia de la shell: el `while` va detrás de un pipe y corre en un subshell; lo que cambia se pierde al terminar, y el `echo`, que va en la shell del script, ve `total=0`. Con comillas simples, `${LINENO}` y las demás variables se calculan en cada línea de la traza; con dobles, se calcularían una vez, al escribir `PS4`.

**9.** Es el descriptor al que `set -x` escribe la traza: abierto en un archivo, la traza va aparte. En stderr se mezcla con los avisos del script, y quien guarda los errores en un log recibe la traza entera. Como solo se activa si `BK_TRACE` tiene valor, sin ella `core.sh` no hace nada distinto.

**10.** Crear procesos: cada `$(basename ...)` y cada lado de `echo | sed` es un proceso nuevo, 6000 en total. `x=$(printf ...)` no lanza un programa, pero `$( )` crea un subshell, una copia de bash; `printf -v x` lo evita. Un pipe lanza cuatro procesos en total, uno por herramienta, y cada uno procesa los 2000 nombres de una vez: lo caro no es la herramienta, es lanzarla una vez por línea.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 70, llevada a porcentaje. Cada criterio de éxito se comprueba ejecutando el comando en el laboratorio.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — Los avisos de shellcheck](2-practicas/lab-01-avisos-de-shellcheck/README.md) | Código, gravedad y columna explicados; `archive-reports.sh` copia `enero 2026.txt` y pasa shellcheck con un solo `disable` justificado | 10 |
| [02 — Formato con shfmt](2-practicas/lab-02-formato-con-shfmt/README.md) | `-d`, `-l` y `-w` explicados; `rotate-logs.sh` formateado hace lo mismo y pasa `shfmt -d` con el `.editorconfig` | 10 |
| [03 — Primeros tests con bats](2-practicas/lab-03-primeros-tests-con-bats/README.md) | `run`, `$status`, `$output` y `$lines` explicados; el test de los dos espacios falló antes del arreglo; 4 tests en verde | 10 |
| [04 — setup, teardown y temporales en bats](2-practicas/lab-04-setup-y-temporales-en-bats/README.md) | Por qué fallaban la segunda vez y para qué hizo falta `teardown` explicados; 6 tests en verde, dos veces seguidas, sin rastro | 10 |
| [05 — La traza: set -x, PS4 y BASH_XTRACEFD](2-practicas/lab-05-traza-con-set-x/README.md) | La línea de la traza que delata el subshell señalada; `sum-sizes.sh` da 4100 bytes y su traza va a `TRACE` | 10 |
| [06 — Depurar con tests](2-practicas/lab-06-depurar-con-tests/README.md) | Cada test falló antes de su arreglo; `trap ERR` y el `[[ -r ]]` explicados; 5 tests en verde | 10 |
| [07 — Rendimiento: subshells y builtins](2-practicas/lab-07-rendimiento-subshells-y-builtins/README.md) | `real`, `user`, `sys` y el coste de `$( )` explicados; `count-ext.sh` sin ningún `++` en la traza | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con tus palabras por qué funciona; 8 si se cumplen todos; 7 si falla uno; menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 12`. Es binario: pasa o no pasa. 4 puntos por comprobación.

| Comprobación | Puntos |
|---|:--:|
| `lint-ayuda` — bashkit lint -h enseña el uso con código 0; un archivo que no existe avisa y sale con código 2 | 4 |
| `lint-shellcheck` — bk-lint encuentra una variable sin comillas (SC2086) en un script nuevo del kit y sale con código 1 | 4 |
| `lint-shfmt` — bk-lint enseña el diff de shfmt de un archivo mal sangrado, y bk-lint -w lo arregla | 4 |
| `lint-limpio` — el kit entero pasa bk-lint: shellcheck y shfmt sin avisos | 4 |
| `trace-archivo` — con BK_TRACE, la traza va a ese archivo con el archivo y la línea delante, y la salida no cambia | 4 |
| `trace-bashkit` — BK_TRACE llega del dispatcher al subcomando: la traza tiene líneas de bashkit, de bk-report y de core.sh | 4 |
| `report-127` — bk-report cuenta los bloques con códigos de más de un dígito (127, 130) | 4 |
| `tests-pasan` — bats tests pasa entero, con 14 tests o más | 4 |
| `tests-ficheros` — hay tests de bk-check y bk-run (3 o más en cada uno) y de bk-report (2 o más) | 4 |
| `mut-check` — los tests de bk-check fallan si bk-check da por bueno un valor malo | 4 |
| `mut-run` — los tests de bk-run fallan si bk-run sale siempre con 0 | 4 |
| `mut-report` — el test de regresión de bk-report falla si vuelve el fallo de los códigos de un dígito | 4 |
| `tests-aislados` — los tests no dejan archivos en el kit ni en la carpeta desde la que lanzas bats | 4 |
| `kit-limpio` — el kit y sus tests sin TODOs | 4 |
| `readme-completo` — README.md sin TODOs, documenta bk-lint y cómo pasar los tests, y tiene la bitácora de la semana 12 | 4 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **Tests que comprueban** | Cada test comprueba lo que ve el usuario (salida, código, stderr, archivos) con un nombre que lo dice; un caso bueno y uno malo de cada cosa | Pasan y fallan con el comando roto, pero con nombres vagos ("test 1") o comprobando solo `$status` | 10 |
| **Aislamiento** | Todo en `$BATS_TEST_TMPDIR`; los datos de cada test los prepara el propio test; lo común, en `test_helper.bash` | Aislados, pero con el `setup` copiado en cada archivo | 10 |
| **bk-lint** | Las dos revisiones siempre, con un solo estilo de shfmt para `-d` y `-w`; resumen a stderr y códigos 0, 1 y 2 | Funciona, pero se para en la primera revisión que falla | 10 |
| **Comentarios del porqué** | Explican `PS4` con comillas simples, `BASH_XTRACEFD`, el test de regresión y el `cd` del `setup`; no repiten el código | Comentarios que repiten el código | 10 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| Un `# shellcheck disable` sin un comentario que diga por qué | −5 pts |
| Un test que escribe fuera de su carpeta temporal (en el kit o en tu `$HOME`) | −10 pts |

---

## 📋 Checklist de entrega

- [ ] Los 7 labs con sus criterios de éxito comprobados
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/` sin ningún `TODO`
- [ ] `./scripts/verificar-semana.sh 12` con las 15 comprobaciones en verde

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Proyecto — Tests, lint y depuración de bashkit](3-proyecto/README.md) | [Recursos — ebooks](4-recursos/ebooks-free/README.md) → |

[↑ Semana 12](README.md)
