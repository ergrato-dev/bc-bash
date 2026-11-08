# Leer líneas: read y mapfile

`read` lee **una línea** de su entrada y la guarda en variables. Dentro de un `while`, una vuelta por línea:

```bash
while IFS= read -r line; do
  echo "> $line"
done < notas.txt
```

`done < notas.txt` le pasa el archivo a todo el bucle; cada `read` lee la línea siguiente. Cuando no quedan líneas, `read` sale con `1` y el bucle termina. Nunca `cat notas.txt | while`: el `cat` sobra y el pipe mete el bucle en un subshell (teoría 04).

## Las dos piezas que no faltan nunca

| Pieza | Sin ella | Ejemplo |
|---|---|---|
| `-r` | `read` se come las `\` | `C:\temp` llega como `C:temp` |
| `IFS=` | `read` quita los espacios del principio y del final | `   sangría` llega como `sangría` |

`IFS=` delante de `read`, sin `;`, vale **solo para ese `read`**: no cambia el `IFS` del resto del script. shellcheck avisa si falta `-r` (`SC2162`).

## Partir en campos

`IFS` es la lista de caracteres por los que `read` parte la línea. Con varias variables, cada una se lleva un campo, y **la última se lleva el resto**:

```bash
IFS=: read -r user _ uid _ <<< "ana:x:1000:1000:Ana García:/home/ana:/bin/bash"
# user=ana  uid=1000  _ (la última)="Ana García:/home/ana:/bin/bash"
```

`_` es una variable de descarte: "este campo no me interesa". `<<<` (here-string) pasa un texto como entrada de un comando, igual que un here-doc de una línea (semana 03).

## La última línea sin salto de línea

Un archivo escrito a mano puede terminar sin salto de línea. En esa línea, `read` la guarda en la variable, pero sale con `1`, y el `while` termina sin procesarla:

```bash
while IFS= read -r line || [[ -n $line ]]; do
```

`|| [[ -n $line ]]`: si `read` falla pero ha leído algo, una vuelta más. Al final de verdad, la variable queda vacía y el bucle termina.

## mapfile: todas las líneas a la vez

`while read` procesa y olvida. Si hace falta saber cuántas líneas hay, ir a la tercera o recorrerlas varias veces, `mapfile` las guarda en un **array**, una variable con varios valores numerados desde `0`:

```bash
mapfile -t hosts < hosts.txt
echo "${#hosts[@]}"                    # cuántas: 5
echo "${hosts[0]}"                     # la primera
echo "${hosts[-1]}"                    # la última
for h in "${hosts[@]}"; do ...         # todas, cada una entera
for i in "${!hosts[@]}"; do ...        # los índices: 0, 1, 2...
```

`-t` quita el salto de línea del final de cada elemento; sin él, cada valor lo arrastra y `"${hosts[0]}" == "web-01"` no se cumple. Las personas cuentan desde 1 y el array desde 0: la línea `n` es `${hosts[n - 1]}`. Un índice que llega de fuera se valida antes de usarlo: con `0`, `n - 1` es `-1`, el último, y la respuesta parece correcta.

Los arrays a fondo (añadir, borrar, arrays asociativos), en la semana 09.

## Cuál usar

| Necesitas | Usa |
|---|---|
| procesar cada línea una vez, aunque el archivo sea enorme | `while IFS= read -r` |
| partir cada línea en campos | `while IFS=: read -r a b c` |
| el número de líneas, una línea por su posición, varias pasadas | `mapfile -t` |

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — while, until, break y continue](02-while-until-break-y-continue.md) | [Teoría — Archivos con cualquier nombre](04-archivos-con-cualquier-nombre.md) → |

[↑ Semana 07](../README.md)
