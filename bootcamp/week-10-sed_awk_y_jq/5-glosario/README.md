# Glosario — Semana 10

| Término | Definición en una línea | Ejemplo |
|---------|-------------------------|---------|
| `sed` | Editor de flujo: aplica un programa a cada línea y escribe el resultado en stdout | `sed 's/http:/https:/' urls.txt` |
| `s/regex/reemplazo/` | Comando de `sed` que cambia lo que encaja con la regex; con `g`, todas las veces | `sed 's/uno/1/g'` |
| Grupo (`\1`) | Parte de la regex entre paréntesis; en el reemplazo, `\1` es lo que encajó en el primero | `sed -E 's/(.+) (.+)/\2 \1/'` |
| Dirección | Número, regex o rango delante de un comando de `sed` que elige a qué líneas se aplica | `sed -n '/^\[db\]/,/^\[/p'` |
| `sed -i` | Cambia el archivo en lugar de escribir en stdout; con `.bak`, guarda antes el original | `sed -i.bak 's/2/4/' app.conf` |
| `awk` | Lenguaje para texto por columnas: parte cada línea en campos y aplica reglas `patrón { acción }` | `awk -F: '$3 >= 1000' /etc/passwd` |
| Campo (`$1`, `$NF`) | Cada trozo de la línea separado por espacios o por `-F`; `$NF` es el último | `awk '{ print $1, $NF }'` |
| `NF` / `NR` | Cuántos campos tiene la línea / el número de la línea que se lee | `awk 'NR == 1 { print NF }'` |
| `BEGIN` / `END` | Bloques de awk que se ejecutan una vez antes de la primera línea y después de la última | `awk '{ s += $10 } END { print s }'` |
| `OFS` | Separador que awk pone entre campos al escribir o al rehacer la línea | `awk -v OFS=, '{ $1 = $1; print }'` |
| `awk -v` | Pasa un valor de bash a una variable de awk como dato, no como código | `awk -v limit="$limit" '$5 > limit'` |
| JSON | Formato de datos con objetos, arrays, textos, números, `true`, `false` y `null` | `{"codigo": 200, "ruta": "/"}` |
| `jq` | Programa que lee JSON, le aplica un filtro y escribe el resultado | `jq -r '.servicios[].nombre' s.json` |
| `select()` | Filtro de jq que deja pasar solo los valores que cumplen la condición | `jq '.[] \| select(.codigo >= 500)'` |
| `--arg` / `--argjson` | Dan a jq una variable: un texto escapado / un valor que ya es JSON | `jq -n --arg m "$msg" '{mensaje: $m}'` |

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Recursos — web](../4-recursos/webgrafia/README.md) | — |

[↑ Semana 10](../README.md)
