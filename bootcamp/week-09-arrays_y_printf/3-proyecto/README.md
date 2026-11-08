# Proyecto Semana 09 — bashkit report: el log de bk-run en una tabla

⏱ Duración estimada: ~3 h 30 min

## Contexto

Desde la semana 03, `bk-run` guarda en `bk-run.log` cada comando que ejecutas, su salida y su código de salida. Después de unas semanas, ese log tiene cientos de bloques y nadie lo lee. Esta semana escribes **`bin/bk-report`**: lee el log, cuenta con **arrays asociativos** cuántas veces se ejecutó cada comando y cuántas falló, y lo enseña en una **tabla alineada con `printf`**. Como `bashkit` saca sus subcomandos de `bin/`, `bashkit report` funciona sin tocar el dispatcher ([docs/proyecto-hilo-conductor.md](../../../docs/proyecto-hilo-conductor.md)).

```text
$ bashkit report
COMANDO     VECES  BIEN FALLOS
./deploy.sh     2     1      1
df              2     2      0
ping            1     0      1
systemctl       1     1      0
TOTAL           6     4      2
```

## Estructura del proyecto

`starter/` es el `bashkit` con el que terminaste la semana 08, más lo nuevo:

```text
3-proyecto/
├── starter/                 ← aquí trabajas
│   ├── README.md            ← 2 TODOs: bk-report y la bitácora
│   ├── bin/
│   │   ├── bashkit
│   │   ├── bk-report        ← nuevo, sin permiso de ejecución, TODOs 1 a 7
│   │   └── bk-check, bk-clean, bk-info, bk-rename, bk-run, bk-top-ips
│   ├── lib/core.sh
│   └── docs/
│       └── inventario.txt   ← hay que regenerarlo
├── tests/
│   ├── bk-run.log           ← un log de bk-run de tres días
│   └── cortado.log          ← un log recortado, con un bloque a medias
└── solucion/
```

Así es un bloque del log, tal como lo escribe `bk-run`:

```text
== 2026-11-02 09:15:40 ./deploy.sh web-01 ==
desplegando web-01
error: no queda espacio en /var
== código: 1 ==
```

## Lo que debes construir

1. `bin/bk-report` con permisos `755`. Uso: `bk-report [log]`. Sin argumento, lee el log de `BK_LOG` o, si no existe esa variable, `bk-run.log` de la carpeta en la que estás (el mismo que escribe `bk-run`). Con más de un argumento, `die` con el uso y código `2`; con un log que no se puede leer, `die` con su nombre y código `1`.
2. Un contador por comando en tres arrays asociativos (`declare -A`): ejecuciones, las que salieron con `0` y las que no. El comando es la **primera palabra** de la línea `== fecha hora comando ==`: `df -h` y `df -h /var` cuentan como `df`. Un bloque solo cuenta cuando llega su `== código: N ==`.
3. Una tabla en stdout: la cabecera `COMANDO VECES BIEN FALLOS`, una fila por comando ordenada por nombre y una fila `TOTAL`. Todas las líneas miden lo mismo: la primera columna, lo que el nombre más largo (como poco, lo que `COMANDO`), y los números alineados a la derecha.
4. Un log recortado que empieza a mitad de un bloque no para el script. Un log vacío da la cabecera y `TOTAL 0 0 0`.
5. El kit sin TODOs y sin avisos de `shellcheck -x`; `docs/inventario.txt` regenerado y `README.md` sin TODOs.

## Paso a paso

### Paso 0 — Entrar al laboratorio

Desde la raíz del repositorio, en tu equipo:

```bash
docker compose run --rm lab
cd bootcamp/week-09-arrays_y_printf/3-proyecto/starter
```

(sin salida).

### Paso 1 — El esqueleto

Abre `bin/bk-report` en tu editor: carga `lib/core.sh`, lee el log línea a línea con un `while` y dos regex (las de la cabecera y el final de cada bloque), y tiene siete TODOs.

```bash
ls -l bin/bk-report
bin/bk-report; echo $?
```

Algo como (cambian la fecha y el tamaño):

```text
-rw-r--r-- 1 alumno alumno 1474 Nov  8 07:22 bin/bk-report
bash: bin/bk-report: Permission denied
126
```

Como el `bashkit` de la semana 08, llega sin `x`. Dáselo y prueba otra vez:

```bash
chmod +x bin/bk-report
bin/bk-report; echo $?
```

```text
bin/bk-report: line 29: bk-run.log: No such file or directory
1
```

En esta carpeta no hay `bk-run.log`, y el `< "$log"` del `while` falla con un mensaje de bash, no del kit.

### Paso 2 — TODO 1: qué log leer

Cambia los dos comentarios del `TODO 1` y la línea `log="bk-run.log"` por:

