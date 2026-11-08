# Lab 07 — Funciones rotas

⏱ Duración estimada: ~60 min

## Objetivo

Encontrar y arreglar los cuatro fallos típicos de las funciones de un script, los dos que ve shellcheck y los dos que solo aparecen al ejecutarlo.

## Contexto

- `starter/log-summary.sh` dice, para cada `.log` que recibe, cuántas líneas tiene y cuántas dicen `ERROR`, e ignora lo que no es un `.log`. Viene **roto a propósito**: cuatro fallos, cada uno marcado con un TODO.
- `datos/` tiene tres logs y un `notas.txt` que el script tiene que ignorar.
- Los fallos de este lab no son de sintaxis: el script es bash correcto. Están en dónde se llama a una función, qué recibe, qué imprime y cómo termina.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-08-funciones_alcance_y_librerias/2-practicas/lab-07-funciones-rotas
   ```
   (sin salida).

1. **La respuesta correcta.**
   ```bash
   grep -c ERROR datos/*.log
   wc -l datos/*.log
   ```
   ```text
   datos/app.log:2
   datos/db.log:0
   datos/web.log:1
     5 datos/app.log
     3 datos/db.log
     2 datos/web.log
    10 total
   ```
   El script tiene que dar esos números, y una línea `ignorado: datos/notas.txt`.

2. **Lo que responde.** `datos/*` le pasa los cuatro archivos:
   ```bash
   bash starter/log-summary.sh datos/*; echo $?
   ```
   ```text
   starter/log-summary.sh: line 6: print_summary: command not found
   127
   ```

3. **Lo que ve shellcheck.**
   ```bash
   shellcheck starter/log-summary.sh
   ```
   ```text

   In starter/log-summary.sh line 6:
   print_summary # TODO 1 y TODO 2
   ^-----------^ SC2218 (error): This function is only defined later. Move the definition up.
   ^-----------^ SC2119 (info): Use print_summary "$@" if function's $1 should mean script's $1.


   In starter/log-summary.sh line 20:
   print_summary() {
   ^-- SC2120 (warning): print_summary references arguments, but none are ever passed.

   For more information:
     https://www.shellcheck.net/wiki/SC2218 -- This function is only defined lat...
     https://www.shellcheck.net/wiki/SC2120 -- print_summary references argument...
     https://www.shellcheck.net/wiki/SC2119 -- Use print_summary "$@" if functio...
   ```
   Dos fallos en la misma línea: el TODO 1 (`SC2218`) y el TODO 2 (`SC2119` y `SC2120`). Los de `count_errors` e `is_log` no aparecen.

4. **TODO 1: llamada antes de la definición.** En la línea 6, bash todavía no ha leído `print_summary` (lab 01, paso 4). Borra la línea `print_summary # TODO 1 y TODO 2` y la línea vacía de debajo, y escribe al final del archivo, después de la `}` de `print_summary`:
   ```bash

   print_summary # TODO 2
   ```
   Prueba:
   ```bash
   bash starter/log-summary.sh datos/*; echo $?
   ```
   ```text
   0
   ```
   Ni un error, ni una línea.

5. **TODO 2: la función no recibe nada.** `print_summary` recorre `"$@"`, que dentro de una función son **sus** argumentos, y se la llama sin ninguno (lab 01, paso 5). Es lo que decía `SC2119`. Cambia la última línea por:
   ```bash
   print_summary "$@"
   ```
   Prueba:
   ```bash
   bash starter/log-summary.sh datos/*; echo $?
   ```
   ```text
   datos/app.log: 5 líneas, contando en datos/app.log
   2 con ERROR
   datos/db.log: 3 líneas, contando en datos/db.log
   0 con ERROR
   1
   ```
   Dos fallos más: las líneas salen partidas, y el script para después de `db.log` con código `1` y sin decir por qué.

6. **TODO 3: un mensaje en la salida de la función.** `$(count_errors "$f")` recoge **todo** lo que imprime la función: el número y también el `echo "contando en $1"` que alguien dejó para depurar. Lo que no es el resultado va a stderr, que `$( )` no recoge. En `count_errors`, cambia el `# TODO 3` de esa línea por `>&2`:
   ```bash
     echo "contando en $1" >&2
   ```
   Prueba:
   ```bash
   bash starter/log-summary.sh datos/*; echo $?
   ```
   ```text
   contando en datos/app.log
   datos/app.log: 5 líneas, 2 con ERROR
   contando en datos/db.log
   datos/db.log: 3 líneas, 0 con ERROR
   1
   ```
   Las líneas ya están bien. Sigue parando en el tercer archivo, `datos/notas.txt`.

7. **TODO 4: `exit` en lugar de `return`.** `is_log` dice "no" con `exit 1`, y `exit` dentro de una función termina el script entero (lab 02, paso 4). El `if !` que la llama nunca recibe la respuesta. En `is_log`, cambia `|| exit 1 # TODO 4` por:
   ```bash
     [[ $1 == *.log ]] || return 1
   ```
   Prueba:
   ```bash
   bash starter/log-summary.sh datos/*; echo $?
   bash starter/log-summary.sh datos/* 2>/dev/null
   ```
   ```text
   contando en datos/app.log
   datos/app.log: 5 líneas, 2 con ERROR
   contando en datos/db.log
   datos/db.log: 3 líneas, 0 con ERROR
   ignorado: datos/notas.txt
   contando en datos/web.log
   datos/web.log: 2 líneas, 1 con ERROR
   0
   datos/app.log: 5 líneas, 2 con ERROR
   datos/db.log: 3 líneas, 0 con ERROR
   datos/web.log: 2 líneas, 1 con ERROR
   ```
   Los mismos números que en el paso 1. Con `2>/dev/null` queda solo el resultado: los mensajes y el `ignorado` iban por stderr.

8. **shellcheck limpio.**
   ```bash
   shellcheck starter/log-summary.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas por qué el script no imprimía nada después del TODO 1 (paso 5)
- [ ] Explicas por qué las líneas salían partidas, y por qué `>&2` lo arregla (paso 6)
- [ ] Explicas por qué el script paraba en `datos/notas.txt` sin mensaje (paso 7)
- [ ] `bash starter/log-summary.sh datos/* 2>/dev/null` imprime los mismos números que el paso 1
- [ ] `shellcheck starter/log-summary.sh` no imprime nada

## Reto extra

Quita el `|| true` de `count_errors` y ejecuta el script: sigue funcionando, aunque `grep -c` sale con `1` cuando cuenta `0`. Ahora guarda el número antes del `echo`, con `errors=$(count_errors "$f")`, y vuelve a probar: para en `db.log`. `set -e` no mira un `$( )` que va dentro de los argumentos de otro comando, y sí una asignación. La semana 11 trata estos límites de `set -e`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 06 — Dispatcher de subcomandos](../lab-06-dispatcher/README.md) | [Proyecto — lib/core.sh y bashkit: un kit, un comando](../../3-proyecto/README.md) → |

[↑ Semana 08](../../README.md)
