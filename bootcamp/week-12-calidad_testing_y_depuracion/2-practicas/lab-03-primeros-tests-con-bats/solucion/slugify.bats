#!/usr/bin/env bats
# Tests de slugify.sh. Se lanzan con: bats starter/slugify.bats

# run -N necesita bats 1.5 o más: sin esta línea, bats avisa al usarlo.
bats_require_minimum_version 1.5.0

# setup corre antes de cada test. BATS_TEST_DIRNAME es la carpeta de este archivo:
# así el test encuentra slugify.sh lo lances desde donde lo lances.
setup() {
  slugify="$BATS_TEST_DIRNAME/slugify.sh"
}

@test "un título con espacios da un slug con guiones" {
  run bash "$slugify" "Hola Mundo"
  [[ $status -eq 0 ]]
  [[ $output == "hola-mundo" ]]
}

@test "cada título da una línea" {
  run bash "$slugify" "Hola Mundo!" "Informe de Ventas 2026"
  [[ ${#lines[@]} -eq 2 ]]
  [[ ${lines[0]} == "hola-mundo" ]]
  [[ ${lines[1]} == "informe-de-ventas-2026" ]]
}

@test "sin títulos enseña el uso y sale con código 2" {
  run -2 bash "$slugify"
  [[ $output == "uso: slugify.sh <título>..." ]]
}

@test "varios espacios seguidos dan un solo guion" {
  run -0 bash "$slugify" "Hola  Mundo"
  [[ $output == "hola-mundo" ]]
}
