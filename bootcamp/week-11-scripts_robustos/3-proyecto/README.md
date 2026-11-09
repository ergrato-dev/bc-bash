# Proyecto Semana 11 — bk-run robusto: opciones, temporales y bloqueo

⏱ Duración estimada: ~3 h 30 min

## Contexto

`bk-run` (semana 03) es el comando del kit que más se usa: ejecuta otro comando y apunta en un log su salida y su código. Funciona bien mientras lo lanzas tú, uno cada vez. Pero un cron, dos terminales o un CI pueden lanzar dos `bk-run` a la vez sobre el mismo log, y entonces pasa esto (con el `bk-run` de la semana pasada):

```text
== 2026-11-09 02:42:23 bash -c echo a1; sleep 1; echo a2 ==
== 2026-11-09 02:42:23 bash -c sleep 0.5; echo b1; sleep 1; echo b2 ==
a1
b1
a2
== código: 0 ==
b2
== código: 0 ==
```

Las líneas de los dos comandos están mezcladas, y `bk-report` (semana 09) ya no sabe qué salida es de cuál. Esta semana conviertes `bk-run` en un script robusto, con lo que viste en los labs:

- **opciones con `getopts`** (lab 04): `-q` (no enseñar la salida), `-v` (contar lo que hace), `-l log`, `-w segundos` y `-h`;
- **un temporal con `mktemp` que borra un `trap EXIT`** (labs 02 y 03): la salida se guarda ahí mientras corre el comando;
- **un bloqueo con `flock`** (lab 05): el bloque entero se copia al log de una vez, y de uno en uno;
- **avisos por niveles en `lib/core.sh`** (lab 06): `log_debug`, `log_info` y `log_warn`, con `BK_LOG_LEVEL`.

Como `bashkit` pasa los argumentos tal cual (semana 08), `bashkit run -q ./deploy.sh` funciona sin tocar el dispatcher.

## Estructura del proyecto

`starter/` es el `bashkit` con el que terminaste la semana 10, con TODOs en dos archivos:

```text
3-proyecto/
├── starter/                 ← aquí trabajas
│   ├── README.md            ← 2 TODOs: bk-run y la bitácora
│   ├── bin/
│   │   ├── bk-run           ← TODOs 2 a 7
│   │   └── bashkit, bk-check, bk-clean, bk-info, bk-logs, bk-rename, bk-report, bk-top-ips
│   ├── lib/core.sh          ← TODO 1
│   └── docs/
└── solucion/
```

No hay archivos nuevos: el inventario de `docs/` sigue valiendo.

## Lo que debes construir

1. En `lib/core.sh`: `log_at <nivel> <mensaje>`, que escribe `comando: nivel: mensaje` en stderr solo si el nivel llega al de `BK_LOG_LEVEL` (`debug` < `info` < `warn` < `error`; `info` si no está), y para el script con código `2` si `BK_LOG_LEVEL` no es uno de los cuatro. Encima, `log_debug`, `log_info` y `log_warn`.
2. `bk-run [-q] [-v] [-l log] [-w segundos] [--] <comando> [argumentos...]`, con `getopts`. `-h` escribe el uso en stdout y sale con `0`. Una opción desconocida, una opción sin su valor, la falta de comando o un `-w` que no es un número: `die` con código `2`.
3. Antes de ejecutar el comando, comprueba que puede escribir en el log; si no, `die` con su nombre y código `1`.
4. La salida del comando va a un temporal de `mktemp`, que un `trap ... EXIT` borra al salir. Con `-q` no se enseña en pantalla.
5. Al terminar el comando, bloquea el log con `flock -w` y copia el bloque entero (cabecera, salida y código). Si no consigue el bloqueo, no borra el temporal y dice dónde está.
6. Un comando que falla avisa con `log_warn`, y `bk-run` sale con su código.
7. El kit sin TODOs y sin avisos de `shellcheck -x`; `README.md` sin TODOs.

## Paso a paso

Los comandos de los pasos dejan `bk-run.log` y alguna carpeta de prueba dentro de `starter/`; el paso 8 los borra.

### Paso 0 — Entrar al laboratorio

Desde la raíz del repositorio, en tu equipo:

