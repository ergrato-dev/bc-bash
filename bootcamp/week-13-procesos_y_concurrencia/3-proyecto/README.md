# Proyecto Semana 13 — `bashkit healthcheck`: comprobaciones en paralelo

⏱ Duración estimada: ~3 h 30 min

## Contexto

Entras en una máquina y quieres saber si está sana: si queda disco, si `/tmp` se puede escribir, si responde una URL. Son comprobaciones cortas, pero una sola colgada (una URL que no contesta) puede dejarte esperando un minuto. Esta semana `bashkit` aprende a lanzarlas todas a la vez, con lo que viste en los labs:

- **trabajos en segundo plano con `&`**, su pid en `$!` y su código con `wait <pid>` (lab 01);
- **un límite de trabajos a la vez** con `jobs -rp` y `wait -n` (lab 02);
- **`timeout`**, para que una comprobación colgada no pare el resto (lab 02);
- **`trap` y `kill`**, para que un Ctrl-C o un `kill` no dejen hijos huérfanos (lab 06);
- **cron**, para que el kit se ejecute solo cada 5 minutos (lab 07).

## Estructura del proyecto

`starter/` es el `bashkit` con el que terminaste la semana 12, con TODOs en tres archivos:

```text
3-proyecto/
├── starter/                      ← aquí trabajas
│   ├── README.md                 ← 3 TODOs: bk-healthcheck, la línea de cron y la bitácora
│   ├── healthcheck.conf          ← nuevo: las comprobaciones de esta máquina (ya hecho)
│   ├── bin/
│   │   ├── bk-healthcheck        ← nuevo, sin bit de ejecución: TODOs 1 a 5
│   │   └── bashkit, bk-check, bk-clean, bk-info, bk-lint, bk-logs, bk-rename, bk-report, bk-run, bk-top-ips
│   ├── lib/core.sh
│   ├── tests/
│   │   ├── bk-healthcheck.bats   ← TODO 6
│   │   └── test_helper.bash, bashkit.bats, bk-check.bats, bk-report.bats, bk-run.bats
│   └── docs/
│       └── inventario.txt        ← hay que regenerarlo
└── solucion/
```

## Lo que debes construir

1. `bk-healthcheck [-j trabajos] [-t segundos] [archivo]` lee un archivo con una comprobación por línea (`nombre comando`), sin contar las vacías ni los comentarios. Sin archivo, usa el `healthcheck.conf` de la raíz del kit.
2. Lanza las comprobaciones en segundo plano, nunca más de `-j` a la vez (4 si no dices otro número), y corta la que tarde más de `-t` segundos (10).
3. Escribe `ok    nombre` o `FAIL  nombre (código N)` en el orden del archivo, con las últimas líneas del error debajo de cada fallo. Resume en stderr y sale con `0` si todo va bien, `1` si algo falla y `2` con un error de uso.
4. Con Ctrl-C o un `kill`, para también las comprobaciones que siguen en marcha y no deja archivos temporales.
5. Tres tests o más en `tests/bk-healthcheck.bats`; el kit pasa `bk-lint` y `bats tests`; sin TODOs; el `README.md` con la línea de cron.

## Paso a paso

### Paso 0 — Entrar al laboratorio

Desde la raíz del repositorio, en tu equipo:

```bash
docker compose run --rm lab
cd bootcamp/week-13-procesos_y_concurrencia/3-proyecto/starter
```

(sin salida).

### Paso 1 — Lo que ya hay

Los tests de la semana 12 pasan (`bk-healthcheck.bats` todavía no tiene ninguno). `bin/bk-healthcheck` es nuevo y no tiene el bit de ejecución: `chmod +x` se lo da.

```bash
bats tests
```

```text
...
 ✓ una opción desconocida sale con código 2

19 tests, 0 failures
```

```bash
ls -l bin/bk-healthcheck
chmod +x bin/bk-healthcheck
bin/bk-healthcheck; echo "código: $?"
```

