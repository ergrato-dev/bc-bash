# Rúbrica de Evaluación — Semana 09

> Arrays y printf. Se evalúan tres evidencias por separado y hace falta **70% en cada una**. Que una tabla salga bien con tus datos de prueba no basta: tiene que seguir alineada con nombres con espacios, con tildes y con logs que no esperabas, y tienes que poder explicar por qué.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 7 labs, con sus criterios de éxito comprobados en el laboratorio |
| 📦 Producto | 30% | `bin/bk-report` (`bashkit report`): 60 pts de autograding + 40 pts de calidad |

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
| 1 | `files=("mis notas.txt" informe.pdf)`. ¿Cuántos argumentos recibe `rm` con `rm ${files[@]}`, con `rm "${files[@]}"` y con `rm "${files[*]}"`? ¿Cuál es el correcto y por qué? |
| 2 | Un script guarda sus opciones de `tar` en un texto, `opts="-czf copia.tgz -C $src"`, y ejecuta `tar $opts`. ¿Qué pasa con `src="mis datos"`? ¿Por qué `tar "$opts"` tampoco funciona? |
| 3 | `echo "$servers"` imprime solo `web-01` aunque el array tiene cinco elementos. ¿Por qué? ¿Qué cuentan `${#servers}` y `${#servers[@]}`? |
| 4 | Después de `unset 'hosts[1]'`, un `for ((i = 0; i < ${#hosts[@]}; i++))` no llega al último elemento. ¿Por qué? ¿Cómo se recorre bien? |
| 5 | `m[web]=1; m[db]=2; declare -p m` da `declare -a m=([0]="2")`. ¿Qué ha pasado? ¿Qué faltaba? |
| 6 | Un script con `set -e` cuenta con `((count[$k]++))` y termina sin mensaje en la primera línea. ¿Por qué? ¿Por qué `count[$k]+=1` tampoco sirve? |
| 7 | `for k in "${!count[@]}"` saca las claves en un orden distinto del de entrada. ¿Por qué? ¿Cómo consigues una salida ordenada que no cambie entre ejecuciones? |
| 8 | ¿Por qué `printf "$line\n"` es peligroso cuando `line` viene de un archivo? ¿Qué escribes en su lugar? |
| 9 | `printf '%-10s|' José` deja la barra un carácter antes que con `Jose`. ¿Por qué? ¿Qué cuenta `${#name}`, y cómo lo usas para alinear? |
| 10 | En `bk-report`, ¿por qué el contador se lee con `${runs[$cmd]:-0}`, y por qué la condición del `== código` lleva `-n $cmd`? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** Sin comillas, tres (`mis`, `notas.txt`, `informe.pdf`): cada elemento se parte por los espacios, y `rm` intentaría borrar `mis` y `notas.txt`, que no existen o son otros. Con `"${files[@]}"`, dos, cada uno entero: el correcto. Con `"${files[*]}"`, uno solo, `mis notas.txt informe.pdf`, que tampoco existe. `[*]` sirve para escribir una lista, no para pasarla.

**2.** `$opts` sin comillas se parte por los espacios, también el de `mis datos`: `tar` recibe `mis` y `datos` como dos argumentos y no encuentra ninguno. `"$opts"` es un solo argumento con todas las opciones dentro, que `tar` no entiende. Un texto no puede guardar dónde acaba cada argumento; un array sí: `opts=(-czf copia.tgz -C "$src")` y `tar "${opts[@]}"`.

**3.** El nombre de un array sin `[ ]` es su casilla `0`: `$servers` es `${servers[0]}`. `${#servers}` es el largo de ese primer elemento, en caracteres (6 para `web-01`); `${#servers[@]}` es cuántos elementos tiene el array.

**4.** `unset` borra la casilla 1 sin mover las demás: quedan los índices 0, 2 y 3, y `${#hosts[@]}` vale 3. El bucle va de 0 a 2, lee la casilla 1 vacía y nunca llega a la 3. `for i in "${!hosts[@]}"` recorre los índices que existen; si no hacen falta los índices, `for h in "${hosts[@]}"`.

**5.** Sin `declare -A`, `m` es un array indexado, y lo que va entre `[ ]` es una cuenta: `web` y `db` son variables que no existen y valen `0`. Las dos asignaciones van a la casilla `0`, y la segunda pisa la primera. Faltaba `declare -A m` antes de usarlo.

**6.** `count[$k]++` vale lo que había antes de sumar: `0` la primera vez. `(( ))` con un resultado `0` sale con código 1, y `set -e` para el script. `count[$k]+=1` fuera de `$(( ))` añade el texto `1` al final: `1`, `11`, `111`. La forma segura es `count[$k]=$((${count[$k]:-0} + 1))`.

**7.** Un array asociativo guarda sus claves en una tabla hash: el orden en que salen depende de bash, no de cuándo entraron. Se ordena lo que sale: un `for` sobre `"${!count[@]}"` metido en un pipe a `sort` (con `LC_ALL=C` para que sea igual en cualquier máquina).

**8.** `printf` interpreta su primer argumento: un `%` dentro del dato (`100% remoto`) se lee como una instrucción, y la salida sale mal o el comando falla. El formato va fijo y entre comillas simples, y el dato como argumento: `printf '%s\n' "$line"`. shellcheck lo marca con `SC2059`.

