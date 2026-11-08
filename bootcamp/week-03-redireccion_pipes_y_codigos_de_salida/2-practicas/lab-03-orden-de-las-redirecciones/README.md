# Lab 03 — El orden de las redirecciones

⏱ Duración estimada: ~60 min

## Objetivo

Juntar stdout y stderr en un mismo archivo con `2>&1`, y entender por qué el orden en que escribes las redirecciones cambia el resultado.

## Contexto

- `2>&1` significa "que el descriptor 2 apunte adonde apunta **ahora** el 1". Es una copia en ese momento, no un enlace permanente ([teoría](../../1-teoria/01-redireccion-y-descriptores.md)).
- bash aplica las redirecciones de izquierda a derecha, antes de arrancar el comando.
- `starter/noisy.sh` imita un instalador: escribe progreso por stdout y problemas por stderr. No lo cambies. `starter/capture-all.sh` quiere guardarlo todo en un log, pero tiene el orden al revés a propósito.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-03-redireccion_pipes_y_codigos_de_salida/2-practicas/lab-03-orden-de-las-redirecciones
   mkdir zona
   ```
   (sin salida).

1. **El instalador de pega:**
   ```bash
   bash starter/noisy.sh
   bash starter/noisy.sh > zona/a.log
   ```
   ```text
   paso 1: descargando
   aviso: el espejo principal no responde
   paso 2: instalando
   error: falta espacio en disco
   aviso: el espejo principal no responde
   error: falta espacio en disco
   ```
   Con `>`, los problemas siguen en pantalla y el log solo tiene el progreso. Justo lo que no quieres en un log.

2. **Mira los descriptores de un proceso.** `/proc/self/fd` es una carpeta especial que muestra adónde apunta cada descriptor del proceso que la lee (aquí, el propio `ls`):
   ```bash
   ls -l /proc/self/fd
   ```
   Algo como:
   ```text
   total 0
   lrwx------ 1 alumno alumno 64 Nov  8 05:07 0 -> /dev/pts/0
   lrwx------ 1 alumno alumno 64 Nov  8 05:07 1 -> /dev/pts/0
   lrwx------ 1 alumno alumno 64 Nov  8 05:07 2 -> /dev/pts/0
   lr-x------ 1 alumno alumno 64 Nov  8 05:07 3 -> /proc/14/fd
   ```
   `/dev/pts/0` es tu terminal: los tres descriptores apuntan a ella. El `3` es la carpeta que `ls` tiene abierta para leerla; ignóralo.

3. **`> archivo 2>&1`: primero el 1, después el 2.**
   ```bash
   ls -l /proc/self/fd > zona/fd.txt 2>&1
   cat zona/fd.txt
   ```
   Algo como:
   ```text
   total 0
   lrwx------ 1 alumno alumno 64 Nov  8 05:07 0 -> /dev/pts/0
   l-wx------ 1 alumno alumno 64 Nov  8 05:07 1 -> /bc-bash/bootcamp/week-03-redireccion_pipes_y_codigos_de_salida/2-practicas/lab-03-orden-de-las-redirecciones/zona/fd.txt
   l-wx------ 1 alumno alumno 64 Nov  8 05:07 2 -> /bc-bash/bootcamp/week-03-redireccion_pipes_y_codigos_de_salida/2-practicas/lab-03-orden-de-las-redirecciones/zona/fd.txt
   lr-x------ 1 alumno alumno 64 Nov  8 05:07 3 -> /proc/15/fd
   ```
   `> zona/fd.txt` mueve el 1 al archivo. Después `2>&1` copia el 1, que **ya** es el archivo. Los dos acaban en `zona/fd.txt`.

4. **`2>&1 > archivo`: al revés.**
   ```bash
   ls -l /proc/self/fd 2>&1 > zona/fd.txt
   cat zona/fd.txt
   ```
   Algo como:
   ```text
   total 0
   lrwx------ 1 alumno alumno 64 Nov  8 05:07 0 -> /dev/pts/0
   l-wx------ 1 alumno alumno 64 Nov  8 05:07 1 -> /bc-bash/bootcamp/week-03-redireccion_pipes_y_codigos_de_salida/2-practicas/lab-03-orden-de-las-redirecciones/zona/fd.txt
   lrwx------ 1 alumno alumno 64 Nov  8 05:07 2 -> /dev/pts/0
   lr-x------ 1 alumno alumno 64 Nov  8 05:07 3 -> /proc/15/fd
   ```
   `2>&1` copió el 1 cuando todavía era la terminal. Luego `>` movió solo el 1. El 2 se quedó en la terminal.

5. **Lo mismo con el instalador:**
   ```bash
   bash starter/noisy.sh > zona/b.log 2>&1
   cat zona/b.log
   bash starter/noisy.sh 2>&1 > zona/c.log
   ```
   ```text
   paso 1: descargando
   aviso: el espejo principal no responde
   paso 2: instalando
   error: falta espacio en disco
   aviso: el espejo principal no responde
   error: falta espacio en disco
   ```
   El primero no imprime nada y su log tiene las cuatro líneas, en orden. El segundo deja los problemas en pantalla, como en el paso 1. `&> zona/b.log` es el atajo de bash para lo primero.

6. **Por qué importa con pipes.** Un pipe (`|`, lab 04) solo conecta stdout:
   ```bash
   bash starter/noisy.sh | wc -l
   bash starter/noisy.sh 2>&1 | wc -l
   ```
   ```text
   aviso: el espejo principal no responde
   error: falta espacio en disco
   2
   4
   ```
   `wc -l` cuenta 2 líneas: los problemas no entraron en el pipe, salieron por pantalla. Con `2>&1` delante entran los cuatro. Aquí el orden es natural: bash conecta el pipe **antes** de aplicar las redirecciones del comando, así que `2>&1` ya copia el pipe.

7. **El script, sin tocar:**
   ```bash
   bash starter/capture-all.sh
   cat zona/todo.log
   ```
   ```text
   aviso: el espejo principal no responde
   error: falta espacio en disco
   paso 1: descargando
   paso 2: instalando
   ```

8. **TODO 1.** Abre `starter/capture-all.sh` en tu editor y cambia el orden de las dos redirecciones. Prueba:
   ```bash
   bash starter/capture-all.sh
   cat zona/todo.log
   ```
   ```text
   paso 1: descargando
   aviso: el espejo principal no responde
   paso 2: instalando
   error: falta espacio en disco
   ```
   El script ya no imprime nada; el log lo tiene todo.

9. **TODO 2.** Bajo el `TODO 2`, otra ejecución de `bash starter/noisy.sh` que **añada** salida y errores al final de `zona/todo.log` (`>>` y `2>&1`, en ese orden). Borra los comentarios `TODO`. Prueba:
   ```bash
   bash starter/capture-all.sh
   wc -l < zona/todo.log
   ```
   ```text
   8
   ```
   Ocho líneas: la primera ejecución vacía el log y escribe 4; la segunda suma otras 4. Ejecuta el script otra vez: sigue habiendo 8, porque el primer `>` vuelve a empezar.

## Criterios de éxito

- [ ] Explicas con la salida de `/proc/self/fd` por qué `2>&1 > archivo` deja stderr en la terminal (pasos 3 y 4)
- [ ] Explicas por qué `wc -l` contó 2 y no 4 en el paso 6
- [ ] `bash starter/capture-all.sh` no imprime nada y deja 8 líneas en `zona/todo.log`

## Reto extra

`>&2` es una forma corta de `1>&2`. Con lo que has visto, predice qué hace `echo hola >&2 2> /dev/null`, ¿se ve `hola`? Pruébalo y explícalo con el orden de izquierda a derecha.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 02 — Sobrescribir y añadir](../lab-02-sobrescribir-y-anadir/README.md) | [Lab 04 — Pipes y tee](../lab-04-pipes-y-tee/README.md) → |

[↑ Semana 03](../../README.md)
