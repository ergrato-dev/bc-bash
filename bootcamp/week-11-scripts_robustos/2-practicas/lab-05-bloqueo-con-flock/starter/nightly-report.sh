#!/usr/bin/env bash
# nightly-report.sh — el informe de cada noche: tarda unos segundos y lo apunta en report.log.
# Para qué: un trabajo de cron que no puede correr dos veces a la vez. Si un día tarda
# más de lo normal y el cron lo lanza otra vez, las dos copias se pisarían el informe.
set -euo pipefail

# TODO 1: abre nightly-report.lock en un descriptor y bloquéalo con flock -n;
# si otro lo tiene, avisa en stderr y sal con 1.
# TODO 2: con WAIT=N, espera hasta N segundos al bloqueo en lugar de rendirte enseguida.

echo "$(date +%T) inicio $$" >> report.log
# El trabajo de verdad (leer logs, calcular, enviar): aquí, unos segundos de espera.
sleep "${WORK_SECS:-3}"
echo "$(date +%T) fin $$" >> report.log
echo "informe hecho ($$)"
