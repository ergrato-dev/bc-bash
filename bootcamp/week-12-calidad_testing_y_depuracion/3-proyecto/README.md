# Proyecto Semana 12 — Tests, lint y depuración de bashkit

⏱ Duración estimada: ~3 h 30 min

## Contexto

`bashkit` ya tiene diez comandos. Cada vez que cambias uno, ¿cómo sabes que los otros nueve siguen funcionando? Hasta ahora, probándolos a mano. Esta semana el kit aprende a comprobarse solo, con lo que viste en los labs:

- **una traza con `set -x`, `PS4` y `BASH_XTRACEFD`** (lab 05): `BK_TRACE=traza.txt bashkit report` escribe en un archivo cada línea que ejecuta, con su archivo y su número de línea;
- **un fallo escondido en `bk-report`**, que encuentras con esa traza y fijas con un **test de regresión** (lab 06);
- **tests con bats** (labs 03 y 04) para `bk-check`, `bk-run` y `bk-report`, cada uno en su carpeta temporal;
- **`bin/bk-lint`**, que revisa el kit entero con **shellcheck** y **shfmt** (labs 01 y 02).

Esta copia del kit trae dos problemas puestos a propósito para que los encuentres: `bk-report` cuenta mal y `bk-top-ips` tiene una variable sin comillas. Además, dos archivos del kit no siguen el formato de shfmt: eso no es a propósito, y lo descubre `bk-lint`.

## Estructura del proyecto

`starter/` es el `bashkit` con el que terminaste la semana 11, con TODOs en cinco archivos:

```text
3-proyecto/
├── starter/                    ← aquí trabajas
│   ├── README.md               ← 3 TODOs: bk-lint, los tests y la bitácora
│   ├── bin/
│   │   ├── bk-lint             ← nuevo, sin bit de ejecución: TODOs 5 a 7
│   │   ├── bk-report           ← cuenta mal (paso 3)
│   │   └── bashkit, bk-check, bk-clean, bk-info, bk-logs, bk-rename, bk-run, bk-top-ips
│   ├── lib/core.sh             ← TODO 1
│   ├── tests/
│   │   ├── test_helper.bash    ← lo que comparten los tests (ya hecho)
│   │   ├── bashkit.bats        ← 4 tests del dispatcher (ya hechos): el modelo
│   │   ├── bk-report.bats      ← TODO 2
│   │   ├── bk-check.bats       ← TODO 3
│   │   └── bk-run.bats         ← TODO 4
│   └── docs/
│       └── inventario.txt      ← hay que regenerarlo
├── tests/
│   └── bk-run.log              ← un log de bk-run con 4 bloques: códigos 0, 2, 127 y 130
└── solucion/
```

## Lo que debes construir

1. En `lib/core.sh`: con `BK_TRACE=<archivo>`, cada comando del kit escribe su traza (`set -x`) en ese archivo, con `+ archivo:línea: ` delante de cada línea (`PS4`) y sin mezclarla con stderr (`BASH_XTRACEFD`).
2. `bk-report` cuenta los bloques con códigos de más de un dígito (127, 130), y un test de regresión lo comprueba.
3. Tests con bats: 3 o más de `bk-check` y de `bk-run`, 2 o más de `bk-report`, 14 o más en total. Ninguno deja archivos fuera de su carpeta temporal, y fallan si el comando que prueban se rompe.
4. `bk-lint [-w] [archivo...]`: shellcheck y shfmt sobre los archivos que le das o, sin argumentos, sobre todo el kit. Resume en stderr con `archivos revisados: N, sin avisos` (código `0`) o `... con avisos de shellcheck y shfmt` (código `1`). `-w` arregla el formato. Un archivo que no existe o una opción desconocida: código `2`.
5. El kit entero pasa `bk-lint` y `bats tests`; sin TODOs; `docs/inventario.txt` regenerado y `README.md` sin TODOs.

## Paso a paso

