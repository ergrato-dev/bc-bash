# Lab 03 — Primeros tests con bats

⏱ Duración estimada: ~60 min

## Objetivo

Escribir tests con bats que ejecutan un script con `run` y comprueban su código, su salida y cada línea, y usar un test que falla para encontrar y arreglar un fallo.

## Contexto

- Probar un script a mano funciona una vez. Cuando lo cambies, tendrás que acordarte de repetir todas las pruebas, y no lo harás. Un **test** es una prueba escrita en un archivo: se repite entera con un comando, siempre igual.
- **bats** (*Bash Automated Testing System*) ejecuta archivos `.bats`. Cada `@test "nombre" { ... }` es un test: un bloque de bash que pasa si ninguna de sus líneas falla. Para comprobar algo, se escribe un `[[ ]]`: si no se cumple, el test falla y bats dice en qué línea.
- `starter/slugify.sh` convierte títulos en *slugs*, el nombre que va en una URL: `Hola Mundo!` da `hola-mundo`. `starter/slugify.bats` tiene ya un `setup` y cuatro TODOs, uno por test.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-12-calidad_testing_y_depuracion/2-practicas/lab-03-primeros-tests-con-bats
   ```
   (sin salida).

1. **El script, a mano.** Abre `starter/slugify.sh` y `starter/slugify.bats` en tu editor.
   ```bash
   bash starter/slugify.sh "Hola Mundo!" "Informe de Ventas 2026"
   bash starter/slugify.sh; echo $?
   bats starter/slugify.bats; echo "código: $?"
   ```
   ```text
   hola-mundo
   informe-de-ventas-2026
   uso: slugify.sh <título>...
   2

   0 tests, 0 failures

   código: 0
   ```
   Un archivo sin tests pasa: no hay nada que falle.

2. **TODO 1: el primer test.** `run comando` ejecuta el comando sin que su fallo pare el test, y deja su código en `$status` y lo que escribe (stdout y stderr juntos) en `$output`. Cambia el comentario del `TODO 1` por:
   ```bash
   @test "un título con espacios da un slug con guiones" {
     run bash "$slugify" "Hola Mundo"
     [[ $status -eq 0 ]]
     [[ $output == "hola-mundo" ]]
   }
   ```
   Prueba:
   ```bash
   bats starter/slugify.bats
   ```
   ```text
   slugify.bats
    ✓ un título con espacios da un slug con guiones

   1 test, 0 failures
   ```
   El nombre del test dice qué comprueba: cuando falle, es lo primero que leerás.

3. **Un test que falla.** Para ver cómo avisa bats, cambia a propósito `"hola-mundo"` por `"hola_mundo"` en la última línea del test:
   ```bash
   bats starter/slugify.bats; echo "código: $?"
   ```
   ```text
   slugify.bats
    ✗ un título con espacios da un slug con guiones
      (in test file starter/slugify.bats, line 16)
        `[[ $output == "hola_mundo" ]]' failed

   1 test, 1 failure

   código: 1
   ```
   `✗`, el archivo, la línea y la comprobación que falló. `bats` sale con `1` si falla algún test. Vuelve a dejar `"hola-mundo"`.

