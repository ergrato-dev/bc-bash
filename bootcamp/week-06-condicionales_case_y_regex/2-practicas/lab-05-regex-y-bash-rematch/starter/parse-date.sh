#!/usr/bin/env bash
# parse-date.sh — separa una fecha AAAA-MM-DD en año, mes y día, y rechaza las mal escritas.
set -euo pipefail

date_in="${1:?uso: parse-date.sh <AAAA-MM-DD>}"

# TODO 1: si date_in no encaja con la regex, "fecha mal escrita: ..." a stderr y código 1 (paso 8)
# TODO 2: year, month y day desde BASH_REMATCH, y el echo del final con ellos (paso 9)
# TODO 3: si el mes no está entre 1 y 12, "mes fuera de rango: ..." a stderr y código 1 (paso 10)
# TODO 4: si el día no está entre 1 y 31, "día fuera de rango: ..." a stderr y código 1 (paso 11)

echo "sin implementar: $date_in"
