#!/usr/bin/env bash
# team-table.sh — la tabla de guardias del equipo a partir de líneas "nombre:rol:guardias".
set -euo pipefail

# Escribe $1 relleno con espacios hasta $2 caracteres.
pad() {
  # printf cuenta bytes, y una letra con tilde ocupa dos: ${#1} cuenta caracteres.
  printf '%s%*s' "$1" $(($2 - ${#1})) ''
}

main() {
  local file="${1:?uso: team-table.sh <archivo>}"
  local names=() roles=() shifts=()
  local name role n i line total=0 list=""
  while IFS=: read -r name role n; do
    names+=("$name")
    roles+=("$role")
    shifts+=("$n")
    total=$((total + n))
  done < "$file"

  echo "$(pad NOMBRE 11) $(pad ROL 12) GUARDIAS"
  for i in "${!names[@]}"; do
    line="$(pad "${names[i]}" 11) $(pad "${roles[i]}" 12) ${shifts[i]}"
    printf '%s\n' "$line"
  done

  echo "${#names[@]} personas, $total guardias"

  # ${list:+, } da ", " si list ya tiene algo, y nada si está vacía.
  for name in "${names[@]}"; do
    list+="${list:+, }$name"
  done
  echo "orden de guardias: $list"
}

main "$@"
