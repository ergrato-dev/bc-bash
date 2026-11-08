# Labs — Semana 07: Bucles, read y archivos seguros

| # | Lab | Objetivo | Tiempo |
|---|-----|----------|--------|
| 1 | [lab-01-for](lab-01-for/README.md) | Repetir un bloque por cada elemento de una lista, un rango o un glob, sin partir los nombres | ~60 min |
| 2 | [lab-02-while-y-until](lab-02-while-y-until/README.md) | Repetir mientras se cumpla una condición, o hasta que se cumpla, con un límite | ~60 min |
| 3 | [lab-03-break-y-continue](lab-03-break-y-continue/README.md) | Saltar una vuelta con `continue` y salir del bucle con `break` | ~60 min |
| 4 | [lab-04-read-e-ifs](lab-04-read-e-ifs/README.md) | Leer un archivo línea a línea y partir cada línea en campos con `IFS` | ~60 min |
| 5 | [lab-05-mapfile](lab-05-mapfile/README.md) | Cargar un archivo en un array con `mapfile -t` y sacar una línea por su número | ~60 min |
| 6 | [lab-06-find-print0](lab-06-find-print0/README.md) | Recorrer archivos con cualquier nombre con `find -print0` y `read -d ''` | ~60 min |
| 7 | [lab-07-bucles-rotos](lab-07-bucles-rotos/README.md) | Encontrar los cuatro fallos típicos de los bucles, con y sin shellcheck | ~60 min |

**Total labs: 7 horas**

## Antes de cada lab

- Todo se hace dentro del laboratorio Docker, como `alumno`. Desde la raíz del repositorio en tu equipo: `docker compose run --rm lab`.
- Cada lab empieza con un **paso 0**: el `cd` a su carpeta desde `/bc-bash`, la raíz del repositorio dentro del laboratorio.
- Si un bucle no termina, `Ctrl+C` lo para.
- Lo que crean los labs va a `zona/`, dentro de la carpeta de cada lab. git la ignora y puedes borrarla cuando quieras: `rm -r zona`.
- El lab 07 trae un script **roto a propósito**: ejecútalo tal cual antes de arreglarlo, para ver cómo falla.

Completa los labs en orden. Después, el [Proyecto semanal](../3-proyecto/README.md).

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — Archivos con cualquier nombre](../1-teoria/04-archivos-con-cualquier-nombre.md) | [Lab 01 — for](lab-01-for/README.md) → |

[↑ Semana 07](../README.md)
