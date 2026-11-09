#!/usr/bin/env bats
# Tests de stock.sh, el script. Se lanzan con: bats starter/tests

bats_require_minimum_version 1.5.0

# TODO 1: un setup que entra en la carpeta temporal de cada test.

@test "añadir 3 tornillos deja 3" {
  run -0 bash "$BATS_TEST_DIRNAME/../stock.sh" add tornillos 3
  run -0 bash "$BATS_TEST_DIRNAME/../stock.sh" get tornillos
  [[ $output == "3" ]]
}

@test "dos entradas del mismo producto se suman" {
  bash "$BATS_TEST_DIRNAME/../stock.sh" add tuercas 2
  bash "$BATS_TEST_DIRNAME/../stock.sh" add tuercas 5
  run -0 bash "$BATS_TEST_DIRNAME/../stock.sh" get tuercas
  [[ $output == "7" ]]
}
