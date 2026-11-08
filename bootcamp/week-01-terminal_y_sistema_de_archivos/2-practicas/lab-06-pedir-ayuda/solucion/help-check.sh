#!/usr/bin/env bash
# help-check.sh — usa type, help y una opción de ls que encontraste en man.

echo "== qué es cd =="
type cd

echo "== qué es mkdir =="
type mkdir

echo "== pwd en una línea =="
help -d pwd

echo "== tamanos, del más grande al más pequeño =="
ls -S starter/tamanos
