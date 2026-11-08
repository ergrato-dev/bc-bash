# case

Cuando el mismo valor se compara con varias opciones, una cadena de `elif` repite la variable en cada línea. `case` la escribe una vez y pone las opciones en columna.

```bash
case "$accion" in
  start)
    echo "arrancando"
    ;;
  stop | halt)
    echo "parando"
    ;;
  *)
    echo "acción desconocida: $accion" >&2
    exit 2
    ;;
esac
```

## Las piezas

| Pieza | Qué hace |
|---|---|
| `case valor in` | el valor que se compara; cítalo como cualquier expansión |
| `patrón)` | una rama; puede tener varios patrones separados por `\|` |
| `;;` | cierra la rama; sin él, el `case` no está bien escrito |
| `*)` | encaja con todo: la rama "en cualquier otro caso", siempre la última |
| `esac` | `case` al revés: cierra el conjunto |

Una rama corta cabe en una línea: `stop | halt) echo "parando" ;;`.

## Patrones glob

Los patrones son los globs de los nombres de archivo (semana 05), aplicados a un texto. Encajan con el texto **entero**:

| Patrón | Encaja con |
|---|---|
| `*.tar.gz` | lo que termina en `.tar.gz` |
| `-h \| --help` | exactamente `-h` o `--help` |
| `[0-9]` | una sola cifra; `42` no |
| `[sS]` | `s` o `S` |
| `?` | un carácter cualquiera |
| `"*"` | un asterisco literal, entre comillas |

Para no distinguir mayúsculas, compara en minúsculas sin cambiar la variable: `case "${resp,,}" in`.

## Gana la primera

bash prueba las ramas en orden y se queda con la **primera** que encaja; las demás no se miran. `app.tar.gz` encaja con `*.gz` y con `*.tar.gz`: va primero el patrón más concreto.

```bash
case "$f" in
  *.tar.gz) echo "tar -xzf" ;;   # antes que *.gz
  *.gz) echo "gunzip" ;;
esac
```

Si `*)` estuviera arriba, ninguna rama de debajo se usaría nunca. shellcheck lo detecta (`SC2221`).

## Para qué se usa

- **Opciones de un script**: `-v`, `-h | --help`, y `-*)` para avisar de una opción desconocida.
- **Subcomandos**: `bashkit backup`, `bashkit report`... El dispatcher de la semana 08 es un `case`.
- **Extensiones o prefijos**: elegir qué hacer con un archivo según su nombre.
- **Respuestas**: `s | si | sí)` frente a `n | no)`.

## case o [[ ]]

`case` compara con patrones glob, que bastan para extensiones y opciones. Para un formato con reglas (cuatro números de 0 a 255, una fecha), hace falta una regex: `[[ =~ ]]` (teoría 04). Los dos se combinan bien: un `case` elige qué regex aplicar, y un solo `[[ =~ ]]` la comprueba.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — Comparar con `[[ ]]`](02-comparar-con-dobles-corchetes.md) | [Teoría — Regex con `=~` y argumentos](04-regex-y-argumentos.md) → |

[↑ Semana 06](../README.md)