```bash
# Un log como mucho. Sin argumento, el mismo que usa bk-run: "bk-run ...; bk-report" cuadra.
[[ $# -le 1 ]] || die "uso: bk-report [log]" 2
log="${1:-${BK_LOG:-bk-run.log}}"
[[ -r $log ]] || die "no puedo leer '$log'"
```

`${1:-${BK_LOG:-bk-run.log}}` anida dos valores por defecto (semana 05): el argumento; si no hay, `BK_LOG`; si tampoco, `bk-run.log`. `-r` comprueba que el archivo existe y se puede leer. Prueba:

```bash
bin/bk-report no-existe.log; echo $?
bin/bk-report a.log b.log; echo $?
bin/bk-report ../tests/bk-run.log
```

```text
bk-report: no puedo leer 'no-existe.log'
1
bk-report: uso: bk-report [log]
2
bin/bk-report: line 37: declare: runs: not found
bin/bk-report: line 37: declare: ok: not found
bin/bk-report: line 37: declare: failed: not found
declare -- width="7"
```

La última línea del script, `declare -p`, enseña cómo está cada variable: así ves los contadores mientras los construyes. Los tres arrays todavía no existen.

### Paso 3 — TODO 2: los arrays asociativos

Un array normal usa números como índice. Prueba qué hace con nombres:

```bash
declare -a m; m[web]=1; m[db]=2; declare -p m
```

```text
declare -a m=([0]="2")
```

Dentro de `[ ]`, un array indexado hace una cuenta: `web` y `db` son variables que no existen y valen `0`. Las dos asignaciones van a la casilla `0`, y la segunda pisa la primera. `declare -A` crea un array **asociativo**, con textos como claves. Cambia el comentario del `TODO 2` por:

```bash
# Un contador por comando, con el nombre del comando como clave.
# Sin -A, bash tomaría cada clave como un número (0) y todos los comandos irían a la misma casilla.
declare -A runs=() ok=() failed=()
```

`=()` los crea vacíos. Prueba:

```bash
bin/bk-report ../tests/bk-run.log
```

```text
declare -A runs=()
declare -A ok=()
declare -A failed=()
declare -- width="7"
```

### Paso 4 — TODO 3: contar

Cuando una línea es `== código: N ==`, `BASH_REMATCH[1]` es el código y `cmd`, el comando del bloque. Cambia `: # TODO 3: ...` por:

```bash
    # Una asignación y no ((runs[$cmd]++)): eso vale 0 la primera vez y set -e pararía el script.
    runs[$cmd]=$((${runs[$cmd]:-0} + 1))
    total_runs=$((total_runs + 1))
    if [[ ${BASH_REMATCH[1]} == 0 ]]; then
      ok[$cmd]=$((${ok[$cmd]:-0} + 1))
      total_ok=$((total_ok + 1))
    else
      failed[$cmd]=$((${failed[$cmd]:-0} + 1))
      total_failed=$((total_failed + 1))
    fi
```

`${runs[$cmd]:-0}` es `0` para un comando que todavía no tiene casilla: sin el `:-0`, `set -u` pararía el script la primera vez. Prueba:

```bash
bin/bk-report ../tests/bk-run.log
```

```text
declare -A runs=(["ping -c 1 db-01"]="1" ["./deploy.sh web-01"]="2" ["df -h"]="1" ["df -h /var"]="1" ["systemctl restart nginx"]="1" )
declare -A ok=(["./deploy.sh web-01"]="1" ["df -h"]="1" ["df -h /var"]="1" ["systemctl restart nginx"]="1" )
declare -A failed=(["ping -c 1 db-01"]="1" ["./deploy.sh web-01"]="1" )
declare -- width="7"
```

Cuenta bien, pero `df -h` y `df -h /var` son dos claves: la clave es la línea entera. Fíjate también en el orden: las claves de un array asociativo salen en el orden que bash quiere, no en el que entraron.

### Paso 5 — TODO 4: la primera palabra

En la rama de la cabecera, cambia `cmd="${BASH_REMATCH[1]}" # TODO 4: ...` por:

```bash
    # Solo la primera palabra: "df -h" y "df -h /var" son el mismo comando.
    cmd="${BASH_REMATCH[1]%% *}"
```

`%% *` quita desde el primer espacio hasta el final (semana 05). Prueba:

```bash
bin/bk-report ../tests/bk-run.log
```

```text
declare -A runs=([df]="2" [systemctl]="1" [./deploy.sh]="2" [ping]="1" )
declare -A ok=([df]="2" [systemctl]="1" [./deploy.sh]="1" )
declare -A failed=([./deploy.sh]="1" [ping]="1" )
declare -- width="7"
```

Seis ejecuciones de cuatro comandos. `ping` no está en `ok` y `df`, en `failed`, tampoco: nunca se les sumó nada. Por eso, al leerlos, también va `:-0`.

### Paso 6 — TODO 5: el ancho de la primera columna

