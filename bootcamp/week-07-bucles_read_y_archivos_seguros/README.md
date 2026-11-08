# Semana 07 — Bucles, read y archivos seguros

## Descripción

Tus scripts empiezan a repetir: una vez por archivo, por línea, por argumento o hasta que pase algo. Verás por qué `for f in $(ls)` se rompe con un espacio, por qué `cat archivo | while` pierde las variables y cómo recorrer archivos con cualquier nombre, saltos de línea incluidos. El resultado es `bk-clean`, que borra los archivos viejos de una carpeta sin tocar nada más.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Recorrer listas, rangos, globs y argumentos con `for`, y explicar por qué nunca `$(ls)`
- Repetir con `while` y `until` según una condición, con un límite para no colgarse
- Saltar vueltas con `continue`, salir con `break` y saber después cómo terminó el bucle
- Leer un archivo línea a línea con `while IFS= read -r`, partir campos con `IFS` y no perder la última línea
- Cargar un archivo en un array con `mapfile -t` y usar un índice validado
- Recorrer archivos con cualquier nombre con `find -print0`, `read -d ''` y `< <(...)`, y borrar con `rm --`
- Escribir `bin/bk-clean`, que borra archivos viejos con `--dry-run` y sin salir de sus carpetas

## Prerrequisitos

- [Semana 06](../week-06-condicionales_case_y_regex/README.md) completada: condicionales, `case` y regex
- El laboratorio funcionando: ver [docs/setup-entorno.md](../../docs/setup-entorno.md)

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-for.md](1-teoria/01-for.md) · [02-while-until-break-y-continue.md](1-teoria/02-while-until-break-y-continue.md) · [03-leer-lineas-read-y-mapfile.md](1-teoria/03-leer-lineas-read-y-mapfile.md) · [04-archivos-con-cualquier-nombre.md](1-teoria/04-archivos-con-cualquier-nombre.md) | 1 h |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 30 min |
| 1 | Lab | [lab-01-for](2-practicas/lab-01-for/README.md) | 60 min |
| 2 | Lab | [lab-02-while-y-until](2-practicas/lab-02-while-y-until/README.md) | 60 min |
| 3 | Lab | [lab-03-break-y-continue](2-practicas/lab-03-break-y-continue/README.md) | 60 min |
| 4 | Lab | [lab-04-read-e-ifs](2-practicas/lab-04-read-e-ifs/README.md) | 60 min |
| 5 | Lab | [lab-05-mapfile](2-practicas/lab-05-mapfile/README.md) | 60 min |
| 6 | Lab | [lab-06-find-print0](2-practicas/lab-06-find-print0/README.md) | 60 min |
| 7 | Lab | [lab-07-bucles-rotos](2-practicas/lab-07-bucles-rotos/README.md) | 60 min |
| — | Proyecto | [bk-clean: borrar lo viejo sin miedo](3-proyecto/README.md) | 3 h 30 min |

**Total: 12 horas**

## Distribución del tiempo

```text
[1 h]        Leer 1-teoria/ (for, while/until, read/mapfile y nombres raros)
[30 min]     Responder las 10 preguntas de Conocimiento
[60 min]     lab-01 — for, rangos, globs y por qué no $(ls)
[60 min]     lab-02 — while, until y un límite de espera
[60 min]     lab-03 — break, continue y cómo terminó el bucle
[60 min]     lab-04 — while IFS= read -r, campos y la última línea
[60 min]     lab-05 — mapfile -t, arrays e índices
[60 min]     lab-06 — find -print0, read -d '', < <(...) y rm --
[60 min]     lab-07 — depurar bucles con y sin shellcheck
[3 h 30 min] Proyecto: bin/bk-clean
```

## Verificación de completitud

Desde la raíz del repositorio (en tu equipo o dentro del laboratorio):

```bash
./scripts/verificar-semana.sh 07
```

Comprueba tu proyecto (`3-proyecto/starter/`) contra los 15 requisitos verificables de la semana, dentro del laboratorio Docker.

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [← Semana 06 — Condicionales, case y regex](../week-06-condicionales_case_y_regex/README.md) | **Semana 07 — Bucles, read y archivos seguros** | [Semana 08 — Funciones, alcance y librerías →](../week-08-funciones_alcance_y_librerias/README.md) |

[← Volver al índice del bootcamp](../README.md)
