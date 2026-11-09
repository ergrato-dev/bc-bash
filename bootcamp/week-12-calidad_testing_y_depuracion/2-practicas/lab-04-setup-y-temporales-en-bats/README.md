# Lab 04 — setup, teardown y temporales en bats

⏱ Duración estimada: ~60 min

## Objetivo

Aislar cada test en su carpeta temporal con `setup`, compartir lo común con `load`, probar las funciones de una librería una a una y dejarlo todo limpio con `teardown`.

## Contexto

- Un test que escribe archivos en la carpeta desde la que lo lanzas deja rastro, y el siguiente test (o la siguiente vez que lo lanzas) empieza con lo que dejó el anterior. Un buen test da el mismo resultado siempre, se ejecute solo, con otros o diez veces.
- bats crea para cada test una carpeta temporal vacía, `$BATS_TEST_TMPDIR`, y la borra al acabar. Pero no entra en ella: eso lo hace tu `setup`, la función que bats ejecuta antes de cada test.
- `starter/stock.sh` lleva un inventario en `stock.txt` (`stock.sh add tornillos 3`, `stock.sh get tornillos`) con las funciones de `starter/lib/stock.sh`. `starter/tests/stock.bats` tiene dos tests que pasan... la primera vez.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-12-calidad_testing_y_depuracion/2-practicas/lab-04-setup-y-temporales-en-bats
   ```
   (sin salida).

1. **El script, a mano.** Abre `starter/stock.sh`, `starter/lib/stock.sh` y `starter/tests/stock.bats` en tu editor.
   ```bash
   bash starter/stock.sh add tornillos 3
   bash starter/stock.sh add clavos 10
   bash starter/stock.sh add tornillos 2
   cat stock.txt
   bash starter/stock.sh get tornillos
   bash starter/stock.sh get martillos
   bash starter/stock.sh add clavos cero; echo $?
   rm stock.txt
   ```
   ```text
   clavos 10
   tornillos 5
   5
   0
   stock_add: 'cero' no es una cantidad
   2
   ```

2. **Pasa una vez.** `bats` con una carpeta ejecuta todos sus `.bats`:
   ```bash
   bats starter/tests
   ls
   ```
   ```text
   stock.bats
    ✓ añadir 3 tornillos deja 3
    ✓ dos entradas del mismo producto se suman

   2 tests, 0 failures

   README.md
   solucion
   starter
   stock.txt
   ```
   Pasa, pero ha dejado `stock.txt` en la carpeta del lab. Lánzalo otra vez:
   ```bash
   bats --tap starter/tests; echo "código: $?"
   cat stock.txt
   ```
   ```text
   1..2
   not ok 1 añadir 3 tornillos deja 3
   # (in test file starter/tests/stock.bats, line 11)
   #   `[[ $output == "3" ]]' failed
   not ok 2 dos entradas del mismo producto se suman
   # (in test file starter/tests/stock.bats, line 18)
   #   `[[ $output == "7" ]]' failed
   código: 1
   tornillos 6
   tuercas 14
   ```
   El segundo intento empezó con el inventario del primero. Los tests no han cambiado y el script tampoco: el fallo está en los tests. Borra el rastro:
   ```bash
   rm stock.txt
   ```
   (sin salida).

3. **Dónde está la carpeta temporal.** Un test no escribe en tu pantalla: bats se guarda lo que escribe y solo lo enseña si falla. Para escribir algo siempre, se manda al descriptor 3 (`>&3`), que bats deja abierto hacia la terminal. Prueba con un test de usar y tirar:
   ```bash
   printf '@test "dónde" {\n  echo "tmp: $BATS_TEST_TMPDIR" >&3\n  echo "pwd: $PWD" >&3\n}\n' > starter/tests/donde.bats
   bats --tap starter/tests/donde.bats
   rm starter/tests/donde.bats
   ```
   Algo como (cambia el nombre de la carpeta temporal):
   ```text
   1..1
   tmp: /tmp/bats-run-J2E1JJ/test/1
   pwd: /bc-bash/bootcamp/week-12-calidad_testing_y_depuracion/2-practicas/lab-04-setup-y-temporales-en-bats
   ok 1 dónde
   ```
   Cada test tiene su carpeta (`test/1`, `test/2`...), pero el test corre donde lanzaste bats.

4. **TODO 1: entrar en la carpeta temporal.** En `starter/tests/stock.bats`, cambia el comentario del `TODO 1` por:
   ```bash
   # Cada test, en su carpeta temporal: bats la crea antes del test y la borra después.
   # Sin esto, stock.txt se quedaría en la carpeta desde la que lanzas bats, y el test
   # siguiente (o la siguiente vez) empezaría con el inventario del anterior.
   setup() {
     cd "$BATS_TEST_TMPDIR" || return
   }
   ```
   `|| return`: si el `cd` fallara, el test fallaría ahí, en lugar de seguir en la carpeta equivocada. Prueba dos veces:
   ```bash
   bats starter/tests
   bats starter/tests
   ls
   ```
   ```text
   stock.bats
    ✓ añadir 3 tornillos deja 3
    ✓ dos entradas del mismo producto se suman

   2 tests, 0 failures

   stock.bats
    ✓ añadir 3 tornillos deja 3
    ✓ dos entradas del mismo producto se suman

   2 tests, 0 failures

   README.md
   solucion
   starter
   ```
   Sin rastro, y el mismo resultado cada vez.

5. **TODO 2: lo común, en un archivo.** `starter/tests/lib.bats` va a necesitar el mismo `setup`, y además las funciones de la librería. En lugar de copiarlo, crea `starter/tests/test_helper.bash` con tu editor:
   ```bash
   # shellcheck shell=bash
   # test_helper.bash — lo que comparten los tests del lab. Cada .bats lo carga con "load test_helper".

   # run -N y run --separate-stderr necesitan bats 1.5 o más.
   bats_require_minimum_version 1.5.0

   # Antes de cada test: su carpeta temporal y las funciones de lib/stock.sh, para poder
   # probarlas una a una sin pasar por el script.
   setup() {
     cd "$BATS_TEST_TMPDIR" || return
     # shellcheck source=SCRIPTDIR/../lib/stock.sh
     source "$BATS_TEST_DIRNAME/../lib/stock.sh"
   }
   ```
   `load test_helper` carga `test_helper.bash` de la carpeta del `.bats` (bats añade el `.bash`). En `starter/tests/stock.bats`, cambia la línea de `bats_require_minimum_version` y tu `setup` (con sus comentarios) por:
   ```bash
   load test_helper
   ```
   y en `starter/tests/lib.bats`, el comentario del `TODO 2` por lo mismo. Prueba:
   ```bash
   bats starter/tests
   ```
   ```text
   stock.bats
    ✓ añadir 3 tornillos deja 3
    ✓ dos entradas del mismo producto se suman

   2 tests, 0 failures
   ```
   `lib.bats` aún no tiene tests.

6. **TODO 3: probar una función.** `run` también ejecuta funciones: como el `setup` ha cargado la librería con `source`, `stock_get` y `stock_add` existen en cada test. Así compruebas cada pieza sin pasar por el script. En `starter/tests/lib.bats`, cambia el comentario del `TODO 3` por:
   ```bash
   @test "stock_get de un producto que no está da 0" {
     echo "tornillos 5" > stock.txt
     run -0 stock_get stock.txt martillos
     [[ $output == "0" ]]
   }

   @test "stock_add con cantidad 0 sale con código 2 y no crea el inventario" {
     run -2 stock_add stock.txt tornillos 0
     [[ ! -e stock.txt ]]
   }
   ```
   El primer test prepara sus datos: en su carpeta temporal no hay nada que no haya puesto él. Prueba:
   ```bash
   bats starter/tests/lib.bats
   ```
   ```text
   lib.bats
    ✓ stock_get de un producto que no está da 0
    ✓ stock_add con cantidad 0 sale con código 2 y no crea el inventario

   2 tests, 0 failures
   ```

7. **TODO 4: stderr aparte.** `run` junta stdout y stderr en `$output`. Con `run --separate-stderr`, stderr va a `$stderr`, y puedes comprobar que el aviso va a su sitio. Cambia el comentario del `TODO 4` por:
   ```bash
   @test "el aviso de una cantidad mala va a stderr" {
     run --separate-stderr stock_add stock.txt tornillos -3
     [[ $status -eq 2 ]]
     [[ -z $output ]]
     [[ $stderr == "stock_add: '-3' no es una cantidad" ]]
   }
   ```
   Prueba:
   ```bash
   bats starter/tests/lib.bats
   ```
   ```text
   lib.bats
    ✓ stock_get de un producto que no está da 0
    ✓ stock_add con cantidad 0 sale con código 2 y no crea el inventario
    ✓ el aviso de una cantidad mala va a stderr

   3 tests, 0 failures
   ```

8. **TODO 5: un test que necesita limpiar.** `stock_add` escribe un temporal junto al inventario y lo cambia con `mv`. Si no puede escribir en la carpeta, debe fallar sin tocar el inventario. Cambia el comentario del `TODO 5` por:
   ```bash
   @test "si no puede escribir en la carpeta, stock_add falla y el inventario no cambia" {
     # root escribe aunque la carpeta no tenga permiso: ahí el test no comprobaría nada.
     [[ $EUID -ne 0 ]] || skip "como root se puede escribir en cualquier carpeta"
     mkdir almacen
     echo "tornillos 5" > almacen/stock.txt
     chmod a-w almacen
     run -1 stock_add almacen/stock.txt tornillos 1
     [[ $(cat almacen/stock.txt) == "tornillos 5" ]]
   }
   ```
   `skip` da el test por saltado, con el motivo, en lugar de pasarlo o fallarlo. `$EUID` es tu número de usuario: `0` es root. Prueba:
   ```bash
   bats --tap starter/tests/lib.bats; echo "código: $?"
   ```
   Algo como (cambia el nombre de la carpeta temporal):
   ```text
   1..4
   ok 1 stock_get de un producto que no está da 0
   ok 2 stock_add con cantidad 0 sale con código 2 y no crea el inventario
   ok 3 el aviso de una cantidad mala va a stderr
   ok 4 si no puede escribir en la carpeta, stock_add falla y el inventario no cambia
   rm: cannot remove '/tmp/bats-run-ckgol5/test/4/almacen/stock.txt': Permission denied
   código: 1
   ```
   Los cuatro tests pasan, pero bats sale con `1`: no pudo borrar la carpeta temporal del test 4, porque `almacen/` no tiene permiso de escritura. `teardown` es la función que bats ejecuta después de cada test, también si falla. Añade encima del test:
   ```bash
   # teardown corre después de cada test, también si falla: devuelve el permiso de escritura
   # a almacen/ para que bats pueda borrar la carpeta temporal.
   teardown() {
     [[ ! -d almacen ]] || chmod u+w almacen
   }
   ```
   Prueba:
   ```bash
   bats starter/tests
   ```
   ```text
   lib.bats
    ✓ stock_get de un producto que no está da 0
    ✓ stock_add con cantidad 0 sale con código 2 y no crea el inventario
    ✓ el aviso de una cantidad mala va a stderr
    ✓ si no puede escribir en la carpeta, stock_add falla y el inventario no cambia
   stock.bats
    ✓ añadir 3 tornillos deja 3
    ✓ dos entradas del mismo producto se suman

   6 tests, 0 failures
   ```

9. **shellcheck.**
   ```bash
   shellcheck -x starter/stock.sh starter/tests/test_helper.bash; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas por qué los tests del paso 2 pasan la primera vez y fallan la segunda
- [ ] Explicas qué hace bats con `$BATS_TEST_TMPDIR` y qué hace tu `setup` (pasos 3 y 4)
- [ ] `bats starter/tests` da el mismo resultado dos veces seguidas y no deja archivos en la carpeta del lab (paso 4)
- [ ] Explicas por qué hizo falta `teardown` en el paso 8
- [ ] `bats starter/tests` termina con `6 tests, 0 failures` (paso 8)

## Reto extra

`setup_file` y `teardown_file` corren una sola vez por archivo, antes del primer test y después del último. ¿Para qué usarías `setup_file` en lugar de `setup`? Piensa en algo lento, como arrancar un contenedor con una base de datos. ¿Qué pierdes si los tests comparten lo que prepara `setup_file`?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 03 — Primeros tests con bats](../lab-03-primeros-tests-con-bats/README.md) | [Lab 05 — La traza: set -x, PS4 y BASH_XTRACEFD](../lab-05-traza-con-set-x/README.md) → |

[↑ Semana 12](../../README.md)
