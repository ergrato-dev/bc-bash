#!/usr/bin/env bash
# parse-date.sh — separa una fecha AAAA-MM-DD en año, mes y día, y rechaza las mal escritas.
set -euo pipefail

date_in="${1:?uso: parse-date.sh <AAAA-MM-DD>}"

# Cada paréntesis es un grupo: BASH_REMATCH[1], [2] y [3] guardan lo que encaja con él.
# Sin ^ y $, "x2026-11-08y" también encajaría.
re='^([0-9]{4})-([0-9]{2})-([0-9]{2})$'
if [[ ! $date_in =~ $re ]]; then
  echo "fecha mal escrita: '$date_in' (usa AAAA-MM-DD)" >&2
  exit 1
fi
year="${BASH_REMATCH[1]}"
month="${BASH_REMATCH[2]}"
day="${BASH_REMATCH[3]}"

# 10# obliga a leer en base 10: "08" y "09" empiezan por 0 y bash los tomaría por octal.
if (( 10#$month < 1 || 10#$month > 12 )); then
  echo "mes fuera de rango: '$date_in'" >&2
  exit 1
fi
if (( 10#$day < 1 || 10#$day > 31 )); then
  echo "día fuera de rango: '$date_in'" >&2
  exit 1
fi

echo "año $year, mes $month, día $day"
