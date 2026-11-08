#!/usr/bin/env bash
# paginate.sh — enseña una página de una lista larga, 4 líneas por página.
set -euo pipefail

per_page=4

main() {
  local file="${1:?uso: paginate.sh <archivo> <página>}"
  local page="${2:?uso: paginate.sh <archivo> <página>}"
  local lines=() pages
  mapfile -t lines < "$file"

  # Redondeo hacia arriba: con 10 líneas, la página 3 lleva las 2 que sobran.
  pages=$(((${#lines[@]} + per_page - 1) / per_page))
  if [[ ! $page =~ ^[0-9]+$ ]] || ((page < 1 || page > pages)); then
    echo "paginate.sh: la página va de 1 a $pages" >&2
    exit 2
  fi

  echo "página $page de $pages"
  # Desde la posición (page - 1) * per_page, per_page elementos (menos si no quedan).
  printf '  %s\n' "${lines[@]:(page - 1) * per_page:per_page}"
}

main "$@"