```text
-rw-r--r-- 1 alumno alumno 2187 Nov 10 02:20 bin/bk-healthcheck
bk-healthcheck: '/bc-bash/bootcamp/week-13-procesos_y_concurrencia/3-proyecto/starter/bin/../healthcheck.conf' no tiene comprobaciones
código: 2
```

La fecha cambia. Abre `bin/bk-healthcheck` en tu editor: la cabecera, las variables y el resumen final ya están; los TODOs son lo que falta en medio. Sin argumentos busca `healthcheck.conf` junto a `bin/`, y como todavía no lee el archivo (TODO 2), no encuentra ninguna comprobación.

### Paso 2 — TODO 1: las opciones

Igual que `bk-lint` en la semana 12, con dos novedades: `-j` y `-t` llevan un valor (los `:` detrás de `j` y `t` en `":j:t:h"`, y el valor llega en `$OPTARG`), y el caso `:)` es el de una opción a la que le falta ese valor. Cambia el comentario del `TODO(semana 13) 1` por:

```bash
while getopts ":j:t:h" opt; do
  case "$opt" in
    j) max_jobs="$OPTARG" ;;
    t) time_limit="$OPTARG" ;;
    h)
      echo "$usage"
      exit 0
      ;;
    :) die "a -$OPTARG le falta el valor ($usage)" 2 ;;
    *) die "opción desconocida: -$OPTARG ($usage)" 2 ;;
  esac
done
shift $((OPTIND - 1))

[[ $max_jobs =~ ^[1-9][0-9]*$ ]] || die "-j necesita un número mayor que 0, no '$max_jobs'" 2
[[ $time_limit =~ ^[1-9][0-9]*$ ]] || die "-t necesita un número mayor que 0, no '$time_limit'" 2
```

`^[1-9][0-9]*$` acepta `1`, `4` o `20`, y no `0`, `-3` ni `dos`: con `-j 0` no lanzaría nada nunca.

```bash
bin/bk-healthcheck -h; echo "código: $?"
bin/bk-healthcheck -j 0; echo "código: $?"
bin/bk-healthcheck -t; echo "código: $?"
bin/bk-healthcheck -x; echo "código: $?"
```

```text
uso: bk-healthcheck [-j trabajos] [-t segundos] [archivo]
código: 0
bk-healthcheck: -j necesita un número mayor que 0, no '0'
código: 2
bk-healthcheck: a -t le falta el valor (uso: bk-healthcheck [-j trabajos] [-t segundos] [archivo])
código: 2
bk-healthcheck: opción desconocida: -x (uso: bk-healthcheck [-j trabajos] [-t segundos] [archivo])
código: 2
```

### Paso 3 — TODO 2: leer las comprobaciones

Mira el archivo que vas a leer:

```bash
cat healthcheck.conf
```

```text
# Comprobaciones de bk-healthcheck: una por línea, "nombre comando".
# El comando se ejecuta con bash -c; sale con 0 si todo está bien.
disco     [[ $(df --output=pcent / | tail -n 1 | tr -dc 0-9) -lt 90 ]]
tmp       [[ -w /tmp ]]
localhost getent hosts localhost
shell     bash --version
```

`disco` sale bien si el disco está por debajo del 90 %; `tmp`, si puedes escribir en `/tmp`; `localhost`, si el nombre se resuelve. El nombre es la primera palabra y el comando, el resto. `read -r name command` hace justo eso: la primera palabra va a `name` y todo lo demás, espacios incluidos, a la última variable:

```bash
read -r name command <<< "disco   df -h /tmp"; echo "[$name] [$command]"
```

```text
[disco] [df -h /tmp]
```

Cambia el comentario del `TODO(semana 13) 2` por:

```bash
line_number=0
while IFS= read -r line || [[ -n $line ]]; do
  line_number=$((line_number + 1))
  [[ $line =~ ^[[:space:]]*(#|$) ]] && continue
  read -r name command <<< "$line"
  [[ -n $command ]] || die "$file, línea $line_number: falta el comando de '$name'" 2
  names+=("$name")
  commands+=("$command")
done < "$file"
```

