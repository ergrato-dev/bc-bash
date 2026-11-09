# Lab 01 — Los límites de set -e

⏱ Duración estimada: ~60 min

## Objetivo

Encontrar los tres sitios donde `set -e` no para un script que falla (o lo para sin avisar) y arreglarlos.

## Contexto

- `set -e` para el script cuando un comando sale con un código distinto de 0. Pero hay excepciones escritas en el manual, y un script que confía en `set -e` sin conocerlas da por bueno lo que falló.
- `starter/backup-notes.sh` copia los `.txt` de una carpeta a otra, cuenta cuántos copió y sale con `1` si alguno falló. Está **roto a propósito**: tiene tres fallos, uno por cada excepción de este lab.
- `datos/notas/` tiene tres notas: `compras.txt`, `ideas.txt` y `viaje.txt`.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-11-scripts_robustos/2-practicas/lab-01-limites-de-set-e
   ```
   (sin salida).

1. **Lo que sí hace.** `bash -c '...'` ejecuta el texto entre comillas en un bash nuevo: así cada prueba empieza limpia.
   ```bash
   bash -c 'set -e; false; echo nunca'; echo $?
   ```
   ```text
   1
   ```
   `false` es un comando que solo sale con `1`. `set -e` para ahí, y `echo nunca` no llega a correr.

2. **Excepción 1: una función llamada desde un `if`, un `||` o un `&&`.**
   ```bash
   bash -c 'set -e; f() { false; echo "sigo dentro de f"; }; f || echo "f falló"; echo fin'; echo $?
   bash -c 'set -e; f() { false; echo "sigo dentro de f"; }; f; echo fin'; echo $?
   ```
   ```text
   sigo dentro de f
   fin
   0
   1
   ```
   Cuando el código de un comando lo va a mirar alguien (un `if`, un `||`, un `&&`, un `while`), bash desactiva `set -e` para ese comando **y para todo lo que hay dentro**. El `false` de dentro de `f` no la para, el `echo` corre, y `f` devuelve el código del `echo`: 0. El `f falló` nunca sale. En la segunda línea, `f` va sola, `set -e` sí la vigila y para en el `false`.

3. **Excepción 2: `((n++))` con `n` en 0.**
   ```bash
   bash -c 'set -e; n=0; ((n++)); echo "n vale $n"'; echo $?
   bash -c 'set -e; n=0; n=$((n + 1)); echo "n vale $n"'; echo $?
   ```
   ```text
   1
   n vale 1
   0
   ```
   Esta va al revés: para el script cuando no hay ningún error. `(( ))` sale con `1` si la cuenta da 0, y `n++` da el valor de antes de sumar: 0. `n=$((n + 1))` es una asignación, y sale con 0.

4. **Excepción 3: `local x=$(...)`.**
   ```bash
   bash -c 'set -e; f() { local x=$(false); echo "local devolvió $?"; }; f'
   bash -c 'set -e; f() { local x; x=$(false); echo nunca; }; f'; echo $?
   ```
   ```text
   local devolvió 0
   1
   ```
   En `local x=$(false)`, el código que mira `set -e` es el de `local`, que siempre sale bien: el fallo de dentro se pierde. Con la variable declarada en una línea y asignada en otra, la asignación sale con el código de `$(...)`. Pasa lo mismo con `export` y `declare`.

5. **De propina: `&&` en mitad de una línea.**
   ```bash
   bash -c 'set -e; false && echo nunca; echo "sigo después del &&"'; echo $?
   ```
   ```text
   sigo después del &&
   0
   ```
   Lo de la izquierda de un `&&` es una condición (paso 2). Si falla, el `&&` no sigue, pero el script tampoco para.

6. **El script, tal cual.** Abre `starter/backup-notes.sh` en tu editor. Crea la carpeta de destino y ejecútalo:
   ```bash
   mkdir copias
   bash starter/backup-notes.sh datos/notas copias; echo $?
   ls copias
   ```
   ```text
   copiado: compras.txt
   1
   compras.txt
   ```
   Copió una nota y salió con `1` sin decir por qué. Es la excepción del paso 3: el primer `((count++))`.

7. **Arreglo 1.** Cambia `((count++))` por `count=$((count + 1))` y `((failed++))` por `failed=$((failed + 1))`. Prueba:
   ```bash
   rm copias/*
   bash starter/backup-notes.sh datos/notas copias; echo $?
   ```
   ```text
   copiado: compras.txt
   copiado: ideas.txt
   copiado: viaje.txt
   total: 3 copiados, 0 fallos
   0
   ```

8. **Un archivo que no se puede copiar.** Deja en `copias/` un `ideas.txt` sin permiso de escritura (`chmod 444`: solo lectura para todos, semana 02):
   ```bash
   rm copias/*
   touch copias/ideas.txt
   chmod 444 copias/ideas.txt
   bash starter/backup-notes.sh datos/notas copias; echo $?
   ```
   ```text
   copiado: compras.txt
   cp: cannot create regular file 'copias/ideas.txt': Permission denied
   copiado: ideas.txt
   copiado: viaje.txt
   total: 3 copiados, 0 fallos
   0
   ```
   `cp` falló y el script dice `copiado: ideas.txt` y sale con `0`. Es el paso 2: `copy_one` se llama desde un `if`.

9. **Arreglo 2.** En `copy_one`, añade `|| return` al final de la línea del `cp`. `return` sin número devuelve el código del último comando, el del `cp`. Prueba:
   ```bash
   bash starter/backup-notes.sh datos/notas copias; echo $?
   ```
   ```text
   copiado: compras.txt
   cp: cannot create regular file 'copias/ideas.txt': Permission denied
   no se pudo copiar: datos/notas/ideas.txt
   copiado: viaje.txt
   total: 2 copiados, 1 fallos
   1
   ```

10. **Un origen mal escrito.**
    ```bash
    bash starter/backup-notes.sh datos/nootas copias; echo $?
    ```
    ```text
    find: ‘datos/nootas’: No such file or directory
    no hay notas en datos/nootas
    0
    ```
    Una carpeta que no existe no es "no hay notas": un cron vería un `0` y nadie se enteraría. Es el paso 4: `local n=$(find ...)`.

11. **Arreglo 3.** En `check_src`, separa la línea en dos: `local n` y debajo `n=$(find "$src" -maxdepth 1 -name '*.txt' | wc -l)`. Con `pipefail`, el error de `find` es el del pipe entero. Prueba:
    ```bash
    bash starter/backup-notes.sh datos/nootas copias; echo $?
    chmod 644 copias/ideas.txt
    bash starter/backup-notes.sh datos/notas copias; echo $?
    ```
    ```text
    find: ‘datos/nootas’: No such file or directory
    1
    copiado: compras.txt
    copiado: ideas.txt
    copiado: viaje.txt
    total: 3 copiados, 0 fallos
    0
    ```
    Con `chmod 644`, `ideas.txt` vuelve a tener permiso de escritura (para ti) y se copia.

12. **Comentarios y shellcheck.** Explica en un comentario encima de cada arreglo por qué está escrito así. Después:
    ```bash
    shellcheck starter/backup-notes.sh; echo $?
    rm -r copias
    ```
    ```text
    0
    ```
    Antes del arreglo 3, shellcheck ya avisaba del `local n=$(...)` con `SC2155`: "Declare and assign separately to avoid masking return values".

## Criterios de éxito

- [ ] Explicas por qué `f || echo "f falló"` no escribe `f falló` en el paso 2
- [ ] Explicas por qué `((n++))` para el script en el paso 3 y `n=$((n + 1))` no
- [ ] `bash starter/backup-notes.sh datos/notas copias` con `ideas.txt` en solo lectura escribe `total: 2 copiados, 1 fallos` y sale con `1` (paso 9)
- [ ] `bash starter/backup-notes.sh datos/nootas copias` sale con `1` (paso 11)
- [ ] `shellcheck starter/backup-notes.sh` no imprime nada

## Reto extra

`set -e` tampoco se hereda dentro de `$(...)`: prueba `bash -c 'set -e; x=$(false; echo "dentro sigo"); echo "x=$x"'`. Después busca `inherit_errexit` en `man bash` (con `/inherit_errexit`) y prueba lo mismo con `shopt -s inherit_errexit;` delante. ¿Qué cambia?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Índice de labs](../README.md) | [Lab 02 — trap EXIT y mktemp](../lab-02-trap-exit-y-mktemp/README.md) → |

[↑ Semana 11](../../README.md)
