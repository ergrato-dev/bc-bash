# Proyecto Semana 07 — bk-clean: borrar lo viejo sin miedo

⏱ Duración estimada: ~3 h 30 min

## Contexto

Los logs, los volcados de base de datos y los temporales se acumulan hasta que un día el disco se llena y el servicio se cae. La solución de siempre es un `find ... -delete` en un cron, y el error de siempre es que borre lo que no debía: una carpeta mal escrita, un enlace que apuntaba fuera, un nombre con espacios que se partió en dos. Escribes **`bk-clean`**, el sexto comando de `bashkit` ([docs/proyecto-hilo-conductor.md](../../../docs/proyecto-hilo-conductor.md)): borra los archivos de una o varias carpetas que llevan más de N días sin cambiar, y con `--dry-run` enseña antes la lista.

```text
$ bk-clean --dry-run 7 logs
(dry-run) borrar: logs/app.log.3
(dry-run) borrar: logs/informe de marzo.csv
(dry-run) total: 2 archivos
$ bk-clean 7 logs
borrar: logs/app.log.3
borrar: logs/informe de marzo.csv
total: 2 archivos
```

Lo construyes con `for`, `while`, `read -r -d ''` y `find -print0`: la forma de recorrer archivos que no se rompe con ningún nombre.

## Estructura del proyecto

`starter/` es el `bashkit` con el que terminaste la semana 06, más lo nuevo:

```text
3-proyecto/
├── starter/                 ← aquí trabajas (lo corrige el autograding)
│   ├── README.md            ← fila de bk-clean y bitácora de la semana 07 (TODOs)
│   ├── scaffold.sh
│   ├── bin/
│   │   ├── .gitkeep
│   │   ├── bk-info
│   │   ├── bk-run
│   │   ├── bk-top-ips
│   │   ├── bk-rename
│   │   ├── bk-check
│   │   └── bk-clean         ← nuevo: sin permiso de ejecución (TODOs 1 a 8)
│   ├── lib/.gitkeep
│   ├── tests/.gitkeep
│   └── docs/
│       ├── mapa.txt
│       └── inventario.txt   ← hay que regenerarlo
└── tests/
    └── make-fixtures.sh     ← crea archivos viejos y nuevos para probar
```

## Lo que debes construir

1. `bin/bk-clean` con permisos `755`. Uso: `bk-clean [--dry-run] <días> <carpeta>...` (una carpeta o más).
2. Con `-h` o `--help`, el uso en stdout y código `0`. Con menos de dos argumentos (sin contar `--dry-run`), el uso en stderr y código `2`.
3. Si los días no son un número entero de 1 o más, un aviso en stderr y código `2`.
4. Si alguna carpeta no existe, un aviso en stderr con su nombre y código `1`, **sin borrar nada** en ninguna.
5. Borra los archivos (no las carpetas ni los enlaces) que llevan más de N días sin cambiar, también dentro de las subcarpetas, con cualquier nombre: espacios, `*`, un `-` delante o un salto de línea.
6. Una línea `borrar: <ruta>` por archivo y, al final, `total: N archivos`. Con `--dry-run`, las mismas líneas con `(dry-run) ` delante, y no borra nada.
7. Todos los scripts del kit sin TODOs y sin avisos de shellcheck; `docs/inventario.txt` regenerado y `README.md` sin TODOs.

## Paso a paso

### Paso 0 — Entrar al laboratorio

Desde la raíz del repositorio, en tu equipo:

```bash
docker compose run --rm lab
cd bootcamp/week-07-bucles_read_y_archivos_seguros/3-proyecto/starter
```

(sin salida).

### Paso 1 — `bk-clean` ejecutable

```bash
ls -l bin/bk-clean
chmod +x bin/bk-clean
./bin/bk-clean
echo $?
./bin/bk-clean 7 logs
```

Algo como (cambian el tamaño y la fecha):

```text
-rw-r--r-- 1 alumno alumno 1160 Nov  8 06:30 bin/bk-clean
./bin/bk-clean: line 16: $1: unbound variable
1
sin implementar: 7 logs
total: 0 archivos
```

Sin argumentos, `days="$1"` para el script: con `set -u`, usar `$1` cuando no existe es un error. Lo arreglas en el paso 4. Abre `bin/bk-clean` en tu editor y léelo entero antes de seguir.

### Paso 2 — TODO 1: `-h` y `--help`

Igual que en `bk-check` (semana 06, paso 2). Sustituye el comentario del `TODO 1` por:

```bash
case "${1:-}" in
  -h | --help)
    echo "$usage"
    exit 0
    ;;
esac
```

