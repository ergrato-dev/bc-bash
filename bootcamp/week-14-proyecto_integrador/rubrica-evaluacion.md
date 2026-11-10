# Rúbrica de Evaluación — Semana 14

> Proyecto integrador. Se evalúan tres evidencias por separado y hace falta **70% en cada una**. Que la copia se haga no basta: tiene que estar entera o no existir, tiene que poder restaurarse sin dejar la base a medias, ningún fallo puede salir con 0, y tienes que poder explicar por qué.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 7 labs, con sus criterios de éxito comprobados en el laboratorio |
| 📦 Producto | 30% | `bashkit backup` y `restore`: 60 pts de autograding + 40 pts de calidad |

**Bandas:** Sobresaliente 90–100 · Notable 80–89 · Aprobado 70–79 · No aprobado < 70 en cualquiera de las tres.

---

## 🧠 Conocimiento (30%)

Diez preguntas, 3 puntos cada una. No se pide recordar sintaxis: se pide explicar por qué.

| # | Pregunta |
|:--:|---|
| 1 | `docker compose ps` dice que el contenedor de PostgreSQL está `Up`, y aun así un `psql` lanzado justo después falla. ¿Por qué? ¿Qué mira el healthcheck, y qué espera `docker compose up --wait`? |
| 2 | Dentro del laboratorio, `PGHOST` vale `db`; en la CI de GitHub, `localhost`. ¿Por qué cada uno? ¿Qué leen `psql`, `pg_dump` y `pg_restore` de las variables `PG*`? |
| 3 | `psql -f datos.sql` sale con 0 aunque una orden del archivo falle. ¿Por qué es peligroso en un script con `set -e`, y qué cambia `-v ON_ERROR_STOP=1`? |
| 4 | El servicio `db` usa `image: postgres:16` y no `postgres:latest` ni `postgres:17`. ¿Qué error da `pg_dump` 16 contra un servidor 17, y por qué fijar la versión mayor evita que las copias dejen de funcionar un día sin que toques nada? |
| 5 | `pg_dump \| gzip > copia.sql.gz` con la base caída dice "copia hecha", sale con 0 y deja 20 bytes. Explica los tres fallos (el código del pipe, el `>` y el archivo que queda) y cómo los arreglan `pipefail`, el `.partial` con `mv` y el `trap`. |
| 6 | ¿Por qué `mv` de un `.partial` al nombre final es atómico, y por qué deja de serlo si el `.partial` está en `/tmp` y la copia en otro disco? |
| 7 | La rotación elige las copias más viejas por la fecha del **nombre** y no por la de modificación (`ls -t`, `find -mtime`). ¿Por qué? ¿Para qué sirven los `?` de `tienda-????????-??????.dump` en lugar de `tienda-*.dump`? |
| 8 | Sobre una base con las tablas, `pg_restore -d bashkit copia.dump` sale con 1 y no recupera nada. ¿Por qué? ¿Qué hacen `--clean --if-exists`, y qué pasó en el lab 06 sin `--single-transaction` cuando una vista impedía borrar `pedidos`? |
| 9 | `bk-restore` sin `-y` pregunta, pero desde cron o desde un pipe sale con 2 en lugar de restaurar. ¿Qué comprueba `[[ -t 0 ]]`, y por qué parar es mejor que suponer un sí? ¿Qué comprueba `pg_restore -l` antes de tocar la base? |
| 10 | En la CI, cada `run` termina con un código. ¿Qué pasa con un 1, y por qué un script que falla y sale con 0 es peor en la CI que fuera de ella? ¿Qué añade el último paso del workflow de `bashkit` que los tests con dobles no comprueban? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** `Up` dice que el **contenedor** corre, no que PostgreSQL acepte conexiones: tarda unos segundos en arrancar. El healthcheck ejecuta `pg_isready -U bashkit` cada 2 s y marca el contenedor `healthy` cuando sale con 0; `up --wait` no vuelve hasta ese `healthy`. Un script que va detrás necesita su propia espera, porque la base puede reiniciarse después.

**2.** En el laboratorio, `lab` y `db` están en la misma red de compose y cada servicio se llama por su nombre: PostgreSQL está en la máquina `db`. En GitHub, los pasos corren en la propia máquina y el servicio publica su puerto en ella (`5432:5432`): está en `localhost`. Los clientes leen de `PGHOST`, `PGPORT`, `PGUSER`, `PGPASSWORD` y `PGDATABASE` a qué conectarse, así que los comandos no cambian entre los dos sitios.

**3.** Porque `psql` sigue con la orden siguiente después de un error y al final sale con 0: `set -e` no ve ningún fallo y el script sigue como si los datos estuvieran bien cargados, con la mitad. Con `ON_ERROR_STOP=1`, `psql` para en el primer error y sale con 3.