`"${!runs[@]}"` es la lista de **claves** (con `!`); `"${runs[@]}"`, la de valores. `${#name}` es el largo de un texto. Cambia el comentario del `TODO 5` por:

```bash
for name in "${!runs[@]}"; do
  if ((${#name} > width)); then
    width=${#name}
  fi
done
```

`width` empieza en `7`, lo que mide `COMANDO`: la cabecera tiene que caber. Prueba:

```bash
bin/bk-report ../tests/bk-run.log
```

```text
declare -A runs=([df]="2" [systemctl]="1" [./deploy.sh]="2" [ping]="1" )
declare -A ok=([df]="2" [systemctl]="1" [./deploy.sh]="1" )
declare -A failed=([./deploy.sh]="1" [ping]="1" )
declare -- width="11"
```

`./deploy.sh` tiene 11 caracteres.

### Paso 7 — TODO 6: la tabla

`printf` rellena con espacios hasta un ancho: `%-11s` a la izquierda, `%5s` a la derecha. Con `*`, el ancho llega como un argumento más, delante del texto. Borra el comentario del `TODO 6` y la línea `declare -p ...`, y escribe:

```bash
# Un solo formato para todas las filas: así la cabecera, los comandos y el total quedan alineados.
# %-*s toma el ancho del argumento anterior; %5s alinea los números a la derecha.
print_row() { printf '%-*s %5s %5s %6s\n' "$width" "$@"; }

print_row COMANDO VECES BIEN FALLOS
# Las claves de un array asociativo salen sin orden: se ordenan las filas ya escritas.
for name in "${!runs[@]}"; do
  print_row "$name" "${runs[$name]}" "${ok[$name]:-0}" "${failed[$name]:-0}"
done | LC_ALL=C sort
print_row TOTAL "$total_runs" "$total_ok" "$total_failed"
```

`LC_ALL=C` hace que `sort` compare byte a byte, igual en cualquier máquina. Ordenar las filas es ordenar por nombre: los espacios del relleno van antes que cualquier letra. Prueba también con un log vacío:

```bash
bin/bk-report ../tests/bk-run.log
: > vacio.log
bin/bk-report vacio.log
rm vacio.log
```

```text
COMANDO     VECES  BIEN FALLOS
./deploy.sh     2     1      1
df              2     2      0
ping            1     0      1
systemctl       1     1      0
TOTAL           6     4      2
COMANDO VECES  BIEN FALLOS
TOTAL       0     0      0
```

`: > vacio.log` crea un archivo vacío (`:` no imprime nada). Con un array vacío, el `for` no da ninguna vuelta.

### Paso 8 — TODO 7: un log recortado

Cuando un log crece, se recorta por arriba, y puede empezar a mitad de un bloque. `tests/cortado.log` es así, y además tiene un `tar` que se cortó con Ctrl+C antes de su `== código`:

```bash
head -n 3 ../tests/cortado.log
bin/bk-report ../tests/cortado.log; echo $?
```

```text
desplegando web-02
== código: 0 ==
== 2026-11-05 12:00:00 tar -czf copia.tgz datos ==
bin/bk-report: line 32: runs: bad array subscript
1
```

El primer `== código` llega con `cmd` vacío, y `runs[""]` no es una clave válida. Cambia el comentario del `TODO 7` y la línea `elif [[ $line =~ $footer_re ]]; then` de debajo por:

```bash
  # -n $cmd: un log recortado puede empezar a mitad de un bloque, con un "== código" sin
  # comando; runs[""] pararía el script con "bad array subscript".
  elif [[ $line =~ $footer_re && -n $cmd ]]; then
```

Prueba:

```bash
bin/bk-report ../tests/cortado.log; echo $?
```

```text
COMANDO VECES  BIEN FALLOS
ls          1     1      0
TOTAL       1     1      0
0
```

El `tar` no cuenta: la cabecera del `ls` cambió `cmd` antes de que llegara un `== código`.

### Paso 9 — Con `bk-run` y `bashkit`

```bash
bin/bk-run ls bin > /dev/null
bin/bk-run ls no-existe > /dev/null
bin/bk-run ls bin > /dev/null
bin/bashkit report
bin/bashkit help
rm bk-run.log
```

```text
bk-run: 'ls no-existe' salió con código 2
COMANDO VECES  BIEN FALLOS
ls          3     2      1
TOTAL       3     2      1
uso: bashkit <subcomando> [argumentos...]
subcomandos:
  check
  clean
  info
  rename
  report
  run
  top-ips
```

Sin argumento ni `BK_LOG`, `bk-report` lee el mismo `bk-run.log` que escribió `bk-run`. `report` aparece en `bashkit help` sin cambiar `bashkit`: basta con que exista `bin/bk-report` y sea ejecutable. Con otro log y desde otra carpeta:

