#!/usr/bin/env bash
# inspect.sh — revisa starter/inbox: qué hay, también lo oculto, y qué es cada cosa.

echo "== todo, también lo oculto =="
ls -a starter/inbox

echo "== leeme.txt =="
cat starter/inbox/leeme.txt

echo "== qué es foto.jpg =="
# file mira el contenido, no la extensión: el nombre no garantiza nada.
file starter/inbox/foto.jpg