`|| [[ -n $line ]]` lee también la última línea si no termina en salto de línea (semana 07). La regex salta las líneas vacías, las de solo espacios y las que empiezan por `#`. Prueba con el archivo del kit, con uno que tiene una línea sin comando y con uno que no existe:

```bash
bin/bk-healthcheck; echo "código: $?"
printf '# web y disco\nweb\ndisco df /\n' > malo.conf
bin/bk-healthcheck malo.conf; echo "código: $?"
bin/bk-healthcheck no-existe.conf; echo "código: $?"
rm malo.conf
```

```text
bk-healthcheck: 4 comprobaciones, todas bien
código: 0
bk-healthcheck: malo.conf, línea 2: falta el comando de 'web'
código: 2
bk-healthcheck: no puedo leer 'no-existe.conf'
código: 2
```

"Todas bien" es mentira de momento: todavía no ejecuta nada. Pero ya cuenta 4 y para antes de empezar si el archivo está mal.

### Paso 4 — TODO 3: lanzar en segundo plano y recoger los códigos

Cada comprobación se lanza con `&` y su pid, que está en `$!`, se guarda en `pids` con el mismo número que su nombre. Su salida va a un archivo de `out_dir` (la carpeta de `mktemp -d`), para que no se mezcle con las otras. Cambia el comentario del `TODO(semana 13) 3 y 4` (debajo de `pids=()`) por:

```bash
for i in "${!names[@]}"; do
  # bash -c: el comando del archivo puede llevar pipes y [[ ]]. El archivo es tuyo y el
  # comando se ejecuta como tú: no uses un healthcheck.conf que no hayas escrito.
  # < /dev/null: una comprobación que lee el teclado no se queda esperando.
  bash -c "${commands[i]}" > "$out_dir/$i" 2>&1 < /dev/null &
  pids[i]=$!
done
```

`"${!names[@]}"` (con `!`) da los números de las posiciones: `0 1 2 3`. Ahora el informe. `wait <pid>` espera a ese trabajo y sale con su código, aunque haya terminado hace rato. Como se recorren en el orden del archivo, el informe sale en ese orden aunque terminen en otro. Cambia el comentario del `TODO(semana 13) 3:` (debajo de `failed=0`) por:

```bash
for i in "${!names[@]}"; do
  code=0
  wait "${pids[i]}" || code=$?
  if ((code == 0)); then
    printf 'ok    %s\n' "${names[i]}"
    continue
  fi
  printf 'FAIL  %s (código %s)\n' "${names[i]}" "$code"
  failed=$((failed + 1))
  # Las últimas líneas de lo que escribió, sangradas: suelen decir por qué falló.
  tail -n 3 "$out_dir/$i" | sed 's/^/      /'
done
```

`|| code=$?` guarda el código sin que `set -e` pare el script por un `wait` que sale con 1. Prueba con el archivo del kit y con uno que tiene una comprobación lenta, dos que fallan y una con un pipe. `time` (semana 12) dice cuánto tarda:

```bash
bin/bk-healthcheck; echo "código: $?"
printf 'lenta sleep 2\nmal ls /no-existe\nrapida true\npipe echo hola | grep -q adios\n' > prueba.conf
time bin/bk-healthcheck prueba.conf; echo "código: $?"
```

```text
ok    disco
ok    tmp
ok    localhost
ok    shell
bk-healthcheck: 4 comprobaciones, todas bien
código: 0
ok    lenta
FAIL  mal (código 2)
      ls: cannot access '/no-existe': No such file or directory
ok    rapida
FAIL  pipe (código 1)
bk-healthcheck: 4 comprobaciones, 2 con fallos

real	0m2.012s
user	0m0.004s
sys	0m0.010s
código: 1
```

