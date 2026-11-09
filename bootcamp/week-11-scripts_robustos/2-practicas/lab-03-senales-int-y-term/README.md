# Lab 03 — Señales: INT, TERM y KILL

⏱ Duración estimada: ~60 min

## Objetivo

Atrapar `INT` y `TERM` con `trap` para que un script avise, limpie y salga con el código de cada señal, y ver por qué `KILL` no se puede atrapar.

## Contexto

- Una **señal** es un aviso que el sistema entrega a un proceso. `Ctrl-C` en la terminal manda `INT` (*interrupt*); `kill PID` manda `TERM` (*terminate*), que es lo que usan systemd, Docker o un `timeout` para parar un programa; `kill -KILL PID` (o `kill -9`) lo mata sin preguntar.
- Un proceso que muere por una señal sale con el código **128 + el número de la señal**: 130 por `INT` (2), 143 por `TERM` (15), 137 por `KILL` (9).
- `starter/wait-for-file.sh` espera a que aparezca un archivo, mirando cada segundo. Mientras espera, deja su PID en `wait-for-file.pid`, para que se sepa quién espera y se le pueda parar. Ese archivo tiene que desaparecer cuando el script termina, de la forma que sea.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-11-scripts_robustos/2-practicas/lab-03-senales-int-y-term
   ```
   (sin salida).

1. **Nombres y números.** `kill -l` traduce entre los dos:
   ```bash
   kill -l 2 15 9
   kill -l INT
   ```
   ```text
   INT
   TERM
   KILL
   2
   ```

2. **Códigos de salida.** Dentro de un `bash -c`, `sleep 30 &` corre de fondo, `$!` es su PID, y `wait $!` espera a que termine y sale con su código:
   ```bash
   bash -c 'sleep 30 & kill -TERM $!; wait $!; echo "código: $?"'
   bash -c 'sleep 30 & kill -KILL $!; wait $!; echo "código: $?"'
   ```
   Algo como (cambia el PID, `12`):
   ```text
   código: 143
   bash: line 1:    12 Killed                  sleep 30
   código: 137
   ```
   Con `KILL`, bash avisa de que su hijo murió (`Killed`). Con `TERM` no avisa: es la forma normal de parar un programa.

3. **Atrapar una señal.** `trap 'comandos' TERM` cambia lo que pasa al recibir `TERM`: en lugar de morir, el script ejecuta los comandos y sigue. `$$` es el PID del propio bash.
   ```bash
   bash -c 'trap "echo atrapada" TERM; kill -TERM $$; echo sigo'
   bash -c 'trap "echo atrapada" KILL; kill -KILL $$; echo sigo'; echo $?
   ```
   Algo como:
   ```text
   atrapada
   sigo
   bash: line 1:    15 Killed                  bash -c 'trap "echo atrapada" KILL; kill -KILL $$; echo sigo'
   137
   ```
   `KILL` no se puede atrapar: el `trap` no da error, pero el proceso muere igual, sin ejecutar nada. Por eso `kill -9` se deja para cuando lo demás falla.

4. **El script, tal cual.** Abre `starter/wait-for-file.sh` en tu editor.
   ```bash
   bash starter/wait-for-file.sh listo.txt 2; echo $?
   ls
   touch listo.txt
   bash starter/wait-for-file.sh listo.txt; echo $?
   rm listo.txt wait-for-file.pid
   ```
   ```text
   wait-for-file.sh: listo.txt no apareció en 2 s
   1
   README.md
   solucion
   starter
   wait-for-file.pid
   listo: listo.txt
   0
   ```
   El PID se queda en `wait-for-file.pid` incluso cuando todo va bien. Ahora, interrumpido. `timeout -s INT 2 comando` le manda `INT` al comando a los 2 segundos, como un `Ctrl-C`; con `--preserve-status`, `timeout` sale con el código del comando:
   ```bash
   timeout --preserve-status -s INT 2 bash starter/wait-for-file.sh listo.txt; echo $?
   cat wait-for-file.pid
   rm wait-for-file.pid
   ```
   Algo como (cambia el PID):
   ```text
   130
   21
   ```
   Salió con 130 y dejó un PID de un proceso que ya no existe.

5. **TODO 1: limpiar al salir.** Cambia el comentario del `TODO 1` por:
   ```bash
   trap 'rm -f -- "$pid_file"' EXIT
   ```
   Prueba los dos caminos:
   ```bash
   bash starter/wait-for-file.sh listo.txt 1; echo $?
   timeout --preserve-status -s INT 2 bash starter/wait-for-file.sh listo.txt; echo $?
   ls
   ```
   ```text
   wait-for-file.sh: listo.txt no apareció en 1 s
   1
   130
   README.md
   solucion
   starter
   ```
   Ya no queda el PID, tampoco con `INT`: en bash, `EXIT` corre también cuando una señal (que no sea `KILL`) termina el script. Para limpiar basta con `EXIT`. `trap ... INT` y `trap ... TERM` sirven para lo demás: avisar, terminar a medias de forma ordenada o elegir el código.

6. **TODO 2: avisar con `INT`.** Cambia el comentario del `TODO 2` por:
   ```bash
   trap 'echo "cancelado" >&2; exit 130' INT
   ```
   El `exit 130` es necesario: con un `trap` para `INT`, la señal ya no termina el script, y sin `exit` seguiría esperando. 130 es el código que espera quien lo lanzó. Prueba:
   ```bash
   timeout --preserve-status -s INT 2 bash starter/wait-for-file.sh listo.txt; echo $?
   ls
   ```
   ```text
   cancelado
   130
   README.md
   solucion
   starter
   ```

7. **TODO 3: avisar con `TERM`.** Cambia el comentario del `TODO 3` por:
   ```bash
   trap 'echo "parado" >&2; exit 143' TERM
   ```
   Explica en un comentario qué limpia el `EXIT` y por qué los `exit` de los otros dos `trap`. Para mandar `TERM` hace falta el PID: el script corre de fondo y se le para con el PID que dejó en el archivo.
   ```bash
   bash -c 'bash starter/wait-for-file.sh listo.txt & sleep 1.5; kill -TERM "$(cat wait-for-file.pid)"; wait $!; echo "código: $?"'
   ls
   ```
   ```text
   parado
   código: 143
   README.md
   solucion
   starter
   ```
   Si mandas `TERM` mientras el script está en `sleep 1`, bash espera a que termine ese `sleep` antes de ejecutar el `trap`: un script atiende las señales entre comando y comando.

8. **Con `KILL`.**
   ```bash
   bash -c 'bash starter/wait-for-file.sh listo.txt & sleep 1.5; kill -KILL "$(cat wait-for-file.pid)"; wait $!; echo "código: $?"'
   ls
   rm wait-for-file.pid
   ```
   Algo como:
   ```text
   bash: line 1:    28 Killed                  bash starter/wait-for-file.sh listo.txt
   código: 137
   README.md
   solucion
   starter
   wait-for-file.pid
   ```
   Ningún `trap` corre con `KILL`: el PID se queda. Un script que lee ese archivo no puede fiarse de que exista; tiene que comprobar si el proceso sigue vivo (`kill -0 PID` sale con 0 si existe). El lab 05 enseña una forma de bloquear que no tiene este problema.

9. **shellcheck.**
   ```bash
   shellcheck starter/wait-for-file.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas de dónde salen los códigos 130, 143 y 137
- [ ] Explicas por qué `trap ... KILL` no hizo nada en el paso 3
- [ ] Con `timeout --preserve-status -s INT 2`, el script escribe `cancelado`, sale con `130` y no deja `wait-for-file.pid` (paso 6)
- [ ] Con `kill -TERM`, escribe `parado` y sale con `143` (paso 7)
- [ ] `shellcheck starter/wait-for-file.sh` no imprime nada

## Reto extra

Lanza el script sin `timeout` (`bash starter/wait-for-file.sh listo.txt 30`) y pulsa `Ctrl-C`. ¿Qué escribe la terminal además de `cancelado`? Después, en otra terminal del laboratorio, deja un PID falso en el archivo (`echo 99999 > wait-for-file.pid`) y escribe una línea que diga si ese proceso existe con `kill -0`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 02 — trap EXIT y mktemp](../lab-02-trap-exit-y-mktemp/README.md) | [Lab 04 — Opciones con getopts](../lab-04-opciones-con-getopts/README.md) → |

[↑ Semana 11](../../README.md)
