# Labs — Semana 12: Calidad, testing y depuración

| # | Lab | Objetivo | Tiempo |
|---|-----|----------|--------|
| 1 | [lab-01-avisos-de-shellcheck](lab-01-avisos-de-shellcheck/README.md) | Leer y arreglar los avisos de shellcheck de un script roto, y callar con un motivo el que no es un fallo | ~60 min |
| 2 | [lab-02-formato-con-shfmt](lab-02-formato-con-shfmt/README.md) | Ver con `-d` y aplicar con `-w` un estilo fijo, con opciones o con un `.editorconfig` | ~60 min |
| 3 | [lab-03-primeros-tests-con-bats](lab-03-primeros-tests-con-bats/README.md) | Escribir tests con `run`, `$status`, `$output` y `$lines`, y encontrar un fallo con uno | ~60 min |
| 4 | [lab-04-setup-y-temporales-en-bats](lab-04-setup-y-temporales-en-bats/README.md) | Aislar cada test con `setup` y `$BATS_TEST_TMPDIR`, compartir con `load` y limpiar con `teardown` | ~60 min |
| 5 | [lab-05-traza-con-set-x](lab-05-traza-con-set-x/README.md) | Encontrar con `set -x`, `PS4` y `BASH_XTRACEFD` un fallo que no da ningún error | ~60 min |
| 6 | [lab-06-depurar-con-tests](lab-06-depurar-con-tests/README.md) | Arreglar cuatro fallos escribiendo antes un test para cada uno, y localizar otro con `trap ERR` | ~60 min |
| 7 | [lab-07-rendimiento-subshells-y-builtins](lab-07-rendimiento-subshells-y-builtins/README.md) | Medir con `time` y quitar los procesos de un bucle con expansiones y builtins | ~60 min |

**Total labs: 7 horas**

## Antes de cada lab

- Todo se hace dentro del laboratorio Docker, como `alumno`. Desde la raíz del repositorio en tu equipo: `docker compose run --rm lab`. shellcheck, shfmt y bats ya están instalados.
- Cada lab empieza con un **paso 0**: el `cd` a su carpeta desde `/bc-bash`, la raíz del repositorio dentro del laboratorio.
- bats escribe en tu terminal con marcas `✓` y `✗`. Cuando su salida va a un pipe o a un archivo (y en el autograding), usa el formato TAP: líneas `ok` y `not ok`. Algunos pasos lo piden a propósito con `--tap`.
- Los labs 01, 05 y 06 traen un script **roto a propósito**: ejecútalo tal cual antes de arreglarlo, para ver cómo falla.
- Los tiempos del lab 07 dependen de tu equipo: lo que importa es cuántas veces más rápido va cada cambio.

Completa los labs en orden. Después, el [Proyecto semanal](../3-proyecto/README.md).

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — Depurar y medir: set -x, trap ERR y time](../1-teoria/03-depuracion-y-rendimiento.md) | [Lab 01 — Los avisos de shellcheck](lab-01-avisos-de-shellcheck/README.md) → |

[↑ Semana 12](../README.md)
