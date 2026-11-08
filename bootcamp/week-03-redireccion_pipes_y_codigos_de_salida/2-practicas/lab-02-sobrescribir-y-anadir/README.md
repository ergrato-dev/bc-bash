# Lab 02 — Sobrescribir y añadir

⏱ Duración estimada: ~60 min

## Objetivo

Elegir entre `>` y `>>` según haya que reemplazar o conservar un archivo, protegerlo con `noclobber` y leer un archivo por stdin con `<`.

## Contexto

- `>` vacía el archivo **antes** de que el comando escriba nada; `>>` escribe al final de lo que ya hay ([teoría](../../1-teoria/01-redireccion-y-descriptores.md)).
- `<` hace lo contrario: conecta un archivo a la entrada (stdin, descriptor 0) del comando.
- `starter/add-note.sh` debería ir sumando una nota por ejecución, pero tiene un error a propósito: solo conserva la última.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-03-redireccion_pipes_y_codigos_de_salida/2-practicas/lab-02-sobrescribir-y-anadir
   mkdir zona
   ```
   (sin salida).

1. **`>` reemplaza:**
   ```bash
   echo uno > zona/a.txt
   echo dos > zona/a.txt
   cat zona/a.txt
   ```
   ```text
   dos
   ```
   Si el archivo no existe, `>` lo crea. Si existe, lo vacía y escribe. `uno` se perdió sin preguntar.

2. **`>>` añade:**
   ```bash
   echo tres >> zona/a.txt
   cat zona/a.txt
   ```
   ```text
   dos
   tres
   ```

3. **Vaciar un archivo:**
   ```bash
   > zona/a.txt
   ls -l zona/a.txt
   ```
   Algo como (cambia la fecha):
   ```text
   -rw-r--r-- 1 alumno alumno 0 Nov  8 05:07 zona/a.txt
   ```
   Una redirección sin comando: el archivo se queda con tamaño `0`. Así se vacía un log sin borrarlo.

4. **La trampa: leer y escribir el mismo archivo.**
   ```bash
   printf 'uno\ndos\ntres\n' > zona/lineas.txt
   cat zona/lineas.txt > zona/lineas.txt
   ls -l zona/lineas.txt
   ```
   Algo como:
   ```text
   -rw-r--r-- 1 alumno alumno 0 Nov  8 05:07 zona/lineas.txt
   ```
   `printf` escribe el texto y convierte cada `\n` en un salto de línea. La segunda línea parece no hacer nada, pero bash vacía el archivo con `>` **antes** de arrancar `cat`. Cuando `cat` va a leerlo, ya está vacío. Se pierde el contenido.

5. **Protección contra el `>` accidental:**
   ```bash
   echo importante > zona/b.txt
   set -o noclobber
   echo vacío > zona/b.txt
   echo $?
   cat zona/b.txt
   ```
   ```text
   bash: zona/b.txt: cannot overwrite existing file
   1
   importante
   ```
   `set -o noclobber` activa una opción de tu shell: `>` deja de pisar archivos que ya existen. Si de verdad quieres hacerlo, `>|` lo fuerza:
   ```bash
   echo forzado >| zona/b.txt
   cat zona/b.txt
   set +o noclobber
   ```
   ```text
   forzado
   ```
   `set +o` (con `+`) desactiva la opción. Solo dura hasta que sales del laboratorio.

6. **`<`: un archivo como entrada.**
   ```bash
   printf 'uno\ndos\ntres\n' > zona/lineas.txt
   wc -l zona/lineas.txt
   wc -l < zona/lineas.txt
   ```
   ```text
   3 zona/lineas.txt
   3
   ```
   `wc -l` cuenta líneas. Con el nombre como argumento, `wc` abre el archivo y lo cita en la salida. Con `<`, bash le conecta el archivo a stdin: `wc` solo ve texto entrando y no sabe de dónde viene. Por eso imprime solo el número, que es lo que necesitas si lo vas a guardar en una variable.

7. **El script, sin tocar.** Ejecútalo dos veces:
   ```bash
   bash starter/add-note.sh
   bash starter/add-note.sh
   cat zona/notas.txt
   ```
   Algo como (cambian la fecha y la hora):
   ```text
   1 zona/notas.txt
   1 zona/notas.txt
   2026-11-08 05:07:13 revisión hecha
   ```
   Dos ejecuciones, una sola nota.

8. **TODO 1.** Abre `starter/add-note.sh` en tu editor y cambia la redirección del `echo` para que **añada**. Empieza de cero y prueba tres veces:
   ```bash
   rm zona/notas.txt
   bash starter/add-note.sh
   bash starter/add-note.sh
   bash starter/add-note.sh
   ```
   ```text
   1 zona/notas.txt
   2 zona/notas.txt
   3 zona/notas.txt
   ```

9. **TODO 2.** Cambia el `wc -l` para que lea el archivo por stdin y solo imprima el número. Borra los comentarios `TODO`. Prueba:
   ```bash
   bash starter/add-note.sh
   cat zona/notas.txt
   ```
   Algo como:
   ```text
   4
   2026-11-08 05:07:13 revisión hecha
   2026-11-08 05:07:13 revisión hecha
   2026-11-08 05:07:13 revisión hecha
   2026-11-08 05:07:13 revisión hecha
   ```

## Criterios de éxito

- [ ] Explicas por qué `cat zona/lineas.txt > zona/lineas.txt` deja el archivo vacío (paso 4)
- [ ] Explicas qué cambia `noclobber` y cómo saltártelo (paso 5)
- [ ] Explicas por qué `wc -l < archivo` no imprime el nombre (paso 6)
- [ ] Cada `bash starter/add-note.sh` suma una línea a `zona/notas.txt` e imprime solo el total

## Reto extra

Con `noclobber` activado, ¿funciona `>>` sobre un archivo que ya existe? ¿Y `>` sobre uno que no existe? Pruébalo y explica por qué la opción permite esos dos casos.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 01 — stdout y stderr](../lab-01-stdout-y-stderr/README.md) | [Lab 03 — El orden de las redirecciones](../lab-03-orden-de-las-redirecciones/README.md) → |

[↑ Semana 03](../../README.md)
