# Proyecto Semana 01 — El esqueleto de bashkit

⏱ Duración estimada: ~3 h 30 min

## Contexto

Entras en un equipo de operaciones. Cada persona tiene sus propios scripts sueltos en carpetas distintas y nadie sabe dónde está cada cosa. Tu primera tarea es poner orden: una carpeta con una estructura clara que irá creciendo durante todo el bootcamp hasta ser **`bashkit`**, una herramienta de línea de comandos completa ([docs/proyecto-hilo-conductor.md](../../../docs/proyecto-hilo-conductor.md)).

Esta semana no programas todavía: construyes el árbol a mano, lo ordenas, escribes una receta (`scaffold.sh`) que lo rehace en cualquier máquina y dejas un inventario de lo que hay.

## Estructura del proyecto

```text
starter/                   ← aquí trabajas: es tu bashkit (lo corrige el autograding)
├── README.md              ← documentación del kit (TODOs)
├── scaffold.sh            ← receta que recrea la estructura (TODOs)
├── mapa.txt               ← va dentro de docs/
└── borrador-viejo.txt     ← sobra: se borra
```

Al terminar:

```text
starter/
├── README.md
├── scaffold.sh
├── bin/.gitkeep
├── lib/.gitkeep
├── tests/.gitkeep
└── docs/
    ├── mapa.txt
    └── inventario.txt
```

## Lo que debes construir

1. Las carpetas `bin/`, `lib/`, `tests/` y `docs/` dentro de `starter/`.
2. Un `.gitkeep` vacío en `bin/`, `lib/` y `tests/` (git no guarda carpetas vacías; `docs/` tendrá archivos).
3. `mapa.txt` movido a `docs/` y `borrador-viejo.txt` borrado.
4. `scaffold.sh`: al ejecutarlo con `bash scaffold.sh` crea `bashkit/` en la carpeta actual, con las cuatro carpetas, un `.gitkeep` en cada una y un `README.md` cuya primera línea es `# bashkit`. No crea nada fuera de `bashkit/`, se puede ejecutar dos veces seguidas y no borra lo que ya hay dentro.
5. `docs/inventario.txt`: la lista de todos los archivos del kit, generada con `find`.
6. `README.md` del kit completo, sin ningún `TODO`.

## Paso a paso

### Paso 0 — Entrar al laboratorio y a la carpeta del proyecto

Desde la raíz del repositorio, en tu equipo:

```bash
docker compose run --rm lab
cd bootcamp/week-01-terminal_y_sistema_de_archivos/3-proyecto
ls -A starter
```

```text
README.md  borrador-viejo.txt  mapa.txt  scaffold.sh
```

`ls -A` es como `ls -a` sin `.` ni `..`. Comprueba que `scaffold.sh` todavía no hace nada:

```bash
bash starter/scaffold.sh
```

```text
scaffold.sh: sin implementar
```

### Paso 1 — Crear las cuatro carpetas

Entra en `starter/`: desde aquí, todo lo que crees forma parte del kit.

```bash
cd starter
mkdir bin lib tests docs
ls
```

```text
README.md  bin  borrador-viejo.txt  docs  lib  mapa.txt  scaffold.sh  tests
```

Un solo `mkdir` crea las cuatro: cada argumento es una carpeta. No hace falta `-p` porque `starter/` ya existe. Si repites el comando, `mkdir` responde `cannot create directory 'bin': File exists`: no pasa nada, ya estaban.

### Paso 2 — Un `.gitkeep` en cada carpeta vacía

```bash
touch bin/.gitkeep lib/.gitkeep tests/.gitkeep
ls bin
ls -a bin
```

```text
.  ..  .gitkeep
```

El primer `ls bin` no imprime nada: `.gitkeep` empieza por punto y está oculto. `ls -a` lo muestra.

### Paso 3 — Ordenar: mover y borrar

`mapa.txt` describe el kit, así que es documentación: va a `docs/`. La barra final de `docs/` deja claro que el destino es una carpeta.

```bash
mv mapa.txt docs/
ls
ls docs
```

```text
README.md  bin  borrador-viejo.txt  docs  lib  scaffold.sh  tests
mapa.txt
```

