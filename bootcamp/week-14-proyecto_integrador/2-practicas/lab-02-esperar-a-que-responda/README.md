# Lab 02 — Esperar a que PostgreSQL responda

⏱ Duración estimada: ~60 min

## Objetivo

Escribir un script que espera a que PostgreSQL acepte conexiones, preguntando con `pg_isready` cada segundo y rindiéndose con un aviso si no responde a tiempo.

## Contexto

- Un contenedor **arrancado** no es un servicio **listo**: PostgreSQL tarda unos segundos en aceptar conexiones. Un script que llega antes (la copia de las 03:00 justo después de reiniciar el servidor) falla aunque todo esté bien.
- `pg_isready` contesta con su código: 0 acepta conexiones, 1 rechaza (está arrancando), 2 no responde, 3 no lo intentó. Es lo mismo que pregunta el healthcheck de `compose.yaml`.
- `starter/wait-for-db.sh` tiene la estructura, pero aún no espera: dice que la base responde sin preguntar.

## Instrucciones

0. **En tu equipo**, comprueba que PostgreSQL está en marcha (lab 01) y entra al laboratorio:
   ```bash
   docker compose --profile db up -d --wait db
   docker compose run --rm lab
   ```
   **En el laboratorio**:
   ```bash
   cd bootcamp/week-14-proyecto_integrador/2-practicas/lab-02-esperar-a-que-responda
   ```
   (sin salida).

1. **Los códigos de pg_isready.** Pregunta al servidor de verdad, a uno que no existe y con una opción que no entiende. `-d` le pasa los datos de conexión como un texto (`host=db foo=bar`):
   ```bash
   pg_isready; echo $?
   PGHOST=no-existe pg_isready; echo $?
   pg_isready -d 'host=db foo=bar'; echo $?
   ```
   ```text
   db:5432 - accepting connections
   0
   no-existe:5432 - no response
   2
   pg_isready: error: invalid connection option "foo"
   3
   ```
   Con `-q` no escribe nada: solo cuenta el código, que es lo que necesita un `if` o un `until`.

2. **Para la base.** **En tu equipo**, en otra terminal (deja abierta la del laboratorio):
   ```bash
   docker compose stop db
   ```
   ```text
    Container bc-bash-db-1 Stopping
    Container bc-bash-db-1 Stopped
   ```
   **En el laboratorio**:
   ```bash
   pg_isready; echo $?
   ```
   ```text
   db:5432 - no response
   2
   ```

3. **El script, tal cual.** Con la base parada, ejecuta el starter:
   ```bash
   ./starter/wait-for-db.sh; echo $?
   ```
   ```text
   PostgreSQL responde después de 0 s
   0
   ```
   Miente: no ha preguntado. Lo que fuera detrás fallaría al conectar.

4. **TODO 1: esperar.** Abre `starter/wait-for-db.sh` en tu editor. `until comando; do ...; done` repite el cuerpo **mientras el comando falle** (al revés que `while`). Debajo de los TODO, escribe:
   ```bash
   until pg_isready -q; do
     sleep 1
   done
   ```
   No lo pruebes todavía con la base parada: esperaría para siempre. Ese es el problema del TODO 2.

5. **TODO 2: un límite.** `SECONDS` es una variable que bash va subiendo sola: los segundos desde que empezó el script. Dentro del `until`, antes del `sleep`:
   ```bash
     if ((SECONDS >= limit)); then
       echo "PostgreSQL no responde después de $limit s" >&2
       exit 1
     fi
   ```
   Pruébalo con la base parada y un límite de 3 segundos. `time` dice cuánto tardó:
   ```bash
   time ./starter/wait-for-db.sh 3; echo $?
   ```
   ```text
   PostgreSQL no responde después de 3 s

   real	0m2.243s
   user	0m0.045s
   sys	0m0.037s
   1
   ```
   Algo menos de 3 s, y no siempre lo mismo: `SECONDS` cuenta segundos enteros del reloj, y el primero puede llegar enseguida si el script empezó al final de un segundo. Para esperar a una base basta; para medir con precisión, no.

6. **La carrera.** **En el laboratorio**, lanza el script con un límite amplio:
   ```bash
   ./starter/wait-for-db.sh 60; echo $?
   ```
   Se queda esperando. **En tu equipo**, arranca la base sin `--wait` y pregunta enseguida a Docker por su healthcheck. `docker inspect` enseña los datos de un contenedor, y `--format` elige uno:
   ```bash
   docker compose start db
   docker inspect --format '{{.State.Health.Status}}' bc-bash-db-1
   ```
   ```text
    Container bc-bash-db-1 Starting
    Container bc-bash-db-1 Started
   starting
   ```
   `starting`: el contenedor corre, pero el healthcheck aún no ha dicho que esté sano. Unos segundos después, el script del laboratorio termina solo:
   ```text
   PostgreSQL responde después de 7 s
   0
   ```
   (los segundos cambian: los que tardaste en arrancarla, más los que tarda PostgreSQL). Y en tu equipo:
   ```bash
   docker inspect --format '{{.State.Health.Status}}' bc-bash-db-1
   ```
   ```text
   healthy
   ```

7. **Sin script: timeout.** `timeout` (semana 13) corta un comando a los N segundos con código 124. Con un `until` dentro de `bash -c`, es la espera en una línea:
   ```bash
   PGHOST=no-existe timeout 3 bash -c 'until pg_isready -q; do sleep 1; done'; echo $?
   ```
   ```text
   124
   ```
   Sirve para una línea suelta en un `Makefile` o en la CI. El script avisa en español y valida el argumento: mejor para algo que vas a reutilizar.

8. **shellcheck.**
   ```bash
   shellcheck starter/wait-for-db.sh && echo limpio
   ```
   ```text
   limpio
   ```

## Criterios de éxito

- `pg_isready` sale con 0 con la base en marcha, con 2 si no existe o está parada y con 3 con una opción mala (pasos 1 y 2).
- Con la base parada, `./starter/wait-for-db.sh 3` avisa en stderr y sale con 1 en unos 3 segundos (paso 5).
- `./starter/wait-for-db.sh 60` espera mientras la base arranca y sale con 0 cuando responde (paso 6).
- `docker inspect` dice `starting` justo después de arrancar y `healthy` cuando responde (paso 6).
- `shellcheck starter/wait-for-db.sh` no avisa (paso 8).

## Reto extra

En un `compose.yaml`, un servicio puede esperar al healthcheck de otro antes de arrancar:

```yaml
    depends_on:
      db:
        condition: service_healthy
```

Si el servicio que hace las copias llevara esas líneas, ¿podrías quitar `wait-for-db.sh`? Escribe la respuesta en una línea y compruébala con lo que viste en el paso 6. Pista: `depends_on` solo espera cuando **arranca** el servicio; si la base se reinicia de madrugada, la copia de las 03:00 no se entera.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 01 — PostgreSQL en Docker: arrancar, conectar y consultar](../lab-01-postgresql-en-docker/README.md) | [Lab 03 — pg_dump y pg_restore: copiar una base y comprobar la copia](../lab-03-pg-dump-y-pg-restore/README.md) → |

[↑ Semana 14](../../README.md)
