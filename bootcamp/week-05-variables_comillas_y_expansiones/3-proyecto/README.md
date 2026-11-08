# Proyecto Semana 05 — bk-rename: nombres de archivo sin sorpresas

⏱ Duración estimada: ~3 h 30 min

## Contexto

Las cámaras, los móviles y la gente ponen nombres como `Mi Foto (1).JPG` o `Canción del Verano.MP3`. Funcionan, pero obligan a citar en cada comando, se rompen en un script sin comillas y dan problemas en URLs y en servidores que distinguen mayúsculas. Escribes **`bk-rename`**, el cuarto comando de `bashkit` ([docs/proyecto-hilo-conductor.md](../../../docs/proyecto-hilo-conductor.md)): recibe un archivo y le pone un nombre limpio, solo con expansiones de parámetros de bash.

```text
$ bk-rename --dry-run "Mi Foto (1).JPG"
(dry-run) Mi Foto (1).JPG -> mi-foto-1.jpg
$ bk-rename "Mi Foto (1).JPG"
Mi Foto (1).JPG -> mi-foto-1.jpg
```

Las reglas: todo en minúsculas, espacios por guiones, las tildes y la `ñ` por su letra sin tilde, y fuera todo lo que no sea letra, cifra, `.`, `-` o `_`. `--dry-run` enseña el cambio sin hacerlo. Lo probarás con `tests/fixtures/`, una carpeta con cinco archivos de nombres incómodos.

## Estructura del proyecto

`starter/` es el `bashkit` con el que terminaste la semana 04, más lo nuevo:

```text
3-proyecto/
├── tests/
│   └── fixtures/            ← archivos de prueba (no los cambies: los usa el autograding)
└── starter/                 ← aquí trabajas (lo corrige el autograding)
    ├── README.md            ← fila de bk-rename y bitácora de la semana 05 (TODOs)
    ├── scaffold.sh
    ├── bin/
    │   ├── .gitkeep
    │   ├── bk-info
    │   ├── bk-run
    │   ├── bk-top-ips
    │   └── bk-rename        ← nuevo: sin permiso de ejecución (TODOs 1 a 9)
    ├── lib/.gitkeep
    ├── tests/.gitkeep
    └── docs/
        ├── mapa.txt
        └── inventario.txt   ← hay que regenerarlo
```

## Lo que debes construir

1. `bin/bk-rename` con permisos `755`. El uso (código `2`) y el archivo que no existe (código `1`) ya vienen hechos, como en `bk-top-ips`.
2. Acepta `--dry-run` como primer argumento: enseña el cambio y no renombra.
3. Cambia solo el nombre del archivo, nunca las carpetas de su ruta.
4. El nombre nuevo: minúsculas, `-` en lugar de espacios, `á é í ó ú ü ñ` sin tilde, y sin ningún carácter fuera de `a-z`, `0-9`, `.`, `-` y `_`.
5. Si el nombre ya está bien, imprime `sin cambios: <archivo>` y sale con `0`.
6. Si ya existe un archivo con el nombre nuevo, avisa en stderr, sale con `1` y no toca nada.
7. Imprime `origen -> destino`, con `(dry-run) ` delante en modo de prueba.
8. Todos los scripts del kit sin TODOs y sin avisos de shellcheck; `docs/inventario.txt` regenerado y `README.md` sin TODOs.

## Paso a paso

### Paso 0 — Entrar al laboratorio y preparar los archivos de prueba

Desde la raíz del repositorio, en tu equipo:

```bash
docker compose run --rm lab
cd bootcamp/week-05-variables_comillas_y_expansiones/3-proyecto/starter
mkdir -p ../zona
cp -r ../tests/fixtures/. ../zona/
ls ../zona
```

```text
Canción del Verano.MP3
Fotos Viaje
Mi Foto (1).JPG
notas-2026.txt
¡Oferta, Ya!.txt
```

