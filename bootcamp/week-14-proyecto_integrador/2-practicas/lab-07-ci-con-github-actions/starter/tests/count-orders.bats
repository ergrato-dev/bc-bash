#!/usr/bin/env bats
# Tests de count-orders.sh contra un PostgreSQL de verdad: el del laboratorio, o el
# servicio de la CI. Cada test recarga la tienda para empezar siempre igual.

# run -0 y run -1 (comprobar el código de salida) necesitan bats 1.5 o más.
bats_require_minimum_version 1.5.0

setup() {
  ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  psql -v ON_ERROR_STOP=1 -q -f "$ROOT/datos/tienda.sql"
}

@test "cuenta los 12 pedidos de la tienda" {
  run -0 "$ROOT/bin/count-orders.sh"
  [[ $output == 12 ]]
}

@test "si PostgreSQL no responde, avisa y sale con 1" {
  PGHOST=no-existe run -1 "$ROOT/bin/count-orders.sh"
  [[ $output == *"no responde en 'no-existe'"* ]]
}
