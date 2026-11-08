#!/usr/bin/env bash
# Lanza un proceso en segundo plano, lo localiza con ps y lo para con kill.
# Sin set -euo pipefail todavía: llega en la semana 03.

# $$ es el PID del bash que ejecuta este script.
echo "PID de este script: $$"

# & lo lanza en segundo plano: el script sigue sin esperar a que sleep termine.
sleep 30 &
# $! guarda el PID del último proceso lanzado con &.
echo "PID de sleep: $!"

echo "== procesos antes de kill =="
ps -o pid,ppid,stat,comm

# Sin kill, sleep seguiría vivo 30 s después de que el script termine.
kill "$!"
# wait espera a que sleep muera de verdad; sin él, el ps siguiente aún podría verlo.
wait "$!"

echo "== procesos después de kill =="
ps -o pid,ppid,stat,comm
