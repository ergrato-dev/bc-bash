#!/usr/bin/env bash
# check-disk.sh — avisa de los discos que se están llenando, leyendo la salida de "df -P".
# Para qué: un cron que lo mira cada hora y avisa antes de que un disco llegue al 100%.
set -euo pipefail

# shellcheck source=SCRIPTDIR/lib/log.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib/log.sh"

df_output="${1:?uso: check-disk.sh <salida de df -P>}"
full=0

# tail -n +2: desde la línea 2, sin la cabecera. read reparte cada línea en los campos de df.
while read -r _ _ _ _ capacity mount; do
  use="${capacity%\%}"
  log_debug "$mount al $use%"
  if ((use >= 90)); then
    log_error "$mount al $use%: casi lleno"
    full=$((full + 1))
  elif ((use >= 80)); then
    log_warn "$mount al $use%"
  fi
done < <(tail -n +2 "$df_output")

log_info "revisados los discos de $df_output: $full casi llenos"
# Con algún disco casi lleno, código 1: el cron o el sistema de alertas se entera.
((full == 0))
