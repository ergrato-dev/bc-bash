# Glosario — Semana 09

| Término | Definición en una línea | Ejemplo |
|---------|-------------------------|---------|
| Array indexado | Variable con varios valores, cada uno en una casilla numerada desde `0` | `servers=(web-01 web-02)` |
| Índice | El número (o la clave) de una casilla de un array | `${servers[1]}` → `web-02` |
| `"${arr[@]}"` | Todos los elementos, cada uno como un argumento entero | `rm "${files[@]}"` |
| `"${arr[*]}"` | Todos los elementos juntos en un solo texto, separados por el primer carácter de `IFS` | `(IFS=,; echo "${files[*]}")` |
| `${#arr[@]}` | Cuántos elementos tiene el array; `${#arr}` es el largo del primero | `echo "${#servers[@]}"` → `2` |
| `${!arr[@]}` | Los índices (o las claves) del array, no sus valores | `for i in "${!servers[@]}"` |
| `+=( )` | Añade elementos al final de un array | `args+=(--exclude='*.log')` |
| Slice | Un trozo del array: desde una posición, tantos elementos | `"${lines[@]:4:4}"` |
| Hueco | Casilla borrada con `unset`; las demás no se mueven | `unset 'hosts[1]'` → índices `0 2 3` |
| Array asociativo | Array cuyas casillas tienen un texto como nombre; se crea con `declare -A` | `declare -A ports=([ssh]=22)` |
| Clave | El nombre de una casilla de un array asociativo | `${ports[ssh]}` → `22` |
| `[[ -v arr[clave] ]]` | Sale con `0` si la clave existe, aunque su valor esté vacío | `[[ -v ports[ftp] ]] \|\| echo "no hay ftp"` |
| Formato de `printf` | El primer argumento: texto con `%s`, `%d`... que se cambian por los demás argumentos | `printf '%s: %d\n' web 3` |
| Ancho | Número entre `%` y la letra: rellena con espacios hasta esa medida; `-` alinea a la izquierda y `*` lo toma de un argumento | `printf '%-*s|' 8 web` |
| `printf -v` | Guarda el resultado de `printf` en una variable, sin subshell | `printf -v bar '%*s' 5 ''` |

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Recursos — web](../4-recursos/webgrafia/README.md) | — |

[↑ Semana 09](../README.md)
