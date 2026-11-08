# Proyecto Semana 08 — lib/core.sh y bashkit: un kit, un comando

⏱ Duración estimada: ~3 h 30 min

## Contexto

`bashkit` ya tiene seis comandos, y cada uno avisa de los errores a su manera: un `echo ... >&2` y un `exit` copiados una y otra vez. Esta semana sacas lo repetido a una **librería**, `lib/core.sh`, con tres funciones que cualquier comando carga con `source`: `log` (avisar), `die` (avisar y parar) y `require` (comprobar que existe un comando). Y escribes **`bin/bashkit`**, un **dispatcher**: un solo comando que recibe el nombre de un subcomando y ejecuta el `bk-*` que le toca ([docs/proyecto-hilo-conductor.md](../../../docs/proyecto-hilo-conductor.md)).

```text
$ bashkit help
uso: bashkit <subcomando> [argumentos...]
subcomandos:
  check
  clean
  info
  rename
  run
  top-ips
$ bashkit check ip 10.0.0.1
ok: 10.0.0.1
$ bashkit clean 7 no-existe
bk-clean: 'no-existe' no es una carpeta
```

A partir de la semana 09, cada novedad del kit es un subcomando más de `bashkit`.

## Estructura del proyecto

`starter/` es el `bashkit` con el que terminaste la semana 07, más lo nuevo:

```text
3-proyecto/
├── starter/                 ← aquí trabajas (lo corrige el autograding)
│   ├── README.md            ← fila de bashkit, core.sh y bitácora de la semana 08 (TODOs)
│   ├── scaffold.sh
│   ├── bin/
│   │   ├── .gitkeep
│   │   ├── bashkit          ← nuevo: sin permiso de ejecución (TODOs 4 a 8)
│   │   ├── bk-info
│   │   ├── bk-run
│   │   ├── bk-top-ips
│   │   ├── bk-rename
│   │   ├── bk-check
│   │   └── bk-clean         ← pasa a usar core.sh (TODO 9)
│   ├── lib/
│   │   └── core.sh          ← nuevo: log, die y require (TODOs 1 a 3)
│   ├── tests/.gitkeep
│   └── docs/
│       ├── mapa.txt
│       └── inventario.txt   ← hay que regenerarlo
└── solucion/
```

## Lo que debes construir

1. `lib/core.sh`, **sin** permiso de ejecución y sin shebang: se carga con `source`. Cargarlo no imprime nada ni cambia las opciones de la shell.
2. `log <mensaje>`: escribe `nombre-del-script: mensaje` en stderr. `die <mensaje> [código]`: lo mismo y termina el script con el código (`1` si no se dice otro). `require <comando>...`: si falta alguno, `die` con su nombre. Sin dejar variables suyas en el script que la llama.
3. `bin/bashkit` con permisos `755`. Uso: `bashkit <subcomando> [argumentos...]`. Con `help`, `-h` o `--help`, el uso y la lista de subcomandos (los `bk-*` ejecutables de `bin/`) en stdout y código `0`. Sin argumentos, lo mismo en stderr y código `2`.
4. Un subcomando que no encaja con `^[a-z][a-z-]*$` o que no existe: aviso en stderr con el nombre y código `2`.
5. `bashkit <sub> args...` ejecuta `bin/bk-<sub>` con los argumentos intactos y sale con su código. Funciona desde cualquier carpeta y por el `PATH`.
6. `bk-clean` carga `lib/core.sh` y avisa con `die`; sus mensajes y códigos no cambian.
7. Todo el kit sin TODOs y sin avisos de `shellcheck -x`; `docs/inventario.txt` regenerado y `README.md` sin TODOs.

## Paso a paso

### Paso 0 — Entrar al laboratorio

Desde la raíz del repositorio, en tu equipo:

```bash
docker compose run --rm lab
cd bootcamp/week-08-funciones_alcance_y_librerias/3-proyecto/starter
```

(sin salida).

### Paso 1 — Una librería no se ejecuta

```bash
ls -l lib/core.sh bin/bashkit
bash lib/core.sh; echo $?
bash -c 'source lib/core.sh; log hola'
```

Algo como (cambian la fecha y el tamaño):

