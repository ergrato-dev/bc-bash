# Lab 03 — break y continue

⏱ Duración estimada: ~60 min

## Objetivo

Saltar una vuelta con `continue` y salir de un bucle con `break`, y saber después del bucle si se salió antes de tiempo.

## Contexto

- `continue` deja el resto del bloque sin ejecutar y pasa a la siguiente vuelta. `break` sale del bucle entero: el script sigue después del `done`.
- Los dos se usan dentro de un `if`: "si este no me sirve, el siguiente" y "ya tengo lo que buscaba, no sigas".
- `starter/first-free.sh` busca el primer nombre libre entre `base.1` y `base.9`, para guardar una copia nueva sin pisar las anteriores. Hoy devuelve siempre el último.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-07-bucles_read_y_archivos_seguros/2-practicas/lab-03-break-y-continue
   mkdir -p zona
   ```
   (sin salida).

1. **`continue` y `break` en un bucle de cinco vueltas.**
   ```bash
   for i in {1..5}; do if [[ $i -eq 3 ]]; then continue; fi; echo "$i"; done
   for i in {1..5}; do if [[ $i -eq 3 ]]; then break; fi; echo "$i"; done; echo "fuera, i vale $i"
   ```
   ```text
   1
   2
   4
   5
   1
   2
   fuera, i vale 3
   ```
   Con `continue`, la vuelta del `3` no llega al `echo`, y el bucle sigue con `4` y `5`. Con `break`, el bucle termina en el `3`, y `i` se queda con el valor que tenía al salir.

2. **El script, tal cual.** Abre `starter/first-free.sh` en tu editor y léelo. `for ((i = 1; i <= 9; i++))` es el `for` con contador del lab 01. Pruébalo sin copias y con dos:
   ```bash
   bash starter/first-free.sh zona/copia
   touch zona/copia.1 zona/copia.2
   bash starter/first-free.sh zona/copia
   ```
   ```text
   zona/copia.9
   zona/copia.9
   ```
   El primero libre es `zona/copia.1` y, después, `zona/copia.3`. El bucle da las nueve vueltas y `free` se queda con la última.

3. **Qué falta.** Dos cosas: saltarse los números que ya existen (`continue`) y parar en el primero libre (`break`). Cada una es un TODO.

4. **TODO 1: saltar los ocupados.** Sustituye el comentario del `TODO 1` por:
   ```bash
     if [[ -e $base.$i ]]; then
       continue
     fi
   ```
   Si `zona/copia.1` existe, el resto del bloque no se ejecuta en esa vuelta. Prueba:
   ```bash
   bash starter/first-free.sh zona/copia
   ```
   ```text
   zona/copia.9
   ```
   Igual que antes: el bucle salta el `1` y el `2`, pero del `3` al `9` sigue cambiando `free`. Falta parar.

5. **TODO 2: parar en el primero libre.** Sustituye el comentario del `TODO 2` por `break`, con la sangría del bloque. Prueba:
   ```bash
   bash starter/first-free.sh zona/copia
   ```
   ```text
   zona/copia.3
   ```

6. **TODO 3: ¿y si no queda ninguno?** Ocupa los nueve. `{3..9}` se expande antes de llegar a `touch` (lab 01):
   ```bash
   touch zona/copia.{3..9}
   ls zona
   bash starter/first-free.sh zona/copia; echo $?
   ```
   ```text
   copia.1  copia.2  copia.3  copia.4  copia.5  copia.6  copia.7  copia.8  copia.9

   0
   ```
   Una línea vacía y código `0`: si todas las vueltas hacen `continue`, nunca llega el `break`, y `free` sigue vacía. Después del bucle, `free` dice cómo terminó: con algo, salió por el `break`; vacía, dio todas las vueltas. Sustituye el comentario del `TODO 3` por:
   ```bash
   if [[ -z $free ]]; then
     echo "first-free.sh: de $base.1 a $base.9 están todos ocupados" >&2
     exit 1
   fi
   ```
   Prueba con los nueve ocupados y con un hueco en medio:
   ```bash
   bash starter/first-free.sh zona/copia; echo $?
   rm zona/copia.5
   bash starter/first-free.sh zona/copia; echo $?
   ```
   ```text
   first-free.sh: de zona/copia.1 a zona/copia.9 están todos ocupados
   1
   zona/copia.5
   0
   ```

7. **shellcheck.**
   ```bash
   shellcheck starter/first-free.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas por qué el script devolvía `zona/copia.9` con el `continue` y sin el `break` (paso 4)
- [ ] Explicas cómo sabe el script, después del bucle, que no hubo `break` (paso 6)
- [ ] Con `copia.1` a `copia.4` creadas, `bash starter/first-free.sh zona/copia` imprime `zona/copia.5`
- [ ] Con las nueve creadas, sale con `1` y avisa en stderr

## Reto extra

`break` dentro de un `for` que está dentro de otro solo sale del de dentro. `break 2` sale de los dos. Escribe un bucle de `{1..3}` con otro de `{1..3}` dentro que pare los dos en cuanto la suma de los dos números sea `4`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 02 — while y until](../lab-02-while-y-until/README.md) | [Lab 04 — read e IFS](../lab-04-read-e-ifs/README.md) → |

[↑ Semana 07](../../README.md)
