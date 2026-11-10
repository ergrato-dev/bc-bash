#!/usr/bin/env bats
# Tests de bk-backup con los dobles de tests/fakes/: el nombre de la copia, que un fallo
# no deje copias a medias, la rotación y la espera a PostgreSQL.

load test_helper

# TODO(semana 14) 10: tres tests o más. Uno que compruebe el nombre y el contenido de la
# copia, uno en el que pg_dump falla (FAKE_PG_DUMP_FAIL=1) y no queda nada, y uno de la
# rotación con -k.