Prueba:

```bash
./bin/bk-clean --help
echo $?
./bin/bk-clean -h
```

```text
uso: bk-clean [--dry-run] <días> <carpeta>...
0
uso: bk-clean [--dry-run] <días> <carpeta>...
```

### Paso 3 — TODO 2: `--dry-run`

Si el primer argumento es `--dry-run`, el script lo apunta en `dry_run` y lo quita con `shift` (semana 06, lab 06): así, con o sin `--dry-run`, los días son siempre `$1`. Sustituye el comentario del `TODO 2` y la línea `dry_run=""` de debajo por:

```bash
dry_run=""
if [[ "${1:-}" == "--dry-run" ]]; then
  dry_run=1
  shift
fi
```

La última línea del script ya usa `dry_run`: `${dry_run:+(dry-run) }` se convierte en `(dry-run) ` si `dry_run` tiene algo, y en nada si está vacía (semana 05). Prueba:

```bash
./bin/bk-clean --dry-run 7 logs
./bin/bk-clean 7 logs
```

```text
sin implementar: 7 logs
(dry-run) total: 0 archivos
sin implementar: 7 logs
total: 0 archivos
```

`--dry-run` ya no aparece entre los argumentos, y el total lo marca.

### Paso 4 — TODO 3: al menos dos argumentos

Hacen falta los días y una carpeta como mínimo. `-lt` es "menor que" entre números. Sustituye el comentario del `TODO 3` por:

```bash
if [[ $# -lt 2 ]]; then
  echo "$usage" >&2
  exit 2
fi
```

Prueba:

```bash
./bin/bk-clean
echo $?
./bin/bk-clean 7
echo $?
./bin/bk-clean --dry-run 7
echo $?
./bin/bk-clean 7 logs
```

```text
uso: bk-clean [--dry-run] <días> <carpeta>...
2
uso: bk-clean [--dry-run] <días> <carpeta>...
2
uso: bk-clean [--dry-run] <días> <carpeta>...
2
sin implementar: 7 logs
total: 0 archivos
```

Después del `if`, `days="$1"` guarda los días y `shift` los quita: en `"$@"` quedan solo las carpetas.

### Paso 5 — TODO 4: los días, un número de 1 o más

Un número que llega de fuera se valida antes de usarlo (semana 06). La regex `^[1-9][0-9]*$` es "una cifra del 1 al 9 y, detrás, las cifras que sean": deja fuera `0`, `-3`, `7d` y `1.5`. Con `0` el script borraría todo lo que hay en la carpeta. Sustituye el comentario del `TODO 4` por:

```bash
if [[ ! $days =~ ^[1-9][0-9]*$ ]]; then
  echo "bk-clean: '$days' no es un número de días (1 o más)" >&2
  exit 2
fi
```

Prueba:

```bash
./bin/bk-clean abc logs
echo $?
./bin/bk-clean 0 logs
echo $?
./bin/bk-clean 7d logs
echo $?
./bin/bk-clean 30 logs
```

```text
bk-clean: 'abc' no es un número de días (1 o más)
2
bk-clean: '0' no es un número de días (1 o más)
2
bk-clean: '7d' no es un número de días (1 o más)
2
sin implementar: 30 logs
total: 0 archivos
```

### Paso 6 — TODO 5: todas las carpetas existen, o no se toca nada

`for dir in "$@"; do ... done` repite el bloque una vez por argumento, con `dir` valiendo cada uno (lab 01). Con las comillas, una carpeta con espacios es un solo argumento. Antes de borrar nada se comprueban **todas**: si la tercera está mal escrita, no quedan las dos primeras limpias y la tercera sin hacer. Sustituye el comentario del `TODO 5` por:

```bash
for dir in "$@"; do
  if [[ ! -d $dir ]]; then
    echo "bk-clean: '$dir' no es una carpeta" >&2
    exit 1
  fi
done
```

`-d` se cumple si la ruta existe y es una carpeta (semana 06, lab 03). Prueba con una que no existe, con un archivo y con dos carpetas buenas:

```bash
./bin/bk-clean 7 no-existe
echo $?
./bin/bk-clean 7 bin docs/mapa.txt
echo $?
./bin/bk-clean 7 bin docs
```

```text
bk-clean: 'no-existe' no es una carpeta
1
bk-clean: 'docs/mapa.txt' no es una carpeta
1
sin implementar: 7 bin docs
total: 0 archivos
```

El código es `1`, no `2`: el uso está bien escrito, pero el dato no vale.

### Paso 7 — TODO 6: recorrer los archivos viejos con cualquier nombre

