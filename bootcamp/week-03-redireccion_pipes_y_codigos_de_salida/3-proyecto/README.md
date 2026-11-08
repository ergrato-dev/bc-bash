# Proyecto Semana 03 — bk-run: ejecutar y dejar constancia

⏱ Duración estimada: ~3 h 30 min

## Contexto

En un servidor no basta con ejecutar un comando: hay que saber después qué se ejecutó, cuándo, qué dijo y si salió bien. Esta semana escribes **`bk-run`**, el segundo comando de `bashkit` ([docs/proyecto-hilo-conductor.md](../../../docs/proyecto-hilo-conductor.md)). Recibe cualquier comando, lo ejecuta, te enseña su salida y la guarda en un log junto con la fecha y el código de salida:

```text
$ bk-run ls /etc/hostname /no-existe
ls: cannot access '/no-existe': No such file or directory
/etc/hostname
bk-run: 'ls /etc/hostname /no-existe' salió con código 2
```

Y además, `bk-run` sale con el mismo código que el comando, así que puede usarse dentro de otros scripts. También pondrás el modo estricto, `set -euo pipefail`, en todos los scripts del kit.

## Estructura del proyecto

`starter/` es el `bashkit` con el que terminaste la semana 02, más lo nuevo:

```text
starter/                   ← aquí trabajas (lo corrige el autograding)
├── README.md              ← fila de bk-run y bitácora de la semana 03 (TODOs)
├── scaffold.sh            ← falta el modo estricto (TODO 6)
├── bin/
│   ├── .gitkeep
│   ├── bk-info            ← falta el modo estricto (TODO 6)
│   └── bk-run             ← nuevo: sin permiso de ejecución (TODOs 1 a 5)
├── lib/.gitkeep
├── tests/.gitkeep
└── docs/
    ├── mapa.txt
    └── inventario.txt     ← hay que regenerarlo
```

## Lo que debes construir

1. `bin/bk-run` con permisos `755` y `set -euo pipefail`.
2. Sin argumentos, `bk-run` escribe `uso: bk-run <comando> [argumentos...]` en stderr y sale con código `2`.
3. Con un comando, `bk-run` añade a `bk-run.log` (o al archivo de la variable `BK_LOG`) un bloque así, y no borra los anteriores:
   ```text
   == 2026-11-08 05:03:45 ls /etc/hostname /no-existe ==
   ls: cannot access '/no-existe': No such file or directory
   /etc/hostname
   == código: 2 ==
   ```
4. La salida y los errores del comando salen también por pantalla. Si el comando falla, `bk-run` avisa en stderr y sale con el mismo código.
5. `bk-info`, `bk-run` y `scaffold.sh` con `set -euo pipefail`, sin TODOs y sin avisos de shellcheck.
6. `docs/inventario.txt` regenerado y `README.md` sin TODOs.

## Paso a paso

### Paso 0 — Entrar al laboratorio y a la carpeta del proyecto

Desde la raíz del repositorio, en tu equipo:

```bash
docker compose run --rm lab
cd bootcamp/week-03-redireccion_pipes_y_codigos_de_salida/3-proyecto/starter
```

(sin salida). Todo el proyecto se hace desde esta carpeta, `starter/`.

### Paso 1 — `bk-run` ejecutable

`bk-run` ya tiene el shebang, pero no el permiso. Lo arreglas como en la semana 02:

```bash
ls -l bin/bk-run
./bin/bk-run echo hola
chmod 755 bin/bk-run
./bin/bk-run echo hola
echo $?
```

Algo como (cambian la fecha y el tamaño):

```text
-rw-r--r-- 1 alumno alumno 848 Nov  8 05:02 bin/bk-run
bash: ./bin/bk-run: Permission denied
sin implementar
1
```

`echo hola` son los **argumentos** de `bk-run`: el comando que tiene que ejecutar. De momento lo ignora, imprime `sin implementar` y sale con código `1`. Desde aquí, prueba cada TODO con `./bin/bk-run`.

