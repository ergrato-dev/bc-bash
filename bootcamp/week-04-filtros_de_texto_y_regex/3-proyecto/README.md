# Proyecto Semana 04 — bk-top-ips: quién carga el servidor

⏱ Duración estimada: ~3 h 30 min

## Contexto

Cuando un servidor web va lento, la primera pregunta es quién le está pidiendo tanto: un cliente legítimo, un robot o un ataque. La respuesta está en el access log, y se saca con la receta de esta semana. Escribes **`bk-top-ips`**, el tercer comando de `bashkit` ([docs/proyecto-hilo-conductor.md](../../../docs/proyecto-hilo-conductor.md)): recibe un access log y enseña las IP que más peticiones hacen, de más a menos.

```text
$ bk-top-ips /var/log/nginx/access.log 3
      9 203.0.113.7
      7 198.51.100.23
      5 192.0.2.15
```

Un log real trae líneas que no empiezan por una IP (`::1` de las comprobaciones de salud, `-` de peticiones rotas) e IP que no son del cliente (las del *referer*). `bk-top-ips` cuenta solo la IP del principio de cada línea. Lo probarás con `tests/access.log`, un log de 44 líneas preparado con esas trampas.

## Estructura del proyecto

`starter/` es el `bashkit` con el que terminaste la semana 03, más lo nuevo:

```text
3-proyecto/
├── tests/
│   └── access.log           ← datos de prueba (no los cambies: los usa el autograding)
└── starter/                 ← aquí trabajas (lo corrige el autograding)
    ├── README.md            ← fila de bk-top-ips y bitácora de la semana 04 (TODOs)
    ├── scaffold.sh
    ├── bin/
    │   ├── .gitkeep
    │   ├── bk-info
    │   ├── bk-run
    │   └── bk-top-ips       ← nuevo: sin permiso de ejecución (TODOs 1 a 6)
    ├── lib/.gitkeep
    ├── tests/.gitkeep
    └── docs/
        ├── mapa.txt
        └── inventario.txt   ← hay que regenerarlo
```

## Lo que debes construir

1. `bin/bk-top-ips` con permisos `755` y `set -euo pipefail` (ya viene en el starter).
2. Sin argumentos, escribe `uso: bk-top-ips <access.log> [N]` en stderr y sale con código `2`.
3. Si no puede leer el log, escribe en stderr un mensaje con su nombre y sale con código `1`.
4. Cuenta las peticiones de cada IP que aparece **al principio** de una línea y las enseña de más a menos, con el formato de `uniq -c`.
5. Enseña las `N` primeras (el segundo argumento) o 10 si no se indica.
6. Un log sin ninguna IP no es un error: sale con `0` y sin salida.
7. Todos los scripts del kit sin TODOs y sin avisos de shellcheck; `docs/inventario.txt` regenerado y `README.md` sin TODOs.

## Paso a paso

### Paso 0 — Entrar al laboratorio y a la carpeta del proyecto

Desde la raíz del repositorio, en tu equipo:

```bash
docker compose run --rm lab
cd bootcamp/week-04-filtros_de_texto_y_regex/3-proyecto/starter
mkdir -p ../zona
```

(sin salida). `../zona` es la carpeta de pruebas del proyecto, al lado de `starter/`: git la ignora.

### Paso 1 — `bk-top-ips` ejecutable

```bash
ls -l bin/bk-top-ips
./bin/bk-top-ips
```

Algo como (cambian el tamaño y la fecha):

```text
-rw-r--r-- 1 alumno alumno 775 Nov  8 05:25 bin/bk-top-ips
bash: ./bin/bk-top-ips: Permission denied
```

Dale permiso de ejecución (semana 02) y prueba otra vez:

```bash
chmod +x bin/bk-top-ips
./bin/bk-top-ips
echo $?
```

```text
./bin/bk-top-ips: line 8: $1: unbound variable
1
```

`set -u` para el script en la línea 8, `log="$1"`, porque no le has dado ningún argumento. Funciona, pero el mensaje no le dice a quien lo usa qué tiene que escribir. Eso es el TODO 1.

### Paso 2 — TODO 1: el mensaje de uso

Abre `bin/bk-top-ips` en tu editor. Sustituye la línea del `TODO 1` por la comprobación que escribiste en `bk-run` (semana 03): si `$#` no es mayor que 0, `uso: bk-top-ips <access.log> [N]` a stderr y `exit 2`. Los corchetes de `[N]` son la costumbre para decir "opcional". Prueba:

```bash
./bin/bk-top-ips
echo $?
```

```text
uso: bk-top-ips <access.log> [N]
2
```

### Paso 3 — TODO 2: un log que no se puede leer

`test -r ruta` responde `0` si el archivo existe y puedes leerlo. Sustituye la línea del `TODO 2` por un `test -r "$log"` seguido de `||` y un bloque `{ ...; }` que escriba `bk-top-ips: no puedo leer '...'` (con el nombre del log en el sitio de los puntos) a stderr y salga con `1`. Prueba:

