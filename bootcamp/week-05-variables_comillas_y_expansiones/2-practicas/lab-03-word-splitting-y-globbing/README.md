# Lab 03 — Word splitting y globbing

⏱ Duración estimada: ~60 min

## Objetivo

Ver cómo bash parte en palabras y expande con globs una variable sin comillas, y evitarlo con comillas dobles y `--`.

## Contexto

- Después de sustituir una variable **sin comillas**, bash hace dos cosas más con su valor: la parte por los espacios (*word splitting*) y cambia cada palabra con `*`, `?` o `[ ]` por los archivos que encajan (*globbing*) ([teoría](../../1-teoria/02-word-splitting-y-globbing.md)).
- Con comillas dobles no hace ninguna de las dos: `"$f"` es siempre una palabra, con el valor tal cual.
- `starter/archive-report.sh` mueve un informe a `zona/archivo/` y borra los temporales. Con un nombre con espacios mueve el archivo equivocado, y con un nombre que empieza por `-` no borra nada.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-05-variables_comillas_y_expansiones/2-practicas/lab-03-word-splitting-y-globbing
   ```
   (sin salida).

1. **Los archivos de prueba.** Copia la línea entera. `rm -rf zona` borra lo que hubiera de una prueba anterior, así que puedes repetir este paso siempre que quieras empezar de cero:
   ```bash
   rm -rf zona && mkdir zona && touch "zona/informe final.txt" zona/final.txt zona/notas.txt zona/cache.tmp zona/-f.tmp
   ls zona
   ```
   ```text
   -f.tmp
   cache.tmp
   final.txt
   informe final.txt
   notas.txt
   ```
   Dos informes (uno con un espacio en el nombre), unas notas y dos temporales, uno que empieza por `-`.

2. **Word splitting:**
   ```bash
   f="zona/informe final.txt"
   ls $f
   ls "$f"
   ```
   ```text
   ls: cannot access 'zona/informe': No such file or directory
   ls: cannot access 'final.txt': No such file or directory
   zona/informe final.txt
   ```
   Sin comillas, `ls` recibe **dos** argumentos, `zona/informe` y `final.txt`, y no existe ninguno. Con comillas, uno.

3. **Ver las palabras.** `printf '[%s]\n'` imprime cada argumento que recibe entre corchetes, uno por línea (semana 09). Es la forma de ver qué le llega a un comando:
   ```bash
   printf '[%s]\n' $f
   printf '[%s]\n' "$f"
   ```
   ```text
   [zona/informe]
   [final.txt]
   [zona/informe final.txt]
   ```

4. **Los espacios repetidos se pierden:**
   ```bash
   frase="uno     dos"
   echo $frase
   echo "$frase"
   ```
   ```text
   uno dos
   uno     dos
   ```
   Sin comillas, `echo` recibe dos palabras y las une con un espacio. Los cinco espacios no llegan.

5. **Globs.** `*` es "cualquier texto, también vacío"; `?`, "un carácter"; `[cn]`, "una `c` o una `n`":
   ```bash
   echo zona/*.txt
   echo zona/?????.txt
   echo zona/[cn]*
   ```
   ```text
   zona/final.txt zona/informe final.txt zona/notas.txt
   zona/final.txt zona/notas.txt
   zona/cache.tmp zona/notas.txt
   ```
   bash cambia el patrón por la lista de nombres que encajan, ordenada, antes de ejecutar `echo`. Es la misma expansión que rompía el `find -name *.log` de la semana 04.

6. **Cuando no encaja nada, y entre comillas:**
   ```bash
   echo zona/*.pdf
   echo "zona/*.txt"
   ```
   ```text
   zona/*.pdf
   zona/*.txt
   ```
   Sin ningún archivo que encaje, el patrón llega tal cual. Entre comillas no se expande nunca.

7. **Un glob guardado en una variable:**
   ```bash
   patron='zona/*.tmp'
   echo $patron
   echo "$patron"
   ```
   ```text
   zona/-f.tmp zona/cache.tmp
   zona/*.tmp
   ```
   La asignación guarda el texto `zona/*.tmp`. Al usar `$patron` sin comillas, bash lo expande en ese momento.

8. **El script, sin tocar:**
   ```bash
   bash starter/archive-report.sh
   echo $?
   ls zona zona/archivo
   ```
   ```text
   mv: cannot stat 'informe': No such file or directory
   1
   zona:
   -f.tmp
   archivo
   cache.tmp
   informe final.txt
   notas.txt

   zona/archivo:
   final.txt
   ```
   `mv $origen archivo/` recibió `informe`, `final.txt` y `archivo/`: "mueve `informe` y `final.txt` a `archivo/`". `informe` no existe, pero `final.txt` sí, y lo movió. **El informe que tenía que quedarse está archivado y el que había que archivar sigue fuera.** Así es como un script sin comillas acaba borrando o pisando archivos que nadie nombró.

9. **TODO 1.** Abre `starter/archive-report.sh` en tu editor. En la línea del `mv`, pon `"$origen"` entre comillas dobles, y `--` justo después de `mv` (el paso 10 explica por qué). Borra el comentario del `TODO 1`. Repite el paso 1 y prueba:
   ```bash
   bash starter/archive-report.sh
   echo $?
   ```
   ```text
   rm: invalid option -- '.'
   Try 'rm ./-f.tmp' to remove the file '-f.tmp'.
   Try 'rm --help' for more information.
   1
   ```
   El `mv` ya funciona. Ahora falla el `rm`.

10. **TODO 2.** `rm *.tmp` se expande a `rm -f.tmp cache.tmp`, y `rm` toma `-f.tmp` por sus opciones `-f`, `-.`, `-t`... `--` le dice "aquí acaban las opciones: lo que sigue son archivos". Cambia la línea a `rm -- *.tmp` y borra el comentario del `TODO 2`. Repite el paso 1 y prueba:
    ```bash
    bash starter/archive-report.sh
    echo $?
    ls zona
    ```
    ```text
    en archivo/:
    informe final.txt
    0
    archivo
    final.txt
    notas.txt
    ```
    El propio `rm` proponía otra solución: `./*.tmp`, que se expande a `./-f.tmp`, que ya no empieza por `-`.

11. **TODO 3.** Sustituye el comentario del `TODO 3` por un `echo` que imprima `informes que quedan:` (entre comillas) y, **fuera** de las comillas, el glob `*.txt`. Repite el paso 1 y prueba:
    ```bash
    bash starter/archive-report.sh | tail -1
    ```
    ```text
    informes que quedan: final.txt notas.txt
    ```

## Criterios de éxito

- [ ] Explicas qué argumentos recibió `mv` en el paso 8 y por qué movió `final.txt`
- [ ] Explicas qué hace bash con `zona/*.pdf` cuando no hay ningún `.pdf` (paso 6)
- [ ] Explicas por qué `rm *.tmp` falla con un archivo llamado `-f.tmp` y qué arregla `--` (paso 10)
- [ ] Tras repetir el paso 1, `bash starter/archive-report.sh` sale con `0`, deja `informe final.txt` en `zona/archivo/` y `final.txt` fuera, e imprime `informes que quedan: final.txt notas.txt`

## Reto extra

Repite el paso 1, borra los dos informes que no se archivan (`rm zona/final.txt zona/notas.txt`) y ejecuta el script: ¿qué imprime en la última línea, y por qué (paso 6)? En la semana 07 verás `shopt -s nullglob`, que hace que un glob sin resultados desaparezca en lugar de quedarse tal cual.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 02 — Comillas](../lab-02-comillas/README.md) | [Lab 04 — Valores por defecto](../lab-04-valores-por-defecto/README.md) → |

[↑ Semana 05](../../README.md)
