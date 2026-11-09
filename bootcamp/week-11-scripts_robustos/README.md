# Semana 11 — Scripts robustos

## Descripción

Un script que funciona cuando lo lanzas tú, una vez, no está listo para un cron, para un deploy que se reintenta ni para dos compañeros a la vez. Esta semana ves dónde falla `set -e`, cómo limpiar siempre con `trap` y `mktemp`, cómo leer opciones con `getopts`, cómo impedir que dos copias se pisen con `flock` y cómo escribir avisos por niveles. Con todo eso conviertes `bk-run` en un comando que aguanta el uso real.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Reconocer dónde no para `set -e` (funciones en condiciones, `local x=$(...)`, `((n++))`) y arreglarlo
- Crear temporales con `mktemp` y borrarlos siempre al salir con `trap ... EXIT`
- Atrapar `INT` y `TERM`, salir con el código de cada señal y explicar por qué `KILL` no se puede atrapar
- Leer opciones con y sin valor con `getopts`, `OPTARG` y `OPTIND`, y avisar de las que están mal
- Impedir que un script corra dos veces a la vez con `flock`, rindiéndose o esperando
- Escribir avisos con nivel, hora y copia en un archivo, y hacer scripts idempotentes
- Convertir `bin/bk-run` en un comando con opciones, temporal y bloqueo (`bashkit run`)

## Prerrequisitos

- [Semana 10](../week-10-sed_awk_y_jq/README.md) completada: `sed`, `awk`, `jq` y `bashkit logs`
- Las funciones, `local` y `source` de la [semana 08](../week-08-funciones_alcance_y_librerias/README.md), y los descriptores de la [semana 03](../week-03-redireccion_pipes_y_codigos_de_salida/README.md)
- El laboratorio funcionando: ver [docs/setup-entorno.md](../../docs/setup-entorno.md)

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-set-e-trap-y-mktemp.md](1-teoria/01-set-e-trap-y-mktemp.md) · [02-getopts.md](1-teoria/02-getopts.md) · [03-flock-logging-e-idempotencia.md](1-teoria/03-flock-logging-e-idempotencia.md) | 1 h |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 30 min |
| 1 | Lab | [lab-01-limites-de-set-e](2-practicas/lab-01-limites-de-set-e/README.md) | 60 min |
| 2 | Lab | [lab-02-trap-exit-y-mktemp](2-practicas/lab-02-trap-exit-y-mktemp/README.md) | 60 min |
| 3 | Lab | [lab-03-senales-int-y-term](2-practicas/lab-03-senales-int-y-term/README.md) | 60 min |
| 4 | Lab | [lab-04-opciones-con-getopts](2-practicas/lab-04-opciones-con-getopts/README.md) | 60 min |
| 5 | Lab | [lab-05-bloqueo-con-flock](2-practicas/lab-05-bloqueo-con-flock/README.md) | 60 min |
| 6 | Lab | [lab-06-logging-por-niveles](2-practicas/lab-06-logging-por-niveles/README.md) | 60 min |
| 7 | Lab | [lab-07-script-idempotente](2-practicas/lab-07-script-idempotente/README.md) | 60 min |
| — | Proyecto | [bk-run robusto: opciones, temporales y bloqueo](3-proyecto/README.md) | 3 h 30 min |

**Total: 12 horas**

## Distribución del tiempo

```text
[1 h]        Leer 1-teoria/ (set -e, trap, getopts, flock)
[30 min]     Responder las 10 preguntas de Conocimiento
[60 min]     lab-01 — dónde no para set -e
[60 min]     lab-02 — mktemp y trap EXIT
[60 min]     lab-03 — INT, TERM y KILL
[60 min]     lab-04 — getopts
[60 min]     lab-05 — flock
[60 min]     lab-06 — avisos por niveles
[60 min]     lab-07 — depurar un script que no se puede repetir
[3 h 30 min] Proyecto: bin/bk-run y lib/core.sh
```

## Verificación de completitud

Desde la raíz del repositorio (en tu equipo o dentro del laboratorio):

```bash
./scripts/verificar-semana.sh 11
```

Comprueba tu proyecto (`3-proyecto/starter/`) contra los 15 requisitos verificables de la semana, dentro del laboratorio Docker.

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [← Semana 10 — sed, awk y jq](../week-10-sed_awk_y_jq/README.md) | **Semana 11 — Scripts robustos** | — |

[← Volver al índice del bootcamp](../README.md)
