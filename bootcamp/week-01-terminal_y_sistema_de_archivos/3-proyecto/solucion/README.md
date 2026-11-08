# bashkit

Mi CLI de operaciones en bash: la empiezo como un árbol de carpetas y crece cada semana del bootcamp hasta hacer backups de PostgreSQL en Docker.

## Estructura

| Carpeta | Para qué sirve |
|---|---|
| `bin/` | los comandos del kit, uno por archivo (`bk-info`, `bk-run`...) |
| `lib/` | funciones compartidas que cargan los comandos |
| `tests/` | pruebas automáticas del kit |
| `docs/` | documentación: el mapa del kit y el inventario de archivos |

## Recrear la estructura

`bash scaffold.sh` crea `bashkit/` con las cuatro carpetas, un `.gitkeep` en cada una y un `README.md`, dentro de la carpeta desde la que lo ejecutas. Se puede repetir sin perder lo que ya hay en las carpetas.

## Bitácora

- Semana 01: aprendí a moverme por el árbol con rutas relativas y absolutas, a crear, mover y borrar archivos, y a listar el kit con `find`. Lo que más me costó: acordarme de que `rm` no tiene papelera.
