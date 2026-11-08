# Rúbrica de Evaluación — Semana 07

> Bucles, read y archivos seguros. Se evalúan tres evidencias por separado y hace falta **70% en cada una**. Que un bucle funcione con `notas.txt` no basta: tiene que funcionar con `mi foto.jpg`, con un nombre que empieza por `-`, con uno que lleva un salto de línea y con una carpeta vacía, y tienes que poder explicar por qué.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 7 labs, con sus criterios de éxito comprobados en el laboratorio |
| 📦 Producto | 30% | `bin/bk-clean`: 60 pts de autograding + 40 pts de calidad |

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
| 1 | En una carpeta con `mi foto.jpg` y `notas.txt`, ¿cuántas vueltas da `for f in $(ls)` y cuántas `for f in *`? ¿Por qué? |
| 2 | En una carpeta vacía, ¿qué vale `f` en la única vuelta de `for f in *.log`? ¿Qué cambia `shopt -s nullglob`, y qué otra forma hay de no tropezar? |
| 3 | ¿Qué diferencia hay entre `while X` y `until X`? ¿Por qué un bucle que espera a que aparezca un archivo necesita un límite? |
| 4 | Después de `for ((i = 1; i <= 9; i++)); do ...; break; ...; done`, ¿cómo sabe el script si salió por el `break` o dio todas las vueltas? |
| 5 | Con `set -e` y `count=0`, `((count++))` para el script. ¿Por qué? ¿Por qué `count=$((count + 1))` no lo para? |
| 6 | ¿Qué hacen `IFS=` y `-r` en `while IFS= read -r line`? Da un ejemplo de línea que cambiaría sin cada uno. |
| 7 | Un archivo termina sin salto de línea. ¿Por qué `while read` no procesa la última línea, y qué añade `\|\| [[ -n $line ]]`? |
| 8 | Con `mapfile -t lines < hosts.txt`, ¿qué imprime `echo "${lines[n - 1]}"` con `n=0`? ¿Por qué es peor que un error? |
| 9 | ¿Por qué `find -print0` con `read -d ''` funciona con cualquier nombre y `find` con `read` no? ¿Qué carácter no puede ir en un nombre? |
| 10 | `n=0; find . -print0 \| while IFS= read -r -d '' f; do n=$((n + 1)); done; echo "$n"` imprime `0`. ¿Por qué? ¿Qué cambia `done < <(find ...)`? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** `$(ls)` da tres vueltas: `ls` devuelve el texto `mi foto.jpg notas.txt` y bash lo parte por los espacios en `mi`, `foto.jpg` y `notas.txt`. El glob `*` da dos: bash busca los nombres y entrega cada uno entero, sin pasar por un texto que partir.

**2.** Si un glob no encaja con nada, bash lo deja tal cual: `f` vale `*.log`, un archivo que no existe. Con `nullglob`, un glob sin coincidencias desaparece y el bucle da cero vueltas. La otra forma es comprobar dentro que `f` es un archivo de verdad: `[[ -f $f ]] || continue`.

**3.** `while X` repite mientras `X` sale con `0`; `until X`, mientras sale con algo distinto de `0`, es decir, hasta que se cumple. `until X` es `while ! X`. Si el archivo no llega nunca, la condición no cambia y el script se queda esperando para siempre: un contador con un tope y un `exit 1` lo evitan.

**4.** Con una variable que se rellena justo antes del `break` (`free="copia.$i"`). Después del bucle, si tiene algo, se salió por el `break`; si sigue vacía, el bucle dio todas las vueltas sin encontrar nada.

**5.** `(( ))` es un comando que sale con `1` si el resultado de la cuenta es `0`, y `count++` da el valor de antes de sumar: con `count=0`, el resultado es `0`, el código es `1` y `set -e` para el script sin mensaje. `$(( ))` es una expansión dentro de una asignación: la línea siempre sale con `0`.

