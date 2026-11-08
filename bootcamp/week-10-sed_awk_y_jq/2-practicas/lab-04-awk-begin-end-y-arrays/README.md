# Lab 04 — awk: BEGIN, END y arrays

⏱ Duración estimada: ~60 min

## Objetivo

Sumar y contar por clave dentro de `awk` con sus arrays, y escribir el resultado en el bloque `END`.

## Contexto

- `BEGIN { }` se ejecuta una vez antes de la primera línea, y `END { }`, una vez después de la última: es donde se escribe un total.
- Los arrays de awk son siempre asociativos: `count["/app.js"]`, sin `declare`. Una casilla que no existe vale vacío, que en una cuenta es `0`: `count[$7]++` funciona desde la primera línea, y no hay `set -e` que lo pare (semana 09, lab 05).
- `datos/access.log` tiene 8 peticiones; el campo 7 es la ruta y el 10, los bytes enviados. `starter/bytes-by-path.sh` tiene que decir qué rutas se llevan más ancho de banda.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-10-sed_awk_y_jq/2-practicas/lab-04-awk-begin-end-y-arrays
   ```
   (sin salida).

1. **Antes, durante y después.**
   ```bash
   awk 'BEGIN { print "antes" } { n++ } END { print "después:", n, "líneas" }' datos/access.log
   awk '{ s += $10 } END { print s }' datos/access.log
   ```
   ```text
   antes
   después: 8 líneas
   5646009
   ```
   `n++` suma 1 por cada línea; `s += $10`, los bytes. Una variable que no has usado vale vacío, y en una suma, `0`:
   ```bash
   awk 'BEGIN { print x + 1, "[" x "]" }'
   ```
   ```text
   1 []
   ```
   Sin archivo, un programa con solo `BEGIN` no espera ninguna línea. En awk, dos textos seguidos se juntan: `"[" x "]"`.

2. **Contar por clave.**
   ```bash
   awk '{ c[$9]++ } END { for (k in c) print k, c[k] }' datos/access.log
   ```
   ```text
   200 5
   206 1
   304 1
   404 1
   ```
   El campo 9 es el código de respuesta. `for (k in c)` recorre las claves: es el `for k in "${!c[@]}"` de bash. Lo que en la semana 09 era un bucle `while read` con un array asociativo, aquí es una línea.

3. **El script, tal cual.** Abre `starter/bytes-by-path.sh` en tu editor y ejecútalo:
   ```bash
   bash starter/bytes-by-path.sh datos/access.log | head -n 3
   ```
   ```text
   / 5120
   /video.mp4 4500000
   /app.js 81920
   ```
   Una línea por petición: falta juntarlas por ruta.

4. **TODO 1: sumar por ruta.** Cambia `{ print $7, $10 }` por:
   ```bash
     { count[$7]++; bytes[$7] += $10 }
   ```
   `;` separa dos instrucciones en la misma línea. Prueba:
   ```bash
   bash starter/bytes-by-path.sh datos/access.log; echo $?
   ```
   ```text
   0
   ```
   Cuenta, pero ya no escribe nada: falta el `END`.

5. **TODO 2: una línea por ruta.** Cambia el comentario del `TODO 2` por:
   ```bash
     END { for (path in count) printf "%-12s %10d %10d\n", path, count[path], bytes[path] }
   ```
   Prueba:
   ```bash
   bash starter/bytes-by-path.sh datos/access.log
   ```
   Algo como (el orden puede cambiar):
   ```text
   /no-existe            1        153
   /app.js               2      81920
   /                     3      15360
   /video.mp4            2    5548576
   ```
   Como en bash, las claves salen sin orden. El `304` de `/app.js` tiene `-` en los bytes, y en una suma vale `0`. Añade un pipe a `sort` detrás del `' "$log"`:
   ```bash
   ' "$log" |
     sort -k3 -rn
   ```
   `-k3` ordena por la tercera columna; `-rn`, como número y de más a menos (semana 04). Prueba:
   ```bash
   bash starter/bytes-by-path.sh datos/access.log
   ```
   ```text
   /video.mp4            2    5548576
   /app.js               2      81920
   /                     3      15360
   /no-existe            1        153
   ```

6. **TODO 3: la cabecera.** El sitio natural parece `BEGIN`. Pon esta línea justo debajo de `awk '`:
   ```bash
     BEGIN { printf "%-12s %10s %10s\n", "RUTA", "PETICIONES", "BYTES" }
   ```
   Prueba:
   ```bash
   bash starter/bytes-by-path.sh datos/access.log
   ```
   ```text
   /video.mp4            2    5548576
   /app.js               2      81920
   /                     3      15360
   /no-existe            1        153
   RUTA         PETICIONES      BYTES
   ```
   La cabecera también pasa por `sort`, y como no tiene números, va al final. Borra esa línea `BEGIN` y escribe la cabecera con el `printf` de bash, encima de `awk`, donde está el comentario del `TODO 3`:
   ```bash
   # La cabecera la escribe bash, antes del pipe: si la escribiera el BEGIN de awk, sort la ordenaría con las filas.
   printf '%-12s %10s %10s\n' RUTA PETICIONES BYTES
   ```
   Borra los comentarios de `TODO 1` y `TODO 2` y explica en uno qué guarda cada array y por qué un `-` suma 0. Prueba:
   ```bash
   bash starter/bytes-by-path.sh datos/access.log
   ```
   ```text
   RUTA         PETICIONES      BYTES
   /video.mp4            2    5548576
   /app.js               2      81920
   /                     3      15360
   /no-existe            1        153
   ```

7. **shellcheck.**
   ```bash
   shellcheck starter/bytes-by-path.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas cuándo se ejecutan `BEGIN` y `END` (paso 1)
- [ ] Explicas por qué `count[$7]++` funciona sin crear antes el array (paso 1)
- [ ] Explicas por qué la cabecera del `BEGIN` salía al final (paso 6)
- [ ] `bash starter/bytes-by-path.sh datos/access.log` imprime la tabla del paso 6, con `/video.mp4` primero
- [ ] `shellcheck starter/bytes-by-path.sh` no imprime nada

## Reto extra

Añade una fila `TOTAL` al final con todas las peticiones y todos los bytes. Si la escribe el `END`, ¿dónde la deja `sort`? Pista: el programa de awk puede tener dos arrays y una variable más, y bash puede escribir lo que awk le deje en un archivo de `mktemp`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 03 — awk: campos y patrones](../lab-03-awk-campos/README.md) | [Lab 05 — awk y las variables de bash](../lab-05-awk-y-variables-de-bash/README.md) → |

[↑ Semana 10](../../README.md)
