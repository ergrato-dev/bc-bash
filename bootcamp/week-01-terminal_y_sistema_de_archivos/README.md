# Semana 01 — Terminal y sistema de archivos

## Descripción

Abrirás una terminal por primera vez y aprenderás a moverte por el sistema de archivos, crear, copiar, mover, borrar y buscar archivos, y pedir ayuda cuando no sepas un comando. Es la base de todo lo demás: un script de bash no es más que estos mismos comandos escritos en un archivo.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Distinguir terminal, shell y programa, y saber cuál de ellos te muestra un error
- Leer el prompt y escribir comandos con opciones y argumentos
- Moverte por el árbol con `cd` usando rutas absolutas y relativas (`.`, `..`, `~`)
- Crear, copiar, mover, renombrar y borrar archivos y carpetas sin perder datos por accidente
- Buscar archivos por nombre y tipo con `find` y guardar el resultado con `>`
- Encontrar por tu cuenta qué hace un comando con `type`, `help`, `--help` y `man`
- Escribir tu primer script, `scaffold.sh`, que crea el esqueleto de `bashkit`

## Prerrequisitos

- Saber instalar un programa en tu sistema y usar un editor de texto
- Docker instalado y el laboratorio construido (`docker compose build`): ver [docs/setup-entorno.md](../../docs/setup-entorno.md)

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-terminal-shell-y-comandos.md](1-teoria/01-terminal-shell-y-comandos.md) · [02-sistema-de-archivos-y-rutas.md](1-teoria/02-sistema-de-archivos-y-rutas.md) · [03-crear-copiar-mover-borrar.md](1-teoria/03-crear-copiar-mover-borrar.md) · [04-ayuda-atajos-e-historial.md](1-teoria/04-ayuda-atajos-e-historial.md) | 1 h |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 30 min |
| 1 | Lab | [lab-01-primer-contacto](2-practicas/lab-01-primer-contacto/README.md) | 60 min |
| 2 | Lab | [lab-02-moverse-con-cd-tab-e-historial](2-practicas/lab-02-moverse-con-cd-tab-e-historial/README.md) | 60 min |
| 3 | Lab | [lab-03-listar-y-mirar-archivos](2-practicas/lab-03-listar-y-mirar-archivos/README.md) | 60 min |
| 4 | Lab | [lab-04-crear-copiar-y-mover](2-practicas/lab-04-crear-copiar-y-mover/README.md) | 60 min |
| 5 | Lab | [lab-05-borrar-sin-sustos](2-practicas/lab-05-borrar-sin-sustos/README.md) | 60 min |
| 6 | Lab | [lab-06-pedir-ayuda](2-practicas/lab-06-pedir-ayuda/README.md) | 60 min |
| 7 | Lab | [lab-07-buscar-con-find](2-practicas/lab-07-buscar-con-find/README.md) | 60 min |
| — | Proyecto | [El esqueleto de bashkit](3-proyecto/README.md) | 3 h 30 min |

**Total: 12 horas**

## Distribución del tiempo

```text
[1 h]        Leer 1-teoria/ (terminal y comandos, rutas, archivos, ayuda)
[30 min]     Responder las 10 preguntas de Conocimiento
[60 min]     lab-01 — Primeros comandos, errores y primer script
[60 min]     lab-02 — cd, rutas relativas y absolutas, Tab e historial
[60 min]     lab-03 — ls, cat, less y file
[60 min]     lab-04 — mkdir, touch, cp y mv
[60 min]     lab-05 — rm, rmdir y rm -r sin sustos
[60 min]     lab-06 — type, help, --help y man
[60 min]     lab-07 — find y >
[3 h 30 min] Proyecto: el esqueleto de bashkit
```

## Verificación de completitud

Desde la raíz del repositorio (en tu equipo o dentro del laboratorio):

```bash
./scripts/verificar-semana.sh 01
```

Comprueba tu proyecto (`3-proyecto/starter/`) contra los 15 requisitos verificables de la semana, dentro del laboratorio Docker.

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| — | **Semana 01 — Terminal y sistema de archivos** | — |

[← Volver al índice del bootcamp](../README.md)