```bash
PATH="$PWD/bin:$PATH"
cd /tmp
BK_LOG=deploy.log bk-run echo listo
bashkit report deploy.log
rm deploy.log
cd -
```

```text
listo
COMANDO VECES  BIEN FALLOS
echo        1     1      0
TOTAL       1     1      0
/bc-bash/bootcamp/week-09-arrays_y_printf/3-proyecto/starter
```

`cd -` vuelve a la carpeta anterior e imprime cuál es.

### Paso 10 — shellcheck

```bash
shellcheck -x bin/bk-report; echo $?
```

```text
0
```

### Paso 11 — El inventario al día

```bash
find . -type f > docs/inventario.txt
grep report docs/inventario.txt
```

```text
./bin/bk-report
```

### Paso 12 — README del kit

```bash
grep -n TODO README.md
```

```text
29:| `bin/bk-report` | TODO: qué resume `bk-report`, qué columnas tiene la tabla y qué log lee si no le dices ninguno |
49:- Semana 09: TODO: qué aprendiste y qué te costó.
```

Abre `README.md` en tu editor y sustituye cada `TODO` con tus palabras: qué resume `bk-report`, sus columnas, qué log lee por defecto (un ejemplo con `bashkit report`) y la bitácora de la semana (la línea tiene que empezar por `- Semana 09:`). Repite el `grep` hasta que no imprima nada.

### Paso 13 — Autograding

```bash
cd "$(git rev-parse --show-toplevel)" && ./scripts/verificar-semana.sh 09
```

Con todo hecho:

```text
Semana 09 — Arrays y printf

  ✅ bin/bk-report existe, tiene permiso de ejecución y empieza por el shebang del kit
  ✅ bk-report carga lib/core.sh, avisa con die y cuenta con arrays asociativos (declare -A)
  ...
  ✅ README.md sin TODOs, documenta bk-report y tiene la bitácora de la semana 09

15/15 comprobaciones superadas.
```

Cada ❌ trae una pista con el paso donde se arregla. Para salir del laboratorio: `exit`.

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 09` desde la raíz del repositorio (60 de los 100 puntos del Producto, 4 por comprobación). Los otros 40 son de calidad: ver la [rúbrica](../rubrica-evaluacion.md#-producto-30).

- [ ] bin/bk-report existe, tiene permiso de ejecución y empieza por el shebang del kit
- [ ] bk-report carga lib/core.sh, avisa con die y cuenta con arrays asociativos (declare -A)
- [ ] con un log que no se puede leer, avisa en stderr con su nombre y sale con código 1
- [ ] con más de un argumento, escribe el uso en stderr y sale con código 2
- [ ] la primera línea es la cabecera COMANDO VECES BIEN FALLOS
- [ ] una fila por comando (su primera palabra), ordenadas por nombre, con sus ejecuciones, las que salieron bien y las que fallaron, y una fila TOTAL
- [ ] todas las líneas de la tabla miden lo mismo: la primera columna mide lo que el nombre más largo y los números van alineados
- [ ] con un nombre de comando largo, la primera columna se ensancha y la tabla sigue alineada
- [ ] con un log vacío, solo la cabecera y TOTAL 0 0 0, y código 0
- [ ] un log recortado que empieza a mitad de un bloque, o con un bloque sin su línea de código (bk-run cortado), no rompe la cuenta
- [ ] bashkit report resume el log que escribe bk-run, el que dice BK_LOG
- [ ] sin argumento ni BK_LOG, lee bk-run.log de la carpeta en la que estás, como bk-run
- [ ] el kit sin TODOs y limpio para shellcheck -x
- [ ] docs/inventario.txt incluye ./bin/bk-report
- [ ] README.md sin TODOs, documenta bk-report y tiene la bitácora de la semana 09

## Calidad

Además de los checks, se revisa (40 pts, ver la rúbrica):

- `declare -A` para lo que se busca por nombre; `"${arr[@]}"` y `"${!arr[@]}"` siempre entre comillas.
- Contadores que no dependen de `((x++))` con `set -e`, y lecturas con `:-0` para las claves que faltan.
- Un solo formato de `printf` para toda la tabla, en una cadena fija: nunca un dato dentro del formato.
- Avisos a stderr con `die`; `2` para un uso mal hecho; la tabla, a stdout.
- Comentarios que explican el porqué: por qué `-A`, por qué el `sort`, por qué `-n $cmd`.

## Entrega

Commit desde tu copia del repositorio con el mensaje `feat(week-09): bashkit report` que incluya `starter/` completo. Comprueba con `git diff` que aparece `new mode 100755` para `bin/bk-report`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 07 — Tablas rotas](../2-practicas/lab-07-tablas-rotas/README.md) | [Rúbrica de evaluación](../rubrica-evaluacion.md) → |

[↑ Semana 09](../README.md)
