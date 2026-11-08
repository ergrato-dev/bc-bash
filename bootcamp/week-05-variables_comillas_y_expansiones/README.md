# Semana 05 — Variables, comillas y expansiones

## Descripción

Empiezas a programar en bash: guardar datos en variables, decidir con las comillas qué sustituye bash y qué llega tal cual, y transformar textos con expansiones de parámetros, cuentas y salidas de comandos. Verás por qué una variable sin comillas puede borrar archivos que nadie nombró, y cómo evitarlo siempre. El resultado es `bk-rename`, que limpia nombres de archivo con espacios, tildes y mayúsculas.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Crear, usar, borrar y exportar variables, y marcar dónde acaba su nombre con `${ }`
- Elegir entre comillas simples, dobles, `\` y `$'...'` según lo que tenga que sustituirse
- Explicar el word splitting y el globbing, y evitarlos con comillas dobles y `--`
- Dar valores por defecto y exigir variables con `${var:-}`, `${var:=}`, `${var:?}` y `${var:+}`
- Recortar, sustituir y cambiar a mayúsculas con `#`, `%`, `/`, `//`, `^^` y `,,`
- Hacer cuentas con enteros en `$(( ))` y guardar la salida de un comando con `$( )`
- Escribir `bin/bk-rename`, que normaliza el nombre de un archivo y tiene modo `--dry-run`

## Prerrequisitos

- [Semana 04](../week-04-filtros_de_texto_y_regex/README.md) completada: filtros, regex y `find`
- El laboratorio funcionando: ver [docs/setup-entorno.md](../../docs/setup-entorno.md)

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-variables-y-comillas.md](1-teoria/01-variables-y-comillas.md) · [02-word-splitting-y-globbing.md](1-teoria/02-word-splitting-y-globbing.md) · [03-expansiones-de-parametros.md](1-teoria/03-expansiones-de-parametros.md) · [04-aritmetica-y-sustitucion-de-comandos.md](1-teoria/04-aritmetica-y-sustitucion-de-comandos.md) | 1 h |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 30 min |
| 1 | Lab | [lab-01-variables](2-practicas/lab-01-variables/README.md) | 60 min |
| 2 | Lab | [lab-02-comillas](2-practicas/lab-02-comillas/README.md) | 60 min |
| 3 | Lab | [lab-03-word-splitting-y-globbing](2-practicas/lab-03-word-splitting-y-globbing/README.md) | 60 min |
| 4 | Lab | [lab-04-valores-por-defecto](2-practicas/lab-04-valores-por-defecto/README.md) | 60 min |
| 5 | Lab | [lab-05-recortar-y-sustituir](2-practicas/lab-05-recortar-y-sustituir/README.md) | 60 min |
| 6 | Lab | [lab-06-aritmetica](2-practicas/lab-06-aritmetica/README.md) | 60 min |
| 7 | Lab | [lab-07-sustitucion-de-comandos](2-practicas/lab-07-sustitucion-de-comandos/README.md) | 60 min |
| — | Proyecto | [bk-rename: nombres de archivo sin sorpresas](3-proyecto/README.md) | 3 h 30 min |

**Total: 12 horas**

## Distribución del tiempo

```text
[1 h]        Leer 1-teoria/ (variables y comillas, word splitting, expansiones, aritmética y $( ))
[30 min]     Responder las 10 preguntas de Conocimiento
[60 min]     lab-01 — asignar, ${ }, unset, set -u y export
[60 min]     lab-02 — comillas simples, dobles, \ y $'...'
[60 min]     lab-03 — word splitting, globs y --
[60 min]     lab-04 — ${var:-}, ${var:=}, ${var:?} y ${var:+}
[60 min]     lab-05 — ${#}, ${:}, #, ##, %, %%, /, // y mayúsculas
[60 min]     lab-06 — $(( )), división entera, ((n++)) y octal
[60 min]     lab-07 — $( ), saltos de línea, stderr y comillas
[3 h 30 min] Proyecto: bin/bk-rename
```

## Verificación de completitud

Desde la raíz del repositorio (en tu equipo o dentro del laboratorio):

```bash
./scripts/verificar-semana.sh 05
```

Comprueba tu proyecto (`3-proyecto/starter/`) contra los 15 requisitos verificables de la semana, dentro del laboratorio Docker.

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [← Semana 04 — Filtros de texto y regex](../week-04-filtros_de_texto_y_regex/README.md) | **Semana 05 — Variables, comillas y expansiones** | — |

[← Volver al índice del bootcamp](../README.md)