El paso 2 deja `bk-run.log` y `traza.txt` dentro de `starter/`: el paso 6 borra el log y el 9, la traza.

### Paso 0 — Entrar al laboratorio

Desde la raíz del repositorio, en tu equipo:

```bash
docker compose run --rm lab
cd bootcamp/week-12-calidad_testing_y_depuracion/3-proyecto/starter
```

(sin salida).

### Paso 1 — Los tests que ya hay

`bats` ejecuta los archivos `.bats` que le das, o todos los de una carpeta. Abre `tests/bashkit.bats` y `tests/test_helper.bash` en tu editor: cada `@test "nombre" { ... }` es un test, y pasa si ninguna línea falla.

```bash
bats tests
```

```text
bashkit.bats
 ✓ bashkit help enseña el uso y los subcomandos, con código 0
 ✓ bashkit sin subcomando sale con código 2
 ✓ bashkit con un subcomando que no existe avisa y sale con código 2
 ✓ bashkit pasa los argumentos y el código de salida del subcomando

4 tests, 0 failures
```

`bk-report.bats`, `bk-check.bats` y `bk-run.bats` no tienen ningún `@test` todavía: no cuentan. Fíjate en tres piezas del modelo, que vas a usar en todos tus tests:

- `run comando`: ejecuta el comando sin que un fallo pare el test, y guarda su código en `$status`, lo que escribe en `$output` y cada línea en `${lines[@]}`.
- `run -2 comando`: además, el test falla si el código no es `2`.
- `setup()`, en `test_helper.bash`: corre antes de cada test, pone `bin/` en el `PATH` y entra en `$BATS_TEST_TMPDIR`, una carpeta temporal nueva para cada test.

### Paso 2 — TODO 1: la traza en un archivo

Copia el log de ejemplo y mira cómo cuenta `bk-report`:

```bash
cp ../tests/bk-run.log .
cat bk-run.log
bin/bk-report
```

```text
== 2026-11-09 08:00:00 ls /tmp ==
a
== código: 0 ==
== 2026-11-09 08:01:00 ls /nada ==
ls: cannot access '/nada': No such file or directory
== código: 2 ==
== 2026-11-09 08:02:00 nocomando ==
bash: nocomando: command not found
== código: 127 ==
== 2026-11-09 08:03:00 sleep 60 ==
== código: 130 ==
COMANDO VECES  BIEN FALLOS
ls          2     1      1
TOTAL       2     1      1
```

Hay cuatro bloques y cuenta dos: faltan `nocomando` y `sleep`. No da ningún error. Para ver qué hace por dentro hace falta una traza. Así es `set -x`:

```bash
bash -c 'set -x; x=hola; echo "$x"'
```

```text
+ x=hola
+ echo hola
hola
```

Cada línea, con las variables ya cambiadas por su valor, sale con un `+` delante antes de ejecutarse. Ese `+ ` es el valor de `PS4`. Cambia el comentario del `TODO 1`, al final de `lib/core.sh`, por:

```bash
# BK_TRACE=<archivo>: escribe en ese archivo cada línea que ejecuta el comando (set -x).
# PS4 es lo que va delante de cada línea de la traza: el archivo y el número de línea
# dicen dónde mirar. BASH_XTRACEFD manda la traza a un descriptor propio: sin él iría a
# stderr y se mezclaría con los avisos del comando y con lo que capture quien lo llama.
if [[ -n ${BK_TRACE:-} ]]; then
  exec {BASH_XTRACEFD}>> "$BK_TRACE"
  PS4='+ ${BASH_SOURCE[0]##*/}:${LINENO}: '
  set -x
fi
```

- `exec {BASH_XTRACEFD}>> "$BK_TRACE"` abre el archivo para añadir (semana 11, lab 05) y guarda el número del descriptor en `BASH_XTRACEFD`: desde ahí, `set -x` escribe en él.
- `PS4` va entre comillas simples: `${BASH_SOURCE[0]##*/}` (el archivo, sin la ruta) y `${LINENO}` (la línea) se calculan en cada línea de la traza, no una vez al escribir `PS4`.

