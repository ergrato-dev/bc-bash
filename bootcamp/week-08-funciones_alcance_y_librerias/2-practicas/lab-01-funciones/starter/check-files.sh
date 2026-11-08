#!/usr/bin/env bash
# check-files.sh — dice cuántas líneas tiene cada archivo, o que falta.
# Para qué: comprobar de un vistazo que los archivos que necesita un servicio están.
set -euo pipefail

# check_file <archivo>: una línea con "ok" y las líneas, o "falta".
check_file() {
  # TODO 2: si $1 es un archivo, "ok: $1 (N líneas)" con $(wc -l < "$1"); si no, "falta: $1".
  echo "sin implementar: check_file $1"
}

# TODO 1: función main que diga cuántos archivos recibe ($#) y llame a check_file con cada uno; main "$@" al final.
echo "sin implementar: $*"