Los tiempos cambian un poco. 2 segundos: lo que tarda la más lenta, no la suma. `rapida` terminó antes que `lenta`, pero sale después, en el orden del archivo. `pipe` no escribe nada al fallar (`grep -q` es callado): solo el código.

### Paso 5 — TODO 4: como mucho N a la vez, y con límite de tiempo

Ahora mismo, con 6 comprobaciones de 1 segundo:

```bash
printf 'a sleep 1\nb sleep 1\nc sleep 1\nd sleep 1\ne sleep 1\nf sleep 1\n' > seis.conf
time bin/bk-healthcheck seis.conf
```

```text
ok    a
ok    b
ok    c
ok    d
ok    e
ok    f
bk-healthcheck: 6 comprobaciones, todas bien

real	0m1.009s
user	0m0.012s
sys	0m0.008s
```

Todas a la vez. Con 6 da igual; con 300 que abren una conexión cada una, la máquina que vigilas se lleva un susto. Dos piezas del lab 02:

- `jobs -rp`: los pids de los trabajos que siguen en marcha (`-r`, *running*), uno por línea. `| wc -l` los cuenta.
- `wait -n`: espera a que termine uno cualquiera. Sirve para dejar sitio, no para saber cuál ni su código: en bash 5.2, un trabajo que terminó mientras el script hacía otra cosa no lo ve (lo comprobaste en el lab 02). Los códigos ya los recoge `wait <pid>` en el informe.

Y `timeout segundos comando` (lab 02) para el comando si tarda más, y entonces sale con `124`. En el bucle que lanza, añade el `while` al principio y `timeout "$time_limit"` delante de `bash -c`. Pon también el comentario encima de `pids=()`. Queda así:

```bash
# Lanzar cada comprobación en segundo plano, sin pasar de max_jobs a la vez.
# jobs -rp cuenta las que siguen en marcha; wait -n espera a que acabe alguna para dejar sitio.
# El código de cada una se recoge después con wait <pid>: en bash 5.2, wait -n no ve un
# trabajo que terminó mientras el script hacía otra cosa, y wait <pid> sí lo guarda.
pids=()
for i in "${!names[@]}"; do
  while (($(jobs -rp | wc -l) >= max_jobs)); do
    wait -n || true
  done
  # bash -c: el comando del archivo puede llevar pipes y [[ ]]. El archivo es tuyo y el
  # comando se ejecuta como tú: no uses un healthcheck.conf que no hayas escrito.
  # < /dev/null: una comprobación que lee el teclado no se queda esperando.
  timeout "$time_limit" bash -c "${commands[i]}" > "$out_dir/$i" 2>&1 < /dev/null &
  pids[i]=$!
done
```

`wait -n || true`: `wait -n` sale con el código del trabajo que terminó, y uno que falla no debe parar el script. En el informe, el `if` se queda corto: hay tres casos (bien, tiempo agotado, otro fallo). Cambia el `if ... fi` y el `printf 'FAIL ...` que lo sigue por un `case` (semana 06):

```bash
  case "$code" in
    0)
      printf 'ok    %s\n' "${names[i]}"
      continue
      ;;
    124) printf 'FAIL  %s (tiempo agotado: %s s)\n' "${names[i]}" "$time_limit" ;;
    *) printf 'FAIL  %s (código %s)\n' "${names[i]}" "$code" ;;
  esac
```

El resto del bucle (`failed=...` y el `tail`) sigue igual. Prueba los seis con el límite de siempre (4) y con 2, y una comprobación colgada con 2 segundos de límite:

```bash
time bin/bk-healthcheck seis.conf | tail -n 1
time bin/bk-healthcheck -j 2 seis.conf > /dev/null
printf 'colgada sleep 30\nbien true\n' > colgada.conf
time bin/bk-healthcheck -t 2 colgada.conf; echo "código: $?"
```

