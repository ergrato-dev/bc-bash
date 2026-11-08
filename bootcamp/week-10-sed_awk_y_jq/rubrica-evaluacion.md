# Rúbrica de Evaluación — Semana 10

> sed, awk y jq. Se evalúan tres evidencias por separado y hace falta **70% en cada una**. Que el CSV salga bien con tu log de prueba no basta: tiene que aguantar una ruta con comas, una línea que no es una petición y un mensaje con comillas, y tienes que poder explicar por qué.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 7 labs, con sus criterios de éxito comprobados en el laboratorio |
| 📦 Producto | 30% | `bin/bk-logs` (`bashkit logs`): 60 pts de autograding + 40 pts de calidad |

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
| 1 | `sed 's/uno/1/' archivo` deja `uno` en algunas líneas. ¿Por qué? ¿Y por qué `archivo` sigue igual después? |
| 2 | `sed -nE 's/^([^ ]+) .*/\1/p'` saca la IP de cada línea de un access log, pero también saca `nginx:` de un aviso. ¿Qué hacen `-n` y `/p`, y qué le falta a la regex? |
| 3 | `sed -i "s/^port=.*/port=9090/" app.conf` cambia el puerto del servidor y también el de la base de datos. ¿Por qué? ¿Cómo lo limitas a una sección, y qué te protege si te equivocas? |
| 4 | Un script hace `sed -i "s/X/$valor/" archivo` y falla cuando `valor` es `/srv/data`. ¿Por qué? ¿Y por qué `sed` sale con `0` cuando la regex no encuentra nada? |
| 5 | `awk '{ print $1 }' /etc/passwd` escribe la línea entera. ¿Por qué? ¿Qué son `NF` y `$NF`? |
| 6 | `awk '{ c[$9]++ } END { for (k in c) print k, c[k] }'` cuenta bien sin crear antes el array. ¿Por qué? ¿Por qué la cabecera escrita en `BEGIN` acaba al final si pasas la salida por `sort`? |
| 7 | `awk -v limit=500 '$5 > limit'` saca `95ms` como lenta y deja fuera `1240ms`. ¿Por qué? ¿Cómo lo arreglas? |
| 8 | ¿Por qué `awk "\$1 > $limit"` es peligroso aunque funcione, y qué escribes en su lugar? |
| 9 | Un script escribe JSON con `printf '{"mensaje":"%s"}' "$msg"`. ¿Qué pasa con `msg='dijo "listo"'`? ¿Qué cambia `jq -n --arg`, y cuándo hace falta `--argjson`? |
| 10 | En `bk-logs`, ¿por qué `fields` separa los campos con tabuladores y no con comas, y por qué los bytes `-` se cambian por `0` en `normalize` y no en `to_json`? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** Sin `g`, `s` cambia solo la primera vez que encuentra la regex en cada línea: las demás se quedan. Y `sed` nunca cambia el archivo que lee: escribe una copia en stdout. Para cambiarlo hace falta `-i`.

**2.** `-n` hace que `sed` no escriba nada por su cuenta, y `/p`, que escriba la línea si la sustitución encajó: salen solo las líneas que tienen el formato. Pero `^([^ ]+) .*` encaja con cualquier línea que tenga un espacio. La regex tiene que describir la línea entera (la IP, los dos `-`, la fecha entre corchetes, la petición entre comillas...), y entonces un aviso no encaja y no sale.

**3.** `s/^port=.*/.../` se aplica a cada línea que empiece por `port=`, y hay dos. Con un rango delante, solo a las líneas de la sección: `/^\[server\]/,/^\[/ s/.../.../`. Con `-i.bak`, el archivo de antes queda en `app.conf.bak` para volver atrás.

**4.** Con comillas dobles, bash pone el valor antes de que `sed` lea el programa: `s/X//srv/data/` tiene demasiadas `/`. Lo que entra en el programa hay que validarlo (solo dígitos, solo letras) o usar otro separador que el valor no pueda llevar. `sed` sale con `0` porque para él no encontrar nada no es un error; si importa, se comprueba antes con `grep -q`.

**5.** Por defecto `awk` separa por espacios, y una línea de `/etc/passwd` no tiene ninguno (o tiene alguno dentro del nombre completo): `$1` es todo o casi todo. Hace falta `-F:`. `NF` es cuántos campos tiene la línea, y `$NF`, el último.

**6.** En awk, una casilla o variable que no existe vale vacío, y en una cuenta, `0`: `c[$9]++` funciona desde la primera línea, sin `declare` y sin que `set -e` pare nada. `sort` ordena todas las líneas que le llegan, y la cabecera es una más: sin números, `sort -rn` la deja al final. La cabecera se escribe fuera del pipe, desde bash.

**7.** `95ms` no parece un número, así que awk compara como texto, letra a letra: `9` va después de `5`, y `1240ms` va antes porque empieza por `1`. `$5 + 0` lo convierte en número (awk toma las cifras del principio): `ms = $5 + 0` y comparar `ms > limit`.

**8.** Con comillas dobles, el valor de `limit` pasa a ser parte del programa de awk: si viene de un usuario o de un archivo, puede ser código (`system("...")` ejecuta un comando). `awk -v limit="$limit" '$1 > limit'` lo pasa como un dato.

**9.** Las comillas de `msg` cierran el texto de JSON antes de tiempo: sale `{"mensaje":"dijo "listo""}`, que no es JSON. `jq -n --arg msg "$msg" '{mensaje: $msg}'` escapa lo que haga falta (`\"`). `--arg` siempre da un texto; para un número o un array, que ya son JSON, `--argjson`: si no, `"42"` no se puede sumar.

