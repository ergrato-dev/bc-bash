# Lab 02 — `[@]` frente a `[*]`

⏱ Duración estimada: ~60 min

## Objetivo

Guardar los argumentos de un comando en un array y pasárselos con `"${args[@]}"`, sin que un nombre con espacios se parta.

## Contexto

- `"${arr[@]}"` da cada elemento como un argumento aparte; `"${arr[*]}"` los junta todos en un solo texto. Sin comillas, los dos se parten por los espacios.
- Cuando un script monta las opciones de otro comando poco a poco (según lo que le pidan), la tentación es ir sumándolas a un texto. Con un nombre con espacios, eso se rompe; con un array, no.
- `starter/make-backup.sh` empaqueta una carpeta en `copia.tgz` con `tar`, y con `--sin-logs` deja fuera los `.log`. `tar -czf archivo.tgz -C carpeta .` crea (`c`) un archivo comprimido (`z`) con lo que hay dentro de `carpeta`; `tar -tzf` lista lo que lleva.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-09-arrays_y_printf/2-practicas/lab-02-arroba-y-asterisco
   ```
   (sin salida).

1. **Tres formas de expandir un array.** `printf '[%s]\n'` escribe cada argumento que recibe entre corchetes, uno por línea:
   ```bash
   files=("mis notas.txt" informe.pdf)
   printf '[%s]\n' ${files[@]}
   printf '[%s]\n' "${files[@]}"
   printf '[%s]\n' "${files[*]}"
   ```
   ```text
   [mis]
   [notas.txt]
   [informe.pdf]
   [mis notas.txt]
   [informe.pdf]
   [mis notas.txt informe.pdf]
   ```
   Sin comillas, `mis notas.txt` llega partido en dos. Con `"${files[@]}"`, dos argumentos, los dos enteros. Con `"${files[*]}"`, uno solo.

2. **`[*]` para escribir, `[@]` para pasar.** `[*]` junta con el primer carácter de `IFS` (un espacio, si no lo cambias):
   ```bash
   (IFS=,; echo "${files[*]}")
   ```
   ```text
   mis notas.txt,informe.pdf
   ```
   Los paréntesis cambian `IFS` en un subshell, sin tocar tu shell. `[*]` sirve para enseñar una lista; para pasársela a un comando, `"${arr[@]}"`.

3. **El script, tal cual.** Abre `starter/make-backup.sh` en tu editor: suma las opciones de `tar` a un texto, `args`. Mira la carpeta que vas a empaquetar y ejecútalo:
   ```bash
   ls -R datos
   bash starter/make-backup.sh "datos/mis datos"; echo $?
   rm -f copia.tgz
   ```
   ```text
   datos:
   mis datos

   datos/mis datos:
   app.log
   notas.txt
   [tar][-czf][copia.tgz][-C][datos/mis][datos][.]
   tar: datos/mis: Cannot open: No such file or directory
   tar: Error is not recoverable: exiting now
   2
   ```
   `$args` sin comillas se parte por los espacios, también el de `mis datos`, y `tar` recibe `datos/mis` y `datos`. Ponerle comillas tampoco vale: `"$args"` sería **un** argumento con todas las opciones dentro. `tar` llegó a crear un `copia.tgz` a medias: `rm -f` lo borra (`-f`: sin quejarse si no existe).

4. **Lo que dice shellcheck.**
   ```bash
   shellcheck starter/make-backup.sh
   ```
   ```text

   In starter/make-backup.sh line 15:
     printf '[%s]' tar $args
                       ^---^ SC2086 (info): Double quote to prevent globbing and word splitting.

   Did you mean: 
     printf '[%s]' tar "$args"


   In starter/make-backup.sh line 17:
     tar $args
         ^---^ SC2086 (info): Double quote to prevent globbing and word splitting.

   Did you mean: 
     tar "$args"

   For more information:
     https://www.shellcheck.net/wiki/SC2086 -- Double quote to prevent globbing ...
   ```
   shellcheck ve el peligro, pero su propuesta, `"$args"`, aquí no arregla nada (paso 3). Lo que falta es un array.

5. **TODO 1: las opciones en un array.** Haz cuatro cambios:
   - El comentario del `TODO 1` y `local args="-czf copia.tgz"`, por:
     ```bash
       # Las opciones de tar, una por elemento: "mis datos" sigue siendo un solo argumento.
       local args=(-czf copia.tgz)
     ```
   - `args="$args -C $src ."`, por:
     ```bash
       # -C entra en la carpeta antes de empaquetar: dentro del .tgz no queda la ruta entera.
       args+=(-C "$src" .)
     ```
   - En las dos últimas líneas de `main`, `$args` por `"${args[@]}"`:
     ```bash
       printf '[%s]' tar "${args[@]}"
       echo
       tar "${args[@]}"
     ```
   Prueba:
   ```bash
   bash starter/make-backup.sh "datos/mis datos"; echo $?
   tar -tzf copia.tgz
   rm copia.tgz
   ```
   ```text
   [tar][-czf][copia.tgz][-C][datos/mis datos][.]
   0
   ./
   ./notas.txt
   ./app.log
   ```
   `"$src"` entra en el array como un solo elemento, con su espacio dentro.

6. **TODO 2: una opción más, solo si la piden.** Cambia `: # TODO 2: ...` por:
   ```bash
       args+=(--exclude='*.log')
   ```
   Las comillas simples evitan que bash expanda `*.log` aquí: el patrón tiene que llegar tal cual a `tar`. Prueba:
   ```bash
   bash starter/make-backup.sh "datos/mis datos" --sin-logs
   tar -tzf copia.tgz
   rm copia.tgz
   ```
   ```text
   [tar][-czf][copia.tgz][--exclude=*.log][-C][datos/mis datos][.]
   ./
   ./notas.txt
   ```

7. **shellcheck.**
   ```bash
   shellcheck starter/make-backup.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas cuántos argumentos da cada una de las tres formas del paso 1, y por qué
- [ ] Explicas por qué `"$args"` tampoco habría arreglado el script del paso 3
- [ ] `bash starter/make-backup.sh "datos/mis datos" --sin-logs` crea un `copia.tgz` con `notas.txt` y sin `app.log`
- [ ] `shellcheck starter/make-backup.sh` no imprime nada

## Reto extra

Añade una opción `--dry-run` que solo enseñe el comando, sin ejecutar `tar`. Prueba `printf '%q ' tar "${args[@]}"`: `%q` escribe cada argumento con las comillas que haría falta teclear para repetirlo. ¿Qué escribe para `datos/mis datos`?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 01 — Arrays indexados](../lab-01-arrays-indexados/README.md) | [Lab 03 — Huecos y slices](../lab-03-huecos-y-slices/README.md) → |

[↑ Semana 09](../../README.md)
