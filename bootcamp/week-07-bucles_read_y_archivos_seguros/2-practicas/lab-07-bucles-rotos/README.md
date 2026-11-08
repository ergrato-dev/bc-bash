# Lab 07 — Bucles rotos

⏱ Duración estimada: ~60 min

## Objetivo

Encontrar y arreglar los cuatro fallos típicos de los bucles de un script, los dos que ve shellcheck y los dos que solo aparecen al ejecutarlo.

## Contexto

- `starter/count-errors.sh` cuenta las líneas con `ERROR` de cada `.log` de una carpeta, y el total. Viene **roto a propósito**: cuatro fallos, cada uno marcado con un TODO.
- shellcheck ve los fallos de forma (un `$(ls)`, un `read` sin `-r`), pero no sabe qué hará el script con tus datos. Los otros dos solo se ven ejecutándolo con datos de los que conoces la respuesta.
- `datos/` tiene tres logs; uno se llama `app web.log`, con un espacio.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-07-bucles_read_y_archivos_seguros/2-practicas/lab-07-bucles-rotos
   ```
   (sin salida).

1. **La respuesta correcta.** `grep -c` cuenta las líneas que encajan (semana 04), archivo por archivo:
   ```bash
   grep -c ERROR datos/*.log
   ```
   ```text
   datos/app web.log:2
   datos/cache.log:0
   datos/db.log:1
   ```
   El script tiene que decir lo mismo y `total: 3 errores`.

2. **Lo que responde.**
   ```bash
   bash starter/count-errors.sh datos; echo $?
   ```
   ```text
   cat: datos/app: No such file or directory
   1
   ```

3. **Lo que ve shellcheck.**
   ```bash
   shellcheck starter/count-errors.sh
   ```
   ```text

   In starter/count-errors.sh line 10:
   for f in $(ls $dir/*.log); do
            ^--------------^ SC2045 (error): Iterating over ls output is fragile. Use globs.
                 ^--^ SC2086 (info): Double quote to prevent globbing and word splitting.

   Did you mean:
   for f in $(ls "$dir"/*.log); do


   In starter/count-errors.sh line 13:
     cat "$f" | while read line; do
         ^--^ SC2002 (style): Useless cat. Consider 'cmd < file | ..' or 'cmd file | ..' instead.
                      ^--^ SC2162 (info): read without -r will mangle backslashes.

   For more information:
     https://www.shellcheck.net/wiki/SC2045 -- Iterating over ls output is fragi...
     https://www.shellcheck.net/wiki/SC2086 -- Double quote to prevent globbing ...
     https://www.shellcheck.net/wiki/SC2162 -- read without -r will mangle backs...
   ```
   Dos líneas con avisos. El `((errors++))` y lo que pasa con `errors` al salir del `while` no aparecen.

4. **TODO 1, línea 10: `$(ls)`.** `$(ls ...)` devuelve un texto y bash lo parte por los espacios: `app web.log` llega como `datos/app` y `web.log` (lab 01, paso 4). Cambia la línea por un glob:
   ```bash
   for f in "$dir"/*.log; do
   ```
   Borra el comentario del `TODO 1`. Prueba:
   ```bash
   bash starter/count-errors.sh datos; echo $?
   ```
   ```text
   1
   ```
   Ningún mensaje y código `1`: algo salió con `1` y `set -e` paró el script sin decir nada. Antes de buscarlo, el aviso que queda de shellcheck en el `read`.

5. **TODO 2: `read` sin `-r`.** Sin `-r`, `read` se come las `\` de cada línea (lab 04, paso 2): una ruta de Windows en un log, `C:\temp`, llegaría como `C:temp`. Cambia `while read line` por `while IFS= read -r line`. Borra `TODO 2 y` del comentario de esa línea (deja `# TODO 4`). Prueba:
   ```bash
   bash starter/count-errors.sh datos; echo $?
   shellcheck starter/count-errors.sh | grep -o 'SC[0-9]*'
   ```
   ```text
   1
   SC2002
   SC2002
   ```
   El script sigue parando. Queda un solo aviso, `SC2002` (sale dos veces: en el aviso y en el enlace a su wiki), que es de estilo: el TODO 4.

6. **TODO 3: `((errors++))`.** Pruébalo en la terminal, sin `set -e`:
   ```bash
   errors=0; ((errors++)); echo "codigo $? errors $errors"; ((errors++)); echo "codigo $? errors $errors"
   ```
   ```text
   codigo 1 errors 1
   codigo 0 errors 2
   ```
   `(( ))` sale con `1` cuando el resultado de la cuenta es `0`, y `errors++` da el valor **de antes** de sumar. La primera vez vale `0`: código `1`, y `set -e` para el script en la primera línea con `ERROR`. Cambia `((errors++))` por:
   ```bash
         errors=$((errors + 1))
   ```
   `$(( ))` es una expansión, no un comando: la línea siempre sale con `0`. Borra el comentario del `TODO 3`. Prueba:
   ```bash
   bash starter/count-errors.sh datos; echo $?
   ```
   ```text
   0 datos/app web.log
   0 datos/cache.log
   0 datos/db.log
   total: 0 errores
   0
   ```
   Termina, pero todo da `0`.

7. **TODO 4: `cat | while`.** El `while` va detrás de un pipe: es un subshell con su propia copia de `errors` (lab 06, paso 4). Cuenta bien dentro, pero la copia desaparece en el `done`, y el `echo` de debajo ve la `errors=0` de antes. El `cat` sobra: `done < "$f"` le pasa el archivo al `while` sin pipe (lab 04). Quita `cat "$f" | ` del principio de la línea del `while`, que queda así:
   ```bash
     while IFS= read -r line; do
   ```
   y cambia el `done` de ese bucle por:
   ```bash
     done < "$f"
   ```
   Borra el comentario del `TODO 4`. Prueba:
   ```bash
   bash starter/count-errors.sh datos; echo $?
   ```
   ```text
   2 datos/app web.log
   0 datos/cache.log
   1 datos/db.log
   total: 3 errores
   0
   ```
   Lo mismo que en el paso 1.

8. **shellcheck limpio.**
   ```bash
   shellcheck starter/count-errors.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas por qué el script paraba sin mensaje después del TODO 1 (paso 6)
- [ ] Explicas por qué todo daba `0` después del TODO 3 (paso 7)
- [ ] `bash starter/count-errors.sh datos` imprime los mismos números que `grep -c` y `total: 3 errores`
- [ ] `shellcheck starter/count-errors.sh` no imprime nada

## Reto extra

Crea `datos/vacio.log` sin contenido (`touch`) y otro sin salto de línea al final con `printf 'ERROR al final' > datos/sin-salto.log`. ¿Cuenta bien el segundo? Arréglalo con lo del lab 04, paso 9. Borra los dos archivos al terminar.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 06 — find -print0](../lab-06-find-print0/README.md) | [Proyecto — bk-clean: borrar lo viejo sin miedo](../../3-proyecto/README.md) → |

[↑ Semana 07](../../README.md)
