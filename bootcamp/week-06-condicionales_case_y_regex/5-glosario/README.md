# Glosario — Semana 06

| Término | Definición en una línea | Ejemplo |
|---------|-------------------------|---------|
| Condición | Comando cuyo código de salida decide la rama: `0` es "se cumple" | `if grep -q ana /etc/passwd` |
| `if` / `elif` / `else` | Ejecuta el primer bloque cuya condición sale con `0`; `fi` lo cierra | `if [[ -d x ]]; then ...; fi` |
| `test` / `[` | Comando que comprueba una condición y responde con su código | `[ -f notas.txt ]` |
| `[[ ]]` | Condición propia de bash: no parte variables ni lee `>` como redirección | `[[ $f == *.log ]]` |
| Operador de cadena | Compara textos dentro de `[[ ]]` | `==`, `!=`, `-z`, `-n` |
| Operador numérico | Compara números dentro de `[[ ]]` | `-eq`, `-lt`, `-gt` |
| Operador de archivo | Pregunta por una ruta: si existe, qué es o qué permisos tienes | `-e`, `-f`, `-d`, `-x` |
| `case` | Elige la primera rama cuyo patrón glob encaja con un valor | `case "$1" in -h) ...;; esac` |
| `=~` | Comprueba dentro de `[[ ]]` si un texto encaja con una regex extendida | `[[ $v =~ $re ]]` |
| Ancla | `^` y `$`: obligan a la regex a encajar desde el principio y hasta el final | `^[0-9]+$` |
| Grupo | Trozo de una regex entre paréntesis; guarda lo que encajó | `([0-9]{4})` |
| `BASH_REMATCH` | Lista con el texto que encajó con `=~` (`[0]`) y con cada grupo (`[1]`...) | `${BASH_REMATCH[1]}` |
| Parámetros posicionales | Los argumentos de un script: `$1`, `$2`...; `$#` dice cuántos hay | `if [[ $# -ne 2 ]]` |
| `"$@"` | Todos los argumentos, cada uno como llegó | `touch -- "$@"` |
| `shift` | Quita el primer argumento y corre los demás una posición | `shift` tras leer `-v` |

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Recursos — web](../4-recursos/webgrafia/README.md) | — |

[↑ Semana 06](../README.md)
