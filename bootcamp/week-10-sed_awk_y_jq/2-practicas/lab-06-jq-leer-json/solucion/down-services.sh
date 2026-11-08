#!/usr/bin/env bash
# down-services.sh — los servicios de un informe JSON que no están en marcha, con su estado y sus reinicios.
# Para qué: que un cron avise de lo que se ha caído (sale con 1 si hay alguno).
set -euo pipefail

report="${1:?uso: down-services.sh <servicios.json>}"

# -r: el texto sin las comillas de JSON, listo para bash. \( ) mete un valor dentro de un texto de jq.
# < <( ): mapfile en esta bash, no en un subshell (semana 07), para que down siga existiendo.
mapfile -t down < <(jq -r '.servicios[] | select(.estado != "running") | "\(.nombre): \(.estado) (\(.reinicios) reinicios)"' "$report")

if ((${#down[@]} == 0)); then
  echo "todo en marcha"
  exit 0
fi
printf '%s\n' "${down[@]}"
exit 1
