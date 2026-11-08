# Comparar con `[[ ]]`

Dentro de `[[ ]]` caben tres tipos de preguntas: sobre textos, sobre números y sobre archivos. Cada una tiene sus operadores, y usar el de otro tipo no da error: da una respuesta equivocada.

## Textos

| Escribes | Se cumple si |
|---|---|
| `[[ $a == $b ]]` | son iguales; a la derecha, un glob sin comillas es un patrón |
| `[[ $a != $b ]]` | son distintos |
| `[[ -z $a ]]` | `a` está vacía (*zero*) |
| `[[ -n $a ]]` | `a` tiene algo (*non-zero*) |
| `[[ $a < $b ]]` | `a` va antes en orden de diccionario |

```bash
[[ $f == *.log ]]     # termina en .log
[[ $f == "*.log" ]]   # vale exactamente *.log, con el asterisco
```

## Números

| Escribes | Se cumple si |
|---|---|
| `-eq` / `-ne` | igual / distinto |
| `-lt` / `-le` | menor / menor o igual |
| `-gt` / `-ge` | mayor / mayor o igual |

```bash
[[ $usado -gt $limite ]]   # números: 900 no es mayor que 1000
[[ $usado > $limite ]]     # textos: "900" va después de "1000"
```

`(( ))` (semana 05) también compara números, con `<`, `>`, `==`: `(( usado > limite ))`. Las dos formas valen; en `[[ ]]`, siempre las letras.

## Archivos

| Escribes | Se cumple si la ruta... |
|---|---|
| `-e` | existe |
| `-f` / `-d` | es un archivo / una carpeta |
| `-s` | es un archivo con al menos un byte |
| `-r` / `-w` / `-x` | tú puedes leerla / escribirla / ejecutarla (o entrar, si es carpeta) |
| `-L` | es un enlace simbólico |
| `a -nt b` | `a` es más reciente que `b` |

Todos menos `-L` siguen los enlaces: un enlace cuyo destino no existe da falso con `-e`. Varios se solapan (una carpeta cumple `-d` y `-x`), así que en una cadena de `elif` va primero la pregunta más concreta.

## Juntar condiciones

`!` niega, `&&` es "y", `||` es "o", y los paréntesis agrupan:

```bash
[[ -f $f && ! -s $f ]]          # archivo vacío
[[ $n -lt 1 || $n -gt 12 ]]     # fuera de 1..12
```

## Por qué no `[ ]`

`[` es un comando, y sus argumentos pasan por todo lo que bash hace antes de ejecutar (semana 05):

| Con `x="ana maria"` o vacía | `[ ]` | `[[ ]]` |
|---|---|---|
| `$x == root` | `too many arguments`, o `unary operator expected` | compara bien, sin comillas |
| `$a > $b` | crea un archivo llamado como `$b` | compara textos |
| `-a`, `-o` | "y" y "o", obsoletos y ambiguos | no existen: `&&`, `\|\|` |
| `=~` | no existe | regex (teoría 04) |

Dentro de `[[ ]]` las variables no se parten ni se expanden como glob, así que `[[ -e $f ]]` funciona con espacios. Fuera de los corchetes, cita como siempre: `"$f"`.

Una excepción: a la **derecha** de `==` y de `=~`, las comillas cambian el significado. Sin ellas es un patrón o una regex; con ellas, texto literal. Es la única vez que quitar comillas es lo correcto, y shellcheck te avisa si te equivocas.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — if y códigos de salida](01-if-y-codigos-de-salida.md) | [Teoría — case](03-case.md) → |

[↑ Semana 06](../README.md)