```bash
./bin/bk-top-ips nada.log
echo $?
```

```text
bk-top-ips: no puedo leer 'nada.log'
1
```

Sin esta línea, el error lo daría `grep` a mitad del pipe, con su propio mensaje: el tuyo dice qué comando falló y con qué archivo.

### Paso 4 — TODO 3: sacar la IP del principio de cada línea

Primero, mira las líneas que no empiezan por un dígito:

```bash
grep -v '^[0-9]' ../tests/access.log
```

```text
::1 - - [07/Nov/2026:08:40:02 +0000] "GET /health HTTP/1.1" 200 2 "-" "kube-probe/1.31"
- - - [07/Nov/2026:09:20:11 +0000] "-" 400 0 "-" "-"
::1 - - [07/Nov/2026:10:40:02 +0000] "GET /health HTTP/1.1" 200 2 "-" "kube-probe/1.31"
```

Esas tres no deben contar. Y hay una línea con una segunda IP, en el *referer* (la página desde la que llegó el cliente):

```bash
grep -n '"http://' ../tests/access.log
```

```text
22:10.0.0.5 - - [07/Nov/2026:09:15:40 +0000] "GET /login HTTP/1.1" 302 0 "http://203.0.113.7/admin" "Mozilla/5.0 (X11; Linux x86_64) Firefox/131.0"
```

La petición es de `10.0.0.5`; `203.0.113.7` solo aparece en el texto. La regex de la [teoría](../1-teoria/02-grep-y-expresiones-regulares.md), con su `^`, resuelve los dos casos.

Sustituye la línea del `TODO 3` por un `grep -oE` con la regex `'^([0-9]{1,3}\.){3}[0-9]{1,3}'` sobre `"$log"`. Borra también las dos últimas líneas del script (`echo "sin implementar"` y `exit 1`). Prueba:

```bash
./bin/bk-top-ips ../tests/access.log | head -3
./bin/bk-top-ips ../tests/access.log | wc -l
```

```text
198.51.100.23
192.0.2.15
203.0.113.7
41
```

Una IP por línea, 41 en total: las 44 líneas menos las 3 que no empiezan por una IP. Sin el `^`, `grep -o` sacaría también la del referer:

```bash
grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' ../tests/access.log | wc -l
```

```text
42
```

### Paso 5 — TODO 4: contar y ordenar

Termina la línea del `grep` con `|` y escribe en la línea siguiente la receta: `sort | uniq -c | sort -rn`. Un `|` al final de una línea le dice a bash que el pipe sigue en la siguiente; pon dos espacios delante para que se lea como continuación. Borra el comentario del `TODO 4`. Prueba:

```bash
./bin/bk-top-ips ../tests/access.log
```

```text
      9 203.0.113.7
      7 198.51.100.23
      5 192.0.2.15
      4 10.0.0.5
      3 192.0.2.99
      3 172.16.4.20
      2 203.0.113.50
      2 198.51.100.8
      2 10.0.0.31
      1 203.0.113.101
      1 192.0.2.200
      1 172.16.4.1
      1 10.0.0.77
```

`203.0.113.7` tiene 9 peticiones, no 10: la del referer no cuenta. Las que empatan salen en orden inverso de texto, porque `-r` también da la vuelta al desempate.

### Paso 6 — TODO 5: las N primeras

Arriba del script, `top="${2:-10}"` guarda el segundo argumento o, si no lo hay, `10` (la semana 05 lo explica a fondo). Termina la línea de la receta con `|` y añade en la siguiente `head -n "$top"`. Borra el comentario del `TODO 5`. Prueba:

```bash
./bin/bk-top-ips ../tests/access.log | wc -l
./bin/bk-top-ips ../tests/access.log 3
```

```text
10
      9 203.0.113.7
      7 198.51.100.23
      5 192.0.2.15
```

### Paso 7 — TODO 6: un log sin ninguna IP

Un log con solo comprobaciones de salud o vacío no tiene ninguna IP que contar. Pruébalo:

```bash
printf -- '- - - basura\n::1 - - salud\n' > ../zona/sin-ips.log
./bin/bk-top-ips ../zona/sin-ips.log
echo $?
```

```text
1
```

(`--` le dice a `printf` que lo que sigue no son opciones, aunque empiece por `-`.) Sale con `1` y sin ningún mensaje: `grep` no encontró nada y salió con `1` (lab 02 de esta semana), y con `pipefail` ese `1` es el código de todo el pipe, así que `set -e` para el script. Pero "ninguna IP" es una respuesta válida, no un error.

Envuelve el `grep` en un bloque con `|| true` (semana 03): `{ grep -oE '...' "$log" || true; } |`. Si `grep` no encuentra nada, `true` sale con `0` y el pipe sigue, vacío. Los errores de verdad, como un log que no se puede leer, ya los atrapa el TODO 2. Borra el comentario del `TODO 6`. Prueba:

```bash
./bin/bk-top-ips ../zona/sin-ips.log
echo $?
```

```text
0
```

### Paso 8 — `bk-top-ips` dentro de `bk-run`