`../zona` es la carpeta de pruebas del proyecto, al lado de `starter/`: git la ignora. `cp -r ../tests/fixtures/. ../zona/` copia el **contenido** de `fixtures/` (el `/.` del final) y no la carpeta. Así trabajas sobre una copia: si algo sale mal, borra `../zona` y repite el paso.

### Paso 1 — `bk-rename` ejecutable

```bash
ls -l bin/bk-rename
chmod +x bin/bk-rename
./bin/bk-rename
echo $?
./bin/bk-rename nada.txt
echo $?
./bin/bk-rename ../zona/notas-2026.txt
echo $?
```

Algo como (cambian el tamaño y la fecha):

```text
-rw-r--r-- 1 alumno alumno 1148 Nov  8 05:48 bin/bk-rename
uso: bk-rename [--dry-run] <archivo>
2
bk-rename: no existe 'nada.txt'
1
sin implementar
1
```

El uso y la comprobación de que el archivo existe ya vienen escritos, igual que en `bk-top-ips` (semana 04). El resto, en los TODOs. Abre `bin/bk-rename` en tu editor y léelo entero antes de seguir.

### Paso 2 — TODO 1: la opción `--dry-run`

Ahora `--dry-run` se toma por el nombre de un archivo:

```bash
./bin/bk-rename --dry-run
echo $?
```

```text
bk-rename: no existe '--dry-run'
1
```

`shift` quita el primer argumento: lo que era `$2` pasa a ser `$1`, y `$#` baja en uno. Sustituye la línea `dry_run=""` del `TODO 1` por estas dos:

```bash
dry_run=""
test "${1:-}" != "--dry-run" || { dry_run=1; shift; }
```

`${1:-}` vale lo mismo que `$1`, o vacío si no hay ningún argumento: sin él, `set -u` pararía el script con `$1: unbound variable` (lab 04). Si el primer argumento es `--dry-run`, el `test` falla y se ejecuta el bloque: `dry_run` vale `1` y la opción desaparece de los argumentos. Borra el comentario del `TODO 1`. Prueba:

```bash
./bin/bk-rename --dry-run
echo $?
```

```text
uso: bk-rename [--dry-run] <archivo>
2
```

Después del `shift` no queda ningún argumento, así que salta el mensaje de uso.

### Paso 3 — TODO 2: el nombre y la carpeta

Antes de escribir en el script, prueba las expansiones en la terminal (lab 05). `##*/` quita desde el principio todo lo que encaje con `*/`, lo más largo posible: deja lo que hay después de la última `/`. Con una sola `#`, lo más corto: solo hasta la primera `/`.

```bash
src='../zona/Fotos Viaje/IMG 0042.png'
echo "${src##*/}"
echo "${src#*/}"
```

```text
IMG 0042.png
zona/Fotos Viaje/IMG 0042.png
```

Para la carpeta, quita el nombre del final con `%`. El nombre va entre comillas dentro de la expansión para que sus caracteres cuenten tal cual y no como patrón:

```bash
name="${src##*/}"
echo "${src%"$name"}"
```

```text
../zona/Fotos Viaje/
```

¿Por qué no `${src%/*}`? Con un archivo sin carpeta, no hay `/` que quitar:

```bash
s2=notas.txt
echo "[${s2%/*}]"
n2="${s2##*/}"
echo "[${s2%"$n2"}]"
```

```text
[notas.txt]
[]
```

`${s2%/*}` devuelve el nombre entero como si fuera la carpeta; `${s2%"$n2"}` da vacío, que es lo correcto. Sustituye el comentario del `TODO 2` por las dos líneas `name="${src##*/}"` y `dir="${src%"$name"}"`.

### Paso 4 — TODO 3: minúsculas y guiones

`${var,,}` pasa todo a minúsculas. `${var// /-}` cambia **cada** espacio por un guion; con una sola `/`, solo el primero:

