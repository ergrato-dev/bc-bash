# Proyecto Semana 14 — `bashkit backup`: copias de PostgreSQL en Docker

⏱ Duración estimada: ~3 h 30 min

## Contexto

Última semana: `bashkit` hace lo que hace una herramienta de operaciones de verdad, copiar una base de datos cada noche y devolverla cuando hace falta, con lo que viste en los labs:

- **PostgreSQL en Docker** con un healthcheck, y las variables `PG*` (lab 01);
- **esperar a que responda** con `pg_isready` y un límite de tiempo (lab 02);
- **`pg_dump -Fc` y `pg_restore`**, y `pg_restore -l` para saber si un archivo es una copia (lab 03);
- **una copia que no miente**: un `.partial`, `mv` y `trap` (lab 04);
- **rotación** por la fecha del nombre (lab 05);
- **restaurar** con `--clean` y `--single-transaction`, preguntando antes (lab 06);
- **CI con GitHub Actions** y un PostgreSQL de usar y tirar (lab 07).

## Estructura del proyecto

`starter/` es el `bashkit` con el que terminaste la semana 13, con TODOs en siete archivos:

```text
3-proyecto/
├── starter/                      ← aquí trabajas
│   ├── README.md                 ← 4 TODOs: bk-backup, bk-restore, la línea de cron y la bitácora
│   ├── compose.yaml              ← nuevo: el PostgreSQL del kit; TODO 8
│   ├── .github/workflows/ci.yml  ← nuevo: la CI del kit; TODO 9
│   ├── bin/
│   │   ├── bk-backup             ← nuevo, sin bit de ejecución: TODOs 1 a 5
│   │   ├── bk-restore            ← nuevo, sin bit de ejecución: TODOs 6 y 7
│   │   └── bashkit, bk-check, bk-clean, bk-healthcheck, bk-info, bk-lint, bk-logs, ...
│   ├── lib/core.sh
│   ├── tests/
│   │   ├── fakes/                ← nuevo: pg_dump, pg_isready y pg_restore de mentira (ya hechos)
│   │   ├── bk-backup.bats        ← TODO 10
│   │   ├── bk-restore.bats       ← TODO 11
│   │   └── test_helper.bash, bashkit.bats, bk-check.bats, bk-healthcheck.bats, ...
│   └── docs/
│       └── inventario.txt        ← hay que regenerarlo
├── tests/dobles/                 ← los dobles que usa el autograding
└── solucion/
```

## Lo que debes construir

1. `bk-backup [-d carpeta] [-k copias] [-w segundos]` copia con `pg_dump -Fc` la base de `PGDATABASE` en `<carpeta>/<base>-AAAAMMDD-HHMMSS.dump` (sin `-d`, en `backups/` del kit) y escribe la ruta en stdout. Antes espera hasta `-w` segundos (30) a que PostgreSQL responda.
2. Si algo falla, no deja ni copia a medias ni `.partial`, y sale con 1. Después de una copia buena, deja solo las `-k` más nuevas (7) de esa base. Si otra copia está en marcha en la misma carpeta, sale con 3.
3. `bk-restore [-y] archivo` comprueba que el archivo es una copia de `pg_dump -Fc`, pregunta (salvo con `-y`; sin terminal y sin `-y` sale con 2) y restaura todo o nada.
4. `compose.yaml` con `postgres:16`, healthcheck, el puerto solo en `127.0.0.1` y la contraseña de `.env`; `.github/workflows/ci.yml` con lint, tests y una copia y restauración de verdad.
5. Tres tests o más de `bk-backup` y dos de `bk-restore`, con los dobles de `tests/fakes/`; el kit pasa `bk-lint` y `bats tests`; sin TODOs; el `README.md` completo.

## Paso a paso

### Paso 0 — PostgreSQL y el laboratorio

**En tu equipo**, desde la raíz del repositorio, arranca PostgreSQL (lab 01) y entra al laboratorio:

```bash
docker compose --profile db up -d --wait db
docker compose run --rm lab
```

**En el laboratorio**, recarga la tienda y ve al kit:

