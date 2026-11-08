# Proyecto Semana 10 — bashkit logs: el access log en CSV y JSON

⏱ Duración estimada: ~3 h 30 min

## Contexto

`bk-top-ips` (semana 04) cuenta IP, pero un access log tiene mucho más: la fecha, la ruta, el código de respuesta, los bytes. Para llevarlo a una hoja de cálculo o a otro programa hace falta un formato que entiendan: **CSV** (una fila por línea, columnas separadas por comas) o **JSON**. Esta semana escribes **`bin/bk-logs`**, una cadena de tres herramientas: **`sed`** saca los campos de cada línea, **`awk`** los arregla y escribe el CSV, y **`jq`** construye el JSON. Como `bashkit` saca sus subcomandos de `bin/`, `bashkit logs` funciona sin tocar el dispatcher ([docs/proyecto-hilo-conductor.md](../../../docs/proyecto-hilo-conductor.md)).

```text
$ bashkit logs csv access.log
ip,fecha,metodo,ruta,codigo,bytes
10.0.0.5,2026-10-31T23:59:58+00:00,GET,/,200,512
203.0.113.9,2026-11-08T10:12:45+00:00,GET,"/buscar?q=sed,awk",200,1834
...
$ bashkit logs json access.log | jq -c '.[0]'
{"ip":"10.0.0.5","fecha":"2026-10-31T23:59:58+00:00","metodo":"GET","ruta":"/","codigo":200,"bytes":512}
```

## Estructura del proyecto

`starter/` es el `bashkit` con el que terminaste la semana 09, más lo nuevo:

```text
3-proyecto/
├── starter/                 ← aquí trabajas
│   ├── README.md            ← 2 TODOs: bk-logs y la bitácora
│   ├── bin/
│   │   ├── bashkit
│   │   ├── bk-logs          ← nuevo, sin permiso de ejecución, TODOs 1 a 7
│   │   └── bk-check, bk-clean, bk-info, bk-rename, bk-report, bk-run, bk-top-ips
│   ├── lib/core.sh
│   └── docs/
│       └── inventario.txt   ← hay que regenerarlo
├── tests/
│   └── access.log           ← 9 líneas de nginx: 7 peticiones, un aviso y una petición vacía
└── solucion/
```

Así es una línea del log, en el formato *combined* que escriben nginx y Apache:

```text
10.0.0.5 - - [31/Oct/2026:23:59:58 +0000] "GET / HTTP/1.1" 200 512 "-" "curl/8.5.0"
```

La IP, dos `-` (usuario remoto y usuario autenticado, casi siempre vacíos), la fecha entre corchetes, la petición entre comillas (método, ruta y protocolo), el código de respuesta, los bytes enviados, de qué página venía (*referer*) y el programa que hizo la petición (*user agent*).

## Lo que debes construir

1. `bin/bk-logs` con permisos `755`. Uso: `bk-logs csv|json <access.log>`. Con otro número de argumentos o un formato que no es `csv` ni `json`, `die` con el uso y código `2`; con un log que no se puede leer, `die` con su nombre y código `1`. Antes de nada, `require sed awk jq`.
2. Cuatro funciones encadenadas con pipes: `fields` (`sed`: los seis campos separados por tabuladores, y nada de las líneas que no son peticiones), `normalize` (`awk`: la fecha en ISO 8601 y `-` como `0` bytes), `to_csv` (`awk`) y `to_json` (`jq`).
3. El CSV empieza por la cabecera `ip,fecha,metodo,ruta,codigo,bytes`. Una ruta con comas o comillas va entre comillas.
4. El JSON es un array con un objeto por petición: `ip`, `fecha`, `metodo` y `ruta` como textos; `codigo` y `bytes` como números.
5. Un log vacío da la cabecera sola en CSV y `[]` en JSON.
6. El kit sin TODOs y sin avisos de `shellcheck -x`; `docs/inventario.txt` regenerado y `README.md` sin TODOs.

## Paso a paso

### Paso 0 — Entrar al laboratorio

Desde la raíz del repositorio, en tu equipo:

