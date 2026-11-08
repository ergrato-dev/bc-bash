# Lab 01 — for

⏱ Duración estimada: ~60 min

## Objetivo

Repetir un bloque por cada elemento de una lista, de un rango o de un glob, sin partir los nombres con espacios.

## Contexto

- `for nombre in lista; do ... done` ejecuta el bloque una vez por elemento, con `nombre` valiendo cada uno.
- La lista puede ser palabras escritas a mano, un rango `{1..5}`, un glob `carpeta/*` o los argumentos `"$@"`. Hay una forma más, con contador: `for ((i = 1; i <= 5; i++))`.
- `starter/sizes.sh` enseña el tamaño de cada archivo de una carpeta y la suma. Recorre la carpeta con `$(ls)`, el error clásico; lo cambias por un glob.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-07-bucles_read_y_archivos_seguros/2-practicas/lab-01-for
   ```
   (sin salida).

1. **Una lista escrita a mano.** `do` abre el bloque que se repite y `done` lo cierra. En la terminal, todo cabe en una línea separando las piezas con `;`:
   ```bash
   for x in uno dos tres; do echo "$x"; done
   ```
   ```text
   uno
   dos
   tres
   ```
   Tres palabras, tres vueltas. En cada una, `x` vale una palabra.

2. **Un rango y un contador.** `{1..3}` se expande a `1 2 3` antes de que el `for` empiece. La forma con `(( ))` tiene tres partes separadas por `;`: el valor inicial, la condición para seguir y lo que cambia al final de cada vuelta (`i++` suma 1 a `i`).
   ```bash
   for i in {1..3}; do echo "vuelta $i"; done
   for ((i = 1; i <= 3; i++)); do echo "i vale $i"; done
   ```
   ```text
   vuelta 1
   vuelta 2
   vuelta 3
   i vale 1
   i vale 2
   i vale 3
   ```
   `{1..3}` no acepta variables (`{1..$n}` no funciona); el contador, sí: `for ((i = 1; i <= n; i++))`.

3. **Una carpeta con un nombre con espacios.** Prepara datos:
   ```bash
   mkdir -p zona/fotos/viejas
   echo hola > "zona/fotos/mi foto.jpg"
   echo 1234567890 > zona/fotos/notas.txt
   ls zona/fotos
   ```
   ```text
   'mi foto.jpg'   notas.txt   viejas
   ```
   Dos archivos y una carpeta. `ls` pone entre comillas el nombre con espacios: así lo escribirías en un comando.

4. **`$(ls)` frente a un glob.** Los corchetes en el `echo` marcan dónde empieza y acaba cada vuelta:
   ```bash
   for f in $(ls zona/fotos); do echo "[$f]"; done
   for f in zona/fotos/*; do echo "[$f]"; done
   ```
   ```text
   [mi]
   [foto.jpg]
   [notas.txt]
   [viejas]
   [zona/fotos/mi foto.jpg]
   [zona/fotos/notas.txt]
   [zona/fotos/viejas]
   ```
   `$(ls)` devuelve un texto, y bash lo parte por los espacios: `mi foto.jpg` da dos vueltas (word splitting, semana 05). El glob lo expande bash y da cada nombre entero, con la ruta delante. Es la forma de recorrer los archivos de una carpeta.

5. **TODO 1: el glob en el script.** Ejecútalo tal cual y pásale shellcheck:
   ```bash
   bash starter/sizes.sh zona/fotos; echo $?
   shellcheck starter/sizes.sh
   ```
   ```text
   starter/sizes.sh: line 11: zona/fotos/mi: No such file or directory
   1

   In starter/sizes.sh line 9:
   for f in $(ls "$dir"); do
            ^----------^ SC2045 (error): Iterating over ls output is fragile. Use globs.

   For more information:
     https://www.shellcheck.net/wiki/SC2045 -- Iterating over ls output is fragi...
   ```
   Abre `starter/sizes.sh` en tu editor. Cambia `for f in $(ls "$dir"); do` por `for f in "$dir"/*; do`: las comillas protegen la carpeta, y el `*` se queda fuera para que bash lo expanda. Como ahora `f` ya trae la carpeta delante, cambia también `"$dir/$f"` por `"$f"` en la línea del `wc`. Borra el comentario del `TODO 1`. Prueba:
   ```bash
   bash starter/sizes.sh zona/fotos; echo $?
   ```
   ```text
   5 zona/fotos/mi foto.jpg
   11 zona/fotos/notas.txt
   wc: 'standard input': Is a directory
   1
   ```
   `mi foto.jpg` ya es un solo archivo. Ahora falla `viejas`: es una carpeta y `wc` no puede contar sus bytes.

6. **TODO 2: solo archivos.** Mete las tres líneas del bloque (`size=`, `echo` y `total=`) dentro de un `if` que solo entre si `$f` es un archivo normal (`-f`, semana 06):
   ```bash
     if [[ -f $f ]]; then
       size=$(wc -c < "$f")
       echo "$size $f"
       total=$((total + size))
     fi
   ```
   Borra el comentario del `TODO 2`. Prueba:
   ```bash
   bash starter/sizes.sh zona/fotos; echo $?
   ```
   ```text
   5 zona/fotos/mi foto.jpg
   11 zona/fotos/notas.txt
   total: 16 bytes
   0
   ```
   `hola` y el salto de línea son 5 bytes; las diez cifras y el salto, 11.

7. **Un glob que no encaja con nada.** En una carpeta vacía:
   ```bash
   mkdir zona/vacia
   for f in zona/vacia/*; do echo "[$f]"; done
   ```
   ```text
   [zona/vacia/*]
   ```
   Si un glob no encaja con nada, bash lo deja tal cual: una vuelta con un "archivo" llamado `*` que no existe. `shopt -s nullglob` cambia ese comportamiento: un glob sin coincidencias desaparece. `shopt -u` lo vuelve a quitar:
   ```bash
   shopt -s nullglob; for f in zona/vacia/*; do echo "[$f]"; done; shopt -u nullglob
   bash starter/sizes.sh zona/vacia
   ```
   ```text
   total: 0 bytes
   ```
   Con `nullglob`, cero vueltas: el `for` no imprime nada. El script ya respondía bien sin él: el `-f` del paso 6 deja fuera el `*`.

## Criterios de éxito

- [ ] Explicas por qué `$(ls)` dio cuatro vueltas con tres entradas (paso 4)
- [ ] Explicas qué hace un glob que no encaja con nada y qué cambia `nullglob` (paso 7)
- [ ] `bash starter/sizes.sh zona/fotos` imprime `total: 16 bytes` y sale con `0`
- [ ] `shellcheck starter/sizes.sh` no imprime nada

## Reto extra

Haz que `sizes.sh` acepte varias carpetas: `bash starter/sizes.sh zona/fotos zona/vacia`. Pista: un `for dir in "$@"` por fuera del que ya tienes.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Índice de labs](../README.md) | [Lab 02 — while y until](../lab-02-while-y-until/README.md) → |

[↑ Semana 07](../../README.md)
