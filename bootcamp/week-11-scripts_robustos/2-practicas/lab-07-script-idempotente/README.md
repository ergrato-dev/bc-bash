# Lab 07 — Un script idempotente

⏱ Duración estimada: ~60 min

## Objetivo

Arreglar un script de instalación para que ejecutarlo una vez o diez deje exactamente lo mismo, sin errores ni duplicados.

## Contexto

- Un script es **idempotente** cuando repetirlo no cambia nada que ya esté bien. Los de instalación y de deploy se lanzan muchas veces (en cada deploy, tras un fallo a mitad, por un compañero que no sabía que ya se había hecho): si fallan o duplican cosas la segunda vez, son una trampa.
- La regla: cada paso **comprueba o tolera** lo que ya existe. Las herramientas suelen tener la opción: `mkdir -p`, `ln -sfn`, `rm -f`; cuando no la tienen, se comprueba antes (`grep -q ... ||`).
- `starter/setup-app.sh` prepara la carpeta de una app: sus carpetas, un `app.conf` con dos líneas y el enlace `current`, que apunta a la versión en uso (`releases/v1`). Está **roto a propósito**: funciona la primera vez y falla (o hace algo peor) la segunda.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-11-scripts_robustos/2-practicas/lab-07-script-idempotente
   ```
   (sin salida).

1. **La primera vez.** Abre `starter/setup-app.sh` en tu editor. `readlink` escribe a dónde apunta un enlace simbólico:
   ```bash
   bash starter/setup-app.sh app; echo $?
   find app | sort
   cat app/config/app.conf
   readlink app/current
   ```
   ```text
   app lista en app (versión v1)
   0
   app
   app/config
   app/config/app.conf
   app/current
   app/logs
   app/releases
   app/releases/v1
   port=8080
   log_dir=app/logs
   releases/v1
   ```

2. **La segunda vez.**
   ```bash
   bash starter/setup-app.sh app; echo $?
   ```
   ```text
   mkdir: cannot create directory ‘app’: File exists
   1
   ```
   `mkdir` falla con lo que ya existe, y `set -e` para el script.

3. **Arreglo 1: `mkdir -p`.** Cambia las tres líneas de `mkdir` por una sola:
   ```bash
   mkdir -p "$app/config" "$app/logs" "$app/releases/$version"
   ```
   `-p` crea las carpetas que faltan en la ruta (también `$app` y `releases`) y no falla con las que existen (semana 01). Prueba la segunda vez otra vez:
   ```bash
   bash starter/setup-app.sh app; echo $?
   cat app/config/app.conf
   ls app/releases/v1
   readlink app/releases/v1/v1
   ```
   ```text
   app lista en app (versión v1)
   0
   port=8080
   log_dir=app/logs
   port=8080
   log_dir=app/logs
   v1
   releases/v1
   ```
   Sale con 0, pero es peor que fallar: `app.conf` tiene las líneas dos veces, y dentro de `releases/v1` hay un enlace nuevo llamado `v1`, que apunta a `releases/v1` desde ahí dentro (una ruta que no existe). Hay dos fallos más.

4. **Una línea, solo si no está.** `grep -q` no escribe nada, solo sale con 0 si encuentra; `-x` pide la línea entera; `-F` busca el texto tal cual, sin regex (el `.` de una IP sería "cualquier carácter").
   ```bash
   printf 'port=8080\nport=80800\n' > c.txt
   grep -c 'port=8080' c.txt
   grep -cxF 'port=8080' c.txt
   grep -qxF 'nada' c.txt; echo $?
   grep -qxF 'x' no-existe.txt; echo $?
   rm c.txt
   ```
   ```text
   2
   1
   1
   grep: no-existe.txt: No such file or directory
   2
   ```
   Sin `-x`, `port=8080` también está dentro de `port=80800`. Con un archivo que no existe, `grep` sale con 2 y avisa: la primera vez, `app.conf` aún no existe.

5. **Arreglo 2: `add_line`.** Cambia las dos líneas de `echo ... >> "$app/config/app.conf"` por:
   ```bash
   # add_line <línea> <archivo>: añade la línea solo si no está ya. Con >> a secas, cada
   # ejecución la repetiría. -q: sin salida; -x: la línea entera; -F: tal cual, sin regex.
   add_line() {
     grep -qxF -- "$1" "$2" 2> /dev/null || echo "$1" >> "$2"
   }
   add_line "port=8080" "$app/config/app.conf"
   add_line "log_dir=$app/logs" "$app/config/app.conf"
   ```
   `2> /dev/null` calla el aviso de `grep` cuando el archivo aún no existe; el `||` lo crea con la primera línea. La función se llama desde un `||`, y ahí `set -e` no para (lab 01): aquí es lo que se busca. Prueba desde cero, dos veces:
   ```bash
   rm -r app
   bash starter/setup-app.sh app
   bash starter/setup-app.sh app
   cat app/config/app.conf
   ls app/releases/v1
   ```
   ```text
   app lista en app (versión v1)
   app lista en app (versión v1)
   port=8080
   log_dir=app/logs
   v1
   ```
   `app.conf` ya está bien. Queda el enlace de dentro de `releases/v1`.

6. **El enlace que entra en la carpeta.** Si el nombre del enlace ya existe y es una carpeta (o un enlace a una carpeta), `ln` crea el enlace nuevo **dentro** de ella. `-f` (*force*) reemplaza un enlace que ya existe, y `-n` trata el enlace como un archivo y no entra en la carpeta a la que apunta:
   ```bash
   mkdir -p d/v1 d/v2
   ln -s v1 d/current
   ln -sf v2 d/current
   readlink d/current
   ls d/v1
   ln -sfn v2 d/current
   readlink d/current
   rm -r d
   ```
   ```text
   v1
   v2
   v2
   ```
   Con `-sf`, `current` sigue apuntando a `v1`, y el enlace nuevo acabó en `d/v1/v2`. Con `-sfn`, `current` pasa a `v2`.

7. **Arreglo 3: `ln -sfn`.** Cambia el `ln -s` del script por `ln -sfn`. Explica en un comentario encima de cada arreglo qué pasaba la segunda vez. Prueba desde cero: dos veces, y después con otra versión:
   ```bash
   rm -r app
   bash starter/setup-app.sh app
   bash starter/setup-app.sh app; echo $?
   cat app/config/app.conf
   ls -A app/releases/v1
   bash starter/setup-app.sh app v2
   readlink app/current
   ls app/releases
   rm -r app
   ```
   ```text
   app lista en app (versión v1)
   app lista en app (versión v1)
   0
   port=8080
   log_dir=app/logs
   app lista en app (versión v2)
   releases/v2
   v1
   v2
   ```
   `ls -A app/releases/v1` no imprime nada: ya no hay enlaces dentro. Con `v2`, el enlace cambia de versión y `v1` sigue ahí, para volver atrás con otro `setup-app.sh app v1`.

8. **shellcheck.**
   ```bash
   shellcheck starter/setup-app.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas por qué salir con `0` en el paso 3 era peor que fallar en el paso 2
- [ ] Explicas qué hace `-x` en `grep -qxF` y qué pasaría sin él (paso 4)
- [ ] Explicas por qué `ln -sf` no cambió el enlace en el paso 6 y `-n` sí
- [ ] Dos ejecuciones seguidas dejan `app.conf` con dos líneas y `releases/v1` vacía (paso 7)
- [ ] `shellcheck starter/setup-app.sh` no imprime nada

## Reto extra

Añade al script la copia de una plantilla, `cp plantilla.conf "$app/config/local.conf"`, sin pisar los cambios que alguien haya hecho a mano en `local.conf`. Mira en `cp --help` qué hace `--update=none` (la forma vieja, `-n`, avisa de que va a cambiar). ¿Es idempotente un script que **borra** algo (`rm "$app/logs/old.log"`)? ¿Qué opción de `rm` lo hace?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 06 — Logging por niveles](../lab-06-logging-por-niveles/README.md) | [Proyecto — bk-run robusto: opciones, temporales y bloqueo](../../3-proyecto/README.md) → |

[↑ Semana 11](../../README.md)
