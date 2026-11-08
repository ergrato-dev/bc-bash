# Rúbrica de Evaluación — Semana 03

> Redirección, pipes y códigos de salida. Se evalúan tres evidencias por separado y hace falta **70% en cada una**. Que un script "funcione" no basta: tiene que separar resultados de mensajes y decir la verdad con su código de salida.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 7 labs, con sus criterios de éxito comprobados en el laboratorio |
| 📦 Producto | 30% | `bin/bk-run`: 60 pts de autograding + 40 pts de calidad |

**Mínimo 70% en cada evidencia.** No en el promedio.

| Calificación | Rango |
|---|:--:|
| Sobresaliente | 90-100% |
| Notable | 80-89% |
| Aprobado | 70-79% |
| No aprobado | < 70% |

---

## 🧠 Conocimiento (30%)

Diez preguntas, 3 puntos cada una. No se pide recordar opciones: se pide explicar por qué.

| # | Pregunta |
|:--:|---|
| 1 | Si stdout y stderr acaban en la misma pantalla, ¿para qué sirve que sean dos canales distintos? Pon un ejemplo en el que importe. |
| 2 | `sort notas.txt > notas.txt` deja el archivo vacío. ¿Por qué, si `sort` no ha escrito nada todavía? |
| 3 | `comando > log 2>&1` guarda todo en `log`, pero `comando 2>&1 > log` deja los errores en pantalla. Explica qué pasa paso a paso en cada caso. |
| 4 | `ls /no-existe \| wc -l` imprime `0` y `$?` vale `0`. ¿Por qué, y qué cambia `set -o pipefail`? |
| 5 | ¿Por qué un script debe escribir sus mensajes de error con `>&2` y no con un `echo` normal? Piensa en quien guarda su salida con `>`. |
| 6 | ¿Qué diferencia hay entre `<<EOF` y `<<'EOF'`? ¿Cuándo necesitas cada uno al generar un archivo desde un script? |
| 7 | `grep -q alumno /etc/passwd; echo $?; echo $?` imprime `0` y `0`, pero si el usuario no existe imprime `1` y `0`. ¿Por qué el segundo es siempre `0`? |
| 8 | Un script termina con `echo "copia hecha"` aunque el `cp` anterior falló. ¿Con qué código sale y qué problema causa a quien lo use con `&&`? |
| 9 | Con `set -e`, ¿por qué `grep -q x f \|\| echo "no está"` no para el script cuando `grep` no encuentra nada? |
| 10 | `bk-run` guarda el código con `status=0` y `"$@" ... \|\| status=$?`. ¿Qué pasaría con `set -e` si escribieras solo `"$@" \| tee -a "$log"` y después `status=$?`? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** Porque quien ejecuta el comando puede tratarlos por separado: guardar o encadenar los resultados (`> lista.txt`, `| wc -l`) y seguir viendo los errores, o tirar los avisos (`2> /dev/null`) sin perder los resultados. Ejemplo: `find /etc -name '*.conf' > lista.txt` deja una lista limpia y enseña en pantalla las carpetas que no pudo leer.

**2.** bash aplica las redirecciones antes de arrancar el comando, y `>` vacía el archivo al abrirlo. Cuando `sort` empieza a leer `notas.txt`, ya está vacío. Hay que escribir en otro archivo y renombrarlo después.

**3.** Las redirecciones se aplican de izquierda a derecha y `2>&1` copia el destino del 1 en ese momento. En el primero, `> log` mueve el 1 al archivo y luego el 2 copia el 1: los dos al archivo. En el segundo, el 2 copia el 1 cuando aún es la terminal y luego `> log` mueve solo el 1: el 2 sigue en la terminal.

**4.** `ls` falla y escribe el error por stderr, que no entra en el pipe. `wc` recibe 0 líneas, imprime `0` y sale con éxito. Sin `pipefail`, el código de un pipe es el del último comando. Con `pipefail`, es el del último que falló: `2`, el de `ls`.

**5.** Si el error va por stdout, quien haga `script > datos.txt` lo guardará mezclado con los resultados y no lo verá en pantalla. Por stderr, el mensaje sale por pantalla y los datos quedan limpios. También permite callarlo a propósito con `2> /dev/null`.

**6.** Con `<<EOF` bash sustituye `$VAR` y `$( )` dentro del texto, como entre comillas dobles: sirve para meter datos del momento (usuario, fecha). Con `<<'EOF'` el texto llega tal cual: sirve cuando el archivo generado tiene sus propios `$`, como otro script o una configuración que resolverá otra aplicación.

**7.** `$?` es el código del último comando. El primer `echo $?` muestra el de `grep`; el segundo muestra el del primer `echo`, que funcionó. Si hace falta el código más tarde, se guarda en una variable nada más terminar el comando.

**8.** Sale con `0`, el código del último `echo`. Quien haga `script && siguiente` creerá que todo fue bien y seguirá, aunque la copia no exista. Un script tiene que terminar con un código que diga la verdad: `set -e` o un `exit` con el código del fallo.

