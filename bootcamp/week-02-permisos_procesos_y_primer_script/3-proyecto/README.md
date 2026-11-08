# Proyecto Semana 02 — bk-info: la ficha del sistema

⏱ Duración estimada: ~3 h 30 min

## Contexto

Cuando entras en una máquina que no conoces (un servidor, un contenedor, el equipo de otra persona), lo primero es saber dónde estás: con qué usuario, en qué equipo, qué bash hay y dónde va a buscar los comandos. Esta semana escribes el primer comando de verdad de `bashkit`, **`bk-info`**, que lo imprime todo de un vistazo ([docs/proyecto-hilo-conductor.md](../../../docs/proyecto-hilo-conductor.md)).

`bk-info` no se ejecuta con `bash bk-info`: es un comando, con shebang, permiso de ejecución y sin extensión, que funciona por su nombre cuando `bin/` está en el `PATH`.

## Estructura del proyecto

`starter/` es el `bashkit` con el que terminaste la semana 01, más lo nuevo:

```text
starter/                   ← aquí trabajas (lo corrige el autograding)
├── README.md              ← nueva sección Comandos y bitácora de la semana 02 (TODOs)
├── scaffold.sh            ← pasará a ser ejecutable
├── bin/
│   ├── .gitkeep
│   └── bk-info            ← nuevo: sin shebang, sin permiso de ejecución (TODOs)
├── lib/.gitkeep
├── tests/.gitkeep
└── docs/
    ├── mapa.txt
    └── inventario.txt     ← hay que regenerarlo
```

## Lo que debes construir

1. `bin/bk-info` con el shebang `#!/usr/bin/env bash` y permisos `755`.
2. Al ejecutarlo, `bk-info` imprime la cabecera `== bashkit info ==` y seis líneas: `usuario:`, `grupos:`, `equipo:`, `home:`, `bash:` y `path:`. Los valores se leen al ejecutarse (comandos y variables de entorno), nunca se escriben a mano.
3. `bk-info` funciona por su nombre cuando `bin/` está en el `PATH`, sin TODOs y sin avisos de shellcheck.
4. `scaffold.sh` ejecutable: `./scaffold.sh` funciona.
5. `docs/inventario.txt` regenerado, con `./bin/bk-info`.
6. `README.md` sin TODOs: qué hace `bk-info` y la bitácora de la semana 02.

## Paso a paso

### Paso 0 — Entrar al laboratorio y a la carpeta del proyecto

Desde la raíz del repositorio, en tu equipo:

```bash
docker compose run --rm lab
cd bootcamp/week-02-permisos_procesos_y_primer_script/3-proyecto/starter
```

(sin salida). Todo el proyecto se hace desde esta carpeta, `starter/`.

### Paso 1 — Mirar los permisos

```bash
ls -l scaffold.sh bin/bk-info
./bin/bk-info
```

Algo como (cambian las fechas y los tamaños):

```text
-rw-r--r-- 1 alumno alumno  619 Nov  8 04:43 bin/bk-info
-rw-r--r-- 1 alumno alumno  805 Nov  8 04:43 scaffold.sh
bash: ./bin/bk-info: Permission denied
```

Ninguno de los dos tiene `x`. Con `bash` delante sí funciona, porque entonces el programa es bash y `bk-info` solo un archivo que lee:

```bash
bash bin/bk-info
```

```text
== bashkit info ==
sin implementar
```

### Paso 2 — TODO 1: el shebang

Abre `starter/bin/bk-info` en tu editor. La primera línea es el `TODO 1`: sustitúyela entera por el shebang de bashkit:

```text
#!/usr/bin/env bash
```

Tiene que quedar en la línea 1, sin nada delante. Guarda y comprueba que `bash bin/bk-info` sigue imprimiendo lo mismo que en el paso 1.

### Paso 3 — El bit de ejecución

`755` es `rwxr-xr-x`: tú lo puedes cambiar y ejecutar; el resto, ejecutarlo y leerlo.