```bash
docker compose run --rm lab
cd bootcamp/week-10-sed_awk_y_jq/3-proyecto/starter
```

(sin salida).

### Paso 1 — El esqueleto

Abre `bin/bk-logs` en tu editor: carga `lib/core.sh`, tiene las cuatro funciones con un `cat` dentro (que deja pasar las líneas sin cambiarlas), un `case` que las encadena según el formato y siete TODOs.

```bash
ls -l bin/bk-logs
bin/bk-logs csv ../tests/access.log; echo $?
```

Algo como (cambian la fecha y el tamaño):

```text
-rw-r--r-- 1 alumno alumno 1479 Nov  8 07:22 bin/bk-logs
bash: bin/bk-logs: Permission denied
126
```

Dale el permiso de ejecución y prueba otra vez:

```bash
chmod +x bin/bk-logs
bin/bk-logs csv ../tests/access.log | head -n 3
```

```text
10.0.0.5 - - [31/Oct/2026:23:59:58 +0000] "GET / HTTP/1.1" 200 512 "-" "curl/8.5.0"
10.0.0.7 - - [01/Nov/2026:00:00:03 +0000] "POST /login HTTP/1.1" 302 0 "-" "Mozilla/5.0 (X11; Linux x86_64)"
::1 - - [08/Nov/2026:10:07:00 +0000] "GET /health HTTP/1.1" 200 2 "-" "kube-probe/1.31"
```

Con los cuatro `cat`, sale el log tal cual. Cada TODO cambia uno de ellos.

### Paso 2 — TODO 1: argumentos y herramientas

Cambia los dos comentarios del `TODO 1` y las dos líneas de debajo por:

```bash
# jq no viene en todas las máquinas: mejor avisar al principio que a mitad de la salida.
require sed awk jq

[[ $# -eq 2 && $1 =~ ^(csv|json)$ ]] || die "uso: bk-logs csv|json <access.log>" 2
format="$1"
log="$2"
[[ -r $log ]] || die "no puedo leer '$log'"
```

`require` es la de `lib/core.sh` (semana 08). `^(csv|json)$` acepta esas dos palabras y ninguna otra (semana 06). Prueba:

```bash
bin/bk-logs; echo $?
bin/bk-logs xml ../tests/access.log; echo $?
bin/bk-logs csv no-existe.log; echo $?
bin/bk-logs json ../tests/access.log | tail -n 3
```

```text
bk-logs: uso: bk-logs csv|json <access.log>
2
bk-logs: uso: bk-logs csv|json <access.log>
2
bk-logs: no puedo leer 'no-existe.log'
1
198.51.100.4 - - [08/Nov/2026:10:14:02 +0000] "-" 400 0 "-" "-"
203.0.113.9 - - [08/Nov/2026:10:15:00 +0000] "GET /admin HTTP/1.1" 403 153 "-" "sqlmap/1.8"
10.0.0.7 - - [08/Nov/2026:10:20:01 +0000] "GET /api/pedidos HTTP/1.1" 500 87 "-" "curl/8.5.0"
```

La primera de esas tres no es una petición: un escáner abrió la conexión y la cerró sin pedir nada, y nginx escribe `"-"`.

### Paso 3 — TODO 2: los campos, con sed

Una regex que solo mire el principio de la línea no basta:

```bash
sed -nE 's/^([^ ]+) .*/\1/p' ../tests/access.log | paste -sd' '
```

```text
10.0.0.5 10.0.0.7 ::1 10.0.0.5 203.0.113.9 nginx: 198.51.100.4 203.0.113.9 10.0.0.7
```

`nginx:` es el principio del aviso de la línea 6 (lab 01). La regex tiene que describir la línea entera, y `-n` con `/p` hace que solo salgan las que encajan. En `fields`, cambia el comentario del `TODO 2` y el `cat "$log"` por:

```bash
  # -n y /p: solo salen las líneas en las que la sustitución encaja. Un aviso de nginx
  # o una petición vacía ("-") se quedan fuera en lugar de llegar con campos a medias.
  sed -nE 's/^([^ ]+) [^ ]+ [^ ]+ \[([^]]+)\] "([A-Z]+) ([^ ]+) [^"]*" ([0-9]{3}) ([0-9]+|-)( .*)?$/\1\t\2\t\3\t\4\t\5\t\6/p' "$log"
```

