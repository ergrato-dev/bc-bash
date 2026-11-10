# bashkit

Mi CLI de operaciones en bash: la empiezo como un árbol de carpetas y crece cada semana del bootcamp hasta hacer backups de PostgreSQL en Docker.

## Estructura

| Carpeta | Para qué sirve |
|---|---|
| `bin/` | los comandos del kit, uno por archivo (`bk-info`, `bk-run`, `bk-top-ips`, `bk-rename`, `bk-check`, `bk-clean`, `bk-report`, `bk-logs`...) |
| `lib/` | funciones compartidas que cargan los comandos (`core.sh`: `log`, `die`, `require` y los avisos por niveles `log_debug`, `log_info` y `log_warn`) |
| `tests/` | los tests del kit con bats, un archivo por comando (`bk-check.bats`, `bk-run.bats`...), y en `test_helper.bash` lo que comparten |
| `docs/` | documentación: el mapa del kit y el inventario de archivos |

## Recrear la estructura

`./scaffold.sh` crea `bashkit/` con las cuatro carpetas, un `.gitkeep` en cada una y un `README.md`, dentro de la carpeta desde la que lo ejecutas. Se puede repetir sin perder lo que ya hay en las carpetas.

## Comandos

| Comando | Qué hace |
|---|---|
| `bin/bk-info` | imprime tu usuario, tus grupos, el equipo, tu home, la versión de bash y el PATH: lo primero que miras al entrar en una máquina |
| `bin/bk-run` | ejecuta un comando, lo enseña en pantalla y lo guarda en `bk-run.log` con la fecha y su código de salida; sale con el mismo código que el comando. Con `-q` no enseña la salida, con `-l` elige el log y con `-v` cuenta lo que hace. Varios `bk-run` a la vez no mezclan sus líneas: cada bloque se escribe entero, bloqueando el log con `flock` (`-w`: cuántos segundos esperar) |
| `bin/bk-top-ips` | cuenta las peticiones de cada IP en un access log y enseña las N que más hacen (10 si no dices cuántas), de más a menos; ignora las líneas que no empiezan por una IP |
| `bin/bk-rename` | cambia el nombre de un archivo por uno en minúsculas, con guiones en lugar de espacios y sin tildes ni símbolos; con `--dry-run` solo enseña el cambio. No pisa un archivo que ya exista ni toca las carpetas de la ruta |
| `bin/bk-check` | comprueba que un valor es una IP v4, un email o una versión semántica (`ip`, `email` o `semver`); dice `ok` y sale con 0, o avisa en stderr y sale con 1. Con una versión, separa mayor, menor, parche y prerelease |
| `bin/bashkit` | la puerta de entrada al kit: `bashkit clean 7 logs` ejecuta `bk-clean 7 logs`, y `bashkit help` enseña los subcomandos que hay |
| `bin/bk-clean` | borra los archivos de una o varias carpetas (y sus subcarpetas) que llevan más de N días sin cambiar; con `--dry-run` solo enseña la lista. No sigue enlaces, no borra carpetas y no empieza si alguna carpeta no existe |
| `bin/bk-report` | resume el log de `bk-run` en una tabla alineada: cuántas veces se ejecutó cada comando (por su primera palabra), cuántas salió bien y cuántas falló, con una fila de total; lee el log que le digas o el mismo que usa `bk-run` |
| `bin/bk-logs` | convierte un access log de nginx o Apache en CSV (`bk-logs csv`) o en JSON (`bk-logs json`): una fila por petición con ip, fecha en ISO 8601, método, ruta, código y bytes; se salta las líneas que no son peticiones |
| `bin/bk-healthcheck` | ejecuta a la vez las comprobaciones de `healthcheck.conf` (una por línea: un nombre y un comando que sale con 0 si todo va bien) y escribe `ok` o `FAIL` para cada una, en el orden del archivo; sale con 1 si alguna falla. `-j` dice cuántas a la vez (4 si no dices otro número) y `-t` cuántos segundos puede tardar cada una (10). Con Ctrl-C o un `kill`, para también las que siguen en marcha |
| `bin/bk-lint` | revisa los scripts del kit con shellcheck (errores típicos, como una variable sin comillas) y con shfmt (el formato: 2 espacios, los casos del `case` sangrados); sale con 1 si alguno avisa. Sin argumentos revisa todo el kit; con `-w`, shfmt arregla antes el formato |

Con `bin/` en el `PATH` basta con escribir `bashkit info` o `bk-info`: `PATH="$PWD/bin:$PATH"` desde la raíz del kit.

El log se puede cambiar con la opción `-l` o con la variable `BK_LOG`: `bk-run -l deploy.log ./deploy.sh` o `BK_LOG=deploy.log bk-run ./deploy.sh`.

Los avisos del kit tienen nivel: `BK_LOG_LEVEL=debug` los enseña todos y `BK_LOG_LEVEL=error` solo los errores (`info` si no dices nada).

Para ver qué hace un comando por dentro, línea a línea: `BK_TRACE=traza.txt bashkit report` escribe en `traza.txt` cada línea que se ejecuta, con su archivo y su número de línea delante. La salida y los avisos no cambian.

Para pasar los tests, desde la raíz del kit: `bats tests` (o `bats tests/bk-run.bats` para uno solo). Antes de guardar un cambio: `bashkit lint` y `bats tests`.

