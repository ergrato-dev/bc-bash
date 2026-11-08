# Lab 06 — Argumentos

⏱ Duración estimada: ~60 min

## Objetivo

Leer los argumentos de un script con `$1`, `$#`, `"$@"` y `shift`, y pasarlos a otro comando sin romper los que tienen espacios.

## Contexto

- Lo que escribes detrás del nombre de un script llega en `$1`, `$2`...; `$#` dice cuántos hay y `"$@"` los da todos, cada uno como llegó ([teoría](../../1-teoria/04-regex-y-argumentos.md)).
- `$*` y `$@` sin comillas juntan los argumentos y los vuelven a partir por los espacios: es el word splitting de la semana 05.
- `starter/show-args.sh` ya está hecho: enseña los argumentos que recibe. `starter/make-files.sh` crea archivos vacíos y viene **roto a propósito**: con un nombre con espacios crea dos archivos. Tiene cuatro TODOs.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-06-condicionales_case_y_regex/2-practicas/lab-06-argumentos
   ```
   (sin salida).

1. **Qué recibe un script.** `$0` es el nombre con el que se llamó; `$#`, el número de argumentos. `printf` repite su formato por cada argumento: `printf 'arg: [%s]\n' "$@"` imprime una línea por argumento, entre corchetes para que se vean los espacios:
   ```bash
   ./starter/show-args.sh uno dos tres
   ./starter/show-args.sh "informe final.txt" otro
   ```
   ```text
   script: ./starter/show-args.sh
   argumentos: 3
   arg: [uno]
   arg: [dos]
   arg: [tres]
   script: ./starter/show-args.sh
   argumentos: 2
   arg: [informe final.txt]
   arg: [otro]
   ```
   Las comillas al escribir el comando deciden dónde acaba cada argumento; el script las recibe ya quitadas.

2. **Sin argumentos.**
   ```bash
   ./starter/show-args.sh
   ```
   ```text
   script: ./starter/show-args.sh
   argumentos: 0
   arg: []
   ```
   Con cero argumentos, `printf` usa el formato una vez, con el hueco vacío. Por eso un script mira `$#` antes de usar sus argumentos.

3. **Uno a uno.** `bash -c 'código' nombre a b c` ejecuta el código con `nombre` como `$0` y `a b c` como argumentos: sirve para probar sin crear un archivo.
   ```bash
   bash -c 'echo "primero: $1, segundo: $2, total: $#"' show a b c
   ```
   ```text
   primero: a, segundo: b, total: 3
   ```

4. **`"$@"`, `$@` y `"$*"`.** El mismo trío de argumentos, `x` como `$0`, `a b` y `c`:
   ```bash
   bash -c 'printf "[%s]\n" "$@"' x 'a b' c
   bash -c 'printf "[%s]\n" $@' x 'a b' c
   bash -c 'printf "[%s]\n" "$*"' x 'a b' c
   ```
   ```text
   [a b]
   [c]
   [a]
   [b]
   [c]
   [a b c]
   ```
   `"$@"` da dos argumentos, tal como llegaron. `$@` sin comillas los parte: tres. `"$*"` los une en uno solo, con espacios. Para pasar los argumentos a otro comando, siempre `"$@"`.

5. **`shift`.** Quita el primer argumento: `$2` pasa a ser `$1` y `$#` baja en uno. Sirve para leer una opción y quedarte con el resto:
   ```bash
   bash -c 'echo "$1"; shift; echo "$1 (quedan $#)"' x uno dos tres
   ```
   ```text
   uno
   dos (quedan 2)
   ```

6. **Del 10 en adelante, con llaves.** `$10` es `$1` seguido de un `0`:
   ```bash
   bash -c 'echo "${10}" "$10"' x a b c d e f g h i j
   ```
   ```text
   j a0
   ```

7. **El script, sin tocar.** Trabaja en una carpeta de pruebas, `zona/`, que git ignora:
   ```bash
   mkdir zona && cd zona
   ../starter/make-files.sh "informe final.txt"
   ls
   rm informe final.txt
   ```
   ```text
   final.txt
   informe
   ```
   Un nombre, dos archivos. El `rm` los borra para seguir.

