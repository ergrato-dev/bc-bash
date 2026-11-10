#!/usr/bin/env bats
# Tests de bk-restore con los dobles de tests/fakes/: el de pg_restore apunta en
# pg_restore.args cómo lo llamaron, en lugar de tocar una base.

load test_helper

# TODO(semana 14) 11: dos tests o más. Uno que compruebe con qué opciones llama a
# pg_restore (mira pg_restore.args) y uno con un archivo que no es una copia.
