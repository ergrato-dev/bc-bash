# Lab 02 — trap EXIT y mktemp

⏱ Duración estimada: ~60 min

## Objetivo

Crear los archivos de trabajo de un script en una carpeta temporal propia con `mktemp -d` y borrarla siempre al salir con `trap ... EXIT`.

## Contexto

- Muchos scripts necesitan archivos intermedios. Escribirlos en una ruta fija (`/tmp/mi-script`) trae tres problemas: se quedan ahí al terminar, dos ejecuciones a la vez se pisan, y si otro usuario crea antes esa carpeta, tu script no puede escribir.
- `mktemp` crea un archivo (o con `-d`, una carpeta) con un nombre que no existía y solo para ti, y escribe su ruta. `trap 'comandos' EXIT` deja apuntado qué hacer cuando el script termine, de la forma que sea.
- `starter/top-words.sh` cuenta las palabras más repetidas de un texto con dos archivos intermedios en `/tmp/top-words`. `datos/articulo.txt` es un texto corto para probarlo.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-11-scripts_robustos/2-practicas/lab-02-trap-exit-y-mktemp
   ```
   (sin salida).

1. **`mktemp`.**
   ```bash
   f=$(mktemp)
   echo "$f"
   ls -l "$f"
   d=$(mktemp -d)
   echo "$d"
   ls -ld "$d"
   rm -r "$f" "$d"
   ```
   Algo como (cambian los nombres y la fecha):
   ```text
   /tmp/tmp.WjAOAYOV3X
   -rw------- 1 alumno alumno 0 Nov  9 02:53 /tmp/tmp.WjAOAYOV3X
   /tmp/tmp.lwKSPQHquK
   drwx------ 2 alumno alumno 4096 Nov  9 02:53 /tmp/tmp.lwKSPQHquK
   ```
   Los diez caracteres del final son al azar. Los permisos son `rw-------` y `rwx------`: solo tú puedes leer y escribir ahí (semana 02). `ls -ld` enseña la carpeta misma y no lo que tiene dentro.

2. **`trap ... EXIT`.**
   ```bash
   bash -c 'trap "echo adiós" EXIT; echo hola'
   bash -c 'trap "echo adiós" EXIT; false; echo nunca'
   bash -c 'set -e; trap "echo adiós" EXIT; false; echo nunca'; echo $?
   ```
   ```text
   hola
   adiós
   nunca
   adiós
   adiós
   1
   ```
   El `adiós` sale siempre al final: cuando el script llega a la última línea y también cuando `set -e` lo para (la tercera). El código de salida sigue siendo el del fallo: el `trap` no lo cambia.

3. **Comillas dobles o simples.**
   ```bash
   bash -c 'x=antes; trap "echo dobles: $x" EXIT; x=después'
   bash -c "x=antes; trap 'echo simples: \$x' EXIT; x=después"
   ```
   ```text
   dobles: antes
   simples: después
   ```
   Con comillas dobles, bash pone el valor de `$x` al escribir el `trap`; con simples, lo lee al salir. Para borrar una carpeta da igual, porque no cambia, pero las simples son la costumbre: el `trap` usa lo que hay al final. (En la segunda línea, todo va entre dobles para poder usar simples dentro, y `\$` impide que el bash de fuera cambie el `$x`.)

4. **El script, tal cual.** Abre `starter/top-words.sh` en tu editor y ejecútalo:
   ```bash
   bash starter/top-words.sh datos/articulo.txt
   ls /tmp/top-words
   bash starter/top-words.sh datos/articulo.txt 3
   ```
   ```text
         7 script
         5 el
         4 un
         3 temporal
         3 que
   counts.txt
   words.txt
         7 script
         5 el
         4 un
   ```
   Funciona, pero `words.txt` y `counts.txt` se quedan en `/tmp/top-words` para siempre. Bórralos:
   ```bash
   rm -r /tmp/top-words
   ```
   (sin salida).

5. **TODO 1: una carpeta nueva cada vez.** Cambia el comentario del `TODO 1` y las dos líneas de debajo (`work=/tmp/top-words` y `mkdir -p "$work"`) por:
   ```bash
   work="$(mktemp -d)"
   ```
   `mktemp -d` ya crea la carpeta: el `mkdir` sobra. Para ver qué deja el script sin mirar todo `/tmp`, la variable `TMPDIR` le dice a `mktemp` dónde crear. Prueba:
   ```bash
   mkdir tmp
   TMPDIR=$PWD/tmp bash starter/top-words.sh datos/articulo.txt 2
   ls tmp
   ```
   Algo como (cambia el nombre):
   ```text
         7 script
         5 el
   tmp.CckH3JuEw2
   ```
   Ya no se pisa con nadie, pero sigue quedándose: una carpeta nueva en cada ejecución.

6. **TODO 2: borrarla al salir.** Cambia el comentario del `TODO 2` por:
   ```bash
   trap 'rm -rf -- "$work"' EXIT
   ```
   Justo debajo de `mktemp`, antes de nada que pueda fallar: si algo falla antes del `trap`, la carpeta se queda. `--` marca el final de las opciones de `rm` (semana 07). Explica en un comentario por qué la carpeta es nueva y por qué el `trap` va ahí. Prueba, también con un archivo que no existe:
   ```bash
   rm -r tmp/*
   TMPDIR=$PWD/tmp bash starter/top-words.sh datos/articulo.txt 2
   ls -A tmp
   TMPDIR=$PWD/tmp bash starter/top-words.sh no-existe.txt; echo $?
   ls -A tmp
   ```
   ```text
         7 script
         5 el
   grep: no-existe.txt: No such file or directory
   2
   ```
   Los dos `ls -A tmp` no imprimen nada (`-A` enseña también los archivos ocultos). Con `no-existe.txt`, `grep` falla, `set -e` para el script con el código de `grep` (2) y el `trap` borra la carpeta igualmente.

7. **shellcheck y limpieza.**
   ```bash
   rmdir tmp
   shellcheck starter/top-words.sh; echo $?
   ```
   ```text
   0
   ```
   `rmdir` borra una carpeta solo si está vacía: si falla, algo se ha quedado dentro.

## Criterios de éxito

- [ ] Explicas en qué se diferencian `mktemp` y `mktemp -d`, y de quién son los permisos de lo que crean (paso 1)
- [ ] Explicas por qué el `trap` con comillas dobles escribe `antes` (paso 3)
- [ ] Con `TMPDIR=$PWD/tmp`, `tmp/` queda vacía después de una ejecución que va bien y de una que falla (paso 6)
- [ ] `shellcheck starter/top-words.sh` no imprime nada

## Reto extra

Un `trap` nuevo para la misma señal reemplaza al anterior. Si un script necesita borrar dos cosas, ¿qué pasa con `trap 'rm -rf -- "$a"' EXIT` seguido de `trap 'rm -rf -- "$b"' EXIT`? Pruébalo, mira qué escribe `trap -p EXIT` y escribe una función `cleanup` que borre las dos.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 01 — Los límites de set -e](../lab-01-limites-de-set-e/README.md) | [Lab 03 — Señales: INT, TERM y KILL](../lab-03-senales-int-y-term/README.md) → |

[↑ Semana 11](../../README.md)