Por partes: `([^ ]+)` es la IP, y los dos `[^ ]+` sin paréntesis, los dos `-`. `\[([^]]+)\]` es la fecha: `[^]]` es "cualquier cosa menos `]`". `"([A-Z]+) ([^ ]+) [^"]*"` es la petición: método, ruta y el protocolo, que no se guarda. `([0-9]{3})` es el código; `([0-9]+|-)`, los bytes o un `-`. `( .*)?$` acepta el resto de la línea, o nada si el log no trae *referer* ni *user agent*. `\t` es un tabulador. Prueba (`tr` cambia los tabuladores por `|` para que se vean):

```bash
bin/bk-logs csv ../tests/access.log | tr '\t' '|'
```

```text
10.0.0.5|31/Oct/2026:23:59:58 +0000|GET|/|200|512
10.0.0.7|01/Nov/2026:00:00:03 +0000|POST|/login|302|0
::1|08/Nov/2026:10:07:00 +0000|GET|/health|200|2
10.0.0.5|08/Nov/2026:10:09:30 +0000|GET|/static/app.css|304|-
203.0.113.9|08/Nov/2026:10:12:45 +0000|GET|/buscar?q=sed,awk|200|1834
203.0.113.9|08/Nov/2026:10:15:00 +0000|GET|/admin|403|153
10.0.0.7|08/Nov/2026:10:20:01 +0000|GET|/api/pedidos|500|87
```

Siete peticiones, sin el aviso ni la petición vacía.

### Paso 4 — TODO 3: la fecha, con awk

`31/Oct/2026:23:59:58 +0000` no se ordena como texto (`01/Nov` iría antes que `31/Oct`) y pocos programas la entienden. ISO 8601, `2026-10-31T23:59:58+00:00`, sí. `split` de awk corta un texto en un array por una regex (lab 05):

```bash
echo '31/Oct/2026:23:59:58 +0000' | awk '{ n = split($0, d, "[/: ]"); for (i = 1; i <= n; i++) print i, d[i] }'
```

```text
1 31
2 Oct
3 2026
4 23
5 59
6 58
7 +0000
```

Falta pasar `Oct` a `10`: un array de awk que se llena en `BEGIN`, antes de leer la primera línea (lab 04). En `normalize`, cambia el comentario del `TODO 3` y el `cat` por lo de abajo. El comentario del `TODO 7` se queda donde está, encima del `awk`, hasta el paso 8:

```bash
  awk -F'\t' -v OFS='\t' '
    BEGIN {
      # El log escribe el mes con sus letras en inglés: month["Oct"] es "10".
      split("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec", names, " ")
      for (i = 1; i <= 12; i++) month[names[i]] = sprintf("%02d", i)
    }
    {
      # 31/Oct/2026:23:59:58 +0000 pasa a 2026-10-31T23:59:58+00:00: así las fechas
      # se ordenan como texto y cualquier programa las entiende.
      split($2, d, "[/: ]")
      $2 = d[3] "-" month[d[2]] "-" d[1] "T" d[4] ":" d[5] ":" d[6] substr(d[7], 1, 3) ":" substr(d[7], 4)
      print
    }'
```

`-F'\t'` separa los campos por tabuladores, y `OFS` es el separador con el que awk vuelve a escribir la línea cuando cambias un campo. En awk, dos textos seguidos se juntan: `d[3] "-"` es `2026-`. `substr(d[7], 1, 3)` son los tres primeros caracteres de `+0000`. Prueba:

```bash
bin/bk-logs csv ../tests/access.log | tr '\t' '|' | head -n 2
```

```text
10.0.0.5|2026-10-31T23:59:58+00:00|GET|/|200|512
10.0.0.7|2026-11-01T00:00:03+00:00|POST|/login|302|0
```

### Paso 5 — TODO 4: el CSV