```text
-rw-r--r-- 1 alumno alumno 1006 Nov  8 06:54 bin/bashkit
-rw-r--r-- 1 alumno alumno  945 Nov  8 06:53 lib/core.sh
0
sin implementar: log
```

`core.sh` no tiene `x` ni shebang: no es un comando. Ejecutarlo solo **define** las funciones, sin llamar a ninguna, y no imprime nada. `source` lo lee dentro de la shell que lo carga, y por eso después `log` existe ahí. `bash -c '...'` ejecuta el texto en una bash nueva: así las funciones no se quedan en la tuya.

### Paso 2 — TODO 1: `log`

Abre `lib/core.sh` en tu editor. En `log`, borra el comentario del `TODO 1` y el `echo "sin implementar: log" >&2`, y escribe:

```bash
  printf '%s: %s\n' "${0##*/}" "$*" >&2
```

`$0` es la ruta del script que se está ejecutando (dentro de una función no cambia), y `${0##*/}` le quita las carpetas (semana 05). `"$*"` junta todos los argumentos de la función en un texto. Prueba:

```bash
bash -c 'source lib/core.sh; log "hola  mundo"'
bash -c 'source lib/core.sh; log "hola  mundo"' 2>/dev/null; echo $?
```

```text
bash: hola  mundo
0
```

Con `bash -c`, `$0` vale `bash`; desde `bk-clean`, valdrá `bk-clean`. Con `2>/dev/null` no sale nada: el aviso va a stderr.

### Paso 3 — TODO 2: `die`

En `die`, borra el comentario del `TODO 2` y el `echo`, y escribe:

```bash
  log "$1"
  exit "${2:-1}"
```

Una función puede llamar a otra. `exit` dentro de una función termina el script entero, no solo la función (eso es `return`). `${2:-1}` es el segundo argumento o, si no hay, `1`. Prueba:

```bash
bash -c 'source lib/core.sh; die "no hay datos"; echo sigue'; echo $?
bash -c 'source lib/core.sh; die "uso malo" 2'; echo $?
```

```text
bash: no hay datos
1
bash: uso malo
2
```

`sigue` no aparece: `die` paró el script.

### Paso 4 — TODO 3: `require` y `local`

`command -v nombre` imprime la ruta de un comando y sale con `0`, o sale con `1` si no existe. En `require`, borra el comentario del `TODO 3` y el `echo`, y escribe:

```bash
  local cmd
  for cmd in "$@"; do
    command -v "$cmd" > /dev/null || die "falta el comando '$cmd'"
  done
```

`"$@"` dentro de una función son **sus** argumentos, no los del script. `local cmd` hace que `cmd` exista solo mientras dura la función. Prueba:

```bash
bash -c 'source lib/core.sh; require bash find; echo bien'; echo $?
bash -c 'source lib/core.sh; require grep no-existe; echo mal'; echo $?
bash -c 'cmd=mio; source lib/core.sh; require bash; echo "cmd vale $cmd"'
```

```text
bien
0
bash: falta el comando 'no-existe'
1
cmd vale mio
```

Quita `local cmd` y repite el último: imprime `cmd vale bash`. Sin `local`, la variable del `for` es la misma que la del script y la pisa. Vuelve a ponerlo.

### Paso 5 — TODO 4: `bashkit` encuentra su librería

```bash
./bin/bashkit; echo $?
```

```text
bash: ./bin/bashkit: Permission denied
126
```

```bash
chmod +x bin/bashkit
```

(sin salida). Abre `bin/bashkit` en tu editor. Borra el comentario del `TODO 4` y escribe en su lugar:

```bash
bin_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=SCRIPTDIR/../lib/core.sh
source "$bin_dir/../lib/core.sh"
```

`${BASH_SOURCE[0]}` es la ruta de este archivo tal como se llamó (`./bin/bashkit`, `/ruta/al/kit/bin/bashkit`...). `dirname` le quita el nombre, y `cd ... && pwd` la convierte en absoluta. Así la librería se busca **junto al script**, no en la carpeta en la que estás. El comentario `# shellcheck source=...` le dice a shellcheck dónde está el archivo (paso 12). Prueba desde dos sitios:

