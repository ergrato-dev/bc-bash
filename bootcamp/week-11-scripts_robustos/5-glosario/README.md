# Glosario — Semana 11

| Término | Definición en una línea | Ejemplo |
|---------|-------------------------|---------|
| `set -e` (errexit) | Para el script cuando un comando falla, salvo en condiciones (`if`, `\|\|`, `&&`) y lo que se llama desde ellas | `set -euo pipefail` |
| `mktemp` | Crea un archivo (o con `-d`, una carpeta) temporal con un nombre nuevo, solo para ti, y escribe su ruta | `work="$(mktemp -d)"` |
| `TMPDIR` | Variable que dice a `mktemp` en qué carpeta crear los temporales (`/tmp` si no existe) | `TMPDIR=$PWD/tmp ./script.sh` |
| `trap` | Deja apuntados unos comandos para cuando llegue una señal | `trap 'rm -rf -- "$work"' EXIT` |
| `EXIT` | Señal propia de bash que llega al terminar el script, de cualquier forma salvo con `KILL` | `trap 'echo adiós' EXIT` |
| Señal | Aviso del sistema a un proceso; si lo mata, el código es 128 + su número | `kill -l 15` escribe `TERM` |
| `INT` / `TERM` / `KILL` | `Ctrl-C` (130) / la petición normal de parar (143) / matar sin aviso, no se puede atrapar (137) | `kill -TERM "$pid"` |
| `getopts` | Builtin que lee una opción por vuelta de un `while`; `:` detrás de una letra pide un valor | `while getopts ":ql:h" opt; do` |
| `OPTARG` | El valor de la opción que acaba de leer `getopts`, o la letra que falló | `l) log="$OPTARG" ;;` |
| `OPTIND` | Posición del siguiente argumento por leer; tras el bucle, `shift` quita las opciones | `shift $((OPTIND - 1))` |
| `flock` | Bloquea un archivo abierto: solo un proceso a la vez; `-n` no espera, `-w N` espera N segundos | `flock -n informe.lock ./informe.sh` |
| `exec {fd}>` | Abre un archivo en un descriptor libre y guarda su número en la variable | `exec {lock_fd}>> "$log"` |
| Nivel de log | Importancia de un aviso (`debug`, `info`, `warn`, `error`); una variable elige desde cuál se escribe | `BK_LOG_LEVEL=debug bk-run ls` |
| Idempotente | Que ejecutarlo una vez o varias deja lo mismo, sin errores ni duplicados | `mkdir -p logs` |
| `ln -sfn` | Crea un enlace simbólico o lo cambia de destino sin entrar en la carpeta a la que apuntaba | `ln -sfn releases/v2 current` |

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Recursos — web](../4-recursos/webgrafia/README.md) | — |

[↑ Semana 11](../README.md)
