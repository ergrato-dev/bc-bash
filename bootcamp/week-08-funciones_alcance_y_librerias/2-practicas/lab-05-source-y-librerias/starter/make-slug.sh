#!/usr/bin/env bash
# make-slug.sh — convierte un título en un nombre de archivo: "Informe Anual" da "informe-anual".
# Para qué: nombres de archivo sin espacios ni mayúsculas, que no hace falta citar.
set -euo pipefail

# TODO 2: source de lib/strings.sh buscada junto a este script, con BASH_SOURCE.
source lib/strings.sh

for title in "$@"; do
  to_slug "$title"
done
