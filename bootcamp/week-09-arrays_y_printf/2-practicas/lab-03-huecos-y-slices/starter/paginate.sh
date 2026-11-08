#!/usr/bin/env bash
# paginate.sh — enseña una página de una lista larga, 4 líneas por página.
set -euo pipefail

per_page=4

main() {
  local file="${1:?uso: paginate.sh <archivo> <página>}"
  local page="${2:?uso: paginate.sh <archivo> <página>}"
  local lines=() pages
  mapfile -t lines < "$file"

  # TODO 2: cuántas páginas hay, redondeando hacia arriba.
  pages=1
  # TODO 3: avisar y salir con 2 si la página no está entre 1 y pages.

  echo "página $page de $pages"
  # TODO 1: solo las líneas de esa página, no todas.
  printf '  %s\n' "${lines[@]}"
}

main "$@"
