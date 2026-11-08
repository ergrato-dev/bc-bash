# Lab 06 — find -print0

⏱ Duración estimada: ~60 min

## Objetivo

Recorrer los archivos que encuentra `find` con cualquier nombre, con `-print0` y `read -d ''`, sin perder las variables del bucle en un subshell.

## Contexto

- Un nombre de archivo en Linux puede llevar cualquier carácter salvo `/` y el byte nulo: espacios, `*`, un `-` delante y hasta saltos de línea. Leer rutas línea a línea falla con el último.
- `find -print0` termina cada ruta con el byte nulo, y `read -r -d ''` lee hasta ese byte. Es la única separación que no puede aparecer dentro de un nombre.
- `starter/total-size.sh` suma los bytes de los archivos con una extensión, también en subcarpetas. Lee las rutas con un `find | while read`: falla con un nombre raro y, además, siempre dice `total: 0`.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-07-bucles_read_y_archivos_seguros/2-practicas/lab-06-find-print0
   ```
   (sin salida).

1. **Nombres difíciles.** `$'...'` es un tipo de comillas en el que `\n` se convierte en un salto de línea de verdad:
   ```bash
   echo [$'a\nb']
   ```
   ```text
   [a
   b]
   ```
   Con eso creas un archivo con un salto de línea en el nombre, otro con un espacio y otro en una subcarpeta:
   ```bash
   mkdir -p zona/logs/viejos
   echo uno > "zona/logs/app web.log"
   echo dos > zona/logs/viejos/db.log
   echo tres > "zona/logs/linea"$'\n'"rota.log"
   ```
   (sin salida).

2. **Leer línea a línea se rompe.**
   ```bash
   find zona -name "*.log" | while read -r f; do echo "[$f]"; done
   ```
   Algo como (el orden puede variar):
   ```text
   [zona/logs/app web.log]
   [zona/logs/viejos/db.log]
   [zona/logs/linea]
   [rota.log]
   ```
   Tres archivos, cuatro vueltas: el salto de línea del nombre parte la ruta en dos.

3. **Con el byte nulo, no.** `-d ''` le dice a `read` que la línea termina en el byte nulo, en lugar de en el salto de línea. `IFS=` evita que recorte espacios (lab 04):
   ```bash
   find zona -name '*.log' -print0 | while IFS= read -r -d '' f; do echo "[$f]"; done
   ```
   Algo como (el orden puede variar):
   ```text
   [zona/logs/app web.log]
   [zona/logs/viejos/db.log]
   [zona/logs/linea
   rota.log]
   ```
   Tres vueltas. El tercer nombre se ve en dos líneas porque lleva un salto de línea dentro, pero es un solo archivo.

4. **El pipe se come las variables.** Cuenta las vueltas con una variable:
   ```bash
   n=0; find zona -name '*.log' -print0 | while IFS= read -r -d '' f; do n=$((n + 1)); done; echo "n vale $n"
   ```
   ```text
   n vale 0
   ```
   Cada lado de un pipe es un proceso aparte. El `while` va en un **subshell**: una copia de la shell que tiene su propia `n`, la cuenta hasta 3 y desaparece al terminar. La `n` de tu shell sigue en `0`.

5. **`< <(...)`: el bucle en tu shell.** `<(comando)` es la salida de un comando vista como si fuera un archivo, y `<` se la pasa al `while`, igual que `done < archivo` en el lab 04. El `find` va aparte, y el bucle se queda en tu shell. La semana 13 explica cómo funciona por dentro:
   ```bash
   n=0; while IFS= read -r -d '' f; do n=$((n + 1)); done < <(find zona -name '*.log' -print0); echo "n vale $n"
   ```
   ```text
   n vale 3
   ```
   El espacio entre los dos `<` es obligatorio: `<<(` sería otra cosa.

6. **TODO 1: rutas con `-print0`.** Abre `starter/total-size.sh` en tu editor. Ejecútalo y pásale shellcheck:
   ```bash
   bash starter/total-size.sh zona log; echo $?
   shellcheck starter/total-size.sh
   ```
   Algo como (el orden puede variar):
   ```text
   4 zona/logs/app web.log
   4 zona/logs/viejos/db.log
   starter/total-size.sh: line 14: zona/logs/linea: No such file or directory
   1
   ```
   `wc` recibe media ruta, y shellcheck no ve nada raro: no puede saber qué nombres tendrán tus archivos. Cambia la línea del `find` para que use `-print0` y un `read` que lea hasta el byte nulo:
   ```bash
   find "$dir" -type f -name "*.$ext" -print0 | while IFS= read -r -d '' f; do
   ```
   Borra el comentario del `TODO 1`. Prueba:
   ```bash
   bash starter/total-size.sh zona log; echo $?
   ```
   Algo como (el orden puede variar):
   ```text
   4 zona/logs/app web.log
   4 zona/logs/viejos/db.log
   5 zona/logs/linea
   rota.log
   total: 0 bytes en 0 archivos
   0
   ```
   Los tres archivos se leen bien, pero el total se pierde: el subshell del paso 4.

7. **Comprueba los bytes a mano.** `uno` y su salto de línea son 4 bytes; `dos`, 4; `tres`, 5. El total debería ser `13 bytes en 3 archivos`.

8. **TODO 2: sin pipe.** Cambia el bucle para que el `find` vaya al final, con `< <(...)` (paso 5). La primera línea queda solo con el `while`:
   ```bash
   while IFS= read -r -d '' f; do
   ```
   y el `done` lleva el `find` detrás:
   ```bash
   done < <(find "$dir" -type f -name "*.$ext" -print0)
   ```
   Borra el comentario del `TODO 2`. Prueba:
   ```bash
   bash starter/total-size.sh zona log; echo $?
   shellcheck starter/total-size.sh; echo $?
   ```
   Algo como (el orden puede variar):
   ```text
   4 zona/logs/app web.log
   4 zona/logs/viejos/db.log
   5 zona/logs/linea
   rota.log
   total: 13 bytes en 3 archivos
   0
   0
   ```

9. **Nombres que empiezan por `-`.** Los comandos leen como opción todo lo que empieza por `-`. `--` marca el final de las opciones: lo que va detrás es un nombre, empiece por lo que empiece:
   ```bash
   cd zona
   touch -x.log
   touch -- -x.log
   rm -x.log
   rm -- -x.log; echo $?
   cd ..
   ```
   ```text
   touch: invalid option -- 'x'
   Try 'touch --help' for more information.
   rm: invalid option -- 'x'
   Try 'rm ./-x.log' to remove the file '-x.log'.
   Try 'rm --help' for more information.
   0
   ```
   Las rutas de `find zona ...` empiezan por `zona/`, pero si la carpeta llega de un argumento puede ser cualquier cosa: en un script, `rm -- "$f"`.

## Criterios de éxito

- [ ] Explicas por qué el bucle del paso 2 dio cuatro vueltas con tres archivos
- [ ] Explicas por qué `n` valía `0` en el paso 4 y `3` en el paso 5
- [ ] `bash starter/total-size.sh zona log` termina con `total: 13 bytes en 3 archivos`
- [ ] `shellcheck starter/total-size.sh` no imprime nada

## Reto extra

`find` puede ejecutar un comando por su cuenta: `find zona -name '*.log' -exec wc -c -- {} +` le pasa a `wc` todas las rutas de una vez, sin bucle y sin problemas con los nombres. ¿Qué no podrías hacer de esta forma que sí hace `total-size.sh`?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 05 — mapfile](../lab-05-mapfile/README.md) | [Lab 07 — Bucles rotos](../lab-07-bucles-rotos/README.md) → |

[↑ Semana 07](../../README.md)