```bash
docker compose run --rm lab
cd bootcamp/week-11-scripts_robustos/3-proyecto/starter
```

(sin salida).

Mira el problema de las opciones antes de empezar:

```bash
bin/bk-run -q echo hola; echo $?
```

```text
bin/bk-run: line 19: -q: command not found
bk-run: '-q echo hola' salió con código 127
127
```

Para este `bk-run`, todo lo que va detrás es el comando: intenta ejecutar un programa llamado `-q`.

### Paso 1 — TODO 1: avisos por niveles en `lib/core.sh`

Abre `lib/core.sh` en tu editor. Al final están los dos comentarios del `TODO 1`. Cámbialos por:

```bash
# Niveles de aviso: debug < info < warn < error. BK_LOG_LEVEL dice desde cuál se escriben
# (info si no dices otro): con BK_LOG_LEVEL=debug ves los detalles, con error solo los fallos.
# level_number <nivel>: el número del nivel, o código 1 si no es ninguno de los cuatro.
level_number() {
  case "$1" in
    debug) echo 0 ;;
    info) echo 1 ;;
    warn) echo 2 ;;
    error) echo 3 ;;
    *) return 1 ;;
  esac
}

# log_at <nivel> <mensaje>: escribe "comando: nivel: mensaje" si el nivel llega al de BK_LOG_LEVEL.
# Un BK_LOG_LEVEL mal escrito para el script: si lo callara, no verías ni los avisos que pediste.
log_at() {
  local level="$1" min
  shift
  min="$(level_number "${BK_LOG_LEVEL:-info}")" ||
    die "BK_LOG_LEVEL='$BK_LOG_LEVEL' no es un nivel (debug, info, warn o error)" 2
  # return 0 y no un if sin else: un aviso que no se escribe no es un fallo, y con set -e
  # un código 1 aquí pararía el script que llamó a log_at.
  (($(level_number "$level") >= min)) || return 0
  log "$level: $*"
}

log_debug() { log_at debug "$@"; }
log_info() { log_at info "$@"; }
log_warn() { log_at warn "$@"; }
```

Es el lab 06 dentro de la librería: los niveles pasan a números con un `case` y se comparan con `(( ))`. `local level="$1" min` declara dos variables locales en una línea. Prueba cargándola en un bash nuevo, igual que hace cada comando del kit:

```bash
bash -c 'source lib/core.sh; log_warn "disco al 91%"; log_debug "no sale"; BK_LOG_LEVEL=debug log_debug "ahora sí"; BK_LOG_LEVEL=error log_warn "tampoco sale"; BK_LOG_LEVEL=mucho log_info hola; echo "nunca llega"'; echo $?
```

```text
bash: warn: disco al 91%
bash: debug: ahora sí
bash: BK_LOG_LEVEL='mucho' no es un nivel (debug, info, warn o error)
2
```

El aviso empieza por `bash:` porque `${0##*/}` es el nombre del programa que cargó la librería, y aquí es `bash -c`. `VAR=valor comando` pone la variable solo para ese comando (semana 02). Con `mucho`, `die` para el script y `nunca llega` no sale.

### Paso 2 — TODO 2: las opciones con `getopts`

Abre `bin/bk-run` en tu editor. Cambia el comentario del `TODO 2` por:

```bash
# shellcheck source=SCRIPTDIR/../lib/core.sh
source "$(dirname "${BASH_SOURCE[0]}")/../lib/core.sh"

usage="uso: bk-run [-q] [-v] [-l log] [-w segundos] [--] <comando> [argumentos...]"

# Los valores por defecto antes de leer las opciones: una opción solo cambia el suyo.
quiet=""
log="${BK_LOG:-bk-run.log}"
wait_secs=10

# getopts lee las opciones una a una: "l:" lleva valor (llega en OPTARG) y la q no.
# Los dos puntos del principio callan los avisos de getopts: los errores los da die,
# con el formato y el código de todo el kit.
while getopts ":qvl:w:h" opt; do
  case "$opt" in
    q) quiet=1 ;;
    v) BK_LOG_LEVEL=debug ;;
    l) log="$OPTARG" ;;
    w) wait_secs="$OPTARG" ;;
    h)
      echo "$usage"
      exit 0
      ;;
    :) die "a -$OPTARG le falta su valor" 2 ;;
    *) die "opción desconocida: -$OPTARG ($usage)" 2 ;;
  esac
done
# OPTIND es el número del primer argumento que no es una opción: el shift deja en $@
# solo el comando. getopts para en "--" o en lo primero que no empieza por "-", así
# "bk-run -q ls -l" no toma la -l de ls por la suya.
shift $((OPTIND - 1))
```