En `to_csv`, cambia el comentario del `TODO 4` y el `cat` por lo de abajo. El del `TODO 5` va dentro del programa de awk:

```bash
  awk -F'\t' -v OFS=, '
    # TODO 5: la ruta entre comillas cuando lleva comas o comillas.
    BEGIN { print "ip,fecha,metodo,ruta,codigo,bytes" }
    # Cambiar un campo rehace la línea con OFS: los tabuladores pasan a ser comas.
    { $1 = $1; print }'
```

`$1 = $1` no cambia nada, pero obliga a awk a rehacer la línea con `OFS` (lab 05). Prueba, y cuenta las columnas de cada fila con `awk -F,` y `uniq -c`:

```bash
bin/bk-logs csv ../tests/access.log
bin/bk-logs csv ../tests/access.log | awk -F, '{ print NF }' | uniq -c
```

```text
ip,fecha,metodo,ruta,codigo,bytes
10.0.0.5,2026-10-31T23:59:58+00:00,GET,/,200,512
10.0.0.7,2026-11-01T00:00:03+00:00,POST,/login,302,0
::1,2026-11-08T10:07:00+00:00,GET,/health,200,2
10.0.0.5,2026-11-08T10:09:30+00:00,GET,/static/app.css,304,-
203.0.113.9,2026-11-08T10:12:45+00:00,GET,/buscar?q=sed,awk,200,1834
203.0.113.9,2026-11-08T10:15:00+00:00,GET,/admin,403,153
10.0.0.7,2026-11-08T10:20:01+00:00,GET,/api/pedidos,500,87
      5 6
      1 7
      2 6
```

Una fila tiene 7 columnas: la coma de `q=sed,awk` parte la ruta en dos. Una hoja de cálculo pondría `awk` en la columna de los códigos.

### Paso 6 — TODO 5: comillas en el CSV

La regla del CSV (RFC 4180): un campo con comas o comillas va entre comillas, y las comillas que lleva dentro se escriben dos veces. Cambia el comentario del `TODO 5` y el bloque `{ $1 = $1; print }` por:

```bash
    # Un campo con comas o comillas va entre comillas, y sus comillas se doblan (RFC 4180):
    # sin esto, /buscar?q=sed,awk se leería como dos columnas.
    function quote(s) {
      if (s ~ /[",]/) {
        gsub(/"/, "\"\"", s)
        s = "\"" s "\""
      }
      return s
    }
    BEGIN { print "ip,fecha,metodo,ruta,codigo,bytes" }
    # Cambiar un campo rehace la línea con OFS: los tabuladores pasan a ser comas.
    { $4 = quote($4); print }'
```

(Las dos líneas de `BEGIN` y del comentario ya estaban: quedan debajo de la función.) `~` comprueba una regex; `gsub` sustituye todas las veces, como la `g` de `sed`. Ahora es `$4 = ...` el que rehace la línea. Prueba:

```bash
bin/bk-logs csv ../tests/access.log | grep buscar
```

```text
203.0.113.9,2026-11-08T10:12:45+00:00,GET,"/buscar?q=sed,awk",200,1834
```

### Paso 7 — TODO 6: el JSON, con jq

`jq -R` lee cada línea como un texto, no como JSON. Con `-n` no lee nada al empezar, y `inputs` son todas las líneas: `[inputs | ...]` las junta en un array (lab 07). En `to_json`, cambia el comentario del `TODO 6` y el `cat` por:

```bash
  # -R: cada línea es un texto, no JSON. -n con inputs las junta en un solo array (y [] si no hay ninguna).
  # tonumber: el código y los bytes como números, para poder sumarlos y compararlos después.
  jq -nR '[inputs | split("\t") | {ip: .[0], fecha: .[1], metodo: .[2], ruta: .[3], codigo: (.[4] | tonumber), bytes: (.[5] | tonumber)}]'
```

`split("\t")` corta la línea en un array; `.[0]` es su primer elemento. Prueba:

```bash
bin/bk-logs json ../tests/access.log; echo $?
```

```text
jq: error (at <stdin>:4): Invalid numeric literal at EOF at line 1, column 1 (while parsing '-')
5
```

