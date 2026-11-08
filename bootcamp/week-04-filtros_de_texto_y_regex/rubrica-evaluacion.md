# Rúbrica de Evaluación — Semana 04

> Filtros de texto y regex. Se evalúan tres evidencias por separado y hace falta **70% en cada una**. Que un pipe "dé un número" no basta: tiene que contar lo que dice que cuenta, y tienes que poder explicar por qué cada pieza está ahí.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 7 labs, con sus criterios de éxito comprobados en el laboratorio |
| 📦 Producto | 30% | `bin/bk-top-ips`: 60 pts de autograding + 40 pts de calidad |

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
| 1 | `wc -l archivo` imprime `25 archivo` y `wc -l < archivo` imprime `25`. ¿Por qué cambia, y cuál usarías dentro de `$( )` en un script? |
| 2 | Un script con `set -euo pipefail` hace `n=$(grep -c FATAL app.log)` y se para sin mensaje cuando el log no tiene ningún `FATAL`. ¿Por qué, si `grep -c` sí imprime `0`? |
| 3 | `grep '10.0.0.1' hosts.txt` encuentra también `10.0.0.12` y `10a0b0c1`. Explica por qué y escribe un patrón que solo encuentre esa IP como palabra entera. |
| 4 | ¿Qué diferencia hay entre `[0-9]*` y `[0-9]+`? ¿Por qué `grep '[0-9]*' archivo` imprime todas las líneas, también las que no tienen ningún dígito? |
| 5 | Un CSV exportado desde Windows hace que `grep -c '00$'` sobre su última columna dé 0 aunque haya importes como `189.00`. ¿Qué pasa y cómo lo compruebas? |
| 6 | `ls -l \| cut -d' ' -f5` deja huecos en blanco en algunas líneas. ¿Por qué, y qué pieza añadirías antes del `cut`? |
| 7 | `uniq -c visitas.txt` da muchas líneas con `1` aunque haya ciudades repetidas. ¿Por qué, y qué cambia un `sort` delante? |
| 8 | ¿Por qué `sort` sin `-n` pone `1020` antes que `12`, y cuándo da igual usar `-n` o no? |
| 9 | `find . -name *.log` funciona en una carpeta y en otra da `paths must precede expression`. Explica qué hace bash antes de ejecutar `find` en cada caso. |
| 10 | `bk-top-ips` usa `grep -oE '^([0-9]{1,3}\.){3}[0-9]{1,3}'`. ¿Qué problema concreto del access log resuelve el `^`, y cuál resolvería un `cut -d' ' -f1` sin regex y cuál no? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** Con el nombre como argumento, `wc` sabe de qué archivo habla y lo repite en su salida. Con `<`, el archivo llega por stdin y `wc` no conoce el nombre: imprime solo el número. En `$( )` interesa solo el número, así que se usa `wc -l < archivo`.

**2.** `grep` sale con `1` cuando no encuentra nada, también con `-c`, aunque imprima `0`. En una asignación `n=$(...)`, el código de la sustitución es el de la línea, y `set -e` para el script con ese `1`. Si "ninguno" es una respuesta válida, se escribe `n=$(grep -c FATAL app.log || true)`.

**3.** En una regex, `.` encaja con cualquier carácter, también con `a` o con otro dígito; y sin anclas, el patrón puede ser parte de un texto más largo, como `10.0.0.12`. Solución: `grep -w '10\.0\.0\.1'`: `\.` es un punto de verdad y `-w` exige que no haya letras, dígitos ni `_` pegados delante ni detrás.

**4.** `*` es "cero o más veces" y `+`, "una o más" (con `-E`). `[0-9]*` encaja con cero dígitos, es decir, con el texto vacío, y eso está en cualquier línea. Por eso, para "un número", se escribe `[0-9]+` o `[0-9][0-9]*`.

**5.** Windows termina las líneas con `\r\n`. El `\r` se queda pegado al último campo: el importe es `189.00\r`, que no termina en `00`. `cat -A` lo enseña como `^M` antes del `$` del final de línea. Se arregla con `tr -d '\r'`.

**6.** `ls -l` alinea las columnas con varios espacios, y `cut` cuenta cada espacio como un separador: entre dos espacios seguidos hay un campo vacío, y el campo 5 ya no es el tamaño en esas líneas. `tr -s ' '` junta los espacios repetidos en uno antes del `cut`.

**7.** `uniq` solo compara cada línea con la anterior: junta repetidas seguidas. Si la misma ciudad aparece salteada, cada aparición es un grupo distinto con `1`. `sort` pone juntas todas las iguales, y entonces `uniq -c` cuenta cada ciudad una sola vez.

**8.** Sin `-n`, `sort` compara carácter a carácter, como un diccionario: el segundo carácter de `1020` (`0`) va antes que el de `12` (`2`). Da igual cuando todos los números tienen el mismo ancho, como las horas `08`–`11` o la salida de `uniq -c`, que alinea los números con espacios delante.

