# Glosario — Semana 07

| Término | Definición en una línea | Ejemplo |
|---------|-------------------------|---------|
| Bucle | Bloque de comandos que se repite; `do` lo abre y `done` lo cierra | `for f in *.log; do ...; done` |
| `for` | Repite el bloque una vez por cada elemento de una lista | `for h in web-01 db-01` |
| `for (( ))` | `for` con contador: valor inicial, condición para seguir y cambio en cada vuelta | `for ((i = 1; i <= 9; i++))` |
| `while` / `until` | Repite mientras la condición sale con `0` / hasta que sale con `0` | `until [[ -e listo ]]; do sleep 1; done` |
| `break` / `continue` | Sale del bucle / pasa a la siguiente vuelta | `[[ -e $f ]] && continue` |
| `nullglob` | Opción de bash: un glob que no encaja con nada desaparece en lugar de quedarse tal cual | `shopt -s nullglob` |
| `read -r` | Lee una línea de la entrada sin comerse las `\` | `IFS= read -r line` |
| `IFS` | Caracteres por los que `read` parte una línea en campos | `IFS=: read -r user _ uid _` |
| Here-string | `<<<` pasa un texto como entrada de un comando | `read -r a b <<< "uno dos"` |
| `mapfile` | Carga las líneas de un archivo en un array | `mapfile -t hosts < hosts.txt` |
| Array | Variable con varios valores numerados desde 0 | `"${hosts[@]}"`, `${#hosts[@]}` |
| Byte nulo | Único carácter que no puede ir en un nombre de archivo; separa rutas con seguridad | `find . -print0` |
| `read -d ''` | Lee hasta el siguiente byte nulo en lugar de hasta el salto de línea | `while IFS= read -r -d '' f` |
| Subshell | Copia de la shell; lo que cambia dentro se pierde al terminar | `algo \| while ...` |
| Process substitution | `<(comando)`: la salida de un comando vista como un archivo | `done < <(find . -print0)` |

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Recursos — web](../4-recursos/webgrafia/README.md) | — |

[↑ Semana 07](../README.md)
