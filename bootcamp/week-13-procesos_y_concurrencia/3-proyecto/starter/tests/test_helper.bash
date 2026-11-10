# shellcheck shell=bash
# test_helper.bash — lo que comparten todos los tests del kit. Cada .bats lo carga con
# "load test_helper" (bats añade el .bash).

# run --separate-stderr y run -N necesitan bats 1.5 o más: si no lo dices, bats avisa.
bats_require_minimum_version 1.5.0

# setup corre antes de cada test. BATS_TEST_DIRNAME es la carpeta del .bats: de ahí se
# llega al kit, sea cual sea la carpeta desde la que lanzas bats.
setup() {
  KIT_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  PATH="$KIT_DIR/bin:$PATH"
  # Cada test trabaja en su carpeta temporal (bats la crea y la borra): lo que escriba,
  # como bk-run.log, no ensucia el kit ni lo ve el test siguiente.
  cd "$BATS_TEST_TMPDIR" || return
}
