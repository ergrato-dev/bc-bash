# Labs — Semana 04: Filtros de texto y regex

| # | Lab | Objetivo | Tiempo |
|---|-----|----------|--------|
| 1 | [lab-01-ver-y-contar-lineas](lab-01-ver-y-contar-lineas/README.md) | Leer un log por partes con `less`, `head` y `tail`, seguirlo con `tail -f` y contar con `wc` | ~60 min |
| 2 | [lab-02-grep](lab-02-grep/README.md) | Elegir líneas con `grep` y tratar el "no encontró nada" con `set -e` | ~60 min |
| 3 | [lab-03-expresiones-regulares](lab-03-expresiones-regulares/README.md) | Describir textos con regex básicas y extendidas y sacarlos con `grep -o` | ~60 min |
| 4 | [lab-04-cut-y-tr](lab-04-cut-y-tr/README.md) | Sacar columnas con `cut` y limpiar caracteres con `tr` | ~60 min |
| 5 | [lab-05-sort-y-uniq](lab-05-sort-y-uniq/README.md) | Ordenar como texto o como número y contar repetidas con `uniq -c` | ~60 min |
| 6 | [lab-06-buscar-con-find](lab-06-buscar-con-find/README.md) | Encontrar archivos por nombre, fecha y tamaño con `find` | ~60 min |
| 7 | [lab-07-analizar-un-access-log](lab-07-analizar-un-access-log/README.md) | Responder preguntas sobre el tráfico de un servidor con pipes de filtros | ~60 min |

**Total labs: 7 horas**

## Antes de cada lab

- Todo se hace dentro del laboratorio Docker, como `alumno`. Desde la raíz del repositorio en tu equipo: `docker compose run --rm lab`.
- Cada lab empieza con un **paso 0**: el `cd` a su carpeta desde `/bc-bash`, la raíz del repositorio dentro del laboratorio.
- Los datos de cada lab están en su carpeta `datos/`. No los cambies: los outputs de los pasos cuentan con que estén igual.
- Lo que crean los labs va a `zona/`, dentro de la carpeta de cada lab. git la ignora y puedes borrarla cuando quieras: `rm -r zona`.
- Todos los scripts empiezan con `set -euo pipefail` (semana 03). El lab 02 enseña el caso en que eso te sorprende: un `grep` que no encuentra nada.

Completa los labs en orden. Después, el [Proyecto semanal](../3-proyecto/README.md).

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — Buscar archivos con find](../1-teoria/04-buscar-archivos-con-find.md) | [Lab 01 — Ver y contar líneas](lab-01-ver-y-contar-lineas/README.md) → |

[↑ Semana 04](../README.md)
