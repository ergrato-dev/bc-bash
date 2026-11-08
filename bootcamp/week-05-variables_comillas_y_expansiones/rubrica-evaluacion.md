# Rúbrica de Evaluación — Semana 05

> Variables, comillas y expansiones. Se evalúan tres evidencias por separado y hace falta **70% en cada una**. Que un script funcione con `informe.txt` no basta: tiene que funcionar con `informe final.txt`, y tienes que poder explicar qué hace bash con cada comilla.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 7 labs, con sus criterios de éxito comprobados en el laboratorio |
| 📦 Producto | 30% | `bin/bk-rename`: 60 pts de autograding + 40 pts de calidad |

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
| 1 | `nombre = Ana` da `nombre: command not found`. ¿Qué entiende bash en esa línea, y qué entiende en `saludo=Hola Ana`? |
| 2 | Un script hace `echo "log: $app_$entorno.log"` con `app=tienda` y `entorno=prod`. ¿Qué imprime sin `set -u`, qué pasa con `set -u`, y cómo se arregla? |
| 3 | ¿Por qué `echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc` lleva comillas simples por fuera? ¿Qué quedaría en el archivo con dobles? |
| 4 | Con `f="viejo *.log"` en una carpeta con `a.log` y `b.log`, ¿qué argumentos recibe `rm $f`, y cuáles `rm "$f"`? Nombra los dos pasos de bash que los cambian. |
| 5 | `rm *.tmp` falla con `invalid option` en una carpeta que tiene un archivo llamado `-f.tmp`. ¿Por qué, y qué dos formas hay de evitarlo? |
| 6 | ¿Qué diferencia hay entre `${PORT:-5432}` y `${PORT:=5432}`? ¿Y entre `${PORT:-5432}` y `${PORT-5432}` cuando `PORT=""`? |
| 7 | En un script de configuración, ¿cuándo usarías `${DB_USER:?mensaje}` en lugar de `${DB_USER:-postgres}`? |
| 8 | Con `ruta=/var/log/app.tar.gz`, explica por qué `${ruta%.*}` y `${ruta%%.*}` dan resultados distintos, y escribe la expansión que da `app.tar.gz`. |
| 9 | Un script con `set -e` hace `n=0` y luego `((n++))`, y se para sin mensaje. ¿Por qué? ¿Y por qué `$(( usado / total * 100 ))` da `0` con `usado=4300` y `total=5000`? |
| 10 | `lista=$(ls)` guarda tres nombres. ¿Por qué `echo $lista` los imprime en una línea y `echo "$lista"` en tres? ¿Qué pasó con el salto de línea que `ls` escribe al final? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** Con espacios, `nombre = Ana` son tres palabras: el comando `nombre` con los argumentos `=` y `Ana`, y ese comando no existe. Una asignación es una sola palabra sin espacios alrededor del `=`. `saludo=Hola Ana` es una asignación seguida de un comando: "ejecuta `Ana` con la variable `saludo=Hola` solo para él". `saludo` no queda definida en la shell.

**2.** bash lee el nombre de variable más largo posible: `$app_` es la variable `app_`, que no existe. Sin `set -u` vale vacío e imprime `log: prod.log`; con `set -u`, el script para con `app_: unbound variable`. Se arregla marcando dónde acaba el nombre: `${app}_$entorno.log`.

**3.** Entre simples, `$HOME` y `$PATH` llegan sin sustituir al archivo, y se calculan cada vez que se abre una shell, con los valores de ese momento. Con dobles, se sustituirían al ejecutar el `echo`: el archivo guardaría el `PATH` de hoy, fijo, y cualquier cambio posterior al `PATH` se perdería al cargarlo.

**4.** `rm $f` recibe `viejo`, `a.log` y `b.log`: bash sustituye `$f`, la parte por el espacio (*word splitting*) en `viejo` y `*.log`, y expande el glob `*.log` (*globbing*). Borraría dos archivos que nadie nombró. `rm "$f"` recibe un solo argumento, `viejo *.log`: entre comillas dobles no hay ni partición ni glob.

**5.** bash expande `*.tmp` antes de ejecutar `rm`, y la lista ordenada empieza por `-f.tmp`. `rm` lo lee como opciones (`-f`, `-.`...) y el `.` no es una opción válida. Se evita con `--`, que marca el final de las opciones (`rm -- *.tmp`), o haciendo que el glob empiece por `./` (`rm ./*.tmp`), que da `./-f.tmp`.

**6.** Las dos valen `5432` si `PORT` no existe o está vacía, pero `:=` además guarda `5432` en `PORT`; `:-` no la toca. Con `PORT=""`, `${PORT:-5432}` vale `5432` (los dos puntos tratan "vacía" como "sin valor") y `${PORT-5432}` vale vacío (sin los dos puntos solo cuenta si existe, y existe).

**7.** Cuando no hay un valor por defecto razonable y seguir con uno inventado sería peor que parar: conectar con un usuario equivocado puede dar un error confuso más adelante o, peor, actuar sobre la base de otro. `:?` para el script al principio con un mensaje que dice exactamente qué falta.

**8.** `%` quita del final lo más corto que encaje con `.*`, que es `.gz`: queda `/var/log/app.tar`. `%%` quita lo más largo, desde el primer punto: `.tar.gz`, y queda `/var/log/app`. Para el nombre, `${ruta##*/}` quita desde el principio lo más largo que encaje con `*/`, hasta la última barra: `app.tar.gz`.

