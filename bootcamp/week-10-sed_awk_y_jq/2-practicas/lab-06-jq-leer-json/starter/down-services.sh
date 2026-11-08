#!/usr/bin/env bash
# down-services.sh — los servicios de un informe JSON que no están en marcha, con su estado y sus reinicios.
# Para qué: que un cron avise de lo que se ha caído (sale con 1 si hay alguno).
set -euo pipefail

report="${1:?uso: down-services.sh <servicios.json>}"

# TODO 1: solo los servicios cuyo estado no es "running", y su nombre sin comillas.
# TODO 2: cada línea como "worker: exited (7 reinicios)".
mapfile -t down < <(jq -c '.servicios[]' "$report")

# TODO 3: si no hay ninguno, "todo en marcha" y código 0; si hay, cada uno en una línea y código 1.
declare -p down
