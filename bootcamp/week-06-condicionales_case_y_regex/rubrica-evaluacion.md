# Rúbrica de Evaluación — Semana 06

> Condicionales, case y regex. Se evalúan tres evidencias por separado y hace falta **70% en cada una**. Que una condición funcione con `ana` no basta: tiene que responder bien con `ana maria`, con un texto vacío y con `900` frente a `1000`, y tienes que poder explicar por qué.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 7 labs, con sus criterios de éxito comprobados en el laboratorio |
| 📦 Producto | 30% | `bin/bk-check`: 60 pts de autograding + 40 pts de calidad |

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
| 1 | `if grep -q ana /etc/passwd; then` no compara nada. ¿Qué decide entonces si se entra en el `then`? ¿Por qué `set -e` no para el script cuando ese `grep` no encuentra nada? |
| 2 | ¿Por qué `[3 -gt 2]` da `command not found`, y qué tiene que ver con que `[` sea un comando? |
| 3 | Con `x="ana maria"`, `[ $x == root ]` da `too many arguments`; con `x=""`, `unary operator expected`. Explica los dos errores y por qué `[[ $x == root ]]` no da ninguno. |
| 4 | `[[ 900 > 1000 ]]` se cumple. ¿Por qué? ¿Qué pasa con `[ 900 > 1000 ]`, y qué escribirías para comparar los números? |
| 5 | Un enlace `zona/roto` aparece en `ls`, pero `[[ -e zona/roto ]]` da `1`. ¿Por qué? ¿Qué operador lo detecta, y por qué tiene que ir antes que `! -e` en una cadena de `elif`? |
| 6 | En un `case` con `*.gz)` antes de `*.tar.gz)`, ¿qué rama usa `app.tar.gz`, y por qué? ¿Dónde tiene que ir siempre `*)`? |
| 7 | ¿Por qué `[[ $v =~ "$re" ]]` casi nunca encaja y `[[ $v =~ $re ]]` sí? ¿Por qué la regex se guarda en una variable? |
| 8 | ¿Para qué sirven `^` y `$` en la regex de una IP? Da un valor que una regex sin ellos aceptaría por error. |
| 9 | Con `[[ 2.0.0-rc.1 =~ $re ]]` y la regex de semver del proyecto, ¿qué hay en `BASH_REMATCH[0]`, `[4]` y `[5]`? ¿Por qué el 5 está "dentro" del 4? |
| 10 | Un script recibe `"informe final.txt" notas.txt`. ¿Qué recibe `touch` con `touch $*`, con `touch "$*"` y con `touch "$@"`? ¿Para qué sirve el `shift` después de leer un `-v`? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** `if` ejecuta el comando y mira su código de salida: con `0` entra en el `then`; con cualquier otro, en el `elif`/`else` o salta al `fi`. `grep -q` sale con `0` si encuentra el texto y con `1` si no. Un comando que falla en la condición de un `if` es una respuesta, no un error, y `set -e` no salta: si lo hiciera, ningún `if` podría responder "no".

**2.** bash separa la línea en palabras por los espacios: `[3` es una sola palabra, y bash busca un comando con ese nombre, que no existe. `[` es un comando (el mismo que `test`) que recibe la condición como argumentos y exige que el último sea `]`; por eso los espacios dentro de los corchetes son obligatorios.

**3.** `[` es un comando y sus argumentos pasan por el word splitting. Con `ana maria`, recibe `ana`, `maria`, `==`, `root`, `]`: demasiados para una comparación. Con la variable vacía y sin comillas, desaparece: recibe `==`, `root`, `]`, y `==` no tiene operando a la izquierda. `[[ ]]` es sintaxis de bash: no parte las variables, así que `$x` es siempre un solo texto, vacío o con espacios.

**4.** Dentro de `[[ ]]`, `>` compara textos en orden de diccionario, carácter a carácter: `9` va después de `1`, así que `"900"` "es mayor" que `"1000"`. Dentro de `[ ]`, `>` es una redirección: crea un archivo llamado `1000`, y lo que queda, `[ 900 ]`, se cumple porque `900` no está vacío. Para números, `[[ 900 -gt 1000 ]]` o `(( 900 > 1000 ))`.

**5.** `-e` sigue el enlace y mira su destino, que no existe. `-L` mira el enlace en sí y se cumple. En una cadena de `elif`, bash entra en la primera rama que se cumple: si `! -e` fuera antes, el enlace roto diría "no existe" y nunca llegaría a la rama de `-L`.

**6.** `case` usa la primera rama que encaja, y `app.tar.gz` encaja con `*.gz`: sugiere `gunzip`, que no saca lo que hay dentro del `tar`. El patrón más concreto va antes que el más general. `*)` encaja con todo, así que va siempre la última; arriba, las demás no se usarían nunca.

**7.** A la derecha de `=~`, lo que va entre comillas es texto literal: `"$re"` busca los caracteres de la regex, con sus corchetes y paréntesis, y no la regex. Se guarda en una variable porque, escrita dentro de `[[ ]]`, sus paréntesis, `|` y espacios se mezclan con la sintaxis de bash; en la variable, con comillas simples, queda tal cual, y se usa sin comillas.

**8.** Anclan la regex al principio y al final del texto: sin ellos, basta con que un trozo encaje. `x1.2.3.4y`, `1.2.3.4.5` o `1.2.3.456` (que contiene `1.2.3.45`) pasarían como IP.

