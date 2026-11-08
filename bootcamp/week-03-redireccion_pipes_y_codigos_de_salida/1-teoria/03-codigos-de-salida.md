# Códigos de salida

## Un número al terminar

Todo comando, al terminar, devuelve un número entre 0 y 255: su **código de salida**. No se imprime; lo guarda bash en `$?`:

```bash
ls /no-existe
echo $?
```

```text
ls: cannot access '/no-existe': No such file or directory
2
```

La regla es al revés de lo que parece: **`0` es éxito** y cualquier otro número es un fallo. Hay una forma de acertar y muchas de fallar, y cada programa usa números distintos para distinguirlas.

| Código | Quién lo pone | Significa |
|:--:|---|---|
| 0 | cualquier programa | todo bien |
| 1 | la mayoría | fallo general |
| 2 | muchos (`ls`, `grep`) y bash | mal uso o error grave |
| 126 | bash | el archivo existe pero no se puede ejecutar |
| 127 | bash | comando no encontrado |
| 128+N | bash | lo mató la señal N (`130` = `Ctrl+C`, señal 2) |

Lo que significa cada código lo documenta cada programa en su `man`, en la sección *EXIT STATUS*. `grep`, por ejemplo, usa `0` si encuentra, `1` si no encuentra y `2` si hay un error.

## `$?` dura un comando

`$?` es el código del **último** comando, y el siguiente lo pisa, incluido un `echo`. Si lo necesitas después, guárdalo en cuanto termine:

```bash
grep -q alumno /etc/passwd
codigo=$?
```

En un pipe, `$?` es el código del último comando. `PIPESTATUS` guarda el de todos, en orden: `echo "${PIPESTATUS[@]}"` justo después del pipe.

## Comandos que solo responden con el código

Algunos comandos están hechos para preguntar. No imprimen nada; contestan con el código:

- `true` sale siempre con `0` y `false` con `1`.
- `test -f ruta` (¿es un archivo?), `test -d ruta` (¿una carpeta?), `test -w ruta` (¿puedes escribir?).
- `grep -q texto archivo`: ¿aparece el texto?
- `command -v programa`: ¿existe el programa?

## `&&` y `||`: decidir con el código

| Escribes | Se ejecuta `b`... |
|---|---|
| `a && b` | solo si `a` sale con `0` |
| `a \|\| b` | solo si `a` falla |
| `a; b` | siempre |

```bash
mkdir copias && echo "creada"
command -v docker > /dev/null || { echo "falta docker" >&2; exit 4; }
```

`{ ...; }` agrupa varios comandos para que el `||` los ejecute todos. Los espacios tras `{` y el `;` antes de `}` son obligatorios. En la semana 06 llegará `if`, para cuando la decisión tenga más de una línea.

## `exit`: el código de tu script

`exit N` termina el script con el código `N`. Sin `exit`, el script sale con el código de su último comando, que puede ser un `echo` que funcionó aunque todo lo anterior fallara. Un script que dice la verdad con su código se puede usar dentro de otros con `&&` y `||`, como cualquier comando.

Elige códigos con sentido: `0` si todo fue bien, `2` si te llamaron mal (faltan argumentos), y otros distintos si hay varios fallos que alguien quiera distinguir. No uses los de 126 en adelante: ya tienen dueño.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — Pipes, tee y here-docs](02-pipes-tee-y-here-docs.md) | [Teoría — Modo estricto: `set -euo pipefail`](04-set-euo-pipefail.md) → |

[↑ Semana 03](../README.md)
