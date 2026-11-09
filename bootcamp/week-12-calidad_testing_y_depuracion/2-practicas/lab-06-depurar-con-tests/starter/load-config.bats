#!/usr/bin/env bats
# Tests de load-config.sh. Se lanzan con: bats starter/load-config.bats

bats_require_minimum_version 1.5.0

setup() {
  cd "$BATS_TEST_TMPDIR" || return
  load_config="$BATS_TEST_DIRNAME/load-config.sh"
}

@test "lee cada clave con su valor y se salta comentarios y líneas vacías" {
  printf '# comentario\npuerto=8080\n\nhost=localhost\n' > app.conf
  run -0 bash "$load_config" app.conf
  [[ ${lines[0]} == "puerto -> 8080" ]]
  [[ ${lines[1]} == "host -> localhost" ]]
  [[ ${#lines[@]} -eq 2 ]]
}

# TODO 1: una barra invertida (\) en el valor llega tal cual.

# TODO 2: un valor con = dentro llega entero.

# TODO 3: un archivo con fin de línea de Windows (\r\n) da los mismos valores.

# TODO 4: un archivo con solo comentarios no es un error: sale con 0 y no escribe nada.
