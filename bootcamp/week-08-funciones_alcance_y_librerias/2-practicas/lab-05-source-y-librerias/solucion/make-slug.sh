#!/usr/bin/env bash
# make-slug.sh — convierte un título en un nombre de archivo: "Informe Anual" da "informe-anual".
# Para qué: nombres de archivo sin espacios ni mayúsculas, que no hace falta citar.
set -euo pipefail

# La librería se busca junto a este script, no en la carpeta actual: así funciona
# desde cualquier sitio.
# shellcheck source=SCRIPTDIR/lib/strings.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib/strings.sh"

for title in "$@"; do
  to_slug "$title"
done
