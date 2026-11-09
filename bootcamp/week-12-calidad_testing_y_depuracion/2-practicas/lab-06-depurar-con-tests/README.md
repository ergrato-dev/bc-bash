# Lab 06 — Depurar con tests

⏱ Duración estimada: ~60 min

## Objetivo

Arreglar cuatro fallos de un script escribiendo antes, para cada uno, un test que lo demuestra, y usar `trap ... ERR` para saber en qué línea se para un script con `set -e`.

## Contexto

- Cuando encuentras un fallo, la tentación es arreglarlo enseguida. Pero si antes escribes un test que falla por él, ganas tres cosas: sabes que lo has entendido (el test falla por lo que crees), sabes cuándo está arreglado (el test pasa) y sabes que no vuelve (el test se queda). Es un **test de regresión**.
- `set -e` para el script en el primer comando que falla, pero no dice cuál. `trap 'comandos' ERR` ejecuta los comandos cada vez que un comando falla; con `$LINENO` y `$BASH_COMMAND` (el comando que se estaba ejecutando), dice dónde.
- `starter/load-config.sh` lee un archivo `clave=valor` y escribe cada clave con su valor. Está **roto a propósito**: con `datos/app.conf` funciona, y con los otros archivos de `datos/` pierde datos o se para sin decir nada. `starter/load-config.bats` tiene un test que pasa y cuatro TODOs.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-12-calidad_testing_y_depuracion/2-practicas/lab-06-depurar-con-tests
   ```
   (sin salida).

1. **El script, con varios archivos.** Abre `starter/load-config.sh` y `starter/load-config.bats` en tu editor.
   ```bash
   bash starter/load-config.sh datos/app.conf; echo $?
   cat datos/raro.conf
   bash starter/load-config.sh datos/raro.conf
   bash starter/load-config.sh datos/windows.conf | cat -A
   bash starter/load-config.sh datos/vacio.conf; echo $?
   ```
   ```text
   puerto -> 8080
   host -> localhost
   0
   url=https://ejemplo.com/buscar?q=bash&pagina=2
   ruta=C:\temp\logs
   url -> https://ejemplo.com/buscar?q
   ruta -> C:templogs
   puerto -> 8080^M$
   host -> localhost^M$
   1
   ```
   Cuatro problemas: la `url` se corta, la `ruta` pierde sus `\`, los valores de `windows.conf` llevan un `^M` al final (`cat -A` enseña los caracteres invisibles: `^M` es un `\r` y `$` el final de línea) y `vacio.conf` sale con `1` sin ningún aviso. Mira el test que ya hay:
   ```bash
   bats starter/load-config.bats
   ```
   ```text
   load-config.bats
    ✓ lee cada clave con su valor y se salta comentarios y líneas vacías

   1 test, 0 failures
   ```

2. **TODO 1: la barra invertida.** Empieza por lo que ve shellcheck:
   ```bash
   shellcheck starter/load-config.sh
   ```
   ```text

   In starter/load-config.sh line 9:
   grep -v -e '^#' -e '^$' "$file" | while read line; do
                                           ^--^ SC2162 (info): read without -r will mangle backslashes.

   For more information:
     https://www.shellcheck.net/wiki/SC2162 -- read without -r will mangle backs...
   ```
   Antes de arreglarlo, el test. Cambia el comentario del `TODO 1` de `starter/load-config.bats` por:
   ```bash
   @test "una barra invertida en el valor llega tal cual" {
     printf 'ruta=C:\\temp\\logs\n' > raro.conf
     run -0 bash "$load_config" raro.conf
     [[ $output == 'ruta -> C:\temp\logs' ]]
   }
   ```
   `printf` cambia cada `\\` por una `\`: el archivo tiene `ruta=C:\temp\logs`. Prueba:
   ```bash
   bats starter/load-config.bats
   ```
   ```text
   load-config.bats
    ✓ lee cada clave con su valor y se salta comentarios y líneas vacías
    ✗ una barra invertida en el valor llega tal cual
      (in test file starter/load-config.bats, line 22)
        `[[ $output == 'ruta -> C:\temp\logs' ]]' failed

   2 tests, 1 failure
   ```
   Falla por lo que esperabas. Ahora el arreglo: en `starter/load-config.sh`, cambia `while read line; do` por `while IFS= read -r line; do` (semana 07: `-r` deja las `\` tal cual, e `IFS=` los espacios del principio y del final). Prueba:
   ```bash
   bats starter/load-config.bats
   ```
   ```text
   load-config.bats
    ✓ lee cada clave con su valor y se salta comentarios y líneas vacías
    ✓ una barra invertida en el valor llega tal cual

   2 tests, 0 failures
   ```

3. **TODO 2: un `=` en el valor.** El test primero. Cambia el comentario del `TODO 2` por:
   ```bash
   @test "un valor con = dentro llega entero" {
     echo 'url=https://ejemplo.com/buscar?q=bash&pagina=2' > url.conf
     run -0 bash "$load_config" url.conf
     [[ $output == 'url -> https://ejemplo.com/buscar?q=bash&pagina=2' ]]
   }
   ```
   ```bash
   bats starter/load-config.bats
   ```
   ```text
   load-config.bats
    ✓ lee cada clave con su valor y se salta comentarios y líneas vacías
    ✓ una barra invertida en el valor llega tal cual
    ✗ un valor con = dentro llega entero
      (in test file starter/load-config.bats, line 28)
        `[[ $output == 'url -> https://ejemplo.com/buscar?q=bash&pagina=2' ]]' failed

   3 tests, 1 failure
   ```
   `cut -d= -f2` se queda con el segundo trozo entre `=`, y la `url` tiene tres. Cambia las dos líneas de `cut` por:
   ```bash
     # Hasta el primer = es la clave; todo lo demás, el valor, aunque lleve más =.
     key="${line%%=*}"
     value="${line#*=}"
   ```
   `${line%%=*}` quita desde el primer `=` hasta el final; `${line#*=}`, desde el principio hasta el primer `=` (semana 05). Además, ya no lanza dos `echo | cut` por línea (lab 07). Prueba:
   ```bash
   bats starter/load-config.bats
   ```
   ```text
   load-config.bats
    ✓ lee cada clave con su valor y se salta comentarios y líneas vacías
    ✓ una barra invertida en el valor llega tal cual
    ✓ un valor con = dentro llega entero

   3 tests, 0 failures
   ```

4. **TODO 3: fin de línea de Windows.** Los editores de Windows acaban cada línea con dos caracteres, `\r\n`; Linux solo con `\n`. `read` se queda con el `\r` como parte de la línea. El test primero. Cambia el comentario del `TODO 3` por:
   ```bash
   @test "un archivo con fin de línea de Windows da los mismos valores" {
     printf 'puerto=8080\r\nhost=localhost\r\n' > windows.conf
     run -0 bash "$load_config" windows.conf
     [[ ${lines[0]} == "puerto -> 8080" ]]
     [[ ${lines[1]} == "host -> localhost" ]]
   }
   ```
   ```bash
   bats starter/load-config.bats
   ```
   ```text
   load-config.bats
    ✓ lee cada clave con su valor y se salta comentarios y líneas vacías
    ✓ una barra invertida en el valor llega tal cual
    ✓ un valor con = dentro llega entero
    ✗ un archivo con fin de línea de Windows da los mismos valores
      (in test file starter/load-config.bats, line 34)
        `[[ ${lines[0]} == "puerto -> 8080" ]]' failed

   4 tests, 1 failure
   ```
   Añade, como primera línea dentro del bucle:
   ```bash
     # Un archivo escrito en Windows acaba cada línea en \r\n: el \r se quedaría en el valor.
     line="${line%$'\r'}"
   ```
   `$'\r'` es el carácter `\r` (las comillas `$'...'` entienden `\r`, `\n`, `\t`), y `%` lo quita del final si está. Prueba:
   ```bash
   bats starter/load-config.bats
   ```
   ```text
   load-config.bats
    ✓ lee cada clave con su valor y se salta comentarios y líneas vacías
    ✓ una barra invertida en el valor llega tal cual
    ✓ un valor con = dentro llega entero
    ✓ un archivo con fin de línea de Windows da los mismos valores

   4 tests, 0 failures
   ```

5. **TODO 4: se para sin decir nada.** El test primero. Cambia el comentario del `TODO 4` por:
   ```bash
   @test "un archivo con solo comentarios sale con 0 y no escribe nada" {
     printf '# nada todavía\n# puerto=8080\n' > vacio.conf
     run -0 bash "$load_config" vacio.conf
     [[ -z $output ]]
   }
   ```
   ```bash
   bats starter/load-config.bats
   ```
   Termina así:
   ```text
    ✗ un archivo con solo comentarios sale con 0 y no escribe nada
      (in test file starter/load-config.bats, line 40)
        `run -0 bash "$load_config" vacio.conf' failed, expected exit code 0, got 1

   5 tests, 1 failure
   ```
   Sale con `1` y no escribe nada: ¿qué comando falló? Añade debajo de `set -euo pipefail`:
   ```bash

   # Si algo falla, di dónde: set -e para el script sin explicar nada, y esta línea dice cuál
   # y con qué comando. Comillas simples: $LINENO y $BASH_COMMAND se leen al fallar, no ahora.
   trap 'echo "load-config.sh: falló la línea $LINENO: $BASH_COMMAND" >&2' ERR
   ```
   Prueba:
   ```bash
   bash starter/load-config.sh datos/vacio.conf; echo "código: $?"
   ```
   ```text
   load-config.sh: falló la línea 13: grep -v -e '^#' -e '^$' "$file"
   código: 1
   ```
   `grep` sale con `1` cuando no escribe ninguna línea, y con `pipefail` el pipe entero falla (semana 11). Un archivo sin claves no es un error. Cambia el principio de la línea del pipe, `grep -v -e '^#' -e '^$' "$file" | while`, por:
   ```bash
   # grep sale con 1 si no queda ninguna línea (un archivo con solo comentarios), y con pipefail
   # pararía el script. Un archivo sin claves no es un error: || true lo convierte en "nada".
   { grep -v -e '^#' -e '^$' "$file" || true; } | while
   ```
   (el resto de la línea, `IFS= read -r line; do`, igual). Pero `|| true` también calla el `2` de `grep` cuando el archivo no existe. Compruébalo antes, debajo de la línea `file=...`:
   ```bash
   [[ -r $file ]] || { echo "load-config.sh: no puedo leer '$file'" >&2; exit 1; }
   ```
   Prueba:
   ```bash
   bats starter/load-config.bats
   bash starter/load-config.sh datos/raro.conf
   bash starter/load-config.sh no-existe; echo "código: $?"
   ```
   ```text
   load-config.bats
    ✓ lee cada clave con su valor y se salta comentarios y líneas vacías
    ✓ una barra invertida en el valor llega tal cual
    ✓ un valor con = dentro llega entero
    ✓ un archivo con fin de línea de Windows da los mismos valores
    ✓ un archivo con solo comentarios sale con 0 y no escribe nada

   5 tests, 0 failures
   url -> https://ejemplo.com/buscar?q=bash&pagina=2
   ruta -> C:\temp\logs
   load-config.sh: no puedo leer 'no-existe'
   código: 1
   ```
   El `trap` se queda en el script: si algún día falla otro comando, dirá cuál.

6. **shellcheck.**
   ```bash
   shellcheck starter/load-config.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Cada test de los TODOs falló antes de su arreglo y pasa después (pasos 2 a 5)
- [ ] Explicas qué escriben `$LINENO` y `$BASH_COMMAND` dentro del `trap ... ERR` (paso 5)
- [ ] Explicas por qué hizo falta el `[[ -r $file ]]` al añadir el `|| true` (paso 5)
- [ ] `bats starter/load-config.bats` termina con `5 tests, 0 failures` (paso 5)
- [ ] `shellcheck starter/load-config.sh` no imprime nada

## Reto extra

Con `windows.conf` y una línea vacía en medio (`printf 'a=1\r\n\r\nb=2\r\n'`), el script escribe una línea ` -> ` de más: la línea vacía tiene un `\r` y `grep -v '^$'` no la quita. Escribe primero el test y después el arreglo. ¿Dónde es mejor quitar los `\r`, en el bucle o antes del `grep`?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 05 — La traza: set -x, PS4 y BASH_XTRACEFD](../lab-05-traza-con-set-x/README.md) | [Lab 07 — Rendimiento: subshells y builtins](../lab-07-rendimiento-subshells-y-builtins/README.md) → |

[↑ Semana 12](../../README.md)