```text
bk-healthcheck: 6 comprobaciones, todas bien
ok    f

real	0m2.019s
user	0m0.024s
sys	0m0.011s
bk-healthcheck: 6 comprobaciones, todas bien

real	0m3.027s
user	0m0.033s
sys	0m0.012s
FAIL  colgada (tiempo agotado: 2 s)
ok    bien
bk-healthcheck: 2 comprobaciones, 1 con fallos

real	0m2.011s
user	0m0.010s
sys	0m0.001s
código: 1
```

4 a la vez: dos tandas, 2 segundos. 2 a la vez: tres tandas, 3 segundos. Y `colgada` ya no te tiene 30 segundos esperando. (El resumen sale antes que `ok    f` porque va a stderr, que no pasa por el `tail`.)

### Paso 6 — TODO 5: que un Ctrl-C no deje huérfanos

Lanza `colgada.conf` en segundo plano con 60 segundos de límite y mátalo con `kill %1` (`%1` es el trabajo 1 de tu shell, lab 01):

```bash
bin/bk-healthcheck -t 60 colgada.conf &
sleep 1
kill %1
sleep 0.5
pgrep -a sleep
ls -d /tmp/tmp.*
```

```text
[1] 15
[1]+  Terminated              bin/bk-healthcheck -t 60 colgada.conf
27 sleep 30
/tmp/tmp.8fAJDeh26h
```

Los números y el nombre de la carpeta cambian, y seguramente te salen más carpetas: las de los pasos 4 y 5, que hasta ahora nadie borra. `bk-healthcheck` ha muerto, pero su `sleep 30` sigue vivo (`pgrep -a` busca procesos por nombre y enseña su comando) y la carpeta de `mktemp` se ha quedado. La señal llega al proceso al que se la mandas, no a sus hijos. Con Ctrl-C pasa lo mismo: `timeout` pone a su comando en un grupo de procesos propio, y el Ctrl-C de la terminal solo llega al grupo de `bk-healthcheck`. Limpia a mano lo que quedó:

```bash
pkill -x sleep; rm -r /tmp/tmp.*
```

(sin salida). Cambia el comentario del `TODO(semana 13) 5` por:

```bash
# Al salir, por lo que sea: parar las comprobaciones que sigan en marcha y borrar sus salidas.
# Sin el kill, un Ctrl-C o un kill a bk-healthcheck dejaría vivos a sus hijos: la señal
# llega a este proceso, no a los que lanzó. A timeout le basta: reenvía la señal a su comando.
cleanup() {
  local pids
  pids="$(jobs -rp)"
  if [[ -n $pids ]]; then
    # Sin comillas a propósito: un pid por palabra, para que kill reciba cada uno aparte.
    # shellcheck disable=SC2086
    kill $pids 2> /dev/null || true
    wait || true
  fi
  rm -rf "$out_dir"
}
trap cleanup EXIT
# exit dentro del trap hace que corra el de EXIT; 130 y 143 = 128 + el número de la señal.
trap 'exit 130' INT
trap 'exit 143' TERM
```

`wait` sin argumentos espera a todos los hijos: así no se borra `out_dir` mientras un `timeout` todavía escribe en él. Repite la prueba:

```bash
bin/bk-healthcheck -t 60 colgada.conf &
sleep 1
kill %1
sleep 0.5
pgrep -a sleep; echo "código: $?"
ls -d /tmp/tmp.*
```

```text
[1] 15
[1]+  Exit 143                bin/bk-healthcheck -t 60 colgada.conf
código: 1
ls: cannot access '/tmp/tmp.*': No such file or directory
```

`pgrep` no encuentra ningún `sleep` (sale con `1`) y no queda ninguna carpeta temporal. `Exit 143`: 128 + 15, el número de `TERM`. Prueba tú también con Ctrl-C: `bin/bk-healthcheck -t 60 colgada.conf`, Ctrl-C, y `echo $?` dice `130`.

### Paso 7 — Que lo lance cron

cron ejecuta las líneas de tu *crontab* a la hora que dicen, sin terminal y con un entorno casi vacío (lab 07): empieza en tu home, con `PATH=/usr/bin:/bin` y sin tus variables. `env -i` lanza un comando con el entorno vacío, y así puedes probar lo que vería cron sin esperar. `kit="$PWD"` guarda la ruta del kit:

