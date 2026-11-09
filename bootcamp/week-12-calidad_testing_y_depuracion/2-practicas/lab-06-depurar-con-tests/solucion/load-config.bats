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

@test "una barra invertida en el valor llega tal cual" {
  printf 'ruta=C:\\temp\\logs\n' > raro.conf
  run -0 bash "$load_config" raro.conf
  [[ $output == 'ruta -> C:\temp\logs' ]]
}

@test "un valor con = dentro llega entero" {
  echo 'url=https://ejemplo.com/buscar?q=bash&pagina=2' > url.conf
  run -0 bash "$load_config" url.conf
  [[ $output == 'url -> https://ejemplo.com/buscar?q=bash&pagina=2' ]]
}

@test "un archivo con fin de línea de Windows da los mismos valores" {
  printf 'puerto=8080\r\nhost=localhost\r\n' > windows.conf
  run -0 bash "$load_config" windows.conf
  [[ ${lines[0]} == "puerto -> 8080" ]]
  [[ ${lines[1]} == "host -> localhost" ]]
}

@test "un archivo con solo comentarios sale con 0 y no escribe nada" {
  printf '# nada todavía\n# puerto=8080\n' > vacio.conf
  run -0 bash "$load_config" vacio.conf
  [[ -z $output ]]
}
