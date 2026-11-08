# grep y expresiones regulares

## grep: elegir líneas

`grep patrón archivo` imprime las líneas del archivo en las que aparece el patrón. Si no le das archivo, lee de stdin, así que también funciona al final de un pipe.

| Opción | Qué cambia |
|---|---|
| `-i` | no distingue mayúsculas de minúsculas |
| `-v` | al revés: las líneas que **no** tienen el patrón |
| `-n` | pone delante el número de línea |
| `-c` | en vez de las líneas, cuántas son |
| `-w` | solo palabras enteras: `-w ana` no encuentra `mariana` |
| `-o` | solo el trozo que encaja, no la línea entera |
| `-q` | no imprime nada: solo responde con el código |
| `-E` | expresiones regulares extendidas (abajo) |
| `-r` | busca en todos los archivos de una carpeta |

```bash
grep -n bash /etc/passwd
```

```text
1:root:x:0:0:root:/root:/bin/bash
20:alumno:x:1000:1000:Alumno bc-bash:/home/alumno:/bin/bash
```

El código de salida de `grep` es parte de la respuesta: `0` si encontró algo, `1` si no encontró nada y `2` si hubo un error (por ejemplo, el archivo no existe). Con `set -e`, un `grep` que no encuentra nada **para el script**, aunque no sea un error. Si "ninguna línea" es un resultado válido, escribe `grep ... || true`.

## Expresiones regulares

El patrón de `grep` es una **expresión regular** (*regex*): la mayoría de caracteres se representan a sí mismos y unos pocos tienen significado especial:

| Símbolo | Significa | Ejemplo | Encaja con |
|---|---|---|---|
| `.` | un carácter cualquiera | `c.sa` | `casa`, `cosa`, `c-sa` |
| `*` | lo anterior, 0 o más veces | `ab*c` | `ac`, `abc`, `abbbc` |
| `^` | principio de línea | `^root` | `root` solo al principio |
| `$` | final de línea | `bash$` | `bash` solo al final |
| `[abc]` | uno de esos caracteres | `[0-9]` | un dígito |
| `[^abc]` | uno que **no** sea esos | `[^0-9]` | cualquier cosa menos un dígito |
| `\` | quita el significado especial | `\.` | un punto de verdad |

Con `-E` (regex **extendidas**) se suman cuatro más:

| Símbolo | Significa | Ejemplo | Encaja con |
|---|---|---|---|
| `+` | lo anterior, 1 o más veces | `[0-9]+` | `7`, `8080` |
| `?` | lo anterior, 0 o 1 vez | `https?` | `http`, `https` |
| `{n,m}` | lo anterior, entre n y m veces | `[0-9]{1,3}` | de 1 a 3 dígitos |
| `\|` | una cosa u otra | `GET\|POST` | `GET` o `POST` |
| `( )` | agrupa, para repetir o alternar el grupo | `(ab)+` | `ab`, `abab` |

Sin `-E` se escriben con barra (`\+`, `\|`): en este bootcamp usarás `grep -E`.

```bash
grep -E '^(root|alumno):' /etc/passwd
grep -oE '[0-9]+' <<< 'puerto 8080, pid 4312'
```

```text
root:x:0:0:root:/root:/bin/bash
alumno:x:1000:1000:Alumno bc-bash:/home/alumno:/bin/bash
8080
4312
```

## Leer una regex por partes

Una regex larga se lee pieza a pieza. La de una IPv4 al principio de línea:

![La regex ^([0-9]{1,3}\.){3}[0-9]{1,3} separada en sus piezas: ancla de inicio, grupo de 1 a 3 dígitos y un punto repetido tres veces, y un último bloque de 1 a 3 dígitos; debajo, cómo encaja con 203.0.113.7 y por qué no encaja con ::1](../0-assets/01-regex-de-una-ip.svg)

## Dos costumbres que evitan errores

- **El patrón, siempre entre comillas simples.** Sin comillas, bash interpreta antes `*`, `?`, `[ ]` o `|` (semana 05) y `grep` recibe otra cosa.
- **El punto suelto encaja con cualquier carácter.** `grep '10.0.0.1'` también encuentra `10.0.0.12` y `10a0b0c1`. Para un punto literal, `\.`; para que no sobre nada al final, `$` o `-w`.

Acepta `999.1.1.1`: para contar IP basta; validarlas es de la semana 06.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — Filtros de texto: ver, recortar y contar líneas](01-filtros-de-texto.md) | [Teoría — Cortar, transformar, ordenar y contar](03-cortar-ordenar-y-contar.md) → |

[↑ Semana 04](../README.md)