```bash
psql -v ON_ERROR_STOP=1 -q -f bootcamp/week-14-proyecto_integrador/2-practicas/lab-01-postgresql-en-docker/datos/tienda.sql
cd bootcamp/week-14-proyecto_integrador/3-proyecto/starter
```

(sin salida).

### Paso 1 — Lo que ya hay

Los tests de la semana 13 pasan (`bk-backup.bats` y `bk-restore.bats` todavía no tienen ninguno). `bin/bk-backup` y `bin/bk-restore` son nuevos y no tienen el bit de ejecución, así que `bashkit` no los conoce:

```bash
bats tests > /dev/null && echo "tests: $(bats -c tests)"
ls -l bin/bk-backup bin/bk-restore | cut -c1-10
bin/bashkit backup -h; echo $?
```

```text
tests: 24
-rw-r--r--
-rw-r--r--
bashkit: subcomando desconocido: 'backup' (mira bashkit help)
2
```

Dales el bit de ejecución. El dispatcher los descubre solo (semana 08) y el uso y las opciones ya están hechos:

```bash
chmod +x bin/bk-backup bin/bk-restore
bin/bashkit help | grep -E 'backup|restore'
bin/bashkit backup -h; echo $?
bin/bashkit restore -h; echo $?
```

```text
  backup
  restore
uso: bk-backup [-d carpeta] [-k copias] [-w segundos]
0
uso: bk-restore [-y] archivo
0
```

`tests/fakes/` tiene un `pg_dump`, un `pg_isready` y un `pg_restore` de mentira: hacen como que hablan con PostgreSQL sin necesitarlo. `tests/test_helper.bash` los pone delante en el `PATH` de los tests (míralo), así que los tests de los pasos 10 y 11 corren sin base de datos y sin tocar la tuya. Lee los comentarios de cada uno: dicen qué variables los hacen fallar.

### Paso 2 — TODO 1: validar las opciones

Abre `bin/bk-backup` en tu editor. Debajo del TODO 1, para con código 2 si `-k` no es un número mayor que 0, si `-w` no es un número o si falta `PGDATABASE`:

```bash
[[ $keep =~ ^[1-9][0-9]*$ ]] || die "-k necesita un número mayor que 0, no '$keep'" 2
[[ $wait_limit =~ ^[0-9]+$ ]] || die "-w necesita un número de segundos, no '$wait_limit'" 2
[[ -n ${PGDATABASE:-} ]] || die "falta PGDATABASE: el nombre de la base que quieres copiar" 2
```

`-w 0` vale: no esperar. `pg_dump` sabría qué base copiar sin `PGDATABASE` (la de tu usuario), pero el nombre de la copia y la rotación dependen de ella: mejor pararse que copiar la equivocada.

```bash
bin/bk-backup -k 0; echo $?
bin/bk-backup -w pronto; echo $?
PGDATABASE= bin/bk-backup; echo $?
```

```text
bk-backup: -k necesita un número mayor que 0, no '0'
2
bk-backup: -w necesita un número de segundos, no 'pronto'
2
bk-backup: falta PGDATABASE: el nombre de la base que quieres copiar
2
```

### Paso 3 — TODO 2: la copia, sin dejar nada a medias

Debajo del TODO 2 (deja los dos comentarios de encima sobre el nombre y `printf`):

```bash
name="$PGDATABASE-$(printf '%(%Y%m%d-%H%M%S)T' -1).dump"
partial="$dir/.$name.partial"
trap 'rm -f "$partial"' EXIT
pg_dump -Fc -f "$partial" || die "pg_dump falló: no hay copia nueva"
mv "$partial" "$dir/$name"
echo "$dir/$name"
```

Es el arreglo del lab 04 con `pg_dump -f`: crea el archivo antes de conectar, y si falla lo deja vacío o cortado. Pruébalo con el PostgreSQL de verdad, en una carpeta `backups` (git la ignora):

```bash
bin/bk-backup -d backups; echo $?
ls -la backups
pg_restore -l backups/bashkit-*.dump | grep -c 'TABLE DATA'
```