```bash
chmod 755 bin/bk-info
ls -l bin/bk-info
./bin/bk-info
```

Algo como:

```text
-rwxr-xr-x 1 alumno alumno 572 Nov  8 04:54 bin/bk-info
== bashkit info ==
sin implementar
```

Ya es un comando. Desde aquí, prueba cada TODO con `./bin/bk-info`.

### Paso 4 — TODO 2: usuario y grupos

`$(comando)` pone en la línea lo que imprime el comando ([teoría](../1-teoria/03-scripts-y-shebang.md)). Bajo el `TODO 2`, dos líneas:

```bash
echo "usuario: $(id -un)"
echo "grupos: $(id -Gn)"
```

¿Por qué no `$USER`? Pruébalo: `echo "[$USER]"` imprime `[]` en el laboratorio. Esa variable la crea el programa de inicio de sesión de un sistema normal, y Docker no lo usa. `id` pregunta al sistema y funciona siempre.

Prueba con `./bin/bk-info`: bajo la cabecera aparecen `usuario: alumno` y `grupos: alumno`.

### Paso 5 — TODO 3: equipo y home

Bajo el `TODO 3`: una línea `equipo: ` con `$(hostname)` y otra `home: ` con la variable `$HOME`. Prueba: aparecen `equipo: bc-bash-lab` y `home: /home/alumno`.

No escribas `/home/alumno` a mano: en otra máquina, o para otro usuario, sería mentira. El autograding lo comprueba ejecutando `bk-info` con otro `HOME`.

### Paso 6 — TODO 4: bash y PATH

Bajo el `TODO 4`: una línea `bash: ` con `$BASH_VERSION` y otra `path: ` con `$PATH`. Borra `echo "sin implementar"` y los comentarios `TODO`. Prueba:

```bash
./bin/bk-info
```

```text
== bashkit info ==
usuario: alumno
grupos: alumno
equipo: bc-bash-lab
home: /home/alumno
bash: 5.2.21(1)-release
path: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

### Paso 7 — `bk-info` por su nombre

Añade `bin/` al principio del `PATH` con ruta absoluta y llama a `bk-info` sin ruta:

```bash
PATH="$PWD/bin:$PATH"
bk-info
type bk-info
```

```text
== bashkit info ==
usuario: alumno
grupos: alumno
equipo: bc-bash-lab
home: /home/alumno
bash: 5.2.21(1)-release
path: /bc-bash/bootcamp/week-02-permisos_procesos_y_primer_script/3-proyecto/starter/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
bk-info is hashed (/bc-bash/bootcamp/week-02-permisos_procesos_y_primer_script/3-proyecto/starter/bin/bk-info)
```

La línea `path:` muestra el `PATH` que recibió `bk-info`, ya con `bin/` al principio. Comprueba que lee el entorno al ejecutarse, dándole otro `HOME` solo a ese comando:

```bash
HOME=/tmp bk-info
```

La línea `home:` pasa a ser `home: /tmp`. Si `bk-info` tuviera la ruta escrita a mano, no cambiaría.

### Paso 8 — Calidad de `bk-info`

```bash
grep -n TODO bin/bk-info
shellcheck bin/bk-info
```

(sin salida los dos). `grep -n TODO` busca líneas con `TODO` y no debe encontrar ninguna; `shellcheck` revisa el script y no imprime nada si no tiene avisos. Si alguno habla, corrige la línea que indica.

### Paso 9 — `scaffold.sh` ejecutable

`scaffold.sh` ya tiene shebang desde la semana 01, pero no permiso:

```bash
./scaffold.sh
chmod 755 scaffold.sh
```

```text
bash: ./scaffold.sh: Permission denied
```

Pruébalo en una carpeta de pruebas, fuera de `starter/`, para que el `bashkit/` que crea no se mezcle con el kit. `zona/` está en `3-proyecto/` y git la ignora:

```bash
mkdir ../zona
cd ../zona
../starter/scaffold.sh
ls -A bashkit
cd ..
rm -r zona
cd starter
```

```text
bashkit/ creado
README.md  bin  docs  lib  tests
```

Abre `README.md` en tu editor y, en la sección *Recrear la estructura*, cambia `bash scaffold.sh` por `./scaffold.sh`.

### Paso 10 — El inventario al día

`bk-info` es un archivo nuevo del kit: regenera la lista como en la semana 01.

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
./bin/.gitkeep
./lib/.gitkeep
```

