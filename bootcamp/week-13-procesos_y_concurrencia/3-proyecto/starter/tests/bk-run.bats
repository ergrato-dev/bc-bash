#!/usr/bin/env bats
# Tests de bk-run: el código de salida, el log y las opciones.

load test_helper

@test "bk-run sale con el código del comando" {
  run -3 bk-run bash -c 'exit 3'
}

@test "bk-run enseña la salida y la guarda en bk-run.log con su código" {
  run -0 bk-run echo hola
  [[ $output == "hola" ]]
  [[ $(sed -n 2p bk-run.log) == "hola" ]]
  [[ $(tail -n 1 bk-run.log) == "== código: 0 ==" ]]
}

@test "con un fallo, el aviso va a stderr y no a stdout" {
  run --separate-stderr bk-run false
  [[ $status -eq 1 ]]
  [[ -z $output ]]
  [[ $stderr == "bk-run: warn: 'false' salió con código 1" ]]
}

@test "-q no enseña la salida pero la guarda" {
  run -0 bk-run -q echo hola
  [[ -z $output ]]
  grep -qx hola bk-run.log
}

@test "-l elige el log" {
  run -0 bk-run -l otro.log echo hola
  [[ -f otro.log ]]
  [[ ! -e bk-run.log ]]
}

@test "una opción desconocida sale con código 2" {
  run -2 bk-run -x true
}
