# Lab 02 — grep: elegir líneas

⏱ Duración estimada: ~60 min

## Objetivo

Elegir las líneas de un log que te interesan con `grep` y sus opciones, y tratar bien el caso "no encontró nada" en un script con `set -e`.

## Contexto

- `grep patrón archivo` imprime las líneas que contienen el patrón. Sus opciones cambian qué líneas salen y cómo ([teoría](../../1-teoria/02-grep-y-expresiones-regulares.md)).
- `grep` responde también con el código: `0` si encontró, `1` si no encontró y `2` si hubo un error. Con `set -e`, ese `1` para el script.
- `datos/app.log` es el mismo log del lab 01. `starter/errors-report.sh` tiene un fallo a propósito y dos TODOs.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-04-filtros_de_texto_y_regex/2-practicas/lab-02-grep
   ```
   (sin salida).

1. **Las líneas que tienen un texto:**
   ```bash
   grep ERROR datos/app.log
   grep -c ERROR datos/app.log
   ```
   ```text
   2026-11-07 08:12:55 ERROR db: timeout al consultar pedidos
   2026-11-07 08:45:23 ERROR web: POST /api/orders 500
   2026-11-07 09:22:48 ERROR disk: disco lleno en /var, no se puede escribir
   2026-11-07 09:22:49 ERROR web: POST /api/orders 500
   2026-11-07 10:14:27 ERROR db: autenticación fallida para el usuario report
   5
   ```
   `-c` (*count*) cuenta las líneas en vez de imprimirlas.

2. **Mayúsculas y palabras enteras:**
   ```bash
   grep -c disco datos/app.log
   grep -ci disco datos/app.log
   grep -c web datos/app.log
   grep -cw web datos/app.log
   ```
   ```text
   3
   4
   14
   13
   ```
   La línea 8 dice `Disco`: sin `-i` (*ignore case*) no cuenta. Y `web` también aparece dentro de `webhook:`; con `-w` (*word*) solo cuenta `web` como palabra entera. Las opciones de una letra se juntan: `-ci` es `-c -i`.

3. **Al revés y con número de línea:**
   ```bash
   grep -v INFO datos/app.log
   ```
   ```text
   2026-11-07 08:05:40 WARN web: respuesta lenta en /api/orders (1840 ms)
   2026-11-07 08:12:55 ERROR db: timeout al consultar pedidos
   2026-11-07 08:20:44 WARN disk: Disco al 85% en /var
   2026-11-07 08:45:23 ERROR web: POST /api/orders 500
   2026-11-07 09:10:37 WARN disk: disco al 91% en /var
   2026-11-07 09:22:48 ERROR disk: disco lleno en /var, no se puede escribir
   2026-11-07 09:22:49 ERROR web: POST /api/orders 500
   2026-11-07 09:55:31 WARN db: 3 conexiones en espera
   2026-11-07 10:14:27 ERROR db: autenticación fallida para el usuario report
   2026-11-07 10:33:48 WARN web: respuesta lenta en /api/users (2210 ms)
   ```
   `-v` deja lo que **no** tiene el patrón: quitar el ruido de `INFO` deja solo lo que hay que mirar.
   ```bash
   grep -n WARN datos/app.log
   ```
   ```text
   4:2026-11-07 08:05:40 WARN web: respuesta lenta en /api/orders (1840 ms)
   8:2026-11-07 08:20:44 WARN disk: Disco al 85% en /var
   13:2026-11-07 09:10:37 WARN disk: disco al 91% en /var
   20:2026-11-07 09:55:31 WARN db: 3 conexiones en espera
   24:2026-11-07 10:33:48 WARN web: respuesta lenta en /api/users (2210 ms)
   ```
   `-n` pone delante el número de línea: con él puedes ir a ese punto del archivo original (en `less`, escribe el número y `g`).

4. **Un grep detrás de otro.** Cada `grep` de un pipe filtra lo que dejó el anterior:
   ```bash
   grep ERROR datos/app.log | grep -c db
   grep -E 'WARN|ERROR' datos/app.log | grep -v disk | wc -l
   ```
   ```text
   2
   7
   ```
   Errores de la base de datos: 2. Avisos y errores que no son del disco: 7. `-E` permite `|`, "una cosa u otra"; lo verás en el lab 03.

5. **El código de salida:**
   ```bash
   grep -q CRITICAL datos/app.log
   echo $?
   grep -c CRITICAL datos/app.log
   echo $?
   grep -q ERROR datos/no-existe.log
   echo $?
   ```
   ```text
   1
   0
   1
   grep: datos/no-existe.log: No such file or directory
   2
   ```
   `-q` (*quiet*) no imprime nada: solo contesta con el código. `-c` imprime `0`, pero su código también es `1`: no encontró nada. Y `2` es otra cosa, un error de verdad.

6. **Buscar en una carpeta entera:**
   ```bash
   grep -rn puerto .
   ```
   ```text
   ./datos/app.log:1:2026-11-07 08:00:01 INFO web: servicio arrancado en el puerto 8080
   ```
   `-r` (*recursive*) busca en todos los archivos debajo de `.`, la carpeta actual. Con varios archivos, `grep` pone delante el nombre de cada uno.

7. **El script, sin tocar:**
   ```bash
   bash starter/errors-report.sh
   echo $?
   ```
   ```text
   errores: 5
   1
   ```
   Imprime una línea y sale con `1`, sin ningún mensaje de error. Algo falló, pero ¿qué?

8. **Ver qué ejecuta.** `bash -x` enseña cada línea antes de ejecutarla, con `+` delante (`++` si va dentro de `$( )`). La semana 12 lo ve a fondo; aquí basta para encontrar dónde se para:
   ```bash
   bash -x starter/errors-report.sh
   ```
   ```text
   + set -euo pipefail
   + log=datos/app.log
   + mkdir -p zona
   ++ grep -c ERROR datos/app.log
   + errores=5
   + echo 'errores: 5'
   errores: 5
   ++ grep -c CRITICAL datos/app.log
   + criticos=0
   ```
   Lo último que se ejecuta es el `grep -c CRITICAL`. No hay ninguna línea `CRITICAL`, así que `grep` sale con `1` (paso 5) y `set -e` para el script, aunque `0` críticos sea justo la respuesta que querías.

9. **TODO 1.** Abre `starter/errors-report.sh` en tu editor. Añade `|| true` dentro del `$( )`, detrás del `grep`: `$(grep -c CRITICAL "$log" || true)`. Si `grep` falla, se ejecuta `true`, que sale con `0`, y `-e` no salta (semana 03). El `0` ya lo había impreso `grep -c`. Borra el comentario del `TODO 1`. Prueba:
   ```bash
   bash starter/errors-report.sh
   echo $?
   ```
   ```text
   errores: 5
   críticos: 0
   0
   ```

10. **TODO 2.** Sustituye la línea del `TODO 2` por un `echo` que imprima `disco: ` y el recuento sin distinguir mayúsculas, con `$(grep -ci ...)`. Aquí no hace falta `|| true`: si un día no hubiera ninguna, el `$( )` va dentro de los argumentos de `echo`, y `-e` solo mira el código del `echo`. Prueba:
    ```bash
    bash starter/errors-report.sh
    ```
    ```text
    errores: 5
    críticos: 0
    disco: 4
    ```

11. **TODO 3.** Sustituye la línea del `TODO 3` por un `grep` con número de línea redirigido a `zona/errores.txt`. Borra los comentarios `TODO`. Prueba:
    ```bash
    bash starter/errors-report.sh > /dev/null
    cat zona/errores.txt
    ```
    ```text
    6:2026-11-07 08:12:55 ERROR db: timeout al consultar pedidos
    10:2026-11-07 08:45:23 ERROR web: POST /api/orders 500
    15:2026-11-07 09:22:48 ERROR disk: disco lleno en /var, no se puede escribir
    16:2026-11-07 09:22:49 ERROR web: POST /api/orders 500
    22:2026-11-07 10:14:27 ERROR db: autenticación fallida para el usuario report
    ```

## Criterios de éxito

- [ ] Explicas qué hacen `-i`, `-w`, `-v` y `-n` con un ejemplo de este log (pasos 2 y 3)
- [ ] Explicas los tres códigos de salida de `grep` (paso 5)
- [ ] Explicas por qué el script del paso 7 se paraba y por qué `|| true` lo arregla (pasos 8 y 9)
- [ ] `bash starter/errors-report.sh` imprime las tres líneas del paso 10, sale con `0` y deja 5 líneas en `zona/errores.txt`

## Reto extra

`grep -c ERROR datos/app.log` y `grep ERROR datos/app.log | wc -l` dan lo mismo. Prueba ahora con un patrón que no aparezca, como `FATAL`, y mira `echo $?` después de cada uno. ¿Cuál de los dos pararía un script con `set -euo pipefail`? Piensa por qué con lo que sabes de `pipefail`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 01 — Ver y contar líneas](../lab-01-ver-y-contar-lineas/README.md) | [Lab 03 — Expresiones regulares](../lab-03-expresiones-regulares/README.md) → |

[↑ Semana 04](../../README.md)
