#!/usr/bin/env bats
# Tests de bk-restore con los dobles de tests/fakes/: el de pg_restore apunta en
# pg_restore.args cómo lo llamaron, en lugar de tocar una base.

load test_helper

setup_file() {
  export PGDATABASE=tienda
}

@test "con -y restaura con --clean y --single-transaction en la base de PGDATABASE" {
  echo "PGDMP copia" > copia.dump
  run -0 bk-restore -y copia.dump
  [[ $(< pg_restore.args) == "pg_restore --clean --if-exists --no-owner --single-transaction -d tienda copia.dump" ]]
}

@test "sin -y y sin terminal no pregunta ni restaura: sale con 2" {
  echo "PGDMP copia" > copia.dump
  run -2 bk-restore copia.dump < /dev/null
  [[ $output == *"usa -y"* ]]
  [[ ! -e pg_restore.args ]]
}

@test "un archivo que no es una copia de pg_dump para con 1 antes de tocar la base" {
  echo "hola" > notas.txt
  run -1 bk-restore -y notas.txt
  [[ $output == *"no es una copia de pg_dump -Fc"* ]]
  [[ ! -e pg_restore.args ]]
}
