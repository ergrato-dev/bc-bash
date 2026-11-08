# Lab 05 — Procesos y señales

⏱ Duración estimada: ~60 min

## Objetivo

Ver los procesos con `ps`, moverlos entre primer y segundo plano y pararlos con `Ctrl+C` y `kill`.

## Contexto

- Cada comando es un proceso con su PID y el PID de su padre (PPID) ([teoría](../../1-teoria/02-procesos-y-senales.md)).
- `sleep 300` no hace nada durante 300 segundos: es el proceso perfecto para practicar, porque no toca ningún archivo.
- Los PID de tus salidas serán otros: cada proceso recibe el siguiente número libre.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-02-permisos_procesos_y_primer_script/2-practicas/lab-05-procesos-y-senales
   ```

1. **Tus procesos:**
   ```bash
   echo $$
   ps
   ```
   Algo como:
   ```text
   1
       PID TTY          TIME CMD
         1 pts/0    00:00:00 bash
        14 pts/0    00:00:00 ps
   ```
   `$$` es el PID de tu bash. En el laboratorio es el `1`: es el primer proceso del contenedor. `ps` se ve a sí mismo, porque estaba en marcha mientras miraba.

2. **Segundo plano con `&`:**
   ```bash
   sleep 300 &
   ```
   Algo como:
   ```text
   [1] 15
   ```
   Tienes el prompt de vuelta enseguida. `[1]` es el número de trabajo y `15` el PID. Mira los dos:
   ```bash
   jobs
   ps -o pid,ppid,stat,comm
   ```
   Algo como:
   ```text
   [1]+  Running                 sleep 300 &
       PID    PPID STAT COMMAND
         1       0 Ss   bash
        15       1 S    sleep
        16       1 R+   ps
   ```
   `-o` elige las columnas. `sleep` y `ps` tienen `PPID 1`: son hijos de tu bash. `sleep` está en `S` (duerme) y `ps` en `R` (ejecutándose).

3. **`kill` con el número de trabajo:**
   ```bash
   kill %1
   ```
   (sin salida). Pulsa `Enter` una vez más y bash te avisa:
   ```text
   [1]+  Terminated              sleep 300
   ```
   `%1` es el trabajo 1. `kill` mandó `SIGTERM`, la petición de terminar.

4. **`Ctrl+Z`, `bg` y `fg`.** Lanza un `sleep` en primer plano: el prompt no vuelve.
   ```bash
   sleep 200
   ```
   Pulsa `Ctrl+Z`:
   ```text
   ^Z
   [1]+  Stopped                 sleep 200
   ```
   El proceso está detenido, no terminado. Reanúdalo en segundo plano y míralo:
   ```bash
   bg
   jobs
   ```
   ```text
   [1]+ sleep 200 &
   [1]+  Running                 sleep 200 &
   ```
   Tráelo a primer plano:
   ```bash
   fg
   ```
   ```text
   sleep 200
   ```
   El prompt vuelve a estar bloqueado.

5. **`Ctrl+C` y el código de salida.** Pulsa `Ctrl+C` y mira el código:
   ```bash
   echo $?
   ```
   ```text
   130
   ```
   `Ctrl+C` manda `SIGINT` (señal 2) al proceso de primer plano. El código es 128 + 2.

6. **`kill -9`, el último recurso:**
   ```bash
   sleep 100 &
   kill -9 %1
   jobs
   ```
   Algo como:
   ```text
   [1] 42
   [1]+  Killed                  sleep 100
   ```
   `Killed` en vez de `Terminated`: el sistema lo eliminó sin darle ocasión de limpiar nada.

7. **Errores de `kill`:**
   ```bash
   kill 99999
   ```
   ```text
   bash: kill: (99999) - No such process
   ```
   Sin proceso con ese PID. Si existiera y fuera de otro usuario, el error sería `Operation not permitted`.

8. **El script, sin tocar.** `starter/process-check.sh` lanza `sleep 30 &` y debería pararlo, pero aún no lo hace:
   ```bash
   bash starter/process-check.sh
   ```
   Algo como:
   ```text
   PID de este script: 14
   PID de sleep: 15
   == procesos antes de kill ==
   == procesos después de kill ==
   ```
   El script terminó, pero su `sleep` no:
   ```bash
   ps -o pid,ppid,stat,comm
   ```
   Algo como:
   ```text
       PID    PPID STAT COMMAND
         1       0 Ss   bash
        15       1 S    sleep
        16       1 R+   ps
   ```
   El `sleep` 15 sigue vivo y su padre ya es el `1`: al morir el script, quedó **huérfano** y lo adoptó tu bash. Terminará solo a los 30 segundos. Un script que deja procesos sueltos es un script con fugas.

9. **TODO 1.** Abre `starter/process-check.sh` en tu editor. Bajo `== procesos antes de kill ==`: `ps -o pid,ppid,stat,comm`. Prueba con `bash starter/process-check.sh`: en la lista aparecen el `bash` del script y su `sleep`, con el PID del script como PPID.

10. **TODO 2.** `kill "$!"`. `$!` guarda el PID del último proceso lanzado con `&`; las comillas evitan sorpresas si viniera vacío (semana 05).

11. **TODO 3.** `wait "$!"`. `wait` espera a que ese proceso termine de verdad: `kill` solo entrega la señal y no espera, así que sin `wait` el `ps` siguiente aún podría ver el `sleep`.

12. **TODO 4.** Bajo `== procesos después de kill ==`, otra vez `ps -o pid,ppid,stat,comm`. Borra los comentarios `TODO`. Prueba:
    ```bash
    bash starter/process-check.sh
    ```
    Algo como (los PID cambian; el `sleep` 15 es el huérfano del paso 8, si aún no han pasado sus 30 segundos):
    ```text
    PID de este script: 18
    PID de sleep: 19
    == procesos antes de kill ==
        PID    PPID STAT COMMAND
          1       0 Ss   bash
         15       1 S    sleep
         18       1 S+   bash
         19      18 S+   sleep
         20      18 R+   ps
    == procesos después de kill ==
        PID    PPID STAT COMMAND
          1       0 Ss   bash
         15       1 S    sleep
         18       1 S+   bash
         21      18 R+   ps
    ```
    El `sleep` 19, hijo del script (PPID 18), ya no está en el segundo bloque: el script limpia lo que lanza. El `+` de `STAT` indica que ese proceso está en primer plano en tu terminal.

## Criterios de éxito

- [ ] Explicas la diferencia entre número de trabajo (`%1`) y PID (paso 2)
- [ ] Usaste `Ctrl+Z`, `bg` y `fg` con el mismo proceso (paso 4)
- [ ] Explicas por qué `echo $?` da `130` tras `Ctrl+C` (paso 5)
- [ ] Explicas qué es el `sleep` huérfano del paso 8 y quién lo adoptó
- [ ] `bash starter/process-check.sh` imprime lo del paso 12, sin `sleep` en el segundo bloque

## Reto extra

Ejecuta `pstree -p` con un `sleep 300 &` en marcha. Después abre otro laboratorio en una segunda terminal: ¿ves el `sleep` del primero con `ps -e`? ¿Por qué? Pista: cada `docker compose run` es un contenedor distinto.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 04 — Propietarios y root](../lab-04-propietarios-y-root/README.md) | [Lab 06 — Shebang y bit de ejecución](../lab-06-shebang-y-bit-de-ejecucion/README.md) → |

[↑ Semana 02](../../README.md)
