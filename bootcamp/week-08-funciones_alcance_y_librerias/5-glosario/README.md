# Glosario — Semana 08

| Término | Definición en una línea | Ejemplo |
|---------|-------------------------|---------|
| Función | Bloque de comandos con nombre que se llama como un comando | `greet() { echo "hola, $1"; }` |
| `main "$@"` | Llamada a la función principal en la última línea, con los argumentos del script | `main "$@"` |
| Argumentos de función | `$1`, `$#` y `"$@"` dentro de una función: los de la llamada, no los del script | `show uno` → `$#` vale `1` |
| `return` | Termina la función con un código de 0 a 255; el script sigue | `[[ -f $1 ]] \|\| return 1` |
| `exit` en una función | Termina el script entero, no solo la función | `die() { log "$1"; exit "${2:-1}"; }` |
| Alcance | La parte del script que ve una variable; en bash, por defecto, todo el script | `f() { x=1; }; f; echo "$x"` → `1` |
| `local` | Hace que una variable solo exista mientras dura la función | `local i` |
| Alcance dinámico | Las funciones llamadas ven las `local` de la función que las llama | `caller() { local y=1; show; }` |
| `declare -n` / `local -n` | Referencia: otro nombre para la variable que se llama como su valor | `local -n out_host=$2` |
| Librería | Archivo que solo define funciones y se carga con `source`, sin shebang ni bit de ejecución | `lib/core.sh` |
| `source` / `.` | Lee un archivo dentro de la shell actual, como si sus líneas estuvieran escritas ahí | `source lib/strings.sh` |
| `BASH_SOURCE` | Array con la ruta del archivo que se está ejecutando o cargando; `[0]` es el actual | `dirname "${BASH_SOURCE[0]}"` |
| `command -v` | Imprime la ruta de un comando y sale con `0`, o sale con `1` si no existe | `command -v find > /dev/null` |
| Dispatcher | Script que recibe un subcomando y lo reparte a su función o a su script | `bashkit clean 7 logs` |
| `exec` | Sustituye el proceso actual por otro programa, sin volver | `exec "$bin_dir/bk-$sub" "$@"` |

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Recursos — web](../4-recursos/webgrafia/README.md) | — |

[↑ Semana 08](../README.md)
