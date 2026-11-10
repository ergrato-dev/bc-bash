#!/usr/bin/env bats
# Tests de bk-check: un valor bueno y uno malo de cada tipo, y las llamadas mal hechas.

load test_helper

@test "una IP válida da ok y código 0" {
  run bk-check ip 192.168.1.10
  [[ $status -eq 0 ]]
  [[ $output == "ok: 192.168.1.10" ]]
}

@test "una IP con un número mayor que 255 no es válida" {
  run --separate-stderr bk-check ip 192.168.1.256
  [[ $status -eq 1 ]]
  [[ -z $output ]]
  [[ $stderr == "bk-check: '192.168.1.256' no es una IP válida" ]]
}

@test "un email sin dominio no es válido" {
  run -1 bk-check email ana@
  [[ $output == "bk-check: 'ana@' no es un email válido" ]]
}

@test "una versión semántica se separa en sus partes" {
  run -0 bk-check semver 2.10.3-rc.1
  [[ $output == "ok: 2.10.3-rc.1 (mayor 2, menor 10, parche 3, prerelease rc.1)" ]]
}

@test "una versión con ceros a la izquierda no es válida" {
  run -1 bk-check semver 1.02.3
}

@test "un tipo desconocido sale con código 2" {
  run -2 bk-check telefono 600000000
}