```bash
name='Mi Foto (1).JPG'
new="${name,,}"
echo "$new"
new="${new// /-}"
echo "$new"
echo "${name/ /-}"
```

```text
mi foto (1).jpg
mi-foto-(1).jpg
Mi-Foto (1).JPG
```

Escribe en el script, en el sitio del `TODO 3`, `new="${name,,}"` y en la línea siguiente `new="${new// /-}"`.

### Paso 5 — TODO 4: las tildes

Dentro del patrón, `[áà]` es "una `á` o una `à`" (lab 03): `${new//[áà]/a}` cambia cualquiera de las dos por `a`.

```bash
new='canción del verano.mp3'
new="${new//[áà]/a}"
new="${new//[óò]/o}"
echo "$new"
```

```text
cancion del verano.mp3
```

En el sitio del `TODO 4`, escribe una línea para cada vocal y otra para la `ñ`:

```bash
new="${new//[áà]/a}"
new="${new//[éè]/e}"
new="${new//[íì]/i}"
new="${new//[óò]/o}"
new="${new//[úùü]/u}"
new="${new//ñ/n}"
```

Van después del `${name,,}`: así una `Á` ya es `á` cuando llega aquí.

### Paso 6 — TODO 5: fuera los símbolos

`[^...]` es "cualquier carácter que **no** esté en la lista". Cambiarlo por nada lo borra:

```bash
new='mi-foto-(1).jpg'
echo "${new//[^a-z0-9._-]/}"
new='¡oferta,-ya!.txt'
echo "${new//[^a-z0-9._-]/}"
```

```text
mi-foto-1.jpg
oferta-ya.txt
```

El `-` va al final de la lista para que cuente como guion y no como rango. Escribe en el sitio del `TODO 5` la línea `new="${new//[^a-z0-9._-]/}"`.

### Paso 7 — TODO 6: si no cambia nada

`mv a a` da error (`are the same file`). Sustituye el comentario del `TODO 6` por una línea con la forma de las de arriba: `test "$new" != "$name" || { echo "sin cambios: $src"; exit 0; }`. No es un error, así que va a stdout y sale con `0`. Prueba con un nombre que ya está bien:

```bash
./bin/bk-rename ../zona/notas-2026.txt
echo $?
```

```text
sin cambios: ../zona/notas-2026.txt
0
```

### Paso 8 — TODO 7: no pisar

`mv` sustituye sin preguntar un archivo que ya tenga el nombre de destino, y el que había se pierde. Sustituye el comentario del `TODO 7` por dos líneas: `dst="$dir$new"`, el destino completo, y un `test ! -e "$dst" || { ...; }` que escriba en stderr `bk-rename: ya existe '<destino>', no lo piso` y salga con `1`. `! -e` es "no existe". Prueba con un `mi-foto-1.jpg` que ya está ahí:

```bash
echo vieja > ../zona/mi-foto-1.jpg
./bin/bk-rename '../zona/Mi Foto (1).JPG'
echo $?
rm ../zona/mi-foto-1.jpg
```

```text
bk-rename: ya existe '../zona/mi-foto-1.jpg', no lo piso
1
```

El `rm` quita el archivo de prueba para los pasos siguientes.

### Paso 9 — TODO 8: decir qué hace

`${var:+texto}` vale `texto` si la variable tiene algo, y vacío si no (lab 04). Sustituye el comentario del `TODO 8` por:

```bash
echo "${dry_run:+(dry-run) }$src -> $dst"
```

Prueba (el `sin implementar` del final sigue ahí hasta el paso 10):

```bash
./bin/bk-rename --dry-run '../zona/Mi Foto (1).JPG'
echo $?
```

```text
(dry-run) ../zona/Mi Foto (1).JPG -> ../zona/mi-foto-1.jpg
sin implementar
1
```

### Paso 10 — TODO 9: renombrar

Sustituye el comentario del `TODO 9` por la línea que renombra, salvo en modo de prueba:

