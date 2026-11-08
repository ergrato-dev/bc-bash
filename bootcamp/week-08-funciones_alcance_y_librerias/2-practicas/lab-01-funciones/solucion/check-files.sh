#!/usr/bin/env bash
# check-files.sh — dice cuántas líneas tiene cada archivo, o que falta.
# Para qué: comprobar de un vistazo que los archivos que necesita un servicio están.
set -euo pipefail

# check_file <archivo>: una línea con "ok" y las líneas, o "falta".
check_file() {
  if [[ -f $1 ]]; then
    echo "ok: $1 ($(wc -l < "$1") líneas)"
  else
    echo "falta: $1"
  fi
}

main() {
  echo "comprobando $# archivos"
  for f in "$@"; do
    check_file "$f"
  done
}

# main al final: cuando llega aquí, bash ya ha leído todas las funciones.
main "$@"