```text
backups/bashkit-20261110-211039.dump
0
total 12
drwxr-xr-x 2 alumno alumno 4096 Nov 10 21:10 .
drwxr-xr-x 8 alumno alumno 4096 Nov 10 21:10 ..
-rw-r--r-- 1 alumno alumno 3114 Nov 10 21:10 bashkit-20261110-211039.dump
2
```

(tu fecha y tu hora). La ruta va a stdout: así otro script la guarda con `file="$(bk-backup)"`. Ahora con la base caída:

```bash
PGHOST=no-existe bin/bk-backup -d backups; echo $?
ls -A backups
```

```text
pg_dump: error: could not translate host name "no-existe" to address: Temporary failure in name resolution
bk-backup: pg_dump falló: no hay copia nueva
1
bashkit-20261110-211039.dump
```

Ni copia vacía ni `.partial`: el `trap` lo borró.

### Paso 4 — TODO 3: esperar a PostgreSQL

Debajo del TODO 3, la espera del lab 02 con `die`:

```bash
until pg_isready -q; do
  ((SECONDS < wait_limit)) || die "PostgreSQL no responde después de $wait_limit s: no hay copia nueva"
  sleep 1
done
```

```bash
time (PGHOST=no-existe bin/bk-backup -d backups -w 3; echo $?)
PGHOST=no-existe bin/bk-backup -d backups -w 0; echo $?
bin/bk-backup -d backups; echo $?
```

```text
bk-backup: PostgreSQL no responde después de 3 s: no hay copia nueva
1

real	0m3.287s
user	0m0.067s
sys	0m0.050s
bk-backup: PostgreSQL no responde después de 0 s: no hay copia nueva
1
backups/bashkit-20261110-211043.dump
0
```

Ahora el error es el del kit, que dice qué pasa, y no el de `pg_dump`. Con la base en marcha, `pg_isready` dice que sí a la primera y la copia sale como antes.

### Paso 5 — TODO 4: rotación

Debajo del TODO 4. El glob con `?` es el del lab 05; aquí se borran las primeras del array hasta que quedan `keep`:

```bash
copies=("$dir/$PGDATABASE"-????????-??????.dump)
deleted=0
while ((${#copies[@]} - deleted > keep)); do
  rm -f -- "${copies[deleted]}"
  deleted=$((deleted + 1))
done
log "copia de '$PGDATABASE' guardada; quedan $((${#copies[@]} - deleted)), borradas $deleted"
```

No hace falta `nullglob`: justo antes se ha guardado una copia, así que el glob encaja al menos con ella. Crea copias viejas de prueba y una de otra base con un nombre parecido:

```bash
touch backups/bashkit-2026110{1..5}-030000.dump backups/bashkit-viejo-20200101-000000.dump
ls backups | wc -l
bin/bk-backup -d backups -k 3; echo $?
ls backups
```

```text
8
backups/bashkit-20261110-211055.dump
bk-backup: copia de 'bashkit' guardada; quedan 3, borradas 5
0
bashkit-20261110-211039.dump
bashkit-20261110-211043.dump
bashkit-20261110-211055.dump
bashkit-viejo-20200101-000000.dump
```

Quedan las 3 más nuevas de `bashkit` y la de `bashkit-viejo` intacta.

### Paso 6 — TODO 5: una copia a la vez

Debajo del TODO 5 (va **antes** de la espera y de la copia). `exec {lock_fd}>` abre el archivo y guarda el número del descriptor en `lock_fd` (semana 11):

```bash
exec {lock_fd}> "$dir/.lock"
flock -n "$lock_fd" || die "ya hay otra copia en marcha en '$dir'" 3
```

`-n`: si otro lo tiene, no espera. Una copia que llega tarde se salta, y la de la noche siguiente la cubre. Simula otra copia en marcha: `flock` sin `-n` bloquea el archivo mientras dura su comando (`sleep 3`), en segundo plano:

```bash
flock backups/.lock sleep 3 & sleep 0.5
bin/bk-backup -d backups; echo $?
wait
```

```text
bk-backup: ya hay otra copia en marcha en 'backups'
3
```