Y borra, un poco más abajo, el comentario de `BK_LOG` y la línea `log="${BK_LOG:-bk-run.log}"`: ahora el log se decide arriba, con los demás valores por defecto. `-v` cambia `BK_LOG_LEVEL` para el resto del script: los `log_debug` empiezan a salir. Prueba:

```bash
bin/bk-run -h; echo $?
bin/bk-run -x true; echo $?
bin/bk-run -l; echo $?
bin/bk-run -l otro.log echo hola
cat otro.log
```

Algo como (cambian la fecha y la hora):

```text
uso: bk-run [-q] [-v] [-l log] [-w segundos] [--] <comando> [argumentos...]
0
bk-run: opción desconocida: -x (uso: bk-run [-q] [-v] [-l log] [-w segundos] [--] <comando> [argumentos...])
2
bk-run: a -l le falta su valor
2
hola
== 2026-11-09 02:42:35 echo hola ==
hola
== código: 0 ==
```

Dos cosas que aún no van:

```bash
bin/bk-run -q ls -d .; echo $?
bin/bk-run -q; echo $?
```

```text
.
0
uso: bk-run <comando> [argumentos...]
2
```

`-q` ya se lee, pero nadie mira `quiet` (paso 6). Y sin comando, el aviso es el viejo, sin `bk-run:` delante y sin las opciones: lo cambias en el paso 3. La `-d` de `ls -d .` llegó a `ls`: getopts paró en `ls`, lo primero que no empieza por `-`.

### Paso 3 — TODO 3: sin comando y `-w`

Cambia el comentario del `TODO 3` y la línea `test "$#" -gt 0 || ...` de debajo por:

```bash
[[ $# -gt 0 ]] || die "$usage" 2
[[ $wait_secs =~ ^[0-9]+$ ]] || die "'$wait_secs' no es un número de segundos" 2
```

`$#` cuenta lo que quedó después del `shift`: el comando y sus argumentos. Prueba:

```bash
bin/bk-run -q; echo $?
bin/bk-run -w ya true; echo $?
```

```text
bk-run: uso: bk-run [-q] [-v] [-l log] [-w segundos] [--] <comando> [argumentos...]
2
bk-run: 'ya' no es un número de segundos
2
```

### Paso 4 — TODO 4: ¿se puede escribir en el log?

Antes de este TODO, con un log en una carpeta que no existe:

```bash
bin/bk-run -l no/existe.log touch hecho; echo $?
ls hecho
```

```text
bin/bk-run: line 42: no/existe.log: No such file or directory
1
ls: cannot access 'hecho': No such file or directory
```

(El número de línea depende de cómo quedó tu archivo.) Ahora lo para el `echo "== ..." >> "$log"` del principio, con un aviso de bash poco claro. En el paso 6 ese `echo` desaparece y el comando correría sin poder apuntarse. Cambia el comentario del `TODO 4` por:

```bash
# Antes de ejecutar nada: un deploy que corre sin poder apuntarse es peor que uno que no corre.
{ : >> "$log"; } 2> /dev/null || die "no puedo escribir en '$log'"
```

`:` es el comando que no hace nada; con `>> "$log"` abre el log para añadir (y lo crea si no existe) sin escribir nada. Las llaves agrupan para que `2> /dev/null` también calle el aviso de bash cuando la redirección falla. Prueba:

```bash
bin/bk-run -l no/existe.log touch hecho; echo $?
ls
```

```text
bk-run: no puedo escribir en 'no/existe.log'
1
README.md
bin
docs
lib
scaffold.sh
tests
```

No hay `hecho`: `touch` no llegó a correr.