La línea 4 es la del `304`, con `-` en los bytes: `tonumber` no sabe convertirlo. Y como `jq` construye el array entero antes de escribirlo, no sale ni una petición.

### Paso 8 — TODO 7: bytes sin número

Un `-` en los bytes es una respuesta sin cuerpo: 0 bytes. Se arregla donde se arreglan los datos, en `normalize`, y así vale para el CSV y para el JSON. Borra el comentario del `TODO 7` y escribe, en el awk de `normalize`, encima del `print`:

```bash
      # "-" es una respuesta sin cuerpo: 0 bytes. Sin esto, tonumber de jq falla.
      if ($6 == "-") $6 = 0
```

Prueba:

```bash
bin/bk-logs json ../tests/access.log | head -n 9
bin/bk-logs json ../tests/access.log | jq length
bin/bk-logs csv ../tests/access.log | grep ,304,
```

```text
[
  {
    "ip": "10.0.0.5",
    "fecha": "2026-10-31T23:59:58+00:00",
    "metodo": "GET",
    "ruta": "/",
    "codigo": 200,
    "bytes": 512
  },
7
10.0.0.5,2026-11-08T10:09:30+00:00,GET,/static/app.css,304,0
```

`200` y `512` van sin comillas: son números.

### Paso 9 — bashkit logs

Con `bin/` en el `PATH`, `bashkit` encuentra el subcomando nuevo. Pídele a `jq` solo las peticiones que fallaron:

```bash
PATH="$PWD/bin:$PATH"
bashkit help
bashkit logs json ../tests/access.log | jq -c '[.[] | select(.codigo >= 400) | {ip, ruta, codigo}]'
```

```text
uso: bashkit <subcomando> [argumentos...]
subcomandos:
  check
  clean
  info
  logs
  rename
  report
  run
  top-ips
[{"ip":"203.0.113.9","ruta":"/admin","codigo":403},{"ip":"10.0.0.7","ruta":"/api/pedidos","codigo":500}]
```

`select(.codigo >= 400)` funciona porque `codigo` es un número: con `"403"` como texto, la comparación sería otra. Un log vacío:

```bash
: > vacio.log
bk-logs csv vacio.log
bk-logs json vacio.log
rm vacio.log
```

```text
ip,fecha,metodo,ruta,codigo,bytes
[]
```

`: > vacio.log` crea un archivo vacío (semana 03).

### Paso 10 — shellcheck

```bash
grep -rn TODO bin lib scaffold.sh
shellcheck -x bin/bk-logs; echo $?
```

```text
0
```

El `grep` no imprime nada: no queda ningún TODO en el código. shellcheck no mira dentro de los programas de awk ni de jq: van entre comillas simples y, para bash, son un texto.

### Paso 11 — El inventario al día

```bash
find . -type f > docs/inventario.txt
grep logs docs/inventario.txt
```

```text
./bin/bk-logs
```

### Paso 12 — README del kit

```bash
grep -n TODO README.md
```

```text
30:| `bin/bk-logs` | TODO: qué convierte `bk-logs`, en qué dos formatos, qué campos tiene cada fila y qué hace con las líneas que no son peticiones |
53:- Semana 10: TODO: qué aprendiste y qué te costó.
```

Abre `README.md` en tu editor y sustituye cada `TODO` con tus palabras: qué convierte `bk-logs`, sus dos formatos, los campos de cada fila, qué hace con las líneas que no son peticiones y la bitácora de la semana (la línea tiene que empezar por `- Semana 10:`). Repite el `grep` hasta que no imprima nada.

### Paso 13 — Autograding

```bash
cd "$(git rev-parse --show-toplevel)" && ./scripts/verificar-semana.sh 10
```

Con todo hecho:

