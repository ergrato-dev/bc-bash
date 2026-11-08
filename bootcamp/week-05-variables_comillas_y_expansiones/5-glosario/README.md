# Glosario — Semana 05

| Término | Definición en una línea | Ejemplo |
|---------|-------------------------|---------|
| Variable | Nombre que guarda un texto en la shell | `app=tienda` |
| Asignación | Dar valor a una variable: nombre, `=` y valor, sin espacios | `puerto=5432` |
| Variable de entorno | Variable exportada, que reciben los programas que lanza la shell | `export APP_ENV=prod` |
| Expansión | Lo que bash sustituye en una línea antes de ejecutarla | `$HOME`, `$(date)`, `*.log` |
| Comillas simples | Dejan el texto tal cual, sin sustituir nada | `'$HOME'` |
| Comillas dobles | Sustituyen variables y `$( )`, y evitan el word splitting y el globbing | `"$f"` |
| Escape | `\` delante de un carácter para quitarle su significado especial | `\$`, `\"` |
| Word splitting | Partición en palabras del resultado de una expansión sin comillas | `rm $f` con `f="a b"` |
| Globbing | Cambiar un patrón con `*`, `?` o `[ ]` por los archivos que encajan | `echo *.txt` |
| `--` | Marca el final de las opciones: lo que sigue son argumentos | `rm -- *.tmp` |
| Expansión de parámetros | Sustituir una variable aplicando un operador entre llaves | `${ruta##*/}` |
| Valor por defecto | El que se usa si la variable no existe o está vacía | `${PORT:-5432}` |
| Expansión aritmética | Calcular con enteros y sustituir por el resultado | `$(( a * 100 / b ))` |
| Sustitución de comandos | Ejecutar un comando y sustituir por lo que escribe en stdout | `hoy=$(date +%F)` |
| Octal | Base 8: bash lee así los números que empiezan por `0` | `$(( 10#08 ))` |

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Recursos — web](../4-recursos/webgrafia/README.md) | — |

[↑ Semana 05](../README.md)