Primero, datos de prueba. `tests/make-fixtures.sh` crea, en la carpeta desde la que lo ejecutas, archivos con fecha de hace 10 días y de ayer, con nombres difíciles. `touch -d "10 days ago"` es lo que usa para cambiar la fecha. Los creas en `3-proyecto/zona/`, que git ignora:

```bash
mkdir -p ../zona
cd ../zona
../tests/make-fixtures.sh
ls -lA --time-style=+%F basura
```

`-A` enseña también los nombres que empiezan por punto, y `--time-style=+%F`, la fecha como `año-mes-día`. Algo como (cambian las fechas):

```text
total 4
-rw-r--r-- 1 alumno alumno    0 2026-10-29 '*'
-rw-r--r-- 1 alumno alumno    0 2026-10-29  -empieza-por-guion.log
-rw-r--r-- 1 alumno alumno    0 2026-10-29 'con espacios.log'
lrwxrwxrwx 1 alumno alumno   12 2026-10-29  enlace -> ../fuera.txt
-rw-r--r-- 1 alumno alumno    0 2026-10-29 'linea'$'\n''nueva.log'
-rw-r--r-- 1 alumno alumno    0 2026-11-07  nuevo.log
drwxr-xr-x 2 alumno alumno 4096 2026-11-08  sub
-rw-r--r-- 1 alumno alumno    0 2026-10-29  viejo.log
```

En la terminal, `ls` pone entre comillas los nombres raros, tal como los escribirías en un comando. `'linea'$'\n''nueva.log'` es **un solo archivo** con un salto de línea (`\n`) en el nombre. `enlace` apunta a `../fuera.txt`, de fuera de la carpeta: no se debe borrar ninguno de los dos.

Ahora, `find` sin el script. `-type f` se queda con los archivos normales (ni carpetas ni enlaces) y `-mmin +10080`, con los que cambiaron hace más de 10080 minutos, que son 7 días:

```bash
find basura -type f -mmin +10080
find basura -type f -mmin +10080 | cat
```

Algo como (el orden puede variar):

```text
basura/*
basura/viejo.log
basura/-empieza-por-guion.log
basura/linea?nueva.log
basura/sub/dentro.tmp
basura/con espacios.log
basura/*
basura/viejo.log
basura/-empieza-por-guion.log
basura/linea
nueva.log
basura/sub/dentro.tmp
basura/con espacios.log
```

En la terminal, `find` enseña el salto de línea como `?`. Detrás de un pipe (`| cat` solo copia lo que recibe), lo que recibiría un script, el salto es de verdad: seis archivos en siete líneas. Leyendo línea a línea, `linea` y `nueva.log` serían dos. `-print0` termina cada ruta con el byte nulo en lugar de un salto de línea, y ese byte no puede ir en un nombre. `tr '\0' '|'` lo cambia por `|` para que lo veas:

```bash
find basura -type f -mmin +10080 -print0 | tr '\0' '|'
echo
cd ../starter
```

```text
basura/*|basura/viejo.log|basura/-empieza-por-guion.log|basura/linea
nueva.log|basura/sub/dentro.tmp|basura/con espacios.log|
```

Seis rutas, seis `|`. El `echo` solo añade el salto de línea que falta al final.

Para leer ese flujo, `read -r -d '' file` lee hasta el siguiente byte nulo (`-d ''`), sin tocar las barras `\` (`-r`) ni los espacios del principio y del final (`IFS=` delante, lab 04). Y `done < <(find ...)` le pasa al `while` la salida de `find` (lab 06): con `find ... | while`, el bucle iría en un subshell y lo que cambiara se perdería al salir. Sustituye las líneas de los `TODO 6` a `TODO 8` y el `echo "sin implementar..."` por:

```bash
for dir in "$@"; do
  while IFS= read -r -d '' file; do
    echo "${dry_run:+(dry-run) }borrar: $file"
    # TODO 7: borra cada archivo con rm --, salvo con --dry-run (paso 8)
    # TODO 8: suma 1 a count por archivo (paso 9)
  done < <(find "$dir" -type f -mmin +$((days * 24 * 60)) -print0)
