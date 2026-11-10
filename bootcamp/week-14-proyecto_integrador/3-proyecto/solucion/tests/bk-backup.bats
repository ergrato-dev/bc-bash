#!/usr/bin/env bats
# Tests de bk-backup con los dobles de tests/fakes/: el nombre de la copia, que un fallo
# no deje copias a medias, la rotación y la espera a PostgreSQL.

load test_helper

@test "deja una copia con la fecha en el nombre, escribe su ruta y sale con 0" {
  PGDATABASE=tienda run --separate-stderr bk-backup -d copias
  [[ $status -eq 0 ]]
  [[ $output == copias/tienda-????????-??????.dump ]]
  [[ $(head -c 5 "$output") == PGDMP ]]
}

@test "si pg_dump falla, sale con 1 y no deja ni copia ni .partial" {
  FAKE_PG_DUMP_FAIL=1 PGDATABASE=tienda run -1 bk-backup -d copias
  [[ $output == *"pg_dump falló"* ]]
  [[ -z $(ls -A copias | grep -v '^\.lock$') ]]
}

@test "con -k 3 deja las 3 copias más nuevas de la base y no toca las de otra" {
  mkdir copias
  touch copias/tienda-2026010{1,2,3,4}-000000.dump copias/tienda-viejo-20200101-000000.dump
  PGDATABASE=tienda run -0 bk-backup -d copias -k 3
  [[ ! -e copias/tienda-20260101-000000.dump && ! -e copias/tienda-20260102-000000.dump ]]
  [[ -e copias/tienda-20260103-000000.dump && -e copias/tienda-20260104-000000.dump ]]
  [[ -e copias/tienda-viejo-20200101-000000.dump ]]
  [[ $(ls copias/tienda-2*.dump | wc -l) -eq 3 ]]
}

@test "espera a que PostgreSQL responda, y se rinde con 1 si no responde a tiempo" {
  FAKE_PG_READY_AFTER=2 PGDATABASE=tienda run -0 bk-backup -d copias -w 5
  rm .pg_isready-calls
  FAKE_PG_READY_AFTER=99 PGDATABASE=tienda run -1 bk-backup -d nada -w 1
  [[ $output == *"no responde después de 1 s"* ]]
  [[ -z $(ls nada/*.dump 2> /dev/null) ]]
}
