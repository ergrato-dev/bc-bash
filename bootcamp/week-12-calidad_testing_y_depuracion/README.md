# Semana 12 — Calidad, testing y depuración

## Descripción

`bashkit` ya tiene diez comandos, y cada cambio puede romper alguno sin que lo notes. Esta semana aprendes a revisar los scripts sin ejecutarlos con shellcheck y shfmt, a escribir tests con bats que los ejecutan por ti, a seguir un script línea a línea con `set -x` cuando falla sin avisar y a medir qué lo hace lento. Con todo eso, el kit pasa a comprobarse solo.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Leer y arreglar los avisos de shellcheck, y callar con un motivo los que no son fallos
- Dar a todos los scripts un mismo estilo con shfmt (`-d`, `-w`, `.editorconfig`)
- Escribir tests con bats que comprueban el código, la salida y stderr de un comando con `run`
- Aislar cada test en su carpeta temporal con `setup`, `teardown` y `$BATS_TEST_TMPDIR`
- Encontrar un fallo sin aviso con `set -x`, `PS4` y `BASH_XTRACEFD`, y localizar dónde se para un script con `trap ERR`
- Fijar un fallo con un test de regresión escrito antes del arreglo
- Medir un script con `time` y quitar los procesos de un bucle con expansiones y builtins
- Añadir a `bashkit` una suite de tests, `bashkit lint` y la traza `BK_TRACE`

## Prerrequisitos

- [Semana 11](../week-11-scripts_robustos/README.md) completada: `getopts`, `trap`, `mktemp`, `flock` y `bk-run` robusto
- Las expansiones `${var#...}` y `${var%...}` de la [semana 05](../week-05-variables_comillas_y_expansiones/README.md) y el subshell de un pipe de la [semana 07](../week-07-bucles_read_y_archivos_seguros/README.md)
- El laboratorio funcionando: ver [docs/setup-entorno.md](../../docs/setup-entorno.md)

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-shellcheck-y-shfmt.md](1-teoria/01-shellcheck-y-shfmt.md) · [02-tests-con-bats.md](1-teoria/02-tests-con-bats.md) · [03-depuracion-y-rendimiento.md](1-teoria/03-depuracion-y-rendimiento.md) | 1 h |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 30 min |
| 1 | Lab | [lab-01-avisos-de-shellcheck](2-practicas/lab-01-avisos-de-shellcheck/README.md) | 60 min |
| 2 | Lab | [lab-02-formato-con-shfmt](2-practicas/lab-02-formato-con-shfmt/README.md) | 60 min |
| 3 | Lab | [lab-03-primeros-tests-con-bats](2-practicas/lab-03-primeros-tests-con-bats/README.md) | 60 min |
| 4 | Lab | [lab-04-setup-y-temporales-en-bats](2-practicas/lab-04-setup-y-temporales-en-bats/README.md) | 60 min |
| 5 | Lab | [lab-05-traza-con-set-x](2-practicas/lab-05-traza-con-set-x/README.md) | 60 min |
| 6 | Lab | [lab-06-depurar-con-tests](2-practicas/lab-06-depurar-con-tests/README.md) | 60 min |
| 7 | Lab | [lab-07-rendimiento-subshells-y-builtins](2-practicas/lab-07-rendimiento-subshells-y-builtins/README.md) | 60 min |
| — | Proyecto | [Tests, lint y depuración de bashkit](3-proyecto/README.md) | 3 h 30 min |

**Total: 12 horas**

## Distribución del tiempo

```text
[1 h]        Leer 1-teoria/ (shellcheck, shfmt, bats, set -x, rendimiento)
[30 min]     Responder las 10 preguntas de Conocimiento
[60 min]     lab-01 — depurar los avisos de shellcheck
[60 min]     lab-02 — formato con shfmt
[60 min]     lab-03 — primeros tests con bats
[60 min]     lab-04 — setup, teardown y temporales
[60 min]     lab-05 — encontrar un fallo con la traza
[60 min]     lab-06 — un test antes de cada arreglo
[60 min]     lab-07 — medir y quitar procesos
[3 h 30 min] Proyecto: tests/, bin/bk-lint, BK_TRACE y bk-report
```

## Verificación de completitud

Desde la raíz del repositorio (en tu equipo o dentro del laboratorio):

```bash
./scripts/verificar-semana.sh 12
```

Comprueba tu proyecto (`3-proyecto/starter/`) contra los 15 requisitos verificables de la semana, dentro del laboratorio Docker.

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [← Semana 11 — Scripts robustos](../week-11-scripts_robustos/README.md) | **Semana 12 — Calidad, testing y depuración** | [Semana 13 — Procesos y concurrencia →](../week-13-procesos_y_concurrencia/README.md) |

[← Volver al índice del bootcamp](../README.md)