### Paso 11 — README del kit

```bash
grep -n TODO README.md
```

```text
22:| `bin/bk-info` | TODO: qué imprime y cuándo te sirve |
27:- Semana 02: TODO: qué aprendiste y qué te costó.
```

Abre `README.md` en tu editor y sustituye cada `TODO` con tus palabras: qué imprime `bk-info` y para qué te sirve, cómo ponerlo en el `PATH`, y la bitácora de la semana (la línea tiene que empezar por `- Semana 02:`). Repite el `grep` hasta que no imprima nada.

### Paso 12 — Autograding

```bash
cd "$(git rev-parse --show-toplevel)" && ./scripts/verificar-semana.sh 02
```

Con todo hecho:

```text
Semana 02 — Permisos, procesos y primer script

  ✅ bin/bk-info empieza por el shebang #!/usr/bin/env bash
  ✅ bin/bk-info tiene permisos 755 (rwxr-xr-x)
  ...
  ✅ README.md sin TODOs, documenta bk-info y tiene la bitácora de la semana 02

15/15 comprobaciones superadas.
```

Cada ❌ trae una pista con el paso donde se arregla. Para salir del laboratorio: `exit`.

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 02` desde la raíz del repositorio (60 de los 100 puntos del Producto). Los otros 40 son de calidad: ver la [rúbrica](../rubrica-evaluacion.md#-producto-30).

- [ ] bin/bk-info empieza por el shebang #!/usr/bin/env bash
- [ ] bin/bk-info tiene permisos 755 (rwxr-xr-x)
- [ ] bin/bk-info se ejecuta directamente e imprime la cabecera
- [ ] bk-info imprime la línea usuario: con tu nombre de usuario
- [ ] bk-info imprime la línea grupos: con todos tus grupos
- [ ] bk-info imprime la línea equipo: con el nombre del equipo
- [ ] bk-info lee el home de la variable HOME, no lo escribe a mano
- [ ] bk-info imprime la versión de bash con BASH_VERSION
- [ ] bk-info imprime el PATH que recibe al ejecutarse
- [ ] bk-info ya no imprime 'sin implementar'
- [ ] con bin/ en el PATH, bk-info funciona por su nombre, sin ruta
- [ ] bin/bk-info no tiene TODOs y shellcheck no da avisos
- [ ] scaffold.sh es ejecutable y crea bashkit/ con ./scaffold.sh
- [ ] docs/inventario.txt incluye ./bin/bk-info
- [ ] README.md sin TODOs, documenta bk-info y tiene la bitácora de la semana 02

## Calidad

Además de los checks, se revisa (40 pts, ver la rúbrica):

- Ningún valor escrito a mano en `bk-info`: todo sale de un comando o de una variable.
- Comentarios que explican el porqué (por qué `id` y no `USER`, por qué todavía no hay `set -euo pipefail`), no el qué.
- Comillas dobles alrededor de cada `"...$VAR..."` y `"...$(...)..."`.
- `README.md` del kit claro: alguien que no te conoce sabe qué hace `bk-info` y cómo ejecutarlo por su nombre.

## Entrega

Commit desde tu copia del repositorio con el mensaje `feat(week-02): bk-info` que incluya `starter/` completo. git guarda el permiso de ejecución: comprueba con `git diff` que aparece `new mode 100755` para `bin/bk-info` y `scaffold.sh`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 07 — PATH y variables de entorno](../2-practicas/lab-07-path-y-variables-de-entorno/README.md) | [Rúbrica de evaluación](../rubrica-evaluacion.md) → |

[↑ Semana 02](../README.md)