### Paso 5 — TODO 5: un temporal que se borra solo

Primero sin `trap`, para ver el problema. Cambia el comentario del `TODO 5` por:

```bash
# La salida va a un temporal y se copia entera al log al final. Directa al log, dos bk-run
# a la vez mezclarían sus líneas y bk-report contaría mal.
tmp="$(mktemp)"
log_debug "salida temporal: $tmp"
```

`mktemp` crea un archivo vacío con un nombre que no existía (`/tmp/tmp.XXXXXXXXXX`) y escribe su ruta. Si la variable `TMPDIR` tiene una carpeta, lo crea ahí: así ves los temporales sin mirar todo `/tmp`. Prueba:

```bash
mkdir t
TMPDIR=$PWD/t bin/bk-run -v echo hola
ls -A t
TMPDIR=$PWD/t bin/bk-run false; echo $?
ls -A t
```

Algo como (cambian los nombres de los temporales):

```text
bk-run: debug: salida temporal: /bc-bash/bootcamp/week-11-scripts_robustos/3-proyecto/starter/t/tmp.2GqmpWGX9j
hola
tmp.2GqmpWGX9j
bk-run: 'false' salió con código 1
1
tmp.2GqmpWGX9j
tmp.UNsIQgRBM0
```

Cada ejecución deja su temporal: en un cron que corre cada minuto, son 1440 archivos al día. Añade debajo de `tmp="$(mktemp)"`:

```bash
# EXIT corre al salir por cualquier camino (bien, con error, con set -e o con kill):
# el temporal no se queda en /tmp. Comillas simples: $tmp se lee al salir, no ahora.
trap 'rm -f -- "$tmp"' EXIT
```

Prueba otra vez, empezando con `t/` vacía:

```bash
rm -f t/*
TMPDIR=$PWD/t bin/bk-run -v echo hola
ls -A t
TMPDIR=$PWD/t bin/bk-run bash -c 'exit 3'; echo $?
ls -A t
```

Algo como:

```text
bk-run: debug: salida temporal: /bc-bash/bootcamp/week-11-scripts_robustos/3-proyecto/starter/t/tmp.czq9wMoMvZ
hola
bk-run: 'bash -c exit 3' salió con código 3
3
```

Los dos `ls -A t` no imprimen nada: el `trap` borró el temporal al salir, también cuando el comando falló.

### Paso 6 — TODO 6: la salida, al temporal

Borra la línea `echo "== $(date '+%F %T') $* ==" >> "$log"` (la cabecera se escribirá al final, con el resto del bloque). Después cambia el comentario del `TODO 6` y las dos líneas de debajo (`status=0` y la de `tee -a "$log"`) por:

```bash
start="$(date '+%F %T')"
status=0
if [[ -n $quiet ]]; then
  "$@" > "$tmp" 2>&1 || status=$?
else
  "$@" 2>&1 | tee "$tmp" || status=$?
fi
```

`start` guarda la hora de inicio, la que irá en la cabecera. Con `-q`, la salida va solo al temporal; sin `-q`, `tee` la enseña y la guarda (sin `-a`: el temporal empieza vacío). Prueba:

```bash
rm -f bk-run.log
bin/bk-run -q echo secreto; echo $?
bin/bk-run echo visible
cat bk-run.log
```

```text
0
visible
== código: 0 ==
== código: 0 ==
```

`-q` ya calla, pero el log solo tiene los pies de bloque: la salida se queda en el temporal y el `trap` la borra. Falta copiarla.

### Paso 7 — TODO 7: el bloque entero, con `flock`

Cambia el comentario del `TODO 7` y las dos líneas de debajo (el `echo "== código..."` y el `test "$status" -eq 0 || ...`) por:

```bash
# Se abre el log para añadir y se bloquea: el comando ya ha corrido sin esperar a nadie,
# solo la copia del bloque va de uno en uno. flock -w se rinde a los N segundos.
exec {lock_fd}>> "$log"
if ! flock -w "$wait_secs" "$lock_fd"; then
  # Sin bloqueo no se escribe, pero la salida es lo único que queda: se quita el trap
  # para no borrarla, y el aviso dice dónde está.
  trap - EXIT
  die "otro proceso tiene bloqueado '$log' desde hace más de $wait_secs s; la salida está en $tmp"
fi
log_debug "bloqueo de '$log' conseguido"
{
  echo "== $start $* =="
  cat -- "$tmp"
  echo "== código: $status =="
} >&"$lock_fd"

# El aviso de fallo va a stderr: así no se mezcla con la salida del comando.
[[ $status -eq 0 ]] || log_warn "'$*' salió con código $status"
```