**4.** `pg_dump: error: aborting because of server version mismatch`: un `pg_dump` no copia un servidor de una versión mayor más nueva que la suya. El laboratorio y la máquina de GitHub traen el cliente 16; con `latest`, el día que la imagen pase a 18 el servidor sería más nuevo que el cliente y la copia de esa noche fallaría sin que nadie hubiera cambiado nada.

**5.** El código de un pipe es el de su último comando: `gzip` comprime una entrada vacía sin problema y sale con 0, así que `set -e` no ve el fallo de `pg_dump` y el script dice "copia hecha". El `>` vacía el archivo antes de que `pg_dump` empiece: la copia buena de ayer desaparece aunque todo falle. Y quedan 20 bytes: un gzip de nada. `pipefail` hace que el pipe falle si falla cualquiera de sus comandos; escribir en un `.partial` y hacer `mv` solo si todo salió bien deja intacta la copia de ayer; y `trap 'rm -f "$partial"' EXIT` borra el temporal pase lo que pase.

**6.** Dentro de un mismo sistema de archivos, `mv` no copia datos: solo cambia el nombre en el directorio, de una vez. Nadie ve nunca el nombre bueno con media copia. Entre dos sistemas de archivos, `mv` tiene que copiar el archivo entero y después borrar el original, y mientras copia el nombre final ya existe a medias. Por eso el `.partial` va en la misma carpeta que las copias.

**7.** La fecha de modificación la cambia cualquier cosa que toque el archivo: un `touch`, un `cp` sin `-p`, llevar las copias a otro disco. Una copia vieja tocada parecería la más nueva y la rotación borraría las buenas. El nombre no cambia, y con la fecha de año a segundo ordenarlo como texto es ordenarlo por tiempo. `*` encaja con cualquier cosa: `tienda-*.dump` incluye las copias de una base llamada `tienda-viejo`, que además saldrían las últimas. `????????-??????` solo encaja con la forma exacta de la fecha.

**8.** Las tablas ya existen: cada `CREATE TABLE` falla, y el `COPY` de los datos choca con las filas que quedan por la clave primaria y falla entero. `--clean` borra cada objeto antes de crearlo, y `--if-exists` evita el error si alguno no existe. En el lab 06, la vista impidió borrar `pedidos`; sin `--single-transaction`, `pg_restore` siguió después del error, copió los datos encima de los que había y dejó 20 pedidos repetidos y sin clave primaria. Con `--single-transaction`, paró en el primer error y PostgreSQL deshizo todo: la base quedó como estaba.

**9.** `[[ -t 0 ]]` es verdad si la entrada estándar es una terminal: hay alguien que puede contestar. Desde cron o un pipe nadie contesta, y restaurar sin confirmación borra la base actual: si el script supusiera un sí, una línea de cron mal puesta restauraría cada noche la copia vieja encima de los datos nuevos. `pg_restore -l` lee el índice de la copia sin tocar ninguna base: si falla, el archivo no es una copia `-Fc` o está cortado, y el script para antes de borrar nada.