**6.** `-r` hace que `read` no trate `\` como especial: sin él, `C:\temp` llega como `C:temp`. `IFS=` vacía los separadores para ese `read`: sin él, `   sangría` llega como `sangría`, sin los espacios del principio. Con los dos, la línea llega tal cual.

**7.** `read` sí lee la última línea y la guarda en la variable, pero sale con `1` porque no encontró el salto de línea, y el `while` termina sin darle la vuelta. `|| [[ -n $line ]]` da una vuelta más si `read` falló pero leyó algo; al final de verdad, la variable queda vacía y el bucle termina.

**8.** `${lines[-1]}`: el último elemento. Un índice negativo cuenta desde el final. Es peor que un error porque la respuesta parece correcta: el script sigue con un dato que no es el que se pidió. El número se valida antes de usarlo.

**9.** `find` sin opciones separa las rutas con saltos de línea, y un nombre puede contener un salto de línea: `read` lo parte en dos rutas que no existen. `-print0` las separa con el byte nulo, y `read -d ''` corta solo ahí. El byte nulo es el único carácter, junto con `/`, que no puede ir en un nombre, y `/` separa carpetas, no rutas.

**10.** Detrás de un pipe, el `while` va en un subshell: una copia de la shell con su propia `n`, que cuenta hasta el final y desaparece. La `n` de la shell sigue en `0`. Con `done < <(find ...)`, el `find` corre aparte y su salida llega al bucle como un archivo; el `while` se queda en la shell y `n` conserva la cuenta.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 70, llevada a porcentaje. Cada criterio de éxito se comprueba ejecutando el comando en el laboratorio.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — for](2-practicas/lab-01-for/README.md) | `$(ls)` y `nullglob` explicados; `sizes.sh` con `total: 16 bytes` y shellcheck limpio | 10 |
| [02 — while y until](2-practicas/lab-02-while-y-until/README.md) | `while` frente a `until` explicados; `wait-for-file.sh` espera, cuenta y para en el límite | 10 |
| [03 — break y continue](2-practicas/lab-03-break-y-continue/README.md) | `continue` sin `break` y el "¿hubo break?" explicados; `first-free.sh` encuentra el hueco | 10 |
| [04 — read e IFS](2-practicas/lab-04-read-e-ifs/README.md) | `-r`, `IFS=` y la última línea explicados; `list-users.sh` lista a las tres personas | 10 |
| [05 — mapfile](2-practicas/lab-05-mapfile/README.md) | `-t` y el índice `0` explicados; `line-at.sh` responde y rechaza bien | 10 |
| [06 — find -print0](2-practicas/lab-06-find-print0/README.md) | Las cuatro vueltas y el `n` en `0` explicados; `total-size.sh` da `13 bytes en 3 archivos` | 10 |
| [07 — Bucles rotos](2-practicas/lab-07-bucles-rotos/README.md) | Los cuatro fallos explicados; `count-errors.sh` correcto y shellcheck limpio | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con tus palabras por qué funciona; 8 si se cumplen todos; 7 si falla uno; menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 07`. Es binario: pasa o no pasa.

| Comprobación | Puntos |
|---|:--:|
| `clean-ejecutable` — `bin/bk-clean` con permisos `755` y shebang | 3 |
| `clean-ayuda` — `-h` y `--help`: uso por stdout y código `0` | 3 |
| `clean-uso` — sin argumentos o sin carpeta: uso por stderr y código `2` | 4 |
| `clean-dias-invalidos` — `abc`, `0`, `-3`, `7d` y `1.5`: aviso y código `2` | 4 |
| `clean-carpeta-mala` — una carpeta que no existe: aviso, código `1` y nada borrado | 4 |
| `clean-dry-run` — `--dry-run` lista los 6 viejos y no borra ninguno | 5 |
| `clean-borra-viejos` — borra los viejos y deja los nuevos | 5 |
| `clean-nombres-raros` — borra los que empiezan por `-`, el `*` y el del salto de línea | 5 |
| `clean-subcarpetas` — entra en las subcarpetas y no borra la carpeta | 3 |
| `clean-no-sale` — no toca el enlace, ni lo que hay fuera, ni otras carpetas | 5 |
| `clean-varias-carpetas` — limpia dos carpetas en una llamada | 3 |
| `clean-total` — `total: 7 archivos` | 5 |
| `kit-limpio` — scripts del kit sin TODOs, `bk-clean` con `-print0`, `read -r -d ''` y `rm --`, shellcheck limpio | 5 |
| `inventario-al-dia` — `docs/inventario.txt` incluye `./bin/bk-clean` | 3 |
| `readme-completo` — README sin TODOs, con `bk-clean` y la bitácora de la semana 07 | 3 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **Recorrer archivos** | `find -print0` con `while IFS= read -r -d ''` y `< <(...)`; `"$file"` citado en cada uso | Funciona, pero con alguna variable sin comillas o un `IFS=` de menos | 10 |
| **Seguridad** | Todas las carpetas validadas antes del primer `rm`; `rm --`; `-type f`; nada se borra con `--dry-run` | Funciona, pero valida cada carpeta justo antes de limpiarla | 10 |
| **Códigos y salidas** | `2` para un uso mal hecho, `1` para una carpeta que no existe; errores a stderr; `borrar:` y `total:` a stdout | Algún mensaje en el canal equivocado | 10 |
| **Comentarios del porqué** | Explican `-print0`, `< <(...)` frente al pipe, `-type f` y `-mmin`; no repiten el código | Comentarios que repiten el código | 10 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| `bk-clean` recorre archivos con `for f in $(find ...)` o `$(ls)` | −10 pts |
| `bk-clean` borra algo fuera de las carpetas que recibe, o con `--dry-run` | −20 pts |

---

## 📋 Checklist de entrega

- [ ] Los 7 labs con sus criterios de éxito comprobados
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/` sin ningún `TODO`
- [ ] `./scripts/verificar-semana.sh 07` con las 15 comprobaciones en verde

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Proyecto — bk-clean: borrar lo viejo sin miedo](3-proyecto/README.md) | [Recursos — ebooks](4-recursos/ebooks-free/README.md) → |

[↑ Semana 07](README.md)
