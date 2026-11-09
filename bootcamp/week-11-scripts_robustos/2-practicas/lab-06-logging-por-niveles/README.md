# Lab 06 — Logging por niveles

⏱ Duración estimada: ~60 min

## Objetivo

Escribir una librería de avisos con cuatro niveles (`debug`, `info`, `warn`, `error`) que elige qué escribir según `LOG_LEVEL`, pone la hora delante y guarda una copia en un archivo.

## Contexto

- Un script que cuenta todo lo que hace es útil cuando lo depuras y un estorbo en un cron. Uno que no cuenta nada te deja a ciegas cuando falla. Los **niveles** resuelven las dos cosas: cada aviso dice cuánto importa, y una variable decide desde qué nivel se escribe.
- Los avisos van a **stderr**: la salida (stdout) queda para los datos, y quien la capture con `$( )` o un pipe no recibe los avisos mezclados (semana 03).
- `starter/check-disk.sh` lee la salida de `df -P` (el espacio de cada disco) y avisa de los que se llenan: `warn` desde el 80%, `error` desde el 90%. Usa `starter/lib/log.sh`, que de momento escribe todos los avisos sin mirar su nivel. `datos/df.txt` es una salida de `df -P` de ejemplo: así el resultado no depende de tu disco.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-11-scripts_robustos/2-practicas/lab-06-logging-por-niveles
   ```
   (sin salida).

1. **El script, tal cual.** Abre `starter/check-disk.sh` y `starter/lib/log.sh` en tu editor.
   ```bash
   cat datos/df.txt
   bash starter/check-disk.sh datos/df.txt; echo $?
   ```
   ```text
   Filesystem     1024-blocks      Used Available Capacity Mounted on
   /dev/sda1         51474912  23163708  25673096      48% /
   /dev/sdb1        102687672  83177012  14269928      86% /var
   /dev/sdc1         20511312  19485746    576538      98% /home
   tmpfs              4026748         0   4026748       0% /dev/shm
   debug / al 48%
   debug /var al 86%
   warn /var al 86%
   debug /home al 98%
   error /home al 98%: casi lleno
   debug /dev/shm al 0%
   info revisados los discos de datos/df.txt: 1 casi llenos
   1
   ```
   Siete avisos para dos problemas. Sale con `1` porque `/home` está casi lleno.

2. **TODO 1: cada nivel, un número.** Para comparar niveles hace falta un orden: `debug` 0, `info` 1, `warn` 2, `error` 3. En `starter/lib/log.sh`, cambia el comentario del `TODO 1` por:
   ```bash
   # level_number <nivel>: el orden del nivel. Con números, "¿llega a LOG_LEVEL?" es un >=.
   level_number() {
     case "$1" in
       debug) echo 0 ;;
       info) echo 1 ;;
       warn) echo 2 ;;
       error) echo 3 ;;
       *) return 1 ;;
     esac
   }
   ```
   Prueba cargando la librería con `source` (semana 08):
   ```bash
   bash -c 'source starter/lib/log.sh; level_number warn; level_number mucho; echo "código: $?"'
   ```
   ```text
   2
   código: 1
   ```

3. **TODO 2: solo desde `LOG_LEVEL`.** Cambia el comentario del `TODO 2` y las tres primeras líneas de `log_at` (hasta el `echo`, sin incluirlo) por:
   ```bash
     local level="$1" min
     shift
     # Un LOG_LEVEL mal escrito se avisa: callarlo escondería justo los avisos que pediste.
     if ! min="$(level_number "${LOG_LEVEL:-info}")"; then
       echo "log.sh: LOG_LEVEL='$LOG_LEVEL' no es debug, info, warn ni error" >&2
       return 2
     fi
     # return 0: un aviso que no toca escribir no es un error, y con set -e un 1 pararía el script.
     (($(level_number "$level") >= min)) || return 0
   ```
   Deja debajo el `echo "$level $*" >&2`. `${LOG_LEVEL:-info}` es `info` si la variable no existe (semana 05). Prueba con tres niveles y con uno mal escrito:
   ```bash
   bash starter/check-disk.sh datos/df.txt; echo $?
   LOG_LEVEL=debug bash starter/check-disk.sh datos/df.txt
   LOG_LEVEL=error bash starter/check-disk.sh datos/df.txt
   LOG_LEVEL=mucho bash starter/check-disk.sh datos/df.txt; echo $?
   ```
   ```text
   warn /var al 86%
   error /home al 98%: casi lleno
   info revisados los discos de datos/df.txt: 1 casi llenos
   1
   debug / al 48%
   debug /var al 86%
   warn /var al 86%
   debug /home al 98%
   error /home al 98%: casi lleno
   debug /dev/shm al 0%
   info revisados los discos de datos/df.txt: 1 casi llenos
   error /home al 98%: casi lleno
   log.sh: LOG_LEVEL='mucho' no es debug, info, warn ni error
   2
   ```
   Con `mucho`, el primer `log_debug` devuelve 2 y `set -e` para el script con ese código.

4. **TODO 3: la hora y el nivel en mayúsculas.** Un aviso sin hora no sirve para saber cuándo pasó. Cambia `local level="$1" min` por `local level="$1" min line`, borra el comentario del `TODO 3` y cambia el `echo "$level $*" >&2` por:
   ```bash
     # La hora en ISO 8601 y el nivel en mayúsculas (${level^^}): se leen y se filtran con grep.
     line="$(date +%FT%T) ${level^^} $*"
     echo "$line" >&2
   ```
   `date +%FT%T` escribe la fecha y la hora como `2026-11-09T02:58:11`. `${level^^}` es el valor de `level` en mayúsculas. Prueba, con los avisos pasados a stdout (`2>&1`) para poder filtrarlos:
   ```bash
   bash starter/check-disk.sh datos/df.txt 2>&1 | grep -E 'WARN|ERROR'
   ```
   Algo como (cambian la fecha y la hora):
   ```text
   2026-11-09T02:58:11 WARN /var al 86%
   2026-11-09T02:58:11 ERROR /home al 98%: casi lleno
   ```

5. **TODO 4: una copia en un archivo.** Un cron no tiene pantalla: lo que va a stderr se pierde si nadie lo guarda. Borra el comentario del `TODO 4` y añade debajo del `echo "$line" >&2`:
   ```bash
     # El archivo, además de stderr: el cron no tiene pantalla, y el aviso queda para mañana.
     if [[ -n ${LOG_FILE:-} ]]; then
       echo "$line" >> "$LOG_FILE"
     fi
   ```
   `${LOG_FILE:-}` vale vacío si no existe: sin el `:-`, `set -u` pararía el script. Prueba, sin pantalla (`2>/dev/null` tira stderr) y dos veces:
   ```bash
   LOG_FILE=alertas.log LOG_LEVEL=warn bash starter/check-disk.sh datos/df.txt 2>/dev/null; echo $?
   cat alertas.log
   LOG_FILE=alertas.log LOG_LEVEL=warn bash starter/check-disk.sh datos/df.txt 2>/dev/null
   wc -l alertas.log
   rm alertas.log
   ```
   Algo como:
   ```text
   1
   2026-11-09T02:58:11 WARN /var al 86%
   2026-11-09T02:58:11 ERROR /home al 98%: casi lleno
   4 alertas.log
   ```
   `>>` añade: cada ejecución suma sus avisos sin borrar los de antes.

6. **stdout queda limpio.**
   ```bash
   bash starter/check-disk.sh datos/df.txt 2>/dev/null; echo $?
   ```
   ```text
   1
   ```
   Ninguna línea: `check-disk.sh` no escribe nada en stdout, solo avisos en stderr y su código de salida. Un script que lo llame puede usar el código sin limpiar la salida.

7. **shellcheck.**
   ```bash
   shellcheck -x starter/check-disk.sh; echo $?
   ```
   ```text
   0
   ```
   `-x` hace que shellcheck siga el `source` y revise también `lib/log.sh`.

## Criterios de éxito

- [ ] Explicas por qué los avisos van a stderr y no a stdout
- [ ] Con `LOG_LEVEL=error` solo sale el aviso de `/home` (paso 3)
- [ ] Con `LOG_LEVEL=mucho`, el script avisa del nivel y sale con `2` (paso 3)
- [ ] Con `LOG_FILE=alertas.log`, el archivo recibe los avisos con su hora (paso 5)
- [ ] `shellcheck -x starter/check-disk.sh` no imprime nada

## Reto extra

Haz que `log_at` escriba en color cuando stderr es una terminal y sin color cuando va a un archivo o a un pipe: `[[ -t 2 ]]` es verdad si el descriptor 2 es una terminal. `printf '\e[31m%s\e[0m\n' "texto"` escribe `texto` en rojo. ¿Por qué el color no debe llegar a `LOG_FILE`?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 05 — Bloqueo con flock](../lab-05-bloqueo-con-flock/README.md) | [Lab 07 — Un script idempotente](../lab-07-script-idempotente/README.md) → |

[↑ Semana 11](../../README.md)
