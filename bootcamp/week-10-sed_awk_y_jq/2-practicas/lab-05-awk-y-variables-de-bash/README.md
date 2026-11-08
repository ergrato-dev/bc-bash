# Lab 05 — awk y las variables de bash

⏱ Duración estimada: ~60 min

## Objetivo

Pasar datos de bash a `awk` con `-v`, comparar números que llegan pegados a un texto y devolver un código de salida desde `awk`.

## Contexto

- El programa de awk va entre comillas simples, así que bash no cambia nada dentro: `$limit` ahí no es tu variable. Para pasarla, `awk -v limit="$limit"`, y en el programa se escribe `limit`, sin `$`.
- awk decide si compara como número o como texto según lo que ve. `532ms` no parece un número, y comparado con `500`, se compara letra a letra.
- `datos/tiempos.log` tiene una petición por línea, con su fecha y hora, método, ruta, código y lo que tardó. `starter/slow-requests.sh` tiene que enseñar las que tardaron más de N milisegundos y salir con `1` si hay alguna, para que un cron o un CI avise.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-10-sed_awk_y_jq/2-practicas/lab-05-awk-y-variables-de-bash
   ```
   (sin salida).

1. **Una variable pegada en el programa.** Con comillas dobles, bash sí pone el valor:
   ```bash
   n=5
   awk "BEGIN { print $n * 2 }"
   n='system("echo te he colado un comando")'
   awk "BEGIN { print $n }"
   awk -v n="$n" 'BEGIN { print n }'
   ```
   ```text
   10
   te he colado un comando
   0
   system("echo te he colado un comando")
   ```
   El valor de `n` pasa a ser parte del programa: si viene de un archivo o de un usuario, puede ejecutar lo que quiera (`system` lanza un comando). Con `-v`, llega como un dato y awk lo escribe tal cual. Lo mismo pasa con `sed` y con `jq`: los datos, siempre por su opción, nunca pegados.

2. **`OFS`.**
   ```bash
   echo "a b c" | awk -v OFS=, '{ print }'
   echo "a b c" | awk -v OFS=, '{ $1 = $1; print }'
   echo "a b c" | awk -v OFS=, '{ print $3, $1 }'
   ```
   ```text
   a b c
   a,b,c
   c,a
   ```
   `OFS` es lo que awk pone entre los campos al escribir. `print` a secas escribe la línea como llegó; al cambiar un campo, aunque sea por él mismo (`$1 = $1`), awk la rehace con `OFS`. Y las comas de `print` también ponen `OFS`.

3. **Texto o número.**
   ```bash
   awk 'BEGIN { print ("95ms" > "500"), ("95ms" + 0 > 500), "532ms" + 0 }'
   ```
   ```text
   1 0 532
   ```
   Como textos, `"95ms"` va después de `"500"` porque `9` va después de `5`: "es mayor". Sumarle `0` lo convierte en número: awk se queda con las cifras del principio y para en la `m`.

4. **`split`.**
   ```bash
   echo 10:00:01 | awk '{ n = split($0, p, ":"); print n, p[1], p[3] }'
   ```
   ```text
   3 10 01
   ```
   `split(texto, array, separador)` corta el texto, guarda los trozos en el array desde el `1` y devuelve cuántos hay.

5. **El script, tal cual.** Abre `starter/slow-requests.sh` en tu editor y ejecútalo:
   ```bash
   bash starter/slow-requests.sh datos/tiempos.log 500; echo $?
   ```
   ```text
   2026-11-08T10:00:01 GET /api/pedidos 200 532ms
   2026-11-08T10:00:02 GET /api/stock 200 95ms
   2026-11-08T10:00:04 POST /api/pago 201 1240ms
   2026-11-08T10:00:07 GET /health 200 3ms
   2026-11-08T10:00:09 GET /api/pedidos 500 2210ms
   0
   ```
   Todas: dentro de awk, `limit` es una variable que nadie ha llenado, vacía, y cualquier texto va después del texto vacío.

6. **TODO 1: el límite con `-v`.** Cambia el `awk` por:
   ```bash
   awk -v limit="$limit" '$5 > limit' "$log"
   ```
   Prueba:
   ```bash
   bash starter/slow-requests.sh datos/tiempos.log 500
   ```
   ```text
   2026-11-08T10:00:01 GET /api/pedidos 200 532ms
   2026-11-08T10:00:02 GET /api/stock 200 95ms
   ```
   El paso 3: `95ms` sale y `1240ms` no, porque se comparan como textos.

7. **TODO 2: como número.** Cambia el `awk` por:
   ```bash
   awk -v limit="$limit" '
     { ms = $5 + 0 }
     ms > limit
   ' "$log"
   ```
   La primera regla, sin patrón, se ejecuta en cada línea y guarda el número en `ms`; la segunda escribe la línea si es mayor que el límite. Prueba:
   ```bash
   bash starter/slow-requests.sh datos/tiempos.log 500
   ```
   ```text
   2026-11-08T10:00:01 GET /api/pedidos 200 532ms
   2026-11-08T10:00:04 POST /api/pago 201 1240ms
   2026-11-08T10:00:09 GET /api/pedidos 500 2210ms
   ```

8. **TODO 3: hora, ruta y ms.** Cambia el `awk` por:
   ```bash
   awk -v limit="$limit" -v OFS=' | ' '
     { ms = $5 + 0 }
     ms > limit {
       split($1, t, "T")
       print t[2], $3, ms
     }
   ' "$log"
   ```
   `t[2]` es lo que va detrás de la `T` de la fecha. Prueba:
   ```bash
   bash starter/slow-requests.sh datos/tiempos.log 500; echo $?
   ```
   ```text
   10:00:01 | /api/pedidos | 532
   10:00:04 | /api/pago | 1240
   10:00:09 | /api/pedidos | 2210
   0
   ```
   Hay tres lentas y sale con `0`: un cron no se enteraría.

9. **TODO 4: el código de salida.** `exit` en awk termina el programa con ese código, y es el que ve bash. Añade `slow++` debajo del `print`, y una regla más antes de la comilla del final:
   ```bash
     END { exit (slow > 0) }
   ```
   `(slow > 0)` vale `1` si hubo alguna y `0` si no. Borra los comentarios de los TODO y explica en uno por qué `-v` y por qué `+ 0`. Prueba:
   ```bash
   bash starter/slow-requests.sh datos/tiempos.log 500; echo $?
   bash starter/slow-requests.sh datos/tiempos.log 5000; echo $?
   bash starter/slow-requests.sh datos/tiempos.log 1s; echo $?
   ```
   ```text
   10:00:01 | /api/pedidos | 532
   10:00:04 | /api/pago | 1240
   10:00:09 | /api/pedidos | 2210
   1
   0
   slow-requests.sh: '1s' no es un número de milisegundos
   2
   ```
   Con `set -e`, el `1` de awk para el script con ese mismo código.

10. **shellcheck.**
    ```bash
    shellcheck starter/slow-requests.sh; echo $?
    ```
    ```text
    0
    ```

## Criterios de éxito

- [ ] Explicas por qué `awk "BEGIN { print $n }"` ejecutó un comando y `-v` no (paso 1)
- [ ] Explicas qué hace `$1 = $1` con `OFS` (paso 2)
- [ ] Explicas por qué `95ms` salía como lento en el paso 6
- [ ] `bash starter/slow-requests.sh datos/tiempos.log 500` imprime las tres líneas del paso 9 y sale con `1`
- [ ] `shellcheck starter/slow-requests.sh` no imprime nada

## Reto extra

Añade al final, en stderr, una línea con la media de los tiempos lentos: `media: 1327 ms`. En awk, `print ... > "/dev/stderr"` escribe en stderr. ¿Qué pasa con la media si no hay ninguna lenta?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 04 — awk: BEGIN, END y arrays](../lab-04-awk-begin-end-y-arrays/README.md) | [Lab 06 — jq: leer JSON](../lab-06-jq-leer-json/README.md) → |

[↑ Semana 10](../../README.md)