```text
Semana 10 — sed, awk y jq

  ✅ bin/bk-logs existe, tiene permiso de ejecución y empieza por el shebang del kit
  ✅ bk-logs carga lib/core.sh, comprueba sus herramientas con require, avisa con die y usa sed, awk y jq
  ✅ sin argumentos o con un formato que no es csv ni json, escribe el uso en stderr y sale con código 2
  ✅ con un log que no se puede leer, avisa en stderr con su nombre y sale con código 1
  ✅ el CSV empieza por la cabecera y tiene una fila por petición: 7 con el log de prueba, sin el aviso de nginx ni la petición vacía
  ✅ la fecha sale en ISO 8601 (2026-10-31T23:59:58+00:00) y los campos separados por comas
  ✅ una respuesta sin cuerpo (bytes "-" en el log) sale con 0 bytes
  ✅ una ruta con comas va entre comillas, como pide el formato CSV
  ✅ el JSON es un array de 7 objetos, con el código y los bytes como números
  ✅ cada objeto tiene ip, fecha, metodo, ruta, codigo y bytes, con los mismos valores que el CSV
  ✅ con un log vacío, el CSV es solo la cabecera y el JSON un array vacío
  ✅ bashkit help ofrece logs, y bashkit logs json da el mismo array que bk-logs
  ✅ el kit sin TODOs y limpio para shellcheck -x
  ✅ docs/inventario.txt incluye ./bin/bk-logs
  ✅ README.md sin TODOs, documenta bk-logs y tiene la bitácora de la semana 10

15/15 comprobaciones superadas.
```

Cada ❌ trae una pista con el paso donde se arregla. Para salir del laboratorio: `exit`.

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 10` desde la raíz del repositorio (60 de los 100 puntos del Producto, 4 por comprobación). Los otros 40 son de calidad: ver la [rúbrica](../rubrica-evaluacion.md#-producto-30).

- [ ] bin/bk-logs existe, tiene permiso de ejecución y empieza por el shebang del kit
- [ ] bk-logs carga lib/core.sh, comprueba sus herramientas con require, avisa con die y usa sed, awk y jq
- [ ] sin argumentos o con un formato que no es csv ni json, escribe el uso en stderr y sale con código 2
- [ ] con un log que no se puede leer, avisa en stderr con su nombre y sale con código 1
- [ ] el CSV empieza por la cabecera y tiene una fila por petición: 7 con el log de prueba, sin el aviso de nginx ni la petición vacía
- [ ] la fecha sale en ISO 8601 (2026-10-31T23:59:58+00:00) y los campos separados por comas
- [ ] una respuesta sin cuerpo (bytes "-" en el log) sale con 0 bytes
- [ ] una ruta con comas va entre comillas, como pide el formato CSV
- [ ] el JSON es un array de 7 objetos, con el código y los bytes como números
- [ ] cada objeto tiene ip, fecha, metodo, ruta, codigo y bytes, con los mismos valores que el CSV
- [ ] con un log vacío, el CSV es solo la cabecera y el JSON un array vacío
- [ ] bashkit help ofrece logs, y bashkit logs json da el mismo array que bk-logs
- [ ] el kit sin TODOs y limpio para shellcheck -x
- [ ] docs/inventario.txt incluye ./bin/bk-logs
- [ ] README.md sin TODOs, documenta bk-logs y tiene la bitácora de la semana 10

## Calidad

Además de los checks, se revisa (40 pts, ver la rúbrica):

- Una herramienta para cada cosa: `sed` saca los campos, `awk` los transforma, `jq` construye el JSON. Nada de JSON escrito a mano con `echo`.
- Las regex describen la línea entera; lo que no encaja se queda fuera, no llega a medias.
- Los programas de awk y jq entre comillas simples; los datos de bash entran con `-v` o `--arg`, nunca pegados dentro.
- Avisos a stderr con `die`; `2` para un uso mal hecho; los datos, a stdout.
- Comentarios que explican el porqué: por qué tabuladores, por qué `-n` con `/p`, por qué `tonumber`.

## Entrega

Commit desde tu copia del repositorio con el mensaje `feat(week-10): bashkit logs` que incluya `starter/` completo. Comprueba con `git diff` que aparece `new mode 100755` para `bin/bk-logs`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 07 — JSON roto](../2-practicas/lab-07-json-roto/README.md) | [Rúbrica de evaluación](../rubrica-evaluacion.md) → |

[↑ Semana 10](../README.md)
