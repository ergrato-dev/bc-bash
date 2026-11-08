#!/usr/bin/env bash
# write-bashrc.sh — prepara un .bashrc de prueba con un saludo, un alias y el PATH.
set -euo pipefail

destino=zona/bashrc
usuario=alumno
mkdir -p zona

# Dobles para que $usuario se sustituya ya; \" deja las comillas dentro del archivo.
echo "echo \"Hola, $usuario\"" > "$destino"
# Sin las dobles de fuera, bash quitaría las simples y quedaría alias ll=ls -l, roto.
echo "alias ll='ls -l'" >> "$destino"
# Simples a propósito: $HOME y $PATH tienen que llegar sin sustituir al archivo,
# para que se calculen cada vez que se abra la shell, no ahora.
# shellcheck disable=SC2016
echo 'export PATH="$HOME/bin:$PATH"' >> "$destino"

cat "$destino"
