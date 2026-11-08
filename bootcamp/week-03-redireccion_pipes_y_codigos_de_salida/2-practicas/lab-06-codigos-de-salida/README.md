# Lab 06 — Códigos de salida

⏱ Duración estimada: ~60 min

## Objetivo

Leer el código de salida de cada comando con `$?` y usarlo para decidir qué se ejecuta después con `&&` y `||`.

## Contexto

- Todo comando termina con un número entre 0 y 255: `0` es "bien", cualquier otro es un fallo, y cada programa documenta qué significa cada uno ([teoría](../../1-teoria/03-codigos-de-salida.md)).
- `$?` guarda el código del **último** comando, y cada comando nuevo lo pisa.
- `starter/preflight.sh` comprueba, antes de desplegar, que el equipo tiene lo necesario. Cada fallo debe salir con su propio código.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-03-redireccion_pipes_y_codigos_de_salida/2-practicas/lab-06-codigos-de-salida
   mkdir zona
   ```
   (sin salida).

1. **Los dos comandos más simples:**
   ```bash
   true
   echo $?
   false
   echo $?
   ```
   ```text
   0
   1
   ```
   `true` y `false` no hacen nada: solo salen con `0` y con `1`. Sirven para probar.

2. **Códigos que ya conoces:**
   ```bash
   ls /no-existe
   echo $?
   echo 'echo hola' > zona/x.sh
   ./zona/x.sh
   echo $?
   comando-inventado
   echo $?
   ```
   ```text
   ls: cannot access '/no-existe': No such file or directory
   2
   bash: ./zona/x.sh: Permission denied
   126
   bash: comando-inventado: command not found
   127
   ```
   `2` es el código de `ls` para "no pude acceder". `126` y `127` los pone bash: "no se puede ejecutar" y "no existe" (semana 02).

3. **`$?` se pisa:**
   ```bash
   ls /no-existe 2> /dev/null
   echo $?
   echo $?
   ```
   ```text
   2
   0
   ```
   El segundo `echo $?` muestra el código del primer `echo`, que funcionó. Si necesitas el código más tarde, guárdalo antes en una variable: `codigo=$?`.

4. **Comandos que solo responden con el código.** `grep -q` busca un texto sin imprimir nada:
   ```bash
   grep -q alumno /etc/passwd
   echo $?
   grep -q nadie /etc/passwd
   echo $?
   grep -q alumno /no-existe
   echo $?
   ```
   ```text
   0
   1
   grep: /no-existe: No such file or directory
   2
   ```
   `grep` distingue tres casos: encontrado (`0`), no encontrado (`1`) y error (`2`). Lo dice `man grep`, en la sección *EXIT STATUS*.

5. **`test` pregunta sin imprimir:**
   ```bash
   test -f /etc/hostname
   echo $?
   test -d /etc/hostname
   echo $?
   ```
   ```text
   0
   1
   ```
   `-f` pregunta "¿es un archivo?" y `-d` "¿es una carpeta?". La respuesta es el código.

6. **`&&` y `||`:**
   ```bash
   mkdir zona/copias && echo "creada"
   mkdir zona/copias && echo "creada"
   mkdir zona/copias 2> /dev/null || echo "ya existía"
   ```
   ```text
   creada
   mkdir: cannot create directory ‘zona/copias’: File exists
   ya existía
   ```
   `a && b` ejecuta `b` solo si `a` sale con `0`. `a || b`, solo si `a` falla. La segunda vez `mkdir` falla y el `echo` no se ejecuta.

7. **Tú eliges el código:**
   ```bash
   bash -c 'exit 7'
   echo $?
   ```
   ```text
   7
   ```
   `exit N` termina el script con ese código. Sin `exit`, un script sale con el código de su último comando.

8. **El código de cada parte de un pipe.** `$?` solo da el del último; `PIPESTATUS` los guarda todos:
   ```bash
   ls /no-existe | wc -l
   echo "${PIPESTATUS[@]}"
   ```
   ```text
   ls: cannot access '/no-existe': No such file or directory
   0
   2 0
   ```
   `2` es el de `ls` y `0` el de `wc`. Tiene que ir justo detrás del pipe: el siguiente comando lo pisa, como a `$?`.

9. **El script, sin tocar:**
   ```bash
   bash starter/preflight.sh
   echo $?
   ```
   ```text
   0
   ```
   Solo comprueba `git`, que está en el laboratorio.

10. **TODO 1.** Abre `starter/preflight.sh` en tu editor. Copia la línea de `git` bajo el `TODO 1` y cámbiala para `docker`, con el mensaje `falta docker` y el código `4`. Prueba:
    ```bash
    bash starter/preflight.sh
    echo $?
    ```
    ```text
    falta docker
    4
    ```
    El laboratorio no tiene `docker` dentro. El `4` dice qué falló sin leer el mensaje.

11. **Un `docker` de pega para seguir.** Un script llamado `docker` en una carpeta al principio del `PATH` (semana 02) basta para que `command -v` lo encuentre:
    ```bash
    mkdir zona/bin
    printf '#!/usr/bin/env bash\necho "docker de pega"\n' > zona/bin/docker
    chmod +x zona/bin/docker
    PATH="$PWD/zona/bin:$PATH" bash starter/preflight.sh
    echo $?
    ```
    ```text
    0
    ```

12. **TODO 2 y TODO 3.** Bajo el `TODO 2`: `test -w /tmp` (¿puedes escribir en `/tmp`?) con `||` y el bloque `{ ...; }` que escribe `no se puede escribir en /tmp` en stderr y sale con `5`. Bajo el `TODO 3`: `echo "todo listo"` y `exit 0`. Borra los comentarios `TODO`. Prueba:
    ```bash
    PATH="$PWD/zona/bin:$PATH" bash starter/preflight.sh
    echo $?
    ```
    ```text
    todo listo
    0
    ```

13. **Encadenar el script:**
    ```bash
    bash starter/preflight.sh 2> /dev/null || echo "no se despliega"
    PATH="$PWD/zona/bin:$PATH" bash starter/preflight.sh > /dev/null && echo "a desplegar"
    ```
    ```text
    no se despliega
    a desplegar
    ```
    Tu script se comporta como cualquier comando: otros pueden decidir con su código.

## Criterios de éxito

- [ ] Explicas por qué el segundo `echo $?` del paso 3 imprime `0`
- [ ] Explicas los tres códigos de `grep` (paso 4)
- [ ] Explicas cuándo se ejecuta lo que hay detrás de `&&` y de `||` (paso 6)
- [ ] `bash starter/preflight.sh` sale con `4` sin el `docker` de pega, y con él imprime `todo listo` y sale con `0`

## Reto extra

Ejecuta `PATH=/nada bash starter/preflight.sh` y mira `$?`: `127`, y quien se queja es tu shell, no el script. ¿Por qué bash no encuentra `bash`? Ahora prueba `PATH=/nada /usr/bin/bash starter/preflight.sh`: ¿qué código sale y por qué el script no encuentra `git`?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 05 — Here-docs y here-strings](../lab-05-here-docs-y-here-strings/README.md) | [Lab 07 — Modo estricto: set -euo pipefail](../lab-07-modo-estricto/README.md) → |

[↑ Semana 03](../../README.md)
