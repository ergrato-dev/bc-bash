#!/usr/bin/env bash
# backup-notes.sh — copia los .txt de una carpeta a otra y dice cuántos copió.
# Para qué: guardar las notas antes de tocarlas. Si algo falla, tiene que avisar
# y salir con un código distinto de 0, para que quien lo lance se entere.
set -euo pipefail

src="${1:?uso: backup-notes.sh <origen> <destino>}"
dest="${2:?uso: backup-notes.sh <origen> <destino>}"

# check_src: termina sin hacer nada si el origen no tiene notas.
check_src() {
  local n=$(find "$src" -maxdepth 1 -name '*.txt' | wc -l)
  if ((n == 0)); then
    echo "no hay notas en $src"
    exit 0
  fi
}

# copy_one <archivo>: copia un archivo al destino y escribe su nombre.
copy_one() {
  cp -- "$1" "$dest/"
  echo "copiado: ${1##*/}"
}

check_src

count=0
failed=0
for file in "$src"/*.txt; do
  if copy_one "$file"; then
    ((count++))
  else
    echo "no se pudo copiar: $file" >&2
    ((failed++))
  fi
done

echo "total: $count copiados, $failed fallos"
# La última línea decide el código de salida: 1 si algún archivo no se copió.
[[ $failed -eq 0 ]]