Prueba:

```bash
BK_TRACE=traza.txt bin/bk-report > /dev/null
head -n 8 traza.txt
```

```text
+ bk-report:10: [[ 0 -le 1 ]]
+ bk-report:11: log=bk-run.log
+ bk-report:12: [[ -r bk-run.log ]]
+ bk-report:16: runs=()
+ bk-report:16: ok=()
+ bk-report:16: failed=()
+ bk-report:16: declare -A runs ok failed
+ bk-report:17: total_runs=0
```

La traza empieza en la línea 10, la siguiente al `source` de `core.sh`. Como la variable se hereda, también funciona con el dispatcher: `BK_TRACE=traza.txt bin/bashkit report` añade las líneas de `bashkit` y las de `bk-report` al mismo archivo.

### Paso 3 — Encontrar el fallo con la traza

Busca en la traza qué pasa con cada línea `== código: N ==`:

```bash
grep -n "código: [0-9]* ==" traza.txt
```

```text
24:+ bk-report:26: [[ == código: 0 == =~ ^== [0-9-]+ [0-9:]+ (.+) ==$ ]]
25:+ bk-report:31: [[ == código: 0 == =~ ^== código: ([0-9]) ==$ ]]
42:+ bk-report:26: [[ == código: 2 == =~ ^== [0-9-]+ [0-9:]+ (.+) ==$ ]]
43:+ bk-report:31: [[ == código: 2 == =~ ^== código: ([0-9]) ==$ ]]
60:+ bk-report:26: [[ == código: 127 == =~ ^== [0-9-]+ [0-9:]+ (.+) ==$ ]]
61:+ bk-report:31: [[ == código: 127 == =~ ^== código: ([0-9]) ==$ ]]
68:+ bk-report:26: [[ == código: 130 == =~ ^== [0-9-]+ [0-9:]+ (.+) ==$ ]]
69:+ bk-report:31: [[ == código: 130 == =~ ^== código: ([0-9]) ==$ ]]
```

Cada línea del log pasa por las dos regex: la de la cabecera (línea 26) y la del pie (línea 31). Mira qué viene después de un pie con `0` y de uno con `127`:

```bash
sed -n '25,28p;61,64p' traza.txt
```

```text
+ bk-report:31: [[ == código: 0 == =~ ^== código: ([0-9]) ==$ ]]
+ bk-report:31: [[ -n ls ]]
+ bk-report:33: runs[$cmd]=1
+ bk-report:34: total_runs=1
+ bk-report:31: [[ == código: 127 == =~ ^== código: ([0-9]) ==$ ]]
+ bk-report:25: IFS=
+ bk-report:25: read -r line
+ bk-report:26: [[ == 2026-11-09 08:03:00 sleep 60 == =~ ^== [0-9-]+ [0-9:]+ (.+) ==$ ]]
```

Con `0`, la regex encaja y el script cuenta (líneas 33 y 34). Con `127`, salta a leer la línea siguiente (25): no encaja. `([0-9])` es **un** dígito: `127` tiene tres. La causa está en la línea 23 de `bin/bk-report`, la que da valor a `footer_re`. No la arregles todavía.

### Paso 4 — TODO 2: primero el test, después el arreglo

Un **test de regresión** comprueba un fallo que ya pasó, para que no vuelva. Se escribe antes del arreglo: si no falla con el fallo, no lo está comprobando. Cambia el comentario del `TODO 2` de `tests/bk-report.bats` por:

