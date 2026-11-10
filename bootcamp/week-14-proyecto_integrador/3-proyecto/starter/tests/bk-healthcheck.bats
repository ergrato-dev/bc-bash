#!/usr/bin/env bats
# Tests de bk-healthcheck: el informe, el código de salida, el límite de tiempo y el paralelo.

load test_helper

@test "con todo bien, una línea ok por comprobación, en el orden del archivo, y código 0" {
  # La primera tarda más: si el informe fuera en el orden en que terminan, saldría segunda.
  printf '# comentario\nlenta sleep 0.5\n\nrapida true\n' > checks.conf
  run --separate-stderr bk-healthcheck checks.conf
  [[ $status -eq 0 ]]
  [[ $output == $'ok    lenta\nok    rapida' ]]
  [[ $stderr == "bk-healthcheck: 2 comprobaciones, todas bien" ]]
}

@test "una comprobación que falla sale como FAIL con su código y su error, y el código es 1" {
  printf 'bien true\nmal ls /no-existe\n' > checks.conf
  run -1 bk-healthcheck checks.conf
  [[ ${lines[1]} == "FAIL  mal (código 2)" ]]
  [[ ${lines[2]} == *"/no-existe"* ]]
}

@test "-t corta una comprobación colgada y lo dice" {
  printf 'colgada sleep 30\n' > checks.conf
  run -1 bk-healthcheck -t 1 checks.conf
  [[ ${lines[0]} == "FAIL  colgada (tiempo agotado: 1 s)" ]]
}

@test "las comprobaciones van a la vez: cuatro de 1 s tardan menos de 2 s" {
  printf 'a sleep 1\nb sleep 1\nc sleep 1\nd sleep 1\n' > checks.conf
  # EPOCHREALTIME es la hora en microsegundos (1731000000.123456): sin el punto, se resta.
  local start="${EPOCHREALTIME/./}"
  run -0 bk-healthcheck -j 4 checks.conf
  (((${EPOCHREALTIME/./} - start) < 2000000))
}

@test "una línea sin comando para antes de empezar, con código 2" {
  printf 'bien true\nsolo-nombre\n' > checks.conf
  run -2 bk-healthcheck checks.conf
  [[ $output == "bk-healthcheck: checks.conf, línea 2: falta el comando de 'solo-nombre'" ]]
}
