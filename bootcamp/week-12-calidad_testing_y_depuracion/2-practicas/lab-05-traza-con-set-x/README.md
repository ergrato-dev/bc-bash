# Lab 05 — La traza: set -x, PS4 y BASH_XTRACEFD

⏱ Duración estimada: ~60 min

## Objetivo

Seguir un script línea a línea con `set -x`, poner en cada línea de la traza su número y su subshell con `PS4`, y mandar la traza a un archivo con `BASH_XTRACEFD` para encontrar un fallo que no da ningún error.

## Contexto

- Hay fallos que avisan (`command not found`, un código distinto de 0) y fallos que no: el script termina bien y el resultado está mal. Para estos, hay que ver qué hace el script por dentro.
- `set -x` (*xtrace*) hace que bash escriba cada línea antes de ejecutarla, con las variables ya cambiadas por su valor. Lo que va delante de cada línea es el valor de la variable `PS4`, y puede llevar variables, como el número de línea.
- `starter/sum-sizes.sh` cuenta los archivos de una carpeta, con sus subcarpetas, y suma lo que ocupan. Está **roto a propósito**: siempre dice `0`, sin ningún error. `datos/` tiene tres archivos de 1500, 600 y 2000 bytes.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-12-calidad_testing_y_depuracion/2-practicas/lab-05-traza-con-set-x
   ```
   (sin salida).

1. **El script, tal cual.** Abre `starter/sum-sizes.sh` en tu editor. `stat -c "%s %n"` escribe el tamaño en bytes y el nombre de cada archivo:
   ```bash
   find datos -type f -exec stat -c "%s %n" {} +
   bash starter/sum-sizes.sh datos; echo $?
   ```
   ```text
   1500 datos/ventas.csv
   600 datos/informe final.txt
   2000 datos/sub/app.log
   total: 0 bytes (0 KiB) en 0 archivos
   0
   ```
   Tres archivos, 4100 bytes. El script dice 0 y sale con `0`: ningún aviso que seguir. Tampoco `shellcheck starter/sum-sizes.sh` dice nada.

2. **`bash -x`: la traza entera.** `bash -x script` ejecuta el script con `set -x` desde la primera línea. La traza va a stderr: `2>&1` la junta con la salida para leerla con `head` y `tail`.
   ```bash
   bash -x starter/sum-sizes.sh datos 2>&1 | head -n 12
   bash -x starter/sum-sizes.sh datos 2>&1 | tail -n 6
   ```
   ```text
   + set -euo pipefail
   + dir=datos
   + [[ -d datos ]]
   + total=0
   + count=0
   + find datos -type f -print0
   + IFS=
   + read -r -d '' file
   ++ stat -c %s datos/ventas.csv
   + size=1500
   + total=1500
   + count=1
   + IFS=
   + read -r -d '' file
   ++ to_kib 0
   ++ echo 0
   + echo 'total: 0 bytes (0 KiB) en 0 archivos'
   total: 0 bytes (0 KiB) en 0 archivos
   ```
   Se lee de arriba abajo: cada `+` es una línea que se ejecutó, y `++` una que va dentro de otra (`$(stat ...)` dentro de `size=...`). Dentro del bucle, `total` sube hasta 1500 y sigue. Al final, el `echo` usa `0`. Algo cambia `total` de vuelta... o el `echo` no ve el mismo `total`.

3. **`PS4`: el número de línea.** `PS4` vale `+ ` si no dices otra cosa. Con comillas simples, `${LINENO}` se calcula en cada línea de la traza (si fueran dobles, valdría siempre el número de la línea donde escribes `PS4`). bash lee `PS4` del entorno, así que basta con ponerla delante:
   ```bash
   PS4='+ ${LINENO}: ' bash -x starter/sum-sizes.sh datos 2>&1 | head -n 8
   ```
   ```text
   + 4: set -euo pipefail
   + 14: dir=datos
   + 15: [[ -d datos ]]
   + 17: total=0
   + 18: count=0
   + 19: find datos -type f -print0
   + 19: IFS=
   + 19: read -r -d '' file
   ```
   Ahora cada línea de la traza dice dónde mirar en el script.

4. **`PS4`: el subshell y la función.** `$BASH_SUBSHELL` dice en qué subshell va una línea: `0` es la shell del script, `1` una copia. `${FUNCNAME[0]}` es la función que se está ejecutando; con `:+` (semana 05) solo se escribe dentro de una.
   ```bash
   PS4='+ ${LINENO} [subshell ${BASH_SUBSHELL}] ${FUNCNAME[0]:+${FUNCNAME[0]}(): }' bash -x starter/sum-sizes.sh datos 2>&1 | tail -n 12
   ```
   ```text
   + 19 [subshell 1] IFS=
   + 19 [subshell 1] read -r -d '' file
   ++ 20 [subshell 2] stat -c %s datos/sub/app.log
   + 20 [subshell 1] size=2000
   + 21 [subshell 1] total=4100
   + 22 [subshell 1] count=3
   + 19 [subshell 1] IFS=
   + 19 [subshell 1] read -r -d '' file
   ++ 24 [subshell 1] to_kib 0
   ++ 11 [subshell 1] to_kib(): echo 0
   + 24 [subshell 0] echo 'total: 0 bytes (0 KiB) en 0 archivos'
   total: 0 bytes (0 KiB) en 0 archivos
   ```
   Ahí está: el bucle suma bien, `total=4100`, pero en el **subshell 1**. El `echo` de la línea 24 va en el **subshell 0**, donde `total` sigue valiendo `0`. Un `while` detrás de un pipe (`find ... | while`) corre en un subshell, y lo que cambia se pierde al terminar (semana 07). `$(to_kib 0)` también va en un subshell, pero solo devuelve lo que escribe, y eso sí llega.

5. **Arreglarlo.** En `starter/sum-sizes.sh`, cambia la línea `find "$dir" -type f -print0 | while IFS= read -r -d '' file; do` por:
   ```bash
   # < <(find ...) y no find | while: con el pipe, el while va en un subshell y
   # total y count se pierden al salir del bucle. Así el while corre en esta shell.
   while IFS= read -r -d '' file; do
   ```
   y el `done` del bucle por:
   ```bash
   done < <(find "$dir" -type f -print0)
   ```
   `< <(comando)` le da al `while` la salida de `find` como si fuera un archivo (semana 07). Prueba con la misma traza:
   ```bash
   bash starter/sum-sizes.sh datos
   PS4='+ ${LINENO} [subshell ${BASH_SUBSHELL}] ' bash -x starter/sum-sizes.sh datos 2>&1 | tail -n 6
   ```
   ```text
   total: 4100 bytes (5 KiB) en 3 archivos
   + 21 [subshell 0] IFS=
   + 21 [subshell 0] read -r -d '' file
   ++ 26 [subshell 1] to_kib 4100
   ++ 11 [subshell 1] echo 5
   + 26 [subshell 0] echo 'total: 4100 bytes (5 KiB) en 3 archivos'
   total: 4100 bytes (5 KiB) en 3 archivos
   ```
   El bucle va ahora en el subshell 0, el mismo que el `echo`.

6. **Solo un trozo.** Con un script largo, la traza entera es demasiado. `set -x` la enciende en mitad del script y `set +x` la apaga:
   ```bash
   bash -c 'echo antes; set -x; x=1; y=2; set +x; echo después' 2>&1
   ```
   ```text
   antes
   + x=1
   + y=2
   + set +x
   después
   ```
   Rodear con `set -x` y `set +x` el trozo que sospechas es más rápido de leer. El propio `set +x` sale en la traza: se escribe antes de ejecutarse.

7. **La traza mezclada con los avisos.** La traza va a stderr, igual que los avisos del script. Con una carpeta que no existe:
   ```bash
   bash -x starter/sum-sizes.sh no-existe 2> err.txt
   cat err.txt
   ```
   ```text
   + set -euo pipefail
   + dir=no-existe
   + [[ -d no-existe ]]
   + echo 'sum-sizes.sh: '\''no-existe'\'' no es una carpeta'
   sum-sizes.sh: 'no-existe' no es una carpeta
   + exit 1
   ```
   El aviso para el usuario está enterrado entre la traza. Y quien guarda los errores del script en un log recibiría la traza entera.

8. **TODO 2: la traza, a su archivo.** `BASH_XTRACEFD` es el número del descriptor al que `set -x` escribe la traza. `exec {BASH_XTRACEFD}> archivo` abre el archivo en un descriptor nuevo y guarda su número ahí (semana 11, lab 05). Cambia el comentario del `TODO 2` por:
   ```bash
   # TRACE=<archivo>: la traza de set -x va a ese archivo, con el número de línea delante.
   # BASH_XTRACEFD la manda a un descriptor propio: sin él iría a stderr, mezclada con los avisos.
   if [[ -n ${TRACE:-} ]]; then
     exec {BASH_XTRACEFD}> "$TRACE"
     PS4='+ ${LINENO}: '
     set -x
   fi
   ```
   Prueba, con la carpeta buena y con la que no existe:
   ```bash
   TRACE=traza.txt bash starter/sum-sizes.sh datos
   head -n 4 traza.txt
   TRACE=traza.txt bash starter/sum-sizes.sh no-existe 2> err.txt; echo "código: $?"
   cat err.txt
   tail -n 2 traza.txt
   ```
   ```text
   total: 4100 bytes (5 KiB) en 3 archivos
   + 19: dir=datos
   + 20: [[ -d datos ]]
   + 22: total=0
   + 23: count=0
   código: 1
   sum-sizes.sh: 'no-existe' no es una carpeta
   + 20: echo 'sum-sizes.sh: '\''no-existe'\'' no es una carpeta'
   + 20: exit 1
   ```
   La salida y los avisos, como siempre; la traza, aparte. Y como depende de una variable, puedes dejarla en el script: sin `TRACE`, no hace nada.

9. **shellcheck y limpieza.**
   ```bash
   shellcheck starter/sum-sizes.sh; echo $?
   rm err.txt traza.txt
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas qué son los `+` y los `++` de la traza (paso 2)
- [ ] Explicas por qué `PS4` va entre comillas simples (paso 3)
- [ ] Señalas la línea de la traza que demuestra que el bucle corría en un subshell (paso 4)
- [ ] `bash starter/sum-sizes.sh datos` imprime `total: 4100 bytes (5 KiB) en 3 archivos` (paso 5)
- [ ] Con `TRACE=traza.txt`, stderr solo tiene el aviso y la traza va al archivo (paso 8)

## Reto extra

Añade a `PS4` la hora con nanosegundos: `$(date +%s.%N)` dentro de `PS4` se ejecuta en cada línea de la traza. ¿Qué línea del script tarda más? Bash 5 trae también `$EPOCHREALTIME`, una variable con la hora en microsegundos: ¿por qué es mejor que `$(date ...)` dentro de `PS4`?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 04 — setup, teardown y temporales en bats](../lab-04-setup-y-temporales-en-bats/README.md) | [Lab 06 — Depurar con tests](../lab-06-depurar-con-tests/README.md) → |

[↑ Semana 12](../../README.md)
