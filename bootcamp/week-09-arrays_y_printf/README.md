# Semana 09 — Arrays y printf

## Descripción

Hasta ahora, cada variable guardaba un solo texto. Esta semana guardarás listas en arrays indexados, buscarás y contarás por nombre con arrays asociativos, y escribirás tablas alineadas con `printf`. Con todo eso añadirás a `bashkit` el subcomando `report`: un resumen en tabla de lo que `bk-run` dejó en su log.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Crear arrays, leer sus elementos por posición, añadir al final y saber cuántos hay
- Distinguir `"${arr[@]}"`, `"${arr[*]}"` y la expansión sin comillas, y pasar argumentos a un comando en un array
- Sacar trozos con slices y recorrer arrays con huecos por sus índices
- Buscar y contar por clave con `declare -A`, comprobar una clave con `-v` y ordenar la salida
- Escribir tablas con `printf`: anchos fijos y calculados, números, `%%` y `printf -v`
- Evitar los fallos típicos: `((x++))` con `set -e`, un dato dentro del formato y las tildes que desalinean
- Escribir `bin/bk-report` (`bashkit report`)

## Prerrequisitos

- [Semana 08](../week-08-funciones_alcance_y_librerias/README.md) completada: funciones, `lib/core.sh` y el dispatcher `bashkit`
- El laboratorio funcionando: ver [docs/setup-entorno.md](../../docs/setup-entorno.md)

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-arrays-indexados.md](1-teoria/01-arrays-indexados.md) · [02-arrays-asociativos.md](1-teoria/02-arrays-asociativos.md) · [03-printf-y-tablas.md](1-teoria/03-printf-y-tablas.md) | 1 h |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 30 min |
| 1 | Lab | [lab-01-arrays-indexados](2-practicas/lab-01-arrays-indexados/README.md) | 60 min |
| 2 | Lab | [lab-02-arroba-y-asterisco](2-practicas/lab-02-arroba-y-asterisco/README.md) | 60 min |
| 3 | Lab | [lab-03-huecos-y-slices](2-practicas/lab-03-huecos-y-slices/README.md) | 60 min |
| 4 | Lab | [lab-04-arrays-asociativos](2-practicas/lab-04-arrays-asociativos/README.md) | 60 min |
| 5 | Lab | [lab-05-contar-por-clave](2-practicas/lab-05-contar-por-clave/README.md) | 60 min |
| 6 | Lab | [lab-06-printf-y-formatos](2-practicas/lab-06-printf-y-formatos/README.md) | 60 min |
| 7 | Lab | [lab-07-tablas-rotas](2-practicas/lab-07-tablas-rotas/README.md) | 60 min |
| — | Proyecto | [bashkit report: el log de bk-run en una tabla](3-proyecto/README.md) | 3 h 30 min |

**Total: 12 horas**

## Distribución del tiempo

```text
[1 h]        Leer 1-teoria/ (arrays indexados, asociativos y printf)
[30 min]     Responder las 10 preguntas de Conocimiento
[60 min]     lab-01 — crear, leer y recorrer un array
[60 min]     lab-02 — "${arr[@]}" frente a "${arr[*]}", argumentos en un array
[60 min]     lab-03 — slices y huecos
[60 min]     lab-04 — declare -A, -v y claves ordenadas
[60 min]     lab-05 — contar por clave sin que set -e pare
[60 min]     lab-06 — tablas con printf
[60 min]     lab-07 — depurar arrays y printf con y sin shellcheck
[3 h 30 min] Proyecto: bin/bk-report
```

## Verificación de completitud

Desde la raíz del repositorio (en tu equipo o dentro del laboratorio):

```bash
./scripts/verificar-semana.sh 09
```

Comprueba tu proyecto (`3-proyecto/starter/`) contra los 15 requisitos verificables de la semana, dentro del laboratorio Docker.

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [← Semana 08 — Funciones, alcance y librerías](../week-08-funciones_alcance_y_librerias/README.md) | **Semana 09 — Arrays y printf** | [Semana 10 — sed, awk y jq →](../week-10-sed_awk_y_jq/README.md) |

[← Volver al índice del bootcamp](../README.md)
