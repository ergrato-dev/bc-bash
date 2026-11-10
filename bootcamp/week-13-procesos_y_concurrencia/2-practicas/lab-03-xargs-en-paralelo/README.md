# Lab 03 — xargs en paralelo

⏱ Duración estimada: ~60 min

## Objetivo

Repartir el trabajo de muchos archivos entre todos los núcleos con `find -print0 | xargs -0 -P`, sin romper los nombres con espacios y sabiendo cuándo ha fallado alguno.

## Contexto

- `xargs` lee palabras de stdin y las pasa como **argumentos** a un comando. Sirve para los comandos que no leen stdin, como `gzip` o `rm`: `find` encuentra los archivos y `xargs` se los da.
- Con `-P N`, `xargs` lanza hasta N comandos a la vez: el límite del lab 02 sin escribir el bucle. Va bien con el trabajo que gasta CPU (comprimir, calcular un hash), porque cada proceso ocupa un núcleo.
- `starter/make-logs.sh` crea 8 logs de unos 11 MB con un espacio en el nombre (`app 2026-11-01.log`). `starter/compress-logs.sh` los comprime uno detrás de otro, y además está **roto a propósito**: recorre la salida de `ls`.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-13-procesos_y_concurrencia/2-practicas/lab-03-xargs-en-paralelo
   ```
   (sin salida).

1. **Los logs.** Ocupan unos 90 MB: el paso 8 los borra.
   ```bash
   bash starter/make-logs.sh logs
   ls logs
   du -sh logs
   head -n 2 "logs/app 2026-11-01.log"
   ```
   ```text
   app 2026-11-01.log
   app 2026-11-02.log
   app 2026-11-03.log
   app 2026-11-04.log
   app 2026-11-05.log
   app 2026-11-06.log
   app 2026-11-07.log
   app 2026-11-08.log
   88M	logs
   2026-11-01 10:00:00 GET /api/items/51342 200
   2026-11-01 10:00:00 GET /api/items/176311 200
   ```
   Los números de las rutas salen al azar y cambian en tu equipo.

2. **Qué hace `xargs`.** Junta lo que lee en los argumentos de un solo comando. `-n N` pone como mucho N argumentos en cada uno, y `-t` escribe en stderr cada comando antes de ejecutarlo:
   ```bash
   printf 'uno\ndos\ntres\n' | xargs echo
   printf 'uno\ndos\ntres\n' | xargs -n 1 echo
   printf 'uno\ndos\ntres\n' | xargs -t -n 2 echo
   ```
   ```text
   uno dos tres
   uno
   dos
   tres
   echo uno dos
   uno dos
   echo tres
   tres
   ```
   Un `echo` con tres argumentos; tres `echo` con uno; dos `echo`, de dos y de uno.

3. **El script, tal cual.** Abre `starter/compress-logs.sh` en tu editor y ejecútalo:
   ```bash
   bash starter/compress-logs.sh logs; echo "código: $?"
   ```
   ```text
   gzip: logs/app: No such file or directory
   código: 1
   ```
   `$(ls ...)` se parte por los espacios (semana 07): el `for` recibe `logs/app` y `2026-11-01.log` por separado. `set -e` lo para en el primer fallo.

4. **El mismo fallo con `xargs`.** `xargs` también parte por espacios lo que lee:
   ```bash
   ls logs/*.log | xargs gzip -9 -k 2>&1 | head -n 4
   ls logs/*.log | xargs gzip -9 -k 2> /dev/null; echo "código: $?"
   ```
   ```text
   gzip: logs/app: No such file or directory
   gzip: 2026-11-01.log: No such file or directory
   gzip: logs/app: No such file or directory
   gzip: 2026-11-02.log: No such file or directory
   código: 123
   ```
   `gzip -9` comprime lo más que puede y `-k` (*keep*) deja el original. `xargs` no se para al primer fallo: ejecuta todo y al final sale con `123`, "algún comando falló". La solución es la de la semana 07: `find -print0` separa los nombres con el carácter nulo, que no puede ir dentro de un nombre, y `xargs -0` los separa por ahí.

5. **Uno a uno, y luego en paralelo.** Primero, un `gzip` por archivo (`-n 1`) y uno detrás de otro. Los paréntesis hacen que `time` mida el pipe entero:
   ```bash
   time (find logs -name '*.log' -print0 | xargs -0 -n 1 gzip -9 -k)
   ls logs | head -n 3
   rm logs/*.gz
   ```
   ```text
   real	0m2.526s
   user	0m2.719s
   sys	0m0.035s
   app 2026-11-01.log
   app 2026-11-01.log.gz
   app 2026-11-02.log
   ```
   Bien, con espacios y todo. `real` y `user` casi iguales: un solo núcleo trabajando. Ahora con `-P 4`, y con tantos como núcleos tenga tu máquina (`nproc`):
   ```bash
   time (find logs -name '*.log' -print0 | xargs -0 -P 4 -n 1 gzip -9 -k)
   rm logs/*.gz
   nproc
   time (find logs -name '*.log' -print0 | xargs -0 -P "$(nproc)" -n 1 gzip -9 -k)
   rm logs/*.gz
   ```
   ```text
   real	0m0.671s
   user	0m2.819s
   sys	0m0.053s
   8
   real	0m0.395s
   user	0m2.873s
   sys	0m0.041s
   ```
   Los tiempos y el número de núcleos cambian en tu equipo. `user` sigue en casi 3 segundos (el trabajo es el mismo), pero repartido: `real` baja a la cuarta parte con 4. Sin `-n 1`, `xargs` metería los 8 archivos en un solo `gzip` y no habría nada que repartir.

6. **La salida se mezcla.** `-I {}` cambia `{}` por cada línea leída, en el sitio que quieras del comando (y lanza uno por línea). `sh -c '...'` ejecuta un pequeño script. Compara sin y con `-P`:
   ```bash
   printf '%s\n' a b c | xargs -I {} sh -c 'echo empieza {}; sleep 1; echo acaba {}'
   printf '%s\n' a b c | xargs -P 3 -I {} sh -c 'echo empieza {}; sleep 1; echo acaba {}'
   ```
   ```text
   empieza a
   acaba a
   empieza b
   acaba b
   empieza c
   acaba c
   empieza a
   empieza b
   empieza c
   acaba a
   acaba b
   acaba c
   ```
   En paralelo, las líneas de los tres se intercalan, y en otro orden cada vez. Con comandos que escriben mucho, cada uno a su archivo (como `gzip`, o `bk-healthcheck` en el proyecto).

7. **TODOs 1 y 2: el script.** Cambia los dos comentarios de TODO y el bucle `for` por:
   ```bash
   # -print0 y -0 separan los nombres con el carácter nulo: uno con espacios llega entero.
   # -P: cuántos gzip a la vez. -n 1: un archivo por gzip, para que haya trabajo que repartir.
   # --: un nombre que empiece por - no se toma como una opción de gzip.
   # xargs sigue con el resto si un gzip falla, y al final sale con 123: el if lo recoge.
   if ! find "$dir" -type f -name '*.log' -print0 | xargs -0 -P "$max_jobs" -n 1 gzip -9 -k --; then
     echo "compress-logs.sh: algún log de $dir no se pudo comprimir" >&2
     exit 1
   fi
   ```
   Con `set -o pipefail`, el `if` ve también un fallo de `find`. Prueba dos veces: la segunda, los `.gz` ya existen y `gzip` no los pisa.
   ```bash
   time bash starter/compress-logs.sh logs; echo "código: $?"
   ls logs | wc -l
   bash starter/compress-logs.sh logs 2>&1 | tail -n 3
   ```
   ```text
   comprimidos los logs de logs

   real	0m0.373s
   user	0m2.983s
   sys	0m0.059s
   código: 0
   16
   gzip: logs/app 2026-11-01.log.gz already exists;	not overwritten
   gzip: logs/app 2026-11-05.log.gz already exists;	not overwritten
   compress-logs.sh: algún log de logs no se pudo comprimir
   ```
   16: los 8 logs y sus 8 `.gz`. La segunda vez, cada `gzip` avisa de su archivo y el script resume el fallo. El orden de los avisos cambia: van en paralelo.

8. **shellcheck y limpieza.**
   ```bash
   shellcheck starter/compress-logs.sh; echo $?
   rm -r logs
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas por qué `ls | xargs gzip` rompe `app 2026-11-01.log` y qué cambian `-print0` y `-0` (pasos 3 y 4)
- [ ] Explicas qué significa el código `123` de `xargs` (paso 4)
- [ ] Con `-P 4`, `real` baja a la cuarta parte más o menos, y explicas por qué `user` no cambia (paso 5)
- [ ] `bash starter/compress-logs.sh logs` comprime los 8 logs, y la segunda vez avisa y sale con `1` (paso 7)

## Reto extra

`sha256sum` calcula un hash por archivo y escribe una línea por cada uno. Haz `find logs -name '*.log' -print0 | xargs -0 -P 4 -n 1 sha256sum > hashes.txt` y comprueba con `sha256sum -c hashes.txt` que todo cuadra. Con `-P 4`, ¿pueden mezclarse dos líneas de `hashes.txt`? ¿Y si cada `sha256sum` escribiera un archivo de 1 GB de salida?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 02 — Un límite de trabajos a la vez, y timeout](../lab-02-limite-de-trabajos-y-timeout/README.md) | [Lab 04 — Process substitution: <( ) y >( )](../lab-04-process-substitution/README.md) → |

[↑ Semana 13](../../README.md)