```bash
# Un log con tres bloques: dos de ls (bien y mal) y uno de un comando que no existe (127).
write_log() {
  cat > bk-run.log << 'LOG'
== 2026-11-09 08:00:00 ls /tmp ==
a
== código: 0 ==
== 2026-11-09 08:01:00 ls /nada ==
ls: cannot access '/nada': No such file or directory
== código: 2 ==
== 2026-11-09 08:02:00 nocomando ==
bash: nocomando: command not found
== código: 127 ==
LOG
}

@test "bk-report cuenta las veces, los aciertos y los fallos de cada comando" {
  write_log
  run -0 bk-report
  # tr -s ' ' junta los espacios seguidos: el test no depende del ancho de las columnas.
  [[ $(tr -s ' ' <<< "${lines[1]}") == "ls 2 1 1" ]]
}

# Regresión: con la regex ([0-9]) de un solo dígito, los bloques con código 127
# no se contaban y el total salía 2.
@test "bk-report cuenta los códigos de más de un dígito" {
  write_log
  run -0 bk-report
  [[ $(tr -s ' ' <<< "${lines[2]}") == "nocomando 1 0 1" ]]
  [[ $(tr -s ' ' <<< "${lines[3]}") == "TOTAL 3 1 2" ]]
}

@test "bk-report sin log que leer avisa y sale con código 1" {
  run -1 bk-report no-existe.log
  [[ $output == "bk-report: no puedo leer 'no-existe.log'" ]]
}
```

- `write_log` escribe el log en la carpeta temporal del test con un here-doc (semana 03): cada test se prepara sus datos y no depende de lo que hay en `starter/`.
- `${lines[1]}` es la segunda línea de la salida (la primera, `${lines[0]}`, es la cabecera de la tabla).

Prueba:

```bash
bats tests/bk-report.bats; echo "código: $?"
```

```text
bk-report.bats
 ✓ bk-report cuenta las veces, los aciertos y los fallos de cada comando
 ✗ bk-report cuenta los códigos de más de un dígito
   (in test file tests/bk-report.bats, line 33)
     `[[ $(tr -s ' ' <<< "${lines[2]}") == "nocomando 1 0 1" ]]' failed
 ✓ bk-report sin log que leer avisa y sale con código 1

3 tests, 1 failure
código: 1
```

bats dice qué test falla, en qué línea y qué comprobación. Ahora arregla la línea 23 de `bin/bk-report`: `+` detrás de `[0-9]` es "uno o más" (semana 04).

```bash
footer_re='^== código: ([0-9]+) ==$'
```

Prueba:

```bash
bats tests/bk-report.bats
bin/bk-report
```

```text
bk-report.bats
 ✓ bk-report cuenta las veces, los aciertos y los fallos de cada comando
 ✓ bk-report cuenta los códigos de más de un dígito
 ✓ bk-report sin log que leer avisa y sale con código 1

3 tests, 0 failures
COMANDO   VECES  BIEN FALLOS
ls            2     1      1
nocomando     1     0      1
sleep         1     0      1
TOTAL         4     1      3
```

### Paso 5 — TODO 3: los tests de `bk-check`

Cambia el comentario del `TODO 3` de `tests/bk-check.bats` por tus tests. Por ejemplo, estos seis:

```bash
@test "una IP válida da ok y código 0" {
  run bk-check ip 192.168.1.10
  [[ $status -eq 0 ]]
  [[ $output == "ok: 192.168.1.10" ]]
}

@test "una IP con un número mayor que 255 no es válida" {
  run --separate-stderr bk-check ip 192.168.1.256
  [[ $status -eq 1 ]]
  [[ -z $output ]]
  [[ $stderr == "bk-check: '192.168.1.256' no es una IP válida" ]]
}

@test "un email sin dominio no es válido" {
  run -1 bk-check email ana@
  [[ $output == "bk-check: 'ana@' no es un email válido" ]]
}

@test "una versión semántica se separa en sus partes" {
  run -0 bk-check semver 2.10.3-rc.1
  [[ $output == "ok: 2.10.3-rc.1 (mayor 2, menor 10, parche 3, prerelease rc.1)" ]]
}

@test "una versión con ceros a la izquierda no es válida" {
  run -1 bk-check semver 1.02.3
}