```bash
kit="$PWD"
env -i PATH=/usr/bin:/bin HOME="$HOME" sh -c "cd && bin/bk-healthcheck"; echo "código: $?"
env -i PATH=/usr/bin:/bin HOME="$HOME" sh -c "cd && $kit/bin/bk-healthcheck"; echo "código: $?"
```

```text
sh: 1: bin/bk-healthcheck: not found
código: 127
ok    disco
ok    tmp
ok    localhost
ok    shell
bk-healthcheck: 4 comprobaciones, todas bien
código: 0
```

Desde el home, la ruta relativa no existe: en cron, rutas enteras. Y como `bk-healthcheck` busca `healthcheck.conf` junto a `bin/` y no en la carpeta actual, lo encuentra. Ahora la línea de cron: cinco campos de tiempo (minuto, hora, día del mes, mes y día de la semana) y el comando. `*/5` en el minuto es "cada 5 minutos". `crontab -` instala lo que le llega por stdin, y `crontab -l` lo enseña:

```bash
crontab -l; echo "código: $?"
echo "*/5 * * * * $kit/bin/bk-healthcheck >> $kit/healthcheck.log 2>&1" | crontab -
crontab -l
```

```text
no crontab for alumno
código: 1
*/5 * * * * /bc-bash/bootcamp/week-13-procesos_y_concurrencia/3-proyecto/starter/bin/bk-healthcheck >> /bc-bash/bootcamp/week-13-procesos_y_concurrencia/3-proyecto/starter/healthcheck.log 2>&1
```

`>> ... 2>&1` guarda la salida y los avisos en un log: cron no tiene terminal donde enseñarlos. `crontab -` reemplaza el crontab entero: en tu equipo usa `crontab -e`, que lo abre en un editor. En el laboratorio no corre el servicio de cron, así que no se ejecutará; en un servidor, sí. `crontab` comprueba la línea antes de instalarla:

```bash
echo "5 * * *" | crontab -; echo "código: $?"
crontab -r; crontab -l; echo "código: $?"
```

```text
"-":1: bad day-of-week
errors in crontab file, can't install.
código: 1
no crontab for alumno
código: 1
```

`crontab -r` lo borra. Apunta la línea: va al README en el paso 10.

### Paso 8 — TODO 6: los tests de `bk-healthcheck`

Abre `tests/bk-healthcheck.bats` y cambia el comentario del `TODO(semana 13) 6` por tres tests o más. Cada test escribe su propio `checks.conf` en su carpeta temporal (el `setup` de `test_helper.bash` ya entra en ella). Estos son los de la solución; el cuarto mide el tiempo con `$EPOCHREALTIME`, la hora en microsegundos:

```bash
@test "con todo bien, una línea ok por comprobación, en el orden del archivo, y código 0" {
  # La primera tarda más: si el informe fuera en el orden en que terminan, saldría segunda.
  printf '# comentario\nlenta sleep 0.5\n\nrapida true\n' > checks.conf
  run --separate-stderr bk-healthcheck checks.conf
  [[ $status -eq 0 ]]
  [[ $output == $'ok    lenta\nok    rapida' ]]
  [[ $stderr == "bk-healthcheck: 2 comprobaciones, todas bien" ]]
}

@test "una comprobación que falla sale como FAIL con su código y su error, y el código es 1" {
  printf 'bien true\nmal ls /no-existe\n' > checks.conf
  run -1 bk-healthcheck checks.conf
  [[ ${lines[1]} == "FAIL  mal (código 2)" ]]
  [[ ${lines[2]} == *"/no-existe"* ]]
}

@test "-t corta una comprobación colgada y lo dice" {
  printf 'colgada sleep 30\n' > checks.conf
  run -1 bk-healthcheck -t 1 checks.conf
  [[ ${lines[0]} == "FAIL  colgada (tiempo agotado: 1 s)" ]]
}

@test "las comprobaciones van a la vez: cuatro de 1 s tardan menos de 2 s" {
  printf 'a sleep 1\nb sleep 1\nc sleep 1\nd sleep 1\n' > checks.conf
  # EPOCHREALTIME es la hora en microsegundos (1731000000.123456): sin el punto, se resta.
  local start="${EPOCHREALTIME/./}"
  run -0 bk-healthcheck -j 4 checks.conf
  (((${EPOCHREALTIME/./} - start) < 2000000))
}

@test "una línea sin comando para antes de empezar, con código 2" {
  printf 'bien true\nsolo-nombre\n' > checks.conf
  run -2 bk-healthcheck checks.conf
  [[ $output == "bk-healthcheck: checks.conf, línea 2: falta el comando de 'solo-nombre'" ]]
}
```

