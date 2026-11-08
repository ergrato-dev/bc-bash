# Lab 06 — jq: leer JSON

⏱ Duración estimada: ~60 min

## Objetivo

Sacar valores de un JSON con los filtros de `jq` (`.campo`, `.[]`, `select`) y llevarlos a bash con `-r`.

## Contexto

- **JSON** es el formato en que hablan casi todas las APIs y herramientas modernas (`docker inspect`, `kubectl -o json`, `gh --json`). Tiene objetos `{"clave": valor}`, arrays `[1, 2]`, textos entre comillas dobles, números, `true`, `false` y `null`.
- `jq` lee JSON y le aplica un **filtro**. `.` es todo el documento; `.host`, su campo `host`; `|` pasa el resultado al siguiente filtro, como el pipe de bash.
- `datos/servicios.json` es el informe de los servicios de una máquina. `starter/down-services.sh` tiene que decir cuáles no están en marcha y salir con `1` si hay alguno.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-10-sed_awk_y_jq/2-practicas/lab-06-jq-leer-json
   ```
   (sin salida).

1. **Mirar el JSON.**
   ```bash
   cat datos/servicios.json
   jq . datos/servicios.json | head -n 4
   ```
   ```text
   {"host": "web-01", "actualizado": "2026-11-08T10:30:00+00:00", "servicios": [
     {"nombre": "nginx", "estado": "running", "puertos": [80, 443], "reinicios": 0},
     {"nombre": "postgres", "estado": "running", "puertos": [5432], "reinicios": 2},
     {"nombre": "worker", "estado": "exited", "puertos": [], "reinicios": 7},
     {"nombre": "redis", "estado": "restarting", "puertos": [6379], "reinicios": 31}
   ]}
   {
     "host": "web-01",
     "actualizado": "2026-11-08T10:30:00+00:00",
     "servicios": [
   ```
   `jq .` lo escribe sangrado, un valor por línea: así se lee un JSON que llega en una sola línea.

2. **Un campo, con y sin comillas.**
   ```bash
   jq .host datos/servicios.json
   jq -r .host datos/servicios.json
   ```
   ```text
   "web-01"
   web-01
   ```
   Sin `-r`, `jq` escribe JSON: un texto, con sus comillas. Con `-r` (*raw*), el texto a secas: lo que quieres guardar en una variable de bash.

3. **Dentro de un array.**
   ```bash
   jq -c '.servicios[0]' datos/servicios.json
   jq -r '.servicios[0].puertos[1], (.servicios | length)' datos/servicios.json
   jq -r '.servicios[].nombre' datos/servicios.json
   ```
   ```text
   {"nombre":"nginx","estado":"running","puertos":[80,443],"reinicios":0}
   443
   4
   nginx
   postgres
   worker
   redis
   ```
   `[0]` es el primer elemento; `-c` escribe cada resultado en una sola línea. `length` cuenta los elementos; la coma da dos resultados, uno detrás de otro. `.servicios[]` sin número saca **cada** elemento por separado, y lo que va detrás se aplica a cada uno.

4. **Filtrar con `select`.**
   ```bash
   jq -c '.servicios[] | select(.reinicios > 5) | {nombre, reinicios}' datos/servicios.json
   ```
   ```text
   {"nombre":"worker","reinicios":7}
   {"nombre":"redis","reinicios":31}
   ```
   `select(condición)` deja pasar el elemento si la condición es verdad, y lo descarta si no: es el `grep` de jq. `{nombre, reinicios}` construye un objeto con solo esos dos campos.

5. **Textos con valores dentro, y sumas.**
   ```bash
   jq -r '.servicios[] | "\(.nombre) tiene \(.puertos | length) puertos"' datos/servicios.json
   jq '[.servicios[].reinicios] | add' datos/servicios.json
   ```
   ```text
   nginx tiene 2 puertos
   postgres tiene 1 puertos
   worker tiene 0 puertos
   redis tiene 1 puertos
   40
   ```
   Dentro de un texto de jq, `\( )` pone el resultado de un filtro, como `$( )` en bash. Los `[ ]` de fuera juntan los resultados en un array, y `add` los suma.

6. **Un campo que no existe.**
   ```bash
   jq .nada datos/servicios.json; echo $?
   jq -e .nada datos/servicios.json; echo $?
   ```
   ```text
   null
   0
   null
   1
   ```
   Un campo que no existe es `null`, y `jq` sale con `0`. Con `-e`, sale con `1` si el último resultado es `null` o `false`: sirve en un `if`.

7. **El script, tal cual.** Abre `starter/down-services.sh` en tu editor y ejecútalo:
   ```bash
   bash starter/down-services.sh datos/servicios.json
   ```
   ```text
   declare -a down=([0]="{\"nombre\":\"nginx\",\"estado\":\"running\",\"puertos\":[80,443],\"reinicios\":0}" [1]="{\"nombre\":\"postgres\",\"estado\":\"running\",\"puertos\":[5432],\"reinicios\":2}" [2]="{\"nombre\":\"worker\",\"estado\":\"exited\",\"puertos\":[],\"reinicios\":7}" [3]="{\"nombre\":\"redis\",\"estado\":\"restarting\",\"puertos\":[6379],\"reinicios\":31}")
   ```
   `mapfile` guarda cada línea que escribe `jq` en un elemento del array `down` (semana 07), y `declare -p` lo enseña. Hay cuatro servicios enteros: falta elegir.

8. **TODO 1: los que no están en marcha.** Cambia el filtro `'.servicios[]'` y su `-c` por:
   ```bash
   jq -r '.servicios[] | select(.estado != "running") | .nombre'
   ```
   `!=` es "distinto de". Prueba:
   ```bash
   bash starter/down-services.sh datos/servicios.json
   ```
   ```text
   declare -a down=([0]="worker" [1]="redis")
   ```

9. **TODO 2: con su estado.** Cambia el `.nombre` del final del filtro por:
   ```bash
   "\(.nombre): \(.estado) (\(.reinicios) reinicios)"
   ```
   Prueba:
   ```bash
   bash starter/down-services.sh datos/servicios.json
   ```
   ```text
   declare -a down=([0]="worker: exited (7 reinicios)" [1]="redis: restarting (31 reinicios)")
   ```

10. **TODO 3: avisar.** Cambia el comentario del `TODO 3` y el `declare -p down` por:
    ```bash
    if ((${#down[@]} == 0)); then
      echo "todo en marcha"
      exit 0
    fi
    printf '%s\n' "${down[@]}"
    exit 1
    ```
    `${#down[@]}` es cuántos elementos tiene (semana 09). Borra los comentarios de los TODO y explica en uno por qué `-r`. Prueba:
    ```bash
    bash starter/down-services.sh datos/servicios.json; echo $?
    ```
    ```text
    worker: exited (7 reinicios)
    redis: restarting (31 reinicios)
    1
    ```

11. **shellcheck.**
    ```bash
    shellcheck starter/down-services.sh; echo $?
    ```
    ```text
    0
    ```

## Criterios de éxito

- [ ] Explicas qué cambia `-r` (paso 2)
- [ ] Explicas qué hace `.servicios[]` sin número y qué deja pasar `select` (pasos 3 y 4)
- [ ] Explicas por qué `jq .nada` sale con `0` y qué cambia `-e` (paso 6)
- [ ] `bash starter/down-services.sh datos/servicios.json` imprime las dos líneas del paso 10 y sale con `1`
- [ ] `shellcheck starter/down-services.sh` no imprime nada

## Reto extra

Haz que el script reciba el JSON por stdin si no le das archivo, para usarlo así: `docker compose ps --format json | ...`. ¿Qué te dice `jq` si el JSON que le llega está roto, y con qué código sale?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 05 — awk y las variables de bash](../lab-05-awk-y-variables-de-bash/README.md) | [Lab 07 — JSON roto](../lab-07-json-roto/README.md) → |

[↑ Semana 10](../../README.md)