@test "un tipo desconocido sale con código 2" {
  run -2 bk-check telefono 600000000
}
```

`run` junta stdout y stderr en `$output`. Con `--separate-stderr`, stderr va a `$stderr`: así el test comprueba que el aviso va a stderr y que stdout queda vacío (`-z`). Prueba:

```bash
bats tests/bk-check.bats
```

```text
bk-check.bats
 ✓ una IP válida da ok y código 0
 ✓ una IP con un número mayor que 255 no es válida
 ✓ un email sin dominio no es válido
 ✓ una versión semántica se separa en sus partes
 ✓ una versión con ceros a la izquierda no es válida
 ✓ un tipo desconocido sale con código 2

6 tests, 0 failures
```

### Paso 6 — TODO 4: los tests de `bk-run`

`bk-run` escribe `bk-run.log` en la carpeta donde lo llamas. Como `setup` entra en `$BATS_TEST_TMPDIR`, cada test tiene un log nuevo y no ensucia `starter/`. Cambia el comentario del `TODO 4` de `tests/bk-run.bats` por:

```bash
@test "bk-run sale con el código del comando" {
  run -3 bk-run bash -c 'exit 3'
}

@test "bk-run enseña la salida y la guarda en bk-run.log con su código" {
  run -0 bk-run echo hola
  [[ $output == "hola" ]]
  [[ $(sed -n 2p bk-run.log) == "hola" ]]
  [[ $(tail -n 1 bk-run.log) == "== código: 0 ==" ]]
}

@test "con un fallo, el aviso va a stderr y no a stdout" {
  run --separate-stderr bk-run false
  [[ $status -eq 1 ]]
  [[ -z $output ]]
  [[ $stderr == "bk-run: warn: 'false' salió con código 1" ]]
}

@test "-q no enseña la salida pero la guarda" {
  run -0 bk-run -q echo hola
  [[ -z $output ]]
  grep -qx hola bk-run.log
}

@test "-l elige el log" {
  run -0 bk-run -l otro.log echo hola
  [[ -f otro.log ]]
  [[ ! -e bk-run.log ]]
}

@test "una opción desconocida sale con código 2" {
  run -2 bk-run -x true
}
```

`grep -qx hola bk-run.log` es una comprobación más: sin `run`, si `grep` falla (no encuentra la línea), el test falla. Prueba, sin el `bk-run.log` del paso 2:

```bash
rm bk-run.log
bats tests/bk-run.bats
ls bk-run.log
```

```text
bk-run.bats
 ✓ bk-run sale con el código del comando
 ✓ bk-run enseña la salida y la guarda en bk-run.log con su código
 ✓ con un fallo, el aviso va a stderr y no a stdout
 ✓ -q no enseña la salida pero la guarda
 ✓ -l elige el log
 ✓ una opción desconocida sale con código 2

6 tests, 0 failures
ls: cannot access 'bk-run.log': No such file or directory
```

Cinco tests ejecutaron `bk-run`, y en `starter/` no hay ningún `bk-run.log`: cada uno escribió el suyo en su carpeta temporal, y bats la borró al acabar.

### Paso 7 — TODOs 5, 6 y 7: `bin/bk-lint`

Abre `bin/bk-lint` en tu editor y dale el bit de ejecución:

```bash
chmod +x bin/bk-lint
```

(sin salida).

**TODO 5: las opciones.** Cambia el comentario del `TODO 5` por (como el `getopts` de `bk-run`, semana 11):

```bash
write=""
while getopts ":wh" opt; do
  case "$opt" in
    w) write=1 ;;
    h)
      echo "$usage"
      exit 0
      ;;
    *) die "opción desconocida: -$OPTARG ($usage)" 2 ;;
  esac
