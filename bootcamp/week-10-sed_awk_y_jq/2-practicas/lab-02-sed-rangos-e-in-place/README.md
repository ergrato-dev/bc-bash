# Lab 02 — sed: rangos, borrar e in-place

⏱ Duración estimada: ~60 min

## Objetivo

Elegir a qué líneas aplica `sed` sus cambios con direcciones y rangos, y cambiar un archivo con `sed -i` guardando una copia del original.

## Contexto

- Delante de un comando de `sed` puede ir una **dirección**: un número de línea, una regex entre `/` o un **rango** `inicio,fin`. El comando solo se aplica a las líneas que encajan.
- `sed -i` (*in place*) escribe el resultado en el mismo archivo en lugar de en stdout. No hay papelera: con `-i.bak` guarda antes el original en `archivo.bak`.
- `datos/app.conf` tiene dos secciones, `[server]` y `[database]`, y cada una su `port=`. `starter/set-port.sh` cambia el de una sección. Todo lo que modifica el archivo se hace sobre una copia en `mktemp -d`.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-10-sed_awk_y_jq/2-practicas/lab-02-sed-rangos-e-in-place
   ```
   (sin salida).

1. **Por número de línea.**
   ```bash
   sed -n 3p datos/app.conf
   sed -n 2,4p datos/app.conf
   ```
   ```text
   port=8080
   [server]
   port=8080
   workers=2
   ```

2. **Desde una regex.**
   ```bash
   sed -n '/^\[database\]/,$p' datos/app.conf
   ```
   ```text
   [database]
   host=localhost
   port=5432
   ```
   El rango empieza en la primera línea que encaja con la regex y sigue hasta `$`, la última. `\[` es un corchete de verdad: sin `\`, `[database]` sería "una de las letras d, a, t...".

3. **Borrar líneas.**
   ```bash
   sed '/^#/d; /^$/d' datos/app.conf
   ```
   ```text
   [server]
   port=8080
   workers=2
   [database]
   host=localhost
   port=5432
   ```
   `d` borra la línea de la salida. `;` separa dos comandos: aquí, los comentarios y las líneas vacías (`^$`, nada entre el principio y el final).

4. **Un rango entre dos regex.**
   ```bash
   sed -n '/^\[server\]/,/^\[/p' datos/app.conf
   ```
   ```text
   [server]
   port=8080
   workers=2

   [database]
   ```
   De `[server]` a la siguiente línea que empieza por `[`. Las dos de los extremos entran en el rango: aquí no importa, porque `[database]` no tiene un `port=`.

5. **`-i` y `-i.bak`.** `mktemp -d` crea una carpeta temporal y escribe su ruta (semana 07):
   ```bash
   d=$(mktemp -d)
   cp datos/app.conf "$d"/
   sed -i 's/workers=2/workers=4/' "$d/app.conf"
   grep workers "$d/app.conf"
   ls "$d"
   sed -i.bak 's/workers=4/workers=8/' "$d/app.conf"
   ls "$d"
   grep workers "$d"/*
   rm -r "$d"
   ```
   Algo como (cambia el nombre de la carpeta):
   ```text
   workers=4
   app.conf
   app.conf
   app.conf.bak
   /tmp/tmp.mdgI2UA6Ha/app.conf:workers=8
   /tmp/tmp.mdgI2UA6Ha/app.conf.bak:workers=4
   ```
   Con `-i` a secas, `sed` no escribe nada en pantalla: el cambio va al archivo. Con `-i.bak`, el `.bak` tiene el archivo de antes del cambio.

6. **El script, tal cual.** Abre `starter/set-port.sh` en tu editor y ejecútalo sobre una copia:
   ```bash
   d=$(mktemp -d)
   cp datos/app.conf "$d"/
   bash starter/set-port.sh "$d/app.conf" server 9090
   grep -n port= "$d/app.conf"
   ```
   ```text
   3:port=9090
   8:port=9090
   ```
   `-n` de `grep` pone el número de línea. Has cambiado también el puerto de la base de datos: con esta configuración, la aplicación ya no la encuentra.

7. **TODO 1: solo en su sección.** Cambia la línea de `sed` por:
   ```bash
   sed -i "/^\[$section\]/,/^\[/ s/^port=.*/port=$port/" "$file"
   ```
   El rango del paso 4, con la sección del argumento, delante de la `s`. Comillas dobles, para que bash ponga el valor de `$section` y `$port` antes de que `sed` lea el programa: por eso el script solo acepta letras y dígitos, que no pueden romper la regex. Prueba con una copia limpia:
   ```bash
   cp datos/app.conf "$d"/
   bash starter/set-port.sh "$d/app.conf" server 9090
   grep -n port= "$d/app.conf"
   ```
   ```text
   3:port=9090
   8:port=5432
   ```

8. **TODO 2: una copia del original.** Cambia `sed -i` por `sed -i.bak` en esa línea. Prueba:
   ```bash
   cp datos/app.conf "$d"/
   bash starter/set-port.sh "$d/app.conf" server 9090
   ls "$d"
   diff "$d/app.conf.bak" "$d/app.conf"
   ```
   ```text
   app.conf
   app.conf.bak
   3c3
   < port=8080
   ---
   > port=9090
   ```
   `diff` enseña lo que cambió: la línea 3, de `8080` a `9090`.

9. **TODO 3: una sección que no existe.**
   ```bash
   bash starter/set-port.sh "$d/app.conf" cache 6379; echo $?
   ```
   ```text
   0
   ```
   Ninguna línea encaja con el rango, `sed` no cambia nada y sale con `0`: un despliegue creería que el puerto ya está cambiado. Cambia el comentario del `TODO 3` por:
   ```bash
   # Sin la sección, sed no cambiaría nada y saldría con 0: el despliegue creería que funcionó.
   grep -qx "\[$section\]" "$file" || { echo "set-port.sh: no hay sección [$section] en $file" >&2; exit 1; }
   ```
   `-x` exige que la línea entera sea `[cache]`. Borra los comentarios de los `TODO 1` y `TODO 2` y explica en uno por qué el rango y por qué `.bak`. Prueba:
   ```bash
   bash starter/set-port.sh "$d/app.conf" cache 6379; echo $?
   bash starter/set-port.sh "$d/app.conf" server 80/x; echo $?
   rm -r "$d"
   ```
   Algo como (cambia el nombre de la carpeta):
   ```text
   set-port.sh: no hay sección [cache] en /tmp/tmp.36hpfpfcqQ/app.conf
   1
   set-port.sh: '80/x' no es un puerto
   2
   ```

10. **shellcheck.**
    ```bash
    shellcheck starter/set-port.sh; echo $?
    ```
    ```text
    0
    ```

## Criterios de éxito

- [ ] Explicas qué líneas entran en el rango `/^\[server\]/,/^\[/` (paso 4)
- [ ] Explicas por qué el script del paso 6 rompía la configuración de la base de datos
- [ ] Explicas por qué `sed` sale con `0` aunque no cambie nada (paso 9)
- [ ] `bash starter/set-port.sh <copia> server 9090` cambia solo la línea 3 y deja `app.conf.bak` (paso 8)
- [ ] `shellcheck starter/set-port.sh` no imprime nada

## Reto extra

Haz que, si la sección existe pero no tiene `port=`, el script lo añada debajo de la línea `[sección]`. Pista: el comando `a` de `sed` añade una línea detrás de la dirección (`/^\[cache\]/a port=6379`). ¿Cómo sabes antes si ya hay un `port=` en esa sección?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 01 — sed: sustituir](../lab-01-sed-sustituir/README.md) | [Lab 03 — awk: campos y patrones](../lab-03-awk-campos/README.md) → |

[↑ Semana 10](../../README.md)