`$'...'` (semana 05) escribe el salto de línea `\n` dentro de la cadena. Pásalos:

```bash
bats tests/bk-healthcheck.bats
bats tests
```

```text
bk-healthcheck.bats
 ✓ con todo bien, una línea ok por comprobación, en el orden del archivo, y código 0
 ✓ una comprobación que falla sale como FAIL con su código y su error, y el código es 1
 ✓ -t corta una comprobación colgada y lo dice
 ✓ las comprobaciones van a la vez: cuatro de 1 s tardan menos de 2 s
 ✓ una línea sin comando para antes de empezar, con código 2

5 tests, 0 failures
...
24 tests, 0 failures
```

¿Sirven? Rómpelo en una copia (semana 12): primero, que dé por buena cualquier comprobación (`|| true` en lugar de `|| code=$?`); después, que lance de una en una (`>= 1` en lugar de `>= max_jobs`). Con un pipe, bats escribe en formato TAP: `not ok` es un test que falla.

```bash
copia="$(mktemp -d)"; cp -r . "$copia"
sed -i 's/ || code=$?$/ || true/' "$copia/bin/bk-healthcheck"
bats "$copia/tests/bk-healthcheck.bats" | grep "^not ok"
cp bin/bk-healthcheck "$copia/bin/"
sed -i 's/>= max_jobs)); do/>= 1)); do/' "$copia/bin/bk-healthcheck"
bats "$copia/tests/bk-healthcheck.bats" | grep "^not ok"
rm -r "$copia"
```

```text
not ok 2 una comprobación que falla sale como FAIL con su código y su error, y el código es 1
not ok 3 -t corta una comprobación colgada y lo dice
not ok 4 las comprobaciones van a la vez: cuatro de 1 s tardan menos de 2 s
```

Cada rotura la pilla algún test. El autograding hace lo mismo.

### Paso 9 — Limpieza, lint e inventario

```bash
rm prueba.conf seis.conf colgada.conf
bin/bk-lint; echo "código: $?"
grep -rn TODO bin lib tests scaffold.sh healthcheck.conf; echo "código: $?"
find . -type f > docs/inventario.txt
grep health docs/inventario.txt
```

```text
bk-lint: archivos revisados: 13, sin avisos
código: 0
código: 1
./healthcheck.conf
./tests/bk-healthcheck.bats
./bin/bk-healthcheck
```

`grep` sale con `1`: no queda ningún TODO en el código. (El orden de `find` puede cambiar en tu equipo.)

### Paso 10 — README del kit

Abre `README.md` (el de `starter/`) en tu editor y cambia los tres TODOs:

- la fila de `bin/bk-healthcheck`: qué hace, qué archivo lee y qué cambian `-j` y `-t`;
- la frase de cron: la línea del paso 7, en un bloque de código, con la ruta donde tengas el kit (por ejemplo `*/5 * * * * $HOME/bashkit/bin/bk-healthcheck >> $HOME/bashkit/healthcheck.log 2>&1`);
- `- Semana 13: TODO`: qué aprendiste y qué te costó.

```bash
grep -n TODO README.md; echo "código: $?"
```

