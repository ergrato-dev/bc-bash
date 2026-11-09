#!/usr/bin/env bash
# archive-reports.sh — copia los informes .txt de una carpeta a otra y apunta cada copia.
# Roto a propósito: funciona con nombres sin espacios y falla con los demás.
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo 'uso: archive-reports.sh <carpeta> <destino>   (ejemplo: archive-reports.sh "$HOME/informes" archivo)' >&2
  exit 2
fi
src=$1
dest=$2

log_copy() {
  local stamp=$(date +%T)
  echo "$stamp $1" >> copias.log
}

mkdir -p $dest
count=0
for f in $(ls $src); do
  [[ $f == *.txt ]] || continue
  cp $src/$f $dest/
  count=$((count + 1))
done

cd $dest
for f in *.txt; do
  log_copy "$f"
done
echo "copiados: $count"