```bash
test -n "$dry_run" || mv -- "$src" "$dst"
```

`-n` es "no está vacía". `--` le dice a `mv` que lo que sigue no son opciones, aunque un nombre empiece por `-`. Borra el `echo "sin implementar"` y el `exit 1` del final. Prueba primero en modo de prueba y después de verdad:

```bash
./bin/bk-rename --dry-run '../zona/Mi Foto (1).JPG'
echo $?
ls ../zona
./bin/bk-rename '../zona/Mi Foto (1).JPG'
echo $?
ls ../zona
```

```text
(dry-run) ../zona/Mi Foto (1).JPG -> ../zona/mi-foto-1.jpg
0
Canción del Verano.MP3
Fotos Viaje
Mi Foto (1).JPG
notas-2026.txt
¡Oferta, Ya!.txt
../zona/Mi Foto (1).JPG -> ../zona/mi-foto-1.jpg
0
Canción del Verano.MP3
Fotos Viaje
mi-foto-1.jpg
notas-2026.txt
¡Oferta, Ya!.txt
```

Con `--dry-run`, la carpeta no cambia; sin él, `Mi Foto (1).JPG` ya es `mi-foto-1.jpg`.

### Paso 11 — Una carpeta entera con `find -exec`

`bk-rename` trabaja con un archivo. Para todos, `find -exec` (semana 04) lo ejecuta una vez por cada uno: `{}` es el archivo y `\;` cierra el comando. Mira antes con `--dry-run`:

```bash
find ../zona -type f -exec ./bin/bk-rename --dry-run {} \;
```

Algo como (el orden puede variar):

```text
sin cambios: ../zona/mi-foto-1.jpg
sin cambios: ../zona/notas-2026.txt
(dry-run) ../zona/Canción del Verano.MP3 -> ../zona/cancion-del-verano.mp3
(dry-run) ../zona/¡Oferta, Ya!.txt -> ../zona/oferta-ya.txt
(dry-run) ../zona/Fotos Viaje/IMG 0042.png -> ../zona/Fotos Viaje/img-0042.png
```

La lista te convence: lo mismo sin `--dry-run`, y el resultado:

```bash
find ../zona -type f -exec ./bin/bk-rename {} \;
find ../zona | sort
```

```text
sin cambios: ../zona/mi-foto-1.jpg
sin cambios: ../zona/notas-2026.txt
../zona/Canción del Verano.MP3 -> ../zona/cancion-del-verano.mp3
../zona/¡Oferta, Ya!.txt -> ../zona/oferta-ya.txt
../zona/Fotos Viaje/IMG 0042.png -> ../zona/Fotos Viaje/img-0042.png
../zona
../zona/Fotos Viaje
../zona/Fotos Viaje/img-0042.png
../zona/cancion-del-verano.mp3
../zona/mi-foto-1.jpg
../zona/notas-2026.txt
../zona/oferta-ya.txt
```

`Fotos Viaje` sigue con su nombre: `bk-rename` solo toca archivos. Para repetir las pruebas: `rm -r ../zona` y vuelve al paso 0.

### Paso 12 — El kit sin TODOs y sin avisos

```bash
grep -n TODO bin/bk-info bin/bk-run bin/bk-top-ips bin/bk-rename scaffold.sh
shellcheck bin/bk-info bin/bk-run bin/bk-top-ips bin/bk-rename scaffold.sh
```

(sin salida): ningún TODO y ningún aviso. Si shellcheck dice `SC2086 (info): Double quote to prevent globbing and word splitting`, te falta citar una variable: el fallo del lab 03.

### Paso 13 — El inventario al día

```bash
find . -type f > docs/inventario.txt
cat docs/inventario.txt
```

Algo como (el orden puede variar):

```text
./README.md
./scaffold.sh
./docs/mapa.txt
./docs/inventario.txt
./tests/.gitkeep
./bin/bk-info
./bin/bk-run
./bin/bk-top-ips
./bin/bk-rename
./bin/.gitkeep
./lib/.gitkeep
```

