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
# TODO 1: ps -o pid,ppid,stat,comm

# Sin kill, sleep seguiría vivo 30 s después de que el script termine.
# TODO 2: kill con el PID de sleep ("$!")
# wait espera a que sleep muera de verdad; sin él, el ps siguiente aún podría verlo.
# TODO 3: wait con el mismo PID

echo "== procesos después de kill =="
# TODO 4: ps -o pid,ppid,stat,comm
