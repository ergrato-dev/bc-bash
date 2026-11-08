# Lab 06 — Buscar archivos con find

⏱ Duración estimada: ~60 min

## Objetivo

Encontrar archivos por nombre, tipo, antigüedad y tamaño con `find`, actuar sobre ellos con `-exec` y `-delete`, y entender por qué el patrón de `-name` va entre comillas.

## Contexto

- `find dónde condiciones acción` recorre una carpeta entera y se queda con lo que cumple todas las condiciones ([teoría](../../1-teoria/04-buscar-archivos-con-find.md)).
- El patrón de `-name` es un glob (`*`, `?`), no una regex. Sin comillas, bash lo sustituye antes de que `find` lo vea, si encuentra algo que encaje en la carpeta actual.
- Este lab no trae datos: en el paso 1 creas un árbol de prueba en `zona/` con fechas y tamaños a medida. `starter/old-logs.sh` tiene un fallo a propósito y dos TODOs.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-04-filtros_de_texto_y_regex/2-practicas/lab-06-buscar-con-find
   ```
   (sin salida).

1. **El árbol de prueba.** `touch -d "10 days ago"` crea el archivo con esa fecha de modificación, como si llevara 10 días sin cambiar. `truncate -s 2M` crea un archivo de 2 MiB (lleno de ceros). Copia las seis líneas:
   ```bash
   mkdir -p zona/app/logs/viejos zona/app/config zona/app/tmp
   touch zona/app/config/app.conf zona/app/config/db.conf zona/app/LEEME.TXT zona/app/logs/hoy.log
   touch -d "3 days ago" zona/app/logs/semana.log
   touch -d "10 days ago" zona/app/logs/viejos/octubre-1.log zona/app/logs/viejos/octubre-2.log
   truncate -s 2M zona/app/tmp/volcado.bin
   touch "zona/app/tmp/nota con espacios.txt" zona/app/tmp/cache-1.tmp zona/app/tmp/cache-2.tmp
   ```
   (sin salida).

2. **Todo, y solo las carpetas:**
   ```bash
   find zona
   find zona -type d
   ```
   Algo como (el orden de la primera lista puede variar):
   ```text
   zona
   zona/app
   zona/app/config
   zona/app/config/app.conf
   zona/app/config/db.conf
   zona/app/logs
   zona/app/logs/hoy.log
   zona/app/logs/viejos
   zona/app/logs/viejos/octubre-1.log
   zona/app/logs/viejos/octubre-2.log
   zona/app/logs/semana.log
   zona/app/LEEME.TXT
   zona/app/tmp
   zona/app/tmp/cache-2.tmp
   zona/app/tmp/nota con espacios.txt
   zona/app/tmp/volcado.bin
   zona/app/tmp/cache-1.tmp
   zona
   zona/app
   zona/app/config
   zona/app/logs
   zona/app/logs/viejos
   zona/app/tmp
   ```
   Sin condiciones, `find` imprime todo lo que hay debajo, también la propia `zona`. `-type d` deja solo las carpetas (*directories*); `-type f`, solo los archivos (*files*).

3. **Por nombre:**
   ```bash
   find zona -name '*.log' | sort
   find zona -iname '*.txt'
   ```
   ```text
   zona/app/logs/hoy.log
   zona/app/logs/semana.log
   zona/app/logs/viejos/octubre-1.log
   zona/app/logs/viejos/octubre-2.log
   zona/app/LEEME.TXT
   zona/app/tmp/nota con espacios.txt
   ```
   `find` no ordena: `sort` hace que la lista salga siempre igual. `-iname` no distingue mayúsculas, por eso entra `LEEME.TXT`.

4. **Por antigüedad y tamaño:**
   ```bash
   find zona -name '*.log' -mtime +7
   find zona -name '*.log' -mtime -7 | sort
   find zona -size +1M
   ```
   ```text
   zona/app/logs/viejos/octubre-1.log
   zona/app/logs/viejos/octubre-2.log
   zona/app/logs/hoy.log
   zona/app/logs/semana.log
   zona/app/tmp/volcado.bin
   ```
   `-mtime` cuenta días desde la última modificación: `+7`, más de 7; `-7`, menos de 7. Varias condiciones seguidas se cumplen a la vez: nombre `*.log` **y** más de 7 días.

5. **Profundidad, "o" y "no":**
   ```bash
   find zona/app -maxdepth 1
   find zona -name '*.log' -o -name '*.conf' | sort
   find zona -type f ! -name '*.log' | sort
   ```
   Algo como (el orden de la primera lista puede variar):
   ```text
   zona/app
   zona/app/config
   zona/app/logs
   zona/app/LEEME.TXT
   zona/app/tmp
   zona/app/config/app.conf
   zona/app/config/db.conf
   zona/app/logs/hoy.log
   zona/app/logs/semana.log
   zona/app/logs/viejos/octubre-1.log
   zona/app/logs/viejos/octubre-2.log
   zona/app/LEEME.TXT
   zona/app/config/app.conf
   zona/app/config/db.conf
   zona/app/tmp/cache-1.tmp
   zona/app/tmp/cache-2.tmp
   zona/app/tmp/nota con espacios.txt
   zona/app/tmp/volcado.bin
   ```
   `-maxdepth 1` no baja de `zona/app`. `-o` es "o". `!` es "no": archivos que no terminan en `.log`.

6. **Actuar sobre lo encontrado:**
   ```bash
   find zona/app/logs -name '*.log' -exec ls -l {} +
   ```
   Algo como (cambian las fechas y el orden):
   ```text
   -rw-r--r-- 1 alumno alumno 0 Nov  8 05:36 zona/app/logs/hoy.log
   -rw-r--r-- 1 alumno alumno 0 Nov  5 05:36 zona/app/logs/semana.log
   -rw-r--r-- 1 alumno alumno 0 Oct 29 05:36 zona/app/logs/viejos/octubre-1.log
   -rw-r--r-- 1 alumno alumno 0 Oct 29 05:36 zona/app/logs/viejos/octubre-2.log
   ```
   `-exec ls -l {} +` ejecuta `ls -l` una vez, con todos los resultados en el sitio de `{}`. Ahí ves las fechas que puso `touch -d`.

7. **Borrar, mirando antes.** Primero el `find` sin acción; cuando la lista sea la que quieres, el mismo con `-delete`:
   ```bash
   find zona/app/tmp -name '*.tmp'
   find zona/app/tmp -name '*.tmp' -delete
   ls zona/app/tmp
   ```
   Algo como (el orden de la primera lista puede variar):
   ```text
   zona/app/tmp/cache-2.tmp
   zona/app/tmp/cache-1.tmp
   nota con espacios.txt
   volcado.bin
   ```
   `-delete` no pregunta ni tiene papelera. Mirar la lista antes es la costumbre que evita borrar lo que no querías.

8. **El script, sin tocar:**
   ```bash
   bash starter/old-logs.sh
   ```
   Algo como (el orden puede variar):
   ```text
   == logs de más de 7 días ==
   zona/app/logs/viejos/octubre-1.log
   zona/app/logs/viejos/octubre-2.log
   == archivos de más de 1 MiB ==
   ```
   Parece que funciona. Ahora deja un `.log` en la carpeta del lab, como el que dejaría cualquier programa, y ejecútalo otra vez:
   ```bash
   touch nota.log
   bash starter/old-logs.sh
   ```
   ```text
   == logs de más de 7 días ==
   == archivos de más de 1 MiB ==
   ```
   Ya no encuentra nada. Con dos:
   ```bash
   touch otra.log
   bash starter/old-logs.sh
   echo $?
   ```
   ```text
   == logs de más de 7 días ==
   find: paths must precede expression: `otra.log'
   find: possible unquoted pattern after predicate `-name'?
   1
   ```
   `bash -x` (lab 02) enseña qué recibió `find` de verdad:
   ```bash
   bash -x starter/old-logs.sh 2>&1 | grep find
   ```
   ```text
   + find zona/app -name nota.log otra.log -mtime +7
   find: paths must precede expression: `otra.log'
   find: possible unquoted pattern after predicate `-name'?
   ```
   Antes de ejecutar `find`, bash cambió `*.log` por los `.log` de la carpeta actual. Con uno, `find` buscaba `nota.log`; con dos, recibió un argumento que no entiende. El propio `find` sospecha: *possible unquoted pattern*.

9. **TODO 1.** Abre `starter/old-logs.sh` en tu editor. En la línea del `find`, pon el patrón entre comillas simples (`'*.log'`) y añade `| sort` al final. Borra el comentario del `TODO 1`. Prueba con los dos `.log` todavía en la carpeta:
   ```bash
   bash starter/old-logs.sh
   rm nota.log otra.log
   ```
   ```text
   == logs de más de 7 días ==
   zona/app/logs/viejos/octubre-1.log
   zona/app/logs/viejos/octubre-2.log
   == archivos de más de 1 MiB ==
   ```

10. **TODO 2.** Sustituye la línea del `TODO 2` por un `echo` que imprima `total: ` y el número: el mismo `find`, con comillas, por un pipe a `wc -l`, dentro de `$( )`. Prueba:
    ```bash
    bash starter/old-logs.sh
    ```
    ```text
    == logs de más de 7 días ==
    zona/app/logs/viejos/octubre-1.log
    zona/app/logs/viejos/octubre-2.log
    total: 2
    == archivos de más de 1 MiB ==
    ```

11. **TODO 3.** Sustituye la línea del `TODO 3` por un `find` de `zona/app` con `-type f`, `-size +1M` y `-exec ls -lh {} +`. `-h` (*human*) en `ls` escribe el tamaño en K, M o G. Borra los comentarios `TODO`. Prueba:
    ```bash
    bash starter/old-logs.sh | tail -2
    ```
    Algo como (cambia la fecha):
    ```text
    == archivos de más de 1 MiB ==
    -rw-r--r-- 1 alumno alumno 2.0M Nov  8 05:36 zona/app/tmp/volcado.bin
    ```

## Criterios de éxito

- [ ] Explicas qué recibió `find` en el paso 8 con uno y con dos `.log` en la carpeta, y por qué las comillas lo arreglan
- [ ] Explicas la diferencia entre `-mtime +7` y `-mtime -7` (paso 4)
- [ ] Explicas por qué conviene ejecutar el `find` sin `-delete` antes de borrar (paso 7)
- [ ] `bash starter/old-logs.sh` lista los 2 logs viejos ordenados, `total: 2` y `volcado.bin` con `2.0M`, aunque haya `.log` en la carpeta del lab

## Reto extra

Busca los archivos cuyo nombre tiene un espacio: `find zona -name '* *'`. Después prueba `ls $(find zona -name '* *')`. ¿Por qué `ls` dice que no existen `zona/app/tmp/nota`, `con` ni `espacios.txt`? La semana 07 enseña a recorrer resultados de `find` sin este problema.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 05 — sort y uniq: ordenar y contar](../lab-05-sort-y-uniq/README.md) | [Lab 07 — Analizar un access log](../lab-07-analizar-un-access-log/README.md) → |

[↑ Semana 04](../../README.md)
