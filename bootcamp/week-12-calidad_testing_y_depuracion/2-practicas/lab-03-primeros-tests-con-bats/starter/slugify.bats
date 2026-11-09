#!/usr/bin/env bats
# Tests de slugify.sh. Se lanzan con: bats starter/slugify.bats

# run -N necesita bats 1.5 o más: sin esta línea, bats avisa al usarlo.
bats_require_minimum_version 1.5.0

# setup corre antes de cada test. BATS_TEST_DIRNAME es la carpeta de este archivo:
# así el test encuentra slugify.sh lo lances desde donde lo lances.
setup() {
  slugify="$BATS_TEST_DIRNAME/slugify.sh"
}

# TODO 1: un test que comprueba que "Hola Mundo" da hola-mundo y código 0.

# TODO 2: un test con dos títulos que comprueba cada línea de la salida.

# TODO 3: un test que comprueba que sin argumentos sale con código 2 y el uso.

# TODO 4: un test con dos espacios seguidos ("Hola  Mundo").