Antes de borrar, mira qué es (`cat` muestra el contenido) y bórralo con `-i`, que pregunta:

```bash
cat borrador-viejo.txt
rm -i borrador-viejo.txt
```

```text
Borrador antiguo del mapa. Ya no sirve: bórralo.
rm: remove regular file 'borrador-viejo.txt'?
```

Escribe `y` y pulsa `Enter`. Comprueba:

```bash
ls
```

```text
README.md  bin  docs  lib  scaffold.sh  tests
```

### Paso 4 — `scaffold.sh`, TODO 1: las carpetas

Vuelve a `3-proyecto/` y prepara `zona/`, una carpeta de pruebas que git ignora. Ahí ejecutarás `scaffold.sh` sin ensuciar el kit:

```bash
cd ..
mkdir -p zona
```

(sin salida). Abre `starter/scaffold.sh` en tu editor. En el **TODO 1**, escribe un `mkdir` con `-p` y las cuatro rutas `bashkit/bin`, `bashkit/lib`, `bashkit/tests` y `bashkit/docs`. `-p` hace dos cosas: crea `bashkit/` de paso y no falla si las carpetas ya existen, así el script se puede repetir. Borra la línea `echo "scaffold.sh: sin implementar"`. Prueba:

```bash
cd zona
bash ../starter/scaffold.sh
ls
ls bashkit
cd ..
```

```text
bashkit
bin  docs  lib  tests
```

`../starter/scaffold.sh` es una ruta relativa: sube a `3-proyecto/` y baja a `starter/`. El script crea `bashkit/` en la carpeta **desde la que lo ejecutas** (`zona/`), no donde está guardado.

### Paso 5 — TODO 2: los `.gitkeep`

Un solo `touch` con las cuatro rutas: `bashkit/bin/.gitkeep`, `bashkit/lib/.gitkeep`, `bashkit/tests/.gitkeep` y `bashkit/docs/.gitkeep`. Prueba:

```bash
cd zona
bash ../starter/scaffold.sh
ls -A bashkit/bin bashkit/docs
cd ..
```

```text
bashkit/bin:
.gitkeep

bashkit/docs:
.gitkeep
```

Con varias carpetas, `ls` pone el nombre de cada una antes de su contenido.

### Paso 6 — TODO 3: el README del esqueleto

`echo` imprime un texto; con `>` lo guardas en un archivo en vez de verlo en pantalla. Escribe `echo "# bashkit" > bashkit/README.md`. Las comillas hacen que `#` sea texto: sin ellas, bash lo tomaría como el comienzo de un comentario. Añade al final del script un `echo "bashkit/ creado"` para saber que terminó. Prueba, dos veces seguidas:

```bash
cd zona
bash ../starter/scaffold.sh
bash ../starter/scaffold.sh
cat bashkit/README.md
ls -A bashkit
cd ..
```

```text
bashkit/ creado
bashkit/ creado
# bashkit
README.md  bin  docs  lib  tests
```

La segunda ejecución no da error: `mkdir -p` acepta carpetas que ya existen y `touch` sobre un archivo que existe solo cambia su fecha. `>` sí reemplaza `README.md` cada vez; en la semana 06 aprenderás a comprobar antes si existe.

### Paso 7 — Calidad de `scaffold.sh`

`shellcheck` revisa un script y avisa de errores típicos; `grep -n TODO` busca las líneas que todavía dicen `TODO` (con su número). `echo $?` imprime el código de salida del comando anterior: `0` es "todo bien".

```bash
shellcheck starter/scaffold.sh; echo $?
grep -n TODO starter/scaffold.sh; echo $?
```

```text
0
1
```

`shellcheck` sin avisos sale con `0`. `grep` sale con `1` cuando no encuentra nada: ya no quedan `TODO`. Si `grep` imprime líneas, borra esos comentarios: el TODO ya está hecho. La semana 03 explica los códigos de salida.

### Paso 8 — El inventario con `find`

Entra en el kit y genera la lista de archivos. `-type f` deja solo archivos (sin carpetas) y `>` la guarda en `docs/inventario.txt`:

```bash
cd starter
find . -type f > docs/inventario.txt
cat docs/inventario.txt
```

