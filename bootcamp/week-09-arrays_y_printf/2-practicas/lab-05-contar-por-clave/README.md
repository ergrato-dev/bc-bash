# Lab 05 — Contar por clave

⏱ Duración estimada: ~60 min

## Objetivo

Contar cuántas veces aparece cada valor de un log con un array asociativo, sin que `set -e` pare el script al primer conteo.

## Contexto

- Contar por clave es el uso más común de un array asociativo: una casilla por valor distinto, y cada línea suma 1 en la suya. Es lo que hacía `sort | uniq -c` (semana 04), pero dentro del script y sin lanzar otros programas.
- Sumar 1 tiene dos trampas. `((x++))` devuelve el valor **antiguo**, y si es `0`, `(( ))` sale con código 1: con `set -e`, el script para. Y `+=` sin `$(( ))` en un array asociativo **pega** textos en lugar de sumar.
- `datos/access.log` tiene 12 peticiones a un servidor web. `starter/status-count.sh` tiene que decir cuántas acabaron con cada código HTTP (`200` bien, `404` no existe, `500` error del servidor...).

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-09-arrays_y_printf/2-practicas/lab-05-contar-por-clave
   ```
   (sin salida).

1. **`((x++))` con `set -e`.** `bash -c '...'` ejecuta el texto en una bash nueva: así `set -e` no cierra la tuya.
   ```bash
   bash -c 'set -e; declare -A c; ((c[x]++)); echo "sigue"'; echo $?
   bash -c 'set -e; declare -A c; ((++c[x])); echo "sigue: ${c[x]}"'
   ```
   ```text
   1
   sigue: 1
   ```
   `c[x]++` vale lo que había antes de sumar, `0`, y `(( ))` con un resultado `0` es "falso": código 1, y `set -e` para sin decir nada. `++c[x]` vale lo de después, `1`. Funciona, pero depende de un detalle que nadie recuerda a las 3 de la mañana.

2. **`+=` pega textos.**
   ```bash
   declare -A d; d[x]+=1; d[x]+=1; echo "${d[x]}"
   declare -A e; e[x]=$((${e[x]:-0} + 1)); e[x]=$((${e[x]:-0} + 1)); echo "${e[x]}"
   ```
   ```text
   11
   2
   ```
   Fuera de `$(( ))`, `+=` añade texto al final: `1` y `1` dan `11`. La forma que siempre funciona es una asignación con `$(( ))`. `${e[x]:-0}` da `0` mientras la clave no existe; sin él, `set -u` pararía el script.

3. **El script, tal cual.** Abre `starter/status-count.sh` en tu editor. Mira el log y ejecútalo:
   ```bash
   head -n 2 datos/access.log
   bash starter/status-count.sh datos/access.log; echo $?
   ```
   ```text
   10.0.0.5 - - [08/Nov/2026:10:00:00 +0000] "GET / HTTP/1.1" 200 512 "-" "curl/8.5.0"
   10.0.0.7 - - [08/Nov/2026:10:05:00 +0000] "GET /login HTTP/1.1" 200 512 "-" "curl/8.5.0"
   1
   ```
   Separado por espacios, el código es el noveno campo. `read -r _ _ _ _ _ _ _ _ status _` lo guarda en `status`: cada `_` recoge un campo que no interesa, y el último, el resto de la línea. El script no imprime nada y sale con `1`: es el paso 1.

4. **TODO 1: sumar sin trampas.** Cambia la línea `((count[$status]++)) # TODO 1` por:
   ```bash
       # ((count[$status]++)) valdría 0 la primera vez y set -e pararía el script.
       count[$status]=$((${count[$status]:-0} + 1))
   ```
   Prueba:
   ```bash
   bash starter/status-count.sh datos/access.log; echo $?
   ```
   ```text
   declare -A count=([403]="2" [404]="2" [200]="6" [302]="1" [500]="1" )
   declare -- total="12"
   0
   ```
   `declare -p`, al final del script, enseña los contadores. Seis `200`, dos `403`, dos `404`: doce en total.

5. **TODO 2: de más a menos.** Borra los comentarios del `TODO 2` y del `TODO 3` y la línea `declare -p count total`, y escribe:
   ```bash
     # De más a menos: sort -rn ordena por el número del principio.
     for status in "${!count[@]}"; do
       echo "${count[$status]} $status"
     done | sort -rn
   ```
   Prueba:
   ```bash
   bash starter/status-count.sh datos/access.log
   ```
   ```text
   6 200
   2 404
   2 403
   1 500
   1 302
   ```
   Con el mismo número, `-r` también invierte el resto de la línea: `404` antes que `403`.

6. **TODO 3: el porcentaje.** Cambia el `echo` del bucle por:
   ```bash
       echo "${count[$status]} $status $((count[$status] * 100 / total))%"
   ```
   Dentro de `$(( ))`, `count[$status]` va sin `$` delante: es una cuenta. Multiplicar antes de dividir importa: `2 / 12` es `0` en una división entera, y `0 * 100` también. Prueba:
   ```bash
   bash starter/status-count.sh datos/access.log
   ```
   ```text
   6 200 50%
   2 404 16%
   2 403 16%
   1 500 8%
   1 302 8%
   ```
   Los porcentajes suman 98: la división entera tira los decimales de cada uno.

7. **shellcheck.**
   ```bash
   shellcheck starter/status-count.sh; echo $?
   ```
   ```text
   0
   ```
   shellcheck no avisa de `((count[$status]++))`: el código era correcto, y el fallo solo aparece con `set -e` y un `0`.

## Criterios de éxito

- [ ] Explicas por qué el script del paso 3 salió con `1` sin imprimir nada
- [ ] Explicas por qué `d[x]+=1` dos veces da `11` (paso 2)
- [ ] `bash starter/status-count.sh datos/access.log` imprime las cinco líneas del paso 6
- [ ] `shellcheck starter/status-count.sh` no imprime nada

## Reto extra

Cuenta también por IP (el primer campo) en un segundo array asociativo, y enseña la IP que más `4xx` provoca. Pista: `[[ $status == 4* ]]`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 04 — Arrays asociativos](../lab-04-arrays-asociativos/README.md) | [Lab 06 — printf y formatos](../lab-06-printf-y-formatos/README.md) → |

[↑ Semana 09](../../README.md)
