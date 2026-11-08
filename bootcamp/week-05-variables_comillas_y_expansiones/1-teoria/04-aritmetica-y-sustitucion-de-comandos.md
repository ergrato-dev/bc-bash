# Aritmética y sustitución de comandos

## `$(( ))`: cuentas con enteros

`$(( expresión ))` calcula y se sustituye por el resultado:

```bash
usado=4300
total=5000
echo "uso: $(( usado * 100 / total ))%"
```

```text
uso: 86%
```

| Operador | Qué hace | Ejemplo |
|---|---|---|
| `+ - * /` | suma, resta, multiplica, divide | `$(( 7 / 2 ))` es `3` |
| `%` | resto de la división | `$(( 7 % 2 ))` es `1` |
| `**` | potencia | `$(( 2 ** 10 ))` es `1024` |
| `( )` | agrupar | `$(( (2 + 3) * 4 ))` es `20` |
| `< > <= >= == !=` | comparar: `1` si es cierto, `0` si no | `$(( 5 > 3 ))` es `1` |

Dentro, los nombres de variable no necesitan `$`. Cuatro trampas:

- **Solo enteros.** `7 / 2` es `3`: los decimales se pierden. Multiplica antes de dividir: `usado * 100 / total`, no `usado / total * 100`, que da `0`. `2.5` es un error de sintaxis; para decimales, `awk` (semana 10).
- **Un `0` delante es octal.** `$(( 08 ))` da `value too great for base`. Las horas y los meses de `date` llevan ese `0`: `$(( 10#$hora ))` fuerza la base 10.
- **Un texto no es un error.** `x=hola; echo $(( x + 1 ))` da `1`: `hola` se toma por el nombre de otra variable, que vale `0`.
- **Un error dentro de `$(( ))` no para el script**, ni con `set -e`: cancela ese comando y sigue.

## `(( ))`: la cuenta como condición

Sin el `$`, `(( expresión ))` no se sustituye por nada: calcula y sale con `0` si el resultado no es cero, y con `1` si es cero. Sirve para comparar números (semana 06) y para cambiar variables:

```bash
(( n = 5 * 2 ))
(( n++ ))
```

Cuidado con `(( n++ ))` cuando `n` vale `0`: el resultado es el valor de antes, `0`, y sale con `1`. Con `set -e`, el script para ahí. Para contar, `n=$(( n + 1 ))` es una asignación y siempre sale con `0`.

## `$( )`: la salida de un comando

`$(comando)` ejecuta el comando y se sustituye por lo que escribe en stdout:

```bash
hoy=$(date +%F)
lineas=$(wc -l < /etc/passwd)
echo "Copia del $hoy: $lineas usuarios"
```

```text
Copia del 2026-11-08: 20 usuarios
```

- **Quita los saltos de línea del final**, todos: por eso `lineas` guarda `20` y no `20` más un salto de línea.
- **Solo recoge stdout.** Los errores (stderr) salen en pantalla y no entran en la variable.
- **El código de salida es el del comando.** `x=$(false)` sale con `1`; con `set -e`, el script para.
- **Se anidan**, cada una con sus comillas: `"$(basename "$(pwd)")"`.
- **Su resultado se parte en palabras si no lo citas** (teoría 02): `echo $(ls)` lo pone todo en una línea; `echo "$(ls)"` conserva los saltos de línea.

La forma antigua es `` `comando` ``, con comillas invertidas. Hace lo mismo, pero no se anida bien y se confunde con una comilla simple: en scripts nuevos, `$( )`.

## Lo que une la semana

Variables, comillas, recortes, cuentas y salidas de comandos se combinan en una línea:

```bash
echo "Backup de ${HOSTNAME,,} con $(( $(du -sk datos | cut -f1) / 1024 )) MiB"
```

Del interior hacia fuera: `du -sk datos` da los KiB de la carpeta; `cut` se queda con el número; `$(( ))` lo pasa a MiB; `${HOSTNAME,,}` pone el nombre del equipo en minúsculas. Las comillas de fuera hacen que todo llegue a `echo` como un solo argumento.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — Expansiones de parámetros](03-expansiones-de-parametros.md) | [Índice de labs](../2-practicas/README.md) → |

[↑ Semana 05](../README.md)