**9.** Sin comillas, bash sustituye `*.log` por los nombres de la carpeta actual que encajan, antes de ejecutar `find`. Si no hay ninguno, `*.log` llega tal cual y funciona. Con uno, `find` recibe `-name nota.log` y busca otro nombre. Con dos, recibe `-name nota.log otra.log`, y `otra.log` no es una condición válida: el error. Con `'*.log'`, el patrón llega siempre a `find`.

**10.** El `^` hace que solo cuente la IP del principio de la línea, la del cliente: deja fuera las IP que aparecen más adelante, como la del referer. `cut -d' ' -f1` también se quedaría solo con el primer campo, pero no filtraría las líneas que empiezan por `::1` o `-`: las contaría como si fueran IP. La regex resuelve los dos.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 70, llevada a porcentaje. Cada criterio de éxito se comprueba ejecutando el comando en el laboratorio.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — Ver y contar líneas](2-practicas/lab-01-ver-y-contar-lineas/README.md) | `tail -n +N` y `wc -l <` explicados; `log-summary.sh` imprime el resumen y guarda las 5 últimas | 10 |
| [02 — grep](2-practicas/lab-02-grep/README.md) | Opciones y códigos de `grep` explicados; `errors-report.sh` arreglado sale con 0 | 10 |
| [03 — Expresiones regulares](2-practicas/lab-03-expresiones-regulares/README.md) | Fallo del `.` explicado; `extract-contacts.sh` cuenta 4 y deja 5 correos y 6 teléfonos | 10 |
| [04 — cut y tr](2-practicas/lab-04-cut-y-tr/README.md) | Trampa del `\r` y de los espacios explicadas; `sales-report.sh` imprime `ventas: 8` sin errores | 10 |
| [05 — sort y uniq](2-practicas/lab-05-sort-y-uniq/README.md) | Orden de texto y `uniq` sin `sort` explicados; `top-cities.sh` da 11, 8 y 5 | 10 |
| [06 — Buscar con find](2-practicas/lab-06-buscar-con-find/README.md) | Patrón sin comillas explicado; `old-logs.sh` funciona con `.log` en la carpeta | 10 |
| [07 — Analizar un access log](2-practicas/lab-07-analizar-un-access-log/README.md) | Campos y patrón del 404 explicados; `status-report.sh` imprime las cuatro secciones | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con tus palabras por qué funciona; 8 si se cumplen todos; 7 si falla uno; menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 04`. Es binario: pasa o no pasa.

| Comprobación | Puntos |
|---|:--:|
| `top-ejecutable` — `bin/bk-top-ips` con permisos `755` y shebang | 3 |
| `top-uso` — sin argumentos, uso por stderr y código `2` | 4 |
| `top-no-legible` — log que no existe: mensaje con su nombre y código `1` | 4 |
| `top-primero` — la primera línea es `9 203.0.113.7` | 5 |
| `top-solo-inicio` — solo cuenta la IP del principio de la línea | 5 |
| `top-total` — los recuentos suman 41 | 4 |
| `top-orden` — de más a menos, como número | 4 |
| `top-diez` — sin N, 10 líneas | 3 |
| `top-n` — con N=3, la tercera es `5 192.0.2.15` | 4 |
| `top-n-lineas` — con N=3, exactamente 3 líneas | 3 |
| `top-sin-ips` — un log sin IP sale con `0` y sin salida | 5 |
| `top-con-bk-run` — `bk-run` registra el resultado de `bk-top-ips` | 4 |
| `kit-limpio` — scripts del kit sin TODOs y con shellcheck limpio | 5 |
| `inventario-al-dia` — `docs/inventario.txt` incluye `./bin/bk-top-ips` | 3 |
| `readme-completo` — README sin TODOs, con `bk-top-ips` y la bitácora de la semana 04 | 4 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **La regex** | Entre comillas simples; puedes explicar el `^`, los `\.` y el `{1,3}` | Funciona, pero no sabes decir qué hace cada pieza | 10 |
| **Mensajes y códigos** | Uso y errores por stderr con `2` y `1`; un log sin IP sale con `0` | Algún mensaje por stdout o un código fijo | 10 |
| **Comentarios del porqué** | Explican el `^`, el `sort` antes del `uniq -c` y el `\|\| true`; no repiten el código | Comentarios que repiten el código | 10 |
| **README del kit** | Explica qué hace `bk-top-ips`, sus dos argumentos y qué líneas ignora; la bitácora dice qué te costó | Solo el nombre del comando | 10 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| `bk-run.log` u otros logs de prueba dentro de `starter/` en la entrega | −5 pts |
| Cambios en `3-proyecto/tests/access.log` | −10 pts |

---

## 📋 Checklist de entrega

- [ ] Los 7 labs con sus criterios de éxito comprobados
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/` sin ningún `TODO`
- [ ] `./scripts/verificar-semana.sh 04` con las 15 comprobaciones en verde

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Proyecto — bk-top-ips: quién carga el servidor](3-proyecto/README.md) | [Recursos — ebooks](4-recursos/ebooks-free/README.md) → |

[↑ Semana 04](README.md)
