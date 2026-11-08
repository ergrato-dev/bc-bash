# Semana 04 — Filtros de texto y regex

## Descripción

Aprenderás a sacar respuestas de archivos de texto: ver un log por partes, elegir sus líneas con `grep`, describir lo que buscas con expresiones regulares, cortar columnas, ordenar y contar. Encadenarás esos filtros en pipes para responder preguntas reales sobre un servidor, y encontrarás archivos por nombre, fecha y tamaño con `find`. El resultado es `bk-top-ips`, que dice qué IP cargan más un servidor web.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Leer archivos por partes con `less`, `head` y `tail`, seguir un log con `tail -f` y contar con `wc`
- Elegir líneas con `grep` y sus opciones, y tratar su código de salida en scripts con `set -e`
- Escribir expresiones regulares básicas y extendidas, y sacar solo lo que encaja con `grep -o`
- Sacar columnas con `cut` y limpiar caracteres con `tr`, incluidos los finales de línea de Windows
- Ordenar como texto o como número con `sort` y contar repetidas con `sort | uniq -c | sort -rn`
- Encontrar archivos con `find` por nombre, tipo, antigüedad y tamaño, y actuar sobre ellos
- Escribir `bin/bk-top-ips`, que cuenta las peticiones de cada IP en un access log

## Prerrequisitos

- [Semana 03](../week-03-redireccion_pipes_y_codigos_de_salida/README.md) completada: redirecciones, pipes, códigos de salida y `set -euo pipefail`
- El laboratorio funcionando: ver [docs/setup-entorno.md](../../docs/setup-entorno.md)

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-filtros-de-texto.md](1-teoria/01-filtros-de-texto.md) · [02-grep-y-expresiones-regulares.md](1-teoria/02-grep-y-expresiones-regulares.md) · [03-cortar-ordenar-y-contar.md](1-teoria/03-cortar-ordenar-y-contar.md) · [04-buscar-archivos-con-find.md](1-teoria/04-buscar-archivos-con-find.md) | 1 h |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 30 min |
| 1 | Lab | [lab-01-ver-y-contar-lineas](2-practicas/lab-01-ver-y-contar-lineas/README.md) | 60 min |
| 2 | Lab | [lab-02-grep](2-practicas/lab-02-grep/README.md) | 60 min |
| 3 | Lab | [lab-03-expresiones-regulares](2-practicas/lab-03-expresiones-regulares/README.md) | 60 min |
| 4 | Lab | [lab-04-cut-y-tr](2-practicas/lab-04-cut-y-tr/README.md) | 60 min |
| 5 | Lab | [lab-05-sort-y-uniq](2-practicas/lab-05-sort-y-uniq/README.md) | 60 min |
| 6 | Lab | [lab-06-buscar-con-find](2-practicas/lab-06-buscar-con-find/README.md) | 60 min |
| 7 | Lab | [lab-07-analizar-un-access-log](2-practicas/lab-07-analizar-un-access-log/README.md) | 60 min |
| — | Proyecto | [bk-top-ips: quién carga el servidor](3-proyecto/README.md) | 3 h 30 min |

**Total: 12 horas**

## Distribución del tiempo

```text
[1 h]        Leer 1-teoria/ (filtros, grep y regex, cut/tr/sort/uniq, find)
[30 min]     Responder las 10 preguntas de Conocimiento
[60 min]     lab-01 — less, head, tail, tail -f y wc
[60 min]     lab-02 — grep y sus opciones, grep con set -e
[60 min]     lab-03 — regex básicas y extendidas, grep -o
[60 min]     lab-04 — cut, tr y el \r de Windows
[60 min]     lab-05 — sort, sort -n y uniq -c
[60 min]     lab-06 — find, -exec, -delete y el patrón sin comillas
[60 min]     lab-07 — un access log con pipes de filtros
[3 h 30 min] Proyecto: bin/bk-top-ips
```

## Verificación de completitud

Desde la raíz del repositorio (en tu equipo o dentro del laboratorio):

```bash
./scripts/verificar-semana.sh 04
```

Comprueba tu proyecto (`3-proyecto/starter/`) contra los 15 requisitos verificables de la semana, dentro del laboratorio Docker.

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [← Semana 03 — Redirección, pipes y códigos de salida](../week-03-redireccion_pipes_y_codigos_de_salida/README.md) | **Semana 04 — Filtros de texto y regex** | [Semana 05 — Variables, comillas y expansiones →](../week-05-variables_comillas_y_expansiones/README.md) |

[← Volver al índice del bootcamp](../README.md)
