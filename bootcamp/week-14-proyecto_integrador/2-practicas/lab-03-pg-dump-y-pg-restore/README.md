# Lab 03 — pg_dump y pg_restore: copiar una base y comprobar la copia

⏱ Duración estimada: ~60 min

## Objetivo

Copiar la base de la tienda con `pg_dump` en los dos formatos, restaurarla en una base nueva con `pg_restore` y `psql`, y comprobar con un script que la copia tiene las mismas filas que la original.

## Contexto

- `pg_dump` escribe las órdenes que vuelven a crear la base: en texto (`.sql`, se lee con `less`) o en formato custom (`-Fc`, comprimido y con índice). Mientras copia, la base sigue funcionando.
- Restaurar en una base **nueva** es la forma segura de mirar una copia: no tocas la de verdad. `createdb` crea una base vacía y `dropdb` la borra.
- `starter/compare-dbs.sh` compara cuántas filas tiene cada tabla en dos bases, pero aún no compara nada.

## Instrucciones

0. Con PostgreSQL en marcha (lab 01), entra al laboratorio y ve a la carpeta del lab. Recarga la tienda por si la cambiaste:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-14-proyecto_integrador/2-practicas/lab-03-pg-dump-y-pg-restore
   psql -v ON_ERROR_STOP=1 -q -f ../lab-01-postgresql-en-docker/datos/tienda.sql
   ```
   (sin salida).

1. **Una copia en texto.** Sin `-F`, `pg_dump` escribe SQL. `-f` dice en qué archivo (sin él, en la pantalla). Mira qué órdenes contiene:
   ```bash
   pg_dump -f copia.sql; echo $?
   grep -n -E '^(CREATE TABLE|COPY|ALTER TABLE)' copia.sql
   ```
   ```text
   0
   29:CREATE TABLE public.clientes (
   36:ALTER TABLE public.clientes OWNER TO bashkit;
   42:CREATE TABLE public.pedidos (
   50:ALTER TABLE public.pedidos OWNER TO bashkit;
   56:COPY public.clientes (id, nombre, ciudad) FROM stdin;
   69:COPY public.pedidos (id, cliente_id, fecha, total) FROM stdin;
   89:ALTER TABLE ONLY public.clientes
   97:ALTER TABLE ONLY public.pedidos
   105:ALTER TABLE ONLY public.pedidos
   ```
   Primero crea las tablas, después copia los datos (`COPY`) y al final añade las claves (`ALTER TABLE ... ADD CONSTRAINT`): así cargar los datos es más rápido. Los datos van en texto, una fila por línea, hasta una línea con `\.`:
   ```bash
   sed -n '/^COPY public.clientes/,/^\\\./p' copia.sql
   ```
   ```text
   COPY public.clientes (id, nombre, ciudad) FROM stdin;
   1	Ana Torres	Madrid
   2	Luis Pérez	Bogotá
   3	Marta Ruiz	Lima
   4	Jorge Díaz	Ciudad de México
   5	Sofía León	Santiago
   \.
   ```

2. **Una copia en formato custom.** `-Fc` escribe un archivo binario que empieza por `PGDMP`. `head -c 5` enseña sus 5 primeros bytes:
   ```bash
   pg_dump -Fc -f copia.dump
   head -c 5 copia.dump; echo
   ls -l copia.sql copia.dump
   ```
   ```text
   PGDMP
   -rw-r--r-- 1 alumno alumno 3114 Nov 10 21:01 copia.dump
   -rw-r--r-- 1 alumno alumno 2512 Nov 10 21:01 copia.sql
   ```
   (la fecha cambia). Con 17 filas, el custom ocupa **más**: el índice y la cabecera pesan más de lo que ahorra comprimir. Con 372 pedidos ya son 3946 bytes frente a 11 404, y con una base de verdad la diferencia es enorme.

3. **El índice.** `pg_restore -l` lee el índice de una copia custom sin tocar ninguna base. Las líneas con `;` son comentarios:
   ```bash
   pg_restore -l copia.dump
   ```
   ```text
   ;
   ; Archive created at 2026-11-10 21:01:58 UTC
   ;     dbname: bashkit
   ;     TOC Entries: 11
   ;     Compression: gzip
   ;     Dump Version: 1.15-0
   ;     Format: CUSTOM
   ;     Integer: 4 bytes
   ;     Offset: 8 bytes
   ;     Dumped from database version: 16.15 (Debian 16.15-1.pgdg13+2)
   ;     Dumped by pg_dump version: 16.15 (Ubuntu 16.15-0ubuntu0.24.04.1)
   ;
   ;
   ; Selected TOC Entries:
   ;
   215; 1259 16440 TABLE public clientes bashkit
   216; 1259 16447 TABLE public pedidos bashkit
   3418; 0 16440 TABLE DATA public clientes bashkit
   3419; 0 16447 TABLE DATA public pedidos bashkit
   3271; 2606 16446 CONSTRAINT public clientes clientes_pkey bashkit
   3273; 2606 16451 CONSTRAINT public pedidos pedidos_pkey bashkit
   3274; 2606 16452 FK CONSTRAINT public pedidos pedidos_cliente_id_fkey bashkit
   ```
   (los números y la fecha cambian). Si `pg_restore -l` falla, el archivo no es una copia custom o está cortado: es la comprobación que hará `bk-restore` antes de tocar nada.

4. **pg_restore necesita un destino.** Sin `-d` (una base) ni `-f` (un archivo), avisa y no hace nada:
   ```bash
   pg_restore copia.dump; echo $?
   ```
   ```text
   pg_restore: error: one of -d/--dbname and -f/--file must be specified
   1
   ```
   Con `-f -` escribe el SQL en la pantalla (`-` = stdout): es el mismo contenido que `copia.sql`.
   ```bash
   pg_restore -f - copia.dump | grep -E '^(CREATE TABLE|COPY)'
   ```
   ```text
   CREATE TABLE public.clientes (
   CREATE TABLE public.pedidos (
   COPY public.clientes (id, nombre, ciudad) FROM stdin;
   COPY public.pedidos (id, cliente_id, fecha, total) FROM stdin;
   ```

5. **Restaurar en una base nueva.** `createdb prueba` crea una base vacía; `pg_restore -d prueba` restaura en ella. `psql -d prueba` consulta esa base en lugar de la de `PGDATABASE`:
   ```bash
   createdb prueba; echo $?
   pg_restore -d prueba copia.dump; echo $?
   psql -d prueba -Atc 'select count(*) from pedidos'
   ```
   ```text
   0
   0
   12
   ```
   Si la base ya existe, `createdb` falla (no la pisa):
   ```bash
   createdb prueba; echo $?
   ```
   ```text
   createdb: error: database creation failed: ERROR:  database "prueba" already exists
   1
   ```

6. **Restaurar la copia en texto.** Una copia `.sql` se restaura con `psql -f`, con `ON_ERROR_STOP` (lab 01). `> /dev/null` tira lo que escriben las órdenes al ejecutarse:
   ```bash
   createdb desde_sql
   psql -d desde_sql -v ON_ERROR_STOP=1 -q -f copia.sql > /dev/null; echo $?
   psql -d desde_sql -Atc 'select count(*) from clientes'
   psql -Atc 'select datname from pg_database order by 1'
   ```
   ```text
   0
   5
   bashkit
   desde_sql
   postgres
   prueba
   template0
   template1
   ```
   `pg_database` es la lista de bases del servidor. `postgres`, `template0` y `template1` las crea PostgreSQL.

7. **El script, tal cual.** Crea una base vacía y compárala con la tienda usando el starter:
   ```bash
   createdb vacia
   ./starter/compare-dbs.sh bashkit vacia; echo $?
   ```
   ```text
   iguales
   0
   ```
   Miente: una base vacía no es igual que la tienda. Un comprobador que siempre dice "bien" es peor que no tener ninguno.

8. **TODO 1: contar las filas.** Abre `starter/compare-dbs.sh` en tu editor. En `row_counts`, borra el `:` y escribe, debajo del TODO 1:
   ```bash
   psql -d "$db" -v ON_ERROR_STOP=1 -Atc \
     "select tablename from pg_tables where schemaname = 'public' order by 1" |
     while read -r table; do
       printf '%s %s\n' "$table" "$(psql -d "$db" -Atc "select count(*) from \"$table\"" < /dev/null)"
     done
   ```
   `pg_tables` es la lista de tablas; `public` es donde están las tuyas. El `< /dev/null` del segundo `psql` es para que no se coma las líneas del pipe, que son para `read` (el mismo problema que `ssh` dentro de un `while`). Pruébalo sin esperar al TODO 2: `bash -c` abre otra shell, `source` carga en ella el script (con los argumentos `bashkit vacia`, para que pase la comprobación de `$#`) y a partir de ahí `row_counts` existe y se puede llamar:
   ```bash
   bash -c 'source starter/compare-dbs.sh bashkit vacia > /dev/null; row_counts bashkit'
   ```
   ```text
   clientes 5
   pedidos 12
   ```

9. **TODO 2: comparar.** `diff` compara dos archivos; con `<( )` (semana 13), la salida de cada comando hace de archivo. `diff` sale con 0 si son iguales y con 1 si no, y antes enseña las diferencias. Cambia la línea `echo "iguales"` del final por:
   ```bash
   if diff <(row_counts "$1") <(row_counts "$2"); then
     echo "iguales"
   else
     exit 1
   fi
   ```
   Pruébalo con la copia restaurada, con la base vacía y con una copia a la que le faltan filas:
   ```bash
   ./starter/compare-dbs.sh bashkit prueba; echo $?
   ./starter/compare-dbs.sh bashkit vacia; echo $?
   psql -d prueba -qc 'delete from pedidos where cliente_id = 1'
   ./starter/compare-dbs.sh bashkit prueba; echo $?
   ```
   ```text
   iguales
   0
   1,2d0
   < clientes 5
   < pedidos 12
   1
   2c2
   < pedidos 12
   ---
   > pedidos 8
   1
   ```
   `<` es una línea de la primera base y `>` de la segunda: a `prueba` le faltan los 4 pedidos de Ana Torres.

10. **Recoger.** `dropdb` borra una base entera, sin papelera. Borra las tres de prueba y las dos copias:
    ```bash
    dropdb prueba; dropdb desde_sql; dropdb vacia
    rm copia.sql copia.dump
    shellcheck starter/compare-dbs.sh && echo limpio
    ```
    ```text
    limpio
    ```

## Criterios de éxito

- `copia.sql` contiene los `CREATE TABLE` y los `COPY` de las dos tablas (paso 1).
- `head -c 5 copia.dump` imprime `PGDMP` y `pg_restore -l copia.dump` lista 7 entradas (pasos 2 y 3).
- `pg_restore copia.dump` sin `-d` sale con 1 (paso 4).
- La base `prueba` restaurada tiene 12 pedidos (paso 5).
- `./starter/compare-dbs.sh bashkit prueba` dice `iguales` con 0, y con la base vacía o con filas borradas enseña la diferencia y sale con 1 (paso 9).

## Reto extra

`pg_restore -t pedidos` restaura solo una tabla, y `pg_dump -t pedidos` copia solo una. Usa uno de los dos para dejar en una base nueva solo los pedidos, y explica por qué la restauración no se queja de que falte la tabla `clientes`, siendo `pedidos.cliente_id` una clave ajena. Pista: mira qué entradas de `pg_restore -l` restaura `-t` y cuáles no.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 02 — Esperar a que PostgreSQL responda](../lab-02-esperar-a-que-responda/README.md) | [Lab 04 — Un backup que miente](../lab-04-un-backup-que-miente/README.md) → |

[↑ Semana 14](../../README.md)