**9.** `-e` no actúa sobre los comandos que se usan para decidir, como el de la izquierda de `||` o `&&`. El `||` dice que ese fallo es esperado y lo tratas tú.

**10.** Con `pipefail`, el pipe fallaría con el código del comando y `-e` pararía `bk-run` en esa línea. `status=$?` no llegaría a ejecutarse, el log se quedaría sin la línea `== código: N ==` y no habría aviso. El `||` hace que el fallo no pare el script y guarda el código.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 70, llevada a porcentaje. Cada criterio de éxito se comprueba ejecutando el comando en el laboratorio.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — stdout y stderr](2-practicas/lab-01-stdout-y-stderr/README.md) | `>` y `2>` explicados; `find-ssl.sh` separa lista y avisos y escribe `listo` por stderr | 10 |
| [02 — Sobrescribir y añadir](2-practicas/lab-02-sobrescribir-y-anadir/README.md) | Trampa de `cat f > f` y `noclobber` explicados; `add-note.sh` suma una nota por ejecución | 10 |
| [03 — El orden de las redirecciones](2-practicas/lab-03-orden-de-las-redirecciones/README.md) | Orden explicado con `/proc/self/fd`; `capture-all.sh` deja 8 líneas sin imprimir nada | 10 |
| [04 — Pipes y tee](2-practicas/lab-04-pipes-y-tee/README.md) | stderr fuera del pipe y código del pipe explicados; `users-report.sh` completo | 10 |
| [05 — Here-docs y here-strings](2-practicas/lab-05-here-docs-y-here-strings/README.md) | `<<EOF` frente a `<<'EOF'` explicado; `write-config.sh` genera las cinco líneas | 10 |
| [06 — Códigos de salida](2-practicas/lab-06-codigos-de-salida/README.md) | `$?`, códigos de `grep`, `&&` y `\|\|` explicados; `preflight.sh` sale con 4 o con 0 | 10 |
| [07 — Modo estricto](2-practicas/lab-07-modo-estricto/README.md) | Cada opción explicada con su error; `archive-notes.sh` arreglado sale con 0 | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con tus palabras por qué funciona; 8 si se cumplen todos; 7 si falla uno; menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 03`. Es binario: pasa o no pasa.

| Comprobación | Puntos |
|---|:--:|
| `run-ejecutable` — `bin/bk-run` con permisos `755` y shebang | 3 |
| `run-estricto` — `set -euo pipefail` en `bk-run` | 4 |
| `run-uso-codigo` — sin argumentos sale con `2` | 3 |
| `run-uso-stderr` — el mensaje de uso va por stderr | 4 |
| `run-cabecera` — cabecera con fecha, hora y comando | 4 |
| `run-pantalla` — la salida del comando se ve en pantalla | 3 |
| `run-log-salida` — la salida queda en el log | 4 |
| `run-log-errores` — los errores también quedan en el log | 5 |
| `run-log-codigo` — el log cierra con el código real | 4 |
| `run-mismo-codigo` — `bk-run` sale con el código del comando | 5 |
| `run-aviso-stderr` — aviso de fallo por stderr | 3 |
| `run-acumula` — cada ejecución se añade sin borrar | 4 |
| `run-bk-log` — `BK_LOG` cambia el log | 3 |
| `kit-estricto` — modo estricto en todo el kit, sin TODOs, shellcheck limpio | 4 |
| `inventario-al-dia` — `docs/inventario.txt` incluye `./bin/bk-run` | 3 |
| `readme-completo` — README sin TODOs, con `bk-run` y la bitácora de la semana 03 | 4 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **Mensajes a stderr** | Uso y avisos por stderr; stdout solo con la salida del comando | Algún mensaje por stdout | 10 |
| **Códigos de salida** | `2` para el mal uso y el del comando en todo lo demás, también con `127` | Algún caso sale con `0` o con un código fijo | 10 |
| **Comentarios del porqué** | Explican `"$@"` frente a `$*`, el `2>&1` y el `\|\| status=$?`; no repiten el código | Comentarios que repiten el código | 10 |
| **README del kit** | Explica qué hace `bk-run`, dónde deja el log, cómo cambiarlo y qué código devuelve; la bitácora dice qué te costó | Solo el nombre del comando | 10 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| `bk-run.log` u otros logs de prueba dentro de `starter/` en la entrega | −5 pts |
| Un script del kit sin `set -euo pipefail` | −5 pts |

---

## 📋 Checklist de entrega

- [ ] Los 7 labs con sus criterios de éxito comprobados
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/` sin ningún `TODO`
- [ ] `./scripts/verificar-semana.sh 03` con las 16 comprobaciones en verde

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Proyecto — bk-run: ejecutar y dejar constancia](3-proyecto/README.md) | [Recursos — ebooks](4-recursos/ebooks-free/README.md) → |

[↑ Semana 03](README.md)
