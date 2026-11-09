#!/usr/bin/env bats
# Tests de lib/stock.sh, las funciones, sin pasar por el script.

load test_helper

@test "stock_get de un producto que no está da 0" {
  echo "tornillos 5" > stock.txt
  run -0 stock_get stock.txt martillos
  [[ $output == "0" ]]
}

@test "stock_add con cantidad 0 sale con código 2 y no crea el inventario" {
  run -2 stock_add stock.txt tornillos 0
  [[ ! -e stock.txt ]]
}

@test "el aviso de una cantidad mala va a stderr" {
  run --separate-stderr stock_add stock.txt tornillos -3
  [[ $status -eq 2 ]]
  [[ -z $output ]]
  [[ $stderr == "stock_add: '-3' no es una cantidad" ]]
}

# teardown corre después de cada test, también si falla: devuelve el permiso de escritura
# a almacen/ para que bats pueda borrar la carpeta temporal.
teardown() {
  [[ ! -d almacen ]] || chmod u+w almacen
}

@test "si no puede escribir en la carpeta, stock_add falla y el inventario no cambia" {
  # root escribe aunque la carpeta no tenga permiso: ahí el test no comprobaría nada.
  [[ $EUID -ne 0 ]] || skip "como root se puede escribir en cualquier carpeta"
  mkdir almacen
  echo "tornillos 5" > almacen/stock.txt
  chmod a-w almacen
  run -1 stock_add almacen/stock.txt tornillos 1
  [[ $(cat almacen/stock.txt) == "tornillos 5" ]]
}