Para comprobar la máquina cada 5 minutos con cron, guarda el resultado en un log. cron ejecuta desde tu home y con un `PATH` mínimo: por eso la ruta del comando va entera y `bk-healthcheck` busca `healthcheck.conf` junto al kit. Se instala con `crontab -e`:

```text
*/5 * * * * $HOME/bashkit/bin/bk-healthcheck >> $HOME/bashkit/healthcheck.log 2>&1
```

Para ver el resumen de lo que registraste: `bashkit report` (o `bashkit report deploy.log`).

Para llevar un access log a una hoja de cálculo o a jq: `bashkit logs csv access.log > peticiones.csv` o `bashkit logs json access.log | jq '[.[] | select(.codigo >= 500)]'`.

Para probar `bk-top-ips` con datos reales: `bk-top-ips /var/log/nginx/access.log 5`.

Para ordenar una carpeta entera, mirando antes: `find fotos -type f -exec bk-rename --dry-run {} ;` y, si la lista te convence, lo mismo sin `--dry-run`.

## Bitácora

- Semana 01: aprendí a moverme por el árbol con rutas relativas y absolutas, a crear, mover y borrar archivos, y a listar el kit con `find`. Lo que más me costó: acordarme de que `rm` no tiene papelera.
- Semana 02: aprendí a leer y cambiar permisos con `chmod`, a ver y parar procesos con `ps` y `kill`, y a convertir un archivo en un comando con el shebang, el bit de ejecución y el `PATH`. Lo que más me costó: entender que una variable sin `export` no llega a los programas que lanzo.
- Semana 03: aprendí a separar la salida de los errores con `>`, `2>` y `2>&1`, a encadenar comandos con pipes y `tee`, a leer el código de salida con `$?` y a parar un script al primer fallo con `set -euo pipefail`. Lo que más me costó: entender que el orden de `> archivo 2>&1` importa.
- Semana 04: aprendí a filtrar texto con `grep`, `cut`, `sort`, `uniq` y `tr`, a escribir expresiones regulares básicas y extendidas y a buscar archivos con `find`. Lo que más me costó: acordarme de que `uniq -c` solo junta líneas seguidas y necesita un `sort` antes.
- Semana 05: aprendí a guardar datos en variables, a elegir entre comillas simples y dobles, a recortar y sustituir textos con `${var#...}`, `${var%...}` y `${var//...}`, a hacer cuentas con `$(( ))` y a guardar la salida de un comando con `$( )`. Lo que más me costó: acordarme de citar cada `"$var"` aunque hoy no tenga espacios.
- Semana 06: aprendí a decidir con `if`, `[[ ]]` y `case`, a comprobar archivos, textos y números con sus operadores, a validar formatos con `=~` y sacar sus partes con `BASH_REMATCH`, y a leer argumentos con `$1`, `$#` y `"$@"`. Lo que más me costó: acordarme de que la regex detrás de `=~` va sin comillas.
- Semana 07: aprendí a repetir con `for`, `while` y `until`, a cortar un bucle con `break` y `continue`, a leer un archivo línea a línea con `while IFS= read -r` y `mapfile`, y a recorrer archivos con cualquier nombre con `find -print0` y `read -d ''`. Lo que más me costó: entender que con un pipe el `while` va en un subshell y las variables que cambia se pierden.
- Semana 08: aprendí a agrupar código en funciones con sus argumentos, a separar lo que una función imprime de su código de salida, a aislar sus variables con `local`, a cargar una librería con `source` y a repartir los subcomandos de `bashkit` con un `case` y `exec`. Lo que más me costó: entender que sin `local` una variable de una función pisa la del que la llama.
- Semana 09: aprendí a guardar listas en arrays indexados y a recorrerlos con `"${arr[@]}"`, a contar por nombre con arrays asociativos (`declare -A`) y a escribir tablas alineadas con `printf` y sus anchos. Lo que más me costó: acordarme de que las claves de un array asociativo salen sin orden.
- Semana 10: aprendí a sustituir y filtrar líneas con `sed`, a trabajar por campos con `awk` y sus bloques `BEGIN` y `END`, y a leer y construir JSON con `jq`. Lo que más me costó: acordarme de que un campo con comas tiene que ir entre comillas en un CSV.
- Semana 11: aprendí a ver dónde no salta `set -e`, a limpiar al salir con `trap` y `mktemp`, a leer opciones con `getopts`, a bloquear un archivo con `flock` y a escribir avisos por niveles. Lo que más me costó: acordarme de que `set -e` no para dentro de una función llamada desde un `if` o un `||`.
- Semana 12: aprendí a revisar los scripts con shellcheck y shfmt, a escribir tests con bats que comprueban la salida y el código de cada comando, a seguir un script línea a línea con `set -x` y `PS4`, y a fijar un fallo con un test de regresión. Lo que más me costó: acordarme de que cada test empieza de cero y necesita su propia carpeta temporal.
- Semana 13: aprendí a lanzar comandos en segundo plano con `&` y recoger su código con `wait`, a limitar cuántos van a la vez con `wait -n` y `xargs -P`, a pasar la salida de un comando como si fuera un archivo con `<( )`, a parar a los hijos de un script con `trap` y `kill`, y a programar un comando con cron y con un timer de systemd. Lo que más me costó: entender que una señal llega al script y no a los procesos que lanzó.
