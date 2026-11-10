# Lab 06 — Restaurar sin miedo

⏱ Duración estimada: ~60 min

## Objetivo

Recuperar unos datos borrados con `pg_restore`, ver qué pasa cuando una restauración falla a medias con y sin `--single-transaction`, y escribir un script que restaura solo después de comprobar la copia y de preguntar.

## Contexto

- Restaurar es la operación más peligrosa de las copias: borra lo que hay ahora. Hazlo con prisa y sin probar, y puedes acabar peor que antes del accidente.
- `pg_restore --clean --if-exists` borra cada tabla antes de crearla de nuevo. `--single-transaction` hace todo dentro de una transacción: o sale todo bien, o PostgreSQL deshace lo que llevaba y la base queda como estaba.
- `starter/restore.sh` tiene la estructura; le faltan la comprobación de la copia, la pregunta y la restauración.

## Instrucciones

0. Con PostgreSQL en marcha (lab 01), entra al laboratorio, ve a la carpeta del lab y recarga la tienda:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-14-proyecto_integrador/2-practicas/lab-06-restaurar-sin-miedo
   psql -v ON_ERROR_STOP=1 -q -f ../lab-01-postgresql-en-docker/datos/tienda.sql
   ```
   (sin salida).

1. **La copia de antes del accidente.**
   ```bash
   pg_dump -Fc -f tienda.dump; ls tienda.dump
   ```
   ```text
   tienda.dump
   ```

2. **El accidente.** Alguien borra los pedidos de Ana Torres (cliente 1):
   ```bash
   psql -c 'delete from pedidos where cliente_id = 1'
   psql -Atc 'select count(*) from pedidos'
   ```
   ```text
   DELETE 4
   8
   ```

3. **Restaurar sin más.** Lo primero que se le ocurre a cualquiera. Los errores van a `errores.txt` para no llenar la pantalla:
   ```bash
   pg_restore -d bashkit tienda.dump 2> errores.txt; echo $?
   tail -n 1 errores.txt
   psql -Atc 'select count(*) from pedidos'
   ```
   ```text
   1
   pg_restore: warning: errors ignored on restore: 7
   8
   ```
   Siete errores y los pedidos siguen en 8. Las tablas ya existían (`CREATE TABLE` falla) y los datos de la copia chocan con los que quedan (la clave `id` no se puede repetir), así que `COPY` falla entero. No recuperó nada. `less errores.txt` enseña los siete, si te interesan.

4. **Con --clean.** `--clean` borra cada tabla antes de crearla y `--if-exists` evita el error si alguna no existe:
   ```bash
   pg_restore --clean --if-exists -d bashkit tienda.dump; echo $?
   psql -Atc 'select count(*) from pedidos'
   ```
   ```text
   0
   12
   ```
   Recuperados los 12.

5. **Una restauración que falla a medias.** Desde la copia, alguien ha creado una **vista**: una consulta guardada con nombre, que depende de la tabla `pedidos`. Créala y repite el accidente:
   ```bash
   psql -c 'create view gasto as select cliente_id, sum(total) as total from pedidos group by cliente_id'
   psql -c 'delete from pedidos where cliente_id = 1'
   pg_restore --clean --if-exists -d bashkit tienda.dump 2> errores.txt; echo $?
   grep -E '^pg_restore: (error|warning)' errores.txt
   psql -Atc 'select count(*) from pedidos'
   ```
   ```text
   CREATE VIEW
   DELETE 4
   1
   pg_restore: error: could not execute query: ERROR:  cannot drop table public.pedidos because other objects depend on it
   pg_restore: error: could not execute query: ERROR:  relation "pedidos" already exists
   pg_restore: error: could not execute query: ERROR:  could not create unique index "pedidos_pkey"
   pg_restore: warning: errors ignored on restore: 3
   20
   ```
   **20** pedidos: los 8 que quedaban más los 12 de la copia. PostgreSQL no dejó borrar `pedidos` por la vista, `pg_restore` siguió como si nada, copió los datos encima y no pudo volver a crear la clave. Ahora hay pedidos repetidos:
   ```bash
   psql -Atc 'select id, count(*) from pedidos group by id having count(*) > 1 order by id' | head -n 3
   ```
   ```text
   2|2
   4|2
   5|2
   ```
   La base está peor que después del accidente. Déjala como al principio (borra la vista y recarga la tienda) y prepara el mismo escenario:
   ```bash
   psql -qc 'drop view gasto'
   psql -v ON_ERROR_STOP=1 -q -f ../lab-01-postgresql-en-docker/datos/tienda.sql
   psql -qc 'create view gasto as select cliente_id, sum(total) as total from pedidos group by cliente_id'
   psql -qc 'delete from pedidos where cliente_id = 1'
   ```
   (sin salida).

6. **Con --single-transaction.** La misma restauración, todo o nada:
   ```bash
   pg_restore --clean --if-exists --single-transaction -d bashkit tienda.dump; echo $?
   psql -Atc 'select count(*) from pedidos'
   ```
   ```text
   pg_restore: error: could not execute query: ERROR:  cannot drop table public.pedidos because other objects depend on it
   DETAIL:  view public.gasto depends on table public.pedidos
   HINT:  Use DROP ... CASCADE to drop the dependent objects too.
   Command was: DROP TABLE IF EXISTS public.pedidos;
   1
   8
   ```
   Para en el **primer** error y deshace lo que llevaba: los 8 pedidos de antes, sin duplicados. La base no ha mejorado, pero tampoco ha empeorado, y el error dice exactamente qué estorba. Quita la vista y repite:
   ```bash
   psql -c 'drop view gasto'
   pg_restore --clean --if-exists --single-transaction -d bashkit tienda.dump; echo $?
   psql -Atc 'select count(*) from pedidos'
   ```
   ```text
   DROP VIEW
   0
   12
   ```

7. **El script, tal cual.**
   ```bash
   ./starter/restore.sh tienda.dump; echo $?
   ```
   ```text
   sin implementar
   1
   ```

8. **TODO 1: ¿es una copia?** Abre `starter/restore.sh` en tu editor. Debajo del TODO 1:
   ```bash
   if ! pg_restore -l "$file" > /dev/null 2>&1; then
     echo "'$file' no es una copia de pg_dump -Fc" >&2
     exit 1
   fi
   ```
   `pg_restore -l` solo lee el índice (lab 03): si falla, se para antes de tocar la base. Para probarlo antes de los otros TODO, crea un archivo que no es una copia:
   ```bash
   echo hola > notas.txt
   ./starter/restore.sh -y notas.txt; echo $?
   rm notas.txt
   ```
   ```text
   'notas.txt' no es una copia de pg_dump -Fc
   1
   ```

9. **TODO 2: preguntar.** `[[ -t 0 ]]` es verdad si la entrada estándar es una terminal (alguien que puede contestar). `read -p` escribe una pregunta y lee la respuesta. Debajo del TODO 2:
   ```bash
   if [[ -z $yes ]]; then
     if [[ ! -t 0 ]]; then
       echo "sin terminal no puedo preguntar: usa -y para confirmar" >&2
       exit 2
     fi
     read -r -p "Esto reemplaza lo que hay en '$PGDATABASE' por '$file'. ¿Seguir? [s/N] " answer || answer=""
     if [[ $answer != [sS] ]]; then
       echo "cancelado: no he tocado la base" >&2
       exit 1
     fi
   fi
   ```
   `[s/N]`: la mayúscula es lo que pasa si solo pulsas Enter, que es no. `|| answer=""`: si la entrada se acaba sin respuesta (Ctrl-D), `read` falla, y sin eso `set -e` pararía el script sin decir nada. Desde un pipe o desde cron no hay terminal; `< /dev/null` lo simula:
   ```bash
   ./starter/restore.sh tienda.dump < /dev/null; echo $?
   ```
   ```text
   sin terminal no puedo preguntar: usa -y para confirmar
   2
   ```

10. **TODO 3: restaurar.** Borra las dos líneas del final (`echo "sin implementar"` y `exit 1`) y, debajo del TODO 3:
    ```bash
    pg_restore --clean --if-exists --no-owner --single-transaction -d "$PGDATABASE" "$file"
    echo "'$PGDATABASE' restaurada desde '$file'"
    ```
    `--no-owner`: lo restaurado pasa a ser del usuario que restaura, aunque la copia venga de un servidor con otro usuario. Prueba la pregunta: contesta `n` la primera vez y `s` la segunda.
    ```bash
    ./starter/restore.sh tienda.dump; echo $?
    ./starter/restore.sh tienda.dump; echo $?
    ```
    ```text
    Esto reemplaza lo que hay en 'bashkit' por 'tienda.dump'. ¿Seguir? [s/N] n
    cancelado: no he tocado la base
    1
    Esto reemplaza lo que hay en 'bashkit' por 'tienda.dump'. ¿Seguir? [s/N] s
    'bashkit' restaurada desde 'tienda.dump'
    0
    ```
    Y sin preguntar, con `-y`, después de otro accidente:
    ```bash
    psql -qc 'delete from pedidos where cliente_id = 1'
    ./starter/restore.sh -y tienda.dump; echo $?
    psql -Atc 'select count(*) from pedidos'
    ```
    ```text
    'bashkit' restaurada desde 'tienda.dump'
    0
    12
    ```

11. **El simulacro.** Una copia que nunca has restaurado no sabes si sirve. Restáurala en una base de usar y tirar, sin tocar la de verdad: `PGDATABASE=simulacro` delante del comando cambia la base solo para él.
    ```bash
    createdb simulacro
    PGDATABASE=simulacro ./starter/restore.sh -y tienda.dump
    psql -d simulacro -Atc 'select count(*) from pedidos'
    dropdb simulacro
    ```
    ```text
    'simulacro' restaurada desde 'tienda.dump'
    12
    ```

12. **Recoger.**
    ```bash
    shellcheck starter/restore.sh && echo limpio
    rm tienda.dump errores.txt
    ```
    ```text
    limpio
    ```

## Criterios de éxito

- Sin `--clean`, `pg_restore` sale con 1 y no recupera los pedidos (paso 3); con `--clean --if-exists`, vuelven a ser 12 (paso 4).
- Con una vista que depende de `pedidos`, sin `--single-transaction` quedan 20 pedidos repetidos; con él, quedan los 8 de antes y sale con 1 (pasos 5 y 6).
- `./starter/restore.sh -y` con un archivo que no es una copia sale con 1; sin `-y` y sin terminal, con 2 (pasos 8 y 9).
- Contestando `n` no restaura (código 1); contestando `s` o con `-y`, deja 12 pedidos (paso 10).
- El simulacro en la base `simulacro` da 12 pedidos (paso 11).

## Reto extra

En el paso 6, `--single-transaction` paró por la vista `gasto`, que no está en la copia. `pg_restore` no tiene una opción para borrar "lo que dependa" de una tabla, pero `DROP ... CASCADE` sí. Antes de cambiar el script: ¿qué perderías si `restore.sh` borrara con `CASCADE` todo lo que depende de las tablas de la copia? Escribe la respuesta en una línea, pensando en quién creó la vista y por qué.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 05 — Rotación de copias: guardar solo las últimas](../lab-05-rotacion-de-copias/README.md) | [Lab 07 — CI con GitHub Actions](../lab-07-ci-con-github-actions/README.md) → |

[↑ Semana 14](../../README.md)
