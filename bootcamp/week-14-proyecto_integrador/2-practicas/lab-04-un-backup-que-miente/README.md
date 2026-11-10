# Lab 04 — Un backup que miente

⏱ Duración estimada: ~60 min

## Objetivo

Encontrar por qué un script de copias dice "copia hecha" cuando ha fallado y además destruye la copia buena, y arreglarlo con `pipefail`, un archivo temporal, `mv` y `trap`.

## Contexto

- `starter/backup.sh` está **roto a propósito**. Hace lo que hacen muchos scripts de copias reales: `pg_dump | gzip > copia.sql.gz`. Con la base en marcha funciona; el día que la base no responde, falla de la peor forma posible.
- Una copia que falla y lo dice es un problema pequeño: la repites. Una copia que falla y dice que salió bien es un problema que descubres el día que la necesitas.
- Para simular una base caída sin pararla, cambia `PGHOST` solo para un comando: `PGHOST=no-existe ./starter/backup.sh`.

## Instrucciones

0. Con PostgreSQL en marcha (lab 01), entra al laboratorio, ve a la carpeta del lab y recarga la tienda:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-14-proyecto_integrador/2-practicas/lab-04-un-backup-que-miente
   psql -v ON_ERROR_STOP=1 -q -f ../lab-01-postgresql-en-docker/datos/tienda.sql
   ```
   (sin salida).

1. **Con la base en marcha.** Haz una copia y comprueba que tiene las dos tablas. `zcat` descomprime a la pantalla sin tocar el archivo:
   ```bash
   ./starter/backup.sh; echo $?
   ls -l copias
   zcat copias/bashkit.sql.gz | grep -c '^COPY'
   ```
   ```text
   copia hecha: copias/bashkit.sql.gz
   0
   total 4
   -rw-r--r-- 1 alumno alumno 1006 Nov 10 21:03 bashkit.sql.gz
   2
   ```
   (el tamaño y la fecha pueden cambiar un poco). Esta es tu copia buena.

2. **Con la base caída.** Ejecútalo como si PostgreSQL no respondiera:
   ```bash
   PGHOST=no-existe ./starter/backup.sh; echo $?
   ls -l copias
   zcat copias/bashkit.sql.gz | wc -c
   ```
   ```text
   pg_dump: error: could not translate host name "no-existe" to address: Temporary failure in name resolution
   copia hecha: copias/bashkit.sql.gz
   0
   total 4
   -rw-r--r-- 1 alumno alumno 20 Nov 10 21:03 bashkit.sql.gz
   0
   ```
   Tres fallos a la vez:
   - Dice `copia hecha` y sale con **0**: cron, la CI o quien lo llame cree que todo fue bien.
   - La copia buena del paso 1 **ya no existe**: `>` vació el archivo antes de que `pg_dump` empezara.
   - Lo que queda son 20 bytes: lo que escribe `gzip` cuando comprime nada.

3. **Fallo 1: el código del pipe.** El código de salida de un pipe es el de su **último** comando: `gzip` comprimió nada sin problemas y salió con 0, y `set -e` no vio ningún fallo. `pipefail` hace que el pipe falle si falla cualquiera de sus comandos. Abre `starter/backup.sh` en tu editor y cambia `set -eu` por:
   ```bash
   set -euo pipefail
   ```
   Recupera la copia buena y vuelve a simular la caída:
   ```bash
   ./starter/backup.sh > /dev/null
   PGHOST=no-existe ./starter/backup.sh; echo $?
   ls -l copias
   ```
   ```text
   pg_dump: error: could not translate host name "no-existe" to address: Temporary failure in name resolution
   1
   total 4
   -rw-r--r-- 1 alumno alumno 20 Nov 10 21:03 bashkit.sql.gz
   ```
   Ya no miente: sale con 1. Pero la copia buena sigue perdida: el `>` la vació antes de que nada fallara.

4. **Fallo 2: escribir encima de la buena.** La copia nueva va a un archivo **temporal** en la misma carpeta, y solo si todo salió bien se renombra con `mv` al nombre final. `mv` dentro de un mismo disco no copia nada, solo cambia el nombre: es instantáneo, y nadie ve nunca una copia a medias con el nombre bueno. Cambia las dos últimas líneas del script por:
   ```bash
   final="copias/$PGDATABASE.sql.gz"
   partial="copias/.$PGDATABASE.sql.gz.partial"

   if ! pg_dump | gzip > "$partial"; then
     echo "la copia falló: $final no se ha tocado" >&2
     exit 1
   fi
   mv "$partial" "$final"
   echo "copia hecha: $final"
   ```
   El punto delante del nombre esconde el temporal de un `ls` normal, y el `if !` dice qué pasó antes de salir. Recupera la copia buena y simula la caída otra vez. `ls -la` enseña también los archivos ocultos:
   ```bash
   ./starter/backup.sh > /dev/null
   ls -l copias
   PGHOST=no-existe ./starter/backup.sh; echo $?
   ls -la copias
   ```
   ```text
   total 4
   -rw-r--r-- 1 alumno alumno 1005 Nov 10 21:03 bashkit.sql.gz
   pg_dump: error: could not translate host name "no-existe" to address: Temporary failure in name resolution
   la copia falló: copias/bashkit.sql.gz no se ha tocado
   1
   total 16
   drwxr-xr-x 2 alumno alumno 4096 Nov 10 21:03 .
   drwxr-xr-x 5 alumno alumno 4096 Nov 10 21:03 ..
   -rw-r--r-- 1 alumno alumno   20 Nov 10 21:03 .bashkit.sql.gz.partial
   -rw-r--r-- 1 alumno alumno 1005 Nov 10 21:03 bashkit.sql.gz
   ```
   La copia buena sigue ahí, con sus 1005 bytes. Queda basura: el `.partial` de 20 bytes.

5. **Fallo 3: la basura.** `trap '...' EXIT` (semana 11) ejecuta un comando al salir el script, por lo que sea: un `exit 1`, un fallo con `set -e` o un Ctrl-C. Si todo salió bien, el `mv` ya se llevó el temporal y `rm -f` no encuentra nada que borrar (sin `-f` se quejaría). Justo debajo de la línea `partial=...`, añade:
   ```bash
   trap 'rm -f "$partial"' EXIT
   ```
   Borra el temporal que quedó del paso 4 y repite la caída:
   ```bash
   rm copias/.bashkit.sql.gz.partial
   PGHOST=no-existe ./starter/backup.sh; echo $?
   ls -la copias
   ```
   ```text
   pg_dump: error: could not translate host name "no-existe" to address: Temporary failure in name resolution
   la copia falló: copias/bashkit.sql.gz no se ha tocado
   1
   total 12
   drwxr-xr-x 2 alumno alumno 4096 Nov 10 21:03 .
   drwxr-xr-x 5 alumno alumno 4096 Nov 10 21:03 ..
   -rw-r--r-- 1 alumno alumno 1005 Nov 10 21:03 bashkit.sql.gz
   ```

6. **Con la base en marcha, otra vez.** El arreglo no puede romper el caso normal. `gzip -t` comprueba que un `.gz` está entero, sin descomprimirlo a ningún sitio:
   ```bash
   ./starter/backup.sh; echo $?
   gzip -t copias/bashkit.sql.gz; echo $?
   zcat copias/bashkit.sql.gz | grep -c '^COPY'
   ```
   ```text
   copia hecha: copias/bashkit.sql.gz
   0
   0
   2
   ```

7. **Una copia cortada.** `head -c 100` se queda con los 100 primeros bytes: así queda un archivo si el disco se llena a mitad. `gzip -t` lo detecta:
   ```bash
   head -c 100 copias/bashkit.sql.gz > roto.gz
   gzip -t roto.gz; echo $?
   rm roto.gz
   ```
   ```text

   gzip: roto.gz: unexpected end of file
   1
   ```
   Es lo que comprobarías antes de restaurar una copia comprimida, como `pg_restore -l` con una copia custom (lab 03).

8. **Recoger y revisar.**
   ```bash
   shellcheck starter/backup.sh && echo limpio
   rm -r copias
   ```
   ```text
   limpio
   ```
   shellcheck no avisaba del script roto: los tres fallos son de lógica, no de sintaxis. Por eso los tests y las pruebas con la base caída importan tanto como el lint.

## Criterios de éxito

- Con la base caída, el script roto dice `copia hecha`, sale con 0 y deja un `.gz` de 20 bytes en lugar de la copia buena (paso 2).
- Con `pipefail`, el mismo caso sale con 1 (paso 3).
- Con el temporal y `mv`, la copia buena sobrevive a un fallo (paso 4).
- Con el `trap`, no queda ningún `.partial` después de un fallo (paso 5).
- Con la base en marcha, la copia arreglada pasa `gzip -t` y tiene 2 `COPY` (paso 6).

## Reto extra

El `mv` es atómico solo si el temporal y el destino están en el **mismo sistema de archivos**. Si `partial` estuviera en `/tmp` (otro disco, o un `tmpfs` en memoria), `mv` tendría que copiar el archivo entero y borrar el original, y alguien podría ver la copia a medias. Comprueba en qué sistema de archivos está cada carpeta con `df --output=target copias /tmp` y explica en una línea por qué el temporal va en `copias/` y no en un `mktemp` normal.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 03 — pg_dump y pg_restore: copiar una base y comprobar la copia](../lab-03-pg-dump-y-pg-restore/README.md) | [Lab 05 — Rotación de copias: guardar solo las últimas](../lab-05-rotacion-de-copias/README.md) → |

[↑ Semana 14](../../README.md)
