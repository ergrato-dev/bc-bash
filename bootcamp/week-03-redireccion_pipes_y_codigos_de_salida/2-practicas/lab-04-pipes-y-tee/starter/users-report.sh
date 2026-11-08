#!/usr/bin/env bash
# Informe de las cuentas del sistema: cuántas hay, las primeras por orden alfabético y cuándo se hizo.
# Sin set -euo pipefail hasta el lab 07: allí verás qué cambia.

ls starter > /dev/null || exit 1
mkdir -p zona

# getent passwd imprime una línea por cuenta, como /etc/passwd.
# TODO 1: guarda las cuentas en zona/cuentas.txt con tee y, en el mismo pipe, cuéntalas con wc -l

# TODO 2: ordena zona/cuentas.txt con sort y quédate con las 3 primeras con head -3

# TODO 3: añade la fecha (date '+%F') al final de zona/historial.txt con tee -a, sin que salga en pantalla
