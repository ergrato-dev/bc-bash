#!/usr/bin/env bash
# backup-notes.sh — copia los .txt de una carpeta a otra y dice cuántos copió.
# Para qué: guardar las notas antes de tocarlas. Si algo falla, tiene que avisar
# y salir con un código distinto de 0, para que quien lo lance se entere.
set -euo pipefail

src="${1:?uso: backup-notes.sh <origen> <destino>}"
dest="${2:?uso: backup-notes.sh <origen> <destino>}"

# check_src: termina sin hacer nada si el origen no tiene notas.
check_src() {
  # local en su propia línea: "local n=$(...)" devuelve el código de local (siempre 0),
  # y set -e no se enteraría de que find falló con un origen que no existe.
  local n
  n=$(find "$src" -maxdepth 1 -name '*.txt' | wc -l)
  if ((n == 0)); then
    echo "no hay notas en $src"
    exit 0
  fi
}

# copy_one <archivo>: copia un archivo al destino y escribe su nombre.
copy_one() {
  # Se llama desde un if, y ahí dentro set -e no para nada: sin el return, un cp que
  # falla sigue hasta el echo y la función devuelve 0, como si hubiera copiado.
  cp -- "$1" "$dest/" || return
  echo "copiado: ${1##*/}"
}

check_src

count=0
failed=0
for file in "$src"/*.txt; do
  if copy_one "$file"; then
    # Una asignación y no ((count++)): con count en 0, ((count++)) vale 0, devuelve 1
    # y set -e para el script en la primera copia.
    count=$((count + 1))
  else
    echo "no se pudo copiar: $file" >&2
    failed=$((failed + 1))
  fi
done

echo "total: $count copiados, $failed fallos"
# La última línea decide el código de salida: 1 si algún archivo no se copió.
[[ $failed -eq 0 ]]