4. **Sin `run`.** ¿Por qué `run`? Prueba un test que llama al script directamente, sin argumentos:
   ```bash
   printf '@test "sin run" {\n  bash "$BATS_TEST_DIRNAME/slugify.sh"\n  echo "nunca llega"\n}\n' > starter/sin-run.bats
   bats starter/sin-run.bats
   rm starter/sin-run.bats
   ```
   ```text
   sin-run.bats
    ✗ sin run
      (in test file starter/sin-run.bats, line 2)
        `bash "$BATS_TEST_DIRNAME/slugify.sh"' failed with status 2
      uso: slugify.sh <título>...

   1 test, 1 failure
   ```
   bats ejecuta cada test con `set -e`: un comando que falla para el test ahí. Sin `run` no puedes comprobar que un script falla *como debe*. bats enseña también lo que escribió el test (`uso: ...`): solo cuando falla.

5. **TODO 2: cada línea.** `$lines` es un array (semana 09) con cada línea de la salida: `${lines[0]}` es la primera. Cambia el comentario del `TODO 2` por:
   ```bash
   @test "cada título da una línea" {
     run bash "$slugify" "Hola Mundo!" "Informe de Ventas 2026"
     [[ ${#lines[@]} -eq 2 ]]
     [[ ${lines[0]} == "hola-mundo" ]]
     [[ ${lines[1]} == "informe-de-ventas-2026" ]]
   }
   ```
   `${#lines[@]}` es cuántas líneas hay. Prueba:
   ```bash
   bats starter/slugify.bats
   ```
   ```text
   slugify.bats
    ✓ un título con espacios da un slug con guiones
    ✓ cada título da una línea

   2 tests, 0 failures
   ```

6. **TODO 3: el código, en `run`.** `run -2 comando` además hace fallar el test si el código no es `2`: es lo mismo que el `[[ $status -eq 2 ]]`, en una línea. Necesita bats 1.5 o más, y por eso el archivo empieza con `bats_require_minimum_version 1.5.0`. Cambia el comentario del `TODO 3` por:
   ```bash
   @test "sin títulos enseña el uso y sale con código 2" {
     run -2 bash "$slugify"
     [[ $output == "uso: slugify.sh <título>..." ]]
   }
   ```
   Prueba:
   ```bash
   bats starter/slugify.bats
   ```
   ```text
   slugify.bats
    ✓ un título con espacios da un slug con guiones
    ✓ cada título da una línea
    ✓ sin títulos enseña el uso y sale con código 2

   3 tests, 0 failures
   ```

7. **TODO 4: un test que encuentra un fallo.** ¿Qué pasa con dos espacios seguidos? Escribe primero el test con lo que *debería* salir. Cambia el comentario del `TODO 4` por:
   ```bash
   @test "varios espacios seguidos dan un solo guion" {
     run -0 bash "$slugify" "Hola  Mundo"
     echo "salida: $output"
     [[ $output == "hola-mundo" ]]
   }
   ```
   El `echo` no comprueba nada: como bats enseña lo que escribe un test que falla, te dice qué salió. Prueba:
   ```bash
   bats starter/slugify.bats
   ```
   Termina así:
   ```text
    ✗ varios espacios seguidos dan un solo guion
      (in test file starter/slugify.bats, line 34)
        `[[ $output == "hola-mundo" ]]' failed
      salida: hola--mundo

   4 tests, 1 failure
   ```
   `${slug// /-}` cambia cada espacio por un guion: dos espacios, dos guiones. En `starter/slugify.sh`, cambia esa línea por:
   ```bash
     slug="$(tr -s ' ' '-' <<< "$slug")"
   ```
   `tr ' ' '-'` cambia los espacios por guiones, y `-s` (*squeeze*) junta en uno los guiones seguidos que resultan (semana 04). Explícalo en un comentario. Prueba:
   ```bash
   bats starter/slugify.bats
   ```
   ```text
   slugify.bats
    ✓ un título con espacios da un slug con guiones
    ✓ cada título da una línea
    ✓ sin títulos enseña el uso y sale con código 2
    ✓ varios espacios seguidos dan un solo guion

   4 tests, 0 failures
   ```
   Los tres primeros tests siguen pasando: el arreglo no rompió nada que ya funcionaba.

8. **Contar, filtrar y TAP.** `-c` (*count*) dice cuántos tests hay sin ejecutarlos. `-f` (*filter*) ejecuta solo los que tienen ese texto (una regex) en el nombre. `--tap` escribe el formato TAP, una línea `ok`/`not ok` por test: el que sale cuando la salida no va a una terminal, como en el autograding.
   ```bash
   bats -c starter/slugify.bats
   bats -f guion starter/slugify.bats
   bats --tap starter/slugify.bats
   ```
   ```text
   4
   slugify.bats
    ✓ un título con espacios da un slug con guiones
    ✓ varios espacios seguidos dan un solo guion

   2 tests, 0 failures
   1..4
   ok 1 un título con espacios da un slug con guiones
   ok 2 cada título da una línea
   ok 3 sin títulos enseña el uso y sale con código 2
   ok 4 varios espacios seguidos dan un solo guion
   ```
   `-f guion` encontró también `guiones`: es una regex, no un nombre exacto.

## Criterios de éxito

- [ ] Explicas qué guardan `$status`, `$output` y `$lines` después de `run` (pasos 2 y 5)
- [ ] Explicas por qué un test sin `run` no puede comprobar un script que falla (paso 4)
- [ ] El test del `TODO 4` falló antes del arreglo y pasa después (paso 7)
- [ ] `bats starter/slugify.bats` termina con `4 tests, 0 failures` (paso 7)

## Reto extra

Prueba `bash starter/slugify.sh "Hola Mundo " "  Hola"`: salen `hola-mundo-` y `-hola`, con guiones en los bordes. Escribe primero un test que falle con esos dos títulos y después arregla el script con `${slug#-}` y `${slug%-}` (semana 05).

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 02 — Formato con shfmt](../lab-02-formato-con-shfmt/README.md) | [Lab 04 — setup, teardown y temporales en bats](../lab-04-setup-y-temporales-en-bats/README.md) → |

[↑ Semana 12](../../README.md)
