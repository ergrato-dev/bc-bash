# Labs — Semana 03: Redirección, pipes y códigos de salida

| # | Lab | Objetivo | Tiempo |
|---|-----|----------|--------|
| 1 | [lab-01-stdout-y-stderr](lab-01-stdout-y-stderr/README.md) | Separar la salida normal de los errores con `>`, `2>` y `/dev/null` | ~60 min |
| 2 | [lab-02-sobrescribir-y-anadir](lab-02-sobrescribir-y-anadir/README.md) | Elegir entre `>` y `>>`, proteger archivos con `noclobber` y leer por stdin con `<` | ~60 min |
| 3 | [lab-03-orden-de-las-redirecciones](lab-03-orden-de-las-redirecciones/README.md) | Juntar stdout y stderr con `2>&1` y entender por qué importa el orden | ~60 min |
| 4 | [lab-04-pipes-y-tee](lab-04-pipes-y-tee/README.md) | Encadenar comandos con `\|` y guardar una copia por el camino con `tee` | ~60 min |
| 5 | [lab-05-here-docs-y-here-strings](lab-05-here-docs-y-here-strings/README.md) | Generar archivos de varias líneas con here-docs y pasar textos con `<<<` | ~60 min |
| 6 | [lab-06-codigos-de-salida](lab-06-codigos-de-salida/README.md) | Leer `$?` y decidir con `&&`, `\|\|` y `exit` | ~60 min |
| 7 | [lab-07-modo-estricto](lab-07-modo-estricto/README.md) | Depurar un script roto con `set -euo pipefail` | ~60 min |

**Total labs: 7 horas**

## Antes de cada lab

- Todo se hace dentro del laboratorio Docker, como `alumno`. Desde la raíz del repositorio en tu equipo: `docker compose run --rm lab`.
- Cada lab empieza con un **paso 0**: el `cd` a su carpeta desde `/bc-bash`, la raíz del repositorio dentro del laboratorio.
- Lo que crean los labs va a `zona/`, dentro de la carpeta de cada lab. git la ignora y puedes borrarla cuando quieras: `rm -r zona`.
- Los scripts de los labs 01 a 06 todavía no usan `set -euo pipefail`: el lab 07 enseña qué cambia. Desde ahí, todos lo llevan.

Completa los labs en orden. Después, el [Proyecto semanal](../3-proyecto/README.md).

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — Modo estricto: `set -euo pipefail`](../1-teoria/04-set-euo-pipefail.md) | [Lab 01 — stdout y stderr](lab-01-stdout-y-stderr/README.md) → |

[↑ Semana 03](../README.md)
