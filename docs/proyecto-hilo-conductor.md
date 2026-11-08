# Proyecto hilo conductor: `bashkit`

`bashkit` es una CLI de operaciones escrita en bash que construyes tú, semana a semana. Cada `3-proyecto/starter/` es la solución de la semana anterior más los TODOs de la nueva; al terminar la semana 14 tienes una herramienta probada con bats que hace backups de PostgreSQL en Docker.

## Crecimiento por semana

| Semana | Qué se añade | Concepto que lo justifica |
|---|---|---|
| 01 | Árbol `bashkit/{bin,lib,tests,docs}` + `docs/inventario.txt` | Rutas, directorios, `find` |
| 02 | `bin/bk-info` | Shebang, permisos, variables de entorno |
| 03 | `bin/bk-run` | Redirección, códigos de salida, `set -euo pipefail` |
| 04 | `bin/bk-top-ips` | Pipes y filtros de texto |
| 05 | `bin/bk-rename` | Comillas, expansiones de parámetros |
| 06 | `bin/bk-check` | `[[ ]]`, `case`, regex |
| 07 | `bin/bk-clean` | Bucles y archivos con nombres raros |
| 08 | `lib/core.sh` + `bin/bashkit` | Funciones, `source`, dispatcher |
| 09 | `bashkit report` | Arrays asociativos, `printf` |
| 10 | `bashkit logs` | `sed`, `awk`, `jq` |
| 11 | Opciones con `getopts`, `trap`, `flock` | Scripts robustos |
| 12 | `tests/*.bats`, shellcheck y shfmt limpios | Calidad |
| 13 | `bashkit healthcheck` | Concurrencia |
| 14 | `bashkit backup` / `restore` + `compose.yaml` + CI | Producción |

## Reglas

- Trabajas siempre en `3-proyecto/starter/` de la semana en curso: es lo que corrige `./scripts/verificar-semana.sh NN`.
- Si quieres conservar tu versión entre semanas, cópiala encima del `starter/` siguiente antes de empezar; los TODOs nuevos están marcados con `# TODO(semana NN)`.
- Ningún subcomando escribe fuera de su directorio de trabajo o de `mktemp -d`.