```bash
./bin/bashkit hola; echo $?
(cd /tmp && "$OLDPWD/bin/bashkit" hola); echo $?
(cd /tmp && source lib/core.sh); echo $?
```

```text
sin implementar: hola
0
sin implementar: hola
0
bash: lib/core.sh: No such file or directory
1
```

Los paréntesis ejecutan los comandos en un subshell: el `cd /tmp` no cambia tu carpeta. `$OLDPWD` es la carpeta en la que estabas antes del último `cd`. `bashkit` funciona desde `/tmp`; un `source lib/core.sh` relativo, no.

### Paso 6 — TODO 5: ayuda y uso

En `main`, borra el comentario del `TODO 5` y escribe:

```bash
  case "${1:-}" in
    -h | --help | help)
      usage
      exit 0
      ;;
    "")
      usage >&2
      exit 2
      ;;
  esac
```

`usage` ya está escrita: una función que imprime, y cuya salida se redirige como la de cualquier comando (`usage >&2`). Prueba:

```bash
./bin/bashkit help; echo $?
./bin/bashkit > /dev/null; echo $?
```

```text
uso: bashkit <subcomando> [argumentos...]
subcomandos:
  (sin implementar)
0
uso: bashkit <subcomando> [argumentos...]
subcomandos:
  (sin implementar)
2
```

El segundo sale aunque tires stdout: va por stderr.

### Paso 7 — TODO 6: la lista de subcomandos

En `list_subcommands`, borra el comentario del `TODO 6` y el `echo "  (sin implementar)"`, y escribe:

```bash
  local file
  for file in "$bin_dir"/bk-*; do
    if [[ -x $file ]]; then
      echo "  ${file##*/bk-}"
    fi
  done
```

`${file##*/bk-}` quita todo hasta el último `/bk-`: de `.../bin/bk-clean` queda `clean`. Es `if` y no `[[ -x $file ]] && echo`: si el último archivo no fuese ejecutable, el `&&` dejaría la función saliendo con `1`, y `set -e` pararía `bashkit`. Prueba:

```bash
./bin/bashkit --help
(cd /tmp && "$OLDPWD/bin/bashkit" -h)
```

```text
uso: bashkit <subcomando> [argumentos...]
subcomandos:
  check
  clean
  info
  rename
  run
  top-ips
uso: bashkit <subcomando> [argumentos...]
subcomandos:
  check
  clean
  info
  rename
  run
  top-ips
```

La lista sale de `bin/`: con un `bk-nuevo`, `bashkit` lo ofrece sin tocar esta función.

### Paso 8 — TODO 7: nombres válidos

El subcomando llega de quien escribe en la terminal, y acaba dentro de una ruta. Debajo del `esac`, borra el comentario del `TODO 7` y escribe:

```bash
  local sub="$1"
  shift
  [[ $sub =~ ^[a-z][a-z-]*$ ]] || die "'$sub' no es un nombre de subcomando" 2
```

`shift` quita el subcomando de `"$@"`: lo que queda son sus argumentos. Prueba:

```bash
./bin/bashkit ../../etc/passwd; echo $?
./bin/bashkit Info; echo $?
./bin/bashkit info; echo $?
```

```text
bashkit: '../../etc/passwd' no es un nombre de subcomando
2
bashkit: 'Info' no es un nombre de subcomando
2
sin implementar: 
0
```

`die` viene de `core.sh`: ya la usas. Con `info` el nombre es bueno y llega al `echo` del TODO 8, ya sin argumentos.

### Paso 9 — TODO 8: ejecutar el subcomando

Borra el comentario del `TODO 8` y el `echo "sin implementar: $*"`, y escribe:

```bash
  [[ -x "$bin_dir/bk-$sub" ]] || die "subcomando desconocido: '$sub' (mira bashkit help)" 2
  exec "$bin_dir/bk-$sub" "$@"
```

`exec` sustituye `bashkit` por el otro programa, sin volver: el código de salida de `bashkit` es el del subcomando. `"$@"` entre comillas pasa cada argumento entero, aunque lleve espacios o esté vacío. Prueba:

```bash
./bin/bashkit nada; echo $?
./bin/bashkit check ip 10.0.0.1; echo $?
./bin/bashkit check ip 999.1.1.1; echo $?
BK_LOG=/dev/null ./bin/bashkit run printf '[%s]\n' 'a  b' '' c; echo $?
```

