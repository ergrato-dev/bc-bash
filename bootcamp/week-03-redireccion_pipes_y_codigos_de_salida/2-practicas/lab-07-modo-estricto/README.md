# Lab 07 — Modo estricto: set -euo pipefail

⏱ Duración estimada: ~60 min

## Objetivo

Hacer que un script se pare en el primer error con `set -euo pipefail`, y depurar un script roto a propósito siguiendo el error que señala cada opción.

## Contexto

- Sin opciones, bash sigue ejecutando aunque un comando falle, aunque uses una variable que no existe y aunque falle la mitad de un pipe ([teoría](../../1-teoria/04-set-euo-pipefail.md)).
- `starter/archive-notes.sh` cuenta notas y registra una copia. Tiene **tres errores a propósito** y, sin modo estricto, termina con código `0` como si todo hubiera ido bien.
- Desde este lab, todos los scripts de `bashkit` empiezan con `set -euo pipefail`.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-03-redireccion_pipes_y_codigos_de_salida/2-practicas/lab-07-modo-estricto
   ```
   (sin salida).

1. **El script, sin tocar:**
   ```bash
   bash starter/archive-notes.sh
   echo $?
   ls
   ```
   ```text
   find: ‘zona/notas’: No such file or directory
   notas encontradas: 0
   starter/archive-notes.sh: line 14: cd: zona/archivo: No such file or directory
   copia registrada en /ultima-copia.txt
   0
   solucion  starter  ultima-copia.txt
   ```
   Tres errores y código `0`. `find` falló y el script contó 0 notas. `cd` falló y la copia se escribió en la carpeta del lab, no en `zona/archivo`. El mensaje final dice `/ultima-copia.txt` porque `$destno` está mal escrita y vale texto vacío. Borra la copia mal puesta:
   ```bash
   rm ultima-copia.txt
   ```

2. **`-e`: parar en el primer fallo.** `bash -e -c '...'` ejecuta el texto con esa opción activada:
   ```bash
   bash -c 'false; echo sigue'
   bash -e -c 'false; echo sigue'
   echo $?
   ```
   ```text
   sigue
   1
   ```
   Con `-e`, `false` falla y bash termina ahí, con su código.

3. **`-u`: parar con variables que no existen.**
   ```bash
   bash -c 'echo "[$nada]"'
   bash -u -c 'echo "[$nada]"'
   ```
   ```text
   []
   bash: line 1: nada: unbound variable
   ```
   Sin `-u`, una variable que no existe vale texto vacío y nadie se entera. Con `-u`, es un error (*unbound* = sin valor).

4. **`pipefail`: que el pipe falle si falla una parte.**
   ```bash
   bash -c 'ls /no-existe | wc -l; echo "código: $?"'
   bash -o pipefail -c 'ls /no-existe | wc -l; echo "código: $?"'
   ```
   ```text
   ls: cannot access '/no-existe': No such file or directory
   0
   código: 0
   ls: cannot access '/no-existe': No such file or directory
   0
   código: 2
   ```
   Sin `pipefail`, el código es el de `wc`, el último. Con `pipefail`, el del último comando que falló: el `2` de `ls`. Así `-e` también puede ver los fallos dentro de un pipe.

5. **TODO 1.** Abre `starter/archive-notes.sh` en tu editor y sustituye la línea del `TODO 1` por `set -euo pipefail`: las tres opciones en una línea. Prueba:
   ```bash
   bash starter/archive-notes.sh
   echo $?
   ```
   ```text
   find: ‘zona/notas’: No such file or directory
   1
   ```
   Para en la primera línea que falla. `pipefail` hizo que el `$(find ... | wc -l)` fallara y `-e` cortó ahí. Ese error no es del script: faltan los datos. Créalos:
   ```bash
   mkdir -p zona/notas
   touch zona/notas/lunes.txt zona/notas/martes.txt
   bash starter/archive-notes.sh
   echo $?
   ls
   ```
   ```text
   notas encontradas: 2
   starter/archive-notes.sh: line 14: cd: zona/archivo: No such file or directory
   1
   solucion  starter  zona
   ```
   Ahora cuenta bien y para en el `cd`. Esta vez no hay `ultima-copia.txt` en la carpeta del lab: `-e` impidió escribirla en el sitio equivocado.

6. **TODO 2.** Sustituye la línea del `TODO 2` por `mkdir -p "$destino"`, para que la carpeta exista antes del `cd`. Prueba:
   ```bash
   bash starter/archive-notes.sh
   echo $?
   ```
   ```text
   notas encontradas: 2
   starter/archive-notes.sh: line 18: destno: unbound variable
   1
   ```
   `-u` encontró la errata y dice la línea.

7. **TODO 3.** Corrige el nombre de la variable en la última línea y borra los comentarios `TODO`. Prueba:
   ```bash
   bash starter/archive-notes.sh
   echo $?
   cat zona/archivo/ultima-copia.txt
   ```
   Algo como (cambia la fecha):
   ```text
   notas encontradas: 2
   copia registrada en zona/archivo/ultima-copia.txt
   0
   2026-11-08
   ```
   El `0` ahora dice la verdad.

8. **Un límite que conviene conocer.** `-e` no actúa sobre los comandos que se usan para decidir:
   ```bash
   bash -e -c 'false && echo nunca; echo sigue'
   bash -e -c 'false || true; echo sigue'
   ```
   ```text
   sigue
   sigue
   ```
   El `false` de la izquierda de `&&` o `||` no para el script: bash entiende que lo estás comprobando tú. Por eso `bk-run` usa `|| status=$?` para guardar un fallo sin pararse. La semana 11 recorre el resto de casos en que `-e` no salta.

## Criterios de éxito

- [ ] Explicas por qué el script del paso 1 sale con `0` aunque fallaron tres cosas
- [ ] Explicas qué error detecta cada una de las tres opciones (pasos 2, 3 y 4)
- [ ] Explicas por qué con `-e` no apareció `ultima-copia.txt` en la carpeta del lab (paso 5)
- [ ] `bash starter/archive-notes.sh` imprime las dos líneas del paso 7 y sale con `0`

## Reto extra

Borra `zona/notas` (`rm -r zona/notas`) y ejecuta el script arreglado. Sale con `1` en el `find`. ¿Es lo correcto o debería decir "notas encontradas: 0"? Piensa qué preferirías leer en el log de un servidor y por qué.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 06 — Códigos de salida](../lab-06-codigos-de-salida/README.md) | [Proyecto — bk-run: ejecutar y dejar constancia](../../3-proyecto/README.md) → |

[↑ Semana 03](../../README.md)