### Paso 7 — TODO 6: antes de restaurar

Abre `bin/bk-restore` en tu editor. Debajo del TODO 6, la comprobación y la pregunta del lab 06, con `die`:

```bash
pg_restore -l "$file" > /dev/null 2>&1 || die "'$file' no es una copia de pg_dump -Fc"

if [[ -z $yes ]]; then
  [[ -t 0 ]] || die "sin terminal no puedo preguntar: usa -y para confirmar" 2
  read -r -p "Esto reemplaza lo que hay en '$PGDATABASE' por '$file'. ¿Seguir? [s/N] " answer || answer=""
  [[ $answer == [sS] ]] || die "cancelado: no he tocado la base"
fi
```

`copies[-1]` es el último elemento de un array: la copia más nueva.

```bash
echo hola > notas.txt
bin/bashkit restore -y notas.txt; echo $?
rm notas.txt
copies=(backups/bashkit-????????-??????.dump)
bin/bashkit restore "${copies[-1]}" < /dev/null; echo $?
bin/bashkit restore "${copies[-1]}"; echo $?
```

Contesta pulsando solo Enter:

```text
bk-restore: 'notas.txt' no es una copia de pg_dump -Fc
1
bk-restore: sin terminal no puedo preguntar: usa -y para confirmar
2
Esto reemplaza lo que hay en 'bashkit' por 'backups/bashkit-20261110-211055.dump'. ¿Seguir? [s/N]
bk-restore: cancelado: no he tocado la base
1
```

### Paso 8 — TODO 7: restaurar

Debajo del TODO 7:

```bash
pg_restore --clean --if-exists --no-owner --single-transaction -d "$PGDATABASE" "$file" ||
  die "pg_restore falló: la base '$PGDATABASE' se queda como estaba"
log "base '$PGDATABASE' restaurada desde '$file'"
```

El accidente y la vuelta atrás:

```bash
psql -c 'delete from pedidos where cliente_id = 1'
bin/bashkit restore -y "${copies[-1]}"; echo $?
psql -Atc 'select count(*) from pedidos'
```

```text
DELETE 4
bk-restore: base 'bashkit' restaurada desde 'backups/bashkit-20261110-211055.dump'
0
12
```

### Paso 9 — TODO 8: el `compose.yaml` del kit

`compose.yaml` es el PostgreSQL del kit para cuando lo uses fuera del bootcamp, en tu máquina o en un servidor. Ábrelo en tu editor. Debajo del primer TODO 8, dentro de `environment`, con 6 espacios:

```yaml
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:?pon POSTGRES_PASSWORD en el archivo .env}
```

`${VAR:?mensaje}` es la expansión de bash de la semana 05, y compose la entiende igual: si falta la variable, para con el mensaje en lugar de arrancar sin contraseña. Compose la lee del archivo `.env` junto a `compose.yaml`, que git ignora. Cambia el segundo TODO 8 (las dos líneas de comentario) por, con 4 espacios:

```yaml
    ports:
      - "127.0.0.1:5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD", "pg_isready", "-U", "bashkit"]
      interval: 2s
      retries: 15
```

`127.0.0.1:` delante del puerto: solo se llega desde la propia máquina; sin eso, el puerto queda abierto a toda la red. El laboratorio no tiene `docker`, así que compruébalo **en tu equipo**, desde la raíz del repositorio. `config --quiet` lee el archivo y solo habla si hay un error:

```bash
docker compose -f bootcamp/week-14-proyecto_integrador/3-proyecto/starter/compose.yaml config --quiet; echo "código: $?"
POSTGRES_PASSWORD=prueba docker compose -f bootcamp/week-14-proyecto_integrador/3-proyecto/starter/compose.yaml config --quiet; echo "código: $?"
```

```text
error while interpolating services.db.environment.POSTGRES_PASSWORD: required variable POSTGRES_PASSWORD is missing a value: pon POSTGRES_PASSWORD en el archivo .env
código: 1
código: 0
```

No lo arranques aquí: el puerto 5432 y el nombre del volumen podrían chocar con el `db` del bootcamp.