### Paso 2 — TODO 1: el modo estricto

Abre `starter/bin/bk-run` en tu editor. Sustituye la línea del `TODO 1` por:

```bash
set -euo pipefail
```

Tres opciones a la vez ([teoría](../1-teoria/04-set-euo-pipefail.md)): `-e` para el script en el primer comando que falla, `-u` lo para si usas una variable que no existe, y `-o pipefail` hace que un pipe falle si falla cualquiera de sus comandos. Guarda y comprueba que no ha cambiado nada:

```bash
./bin/bk-run echo hola
echo $?
```

```text
sin implementar
1
```

### Paso 3 — TODO 2: el mensaje de uso

Sin comando no hay nada que ejecutar. Bajo el `TODO 2`, en una sola línea:

```bash
test "$#" -gt 0 || { echo "uso: bk-run <comando> [argumentos...]" >&2; exit 2; }
```

Pieza a pieza:

- `$#` es el número de argumentos que recibió el script (lo verás a fondo en la semana 06).
- `test "$#" -gt 0` es un comando que no imprime nada: sale con `0` si el número es mayor (*greater than*) que 0, y con `1` si no.
- `||` ejecuta lo de la derecha solo si lo de la izquierda falló.
- `{ ...; }` agrupa dos comandos para que el `||` ejecute los dos. Los espacios tras `{` y el `;` antes de `}` son obligatorios.
- `>&2` manda el mensaje a stderr, el canal de los errores, y `exit 2` sale con el código habitual de "uso incorrecto".

Prueba:

```bash
./bin/bk-run
echo $?
./bin/bk-run 2> /dev/null
echo $?
```

```text
uso: bk-run <comando> [argumentos...]
2
2
```

Con `2> /dev/null` el mensaje desaparece: es la prueba de que va por stderr. El código `2` sigue ahí.

### Paso 4 — TODO 3: la cabecera del bloque

Bajo el `TODO 3`:

```bash
echo "== $(date '+%F %T') $* ==" >> "$log"
```

`date '+%F %T'` imprime la fecha y la hora (`2026-11-08 05:03:45`). `$*` son todos los argumentos juntos en un texto: el comando que vas a ejecutar. `>> "$log"` añade la línea al final del log en vez de imprimirla. Prueba:

```bash
./bin/bk-run echo hola
cat bk-run.log
rm bk-run.log
```

Algo como (cambian la fecha y la hora):

```text
sin implementar
== 2026-11-08 05:03:45 echo hola ==
```

La cabecera no sale en pantalla, solo en el log. Borras el log para que la próxima prueba empiece de cero.

### Paso 5 — TODO 4: ejecutar y guardar

Bajo el `TODO 4`, dos líneas:

```bash
status=0
"$@" 2>&1 | tee -a "$log" || status=$?
```

- `"$@"` son los argumentos tal cual llegaron, cada uno por separado: ejecuta el comando. Con `$*` se juntarían en un solo texto y `ls /etc/hostname` buscaría un programa llamado así, con espacio.
- `2>&1` manda los errores del comando al mismo sitio que su salida, para que entren los dos en el pipe ([teoría](../1-teoria/01-redireccion-y-descriptores.md)).
- `tee -a "$log"` copia lo que recibe a la pantalla y al final del log a la vez ([teoría](../1-teoria/02-pipes-tee-y-here-docs.md)).
- Con `pipefail`, el pipe sale con el código del comando, no con el de `tee`. Si falla, `|| status=$?` guarda ese código. Sin el `||`, `set -e` pararía `bk-run` justo aquí y el log se quedaría sin la línea del código.

Prueba con un comando que funciona a medias:

```bash
./bin/bk-run ls /etc/hostname /no-existe
cat bk-run.log
rm bk-run.log
```

Algo como:

```text
ls: cannot access '/no-existe': No such file or directory
/etc/hostname
sin implementar
== 2026-11-08 05:03:45 ls /etc/hostname /no-existe ==
ls: cannot access '/no-existe': No such file or directory
/etc/hostname
```

