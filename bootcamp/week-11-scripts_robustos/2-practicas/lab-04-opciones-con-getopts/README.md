# Lab 04 — Opciones con getopts

⏱ Duración estimada: ~60 min

## Objetivo

Leer las opciones de un script con `getopts` (con y sin valor, juntas o separadas) y avisar de las que no existen o les falta su valor.

## Contexto

- Las opciones son los argumentos que empiezan por `-`: `ls -l -a`, `ls -la`, `head -n 3`, `head -n3`. Leerlas a mano con `if [[ $1 == ... ]]` y `shift` funciona para una o dos (semana 07), pero no para `-la` ni para cualquier orden.
- `getopts` es un builtin de bash: en cada vuelta de un `while`, deja la siguiente opción en una variable. Solo entiende opciones de una letra; las largas (`--count`) no.
- `starter/grep-log.sh` busca un texto en un log y tiene que aceptar `-i` (sin distinguir mayúsculas), `-c` (solo cuántas líneas), `-n N` (solo las últimas N) y `-h` (ayuda). La búsqueda ya está escrita: faltan las opciones. `datos/app.log` tiene siete líneas de una aplicación.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-11-scripts_robustos/2-practicas/lab-04-opciones-con-getopts
   ```
   (sin salida).

1. **Una vuelta por opción.** `"ab:"` es la lista de opciones: `-a` y `-b`, que lleva un valor (los dos puntos). Lo que va detrás de `bash -c '...'` son los argumentos: el primero (`_`) es el nombre del script, `$0`, y el resto llega como `$1`, `$2`...
   ```bash
   bash -c 'while getopts "ab:" opt; do echo "opt=$opt OPTARG=${OPTARG:-} OPTIND=$OPTIND"; done; shift $((OPTIND - 1)); echo "queda: $*"' _ -a -b valor resto -a
   ```
   ```text
   opt=a OPTARG= OPTIND=2
   opt=b OPTARG=valor OPTIND=4
   queda: resto -a
   ```
   `opt` es la letra; `OPTARG`, el valor de las que llevan; `OPTIND`, la posición del siguiente argumento por leer. `getopts` para en `resto`, lo primero que no es una opción: el último `-a` ya no es suyo. `shift $((OPTIND - 1))` quita lo leído y deja en `$@` el resto.

2. **Juntas, pegadas y mal escritas.**
   ```bash
   bash -c 'while getopts "ab:" opt; do echo "opt=$opt OPTARG=${OPTARG:-}"; done' _ -ab3 -z -b
   ```
   ```text
   opt=a OPTARG=
   opt=b OPTARG=3
   opt=? OPTARG=
   opt=? OPTARG=
   _: illegal option -- z
   _: option requires an argument -- b
   ```
   `-ab3` son `-a` y `-b 3`. Con `-z` (no está en la lista) y con `-b` sin valor, `opt` vale `?` y `getopts` avisa en inglés. Con dos puntos al principio de la lista (`":ab:"`), se calla y deja la información para ti:
   ```bash
   bash -c 'while getopts ":ab:" opt; do echo "opt=$opt OPTARG=${OPTARG:-}"; done' _ -z -b
   ```
   ```text
   opt=? OPTARG=z
   opt=: OPTARG=b
   ```
   `?`: opción desconocida, y `OPTARG` dice cuál. `:`: le falta el valor, y `OPTARG` dice a cuál.

3. **El script, tal cual.** Abre `starter/grep-log.sh` en tu editor.
   ```bash
   bash starter/grep-log.sh ERROR datos/app.log
   bash starter/grep-log.sh -c ERROR datos/app.log; echo $?
   ```
   ```text
   2026-11-09T08:15:02 ERROR timeout al llamar a pagos
   2026-11-09T08:31:17 ERROR disco al 95%
   uso: grep-log.sh [-i] [-c] [-n N] <texto> <log>
   2
   ```
   Con `-c` hay tres argumentos y el script espera dos.

4. **TODO 1: `-i`, `-c` y `-h`.** Cambia el comentario del `TODO 1` por:
   ```bash
   while getopts "ich" opt; do
     case "$opt" in
       i) ignore_case=1 ;;
       c) count_only=1 ;;
       h)
         echo "$usage"
         exit 0
         ;;
     esac
   done
   ```
   Prueba:
   ```bash
   bash starter/grep-log.sh -c ERROR datos/app.log; echo $?
   bash starter/grep-log.sh -h; echo $?
   ```
   ```text
   uso: grep-log.sh [-i] [-c] [-n N] <texto> <log>
   2
   uso: grep-log.sh [-i] [-c] [-n N] <texto> <log>
   0
   ```
   `-h` ya va (y sale con 0: pedir ayuda no es un error). `-c` se lee, pero sigue en `$@`: `$1` es `-c`.

5. **TODO 2: el `shift`.** Cambia el comentario del `TODO 2` por:
   ```bash
   shift $((OPTIND - 1))
   ```
   Prueba:
   ```bash
   bash starter/grep-log.sh -c ERROR datos/app.log
   bash starter/grep-log.sh -ic error datos/app.log
   bash starter/grep-log.sh -i error datos/app.log
   bash starter/grep-log.sh -c -- -z datos/app.log
   ```
   ```text
   2
   3
   2026-11-09T08:15:02 ERROR timeout al llamar a pagos
   2026-11-09T08:15:09 error reintento de pagos fallido
   2026-11-09T08:31:17 ERROR disco al 95%
   0
   ```
   `--` termina las opciones: `-z` es el texto que se busca (no aparece, 0 líneas).

6. **TODO 3: `-n N`.** Antes:
   ```bash
   bash starter/grep-log.sh -n 2 ERROR datos/app.log; echo $?
   ```
   ```text
   starter/grep-log.sh: illegal option -- n
   uso: grep-log.sh [-i] [-c] [-n N] <texto> <log>
   2
   ```
   Cambia `"ich"` por `"icn:h"`, borra el comentario del `TODO 3` y añade al `case`, debajo de la línea de `c)`:
   ```bash
       n)
         [[ $OPTARG =~ ^[1-9][0-9]*$ ]] || { echo "grep-log.sh: -n necesita un número, no '$OPTARG'" >&2; exit 2; }
         last="$OPTARG"
         ;;
   ```
   `getopts` no comprueba qué valor llega: eso es cosa tuya (semana 06). Prueba:
   ```bash
   bash starter/grep-log.sh -n 1 INFO datos/app.log
   bash starter/grep-log.sh -in1 error datos/app.log
   bash starter/grep-log.sh -n dos INFO datos/app.log; echo $?
   bash starter/grep-log.sh -x INFO datos/app.log; echo $?
   bash starter/grep-log.sh -n; echo $?
   ```
   ```text
   2026-11-09T08:20:00 INFO 120 peticiones en el último minuto
   2026-11-09T08:31:17 ERROR disco al 95%
   grep-log.sh: -n necesita un número, no 'dos'
   2
   starter/grep-log.sh: illegal option -- x
   2026-11-09T08:00:01 INFO servidor arrancado en el puerto 8080
   2026-11-09T08:00:05 INFO conexión con la base de datos
   2026-11-09T08:20:00 INFO 120 peticiones en el último minuto
   0
   starter/grep-log.sh: option requires an argument -- n
   uso: grep-log.sh [-i] [-c] [-n N] <texto> <log>
   2
   ```
   `-in1` son `-i` y `-n 1`. Pero `-x` avisa en inglés y el script sigue como si nada, y salió con 0. Falta el TODO 4.

7. **TODO 4: los errores.** Pon dos puntos al principio de la lista (`":icn:h"`), borra el comentario del `TODO 4` y añade al final del `case`, después de `h)`:
   ```bash
       :)
         echo "grep-log.sh: a -$OPTARG le falta su valor" >&2
         exit 2
         ;;
       *)
         echo "grep-log.sh: opción desconocida: -$OPTARG" >&2
         echo "$usage" >&2
         exit 2
         ;;
   ```
   `*` y no `\?`: en un `case`, `?` es un patrón que encaja con cualquier letra, y `*` recoge todo lo que no encajó antes. Explica en comentarios para qué son los dos puntos del principio y el `shift`. Prueba:
   ```bash
   bash starter/grep-log.sh -x INFO datos/app.log; echo $?
   bash starter/grep-log.sh -n; echo $?
   bash starter/grep-log.sh -c "95%" datos/app.log
   ```
   ```text
   grep-log.sh: opción desconocida: -x
   uso: grep-log.sh [-i] [-c] [-n N] <texto> <log>
   2
   grep-log.sh: a -n le falta su valor
   2
   1
   ```

8. **Las opciones, delante.**
   ```bash
   bash starter/grep-log.sh INFO datos/app.log -n 1; echo $?
   ```
   ```text
   uso: grep-log.sh [-i] [-c] [-n N] <texto> <log>
   2
   ```
   `getopts` para en `INFO`, y `-n 1` se quedan como argumentos sobrantes. Así funcionan casi todos los comandos de bash; los de GNU (`ls`, `grep`) reordenan los argumentos y aceptan opciones al final, pero no cuentes con ello en tus scripts.

9. **shellcheck.**
   ```bash
   shellcheck starter/grep-log.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas qué valen `opt`, `OPTARG` y `OPTIND` en cada vuelta del paso 1
- [ ] Explicas qué cambian los dos puntos del principio de la lista (paso 2)
- [ ] `bash starter/grep-log.sh -ic error datos/app.log` imprime `3` (paso 5)
- [ ] `bash starter/grep-log.sh -x INFO datos/app.log` avisa en stderr y sale con `2` (paso 7)
- [ ] `shellcheck starter/grep-log.sh` no imprime nada

## Reto extra

Añade `-v`, que enseña las líneas que **no** contienen el texto (`grep -v`). ¿Qué tiene que hacer el script con `-v -c` juntas? Pruébalo con `grep -vc INFO datos/app.log`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 03 — Señales: INT, TERM y KILL](../lab-03-senales-int-y-term/README.md) | [Lab 05 — Bloqueo con flock](../lab-05-bloqueo-con-flock/README.md) → |

[↑ Semana 11](../../README.md)