**10.** Una ruta puede llevar comas (`/buscar?q=sed,awk`) y nunca un tabulador: con comas, `split` partiría la ruta en dos. Los datos se arreglan en un solo sitio, el que comparten los dos formatos: así el CSV también da `0` y no un `-`, y `tonumber` de jq no falla.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 70, llevada a porcentaje. Cada criterio de éxito se comprueba ejecutando el comando en el laboratorio.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — sed: sustituir](2-practicas/lab-01-sed-sustituir/README.md) | `g`, `\1` y `&` explicados; `mask-ips.sh` deja las IP en `.0` y los tokens en `XXX` | 10 |
| [02 — sed: rangos, borrar e in-place](2-practicas/lab-02-sed-rangos-e-in-place/README.md) | El rango y el `0` de `sed` explicados; `set-port.sh` cambia solo su sección, deja `.bak` y avisa | 10 |
| [03 — awk: campos y patrones](2-practicas/lab-03-awk-campos/README.md) | Campos, `NF` y números frente a textos explicados; `list-users.sh` con la tabla de personas | 10 |
| [04 — awk: BEGIN, END y arrays](2-practicas/lab-04-awk-begin-end-y-arrays/README.md) | `BEGIN`, `END` y la cabecera ordenada explicados; `bytes-by-path.sh` ordenado por bytes | 10 |
| [05 — awk y las variables de bash](2-practicas/lab-05-awk-y-variables-de-bash/README.md) | `-v`, `OFS` y `+ 0` explicados; `slow-requests.sh` con las tres lentas y código `1` | 10 |
| [06 — jq: leer JSON](2-practicas/lab-06-jq-leer-json/README.md) | `-r`, `.[]`, `select` y `-e` explicados; `down-services.sh` avisa y sale con `1` | 10 |
| [07 — JSON roto](2-practicas/lab-07-json-roto/README.md) | Los cuatro fallos explicados; `deploy-event.sh` escribe JSON válido con comillas en el mensaje | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con tus palabras por qué funciona; 8 si se cumplen todos; 7 si falla uno; menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 10`. Es binario: pasa o no pasa. 4 puntos por comprobación.

| Comprobación | Puntos |
|---|:--:|
| `logs-ejecutable` — bin/bk-logs existe, tiene permiso de ejecución y empieza por el shebang del kit | 4 |
| `logs-usa-core` — bk-logs carga lib/core.sh, comprueba sus herramientas con require, avisa con die y usa sed, awk y jq | 4 |
| `logs-uso` — sin argumentos o con un formato que no es csv ni json, escribe el uso en stderr y sale con código 2 | 4 |
| `logs-sin-log` — con un log que no se puede leer, avisa en stderr con su nombre y sale con código 1 | 4 |
| `csv-filas` — el CSV empieza por la cabecera y tiene una fila por petición: 7 con el log de prueba, sin el aviso de nginx ni la petición vacía | 4 |
| `csv-fecha` — la fecha sale en ISO 8601 (2026-10-31T23:59:58+00:00) y los campos separados por comas | 4 |
| `csv-bytes` — una respuesta sin cuerpo (bytes "-" en el log) sale con 0 bytes | 4 |
| `csv-comillas` — una ruta con comas va entre comillas, como pide el formato CSV | 4 |
| `json-array` — el JSON es un array de 7 objetos, con el código y los bytes como números | 4 |
| `json-objeto` — cada objeto tiene ip, fecha, metodo, ruta, codigo y bytes, con los mismos valores que el CSV | 4 |
| `logs-vacio` — con un log vacío, el CSV es solo la cabecera y el JSON un array vacío | 4 |
| `logs-con-bashkit` — bashkit help ofrece logs, y bashkit logs json da el mismo array que bk-logs | 4 |
| `kit-limpio` — el kit sin TODOs y limpio para shellcheck -x | 4 |
| `inventario-al-dia` — docs/inventario.txt incluye ./bin/bk-logs | 4 |
| `readme-completo` — README.md sin TODOs, documenta bk-logs y tiene la bitácora de la semana 10 | 4 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **Una herramienta para cada cosa** | `sed` saca los campos, `awk` los transforma y escribe el CSV, `jq` construye el JSON | Funciona, pero con JSON escrito a mano o un `while read` donde iba awk | 10 |
| **Regex y formatos** | La regex describe la línea entera; el CSV cumple las comillas; los números van como números en el JSON | Funciona con el log de prueba, pero una línea rara se cuela a medias | 10 |
| **Datos fuera del código** | Programas de awk y jq entre comillas simples; nada de bash pegado dentro | Alguna variable de bash dentro de un programa, aunque hoy no rompa | 10 |
| **Comentarios del porqué** | Explican los tabuladores, `-n` con `/p`, el `BEGIN` de los meses y `tonumber`; no repiten el código | Comentarios que repiten el código | 10 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| Una variable de bash pegada dentro de un programa de `sed`, `awk` o `jq` | −10 pts |
| JSON construido con `echo` o `printf` | −10 pts |

---

## 📋 Checklist de entrega

- [ ] Los 7 labs con sus criterios de éxito comprobados
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/` sin ningún `TODO`
- [ ] `./scripts/verificar-semana.sh 10` con las 15 comprobaciones en verde

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Proyecto — bashkit logs: el access log en CSV y JSON](3-proyecto/README.md) | [Recursos — ebooks](4-recursos/ebooks-free/README.md) → |

[↑ Semana 10](README.md)
