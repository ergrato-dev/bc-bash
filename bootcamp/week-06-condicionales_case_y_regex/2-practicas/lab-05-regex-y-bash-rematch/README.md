# Lab 05 — Regex y BASH_REMATCH

⏱ Duración estimada: ~60 min

## Objetivo

Comprobar el formato de un texto con `=~` y sacar sus partes con `BASH_REMATCH`, sin `grep` ni `cut`.

## Contexto

- `[[ texto =~ regex ]]` sale con `0` si el texto encaja con la regex extendida, la misma de `grep -E` (semana 04) ([teoría](../../1-teoria/04-regex-y-argumentos.md)).
- Lo que va entre comillas a la derecha de `=~` es texto literal. Por eso la regex se guarda en una variable y se escribe sin comillas: `[[ $f =~ $re ]]`.
- `starter/parse-date.sh` separa una fecha `AAAA-MM-DD` en año, mes y día, y rechaza las mal escritas. Tiene cuatro TODOs.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-06-condicionales_case_y_regex/2-practicas/lab-05-regex-y-bash-rematch
   ```
   (sin salida).

1. **Encajar con una regex.** `[0-9]+` es "una o más cifras"; `^` y `$`, el principio y el final del texto:
   ```bash
   [[ 2026 =~ ^[0-9]+$ ]]; echo $?
   [[ 20x6 =~ ^[0-9]+$ ]]; echo $?
   ```
   ```text
   0
   1
   ```

2. **Sin anclas, basta un trozo.** `=~` busca la regex en cualquier parte del texto, como `grep`:
   ```bash
   [[ x2026y =~ [0-9]+ ]]; echo $?
   [[ x2026y =~ ^[0-9]+$ ]]; echo $?
   ```
   ```text
   0
   1
   ```
   Para validar un formato, siempre `^...$`: si no, `x2026y` "es un número".

3. **Las comillas hacen literal.** `\.` es un punto de verdad; `.` sin `\`, cualquier carácter:
   ```bash
   f=access.log
   [[ $f =~ \.log$ ]]; echo $?
   [[ $f =~ "\.log$" ]]; echo $?
   [[ $f =~ ".log"$ ]]; echo $?
   [[ accessXlog =~ .log$ ]]; echo $?
   ```
   ```text
   0
   1
   0
   0
   ```
   La segunda busca el texto `\.log$`, con su barra y su dólar. La tercera cita solo `.log`: el punto queda literal y el `$` sigue siendo el final. La cuarta muestra el punto sin `\`, que también encaja con la `X`.

4. **La regex en una variable.** Con paréntesis o `|`, escribirla directamente dentro de `[[ ]]` funciona, pero cuesta leerla y es fácil equivocarse con los caracteres especiales. Guárdala con comillas simples y úsala sin comillas:
   ```bash
   re='^(a|b)+$'
   [[ abba =~ $re ]]; echo $?
   [[ abba =~ ^(a|b)+$ ]]; echo $?
   [[ abba =~ "$re" ]]; echo $?
   ```
   ```text
   0
   0
   1
   ```
   Con comillas, `"$re"` vuelve a ser texto literal: busca `^(a|b)+$` con sus paréntesis. shellcheck lo marca como `SC2076`.

5. **`BASH_REMATCH`, las partes.** Cada paréntesis de la regex es un grupo. Si encaja, bash guarda en la lista `BASH_REMATCH` el texto entero (elemento `0`) y lo de cada grupo (`1`, `2`...), en el orden de sus `(`:
   ```bash
   re='^([a-z]+)@([a-z.]+)$'
   [[ ana@example.com =~ $re ]]; echo $?
   echo "${BASH_REMATCH[0]}"
   echo "${BASH_REMATCH[1]}"
   echo "${BASH_REMATCH[2]}"
   ```
   ```text
   0
   ana@example.com
   ana
   example.com
   ```
   `${BASH_REMATCH[1]}` es "el elemento 1 de la lista". Las listas (arrays) llegan en la semana 09; por ahora, solo las lees así.

6. **Si no encaja, se vacía.**
   ```bash
   [[ nada =~ $re ]]; echo $?
   echo "[${BASH_REMATCH[1]}]"
   ```
   ```text
   1
   []
   ```
   Lee `BASH_REMATCH` solo justo después de un `=~` que encajó: el siguiente `=~` lo sobrescribe.

7. **Cifras con un cero delante.** Lo que saca la regex es texto: `08`. En `$(( ))`, un número que empieza por `0` se lee en octal, y `8` no existe en octal (semana 05, lab 06). `10#` obliga a leerlo en base 10:
   ```bash
   m=08
   echo $(( m + 1 ))
   echo $(( 10#$m + 1 ))
   ```
   ```text
   bash: 08: value too great for base (error token is "08")
   9
   ```

8. **El script y el TODO 1.**
   ```bash
   bash starter/parse-date.sh 2026-11-08
   ```
   ```text
   sin implementar: 2026-11-08
   ```
   Abre `starter/parse-date.sh` en tu editor. Sustituye el comentario del `TODO 1` por la regex, con tres grupos (cuatro cifras, dos y dos), y el `if` que rechaza lo que no encaja:
   ```bash
   re='^([0-9]{4})-([0-9]{2})-([0-9]{2})$'
   if [[ ! $date_in =~ $re ]]; then
     echo "fecha mal escrita: '$date_in' (usa AAAA-MM-DD)" >&2
     exit 1
   fi
   ```
   `{4}` es "exactamente cuatro veces" (semana 04). Prueba:
   ```bash
   bash starter/parse-date.sh 2026-1-8; echo $?
   bash starter/parse-date.sh x2026-11-08; echo $?
   bash starter/parse-date.sh 2026-11-08
   ```
   ```text
   fecha mal escrita: '2026-1-8' (usa AAAA-MM-DD)
   1
   fecha mal escrita: 'x2026-11-08' (usa AAAA-MM-DD)
   1
   sin implementar: 2026-11-08
   ```

9. **TODO 2.** Sustituye el comentario del `TODO 2` por tres asignaciones desde `BASH_REMATCH`: `year="${BASH_REMATCH[1]}"`, y lo mismo con `month` (grupo 2) y `day` (grupo 3). Cambia el `echo` del final por `echo "año $year, mes $month, día $day"`. Prueba:
   ```bash
   bash starter/parse-date.sh 2026-11-08
   bash starter/parse-date.sh 2026-13-01
   ```
   ```text
   año 2026, mes 11, día 08
   año 2026, mes 13, día 01
   ```
   El formato es correcto, pero no hay mes 13. Una regex comprueba la forma; los rangos, mejor con números.

10. **TODO 3.** Sustituye el comentario del `TODO 3` por un `if` con `(( ))`, donde `||` es "o":
    ```bash
    if (( 10#$month < 1 || 10#$month > 12 )); then
      echo "mes fuera de rango: '$date_in'" >&2
      exit 1
    fi
    ```
    Prueba:
    ```bash
    bash starter/parse-date.sh 2026-13-01; echo $?
    bash starter/parse-date.sh 2026-00-10; echo $?
    bash starter/parse-date.sh 2026-08-09
    ```
    ```text
    mes fuera de rango: '2026-13-01'
    1
    mes fuera de rango: '2026-00-10'
    1
    año 2026, mes 08, día 09
    ```
    Sin `10#`, `2026-08-09` daría el error del paso 7.

11. **TODO 4.** Lo mismo para el día, entre 1 y 31, con el mensaje `día fuera de rango: '<fecha>'`. Borra los comentarios de los TODOs. Prueba:
    ```bash
    bash starter/parse-date.sh 2026-02-32; echo $?
    bash starter/parse-date.sh 2026-02-00; echo $?
    bash starter/parse-date.sh 2026-11-08; echo $?
    ```
    ```text
    día fuera de rango: '2026-02-32'
    1
    día fuera de rango: '2026-02-00'
    1
    año 2026, mes 11, día 08
    0
    ```

## Criterios de éxito

- [ ] Explicas por qué `[[ $f =~ "\.log$" ]]` no encaja con `access.log` (paso 3)
- [ ] Explicas por qué la regex va en una variable y sin comillas (paso 4)
- [ ] `bash starter/parse-date.sh 2026-11-08` imprime `año 2026, mes 11, día 08`
- [ ] `2026-1-8`, `2026-13-01` y `2026-02-32` salen con `1` y un mensaje en stderr

## Reto extra

`2026-02-30` pasa, y febrero nunca tiene 30 días. `date -d 2026-02-30` falla porque no existe: úsalo en un `if` (lab 01) para rechazarla. ¿Sobra entonces el TODO 4?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 04 — case](../lab-04-case/README.md) | [Lab 06 — Argumentos](../lab-06-argumentos/README.md) → |

[↑ Semana 06](../../README.md)