done
shift $((OPTIND - 1))
```

Prueba:

```bash
bin/bk-lint -h; echo $?
bin/bk-lint -x; echo $?
```

```text
uso: bk-lint [-w] [archivo...]
0
bk-lint: opción desconocida: -x (uso: bk-lint [-w] [archivo...])
2
```

**TODO 6: qué archivos.** Cambia el comentario del `TODO 6` por:

```bash
# Sin archivos, todo el kit. Un glob y no ls: bin/* no incluye .gitkeep (empieza por punto).
# El cd a la raíz del kit hace que los avisos digan bin/bk-run y no la ruta entera.
if [[ $# -gt 0 ]]; then
  files=("$@")
else
  cd "$bin_dir/.."
  files=(bin/* lib/*.sh scaffold.sh)
fi
for file in "${files[@]}"; do
  [[ -f $file ]] || die "no existe '$file'" 2
done
```

Prueba:

```bash
bin/bk-lint no-existe; echo $?
```

```text
bk-lint: no existe 'no-existe'
2
```

**TODO 7: las dos revisiones.** Cambia el comentario del `TODO 7` por:

```bash
# Con -w, shfmt reescribe los archivos con el estilo del kit antes de revisarlos.
if [[ -n $write ]]; then
  shfmt "${shfmt_style[@]}" -w "${files[@]}"
fi

# Las dos revisiones siempre: con un && la segunda no correría si la primera falla,
# y verías los avisos a medias. -x sigue los source para revisar también lib/core.sh.
# shfmt -d enseña, como un diff, qué cambiaría: - la línea de ahora, + la de su estilo.
problems=""
shellcheck -x "${files[@]}" || problems="shellcheck"
shfmt "${shfmt_style[@]}" -d "${files[@]}" || problems="${problems:+$problems y }shfmt"

if [[ -n $problems ]]; then
  die "archivos revisados: ${#files[@]}, con avisos de $problems"
fi
log "archivos revisados: ${#files[@]}, sin avisos"
```

`${problems:+$problems y }` escribe `shellcheck y ` solo si `problems` ya tiene algo (semana 05). Prueba con `bk-lint` mismo, y desde el dispatcher:

```bash
bin/bk-lint bin/bk-lint; echo $?
bin/bashkit lint -h
```

```text
bk-lint: archivos revisados: 1, sin avisos
0
uso: bk-lint [-w] [archivo...]
```

### Paso 8 — El kit entero, sin avisos

```bash
bin/bk-lint; echo "código: $?"
```

La salida es larga (unas 80 líneas). Empieza así:

```text

In bin/bk-top-ips line 24:
  head -n $top
          ^--^ SC2086 (info): Double quote to prevent globbing and word splitting.

Did you mean: 
  head -n "$top"

For more information:
  https://www.shellcheck.net/wiki/SC2086 -- Double quote to prevent globbing ...
--- bin/bk-rename.orig
+++ bin/bk-rename
@@ -7,11 +7,20 @@
 # --dry-run enseña qué haría sin tocar nada: se mira antes de renombrar de verdad.
 # shift lo quita de los argumentos, y el archivo pasa a ser $1 en los dos casos.
 dry_run=""
-test "${1:-}" != "--dry-run" || { dry_run=1; shift; }
+test "${1:-}" != "--dry-run" || {
+  dry_run=1
+  shift
+}
```

y termina así:

```text
--- bin/bk-top-ips.orig
+++ bin/bk-top-ips
@@ -4,13 +4,19 @@
 set -euo pipefail
 
 # Sin log no hay nada que contar: el uso va a stderr y el 2 dice "me llamaste mal".
-test "$#" -gt 0 || { echo "uso: bk-top-ips <access.log> [N]" >&2; exit 2; }
+test "$#" -gt 0 || {
+  echo "uso: bk-top-ips <access.log> [N]" >&2
+  exit 2
+}
 log="$1"
 # Cuántas IP enseñar: el segundo argumento o 10 si no lo das.
 top="${2:-10}"
 
 # Comprobarlo antes da un mensaje claro; sin esto, grep fallaría a mitad del pipe con el suyo.
-test -r "$log" || { echo "bk-top-ips: no puedo leer '$log'" >&2; exit 1; }
+test -r "$log" || {
+  echo "bk-top-ips: no puedo leer '$log'" >&2
+  exit 1
+}
 
 # grep -oE saca solo la IP del principio de cada línea (^): ignora las que empiezan
 # por otra cosa (::1, -) y las IP que aparecen más adelante, en el referer.
bk-lint: archivos revisados: 12, con avisos de shellcheck y shfmt
código: 1
```

Dos problemas distintos:

- **shellcheck** (`SC2086`): `$top` sin comillas. Con `bk-top-ips log.txt "5 9"`, `head` recibiría dos argumentos. Arréglalo a mano en `bin/bk-top-ips`, como propone: `head -n "$top"`. shellcheck avisa; no cambia tu código.
- **shfmt**: `bk-rename` y `bk-top-ips` tienen bloques `{ ...; }` en una línea, y su estilo los quiere en varias. No es un error, es formato: lo arregla `-w`.

```bash
bin/bk-lint -w > /dev/null; echo "código: $?"
bin/bk-lint; echo "código: $?"
```

```text
bk-lint: archivos revisados: 12, sin avisos
código: 0
bk-lint: archivos revisados: 12, sin avisos
código: 0
```

`shfmt -w` cambió los archivos: comprueba que siguen funcionando con todos los tests (el final de la salida):

```bash
bats tests
```

```text
 ✓ -q no enseña la salida pero la guarda
 ✓ -l elige el log
 ✓ una opción desconocida sale con código 2

19 tests, 0 failures
```

### Paso 9 — ¿Tus tests sirven? Rompe el kit a propósito

Un test que nunca falla no comprueba nada. Copia el kit a una carpeta temporal (así no tocas el tuyo), rompe `bk-check` para que dé siempre `0` y pasa sus tests:

```bash
kit=$(mktemp -d)
cp -r . "$kit"
sed -i 's/exit 1$/exit 0/' "$kit/bin/bk-check"
bats "$kit/tests/bk-check.bats"; echo "código: $?"
rm -rf "$kit"
```

Algo como (cambia el nombre de la carpeta):

```text
bk-check.bats
 ✓ una IP válida da ok y código 0
 ✗ una IP con un número mayor que 255 no es válida
   (in test file /tmp/tmp.oqtfDb54fg/tests/bk-check.bats, line 14)
     `[[ $status -eq 1 ]]' failed
 ✗ un email sin dominio no es válido
   (in test file /tmp/tmp.oqtfDb54fg/tests/bk-check.bats, line 20)
     `run -1 bk-check email ana@' failed, expected exit code 1, got 0
   bk-check: 'ana@' no es un email válido
 ✓ una versión semántica se separa en sus partes
 ✗ una versión con ceros a la izquierda no es válida
   (in test file /tmp/tmp.oqtfDb54fg/tests/bk-check.bats, line 30)
     `run -1 bk-check semver 1.02.3' failed, expected exit code 1, got 0
   bk-check: '1.02.3' no es una versión semántica válida
 ✓ un tipo desconocido sale con código 2

6 tests, 3 failures
código: 1
```

Tres tests lo pillan. El autograding hace lo mismo con `bk-run` (que salga siempre con `0`) y con `bk-report` (que vuelva la regex de un dígito). Ahora, limpieza: la traza del paso 2, los TODOs que queden y el inventario.

```bash
rm traza.txt
grep -rn TODO bin lib tests scaffold.sh; echo "código: $?"
find . -type f > docs/inventario.txt
grep -E "lint|tests/" docs/inventario.txt
```

```text
código: 1
./tests/bk-check.bats
./tests/bk-run.bats
./tests/test_helper.bash
./tests/.gitkeep
./tests/bashkit.bats
./tests/bk-report.bats
./bin/bk-lint
```

`grep` sale con `1`: no queda ningún TODO en el código. (El orden de `find` puede cambiar en tu equipo.)

### Paso 10 — README del kit

Abre `README.md` (el de `starter/`) en tu editor y cambia los tres TODOs:

- la fila de `bin/bk-lint`: qué revisa, con qué herramientas y qué hace `-w`;
- la frase de los tests: cómo pasarlos desde la raíz del kit (`bats tests`);
- `- Semana 12: TODO`: qué aprendiste y qué te costó.

Comprueba que no queda ninguno:

```bash
grep -n TODO README.md; echo "código: $?"
```

```text
código: 1
```

### Paso 11 — Autograding

```bash
cd "$(git rev-parse --show-toplevel)" && ./scripts/verificar-semana.sh 12
```

```text
Semana 12 — Calidad, testing y depuración

  ✅ bashkit lint -h enseña el uso con código 0; un archivo que no existe avisa y sale con código 2
  ✅ bk-lint encuentra una variable sin comillas (SC2086) en un script nuevo del kit y sale con código 1
  ✅ bk-lint enseña el diff de shfmt de un archivo mal sangrado, y bk-lint -w lo arregla
  ✅ el kit entero pasa bk-lint: shellcheck y shfmt sin avisos
  ✅ con BK_TRACE, la traza va a ese archivo con el archivo y la línea delante, y la salida no cambia
  ✅ BK_TRACE llega del dispatcher al subcomando: la traza tiene líneas de bashkit, de bk-report y de core.sh
  ✅ bk-report cuenta los bloques con códigos de más de un dígito (127, 130)
  ✅ bats tests pasa entero, con 14 tests o más
  ✅ hay tests de bk-check y bk-run (3 o más en cada uno) y de bk-report (2 o más)
  ✅ los tests de bk-check fallan si bk-check da por bueno un valor malo
  ✅ los tests de bk-run fallan si bk-run sale siempre con 0
  ✅ el test de regresión de bk-report falla si vuelve el fallo de los códigos de un dígito
  ✅ los tests no dejan archivos en el kit ni en la carpeta desde la que lanzas bats
  ✅ el kit y sus tests sin TODOs
  ✅ README.md sin TODOs, documenta bk-lint y cómo pasar los tests, y tiene la bitácora de la semana 12

15/15 comprobaciones superadas.
```

Cada ❌ trae una pista con el paso donde se arregla. Para salir del laboratorio: `exit`.

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 12` desde la raíz del repositorio (60 de los 100 puntos del Producto, 4 por comprobación). Los otros 40 son de calidad: ver la [rúbrica](../rubrica-evaluacion.md#-producto-30).

- [ ] bashkit lint -h enseña el uso con código 0; un archivo que no existe avisa y sale con código 2
- [ ] bk-lint encuentra una variable sin comillas (SC2086) en un script nuevo del kit y sale con código 1
- [ ] bk-lint enseña el diff de shfmt de un archivo mal sangrado, y bk-lint -w lo arregla
- [ ] el kit entero pasa bk-lint: shellcheck y shfmt sin avisos
- [ ] con BK_TRACE, la traza va a ese archivo con el archivo y la línea delante, y la salida no cambia
- [ ] BK_TRACE llega del dispatcher al subcomando: la traza tiene líneas de bashkit, de bk-report y de core.sh
- [ ] bk-report cuenta los bloques con códigos de más de un dígito (127, 130)
- [ ] bats tests pasa entero, con 14 tests o más
- [ ] hay tests de bk-check y bk-run (3 o más en cada uno) y de bk-report (2 o más)
- [ ] los tests de bk-check fallan si bk-check da por bueno un valor malo
- [ ] los tests de bk-run fallan si bk-run sale siempre con 0
- [ ] el test de regresión de bk-report falla si vuelve el fallo de los códigos de un dígito
- [ ] los tests no dejan archivos en el kit ni en la carpeta desde la que lanzas bats
- [ ] el kit y sus tests sin TODOs
- [ ] README.md sin TODOs, documenta bk-lint y cómo pasar los tests, y tiene la bitácora de la semana 12

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 07 — Rendimiento: subshells y builtins](../2-practicas/lab-07-rendimiento-subshells-y-builtins/README.md) | [Rúbrica de evaluación](../rubrica-evaluacion.md) → |

[↑ Semana 12](../README.md)