**9.** En UTF-8, la `é` ocupa dos bytes, y el ancho de `printf` cuenta bytes: `José` son 5, y rellena un espacio menos. `${#name}` cuenta caracteres (4). Para alinear, escribes el texto y después los espacios que faltan: `printf '%s%*s' "$name" $((10 - ${#name})) ''`.

**10.** Un comando que aparece por primera vez no tiene casilla, y con `set -u` leerla pararía el script; `:-0` la lee como `0`. `-n $cmd` evita un `== código` sin cabecera delante, como el primero de un log recortado: con `cmd` vacío, `runs[""]` es una clave inválida y el script para con `bad array subscript`.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 70, llevada a porcentaje. Cada criterio de éxito se comprueba ejecutando el comando en el laboratorio.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — Arrays indexados](2-practicas/lab-01-arrays-indexados/README.md) | `[@]` frente a `!` y el nombre a secas explicados; `servers.sh` cuenta, da el primero y el último y numera | 10 |
| [02 — `[@]` frente a `[*]`](2-practicas/lab-02-arroba-y-asterisco/README.md) | Las tres expansiones y por qué `"$args"` no basta explicados; `make-backup.sh` con `mis datos` y `--sin-logs` | 10 |
| [03 — Huecos y slices](2-practicas/lab-03-huecos-y-slices/README.md) | El hueco y el `printf` sin argumentos explicados; `paginate.sh` pagina y rechaza con código `2` | 10 |
| [04 — Arrays asociativos](2-practicas/lab-04-arrays-asociativos/README.md) | `-v` y el orden de las claves explicados; `port-of.sh` busca, avisa y lista ordenado | 10 |
| [05 — Contar por clave](2-practicas/lab-05-contar-por-clave/README.md) | `((x++))` con `set -e` y `+=` explicados; `status-count.sh` con conteos y porcentajes | 10 |
| [06 — printf y formatos](2-practicas/lab-06-printf-y-formatos/README.md) | La repetición del formato y el dato en el formato explicados; `disk-table.sh` alineada y con barras | 10 |
| [07 — Tablas rotas](2-practicas/lab-07-tablas-rotas/README.md) | Los cuatro fallos explicados; `team-table.sh` alineada con tildes y shellcheck limpio | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con tus palabras por qué funciona; 8 si se cumplen todos; 7 si falla uno; menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 09`. Es binario: pasa o no pasa. 4 puntos por comprobación.

| Comprobación | Puntos |
|---|:--:|
| `report-ejecutable` — `bin/bk-report` ejecutable y con shebang | 4 |
| `report-usa-core` — carga `core.sh`, usa `die` y `declare -A` | 4 |
| `report-sin-log` — log ilegible: aviso con su nombre y código `1` | 4 |
| `report-uso` — más de un argumento: uso por stderr y código `2` | 4 |
| `report-cabecera` — cabecera `COMANDO VECES BIEN FALLOS` | 4 |
| `report-cuenta` — una fila por comando, ordenadas, y `TOTAL` | 4 |
| `report-alineado` — todas las líneas miden lo mismo | 4 |
| `report-ancho` — la primera columna se ensancha con un nombre largo | 4 |
| `report-vacio` — log vacío: cabecera y `TOTAL 0 0 0` | 4 |
| `report-cortado` — un log recortado o un bloque sin código no rompen la cuenta | 4 |
| `report-con-bk-run` — `bashkit report` resume el log de `bk-run` (`BK_LOG`) | 4 |
| `report-por-defecto` — sin argumento ni `BK_LOG`, lee `bk-run.log` | 4 |
| `kit-limpio` — kit sin TODOs y limpio para `shellcheck -x` | 4 |
| `inventario-al-dia` — `docs/inventario.txt` incluye `./bin/bk-report` | 4 |
| `readme-completo` — README sin TODOs, con `bk-report` y la bitácora de la semana 09 | 4 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **Arrays** | `declare -A` para lo que se busca por nombre; `"${arr[@]}"` y `"${!arr[@]}"` siempre entre comillas | Funcionan, pero alguna expansión sin comillas | 10 |
| **Contadores** | Asignaciones con `$(( ))` y `:-0`; nada de `((x++))` con `set -e` | Funcionan con los datos de prueba, pero dependen de `++x` u otro detalle | 10 |
| **printf** | Un formato fijo para toda la tabla; ningún dato dentro del formato; ancho calculado con `*` | Alineada, pero con anchos repetidos a mano en varios formatos | 10 |
| **Comentarios del porqué** | Explican `-A`, el `sort`, `:-0` y `-n $cmd`; no repiten el código | Comentarios que repiten el código | 10 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| Un dato del log dentro del formato de `printf` | −10 pts |
| La salida cambia de orden entre ejecuciones (claves sin ordenar) | −10 pts |

---

## 📋 Checklist de entrega

- [ ] Los 7 labs con sus criterios de éxito comprobados
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/` sin ningún `TODO`
- [ ] `./scripts/verificar-semana.sh 09` con las 15 comprobaciones en verde

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Proyecto — bashkit report: el log de bk-run en una tabla](3-proyecto/README.md) | [Recursos — ebooks](4-recursos/ebooks-free/README.md) → |

[↑ Semana 09](README.md)
