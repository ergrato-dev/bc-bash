#!/usr/bin/env bash
# nightly-report.sh — el informe de cada noche: tarda unos segundos y lo apunta en report.log.
# Para qué: un trabajo de cron que no puede correr dos veces a la vez. Si un día tarda
# más de lo normal y el cron lo lanza otra vez, las dos copias se pisarían el informe.
set -euo pipefail

# {lock_fd}: bash elige un descriptor libre y guarda su número en lock_fd. El bloqueo
# dura lo que el descriptor siga abierto, aquí o en un hijo que lo heredó: se suelta solo
# al terminar, de cualquier forma, también con kill -9. Por eso no hace falta un trap.
exec {lock_fd}> nightly-report.lock
# Sin WAIT, -w 0: si otro tiene el bloqueo, flock se rinde enseguida.
if ! flock -w "${WAIT:-0}" "$lock_fd"; then
  echo "nightly-report.sh: ya hay otro informe en marcha" >&2
  exit 1
fi

echo "$(date +%T) inicio $$" >> report.log
# El trabajo de verdad (leer logs, calcular, enviar): aquí, unos segundos de espera.
sleep "${WORK_SECS:-3}"
echo "$(date +%T) fin $$" >> report.log
echo "informe hecho ($$)"
