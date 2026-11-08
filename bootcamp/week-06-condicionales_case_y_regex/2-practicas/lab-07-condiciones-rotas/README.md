# Lab 07 — Condiciones rotas

⏱ Duración estimada: ~60 min

## Objetivo

Encontrar y arreglar con shellcheck los cuatro fallos típicos de las condiciones de un script que no da ningún error, pero responde mal.

## Contexto

- Una condición mal escrita casi nunca para el script: da `0` o `1` equivocado, y el script sigue por la rama que no era. Los fallos de los labs 02 a 05 tienen esa forma.
- `shellcheck` lee un script sin ejecutarlo y avisa de esos fallos, con un código `SC` que puedes buscar en su wiki ([webgrafía](../../4-recursos/webgrafia/README.md)).
- `starter/validate-user.sh` comprueba si un texto sirve como nombre de usuario Linux. Viene **roto a propósito**: cuatro condiciones fallan, cada una marcada con un TODO.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-06-condicionales_case_y_regex/2-practicas/lab-07-condiciones-rotas
   ```
   (sin salida).

1. **Las reglas.** Abre `starter/validate-user.sh` en tu editor y lee el comentario de arriba: de 3 a 16 caracteres, empieza por minúscula, después minúsculas, cifras, `_` o `-`, y ni `root` ni `admin`. Escribe en un papel qué debería responder para `ana`, `ana maria`, `Ana`, `ab` y `root`.

2. **Lo que responde.**
   ```bash
   bash starter/validate-user.sh ana; echo $?
   bash starter/validate-user.sh "ana maria"; echo $?
   bash starter/validate-user.sh Ana
   bash starter/validate-user.sh root
   bash starter/validate-user.sh; echo $?
   ls
   ```
   ```text
   no: 'ana' tiene que tener de 3 a 16 caracteres
   1
   starter/validate-user.sh: line 10: [: ana: binary operator expected
   no: 'ana maria' tiene que tener de 3 a 16 caracteres
   1
   no: 'Ana' tiene que tener de 3 a 16 caracteres
   no: 'root' tiene que tener de 3 a 16 caracteres
   uso: validate-user.sh <nombre>
   2
   16
   solucion
   starter
   ```
   Todo se rechaza por la longitud, y apareció un archivo `16`. Solo el uso funciona.

3. **Lo que ve shellcheck.**
   ```bash
   shellcheck starter/validate-user.sh
   ```
   ```text

   In starter/validate-user.sh line 10:
   if [ -z $name ]; then
           ^---^ SC2086 (info): Double quote to prevent globbing and word splitting.

   Did you mean:
   if [ -z "$name" ]; then


   In starter/validate-user.sh line 16:
   if [ ${#name} -lt 3 -o ${#name} > 16 ]; then
                       ^-- SC2166 (warning): Prefer [ p ] || [ q ] as [ p -o q ] is not well defined.
                                   ^-- SC2071 (error): > is for string comparisons. Use -gt instead.


   In starter/validate-user.sh line 22:
   if [[ ! $name =~ "^[a-z][a-z0-9_-]*$" ]]; then
                    ^------------------^ SC2076 (warning): Remove quotes from right-hand side of =~ to match as a regex rather than literally.


   In starter/validate-user.sh line 29:
     *) echo "ok: $name" ;;
     ^-- SC2221 (warning): This pattern always overrides a later one on line 30.


   In starter/validate-user.sh line 30:
     root | admin)
     ^--^ SC2222 (warning): This pattern never matches because of a previous pattern on line 29.

   For more information:
     https://www.shellcheck.net/wiki/SC2071 -- > is for string comparisons. Use ...
     https://www.shellcheck.net/wiki/SC2076 -- Remove quotes from right-hand sid...
     https://www.shellcheck.net/wiki/SC2166 -- Prefer [ p ] || [ q ] as [ p -o q...
   ```
   Cada aviso dice la línea, señala con `^` el trozo y explica el problema. Uno por TODO.

4. **TODO 1, línea 10.** Con `ana maria`, `[ -z $name ]` recibe `-z`, `ana` y `maria`: el error `binary operator expected` del paso 2 (lab 02, paso 5). Cambia la condición por `[[ -z $name ]]`. Borra el comentario del `TODO 1`. Prueba:
   ```bash
   bash starter/validate-user.sh "ana maria"
   ```
   ```text
   no: 'ana maria' tiene que tener de 3 a 16 caracteres
   ```
   El error de `[` desapareció. La respuesta sigue mal: es el TODO 2.

5. **TODO 2, línea 16.** Dos fallos en una línea: `> 16` es una redirección que crea el archivo `16` (lab 02, paso 7), y lo que queda, `[ 3 -lt 3 -o 3 ]`, siempre se cumple porque `3` no está vacío. `-o` ("o" dentro de `[ ]`) está obsoleto. Cambia la línea por:
   ```bash
   if [[ ${#name} -lt 3 || ${#name} -gt 16 ]]; then
   ```
   `${#name}` es la longitud (semana 05). Borra el comentario del `TODO 2` y el archivo `16`. Prueba:
   ```bash
   rm 16
   bash starter/validate-user.sh ab
   bash starter/validate-user.sh ana
   ls
   ```
   ```text
   no: 'ab' tiene que tener de 3 a 16 caracteres
   no: 'ana' solo puede tener minúsculas, cifras, _ y -, y empezar por letra
   solucion
   starter
   ```
   `ab` ya se rechaza por lo que toca y no aparece el `16`. `ana` cae en la regex: el TODO 3.

6. **TODO 3, línea 22.** Con comillas, `=~` busca el texto `^[a-z][a-z0-9_-]*$` literal, y ningún nombre lo contiene (lab 05, paso 4). Guarda la regex en una variable y úsala sin comillas: sustituye la línea del `if` por estas dos.
   ```bash
   re='^[a-z][a-z0-9_-]*$'
   if [[ ! $name =~ $re ]]; then
   ```
   Borra el comentario del `TODO 3`. Prueba:
   ```bash
   bash starter/validate-user.sh ana
   bash starter/validate-user.sh Ana
   bash starter/validate-user.sh root
   ```
   ```text
   ok: ana
   no: 'Ana' solo puede tener minúsculas, cifras, _ y -, y empezar por letra
   ok: root
   ```

7. **TODO 4, línea 29.** `*)` encaja con todo y va primero: `root | admin)` no se usa nunca (lab 04, paso 5). Mueve la línea `*) echo "ok: $name" ;;` debajo de la rama de `root | admin`, justo antes de `esac`. Borra el comentario del `TODO 4`. Prueba:
   ```bash
   bash starter/validate-user.sh root; echo $?
   bash starter/validate-user.sh ana_garcia-2; echo $?
   ```
   ```text
   no: 'root' está reservado
   1
   ok: ana_garcia-2
   0
   ```

8. **shellcheck limpio.** Vuelve a pasarlo:
   ```bash
   shellcheck starter/validate-user.sh; echo $?
   ```
   ```text
   0
   ```
   Sin salida y con código `0`: ningún aviso. Repite el paso 2 y compara con lo que escribiste en el paso 1.

## Criterios de éxito

- [ ] Explicas por qué la condición de la línea 16 se cumplía con cualquier nombre (paso 5)
- [ ] Explicas por qué `root | admin)` nunca se usaba (paso 7)
- [ ] `bash starter/validate-user.sh ana` imprime `ok: ana`, y `root`, `Ana` y `ab` salen con `1` con el motivo correcto
- [ ] `shellcheck starter/validate-user.sh` no imprime nada

## Reto extra

Añade una regla: el nombre no puede acabar en `-`. ¿Lo harías cambiando la regex o con otra rama del `case` (`*-)`)? Pruébalo con `ana-`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 06 — Argumentos](../lab-06-argumentos/README.md) | [Proyecto — bk-check: validar antes de usar](../../3-proyecto/README.md) → |

[↑ Semana 06](../../README.md)
