# Lab 06 — Aritmética

⏱ Duración estimada: ~60 min

## Objetivo

Hacer cuentas con enteros en `$(( ))`, y evitar las tres trampas de la aritmética de bash: la división entera, el `((n++))` con `set -e` y los números que empiezan por `0`.

## Contexto

- `$(( expresión ))` calcula y se sustituye por el resultado, como `$variable` se sustituye por su valor. `(( expresión ))`, sin el `$`, calcula y solo da un código de salida ([teoría](../../1-teoria/04-aritmetica-y-sustitucion-de-comandos.md)).
- bash solo sabe de **enteros**: no hay decimales, y `7 / 2` es `3`.
- `starter/disk-alert.sh` calcula cuánto ocupa un disco y cuándo se llenará. Cae en las tres trampas.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-05-variables_comillas_y_expansiones/2-practicas/lab-06-aritmetica
   ```
   (sin salida).

1. **Calcular:**
   ```bash
   echo $(( 2 + 3 * 4 ))
   echo $(( (2 + 3) * 4 ))
   echo 2 + 3
   ```
   ```text
   14
   20
   2 + 3
   ```
   Dentro de `$(( ))`, `*` multiplica antes de que `+` sume, como en matemáticas; los paréntesis cambian el orden. Fuera, `2 + 3` son tres palabras para `echo`.

2. **Solo enteros:**
   ```bash
   echo $(( 7 / 2 ))
   echo $(( 7 % 2 ))
   echo $(( 10 / 3 * 3 ))
   echo $(( 10 * 3 / 3 ))
   echo $(( 2 ** 10 ))
   ```
   ```text
   3
   1
   9
   10
   1024
   ```
   `/` descarta los decimales y `%` da el resto. Por eso el orden importa: `10 / 3` ya es `3`, y por `3` da `9`. Multiplicando primero no se pierde nada. `**` es la potencia.

3. **Variables dentro:**
   ```bash
   n=5
   echo $(( n * 2 ))
   n=$(( n + 1 ))
   echo "$n"
   x=hola
   echo $(( x + 1 ))
   ```
   ```text
   10
   6
   1
   ```
   Dentro de `$(( ))`, los nombres no necesitan `$`. `n=$(( n + 1 ))` es la forma clara de sumar uno. Cuidado: un texto que no es un número no da error. `hola` se toma por el nombre de otra variable, que no existe y vale `0`.

4. **Sin decimales:**
   ```bash
   echo $(( 5 / 2.0 ))
   echo $?
   ```
   ```text
   bash: 5 / 2.0 : syntax error: invalid arithmetic operator (error token is ".0 ")
   1
   ```
   El `.` no existe en la aritmética de bash. El laboratorio no trae `bc`, la calculadora clásica; para decimales usarás `awk` en la semana 10.

5. **`(( ))` como condición:**
   ```bash
   (( 5 > 3 )); echo $?
   (( 0 )); echo $?
   n=0
   (( n++ )); echo "$? $n"
   (( n++ )); echo "$? $n"
   ```
   ```text
   0
   1
   1 1
   0 2
   ```
   `(( ))` sale con `0` si el resultado no es cero, y con `1` si es cero: como "verdadero" y "falso". `n++` suma uno a `n`, pero el resultado de la expresión es el valor **de antes**. La primera vez es `0`, así que `(( n++ ))` sale con `1`, aunque haya sumado. Con `set -e`, eso para el script.

6. **Los números que empiezan por `0`:**
   ```bash
   echo $(( 010 ))
   echo $(( 08 ))
   echo $(( 10#08 ))
   ```
   ```text
   8
   bash: 08: value too great for base (error token is "08")
   8
   ```
   Un `0` delante significa octal, en base 8: `010` es `8`, y `08` no existe porque en octal no hay cifra `8`. Pasa con las horas, los días y los meses que da `date` (`08`, `09`). `10#` delante dice "este número está en base 10".

7. **El script, sin tocar:**
   ```bash
   bash starter/disk-alert.sh
   echo $?
   ```
   ```text
   uso: 0%
   1
   ```
   Dos fallos: el disco está al 86% y dice `0%`, y el script para justo después, sin ningún mensaje.

8. **TODO 1.** `usado_mb / total_mb` es `4300 / 5000`, que en enteros es `0`, y por `100` sigue siendo `0` (paso 2). Abre `starter/disk-alert.sh` en tu editor y cambia el orden: primero `usado_mb * 100`, después `/ total_mb`. Borra el comentario del `TODO 1`. Prueba:
   ```bash
   bash starter/disk-alert.sh
   echo $?
   ```
   ```text
   uso: 86%
   1
   ```
   El porcentaje ya sale. El script sigue parando sin mensaje.

9. **TODO 2.** Es el `((comprobaciones++))` del paso 5: `comprobaciones` vale `0`, así que sale con `1` y `set -e` para el script. Cámbialo por `comprobaciones=$(( comprobaciones + 1 ))`, que es una asignación y sale con `0`. Borra el comentario del `TODO 2`. Prueba:
   ```bash
   bash starter/disk-alert.sh
   echo $?
   ```
   ```text
   uso: 86%
   libre: 700 MB
   starter/disk-alert.sh: line 20: 08: value too great for base (error token is "08")
   comprobaciones: 1
   0
   ```
   Llega al final, pero con un error del paso 6, y **sale con `0`**: un error dentro de `$(( ))` cancela ese comando y el script sigue, sin que `set -e` lo pare. La semana 11 trata estos límites de `set -e`.

10. **TODO 3.** Sustituye el comentario del `TODO 3` por dos líneas: un `echo` que imprima `se llena en N días`, con `N` igual a `libre_mb` entre `crecimiento_mb` dentro de `$(( ))`, y otra suma de `comprobaciones` como la del TODO 2. Prueba:
    ```bash
    bash starter/disk-alert.sh | tail -2
    ```
    ```text
    starter/disk-alert.sh: line 21: 08: value too great for base (error token is "08")
    se llena en 20 días
    comprobaciones: 2
    ```
    Con `| tail -2` el error del paso 9 sigue en pantalla, y sale el primero: va por stderr y no pasa por el pipe (semana 03), así que no espera a `tail`.

11. **TODO 4.** Pon `10#` delante de `$hora` en la cuenta de la hora (paso 6). `10#$hora` funciona porque bash sustituye primero `$hora` por `08` y después calcula `10#08`. Borra los comentarios `TODO`. Prueba:
    ```bash
    bash starter/disk-alert.sh
    echo $?
    ```
    ```text
    uso: 86%
    libre: 700 MB
    se llena en 20 días
    próxima comprobación: a las 9
    comprobaciones: 2
    0
    ```

## Criterios de éxito

- [ ] Explicas por qué `$(( 4300 / 5000 * 100 ))` da `0` y cómo arreglarlo sin decimales (paso 8)
- [ ] Explicas por qué `(( n++ ))` con `n=0` sale con `1` y qué hace eso con `set -e` (paso 5)
- [ ] Explicas por qué `08` da error y `07` no (paso 6)
- [ ] `bash starter/disk-alert.sh` imprime las cinco líneas del paso 11, sin errores, y sale con `0`

## Reto extra

El porcentaje real es 86,0 y bash dice `86`, pero con `usado_mb=4349` el real sería 86,98 y bash seguiría diciendo `86`: la división entera corta, no redondea. ¿Qué número tendrías que sumar a `usado_mb * 100` antes de dividir entre `total_mb` para que redondee al entero más cercano? Pruébalo con `4349` y con `4320`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 05 — Recortar y sustituir](../lab-05-recortar-y-sustituir/README.md) | [Lab 07 — Sustitución de comandos](../lab-07-sustitucion-de-comandos/README.md) → |

[↑ Semana 05](../../README.md)
