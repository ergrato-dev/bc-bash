# Semana 03 — Redirección, pipes y códigos de salida

## Descripción

Aprenderás adónde va lo que imprime un comando y cómo cambiarlo: separar resultados de errores, guardarlos en archivos, encadenar comandos con pipes y generar archivos con here-docs. Leerás el código de salida de cada comando para decidir qué hacer después, y harás que tus scripts se paren en el primer error con `set -euo pipefail`. El resultado es `bk-run`, que ejecuta cualquier comando y deja constancia en un log.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Distinguir stdin, stdout y stderr y redirigir cada uno con `<`, `>`, `>>`, `2>` y `&>`
- Juntar stdout y stderr con `2>&1` y explicar por qué el orden de las redirecciones cambia el resultado
- Encadenar comandos con `|` y guardar copias por el camino con `tee`
- Generar archivos de varias líneas con here-docs, con y sin sustitución, y pasar textos con `<<<`
- Leer el código de salida con `$?` y `PIPESTATUS`, y decidir con `&&`, `||` y `exit`
- Activar `set -euo pipefail` y depurar un script siguiendo el error que señala cada opción
- Escribir `bin/bk-run`, que registra la salida y el código de cualquier comando

## Prerrequisitos

- [Semana 02](../week-02-permisos_procesos_y_primer_script/README.md) completada: permisos, shebang, `chmod +x`, `PATH` y `$( )`
- El laboratorio funcionando: ver [docs/setup-entorno.md](../../docs/setup-entorno.md)

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-redireccion-y-descriptores.md](1-teoria/01-redireccion-y-descriptores.md) · [02-pipes-tee-y-here-docs.md](1-teoria/02-pipes-tee-y-here-docs.md) · [03-codigos-de-salida.md](1-teoria/03-codigos-de-salida.md) · [04-set-euo-pipefail.md](1-teoria/04-set-euo-pipefail.md) | 1 h |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 30 min |
| 1 | Lab | [lab-01-stdout-y-stderr](2-practicas/lab-01-stdout-y-stderr/README.md) | 60 min |
| 2 | Lab | [lab-02-sobrescribir-y-anadir](2-practicas/lab-02-sobrescribir-y-anadir/README.md) | 60 min |
| 3 | Lab | [lab-03-orden-de-las-redirecciones](2-practicas/lab-03-orden-de-las-redirecciones/README.md) | 60 min |
| 4 | Lab | [lab-04-pipes-y-tee](2-practicas/lab-04-pipes-y-tee/README.md) | 60 min |
| 5 | Lab | [lab-05-here-docs-y-here-strings](2-practicas/lab-05-here-docs-y-here-strings/README.md) | 60 min |
| 6 | Lab | [lab-06-codigos-de-salida](2-practicas/lab-06-codigos-de-salida/README.md) | 60 min |
| 7 | Lab | [lab-07-modo-estricto](2-practicas/lab-07-modo-estricto/README.md) | 60 min |
| — | Proyecto | [bk-run: ejecutar y dejar constancia](3-proyecto/README.md) | 3 h 30 min |

**Total: 12 horas**

## Distribución del tiempo

```text
[1 h]        Leer 1-teoria/ (descriptores, pipes y here-docs, códigos de salida, modo estricto)
[30 min]     Responder las 10 preguntas de Conocimiento
[60 min]     lab-01 — >, 2>, &> y /dev/null
[60 min]     lab-02 — > frente a >>, noclobber y <
[60 min]     lab-03 — 2>&1 y el orden de las redirecciones
[60 min]     lab-04 — pipes, |& y tee
[60 min]     lab-05 — here-docs y here-strings
[60 min]     lab-06 — $?, PIPESTATUS, &&, || y exit
[60 min]     lab-07 — set -euo pipefail sobre un script roto
[3 h 30 min] Proyecto: bin/bk-run
```

## Verificación de completitud

Desde la raíz del repositorio (en tu equipo o dentro del laboratorio):

```bash
./scripts/verificar-semana.sh 03
```

Comprueba tu proyecto (`3-proyecto/starter/`) contra los 16 requisitos verificables de la semana, dentro del laboratorio Docker.

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [← Semana 02 — Permisos, procesos y primer script](../week-02-permisos_procesos_y_primer_script/README.md) | **Semana 03 — Redirección, pipes y códigos de salida** | [Semana 04 — Filtros de texto y regex →](../week-04-filtros_de_texto_y_regex/README.md) |

[← Volver al índice del bootcamp](../README.md)
