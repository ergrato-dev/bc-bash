#!/usr/bin/env bash
# bytes-by-path.sh — cuántas peticiones y cuántos bytes se llevó cada ruta de un access log, de más a menos bytes.
# Para qué: saber qué archivo se come el ancho de banda antes de pagar más.
set -euo pipefail

log="${1:?uso: bytes-by-path.sh <access.log>}"

# La cabecera la escribe bash, antes del pipe: si la escribiera el BEGIN de awk, sort la ordenaría con las filas.
printf '%-12s %10s %10s\n' RUTA PETICIONES BYTES
awk '
  # Una casilla por ruta: count y bytes empiezan vacías, que en una suma valen 0.
  # Un "-" en los bytes (respuesta sin cuerpo) también suma 0.
  { count[$7]++; bytes[$7] += $10 }
  # END se ejecuta una vez, después de la última línea: aquí ya están todas las sumas.
  END { for (path in count) printf "%-12s %10d %10d\n", path, count[path], bytes[path] }
' "$log" |
  # for (... in ...) sale sin orden, como en bash: -k3 ordena por la 3.ª columna, -rn de más a menos.
  sort -k3 -rn