El error de `ls` está en el log gracias al `2>&1`.

### Paso 6 — TODO 5: el código, el aviso y la salida

Bajo el `TODO 5`, tres líneas. Borra después `echo "sin implementar" >&2`, `exit 1` y los comentarios `TODO`:

```bash
echo "== código: $status ==" >> "$log"
test "$status" -eq 0 || echo "bk-run: '$*' salió con código $status" >&2
exit "$status"
```

La primera cierra el bloque del log. La segunda avisa por stderr solo si el código no es (`-eq`, *equal*) `0`. La tercera sale con el código del comando. Prueba:

```bash
./bin/bk-run ls /etc/hostname /no-existe
echo $?
./bin/bk-run true
echo $?
cat bk-run.log
```

Algo como:

```text
ls: cannot access '/no-existe': No such file or directory
/etc/hostname
bk-run: 'ls /etc/hostname /no-existe' salió con código 2
2
0
== 2026-11-08 05:03:45 ls /etc/hostname /no-existe ==
ls: cannot access '/no-existe': No such file or directory
/etc/hostname
== código: 2 ==
== 2026-11-08 05:03:45 true ==
== código: 0 ==
```

`true` es un comando que no hace nada y siempre sale con `0`: su bloque no tiene salida. Ahora separa los dos canales de `bk-run`:

```bash
./bin/bk-run ls /no-existe > /dev/null
./bin/bk-run ls /no-existe 2> /dev/null
rm bk-run.log
```

```text
bk-run: 'ls /no-existe' salió con código 2
ls: cannot access '/no-existe': No such file or directory
```

Con `> /dev/null` solo queda el aviso de `bk-run`, que va por stderr. Con `2> /dev/null` queda el error de `ls`: el `2>&1` de dentro lo convirtió en salida normal de `bk-run`.

### Paso 7 — `bk-run` por su nombre y con otro log

```bash
PATH="$PWD/bin:$PATH"
bk-run hostname
bk-run false || echo "algo falló"
grep -c "^== código" bk-run.log
```

```text
bc-bash-lab
bk-run: 'false' salió con código 1
algo falló
2
```

`false` siempre sale con `1`. Como `bk-run` devuelve ese código, el `||` de tu shell funciona igual que con `false` a secas. `grep -c` cuenta las líneas que empiezan por `== código`: dos ejecuciones, dos bloques. Ninguna borró la anterior.

Ahora con otro log, dándole la variable `BK_LOG` solo a ese comando:

```bash
BK_LOG=otro.log bk-run id -un
cat otro.log
ls *.log
rm bk-run.log otro.log
```

Algo como:

```text
alumno
== 2026-11-08 05:03:45 id -un ==
alumno
== código: 0 ==
bk-run.log
otro.log
```

### Paso 8 — TODO 6: modo estricto en todo el kit

`bk-info` y `scaffold.sh` tienen la línea que lo prometía:

```bash
grep -n TODO bin/bk-run bin/bk-info scaffold.sh
```

```text
bin/bk-info:4:# TODO 6: sustituye esta línea por el modo estricto (paso 8)
scaffold.sh:4:# TODO 6: sustituye esta línea por el modo estricto (paso 8)
```

Abre los dos en tu editor y sustituye esa línea por `set -euo pipefail`. Comprueba:

```bash
grep -n TODO bin/bk-run bin/bk-info scaffold.sh
shellcheck bin/bk-run bin/bk-info scaffold.sh
./bin/bk-info | head -3
```

```text
== bashkit info ==
usuario: alumno
grupos: alumno
```

Los dos primeros, sin salida: ningún TODO y ningún aviso. `bk-info` sigue funcionando: ninguno de sus comandos falla ni usa variables que no existan.

### Paso 9 — El inventario al día

Comprueba antes que no queda ningún `.log` de las pruebas (`ls *.log` debe dar `No such file or directory`): si no, entraría en el inventario.