done
```

`$((days * 24 * 60))` pasa los días a minutos (semana 05). `-mmin` y no `-mtime`, que cuenta en días enteros redondeando hacia abajo: con `-mtime +7`, un archivo de 7 días y medio no entra. Prueba:

```bash
./bin/bk-clean 7 ../zona/basura
```

Algo como (el orden puede variar):

```text
borrar: ../zona/basura/*
borrar: ../zona/basura/viejo.log
borrar: ../zona/basura/-empieza-por-guion.log
borrar: ../zona/basura/linea
nueva.log
borrar: ../zona/basura/sub/dentro.tmp
borrar: ../zona/basura/con espacios.log
total: 0 archivos
```

Seis `borrar:`, uno por archivo, incluido el del salto de línea. Ni `nuevo.log`, ni `enlace`, ni `sub`. Todavía no borra nada y el total sigue en `0`.

### Paso 8 — TODO 7: borrar, salvo con `--dry-run`

`[[ -n $dry_run ]] || rm -- "$file"` se lee "o hay `dry_run`, o se borra": `||` ejecuta lo de la derecha solo si lo de la izquierda falla (semana 03). `--` le dice a `rm` que lo que viene ya no son opciones: sin él, `rm -empieza-por-guion.log` tomaría el nombre por opciones. Sustituye el comentario del `TODO 7` por:

```bash
    [[ -n $dry_run ]] || rm -- "$file"
```

Prueba primero con `--dry-run`, y mira que no se borró nada:

```bash
./bin/bk-clean --dry-run 7 ../zona/basura
ls -A ../zona/basura
```

Algo como (el orden de las líneas `borrar` y el reparto en columnas pueden variar):

```text
(dry-run) borrar: ../zona/basura/*
(dry-run) borrar: ../zona/basura/viejo.log
(dry-run) borrar: ../zona/basura/-empieza-por-guion.log
(dry-run) borrar: ../zona/basura/linea
nueva.log
(dry-run) borrar: ../zona/basura/sub/dentro.tmp
(dry-run) borrar: ../zona/basura/con espacios.log
(dry-run) total: 0 archivos
'*'                       'con espacios.log'  'linea'$'\n''nueva.log'   sub
 -empieza-por-guion.log   enlace              nuevo.log                viejo.log
```

Ahora de verdad:

```bash
./bin/bk-clean 7 ../zona/basura
ls -A ../zona/basura ../zona/basura/sub ../zona
```

```text
borrar: ../zona/basura/*
borrar: ../zona/basura/viejo.log
borrar: ../zona/basura/-empieza-por-guion.log
borrar: ../zona/basura/linea
nueva.log
borrar: ../zona/basura/sub/dentro.tmp
borrar: ../zona/basura/con espacios.log
total: 0 archivos
../zona:
basura  fuera.txt  otra

../zona/basura:
enlace  nuevo.log  sub

../zona/basura/sub:
```

Quedan `nuevo.log`, el enlace, la carpeta `sub` (vacía) y `fuera.txt`. `otra/` no se tocó porque no se pidió.

### Paso 9 — TODO 8: contar

`count=$((count + 1))` suma uno a `count`. No uses `((count++))`: cuando `count` vale `0`, esa forma sale con código `1` y `set -e` para el script en el primer archivo (lab 07). Sustituye el comentario del `TODO 8` por:

```bash
    count=$((count + 1))
```

Vuelve a crear los datos (el script se puede repetir) y prueba con dos carpetas:

```bash
(cd ../zona && ../tests/make-fixtures.sh)
./bin/bk-clean 7 ../zona/basura ../zona/otra
ls -A ../zona/otra
```

Los paréntesis ejecutan el `cd` y el script en un subshell: al terminar sigues en `starter/`. Algo como (el orden puede variar):

```text
borrar: ../zona/basura/*
borrar: ../zona/basura/viejo.log
borrar: ../zona/basura/-empieza-por-guion.log
borrar: ../zona/basura/linea
nueva.log
borrar: ../zona/basura/sub/dentro.tmp
borrar: ../zona/basura/con espacios.log
borrar: ../zona/otra/viejo.txt
total: 7 archivos
nuevo.txt
```

Siete: seis de `basura/` y uno de `otra/`. El total es correcto porque el `while` no va detrás de un pipe.

### Paso 10 — El kit sin TODOs y sin avisos

```bash
grep -n TODO bin/bk-info bin/bk-run bin/bk-top-ips bin/bk-rename bin/bk-check bin/bk-clean scaffold.sh
shellcheck bin/bk-info bin/bk-run bin/bk-top-ips bin/bk-rename bin/bk-check bin/bk-clean scaffold.sh
```

(sin salida): ningún TODO y ningún aviso. Si shellcheck dice `SC2162 (info): read without -r will mangle backslashes`, te falta el `-r` del `read`.

### Paso 11 — El inventario al día

```bash
find . -type f > docs/inventario.txt
grep bk- docs/inventario.txt
```

Algo como (el orden puede variar):

```text
./bin/bk-info
./bin/bk-run
./bin/bk-top-ips
./bin/bk-rename
./bin/bk-check
./bin/bk-clean
```

### Paso 12 — README del kit

```bash
grep -n TODO README.md
```

```text
27:| `bin/bk-clean` | TODO: qué borra, qué argumentos recibe, qué hace `--dry-run` y qué no toca nunca |
45:- Semana 07: TODO: qué aprendiste y qué te costó.
```

Abre `README.md` en tu editor y sustituye cada `TODO` con tus palabras: qué borra `bk-clean`, qué argumentos recibe, qué hace `--dry-run`, qué no toca nunca (carpetas, enlaces, nada si una carpeta no existe) y la bitácora de la semana (la línea tiene que empezar por `- Semana 07:`). Repite el `grep` hasta que no imprima nada.

### Paso 13 — Autograding

```bash
cd "$(git rev-parse --show-toplevel)" && ./scripts/verificar-semana.sh 07
```

Con todo hecho:

```text
Semana 07 — Bucles, read y archivos seguros

  ✅ bin/bk-clean tiene permisos 755 y el shebang #!/usr/bin/env bash
  ✅ con --help y con -h, bk-clean escribe 'uso: bk-clean ...' en stdout y sale con código 0
  ...
  ✅ README.md sin TODOs, documenta bk-clean y tiene la bitácora de la semana 07

15/15 comprobaciones superadas.
```

Cada ❌ trae una pista con el paso donde se arregla. Para salir del laboratorio: `exit`.

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 07` desde la raíz del repositorio (60 de los 100 puntos del Producto). Los otros 40 son de calidad: ver la [rúbrica](../rubrica-evaluacion.md#-producto-30).

- [ ] bin/bk-clean tiene permisos 755 y el shebang #!/usr/bin/env bash
- [ ] con --help y con -h, bk-clean escribe 'uso: bk-clean ...' en stdout y sale con código 0
- [ ] sin argumentos, solo con los días o solo con --dry-run y los días, escribe el uso en stderr y sale con código 2
- [ ] con 'abc', '0', '-3', '7d' o '1.5' como días, avisa en stderr y sale con código 2
- [ ] si una de las carpetas no existe, avisa en stderr con su nombre, sale con código 1 y no borra nada de las otras
- [ ] con --dry-run, lista los 6 archivos viejos de basura/ con '(dry-run) borrar: ' y no borra ninguno
- [ ] 'bk-clean 7 basura' borra viejo.log y 'con espacios.log', y deja nuevo.log
- [ ] borra los archivos viejos que empiezan por -, que se llaman * o que tienen un salto de línea en el nombre
- [ ] entra en las subcarpetas: borra basura/sub/dentro.tmp, pero deja la carpeta basura/sub
- [ ] no borra el enlace basura/enlace ni el archivo de fuera al que apunta, ni nada de otra/
- [ ] 'bk-clean 7 basura otra' limpia las dos carpetas: borra otra/viejo.txt y deja otra/nuevo.txt
- [ ] la última línea de 'bk-clean 7 basura otra' es 'total: 7 archivos'
- [ ] los scripts del kit sin TODOs; bk-clean con set -euo pipefail, find -print0, read -r -d '' y rm --, sin $(ls) ni pipes a while; todo limpio para shellcheck
- [ ] docs/inventario.txt incluye ./bin/bk-clean
- [ ] README.md sin TODOs, documenta bk-clean y tiene la bitácora de la semana 07

## Calidad

Además de los checks, se revisa (40 pts, ver la rúbrica):

- Rutas de `find` con `-print0` y `read -r -d ''`, nunca `for f in $(find ...)` ni `$(ls)`; `"$file"` citado en cada uso.
- Todas las carpetas se validan antes del primer `rm`; `rm --`; nada se borra con `--dry-run`.
- Uso y errores a stderr con su código (`2` para un uso mal hecho, `1` para una carpeta que no existe); `borrar:` y `total:`, a stdout.
- Comentarios que explican el porqué: por qué `-print0`, por qué `< <(...)` y no un pipe, por qué `-type f`, por qué `-mmin`.

## Entrega

Commit desde tu copia del repositorio con el mensaje `feat(week-07): bk-clean` que incluya `starter/` completo. Comprueba con `git diff` que aparece `new mode 100755` para `bin/bk-clean`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 07 — Bucles rotos](../2-practicas/lab-07-bucles-rotos/README.md) | [Rúbrica de evaluación](../rubrica-evaluacion.md) → |

[↑ Semana 07](../README.md)
