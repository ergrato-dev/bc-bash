#!/usr/bin/env bash
# write-bashrc.sh — prepara un .bashrc de prueba con un saludo, un alias y el PATH.
set -euo pipefail

destino=zona/bashrc
usuario=alumno
mkdir -p zona

# TODO 1: en el archivo tiene que quedar: echo "Hola, alumno" (paso 8)
echo 'echo "Hola, $usuario"' > "$destino"
# TODO 2: en el archivo tiene que quedar: alias ll='ls -l' (paso 9)
echo alias ll='ls -l' >> "$destino"
# TODO 3: en el archivo tiene que quedar, tal cual: export PATH="$HOME/bin:$PATH" (paso 10)
echo "export PATH=\"$HOME/bin:$PATH\"" >> "$destino"

cat "$destino"