Los comandos del kit se combinan. Pon `bin/` en el `PATH` (semana 02) y deja que `bk-run` registre lo que dice `bk-top-ips`:

```bash
PATH="$PWD/bin:$PATH"
bk-run bk-top-ips ../tests/access.log 3
echo $?
cat bk-run.log
rm bk-run.log
```

Algo como (cambia la fecha):

```text
      9 203.0.113.7
      7 198.51.100.23
      5 192.0.2.15
0
== 2026-11-08 05:38:48 bk-top-ips ../tests/access.log 3 ==
      9 203.0.113.7
      7 198.51.100.23
      5 192.0.2.15
== código: 0 ==
```

El `rm` deja `starter/` sin logs de prueba, que no deben ir en la entrega.

### Paso 9 — El kit sin TODOs y sin avisos

```bash
grep -n TODO bin/bk-info bin/bk-run bin/bk-top-ips scaffold.sh
shellcheck bin/bk-info bin/bk-run bin/bk-top-ips scaffold.sh
```

(sin salida): ningún TODO y ningún aviso. Si shellcheck avisa, el mensaje dice la línea y trae un enlace a su explicación.

### Paso 10 — El inventario al día

Comprueba antes que no queda ningún `.log` de las pruebas dentro de `starter/` (`ls *.log` debe dar `No such file or directory`):

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
./bin/bk-top-ips
./bin/.gitkeep
./lib/.gitkeep
```

### Paso 11 — README del kit

```bash
grep -n TODO README.md
```

```text
24:| `bin/bk-top-ips` | TODO: qué hace, qué argumentos recibe y qué devuelve |
35:- Semana 04: TODO: qué aprendiste y qué te costó.
```

Abre `README.md` en tu editor y sustituye cada `TODO` con tus palabras: qué hace `bk-top-ips`, qué dos argumentos recibe (el segundo, opcional), qué líneas ignora, y la bitácora de la semana (la línea tiene que empezar por `- Semana 04:`). Repite el `grep` hasta que no imprima nada.

### Paso 12 — Autograding

```bash
cd "$(git rev-parse --show-toplevel)" && ./scripts/verificar-semana.sh 04
```

Con todo hecho:

```text
Semana 04 — Filtros de texto y regex

  ✅ bin/bk-top-ips tiene permisos 755 y el shebang #!/usr/bin/env bash
  ✅ sin argumentos, bk-top-ips escribe 'uso: bk-top-ips ...' en stderr y sale con código 2
  ...
  ✅ README.md sin TODOs, documenta bk-top-ips y tiene la bitácora de la semana 04

15/15 comprobaciones superadas.
```

Cada ❌ trae una pista con el paso donde se arregla. Para salir del laboratorio: `exit`.

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 04` desde la raíz del repositorio (60 de los 100 puntos del Producto). Los otros 40 son de calidad: ver la [rúbrica](../rubrica-evaluacion.md#-producto-30).

- [ ] bin/bk-top-ips tiene permisos 755 y el shebang #!/usr/bin/env bash
- [ ] sin argumentos, bk-top-ips escribe 'uso: bk-top-ips ...' en stderr y sale con código 2
- [ ] con un log que no existe, avisa en stderr con su nombre y sale con código 1
- [ ] la primera línea es la IP con más peticiones: 9 203.0.113.7
- [ ] solo cuenta la IP del principio de la línea, no las del referer ni ::1
- [ ] los recuentos suman las 41 peticiones que empiezan por una IP
- [ ] ordena de más a menos peticiones, como número
- [ ] sin N, enseña 10 líneas
- [ ] con N=3, la tercera línea es 5 192.0.2.15
- [ ] con N=3, enseña exactamente 3 líneas
- [ ] un log sin ninguna IP sale con código 0 y sin salida
- [ ] bk-run registra en su log el resultado de bk-top-ips
- [ ] los scripts del kit sin TODOs, con set -euo pipefail y limpios para shellcheck
- [ ] docs/inventario.txt incluye ./bin/bk-top-ips
- [ ] README.md sin TODOs, documenta bk-top-ips y tiene la bitácora de la semana 04

## Calidad

Además de los checks, se revisa (40 pts, ver la rúbrica):

- La regex está entre comillas simples y su `^` y sus `\.` son intencionados, no copiados a ciegas.
- Mensajes de uso y de error a stderr; la salida, solo el recuento.
- Comentarios que explican el porqué: por qué el `^`, por qué el `sort` antes del `uniq -c`, por qué el `|| true`.
- Comillas dobles alrededor de `"$log"`, `"$top"` y `"$#"`.

## Entrega

Commit desde tu copia del repositorio con el mensaje `feat(week-04): bk-top-ips` que incluya `starter/` completo. Comprueba con `git diff` que aparece `new mode 100755` para `bin/bk-top-ips`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 07 — Analizar un access log](../2-practicas/lab-07-analizar-un-access-log/README.md) | [Rúbrica de evaluación](../rubrica-evaluacion.md) → |

[↑ Semana 04](../README.md)