**10.** Con un código distinto de 0, el trabajo se para y el commit sale en rojo: es la señal de que algo se rompió. Un script que falla y sale con 0 deja la CI en verde: todos creen que el cambio está bien y el fallo llega a producción. El último paso restaura de verdad contra un PostgreSQL: los tests con dobles comprueban la lógica del script, pero solo una restauración real demuestra que la copia sirve.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 70, llevada a porcentaje. Cada criterio de éxito se comprueba ejecutando el comando en el laboratorio.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — PostgreSQL en Docker](2-practicas/lab-01-postgresql-en-docker/README.md) | Las variables `PG*`, `-At` y el `0` de `psql -f` sin `ON_ERROR_STOP` explicados; `orders-by-client.sh` imprime los 5 clientes y con `PGHOST=no-existe` avisa y sale con `1`; tras `docker compose restart db` siguen los 12 pedidos | 10 |
| [02 — Esperar a que responda](2-practicas/lab-02-esperar-a-que-responda/README.md) | Los códigos 0, 2 y 3 de `pg_isready` y `starting` frente a `healthy` explicados; `wait-for-db.sh 3` con la base parada sale con `1` y `wait-for-db.sh 60` espera mientras arranca y sale con `0` | 10 |
| [03 — pg_dump y pg_restore](2-practicas/lab-03-pg-dump-y-pg-restore/README.md) | Texto frente a custom, `pg_restore -l` y el `-d` que falta explicados; la base `prueba` tiene 12 pedidos y `compare-dbs.sh` dice `iguales` o enseña la diferencia y sale con `1` | 10 |
| [04 — Un backup que miente](2-practicas/lab-04-un-backup-que-miente/README.md) | Los tres fallos del script roto explicados; con la base caída, `backup.sh` sale con `1`, la copia buena sigue entera y no queda ningún `.partial` | 10 |
| [05 — Rotación de copias](2-practicas/lab-05-rotacion-de-copias/README.md) | El glob con `?`, `nullglob` y por qué no `ls -t` explicados; `rotate.sh -n` lista 7 sin borrar, sin `-n` quedan los días 8, 9 y 10, y repetirlo no borra nada | 10 |
| [06 — Restaurar sin miedo](2-practicas/lab-06-restaurar-sin-miedo/README.md) | `--clean`, los 20 pedidos sin `--single-transaction` y los 8 con ella explicados; `restore.sh` para con `1` ante un archivo que no es copia, con `2` sin terminal, y con `-y` deja 12 pedidos | 10 |
| [07 — CI con GitHub Actions](2-practicas/lab-07-ci-con-github-actions/README.md) | `on`, `runs-on`, `services` y `localhost` frente a `db` explicados; el `ci.yml` sin TODOs ni tabuladores y sus `run` ejecutados en orden sin ningún `✗ rojo` | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con tus palabras por qué funciona; 8 si se cumplen todos; 7 si falla uno; menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 14`. Es binario: pasa o no pasa. 4 puntos por comprobación.

| Comprobación | Puntos |
|---|:--:|
| `bk-ayuda` — bashkit backup -h y bashkit restore -h enseñan el uso con código 0; -k 0 avisa y sale con código 2 | 4 |
| `bk-copia` — deja una copia que empieza por PGDMP con la fecha en el nombre, escribe su ruta en stdout y el resumen en stderr | 4 |
| `bk-fallo` — si pg_dump falla, sale con 1 y no deja ni la copia vacía ni el .partial | 4 |
| `bk-espera` — espera a que PostgreSQL responda, y si no responde en -w segundos se rinde con 1 sin dejar copia | 4 |
| `bk-rotacion` — con -k 3 deja las 3 copias más nuevas de la base y no toca las de otra base que empieza igual | 4 |
| `bk-bloqueo` — si otra copia tiene bloqueada la carpeta, no espera: avisa y sale con código 3 | 4 |
| `rs-confirmar` — bk-restore sin -y y sin terminal no restaura (código 2); un archivo que no existe, tampoco | 4 |
| `rs-no-copia` — un archivo que no es una copia de pg_dump -Fc para con 1 antes de tocar la base | 4 |
| `rs-restaura` — con -y llama a pg_restore con --clean y --single-transaction sobre PGDATABASE; si falla, sale con 1 | 4 |
| `compose` — compose.yaml: postgres:16 con healthcheck de pg_isready, el puerto solo en 127.0.0.1 y la contraseña de .env | 4 |
| `ci` — la CI pasa bk-lint y bats tests, y restaura una copia contra un postgres:16 de usar y tirar | 4 |
| `tests-pasan` — bats tests pasa entero, con 3 tests o más de bk-backup y 2 o más de bk-restore | 4 |
| `mut-rotacion` — los tests de bk-backup fallan si la rotación no borra ninguna copia | 4 |
| `kit-limpio` — el kit pasa bk-lint (shellcheck y shfmt) y no le quedan TODOs | 4 |
| `readme-completo` — README.md sin TODOs, documenta bk-backup con -k, la línea de cron de la copia y la bitácora de la semana 14 | 4 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **Una copia entera o ninguna** | `.partial` en la misma carpeta, `mv` solo tras un `pg_dump` que salió con 0, `trap` que borra el temporal, rotación solo después de una copia buena y bajo `flock` | Copia atómica, pero la rotación corre aunque la copia falle o sin bloqueo | 10 |
| **Restaurar sin sustos** | `pg_restore -l` antes de tocar nada; pregunta con terminal, para sin ella; `--clean --if-exists --single-transaction` | Restaura bien, pero sin comprobar la copia o sin `--single-transaction` | 10 |
| **Listo para producción** | Versión mayor fija y la misma en `compose.yaml`, CI y cliente; contraseña fuera del repositorio (`.env`, `.pgpass`); puerto en `127.0.0.1`; la línea de cron con las variables y su log | Funciona, pero con la contraseña escrita en un archivo del repositorio o el puerto abierto | 10 |
| **Comentarios del porqué** | Explican por qué el `.partial`, por qué `-n` en `flock`, por qué el glob con `?`, por qué `--single-transaction` y por qué no suponer un sí; no repiten el código | Comentarios que repiten el código | 10 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| Una copia que falla sale con 0 o deja un archivo con el nombre de una copia buena | −10 pts |
| `bk-restore` restaura sin `-y` cuando no hay terminal | −10 pts |
| Una contraseña de una base de verdad escrita en un archivo del kit | −5 pts |

---

## 📋 Checklist de entrega

- [ ] Los 7 labs con sus criterios de éxito comprobados
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/` sin ningún `TODO`
- [ ] `./scripts/verificar-semana.sh 14` con las 15 comprobaciones en verde

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Proyecto — `bashkit backup`: copias de PostgreSQL en Docker](3-proyecto/README.md) | [Recursos — ebooks](4-recursos/ebooks-free/README.md) → |

[↑ Semana 14](README.md)