### Paso 10 — TODO 9: la CI del kit

Abre `.github/workflows/ci.yml` en tu editor. Ya tiene el servicio, las variables y los pasos de lint y tests (compáralo con el del lab 07). Cambia el TODO 9 por el simulacro de restauración, con la sangría de los otros pasos:

```yaml
      # Una copia que nunca has restaurado no sabes si sirve: aquí se restaura de verdad.
      - name: Copia y restauración contra PostgreSQL
        run: |
          set -euo pipefail
          psql -c 'create table t (n int); insert into t values (1), (2), (3)'
          file="$(bin/bk-backup -d "$RUNNER_TEMP/backups")"
          psql -c 'drop table t'
          bin/bk-restore -y "$file"
          test "$(psql -Atc 'select count(*) from t')" = 3
```

`test A = B` sale con 1 si no son iguales: si la tabla no vuelve con sus 3 filas, el paso sale en rojo. **En el laboratorio**, ejecuta el bloque tal cual. `sed -n '/run: |/,$p'` saca desde `run: |` hasta el final, y `tail -n +2` quita esa primera línea; `RUNNER_TEMP` es la carpeta temporal que GitHub da a cada trabajo, y aquí la hace `mktemp -d`:

```bash
sed -n '/run: |/,$p' .github/workflows/ci.yml | tail -n +2 | sed 's/^ *//'
RUNNER_TEMP="$(mktemp -d)" bash -c "$(sed -n '/run: |/,$p' .github/workflows/ci.yml | tail -n +2)"; echo $?
psql -qc 'drop table t'
```

```text
set -euo pipefail
psql -c 'create table t (n int); insert into t values (1), (2), (3)'
file="$(bin/bk-backup -d "$RUNNER_TEMP/backups")"
psql -c 'drop table t'
bin/bk-restore -y "$file"
test "$(psql -Atc 'select count(*) from t')" = 3
CREATE TABLE
INSERT 0 3
bk-backup: copia de 'bashkit' guardada; quedan 1, borradas 0
DROP TABLE
bk-restore: base 'bashkit' restaurada desde '/tmp/tmp.bP0ch6LaNr/backups/bashkit-20261110-211114.dump'
0
```

La última línea borra la tabla `t` de prueba de tu base. En GitHub, la base del servicio se tira al acabar.

### Paso 11 — TODOs 10 y 11: los tests

Los dobles de `tests/fakes/` responden a variables: `FAKE_PG_DUMP_FAIL=1` hace fallar a `pg_dump`, `FAKE_PG_READY_AFTER=N` hace que `pg_isready` diga que no a las N primeras preguntas y `FAKE_PG_RESTORE_FAIL=1` hace fallar a `pg_restore`; y el `pg_restore` de mentira apunta en `pg_restore.args` cómo lo llamaron. Abre `tests/bk-backup.bats` en tu editor y cambia el TODO 10 por tres tests o más. Por ejemplo, el nombre de la copia y que un fallo no deje nada:

```bash
@test "deja una copia con la fecha en el nombre, escribe su ruta y sale con 0" {
  PGDATABASE=tienda run --separate-stderr bk-backup -d copias
  [[ $status -eq 0 ]]
  [[ $output == copias/tienda-????????-??????.dump ]]
  [[ $(head -c 5 "$output") == PGDMP ]]
}

@test "si pg_dump falla, sale con 1 y no deja ni copia ni .partial" {
  FAKE_PG_DUMP_FAIL=1 PGDATABASE=tienda run -1 bk-backup -d copias
  [[ $output == *"pg_dump falló"* ]]
  [[ -z $(ls -A copias | grep -v '^\.lock$') ]]
}
```