### Paso 14 — README del kit

```bash
grep -n TODO README.md
```

```text
25:| `bin/bk-rename` | TODO: qué hace, qué opción acepta y qué nombres no toca |
39:- Semana 05: TODO: qué aprendiste y qué te costó.
```

Abre `README.md` en tu editor y sustituye cada `TODO` con tus palabras: qué hace `bk-rename`, qué hace `--dry-run`, qué no toca (las carpetas, un destino que ya existe), y la bitácora de la semana (la línea tiene que empezar por `- Semana 05:`). Repite el `grep` hasta que no imprima nada.

### Paso 15 — Autograding

```bash
cd "$(git rev-parse --show-toplevel)" && ./scripts/verificar-semana.sh 05
```

Con todo hecho:

```text
Semana 05 — Variables, comillas y expansiones

  ✅ bin/bk-rename tiene permisos 755 y el shebang #!/usr/bin/env bash
  ✅ sin argumentos, bk-rename escribe 'uso: bk-rename ...' en stderr y sale con código 2
  ...
  ✅ README.md sin TODOs, documenta bk-rename y tiene la bitácora de la semana 05

15/15 comprobaciones superadas.
```

Cada ❌ trae una pista con el paso donde se arregla. Para salir del laboratorio: `exit`.

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 05` desde la raíz del repositorio (60 de los 100 puntos del Producto). Los otros 40 son de calidad: ver la [rúbrica](../rubrica-evaluacion.md#-producto-30).

- [ ] bin/bk-rename tiene permisos 755 y el shebang #!/usr/bin/env bash
- [ ] sin argumentos, bk-rename escribe 'uso: bk-rename ...' en stderr y sale con código 2
- [ ] con un archivo que no existe, avisa en stderr con su nombre y sale con código 1
- [ ] 'Mi Foto (1).JPG' pasa a llamarse mi-foto-1.jpg
- [ ] imprime una línea 'origen -> destino'
- [ ] con --dry-run enseña el cambio con '(dry-run) ' delante y no renombra
- [ ] 'Canción del Verano.MP3' pasa a cancion-del-verano.mp3
- [ ] '¡Oferta, Ya!.txt' pasa a oferta-ya.txt
- [ ] solo cambia el nombre del archivo, no el de su carpeta
- [ ] un nombre que ya está bien: 'sin cambios: ...' y código 0
- [ ] si el destino ya existe, avisa en stderr, sale con código 1 y no toca ninguno de los dos
- [ ] con find -exec renombra todos los archivos de prueba
- [ ] los scripts del kit sin TODOs, con set -euo pipefail y limpios para shellcheck
- [ ] docs/inventario.txt incluye ./bin/bk-rename
- [ ] README.md sin TODOs, documenta bk-rename y tiene la bitácora de la semana 05

## Calidad

Además de los checks, se revisa (40 pts, ver la rúbrica):

- Cada `"$var"` y cada `"${...}"` entre comillas dobles, también donde hoy no haría falta.
- El nombre se separa con `##*/` y `%"$name"`, no con `cut` ni `sed`: el ejercicio es hacerlo con bash.
- Mensajes de uso y de error a stderr; `sin cambios` y `origen -> destino`, a stdout.
- Comentarios que explican el porqué: por qué solo el nombre, por qué las tildes antes del filtro, por qué no pisar.

## Entrega

Commit desde tu copia del repositorio con el mensaje `feat(week-05): bk-rename` que incluya `starter/` completo. Comprueba con `git diff` que aparece `new mode 100755` para `bin/bk-rename`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 07 — Sustitución de comandos](../2-practicas/lab-07-sustitucion-de-comandos/README.md) | [Rúbrica de evaluación](../rubrica-evaluacion.md) → |

[↑ Semana 05](../README.md)
