# Glosario — Semana 12

| Término | Definición en una línea | Ejemplo |
|---------|-------------------------|---------|
| Linter | Programa que lee código sin ejecutarlo y avisa de fallos típicos | `shellcheck script.sh` |
| `shellcheck` | El linter de bash: cada aviso trae un código, una gravedad y su página en el wiki | `shellcheck -f gcc -S warning script.sh` |
| `# shellcheck disable=` | Comentario que calla un aviso en la línea de debajo; siempre con el motivo encima | `# shellcheck disable=SC2016` |
| `shfmt` | Reescribe un script con un estilo fijo de sangrías y espacios, sin cambiar lo que hace | `shfmt -i 2 -ci -sr -d script.sh` |
| `.editorconfig` | Archivo con el estilo de una carpeta, que leen shfmt y muchos editores | `indent_size = 2` |
| `bats` | Ejecuta archivos `.bats` de tests: cada `@test` pasa si ninguna de sus líneas falla | `bats tests` |
| `run` | En bats, ejecuta un comando sin parar el test y guarda su código y su salida | `run -1 bk-check ip 1.2.3.256` |
| `$status` / `$output` / `$lines` | Lo que guarda `run`: el código, la salida entera y la salida por líneas | `[[ ${lines[0]} == "ok" ]]` |
| `setup` / `teardown` | Funciones que bats ejecuta antes y después de cada test (`teardown`, también si falla) | `setup() { cd "$BATS_TEST_TMPDIR"; }` |
| `$BATS_TEST_TMPDIR` | Carpeta vacía que bats crea para cada test y borra al terminar | `cd "$BATS_TEST_TMPDIR" \|\| return` |
| Test de regresión | Test que comprueba un fallo ya arreglado; se escribe antes del arreglo y tiene que fallar con él | `@test "cuenta los códigos de tres cifras"` |
| `set -x` (xtrace) | Escribe cada línea antes de ejecutarla, con las variables ya cambiadas por su valor | `bash -x script.sh` |
| `PS4` | Lo que va delante de cada línea de la traza; con comillas simples se calcula en cada una | `PS4='+ ${LINENO}: '` |
| `BASH_XTRACEFD` | Descriptor al que escribe `set -x`: abierto en un archivo, la traza no se mezcla con stderr | `exec {BASH_XTRACEFD}> traza.txt` |
| Builtin | Comando que va dentro de bash (`printf`, `read`, `[[`) y no crea un proceso | `printf -v x '%05d' "$n"` |

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Recursos — web](../4-recursos/webgrafia/README.md) | — |

[↑ Semana 12](../README.md)