```bash
find . -type f > docs/inventario.txt
cat docs/inventario.txt
```

Algo como (el orden puede variar):

```text
./README.md
./scaffold.sh
./docs/mapa.txt
./docs/inventario.txt
./tests/.gitkeep
./bin/bk-info
./bin/bk-run
./bin/.gitkeep
./lib/.gitkeep
```

### Paso 10 — README del kit

```bash
grep -n TODO README.md
```

```text
23:| `bin/bk-run` | TODO: qué hace, dónde deja el log y con qué código sale |
31:- Semana 03: TODO: qué aprendiste y qué te costó.
```

Abre `README.md` en tu editor y sustituye cada `TODO` con tus palabras: qué hace `bk-run`, dónde deja el log (y cómo cambiarlo con `BK_LOG`), con qué código sale, y la bitácora de la semana (la línea tiene que empezar por `- Semana 03:`). Repite el `grep` hasta que no imprima nada.

### Paso 11 — Autograding

```bash
cd "$(git rev-parse --show-toplevel)" && ./scripts/verificar-semana.sh 03
```

Con todo hecho:

```text
Semana 03 — Redirección, pipes y códigos de salida

  ✅ bin/bk-run tiene permisos 755 y el shebang #!/usr/bin/env bash
  ✅ bin/bk-run activa el modo estricto con set -euo pipefail
  ...
  ✅ README.md sin TODOs, documenta bk-run y tiene la bitácora de la semana 03

16/16 comprobaciones superadas.
```

Cada ❌ trae una pista con el paso donde se arregla. Para salir del laboratorio: `exit`.

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 03` desde la raíz del repositorio (60 de los 100 puntos del Producto). Los otros 40 son de calidad: ver la [rúbrica](../rubrica-evaluacion.md#-producto-30).

- [ ] bin/bk-run tiene permisos 755 y el shebang #!/usr/bin/env bash
- [ ] bin/bk-run activa el modo estricto con set -euo pipefail
- [ ] sin argumentos, bk-run sale con código 2
- [ ] sin argumentos, bk-run escribe 'uso: bk-run ...' en stderr, no en stdout
- [ ] el log empieza cada bloque con '== AAAA-MM-DD HH:MM:SS comando =='
- [ ] bk-run enseña en pantalla la salida del comando
- [ ] la salida del comando queda en bk-run.log
- [ ] los errores del comando (stderr) también quedan en bk-run.log
- [ ] el log cierra cada bloque con '== código: N ==' y el código real
- [ ] bk-run sale con el mismo código que el comando
- [ ] si el comando falla, bk-run avisa en stderr con el código
- [ ] cada ejecución se añade al log sin borrar las anteriores
- [ ] con BK_LOG=otro.log, bk-run escribe en otro.log
- [ ] bk-info, bk-run y scaffold.sh sin TODOs, con set -euo pipefail y limpios para shellcheck
- [ ] docs/inventario.txt incluye ./bin/bk-run
- [ ] README.md sin TODOs, documenta bk-run y tiene la bitácora de la semana 03

## Calidad

Además de los checks, se revisa (40 pts, ver la rúbrica):

- Cada mensaje para la persona (uso, aviso de fallo) va a stderr; la salida del comando, a stdout.
- Los códigos de salida dicen la verdad: `2` para el mal uso, el del comando en lo demás.
- Comentarios que explican el porqué (por qué `"$@"` y no `$*`, por qué el `|| status=$?`), no el qué.
- Comillas dobles alrededor de `"$@"`, `"$log"` y `"$status"`.

## Entrega

Commit desde tu copia del repositorio con el mensaje `feat(week-03): bk-run` que incluya `starter/` completo. Comprueba con `git diff` que aparece `new mode 100755` para `bin/bk-run`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 07 — Modo estricto: set -euo pipefail](../2-practicas/lab-07-modo-estricto/README.md) | [Rúbrica de evaluación](../rubrica-evaluacion.md) → |

[↑ Semana 03](../README.md)
