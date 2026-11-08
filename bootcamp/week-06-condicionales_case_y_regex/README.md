# Semana 06 — Condicionales, case y regex

## Descripción

Tus scripts empiezan a decidir: hacer una cosa u otra según el código de salida de un comando, el valor de un texto o un número, lo que hay en una ruta o los argumentos que reciben. Verás por qué `if` no compara nada, por qué `[[ ]]` sustituye a `[ ]` y cómo validar un formato con una regex sin lanzar `grep`. El resultado es `bk-check`, que dice si un valor es una IP, un email o una versión semántica.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Explicar que `if` decide por el código de salida de un comando, y usar `elif`, `else` y `!`
- Comparar textos (`==`, `-z`, `-n`) y números (`-eq`, `-lt`, `-gt`) con `[[ ]]`, y explicar las trampas de `[ ]`
- Comprobar rutas con `-e`, `-f`, `-d`, `-s`, `-r`, `-w`, `-x`, `-L` y `-nt`, en el orden correcto
- Elegir entre varias opciones con `case`, patrones glob, `|` y la rama `*)`
- Validar un formato con `=~` y sacar sus partes con `BASH_REMATCH`
- Leer argumentos con `$1`, `$#`, `"$@"` y `shift`, y pasarlos a otro comando sin romperlos
- Escribir `bin/bk-check`, que valida IP v4, emails y versiones semánticas

## Prerrequisitos

- [Semana 05](../week-05-variables_comillas_y_expansiones/README.md) completada: variables, comillas y expansiones
- El laboratorio funcionando: ver [docs/setup-entorno.md](../../docs/setup-entorno.md)

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-if-y-codigos-de-salida.md](1-teoria/01-if-y-codigos-de-salida.md) · [02-comparar-con-dobles-corchetes.md](1-teoria/02-comparar-con-dobles-corchetes.md) · [03-case.md](1-teoria/03-case.md) · [04-regex-y-argumentos.md](1-teoria/04-regex-y-argumentos.md) | 1 h |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 30 min |
| 1 | Lab | [lab-01-if-y-codigos-de-salida](2-practicas/lab-01-if-y-codigos-de-salida/README.md) | 60 min |
| 2 | Lab | [lab-02-comparar-textos-y-numeros](2-practicas/lab-02-comparar-textos-y-numeros/README.md) | 60 min |
| 3 | Lab | [lab-03-operadores-de-archivo](2-practicas/lab-03-operadores-de-archivo/README.md) | 60 min |
| 4 | Lab | [lab-04-case](2-practicas/lab-04-case/README.md) | 60 min |
| 5 | Lab | [lab-05-regex-y-bash-rematch](2-practicas/lab-05-regex-y-bash-rematch/README.md) | 60 min |
| 6 | Lab | [lab-06-argumentos](2-practicas/lab-06-argumentos/README.md) | 60 min |
| 7 | Lab | [lab-07-condiciones-rotas](2-practicas/lab-07-condiciones-rotas/README.md) | 60 min |
| — | Proyecto | [bk-check: validar antes de usar](3-proyecto/README.md) | 3 h 30 min |

**Total: 12 horas**

## Distribución del tiempo

```text
[1 h]        Leer 1-teoria/ (if, [[ ]], case, regex y argumentos)
[30 min]     Responder las 10 preguntas de Conocimiento
[60 min]     lab-01 — if, elif, else, !, [ como comando y command -v
[60 min]     lab-02 — ==, -z, -n, -eq, -gt y las trampas de [ ]
[60 min]     lab-03 — -e, -f, -d, -s, -r, -w, -x, -L y -nt
[60 min]     lab-04 — case, patrones, | y *)
[60 min]     lab-05 — =~, anclas, comillas y BASH_REMATCH
[60 min]     lab-06 — $1, $#, "$@", "$*" y shift
[60 min]     lab-07 — depurar condiciones con shellcheck
[3 h 30 min] Proyecto: bin/bk-check
```

## Verificación de completitud

Desde la raíz del repositorio (en tu equipo o dentro del laboratorio):

```bash
./scripts/verificar-semana.sh 06
```

Comprueba tu proyecto (`3-proyecto/starter/`) contra los 15 requisitos verificables de la semana, dentro del laboratorio Docker.

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [← Semana 05 — Variables, comillas y expansiones](../week-05-variables_comillas_y_expansiones/README.md) | **Semana 06 — Condicionales, case y regex** | — |

[← Volver al índice del bootcamp](../README.md)
