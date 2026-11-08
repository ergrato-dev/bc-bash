# bashkit

Mi CLI de operaciones en bash: la empiezo como un árbol de carpetas y crece cada semana del bootcamp hasta hacer backups de PostgreSQL en Docker.

## Estructura

| Carpeta | Para qué sirve |
|---|---|
| `bin/` | los comandos del kit, uno por archivo (`bk-info`, `bk-run`, `bk-top-ips`, `bk-rename`, `bk-check`, `bk-clean`...) |
| `lib/` | funciones compartidas que cargan los comandos (`core.sh`: `log`, `die` y `require`) |
| `tests/` | pruebas automáticas del kit |
| `docs/` | documentación: el mapa del kit y el inventario de archivos |

## Recrear la estructura

`./scaffold.sh` crea `bashkit/` con las cuatro carpetas, un `.gitkeep` en cada una y un `README.md`, dentro de la carpeta desde la que lo ejecutas. Se puede repetir sin perder lo que ya hay en las carpetas.

## Comandos

| Comando | Qué hace |
|---|---|
| `bin/bk-info` | imprime tu usuario, tus grupos, el equipo, tu home, la versión de bash y el PATH: lo primero que miras al entrar en una máquina |
| `bin/bk-run` | ejecuta un comando, lo enseña en pantalla y lo guarda en `bk-run.log` con la fecha y su código de salida; sale con el mismo código que el comando |
| `bin/bk-top-ips` | cuenta las peticiones de cada IP en un access log y enseña las N que más hacen (10 si no dices cuántas), de más a menos; ignora las líneas que no empiezan por una IP |
| `bin/bk-rename` | cambia el nombre de un archivo por uno en minúsculas, con guiones en lugar de espacios y sin tildes ni símbolos; con `--dry-run` solo enseña el cambio. No pisa un archivo que ya exista ni toca las carpetas de la ruta |
| `bin/bk-check` | comprueba que un valor es una IP v4, un email o una versión semántica (`ip`, `email` o `semver`); dice `ok` y sale con 0, o avisa en stderr y sale con 1. Con una versión, separa mayor, menor, parche y prerelease |
| `bin/bashkit` | la puerta de entrada al kit: `bashkit clean 7 logs` ejecuta `bk-clean 7 logs`, y `bashkit help` enseña los subcomandos que hay |
| `bin/bk-clean` | borra los archivos de una o varias carpetas (y sus subcarpetas) que llevan más de N días sin cambiar; con `--dry-run` solo enseña la lista. No sigue enlaces, no borra carpetas y no empieza si alguna carpeta no existe |
| `bin/bk-report` | TODO: qué resume `bk-report`, qué columnas tiene la tabla y qué log lee si no le dices ninguno |

Con `bin/` en el `PATH` basta con escribir `bashkit info` o `bk-info`: `PATH="$PWD/bin:$PATH"` desde la raíz del kit.

El log se puede cambiar con la variable `BK_LOG`: `BK_LOG=deploy.log bk-run ./deploy.sh`.

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
- Semana 09: TODO: qué aprendiste y qué te costó.
