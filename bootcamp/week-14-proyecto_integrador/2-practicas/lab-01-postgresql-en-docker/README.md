# Lab 01 — PostgreSQL en Docker: arrancar, conectar y consultar

⏱ Duración estimada: ~60 min

## Objetivo

Arrancar el PostgreSQL del laboratorio con su healthcheck, conectarte con `psql`, cargar los datos de una tienda y sacar de la base un resumen desde un script de bash.

## Contexto

- El servicio `db` de `compose.yaml` es un PostgreSQL 16 que solo arranca cuando lo pides (`--profile db`). Desde el laboratorio está en el host `db`, y las variables `PG*` ya dicen cómo conectarse.
- Esta semana usas **dos terminales**: una en tu equipo, en la raíz del repositorio, para los `docker compose`, y otra dentro del laboratorio para todo lo demás. Cada paso dice en cuál va.
- `datos/tienda.sql` crea dos tablas, `clientes` (5) y `pedidos` (12). Los labs siguientes la usan: si estropeas los datos, se recargan con el mismo comando del paso 3.

## Instrucciones

0. **En tu equipo**, desde la raíz del repositorio, arranca PostgreSQL. `--wait` no vuelve hasta que el healthcheck dice que acepta conexiones:
   ```bash
   docker compose --profile db up -d --wait db
   ```
   ```text
    Container bc-bash-db-1 Starting
    Container bc-bash-db-1 Started
    Container bc-bash-db-1 Waiting
    Container bc-bash-db-1 Healthy
   ```
   La primera vez sale algo más largo: Docker baja la imagen `postgres:16` y crea la red y el volumen (`Network bc-bash_default Created`, `Volume "bc-bash_pgdata" Created`). `docker compose ps db` enseña su estado:
   ```bash
   docker compose ps db
   ```
   ```text
   NAME           IMAGE         COMMAND                  SERVICE   CREATED         STATUS                   PORTS
   bc-bash-db-1   postgres:16   "docker-entrypoint.s…"   db        2 minutes ago   Up 2 seconds (healthy)   5432/tcp
   ```
   `(healthy)` es el resultado del healthcheck. Ahora, en la misma terminal o en otra, entra al laboratorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-14-proyecto_integrador/2-practicas/lab-01-postgresql-en-docker
   ```
   (sin salida).

1. **Las variables PG.** `psql`, `pg_dump` y `pg_restore` leen a qué conectarse de las variables que empiezan por `PG`. `env` las lista todas; `grep '^PG'` deja las que empiezan por `PG`:
   ```bash
   env | grep '^PG' | sort
   ```
   ```text
   PGDATABASE=bashkit
   PGHOST=db
   PGPASSWORD=bashkit
   PGUSER=bashkit
   ```
   `PGHOST=db`: dentro de la red de compose, el nombre del servicio es el nombre de la máquina.

2. **¿Responde?** `pg_isready` pregunta si el servidor acepta conexiones y lo dice con su código de salida (0 = sí):
   ```bash
   pg_isready; echo $?
   psql -Atc 'show server_version'
   ```
   ```text
   db:5432 - accepting connections
   0
   16.15 (Debian 16.15-1.pgdg13+2)
   ```
   `psql -c` ejecuta una consulta y sale. `-A` quita la alineación y `-t` la cabecera: queda solo el dato (el número exacto de versión puede cambiar, la mayor es 16).

3. **Cargar los datos.** `psql -f` ejecuta las órdenes de un archivo. `-q` no escribe un mensaje por orden, y `-v ON_ERROR_STOP=1` para al primer error (en el paso 6 verás por qué):
   ```bash
   psql -v ON_ERROR_STOP=1 -q -f datos/tienda.sql; echo $?
   psql -c '\dt'
   ```
   ```text
   0
             List of relations
    Schema |   Name   | Type  |  Owner
   --------+----------+-------+---------
    public | clientes | table | bashkit
    public | pedidos  | table | bashkit
   (2 rows)
   ```
   `\dt` es una orden de `psql` (no de SQL) que lista las tablas.

4. **Consultar.** Una consulta SQL con `select`; sin `-At`, `psql` dibuja una tabla para leerla tú:
   ```bash
   psql -c 'select * from clientes'
   ```
   ```text
    id |   nombre   |      ciudad
   ----+------------+------------------
     1 | Ana Torres | Madrid
     2 | Luis Pérez | Bogotá
     3 | Marta Ruiz | Lima
     4 | Jorge Díaz | Ciudad de México
     5 | Sofía León | Santiago
   (5 rows)
   ```

5. **Un dato para bash.** Para guardar un resultado en una variable, la tabla sobra. Compara:
   ```bash
   psql -c 'select count(*) from pedidos'
   n="$(psql -Atc 'select count(*) from pedidos')"
   echo "hay $n pedidos"
   ```
   ```text
    count
   -------
       12
   (1 row)

   hay 12 pedidos
   ```

6. **psql -f no para solo.** `datos/con-error.sql` tiene tres `INSERT` y el segundo está mal escrito (`INSER`). Ejecútalo sin `ON_ERROR_STOP` y mira el código:
   ```bash
   psql -f datos/con-error.sql; echo $?
   psql -Atc 'select id, nombre from clientes where id > 5'
   ```
   ```text
   INSERT 0 1
   psql:datos/con-error.sql:3: ERROR:  syntax error at or near "INSER"
   LINE 1: INSER INTO clientes VALUES (7, 'Eva Mora', 'Montevideo');
           ^
   INSERT 0 1
   0
   6|Pablo Gil
   8|Raúl Soto
   ```
   Falló una orden, siguió con la siguiente y **salió con 0**: un script con `set -e` no se enteraría. Recarga los datos y repítelo con `ON_ERROR_STOP=1`:
   ```bash
   psql -v ON_ERROR_STOP=1 -q -f datos/tienda.sql
   psql -v ON_ERROR_STOP=1 -f datos/con-error.sql; echo $?
   psql -Atc 'select id, nombre from clientes where id > 5'
   ```
   ```text
   INSERT 0 1
   psql:datos/con-error.sql:3: ERROR:  syntax error at or near "INSER"
   LINE 1: INSER INTO clientes VALUES (7, 'Eva Mora', 'Montevideo');
           ^
   3
   6|Pablo Gil
   ```
   Para en el error y sale con 3. Vuelve a dejar la tienda como estaba:
   ```bash
   psql -v ON_ERROR_STOP=1 -q -f datos/tienda.sql
   ```
   (sin salida).

7. **El script, tal cual.** `starter/orders-by-client.sh` tiene que escribir, para cada cliente, cuántos pedidos tiene y cuánto suman. Ejecútalo:
   ```bash
   ./starter/orders-by-client.sh; echo $?
   ```
   ```text
   pedidos     total  cliente
   sin implementar
   1
   ```

8. **TODO 1: avisar si no responde.** Abre `starter/orders-by-client.sh` en tu editor. Debajo del TODO 1, si `pg_isready -q` falla, escribe en stderr cómo arrancar PostgreSQL y sal con 1:
   ```bash
   if ! pg_isready -q; then
     echo "PostgreSQL no responde: arráncalo con 'docker compose --profile db up -d --wait db'" >&2
     exit 1
   fi
   ```
   Pruébalo apuntando a una máquina que no existe (la variable cambia solo para ese comando):
   ```bash
   PGHOST=no-existe ./starter/orders-by-client.sh; echo $?
   ```
   ```text
   PostgreSQL no responde: arráncalo con 'docker compose --profile db up -d --wait db'
   1
   ```

9. **TODO 2: la consulta.** Borra las dos líneas del final (`echo "sin implementar"` y `exit 1`) y, debajo del TODO 2, pide los datos con un **tabulador** entre columnas (`-F $'\t'`) y léelos con `read`. Un nombre con espacios no se parte: el separador es el tabulador, no el espacio:
   ```bash
   psql -v ON_ERROR_STOP=1 -At -F $'\t' -c "
     select c.nombre, count(p.id), coalesce(sum(p.total), 0)
     from clientes c left join pedidos p on p.cliente_id = c.id
     group by c.nombre order by 3 desc" |
     while IFS=$'\t' read -r name orders total; do
       printf '%7s %9s  %s\n' "$orders" "$total" "$name"
     done
   ```
   `left join` cuenta también a los clientes sin pedidos, y `coalesce(..., 0)` pone 0 donde la suma saldría vacía. Pruébalo:
   ```bash
   ./starter/orders-by-client.sh; echo $?
   ```
   ```text
   pedidos     total  cliente
         1    230.00  Sofía León
         3    179.20  Luis Pérez
         2    119.40  Marta Ruiz
         2    115.74  Jorge Díaz
         4     94.79  Ana Torres
   0
   ```
   El nombre va al final a propósito: `printf` mide los anchos en bytes, una letra con tilde ocupa dos, y en una columna del medio los nombres con tildes descuadrarían la tabla.

10. **Los datos sobreviven.** **En tu equipo**, reinicia el contenedor de PostgreSQL:
    ```bash
    docker compose restart db
    ```
    ```text
     Container bc-bash-db-1 Restarting
     Container bc-bash-db-1 Started
    ```
    **En el laboratorio**, cuando haya vuelto:
    ```bash
    pg_isready; psql -Atc 'select count(*) from pedidos'
    ```
    ```text
    db:5432 - accepting connections
    12
    ```
    Los datos viven en el volumen `pgdata`, no en el contenedor. Solo `docker compose down -v` los borraría.

## Criterios de éxito

- `pg_isready` dice `accepting connections` y sale con 0 (paso 2).
- `psql -Atc 'select count(*) from pedidos'` imprime `12` (paso 5).
- `psql -f datos/con-error.sql` sale con 0 y con `-v ON_ERROR_STOP=1` sale con 3 (paso 6).
- `PGHOST=no-existe ./starter/orders-by-client.sh` avisa en stderr y sale con 1 (paso 8).
- `./starter/orders-by-client.sh` imprime la tabla de 5 clientes, de Sofía León a Ana Torres, y sale con 0 (paso 9).
- Después de `docker compose restart db` sigue habiendo 12 pedidos (paso 10).

## Reto extra

Añade a `orders-by-client.sh` una opción: con un nombre de ciudad como argumento (`./starter/orders-by-client.sh Lima`), solo los clientes de esa ciudad. No metas el argumento dentro del texto de la consulta: un nombre con una comilla la rompería. `psql -v ciudad="$1"` define una variable de `psql`, y en la consulta se usa como `:'ciudad'`, que `psql` escribe ya entre comillas. Ojo: las variables `:'...'` no funcionan con `-c`; pasa la consulta por la entrada estándar (`psql ... <<'SQL'`).

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Índice de labs](../README.md) | [Lab 02 — Esperar a que PostgreSQL responda](../lab-02-esperar-a-que-responda/README.md) → |

[↑ Semana 14](../../README.md)