Algo como (el orden puede variar de una máquina a otra):

```text
./README.md
./scaffold.sh
./docs/mapa.txt
./docs/inventario.txt
./tests/.gitkeep
./bin/.gitkeep
./lib/.gitkeep
```

`docs/inventario.txt` aparece en su propia lista: `>` crea el archivo antes de que `find` empiece a recorrer el árbol. Si cambias archivos del kit, repite el comando: `>` reemplaza la lista entera.

### Paso 9 — README del kit

Busca lo que queda por completar:

```bash
grep -n TODO README.md
```

```text
3:TODO: en una frase, qué es bashkit y para qué lo construyes.
9:| `bin/` | TODO |
10:| `lib/` | TODO |
11:| `tests/` | TODO |
12:| `docs/` | TODO |
16:TODO: el comando que ejecuta scaffold.sh y qué crea.
20:- Semana 01: TODO: qué aprendiste y qué te costó.
```

Abre `starter/README.md` en tu editor y sustituye cada `TODO` con tus palabras: qué es el kit, para qué sirve cada carpeta (`docs/mapa.txt` te da pistas), cómo se ejecuta `scaffold.sh` y la bitácora de la semana. Repite el `grep` hasta que no imprima nada.

### Paso 10 — Autograding

```bash
cd "$(git rev-parse --show-toplevel)" && ./scripts/verificar-semana.sh 01
```

`git rev-parse --show-toplevel` imprime la raíz del repositorio, así que esa línea funciona estés donde estés. Con todo hecho:

```text
Semana 01 — Terminal y sistema de archivos

  ✅ bashkit tiene las carpetas bin, lib, tests y docs
  ✅ bin, lib y tests tienen un .gitkeep para que git las guarde
  ...
  ✅ README.md del kit sin TODOs y explica bin/, lib/, tests/ y docs/

15/15 comprobaciones superadas.
```

Cada ❌ trae una pista con el paso donde se arregla. Para salir del laboratorio: `exit`.

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 01` desde la raíz del repositorio (60 de los 100 puntos del Producto). Los otros 40 son de calidad: ver la [rúbrica](../rubrica-evaluacion.md#-producto-30).

- [ ] bashkit tiene las carpetas bin, lib, tests y docs
- [ ] bin, lib y tests tienen un .gitkeep para que git las guarde
- [ ] mapa.txt está en docs/ y ya no en la raíz del kit
- [ ] borrador-viejo.txt ya no existe
- [ ] scaffold.sh crea bashkit/ con bin, lib, tests y docs
- [ ] scaffold.sh deja un .gitkeep en bin, lib, tests y docs
- [ ] scaffold.sh escribe bashkit/README.md con el título # bashkit
- [ ] scaffold.sh no crea nada fuera de bashkit/
- [ ] scaffold.sh se puede ejecutar dos veces seguidas sin error
- [ ] scaffold.sh no borra lo que ya había en bashkit/
- [ ] scaffold.sh no tiene TODOs y pasa shellcheck
- [ ] docs/inventario.txt lista los archivos del kit con find
- [ ] docs/inventario.txt incluye scaffold.sh y docs/mapa.txt
- [ ] docs/inventario.txt solo tiene archivos, no carpetas
- [ ] README.md del kit sin TODOs y explica bin/, lib/, tests/ y docs/

## Calidad

Además de los checks, se revisa (40 pts, ver la rúbrica):

- `README.md` del kit claro: alguien que no te conoce entiende para qué es cada carpeta.
- `scaffold.sh` sin `rm` y con comentarios que explican el porqué (`-p`, `.gitkeep`), no el qué.
- Rutas relativas en `scaffold.sh`: funciona en cualquier carpeta y en cualquier máquina.
- `docs/inventario.txt` al día con los archivos reales del kit.

## Entrega

Commit desde tu copia del repositorio con el mensaje `feat(week-01): esqueleto de bashkit` que incluya `starter/` completo. git se enseña aparte; si todavía no lo usas, basta con que el autograding pase.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 07 — Buscar con find](../2-practicas/lab-07-buscar-con-find/README.md) | [Rúbrica de evaluación](../rubrica-evaluacion.md) → |

[↑ Semana 01](../README.md)