`exec {lock_fd}>> "$log"` abre el log para añadir y guarda en `lock_fd` el número de descriptor que bash eligió (lab 05). `flock` bloquea ese descriptor; el bloqueo se suelta solo cuando `bk-run` termina y el descriptor se cierra. `>&"$lock_fd"` manda el bloque por ese descriptor. `trap - EXIT` quita el `trap`. Cambia también la segunda línea de la cabecera del script, porque ahora `bk-run` hace algo más:

```bash
# Para qué: dejar constancia de lo que hiciste en una máquina y de si salió bien, también
# cuando varios bk-run escriben a la vez en el mismo log (un cron, dos terminales).
```

Prueba los avisos y el log:

```bash
rm -f bk-run.log
bin/bk-run -q echo secreto
bin/bk-run false; echo $?
BK_LOG_LEVEL=error bin/bk-run false; echo $?
cat bk-run.log
```

Algo como (cambian la fecha y la hora):

```text
bk-run: warn: 'false' salió con código 1
1
1
== 2026-11-09 02:43:11 echo secreto ==
secreto
== código: 0 ==
== 2026-11-09 02:43:11 false ==
== código: 1 ==
== 2026-11-09 02:43:11 false ==
== código: 1 ==
```

Con `BK_LOG_LEVEL=error` el aviso no sale, pero el código sigue siendo `1`. Ahora, dos a la vez, como en el Contexto. `&` deja el primero corriendo de fondo y `wait` espera a que termine (semana 02):

```bash
rm bk-run.log
bin/bk-run bash -c 'echo a1; sleep 1; echo a2' > /dev/null &
bin/bk-run bash -c 'sleep 0.5; echo b1; sleep 1; echo b2' > /dev/null
wait
cat bk-run.log
```

Algo como:

```text
== 2026-11-09 02:43:11 bash -c echo a1; sleep 1; echo a2 ==
a1
a2
== código: 0 ==
== 2026-11-09 02:43:11 bash -c sleep 0.5; echo b1; sleep 1; echo b2 ==
b1
b2
== código: 0 ==
```

Cada bloque entero. Por último, alguien que no suelta el log: `flock bk-run.log sleep 5` lo bloquea durante 5 segundos.

```bash
flock bk-run.log sleep 5 &
sleep 0.5
bin/bk-run -w 1 echo hola; echo $?
wait
```

Algo como (cambia el nombre del temporal):

```text
hola
bk-run: otro proceso tiene bloqueado 'bk-run.log' desde hace más de 1 s; la salida está en /tmp/tmp.qM7adaxjlH
1
```

Mira que la salida sigue ahí (con la ruta que te salió a ti) y bórrala:

```bash
cat /tmp/tmp.qM7adaxjlH
rm /tmp/tmp.qM7adaxjlH
```

```text
hola
```

`bk-report` sigue entendiendo el log: el formato del bloque no ha cambiado.

```bash
bin/bk-report
```

```text
COMANDO VECES  BIEN FALLOS
bash        2     2      0
TOTAL       2     2      0
```

### Paso 8 — shellcheck y limpieza

```bash
rm -rf bk-run.log otro.log t
grep -rn TODO bin lib scaffold.sh
shellcheck -x bin/* lib/core.sh scaffold.sh; echo $?
```

```text
0
```

El `grep` no imprime nada: no queda ningún TODO en el código.

### Paso 9 — README del kit

```bash
grep -n TODO README.md
```

```text
23:| `bin/bk-run` | TODO: qué hace `bk-run`, qué cambian `-q`, `-l`, `-v` y `-w`, y qué pasa cuando dos `bk-run` escriben a la vez en el mismo log |
56:- Semana 11: TODO: qué aprendiste y qué te costó.
```