8. **TODO 3.** Empieza por el fallo. Abre `starter/make-files.sh` en tu editor y cambia `touch $*` por `touch -- "$@"`. `--` marca el final de las opciones (semana 05): un nombre como `-r` no se toma por una. Borra el comentario del `TODO 3`. Prueba:
   ```bash
   ../starter/make-files.sh "informe final.txt"; ls
   ../starter/make-files.sh -v uno.txt; ls
   ```
   ```text
   informe final.txt
   -v
   informe final.txt
   uno.txt
   ```
   Un nombre con espacios, un archivo. Pero `-v` todavía no es una opción del script: con el `--`, `touch` creó un archivo llamado `-v`. Bórralo con `rm -- -v` (sin el `--`, `rm` lo tomaría por su opción `-v`).

9. **TODO 1.** Sustituye el comentario del `TODO 1` por un `case` (lab 04) que mire el primer argumento. Si es `-v`, guarda `1` en `verbose` y quítalo con `shift`. `${1:-}` evita el error de `set -u` cuando no hay ninguno:
   ```bash
   case "${1:-}" in
     -v)
       verbose=1
       shift
       ;;
   esac
   ```
   Prueba:
   ```bash
   ../starter/make-files.sh -v dos.txt; ls
   ```
   ```text
   dos.txt
   informe final.txt
   uno.txt
   ```
   Ya no aparece un archivo `-v`.

10. **TODO 2.** Sin argumentos, ahora es `touch` quien se queja:
    ```bash
    ../starter/make-files.sh; echo $?
    ```
    ```text
    touch: missing file operand
    Try 'touch --help' for more information.
    1
    ```
    Sustituye el comentario del `TODO 2` por un `if` que, si `$#` es `0` (`-eq`, "igual a"), escriba `uso: make-files.sh [-v] <archivo>...` en stderr y salga con `2`. Va después del `case`, para que `-v` solo tampoco valga. Prueba:
    ```bash
    ../starter/make-files.sh; echo $?
    ../starter/make-files.sh -v; echo $?
    ```
    ```text
    uso: make-files.sh [-v] <archivo>...
    2
    uso: make-files.sh [-v] <archivo>...
    2
    ```

11. **TODO 4.** Con `-v`, di qué se ha creado. Sustituye el comentario del `TODO 4` por un `if` con `[[ -n $verbose ]]` (lab 02) y, dentro, `printf 'creado: %s\n' "$@"`. Prueba:
    ```bash
    ../starter/make-files.sh -v "acta 1.txt" acta-2.txt
    ../starter/make-files.sh tres.txt
    ```
    ```text
    creado: acta 1.txt
    creado: acta-2.txt
    ```
    Sin `-v`, `tres.txt` se crea en silencio. Para terminar: `cd .. && rm -r zona`.

## Criterios de éxito

- [ ] Explicas la diferencia entre `"$@"`, `$@` y `"$*"` con el ejemplo del paso 4
- [ ] Explicas por qué `$10` no es el décimo argumento (paso 6)
- [ ] `make-files.sh "informe final.txt"` crea un solo archivo
- [ ] `make-files.sh -v "acta 1.txt" acta-2.txt` imprime dos líneas `creado: ...`, y sin argumentos sale con `2`

## Reto extra

Haz que el script acepte también `--verbose` como `-v`, con un `|` en el patrón del `case`. ¿Qué pasa con `make-files.sh -x a.txt`? Añade una rama `-*)` que avise de una opción desconocida y salga con `2`. ¿Cómo crearías entonces un archivo llamado `-x`?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 05 — Regex y BASH_REMATCH](../lab-05-regex-y-bash-rematch/README.md) | [Lab 07 — Condiciones rotas](../lab-07-condiciones-rotas/README.md) → |

[↑ Semana 06](../../README.md)