```text
código: 1
```

### Paso 11 — Autograding

```bash
cd "$(git rev-parse --show-toplevel)" && ./scripts/verificar-semana.sh 13
```

```text
Semana 13 — Procesos y concurrencia

  ✅ bashkit healthcheck -h enseña el uso con código 0; -j 0 avisa y sale con código 2
  ✅ un archivo que no existe y una línea sin comando avisan y salen con código 2
  ✅ con todo bien: una línea ok por comprobación, sin contar comentarios ni líneas vacías, el resumen a stderr y código 0
  ✅ una comprobación que falla sale como FAIL con su código y su error, y bk-healthcheck sale con 1
  ✅ el informe sigue el orden del archivo, no el orden en que terminan
  ✅ sin -j van 4 a la vez: cuatro comprobaciones de 1 s tardan menos de 2 s
  ✅ con -j 2 nunca van más de dos a la vez: cuatro de 1 s tardan entre 2 y 3 s
  ✅ -t corta una comprobación colgada y dice que se le acabó el tiempo
  ✅ un kill a bk-healthcheck para también sus comprobaciones y borra su carpeta temporal; sale con 143
  ✅ lanzado como lo haría cron (otra carpeta, entorno vacío, PATH mínimo) usa el healthcheck.conf del kit y sale con 0
  ✅ bats tests pasa entero, con 3 tests o más de bk-healthcheck
  ✅ los tests de bk-healthcheck fallan si da por buena una comprobación que falla
  ✅ los tests de bk-healthcheck fallan si las comprobaciones van una detrás de otra
  ✅ el kit pasa bk-lint (shellcheck y shfmt) y no le quedan TODOs
  ✅ README.md sin TODOs, documenta bk-healthcheck con -j y -t, la línea de cron y la bitácora de la semana 13

15/15 comprobaciones superadas.
```

Cada ❌ trae una pista con el paso donde se arregla. Para salir del laboratorio: `exit`.

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 13` desde la raíz del repositorio (60 de los 100 puntos del Producto, 4 por comprobación). Los otros 40 son de calidad: ver la [rúbrica](../rubrica-evaluacion.md#-producto-30).

- [ ] bashkit healthcheck -h enseña el uso con código 0; -j 0 avisa y sale con código 2
- [ ] un archivo que no existe y una línea sin comando avisan y salen con código 2
- [ ] con todo bien: una línea ok por comprobación, sin contar comentarios ni líneas vacías, el resumen a stderr y código 0
- [ ] una comprobación que falla sale como FAIL con su código y su error, y bk-healthcheck sale con 1
- [ ] el informe sigue el orden del archivo, no el orden en que terminan
- [ ] sin -j van 4 a la vez: cuatro comprobaciones de 1 s tardan menos de 2 s
- [ ] con -j 2 nunca van más de dos a la vez: cuatro de 1 s tardan entre 2 y 3 s
- [ ] -t corta una comprobación colgada y dice que se le acabó el tiempo
- [ ] un kill a bk-healthcheck para también sus comprobaciones y borra su carpeta temporal; sale con 143
- [ ] lanzado como lo haría cron (otra carpeta, entorno vacío, PATH mínimo) usa el healthcheck.conf del kit y sale con 0
- [ ] bats tests pasa entero, con 3 tests o más de bk-healthcheck
- [ ] los tests de bk-healthcheck fallan si da por buena una comprobación que falla
- [ ] los tests de bk-healthcheck fallan si las comprobaciones van una detrás de otra
- [ ] el kit pasa bk-lint (shellcheck y shfmt) y no le quedan TODOs
- [ ] README.md sin TODOs, documenta bk-healthcheck con -j y -t, la línea de cron y la bitácora de la semana 13

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 07 — cron y timers de systemd](../2-practicas/lab-07-cron-y-timers-de-systemd/README.md) | [Rúbrica de evaluación](../rubrica-evaluacion.md) → |

[↑ Semana 13](../README.md)