```text
bashkit: subcomando desconocido: 'nada' (mira bashkit help)
2
ok: 10.0.0.1
0
bk-check: '999.1.1.1' no es una IP válida
1
[a  b]
[]
[c]
0
```

Tres argumentos, tres líneas: `'a  b'` con sus dos espacios y `''` vacío llegan tal cual hasta `printf`. `BK_LOG=/dev/null` hace que `bk-run` no deje un log aquí.

### Paso 10 — Por el `PATH`

```bash
PATH="$PWD/bin:$PATH"
cd /tmp
bashkit check semver 1.2.3; echo $?
cd -
```

Algo como (cambia la ruta que imprime `cd -`):

```text
ok: 1.2.3 (mayor 1, menor 2, parche 3)
0
/bc-bash/bootcamp/week-08-funciones_alcance_y_librerias/3-proyecto/starter
```

Desde `/tmp`, por el nombre, como cualquier comando. El `PATH` cambiado dura hasta que sales del laboratorio.

### Paso 11 — TODO 9: `bk-clean` con `core.sh`

```bash
bashkit clean 7 no-existe; echo $?
```

```text
bk-clean: 'no-existe' no es una carpeta
1
```

Funciona, pero con su propio `echo ... >&2; exit`. Abre `bin/bk-clean` en tu editor y borra las dos líneas del comentario del `TODO 9`. En su lugar, carga la librería con la misma idea del paso 5:

```bash
# shellcheck source=SCRIPTDIR/../lib/core.sh
source "$(dirname "${BASH_SOURCE[0]}")/../lib/core.sh"
```

Cambia el `if` que comprueba los días (cuatro líneas, de `if` a `fi`) por:

```bash
[[ $days =~ ^[1-9][0-9]*$ ]] || die "'$days' no es un número de días (1 o más)" 2
```

el `if` de dentro del primer `for` por:

```bash
  [[ -d $dir ]] || die "'$dir' no es una carpeta"
```

y, justo encima de `count=0`, añade:

```bash
require find
```

`die` ya pone `bk-clean: ` delante: el texto del mensaje va sin él. Prueba:

```bash
grep -n 'source\|die\|require' bin/bk-clean
bashkit clean 7 no-existe; echo $?
bashkit clean 7d .; echo $?
```

```text
7:# shellcheck source=SCRIPTDIR/../lib/core.sh
8:source "$(dirname "${BASH_SOURCE[0]}")/../lib/core.sh"
34:[[ $days =~ ^[1-9][0-9]*$ ]] || die "'$days' no es un número de días (1 o más)" 2
39:  [[ -d $dir ]] || die "'$dir' no es una carpeta"
42:require find
bk-clean: 'no-existe' no es una carpeta
1
bk-clean: '7d' no es un número de días (1 o más)
2
```

Los mismos mensajes y códigos que antes, ahora salidos de `core.sh`.

### Paso 12 — shellcheck sigue el `source`

```bash
shellcheck bin/bk-clean; echo $?
```

```text

In bin/bk-clean line 8:
source "$(dirname "${BASH_SOURCE[0]}")/../lib/core.sh"
       ^-- SC1091 (info): Not following: SCRIPTDIR/../lib/core.sh was not specified as input (see shellcheck -x).

For more information:
  https://www.shellcheck.net/wiki/SC1091 -- Not following: SCRIPTDIR/../lib/c...
1
```

shellcheck no lee otros archivos si no se lo pides: sin leer `core.sh`, no sabe qué es `die`. `-x` le deja seguir los `source`, y `SCRIPTDIR` del comentario significa "la carpeta del script". Todo el kit:

```bash
shellcheck -x bin/* lib/core.sh scaffold.sh; echo $?
```

```text
0
```

`lib/core.sh` empieza por `# shellcheck shell=bash`: sin shebang, así sabe shellcheck qué shell es.

### Paso 13 — El inventario al día

```bash
find . -type f > docs/inventario.txt
grep -E 'bashkit|core' docs/inventario.txt
```

```text
./bin/bashkit
./lib/core.sh
```

### Paso 14 — README del kit

