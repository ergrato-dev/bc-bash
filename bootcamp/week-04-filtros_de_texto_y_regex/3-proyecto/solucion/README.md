# bashkit

Mi CLI de operaciones en bash: la empiezo como un árbol de carpetas y crece cada semana del bootcamp hasta hacer backups de PostgreSQL en Docker.

## Estructura

| Carpeta | Para qué sirve |
|---|---|
| `bin/` | los comandos del kit, uno por archivo (`bk-info`, `bk-run`, `bk-top-ips`...) |
| `lib/` | funciones compartidas que cargan los comandos |
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

Con `bin/` en el `PATH` basta con escribir `bk-info`: `PATH="$PWD/bin:$PATH"` desde la raíz del kit.

El log se puede cambiar con la variable `BK_LOG`: `BK_LOG=deploy.log bk-run ./deploy.sh`.

Para probar `bk-top-ips` con datos reales: `bk-top-ips /var/log/nginx/access.log 5`.

## Bitácora

- Semana 01: aprendí a moverme por el árbol con rutas relativas y absolutas, a crear, mover y borrar archivos, y a listar el kit con `find`. Lo que más me costó: acordarme de que `rm` no tiene papelera.
- Semana 02: aprendí a leer y cambiar permisos con `chmod`, a ver y parar procesos con `ps` y `kill`, y a convertir un archivo en un comando con el shebang, el bit de ejecución y el `PATH`. Lo que más me costó: entender que una variable sin `export` no llega a los programas que lanzo.
- Semana 03: aprendí a separar la salida de los errores con `>`, `2>` y `2>&1`, a encadenar comandos con pipes y `tee`, a leer el código de salida con `$?` y a parar un script al primer fallo con `set -euo pipefail`. Lo que más me costó: entender que el orden de `> archivo 2>&1` importa.
- Semana 04: aprendí a filtrar texto con `grep`, `cut`, `sort`, `uniq` y `tr`, a escribir expresiones regulares básicas y extendidas y a buscar archivos con `find`. Lo que más me costó: acordarme de que `uniq -c` solo junta líneas seguidas y necesita un `sort` antes.
