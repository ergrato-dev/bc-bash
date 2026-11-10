#!/usr/bin/env bats
# Tests del dispatcher: bashkit reparte el trabajo entre los bk-* de bin/.

load test_helper

@test "bashkit help enseña el uso y los subcomandos, con código 0" {
  run bashkit help
  [[ $status -eq 0 ]]
  [[ ${lines[0]} == "uso: bashkit <subcomando> [argumentos...]" ]]
  [[ $output == *"  check"* ]]
}

@test "bashkit sin subcomando sale con código 2" {
  run -2 bashkit
  [[ ${lines[0]} == "uso: bashkit <subcomando> [argumentos...]" ]]
}

@test "bashkit con un subcomando que no existe avisa y sale con código 2" {
  run -2 bashkit nada
  [[ $output == "bashkit: subcomando desconocido: 'nada' (mira bashkit help)" ]]
}

@test "bashkit pasa los argumentos y el código de salida del subcomando" {
  run -1 bashkit check ip 999.1.1.1
  [[ $output == "bk-check: '999.1.1.1' no es una IP válida" ]]
}