Abre `README.md` en tu editor y sustituye cada `TODO` con tus palabras: qué hace `bk-run`, sus opciones (`-q`, `-l`, `-v`, `-w`), qué pasa con dos `bk-run` a la vez y la bitácora de la semana (la línea tiene que empezar por `- Semana 11:`). Aprovecha para contar en la línea de `lib/` que `core.sh` tiene avisos por niveles. Repite el `grep` hasta que no imprima nada.

### Paso 10 — Autograding

```bash
cd "$(git rev-parse --show-toplevel)" && ./scripts/verificar-semana.sh 11
```

Con todo hecho:

```text
Semana 11 — Scripts robustos

  ✅ bk-run lee sus opciones con getopts y usa mktemp, trap y flock
  ✅ bk-run -h escribe el uso en stdout y sale con código 0
  ✅ una opción desconocida o una -l sin valor avisan en stderr y salen con código 2
  ✅ sin comando, o con un -w que no es un número de segundos, avisa en stderr y sale con código 2
  ✅ -l elige el log: el bloque va a ese archivo y no a bk-run.log
  ✅ -q no enseña la salida del comando, pero la guarda en el log
  ✅ las opciones que van detrás del comando (o de --) son del comando, no de bk-run
  ✅ si no puede escribir en el log, avisa con su nombre, sale con 1 y no ejecuta el comando
  ✅ -v cuenta en stderr qué temporal usa (de mktemp); al terminar, bien o con un fallo, ya no existe y sale con el código del comando
  ✅ dos bk-run a la vez con el mismo log no mezclan sus líneas: cada bloque va entero
  ✅ si otro proceso tiene el log bloqueado más de -w segundos, avisa, sale con 1 y dice dónde dejó la salida
  ✅ un fallo avisa con nivel warn, y con BK_LOG_LEVEL=error ese aviso no sale
  ✅ un BK_LOG_LEVEL que no es debug, info, warn ni error para bk-run con código 2
  ✅ el kit sin TODOs y limpio para shellcheck -x
  ✅ README.md sin TODOs, documenta las opciones de bk-run y tiene la bitácora de la semana 11

15/15 comprobaciones superadas.
```

Cada ❌ trae una pista con el paso donde se arregla. Para salir del laboratorio: `exit`.

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 11` desde la raíz del repositorio (60 de los 100 puntos del Producto, 4 por comprobación). Los otros 40 son de calidad: ver la [rúbrica](../rubrica-evaluacion.md#-producto-30).

- [ ] bk-run lee sus opciones con getopts y usa mktemp, trap y flock
- [ ] bk-run -h escribe el uso en stdout y sale con código 0
- [ ] una opción desconocida o una -l sin valor avisan en stderr y salen con código 2
- [ ] sin comando, o con un -w que no es un número de segundos, avisa en stderr y sale con código 2
- [ ] -l elige el log: el bloque va a ese archivo y no a bk-run.log
- [ ] -q no enseña la salida del comando, pero la guarda en el log
- [ ] las opciones que van detrás del comando (o de --) son del comando, no de bk-run
- [ ] si no puede escribir en el log, avisa con su nombre, sale con 1 y no ejecuta el comando
- [ ] -v cuenta en stderr qué temporal usa (de mktemp); al terminar, bien o con un fallo, ya no existe y sale con el código del comando
- [ ] dos bk-run a la vez con el mismo log no mezclan sus líneas: cada bloque va entero
- [ ] si otro proceso tiene el log bloqueado más de -w segundos, avisa, sale con 1 y dice dónde dejó la salida
- [ ] un fallo avisa con nivel warn, y con BK_LOG_LEVEL=error ese aviso no sale
- [ ] un BK_LOG_LEVEL que no es debug, info, warn ni error para bk-run con código 2
- [ ] el kit sin TODOs y limpio para shellcheck -x
- [ ] README.md sin TODOs, documenta las opciones de bk-run y tiene la bitácora de la semana 11

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 07 — Un script idempotente](../2-practicas/lab-07-script-idempotente/README.md) | [Rúbrica de evaluación](../rubrica-evaluacion.md) → |

[↑ Semana 11](../README.md)
