# Lab 04 — cut y tr: columnas y caracteres

⏱ Duración estimada: ~60 min

## Objetivo

Sacar columnas de un archivo con `cut` y limpiar o transformar caracteres con `tr`, incluido el `\r` que dejan los archivos de Windows.

## Contexto

- `cut -d SEP -f N` se queda con el campo `N` de cada línea, separando por `SEP`. `tr` cambia, borra o junta caracteres, y solo lee de stdin ([teoría](../../1-teoria/03-cortar-ordenar-y-contar.md)).
- `datos/ventas.csv` es un CSV (*comma-separated values*): una tabla con una venta por línea y los campos separados por comas. Se exportó desde una hoja de cálculo en Windows, y eso deja una trampa invisible.
- `starter/sales-report.sh` lo prepara para trabajar con él en la terminal. Tiene tres TODOs.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-04-filtros_de_texto_y_regex/2-practicas/lab-04-cut-y-tr
   ```
   (sin salida).

1. **Campos de `/etc/passwd`.** Separador `:`; el campo 1 es el usuario, el 6 su home y el 7 su shell:
   ```bash
   cut -d: -f1 /etc/passwd | head -3
   cut -d: -f1,6,7 /etc/passwd | tail -2
   cut -d: -f3- /etc/passwd | tail -1
   ```
   ```text
   root
   daemon
   bin
   systemd-network:/:/usr/sbin/nologin
   alumno:/home/alumno:/bin/bash
   1000:1000:Alumno bc-bash:/home/alumno:/bin/bash
   ```
   Con varios campos, `cut` los vuelve a unir con el mismo separador. `-f3-` es "del 3 al final".

2. **El CSV:**
   ```bash
   cat datos/ventas.csv
   cut -d, -f2 datos/ventas.csv
   ```
   ```text
   fecha,ciudad,producto,unidades,importe
   2026-11-02,Madrid,teclado,3,89.70
   2026-11-02,Sevilla,ratón,5,74.50
   2026-11-03,Madrid,monitor,1,189.00
   2026-11-03,Bilbao,teclado,2,59.80
   2026-11-04,Sevilla,monitor,2,378.00
   2026-11-04,valencia,ratón,4,59.60
   2026-11-05,Madrid,ratón,1,14.90
   2026-11-05,Bilbao,monitor,1,189.00
   ciudad
   Madrid
   Sevilla
   Madrid
   Bilbao
   Sevilla
   valencia
   Madrid
   Bilbao
   ```
   La primera línea es la cabecera, con el nombre de cada columna. Alguien escribió `valencia` en minúsculas.

3. **Por caracteres:**
   ```bash
   cut -c1-10 datos/ventas.csv | head -3
   ```
   ```text
   fecha,ciud
   2026-11-02
   2026-11-02
   ```
   `-c1-10` corta por posición, sin mirar separadores: sirve cuando todas las líneas tienen el mismo formato, como esta fecha.

4. **La trampa invisible.** ¿Cuántos importes terminan en `00`? `tail -n +2` se salta la cabecera (lab 01):
   ```bash
   tail -n +2 datos/ventas.csv | cut -d, -f5 | grep -c '00$'
   ```
   ```text
   0
   ```
   Hay tres (`189.00`, `378.00` y `189.00`), pero `grep` dice 0. `cat -A` enseña los caracteres invisibles: `$` marca el final de cada línea y `^M` es un `\r`:
   ```bash
   head -2 datos/ventas.csv | cat -A
   ```
   ```text
   fecha,ciudad,producto,unidades,importe^M$
   2026-11-02,Madrid,teclado,3,89.70^M$
   ```
   Windows termina cada línea con `\r\n`; Linux solo con `\n`. El `\r` se queda pegado al último campo: el importe es `189.00\r` y ya no termina en `00`.

5. **Borrarlo con `tr -d`:**
   ```bash
   tr -d '\r' < datos/ventas.csv | tail -n +2 | cut -d, -f5 | grep -c '00$'
   ```
   ```text
   3
   ```
   `tr` no acepta nombres de archivo: el CSV entra con `<`. `-d` (*delete*) borra cada carácter de la lista.

6. **Cambiar y juntar caracteres:**
   ```bash
   echo 'Hola Mundo' | tr a-z A-Z
   echo 'uno,dos,tres' | tr ',' '\n'
   ```
   ```text
   HOLA MUNDO
   uno
   dos
   tres
   ```
   `tr` cambia cada carácter de la primera lista por el de la misma posición en la segunda: `a` por `A`, `b` por `B`... Cambiar comas por saltos de línea pone un valor por línea, listo para `sort` o `grep`.

7. **Columnas separadas por varios espacios.** `ls -l` alinea las columnas con espacios:
   ```bash
   ls -l /etc/hostname /etc/passwd /etc/group | cut -d' ' -f5
   ls -l /etc/hostname /etc/passwd /etc/group | tr -s ' ' | cut -d' ' -f5,9
   ```
   Algo como (cambian los tamaños):
   ```text
   510

   969
   510 /etc/group
   12 /etc/hostname
   969 /etc/passwd
   ```
   `/etc/hostname` mide 12 bytes y `ls` lo alinea con dos espacios: para `cut`, entre ellos hay un campo vacío, y el tamaño ya no es el campo 5. `tr -s ' '` (*squeeze*) junta los espacios repetidos en uno, y entonces sí.

8. **El script, sin tocar:**
   ```bash
   bash starter/sales-report.sh
   ```
   ```text
   starter/sales-report.sh: line 12: zona/importes.csv: No such file or directory
   ventas: 
   ```
   La última línea cuenta `zona/importes.csv`, que no existe hasta el TODO 2. El error va dentro del `$( )` de un `echo`, así que `set -e` no para el script (lab 02).

9. **TODO 1.** Abre `starter/sales-report.sh` en tu editor. Sustituye la línea del `TODO 1` por el `tr -d '\r'` del paso 5, leyendo de `"$csv"` y con la salida a `zona/ventas.csv`. Prueba (el error del paso 8 sigue hasta el TODO 2; `2> /dev/null` lo esconde mientras tanto):
   ```bash
   bash starter/sales-report.sh 2> /dev/null
   head -2 zona/ventas.csv | cat -A
   ```
   ```text
   ventas: 
   fecha,ciudad,producto,unidades,importe$
   2026-11-02,Madrid,teclado,3,89.70$
   ```
   Ya no hay `^M`.

10. **TODO 2.** Sustituye la línea del `TODO 2` por un pipe: `tail -n +2 zona/ventas.csv`, y de eso, `cut` de las columnas 2 y 5, con la salida a `zona/importes.csv`. Prueba:
    ```bash
    bash starter/sales-report.sh
    cat zona/importes.csv
    ```
    ```text
    ventas: 8
    Madrid,89.70
    Sevilla,74.50
    Madrid,189.00
    Bilbao,59.80
    Sevilla,378.00
    valencia,59.60
    Madrid,14.90
    Bilbao,189.00
    ```

11. **TODO 3.** Sustituye la línea del `TODO 3` por un pipe: la columna 1 de `zona/importes.csv`, pasada a mayúsculas con `tr '[:lower:]' '[:upper:]'` y con la salida a `zona/ciudades.txt`. `[:lower:]` y `[:upper:]` son las clases "minúsculas" y "mayúsculas": hacen lo mismo que `a-z` y `A-Z`, y además shellcheck no avisa. Borra los comentarios `TODO`. Prueba:
    ```bash
    bash starter/sales-report.sh
    cat zona/ciudades.txt
    ```
    ```text
    ventas: 8
    MADRID
    SEVILLA
    MADRID
    BILBAO
    SEVILLA
    VALENCIA
    MADRID
    BILBAO
    ```
    `valencia` y `Valencia` ya son la misma ciudad. En el lab 05 las contarás.

## Criterios de éxito

- [ ] Explicas por qué `grep -c '00$'` daba 0 y cómo lo descubriste con `cat -A` (paso 4)
- [ ] Explicas por qué `cut -d' ' -f5` falla con la salida de `ls -l` y qué arregla `tr -s ' '` (paso 7)
- [ ] `bash starter/sales-report.sh` imprime `ventas: 8`, sin errores, y deja `zona/ventas.csv` sin `\r` y las 8 ciudades en mayúsculas en `zona/ciudades.txt`

## Reto extra

Prueba `echo 'ratón' | tr '[:lower:]' '[:upper:]'`. ¿Por qué la `ó` no cambia? Pista: `tr` trabaja byte a byte, y en UTF-8 la `ó` ocupa dos bytes (`echo -n ó | wc -c`). En la semana 10, `awk` y `sed` resuelven esto.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 03 — Expresiones regulares](../lab-03-expresiones-regulares/README.md) | [Lab 05 — sort y uniq: ordenar y contar](../lab-05-sort-y-uniq/README.md) → |

[↑ Semana 04](../../README.md)