**9.** `n++` suma uno pero el valor de la expresión es el de antes, `0`, y `(( 0 ))` sale con `1`, "falso". Con `set -e`, ese `1` para el script. Se escribe `n=$(( n + 1 ))`. En la división, bash solo trabaja con enteros: `4300 / 5000` es `0`, y `0 * 100` sigue siendo `0`. Multiplicando antes (`usado * 100 / total`) da `86`.

**10.** Sin comillas, el resultado de `$lista` pasa por el word splitting, que también parte por saltos de línea: `echo` recibe tres argumentos y los une con espacios. Con comillas, recibe un argumento con los saltos dentro. El salto de línea del final lo quitó `$( )`, que siempre quita todos los del final de la salida.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 70, llevada a porcentaje. Cada criterio de éxito se comprueba ejecutando el comando en el laboratorio.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — Variables](2-practicas/lab-01-variables/README.md) | Asignaciones rotas, llaves y `export` explicados; `deploy-vars.sh` sale con `0` | 10 |
| [02 — Comillas](2-practicas/lab-02-comillas/README.md) | Simples, dobles y quitar comillas explicados; `zona/bashrc` se carga sin errores | 10 |
| [03 — Word splitting y globbing](2-practicas/lab-03-word-splitting-y-globbing/README.md) | El `mv` y el `rm` explicados; `archive-report.sh` archiva solo el informe | 10 |
| [04 — Valores por defecto](2-practicas/lab-04-valores-por-defecto/README.md) | `:-`, `-` y `:?` explicados; `connect-db.sh` arma las cuatro URL | 10 |
| [05 — Recortar y sustituir](2-practicas/lab-05-recortar-y-sustituir/README.md) | `#`/`##` y `:-2` explicados; `path-parts.sh` separa la ruta | 10 |
| [06 — Aritmética](2-practicas/lab-06-aritmetica/README.md) | División entera, `((n++))` y octal explicados; `disk-alert.sh` sin errores | 10 |
| [07 — Sustitución de comandos](2-practicas/lab-07-sustitucion-de-comandos/README.md) | Saltos de línea, stderr y comillas de `$( )` explicados; `make-snapshot.sh` completo | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con tus palabras por qué funciona; 8 si se cumplen todos; 7 si falla uno; menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 05`. Es binario: pasa o no pasa.

| Comprobación | Puntos |
|---|:--:|
| `rename-ejecutable` — `bin/bk-rename` con permisos `755` y shebang | 3 |
| `rename-uso` — sin argumentos, uso por stderr y código `2` | 4 |
| `rename-no-existe` — archivo que no existe: mensaje con su nombre y código `1` | 4 |
| `rename-mueve` — `Mi Foto (1).JPG` pasa a `mi-foto-1.jpg` | 5 |
| `rename-salida` — imprime `origen -> destino` | 4 |
| `rename-dry-run` — con `--dry-run` enseña el cambio y no renombra | 5 |
| `rename-tildes` — `Canción del Verano.MP3` pasa a `cancion-del-verano.mp3` | 4 |
| `rename-simbolos` — `¡Oferta, Ya!.txt` pasa a `oferta-ya.txt` | 4 |
| `rename-carpeta` — solo cambia el nombre, no la carpeta | 3 |
| `rename-sin-cambios` — un nombre que ya está bien: `sin cambios` y código `0` | 3 |
| `rename-no-pisa` — no pisa un destino que ya existe | 5 |
| `rename-con-find` — `find -exec` renombra todos los archivos de prueba | 4 |
| `kit-limpio` — scripts del kit sin TODOs y con shellcheck limpio | 5 |
| `inventario-al-dia` — `docs/inventario.txt` incluye `./bin/bk-rename` | 3 |
| `readme-completo` — README sin TODOs, con `bk-rename` y la bitácora de la semana 05 | 4 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **Comillas** | Toda expansión entre comillas dobles, también las que hoy no lo necesitan; `--` delante de los nombres en `mv` | Funciona, pero alguna expansión sin comillas que shellcheck no ve | 10 |
| **Expansiones** | Nombre, carpeta y limpieza con `##`, `%`, `,,` y `//`; puedes explicar cada patrón | Funciona, pero con `basename`, `sed` o `tr` donde bastaba una expansión | 10 |
| **Comentarios del porqué** | Explican por qué solo el nombre, por qué las tildes antes del filtro y por qué no pisar; no repiten el código | Comentarios que repiten el código | 10 |
| **README del kit** | Explica qué hace `bk-rename`, qué hace `--dry-run` y qué no toca; la bitácora dice qué te costó | Solo el nombre del comando | 10 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| Archivos de prueba renombrados dentro de `3-proyecto/tests/fixtures/` (se trabaja sobre la copia de `zona/`) | −10 pts |
| `bk-rename` usa `mv` sin comprobar antes si el destino existe | −5 pts |

---

## 📋 Checklist de entrega

- [ ] Los 7 labs con sus criterios de éxito comprobados
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/` sin ningún `TODO`
- [ ] `./scripts/verificar-semana.sh 05` con las 15 comprobaciones en verde

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Proyecto — bk-rename: nombres de archivo sin sorpresas](3-proyecto/README.md) | [Recursos — ebooks](4-recursos/ebooks-free/README.md) → |

[↑ Semana 05](README.md)