Dentro de `[[ ]]`, el lado derecho de `==` es un patrón: `????????` encaja con 8 caracteres cualesquiera. Escribe tú el de la rotación: crea con `touch` cuatro copias viejas de `tienda` y una de `tienda-viejo`, ejecuta `bk-backup -d copias -k 3` y comprueba con `[[ -e ... ]]` y `[[ ! -e ... ]]` cuáles quedan. En `tests/bk-restore.bats`, cambia el TODO 11 por dos tests o más: uno que compruebe las opciones (`[[ $(< pg_restore.args) == "pg_restore --clean ..." ]]`) y uno con un archivo que no es una copia. Una copia de mentira es cualquier archivo que empieza por `PGDMP`: `echo "PGDMP copia" > copia.dump`.

```bash
bats tests/bk-backup.bats tests/bk-restore.bats; echo $?
```

```text
bk-backup.bats
 ✓ deja una copia con la fecha en el nombre, escribe su ruta y sale con 0
 ✓ si pg_dump falla, sale con 1 y no deja ni copia ni .partial
 ✓ con -k 3 deja las 3 copias más nuevas de la base y no toca las de otra
 ✓ espera a que PostgreSQL responda, y se rinde con 1 si no responde a tiempo
bk-restore.bats
 ✓ con -y restaura con --clean y --single-transaction en la base de PGDATABASE
 ✓ sin -y y sin terminal no pregunta ni restaura: sale con 2
 ✓ un archivo que no es una copia de pg_dump para con 1 antes de tocar la base

7 tests, 0 failures

0
```

(tus nombres y tu número de tests pueden ser otros). Comprueba que el test de la rotación sirve: rompe la rotación a propósito cambiando `> keep)); do` por `> 999)); do` en `bin/bk-backup`, ejecuta `bats tests/bk-backup.bats` (tiene que salir algún `✗`) y deja la línea como estaba.

### Paso 12 — Limpieza, lint e inventario

```bash
rm -r backups
bats tests > /dev/null && echo "tests: $(bats -c tests)"
bin/bk-lint; echo "código: $?"
grep -rn TODO bin lib tests scaffold.sh healthcheck.conf compose.yaml .github; echo "código: $?"
find . -type f > docs/inventario.txt
grep -E 'backup|restore|compose|github|fakes' docs/inventario.txt
```

```text
tests: 31
bk-lint: archivos revisados: 15, sin avisos
código: 0
código: 1
./.github/workflows/ci.yml
./compose.yaml
./tests/bk-restore.bats
./tests/bk-backup.bats
./tests/fakes/pg_restore
./tests/fakes/pg_isready
./tests/fakes/pg_dump
./bin/bk-restore
./bin/bk-backup
```

`grep` sale con `1`: no queda ningún TODO en el código. (El orden de `find` y tu número de tests pueden cambiar.)

### Paso 13 — README del kit

Abre `README.md` (el de `starter/`) en tu editor y cambia los cuatro TODOs:

- la fila de `bin/bk-backup`: qué copia, dónde la deja, cuántas guarda y qué cambian `-d`, `-k` y `-w`;
- la fila de `bin/bk-restore`: qué hace, qué comprueba antes y para qué sirve `-y`;
- la frase de cron: la línea de `crontab -e` en un bloque de código, con las variables de PostgreSQL delante porque cron no lee tu `.bashrc` (por ejemplo `0 3 * * * PGHOST=localhost PGUSER=bashkit PGDATABASE=bashkit $HOME/bashkit/bin/bk-backup >> $HOME/bashkit/backup.log 2>&1`). La contraseña no va en la línea: el README ya explica `~/.pgpass` justo debajo;
- `- Semana 14: TODO`: qué aprendiste y qué te costó.

```bash
grep -n TODO README.md; echo "código: $?"
```

```text
código: 1
```

### Paso 14 — Autograding

El autograding no usa tu PostgreSQL: pone delante sus propios dobles (`3-proyecto/tests/dobles/`), así que da lo mismo si `db` está en marcha.

```bash
cd "$(git rev-parse --show-toplevel)" && ./scripts/verificar-semana.sh 14
```

