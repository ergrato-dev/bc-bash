# Labs — Semana 06: Condicionales, case y regex

| # | Lab | Objetivo | Tiempo |
|---|-----|----------|--------|
| 1 | [lab-01-if-y-codigos-de-salida](lab-01-if-y-codigos-de-salida/README.md) | Decidir según el código de salida de un comando con `if`, `elif`, `else` y `!` | ~60 min |
| 2 | [lab-02-comparar-textos-y-numeros](lab-02-comparar-textos-y-numeros/README.md) | Comparar textos y números con `[[ ]]` sin las trampas de `[ ]` | ~60 min |
| 3 | [lab-03-operadores-de-archivo](lab-03-operadores-de-archivo/README.md) | Comprobar si una ruta existe, qué es y qué se puede hacer con ella | ~60 min |
| 4 | [lab-04-case](lab-04-case/README.md) | Elegir entre varias opciones con `case` y patrones glob | ~60 min |
| 5 | [lab-05-regex-y-bash-rematch](lab-05-regex-y-bash-rematch/README.md) | Validar un formato con `=~` y sacar sus partes con `BASH_REMATCH` | ~60 min |
| 6 | [lab-06-argumentos](lab-06-argumentos/README.md) | Leer argumentos con `$1`, `$#`, `"$@"` y `shift` | ~60 min |
| 7 | [lab-07-condiciones-rotas](lab-07-condiciones-rotas/README.md) | Encontrar y arreglar con shellcheck las condiciones que responden mal | ~60 min |

**Total labs: 7 horas**

## Antes de cada lab

- Todo se hace dentro del laboratorio Docker, como `alumno`. Desde la raíz del repositorio en tu equipo: `docker compose run --rm lab`.
- Cada lab empieza con un **paso 0**: el `cd` a su carpeta desde `/bc-bash`, la raíz del repositorio dentro del laboratorio.
- Para ver la respuesta de una condición sin `if`, escríbela y añade `; echo $?`: `0` es "se cumple", `1` es "no se cumple".
- Lo que crean los labs va a `zona/`, dentro de la carpeta de cada lab. git la ignora y puedes borrarla cuando quieras: `rm -r zona`.
- Los labs 02, 04, 06 y 07 traen scripts **rotos a propósito**: ejecútalos tal cual antes de arreglarlos, para ver cómo falla cada uno.

Completa los labs en orden. Después, el [Proyecto semanal](../3-proyecto/README.md).

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — Regex con `=~` y argumentos](../1-teoria/04-regex-y-argumentos.md) | [Lab 01 — if y códigos de salida](lab-01-if-y-codigos-de-salida/README.md) → |

[↑ Semana 06](../README.md)