**9.** `[0]` es el texto entero que encajó: `2.0.0-rc.1`. Los grupos se numeran por el orden de su paréntesis de apertura: el 4 es `(-(...))`, con el guion, `-rc.1`; el 5 es el de dentro, sin el guion, `rc.1`. Está dentro porque su paréntesis se abre después del del 4 y se cierra antes.

**10.** Con `touch $*`, tres argumentos: `informe`, `final.txt` y `notas.txt` (los junta y los vuelve a partir por los espacios). Con `touch "$*"`, uno solo: `informe final.txt notas.txt`. Con `touch "$@"`, dos, tal como llegaron. `shift` quita el `-v` de los argumentos, así que `"$@"` queda solo con los nombres de archivo.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 70, llevada a porcentaje. Cada criterio de éxito se comprueba ejecutando el comando en el laboratorio.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — if y códigos de salida](2-practicas/lab-01-if-y-codigos-de-salida/README.md) | `[3` y `set -e` en un `if` explicados; `need-tool.sh` distingue instalado, parte de bash y falta | 10 |
| [02 — Comparar textos y números](2-practicas/lab-02-comparar-textos-y-numeros/README.md) | `>` frente a `-gt` y los errores de `[ ]` explicados; `check-quota.sh` sin crear archivos | 10 |
| [03 — Operadores de archivo](2-practicas/lab-03-operadores-de-archivo/README.md) | Enlace roto y orden de `-d`/`-x` explicados; `path-kind.sh` con las seis respuestas | 10 |
| [04 — case](2-practicas/lab-04-case/README.md) | Orden de las ramas y `"*"` explicados; `extract-hint.sh` con mayúsculas y `*)` | 10 |
| [05 — Regex y BASH_REMATCH](2-practicas/lab-05-regex-y-bash-rematch/README.md) | Comillas en `=~` explicadas; `parse-date.sh` separa y rechaza fechas | 10 |
| [06 — Argumentos](2-practicas/lab-06-argumentos/README.md) | `"$@"`, `$@` y `"$*"` explicados; `make-files.sh` con espacios y `-v` | 10 |
| [07 — Condiciones rotas](2-practicas/lab-07-condiciones-rotas/README.md) | Los cuatro fallos explicados; `validate-user.sh` correcto y shellcheck limpio | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con tus palabras por qué funciona; 8 si se cumplen todos; 7 si falla uno; menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 06`. Es binario: pasa o no pasa.

| Comprobación | Puntos |
|---|:--:|
| `check-ejecutable` — `bin/bk-check` con permisos `755` y shebang | 3 |
| `check-ayuda` — `-h` y `--help`: uso por stdout y código `0` | 3 |
| `check-uso` — sin argumentos, con uno o con tres: uso por stderr y código `2` | 4 |
| `check-tipo-desconocido` — tipo desconocido: aviso con su nombre y código `2` | 4 |
| `ip-valida` — `ok: 192.168.1.10` y código `0` | 4 |
| `ip-limites` — `0.0.0.0` y `255.255.255.255` válidas | 3 |
| `ip-rechaza` — rechaza números fuera de rango, ceros delante, partes de más o de menos y texto alrededor | 5 |
| `email-valido` — acepta `ana.perez+tienda@correo.example.com` | 3 |
| `email-rechaza` — rechaza emails sin usuario, sin dominio, con espacios o con dos `@` | 5 |
| `semver-partes` — `ok: 1.4.2 (mayor 1, menor 4, parche 2)` | 5 |
| `semver-prerelease` — añade `, prerelease rc.1` | 4 |
| `semver-rechaza` — rechaza `1.2`, `1.2.3.4`, `01.2.3`, `v1.2.3` y `1.2.3-` | 5 |
| `kit-limpio` — scripts del kit sin TODOs, `bk-check` con `case` y `=~`, shellcheck limpio | 5 |
| `inventario-al-dia` — `docs/inventario.txt` incluye `./bin/bk-check` | 3 |
| `readme-completo` — README sin TODOs, con `bk-check` y la bitácora de la semana 06 | 4 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **Condiciones** | `[[ ]]` en todas, nunca `[ ]`; `-ne`/`-gt` para números y `==` para textos; la regex en variable y sin comillas detrás de `=~` | Funciona, pero mezcla `[ ]` y `[[ ]]` o compara números con `==` | 10 |
| **Estructura** | Un `case` elige la regex y un solo `if` la comprueba; `*)` el último | Funciona, pero repite el `if` y el mensaje en cada rama | 10 |
| **Códigos y salidas** | `2` para un uso mal hecho, `1` para un valor que no vale; errores a stderr; `ok` y `--help` a stdout | Algún mensaje en el canal equivocado | 10 |
| **Comentarios del porqué** | Explican `^`/`$`, los ceros a la izquierda y la regex sin comillas; no repiten el código | Comentarios que repiten el código | 10 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| `bk-check` llama a `grep`, `sed` u otro programa para validar, en lugar de `=~` | −10 pts |

---

## 📋 Checklist de entrega

- [ ] Los 7 labs con sus criterios de éxito comprobados
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/` sin ningún `TODO`
- [ ] `./scripts/verificar-semana.sh 06` con las 15 comprobaciones en verde

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Proyecto — bk-check: validar antes de usar](3-proyecto/README.md) | [Recursos — ebooks](4-recursos/ebooks-free/README.md) → |

[↑ Semana 06](README.md)
