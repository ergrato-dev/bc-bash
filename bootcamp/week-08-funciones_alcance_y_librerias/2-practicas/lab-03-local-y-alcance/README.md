# Lab 03 — local y alcance

⏱ Duración estimada: ~60 min

## Objetivo

Encontrar las variables de una función que pisan las del resto del script y arreglarlas con `local`.

## Contexto

- En bash, una variable creada dentro de una función es **global**: sigue existiendo al salir, y si ya había una con ese nombre, la cambia. `local nombre` la hace solo de la función.
- Una variable `local` la ven también las funciones a las que llama la suya (alcance **dinámico**). Lo que no hace es salir fuera.
- `starter/histogram.sh` dibuja una barra por cada línea de `datos/ventas.txt` (cinco días con sus ventas). Le faltan días y cuenta mal, y shellcheck no ve nada.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-08-funciones_alcance_y_librerias/2-practicas/lab-03-local-y-alcance
   ```
   (sin salida).

1. **Sin `local`, la variable sale de la función.**
   ```bash
   f() { x=dentro; }
   x=fuera; f; echo "$x"
   ```
   ```text
   dentro
   ```
   La `x` de `f` es la misma que la de fuera.

2. **Con `local`, no.**
   ```bash
   g() { local x=dentro; echo "en g: $x"; }
   x=fuera; g; echo "fuera: $x"
   ```
   ```text
   en g: dentro
   fuera: fuera
   ```
   `local x` crea una `x` nueva que tapa la de fuera mientras dura `g`, y desaparece al terminar.

3. **Las funciones llamadas ven las `local` de quien las llama.**
   ```bash
   show() { echo "show ve: $y"; }
   caller() { local y=de-caller; show; }
   caller; echo "fuera: [$y]"
   ```
   ```text
   show ve: de-caller
   fuera: []
   ```
   `show` ve la `y` de `caller` porque se ejecuta mientras `caller` sigue en marcha. Fuera de las dos, `y` no existe.

4. **El histograma roto.** Abre `starter/histogram.sh` en tu editor y ejecútalo:
   ```bash
   bash starter/histogram.sh datos/ventas.txt; echo $?
   cat datos/ventas.txt
   ```
   ```text
   lunes ###
   viernes ######
   6 días
   0
   lunes 3
   martes 1
   miercoles 4
   jueves 2
   viernes 6
   ```
   Faltan tres días y dice `6 días` con cinco líneas. `shellcheck starter/histogram.sh` sale con `0`: el script es correcto para shellcheck, que no sabe qué variables querías compartir.

5. **Sigue la `i`.** El bucle de abajo y el de `draw_bar` usan la misma `i`, global:
   - Vuelta 1 del bucle de abajo: `i=0`, dibuja `lunes`. `draw_bar 3` deja `i` en `3`.
   - El bucle suma 1: `i=4`, la quinta línea, `viernes`. `draw_bar 6` deja `i` en `6`.
   - El bucle suma 1: `i=7`, no es menor que 5, y termina.

   **TODO 1:** en `draw_bar`, cambia el comentario del `TODO 1` por:
   ```bash
     local i
   ```
   Prueba:
   ```bash
   bash starter/histogram.sh datos/ventas.txt
   ```
   ```text
   lunes ###
   martes #
   miercoles ####
   jueves ##
   viernes ######
   6 días
   ```
   Los cinco días, pero todavía `6 días`.

6. **TODO 2: `count`.** `count=${#lines[@]}` guarda cuántas líneas hay (lab 05 de la semana 07). `draw_row` usa otra `count`, global, para las ventas del día, y la última vuelta la deja en `6`, las del viernes. En `draw_row`, cambia el comentario del `TODO 2` por:
   ```bash
     local day count
   ```
   Prueba:
   ```bash
   bash starter/histogram.sh datos/ventas.txt
   ```
   ```text
   lunes ###
   martes #
   miercoles ####
   jueves ##
   viernes ######
   5 días
   ```

7. **shellcheck.**
   ```bash
   shellcheck starter/histogram.sh; echo $?
   ```
   ```text
   0
   ```
   Limpio antes y después: los dos fallos eran de nombres, no de sintaxis. Por eso la regla: **toda variable de una función, `local`**.

## Criterios de éxito

- [ ] Explicas, siguiendo la `i`, por qué el paso 4 solo dibujó lunes y viernes
- [ ] Explicas por qué `count` valía `6` al final antes del TODO 2
- [ ] `bash starter/histogram.sh datos/ventas.txt` dibuja los cinco días y termina con `5 días`
- [ ] `shellcheck starter/histogram.sh` no imprime nada

## Reto extra

`draw_bar` llama a `echo` una vez por `#`. Escribe una versión sin bucle: `printf -v` y `${var// /#}` lo hacen en dos líneas (`help printf`). ¿Sigue necesitando una `local`?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 02 — return y salida](../lab-02-return-y-salida/README.md) | [Lab 04 — declare -n](../lab-04-declare-n/README.md) → |

[↑ Semana 08](../../README.md)