```text
Semana 14 — Proyecto integrador: backups de PostgreSQL en Docker

  ✅ bashkit backup -h y bashkit restore -h enseñan el uso con código 0; -k 0 avisa y sale con código 2
  ✅ deja una copia que empieza por PGDMP con la fecha en el nombre, escribe su ruta en stdout y el resumen en stderr
  ✅ si pg_dump falla, sale con 1 y no deja ni la copia vacía ni el .partial
  ✅ espera a que PostgreSQL responda, y si no responde en -w segundos se rinde con 1 sin dejar copia
  ✅ con -k 3 deja las 3 copias más nuevas de la base y no toca las de otra base que empieza igual
  ✅ si otra copia tiene bloqueada la carpeta, no espera: avisa y sale con código 3
  ✅ bk-restore sin -y y sin terminal no restaura (código 2); un archivo que no existe, tampoco
  ✅ un archivo que no es una copia de pg_dump -Fc para con 1 antes de tocar la base
  ✅ con -y llama a pg_restore con --clean y --single-transaction sobre PGDATABASE; si falla, sale con 1
  ✅ compose.yaml: postgres:16 con healthcheck de pg_isready, el puerto solo en 127.0.0.1 y la contraseña de .env
  ✅ la CI pasa bk-lint y bats tests, y restaura una copia contra un postgres:16 de usar y tirar
  ✅ bats tests pasa entero, con 3 tests o más de bk-backup y 2 o más de bk-restore
  ✅ los tests de bk-backup fallan si la rotación no borra ninguna copia
  ✅ el kit pasa bk-lint (shellcheck y shfmt) y no le quedan TODOs
  ✅ README.md sin TODOs, documenta bk-backup con -k, la línea de cron de la copia y la bitácora de la semana 14

15/15 comprobaciones superadas.
```

Cada ❌ trae una pista con el paso donde se arregla. Para salir del laboratorio: `exit`. Para parar PostgreSQL, en tu equipo: `docker compose stop db`.

### Y después del bootcamp

El kit ya es una herramienta: llévatelo a su propio repositorio (en tu equipo, copia `starter/` a una carpeta fuera del bootcamp, `git init`, y súbelo a GitHub como en el reto del lab 07) y la CI pasará el lint, los tests y el simulacro en cada push.

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 14` desde la raíz del repositorio (60 de los 100 puntos del Producto, 4 por comprobación). Los otros 40 son de calidad: ver la [rúbrica](../rubrica-evaluacion.md#-producto-30).

- [ ] bashkit backup -h y bashkit restore -h enseñan el uso con código 0; -k 0 avisa y sale con código 2
- [ ] deja una copia que empieza por PGDMP con la fecha en el nombre, escribe su ruta en stdout y el resumen en stderr
- [ ] si pg_dump falla, sale con 1 y no deja ni la copia vacía ni el .partial
- [ ] espera a que PostgreSQL responda, y si no responde en -w segundos se rinde con 1 sin dejar copia
- [ ] con -k 3 deja las 3 copias más nuevas de la base y no toca las de otra base que empieza igual
- [ ] si otra copia tiene bloqueada la carpeta, no espera: avisa y sale con código 3
- [ ] bk-restore sin -y y sin terminal no restaura (código 2); un archivo que no existe, tampoco
- [ ] un archivo que no es una copia de pg_dump -Fc para con 1 antes de tocar la base
- [ ] con -y llama a pg_restore con --clean y --single-transaction sobre PGDATABASE; si falla, sale con 1
- [ ] compose.yaml: postgres:16 con healthcheck de pg_isready, el puerto solo en 127.0.0.1 y la contraseña de .env
- [ ] la CI pasa bk-lint y bats tests, y restaura una copia contra un postgres:16 de usar y tirar
- [ ] bats tests pasa entero, con 3 tests o más de bk-backup y 2 o más de bk-restore
- [ ] los tests de bk-backup fallan si la rotación no borra ninguna copia
- [ ] el kit pasa bk-lint (shellcheck y shfmt) y no le quedan TODOs
- [ ] README.md sin TODOs, documenta bk-backup con -k, la línea de cron de la copia y la bitácora de la semana 14

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 07 — CI con GitHub Actions](../2-practicas/lab-07-ci-con-github-actions/README.md) | [Rúbrica de evaluación](../rubrica-evaluacion.md) → |

[↑ Semana 14](../README.md)