```bash
grep -n TODO README.md
```

```text
10:| `lib/` | funciones compartidas que cargan los comandos (TODO: qué funciones trae `core.sh`) |
27:| `bin/bashkit` | TODO: qué hace `bashkit <subcomando>` y qué enseña `bashkit help` |
47:- Semana 08: TODO: qué aprendiste y qué te costó.
```

Abre `README.md` en tu editor y sustituye cada `TODO` con tus palabras: qué hacen `log`, `die` y `require`, cómo se usa `bashkit` (un ejemplo con `bashkit clean`) y la bitácora de la semana (la línea tiene que empezar por `- Semana 08:`). Repite el `grep` hasta que no imprima nada.

### Paso 15 — Autograding

```bash
cd "$(git rev-parse --show-toplevel)" && ./scripts/verificar-semana.sh 08
```

Con todo hecho:

```text
Semana 08 — Funciones, alcance y librerías

  ✅ lib/core.sh existe, sin bit de ejecución, y cargarlo con source no imprime nada ni cambia las opciones de la shell
  ✅ log escribe 'nombre-del-script: mensaje' en stderr y nada en stdout
  ...
  ✅ README.md sin TODOs, documenta bashkit y core.sh y tiene la bitácora de la semana 08

16/16 comprobaciones superadas.
```

Cada ❌ trae una pista con el paso donde se arregla. Para salir del laboratorio: `exit`.

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 08` desde la raíz del repositorio (60 de los 100 puntos del Producto). Los otros 40 son de calidad: ver la [rúbrica](../rubrica-evaluacion.md#-producto-30).

- [ ] lib/core.sh existe, sin bit de ejecución, y cargarlo con source no imprime nada ni cambia las opciones de la shell
- [ ] log escribe 'nombre-del-script: mensaje' en stderr y nada en stdout
- [ ] die avisa en stderr y para el script con código 1, o con el código que recibe
- [ ] require no dice nada si los comandos existen; si falta uno, avisa con su nombre y sale con código 1
- [ ] require no deja variables suyas en el script que la llama: usa local
- [ ] bin/bashkit tiene permisos 755 y el shebang #!/usr/bin/env bash
- [ ] help, -h y --help escriben el uso en stdout, con la lista de subcomandos sacada de bin/, y salen con código 0
- [ ] sin argumentos, bashkit escribe el uso en stderr y sale con código 2
- [ ] con un subcomando que no existe, o con un nombre con / o mayúsculas, avisa en stderr con el nombre y sale con código 2
- [ ] bashkit check ip ... ejecuta bk-check con sus argumentos y sale con su mismo código
- [ ] los argumentos llegan enteros al subcomando: uno con espacios sigue siendo uno
- [ ] bashkit funciona desde cualquier carpeta, llamado por el PATH
- [ ] bk-clean carga lib/core.sh, avisa con die y sigue funcionando igual, también llamado por bashkit
- [ ] el kit sin TODOs y limpio para shellcheck -x, que sigue el source hasta lib/core.sh
- [ ] docs/inventario.txt incluye ./bin/bashkit y ./lib/core.sh
- [ ] README.md sin TODOs, documenta bashkit y core.sh y tiene la bitácora de la semana 08

## Calidad

Además de los checks, se revisa (40 pts, ver la rúbrica):

- Funciones pequeñas con un solo trabajo; toda variable de una función, `local`.
- Avisos a stderr con `log`/`die`; `2` para un uso mal hecho; la salida útil, a stdout.
- La librería se busca junto al script (`BASH_SOURCE`), no en la carpeta actual; `core.sh` no ejecuta nada al cargarse.
- Comentarios que explican el porqué: por qué `exec`, por qué `BASH_SOURCE`, por qué se valida el nombre, por qué `local`.

## Entrega

Commit desde tu copia del repositorio con el mensaje `feat(week-08): lib/core.sh y bashkit` que incluya `starter/` completo. Comprueba con `git diff` que aparece `new mode 100755` para `bin/bashkit`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 07 — Funciones rotas](../2-practicas/lab-07-funciones-rotas/README.md) | [Rúbrica de evaluación](../rubrica-evaluacion.md) → |

[↑ Semana 08](../README.md)
