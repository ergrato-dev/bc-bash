# Lab 07 — Sustitución de comandos

⏱ Duración estimada: ~60 min

## Objetivo

Guardar la salida de un comando en una variable con `$( )`, combinarla con texto y cuentas, y citarla para no perder sus saltos de línea.

## Contexto

- `$(comando)` ejecuta el comando y se sustituye por lo que escribe en stdout. Es la pieza que une los filtros de la semana 04 con las variables de esta ([teoría](../../1-teoria/04-aritmetica-y-sustitucion-de-comandos.md)).
- `datos/web/` es una web pequeña de tres archivos, y `datos/servidores.txt`, la lista de servidores adonde se copia.
- `starter/make-snapshot.sh` empaqueta `datos/web/` en un `.tar.gz` con la fecha en el nombre, como una copia de seguridad, y resume lo que guardó. Tiene cuatro TODOs; el último arregla una lista que sale en una sola línea.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-05-variables_comillas_y_expansiones/2-practicas/lab-07-sustitucion-de-comandos
   ```
   (sin salida).

1. **La salida de un comando, dentro de otro.** `date +%F` imprime la fecha de hoy como `año-mes-día`:
   ```bash
   echo "Hoy es $(date +%F)"
   hoy=$(date +%F)
   echo "$hoy"
   date +%F_%H%M
   ```
   Algo como (cambia la fecha y la hora):
   ```text
   Hoy es 2026-11-08
   2026-11-08
   2026-11-08_0558
   ```
   `$(date +%F)` se sustituye por `2026-11-08` antes de ejecutar `echo`, igual que una variable. Guardada en `hoy`, la puedes usar las veces que quieras sin volver a ejecutar `date`. En el formato, `%H` es la hora y `%M` los minutos.

2. **Los saltos de línea del final desaparecen:**
   ```bash
   x=$(printf 'hola\n\n\n')
   echo "[$x]"
   ```
   ```text
   [hola]
   ```
   `printf 'hola\n\n\n'` escribe `hola` y tres saltos de línea. `$( )` quita todos los del final. Por eso `n=$(wc -l < archivo)` guarda el número limpio, sin salto de línea detrás.

3. **Una dentro de otra.** `basename` imprime la última parte de una ruta:
   ```bash
   echo "Estás en $(basename "$(pwd)")"
   ```
   ```text
   Estás en lab-07-sustitucion-de-comandos
   ```
   Primero se ejecuta la de dentro, `pwd`; su resultado es el argumento de `basename`. Cada `$( )` tiene sus propias comillas: las de `"$(pwd)"` no chocan con las de fuera.

4. **Las comillas invertidas:**
   ```bash
   echo "Año: `date +%Y`"
   ```
   Algo como (cambia el año):
   ```text
   Año: 2026
   ```
   `` `comando` `` es la forma antigua de `$(comando)`. La verás en scripts viejos, pero no se anida bien y se confunde con una comilla simple: en los tuyos, `$( )`.

5. **El código de salida, y stderr:**
   ```bash
   x=$(false)
   echo $?
   x=$(ls nada)
   echo "$? [$x]"
   ```
   ```text
   1
   ls: cannot access 'nada': No such file or directory
   2 []
   ```
   Una asignación con `$( )` sale con el código del comando: con `set -e`, un fallo ahí para el script (semana 03). `$( )` solo recoge stdout: el error de `ls` sale en pantalla y `x` queda vacía.

6. **Citar el resultado:**
   ```bash
   lista=$(ls datos/web)
   echo $lista
   echo "$lista"
   ```
   ```text
   app.js estilo.css index.html
   app.js
   estilo.css
   index.html
   ```
   `lista` guarda tres líneas. Sin comillas, el word splitting (lab 03) también parte por los saltos de línea, y `echo` recibe tres palabras que une con espacios. Con comillas, llega el texto tal cual.

7. **El script, sin tocar:**
   ```bash
   bash starter/make-snapshot.sh
   ls zona
   ```
   ```text
   creado: zona/snapshot-hoy.tar.gz
   copiar a:
   web-01.ejemplo.com web-02.ejemplo.com backup.ejemplo.com
   snapshot-hoy.tar.gz
   ```
   `tar -czf archivo carpeta` crea un archivo comprimido (`-c` *create*, `-z` gzip, `-f` el nombre) con todo lo que hay en la carpeta. Con `hoy` fijo en el nombre, la copia de mañana pisaría la de hoy.

8. **TODO 1.** Abre `starter/make-snapshot.sh` en tu editor. Cambia `fecha=hoy` para que guarde la salida de `date +%F` (paso 1). Borra el comentario del `TODO 1`. Borra la copia mala y prueba:
   ```bash
   rm zona/snapshot-hoy.tar.gz
   bash starter/make-snapshot.sh | head -1
   ```
   Algo como (cambia la fecha):
   ```text
   creado: zona/snapshot-2026-11-08.tar.gz
   ```

9. **TODO 2.** `tar -tzf` (`-t`, *list*) lista lo que hay dentro sin descomprimir. Pruébalo; el `*` evita escribir la fecha:
   ```bash
   tar -tzf zona/snapshot-*.tar.gz
   tar -tzf zona/snapshot-*.tar.gz | grep -vc '/$'
   ```
   ```text
   datos/web/
   datos/web/index.html
   datos/web/app.js
   datos/web/estilo.css
   3
   ```
   La lista incluye la carpeta, que acaba en `/`: `grep -vc '/$'` cuenta las líneas que **no** acaban así (semana 04). Sustituye el comentario del `TODO 2` por un `echo` que imprima `archivos: ` y ese número, con el pipe dentro de `$( )` y `"$archivo"` en lugar del glob. Prueba:
   ```bash
   bash starter/make-snapshot.sh | sed -n 2p
   ```
   `sed -n 2p` imprime solo la línea 2 (semana 10):
   ```text
   archivos: 3
   ```

10. **TODO 3.** `du -k` dice cuánto ocupa un archivo en KiB, y lo separa del nombre con un tabulador:
    ```bash
    du -k zona/snapshot-*.tar.gz
    du -k zona/snapshot-*.tar.gz | cut -f1
    ```
    Algo como (cambia la fecha):
    ```text
    4	zona/snapshot-2026-11-08.tar.gz
    4
    ```
    `cut -f1` sin `-d` corta por tabuladores. Sustituye el comentario del `TODO 3` por un `echo` que imprima `tamaño: `, el número y ` KiB`. Prueba:
    ```bash
    bash starter/make-snapshot.sh | sed -n 3p
    ```
    ```text
    tamaño: 4 KiB
    ```

11. **TODO 4.** El fallo del paso 6. Pon `$servidores` entre comillas dobles en el último `echo`. Borra los comentarios `TODO`. Prueba:
    ```bash
    bash starter/make-snapshot.sh
    echo $?
    ```
    Algo como (cambia la fecha):
    ```text
    creado: zona/snapshot-2026-11-08.tar.gz
    archivos: 3
    tamaño: 4 KiB
    copiar a:
    web-01.ejemplo.com
    web-02.ejemplo.com
    backup.ejemplo.com
    0
    ```

## Criterios de éxito

- [ ] Explicas por qué `$( )` no deja un salto de línea al final del valor (paso 2)
- [ ] Explicas qué recoge `$( )` y qué no, y qué código de salida tiene la asignación (paso 5)
- [ ] Explicas por qué `echo $lista` pone todo en una línea (paso 6)
- [ ] `bash starter/make-snapshot.sh` crea `zona/snapshot-<fecha de hoy>.tar.gz` e imprime `archivos: 3`, el tamaño y un servidor por línea

## Reto extra

Ejecuta el script dos veces seguidas y mira `ls zona`. ¿Por qué sigue habiendo una sola copia? Cambia el formato de la fecha para que incluya la hora y los minutos (paso 1): ¿cuántas copias hay ahora si lo ejecutas dos veces en el mismo minuto? Así se decide cada cuánto se puede hacer una copia sin pisar la anterior.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 06 — Aritmética](../lab-06-aritmetica/README.md) | [Proyecto — bk-rename: nombres de archivo sin sorpresas](../../3-proyecto/README.md) → |

[↑ Semana 05](../../README.md)
