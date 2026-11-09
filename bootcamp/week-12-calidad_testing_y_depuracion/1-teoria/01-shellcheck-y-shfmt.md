# shellcheck y shfmt: revisar sin ejecutar

Hasta ahora, la única forma de saber si un script estaba bien era ejecutarlo. Pero muchos fallos solo salen con ciertos datos: un nombre con espacios, una carpeta vacía, un archivo escrito en Windows. Esta semana añades dos revisiones que leen el script sin ejecutarlo, y tests que lo ejecutan por ti.

## shellcheck: los fallos típicos

`shellcheck script.sh` lee el script y avisa de lo que suele salir mal. Cada aviso trae un código, una gravedad y su página en el wiki (`https://www.shellcheck.net/wiki/SC2086`), que explica el porqué:

| Gravedad | Qué quiere decir |
|---|---|
| `error` | casi seguro un fallo: el script no hará lo que crees |
| `warning` | probablemente un fallo |
| `info` | una costumbre que evita fallos (con `-f gcc` sale como `note`) |
| `style` | se puede escribir mejor o más rápido |

Los que vas a ver esta semana:

| Código | Qué pasa | Arreglo |
|---|---|---|
| `SC2086` | `$var` sin comillas: se parte por los espacios | `"$var"` |
| `SC2045` | `for f in $(ls)`: los nombres con espacios se parten | un glob: `for f in carpeta/*` |
| `SC2155` | `local x=$(cmd)`: el código es el de `local`, no el de `cmd` | `local x` y después `x=$(cmd)` |
| `SC2162` | `read` sin `-r`: se come las `\` | `IFS= read -r` |
| `SC2164` | `cd` sin `\|\| exit` (si no hay `set -e`) | `cd carpeta \|\| exit` |
| `SC2016` | `$` entre comillas simples: no se expande | comillas dobles, o nada si es a propósito |
| `SC2001` | `$(echo "$x" \| sed ...)` | `${x//buscar/cambiar}` |

```bash
shellcheck script.sh              # todos los avisos, con contexto
shellcheck -f gcc script.sh       # uno por línea: archivo:línea:columna: gravedad: texto [código]
shellcheck -S warning script.sh   # solo warning y error
shellcheck -x script.sh           # sigue los source (semana 08)
```

Sale con `1` si hay algún aviso: un CI puede fallar con él.

Un aviso que no es un fallo se calla con un comentario justo encima de la línea, y siempre con el motivo. Sin motivo, quien venga después no sabrá si puede quitarlo:

```bash
# El ejemplo enseña $HOME tal cual, para quien lee el uso: no es una ruta.
# shellcheck disable=SC2016
echo 'uso: backup.sh "$HOME/datos"'
```

Para un `source` con una ruta calculada, `# shellcheck source=SCRIPTDIR/lib/core.sh` le dice dónde está el archivo, contando desde la carpeta del script.

shellcheck no lo ve todo: no sabe qué hay en tus carpetas ni en tus archivos. Un `for f in carpeta/*.txt` sin ningún `.txt`, o un `\r` de Windows al final de cada línea, solo los encuentra un test.

## shfmt: un solo estilo

`shfmt` lee el script y lo vuelve a escribir con un estilo fijo: sangrías, saltos de línea, espacios. No cambia lo que hace. Como tiene que entender el script, también avisa de los errores de sintaxis (un `if` sin `fi`), con su línea y su columna.

```bash
shfmt -d script.sh        # qué cambiaría, como un diff; sale con 1 si hay cambios
shfmt -l carpeta/         # solo los nombres de los que cambiaría (sale con 0 igualmente)
shfmt -w script.sh        # lo reescribe
shfmt -i 2 -ci -sr -d .   # el estilo del bootcamp: 2 espacios, case sangrado, "> archivo"
```

Las opciones de estilo también se pueden dejar en un `.editorconfig`, que shfmt lee cuando no le das ninguna:

```ini
[*.sh]
indent_style = space
indent_size = 2
switch_case_indent = true
space_redirects = true
```

## Antes de guardar un cambio

Las tres revisiones de esta semana, de la más rápida a la más lenta:

```bash
shfmt -i 2 -ci -sr -d bin lib   # el formato
shellcheck -x bin/* lib/*.sh    # los fallos típicos
bats tests                      # lo que hace, de verdad
```

En `bashkit`, las dos primeras las junta `bashkit lint`. La tercera, los tests, en la teoría 02.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Semana 12 — Calidad, testing y depuración](../README.md) | [Teoría — Tests con bats](02-tests-con-bats.md) → |

[↑ Semana 12](../README.md)
