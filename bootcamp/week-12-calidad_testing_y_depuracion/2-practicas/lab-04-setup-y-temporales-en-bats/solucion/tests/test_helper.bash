# shellcheck shell=bash
# test_helper.bash — lo que comparten los tests del lab. Cada .bats lo carga con "load test_helper".

# run -N y run --separate-stderr necesitan bats 1.5 o más.
bats_require_minimum_version 1.5.0

# Antes de cada test: su carpeta temporal y las funciones de lib/stock.sh, para poder
# probarlas una a una sin pasar por el script.
setup() {
  cd "$BATS_TEST_TMPDIR" || return
  # shellcheck source=SCRIPTDIR/../lib/stock.sh
  source "$BATS_TEST_DIRNAME/../lib/stock.sh"
}
