# while, until, break y continue

`for` repite por cada elemento de una lista conocida. Cuando no sabes cuántas vueltas harán falta (hasta que aparezca un archivo, hasta que responda un servidor, mientras queden líneas), se repite según una condición.

## while y until

```bash
n=3
while [[ $n -gt 0 ]]; do    # repite MIENTRAS la condición sale con 0
  echo "quedan $n"
  n=$((n - 1))
done

until [[ -e listo ]]; do    # repite HASTA QUE la condición sale con 0
  sleep 1
done
```

La condición es un comando, como en un `if` (semana 06): se ejecuta antes de cada vuelta y su código de salida decide si hay otra. `until X` es lo mismo que `while ! X`; elige el que se lea mejor.

Si el bloque no cambia nada de lo que mira la condición, el bucle no termina nunca. `Ctrl+C` lo para.

## Un límite siempre

Un bucle que espera algo de fuera necesita un tope: si el archivo no llega nunca, el script se queda colgado.

```bash
waited=0
until [[ -e $file ]]; do
  if [[ $waited -ge $max ]]; then
    echo "no apareció en $max s" >&2
    exit 1
  fi
  sleep 1
  waited=$((waited + 1))
done
```

## break y continue

| Orden | Qué hace |
|---|---|
| `continue` | deja el resto del bloque y pasa a la siguiente vuelta |
| `break` | sale del bucle; el script sigue después del `done` |
| `break 2` | sale de dos bucles, el de dentro y el de fuera |

```bash
for ((i = 1; i <= 9; i++)); do
  [[ -e copia.$i ]] && continue   # ocupado: el siguiente
  free="copia.$i"
  break                           # el primero libre: no sigas
done
```

Después de un bucle con `break`, una variable dice cómo terminó: si `free` sigue vacía, el bucle dio todas las vueltas sin encontrar nada.

`while true; do ... done` es un bucle sin fin que se usa a propósito, con un `break` o un `exit` dentro. `true` es un comando que solo sale con `0`.

## Contar sin que `set -e` pare el script

```bash
count=$((count + 1))   # bien: siempre sale con 0
((count++))            # mal: sale con 1 cuando count valía 0
```

`(( ))` es un comando que sale con `1` si el resultado es `0`, y `count++` da el valor de **antes** de sumar. Con `count=0`, el resultado es `0`, el código es `1`, y `set -e` para el script en silencio. `$(( ))` es una expansión, no un comando: nunca falla.

## Una variable que se pierde

Un bucle detrás de un pipe (`algo | while ...`) va en un **subshell**, una copia de la shell: lo que cambia dentro se pierde al terminar. Lo ves en la teoría 04 y en el lab 06.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — for](01-for.md) | [Teoría — Leer líneas: read y mapfile](03-leer-lineas-read-y-mapfile.md) → |

[↑ Semana 07](../README.md)
