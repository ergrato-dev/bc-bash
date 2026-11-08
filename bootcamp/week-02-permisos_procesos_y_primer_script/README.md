# Semana 02 — Permisos, procesos y primer script

## Descripción

Aprenderás quién eres para el sistema, quién puede leer, cambiar y ejecutar cada archivo, y qué es un proceso y cómo pararlo. Con eso convertirás un archivo de texto en un comando de verdad: con shebang, permiso de ejecución y sitio en el `PATH`. El resultado es `bk-info`, el primer comando de `bashkit`.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Explicar qué son el uid, los grupos y root, y leer `/etc/passwd`
- Leer en `ls -l` quién puede leer, escribir y ejecutar un archivo o entrar en una carpeta
- Cambiar permisos con `chmod` en forma simbólica y octal, y el dueño con `chown` como root
- Ver procesos con `ps`, moverlos entre primer y segundo plano y pararlos con `Ctrl+C` y `kill`
- Hacer ejecutable un script con el shebang y `chmod +x`, y reconocer los errores 126 y 127
- Añadir carpetas al `PATH` y decidir qué variables reciben los procesos hijos con `export`
- Escribir `bin/bk-info`, que imprime la ficha del sistema leyendo comandos y variables de entorno

## Prerrequisitos

- [Semana 01](../week-01-terminal_y_sistema_de_archivos/README.md) completada: rutas, `ls -l`, crear y borrar archivos, `find`
- El laboratorio reconstruido con la versión actual del repositorio (`docker compose build`): ver [docs/setup-entorno.md](../../docs/setup-entorno.md)

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-usuarios-grupos-y-permisos.md](1-teoria/01-usuarios-grupos-y-permisos.md) · [02-procesos-y-senales.md](1-teoria/02-procesos-y-senales.md) · [03-scripts-y-shebang.md](1-teoria/03-scripts-y-shebang.md) · [04-path-y-variables-de-entorno.md](1-teoria/04-path-y-variables-de-entorno.md) | 1 h |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 30 min |
| 1 | Lab | [lab-01-usuarios-y-grupos](2-practicas/lab-01-usuarios-y-grupos/README.md) | 60 min |
| 2 | Lab | [lab-02-leer-permisos](2-practicas/lab-02-leer-permisos/README.md) | 60 min |
| 3 | Lab | [lab-03-cambiar-permisos-con-chmod](2-practicas/lab-03-cambiar-permisos-con-chmod/README.md) | 60 min |
| 4 | Lab | [lab-04-propietarios-y-root](2-practicas/lab-04-propietarios-y-root/README.md) | 60 min |
| 5 | Lab | [lab-05-procesos-y-senales](2-practicas/lab-05-procesos-y-senales/README.md) | 60 min |
| 6 | Lab | [lab-06-shebang-y-bit-de-ejecucion](2-practicas/lab-06-shebang-y-bit-de-ejecucion/README.md) | 60 min |
| 7 | Lab | [lab-07-path-y-variables-de-entorno](2-practicas/lab-07-path-y-variables-de-entorno/README.md) | 60 min |
| — | Proyecto | [bk-info: la ficha del sistema](3-proyecto/README.md) | 3 h 30 min |

**Total: 12 horas**

## Distribución del tiempo

```text
[1 h]        Leer 1-teoria/ (permisos, procesos, shebang, PATH y entorno)
[30 min]     Responder las 10 preguntas de Conocimiento
[60 min]     lab-01 — id, grupos y /etc/passwd
[60 min]     lab-02 — leer ls -l y stat
[60 min]     lab-03 — chmod simbólico y octal, umask
[60 min]     lab-04 — chown y chgrp como root, runuser
[60 min]     lab-05 — ps, &, jobs, fg, bg, Ctrl+C y kill
[60 min]     lab-06 — chmod +x, shebang, errores 126 y 127
[60 min]     lab-07 — PATH, export y variables en procesos hijos
[3 h 30 min] Proyecto: bin/bk-info
```

## Verificación de completitud

Desde la raíz del repositorio (en tu equipo o dentro del laboratorio):

```bash
./scripts/verificar-semana.sh 02
```

Comprueba tu proyecto (`3-proyecto/starter/`) contra los 15 requisitos verificables de la semana, dentro del laboratorio Docker.

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [← Semana 01 — Terminal y sistema de archivos](../week-01-terminal_y_sistema_de_archivos/README.md) | **Semana 02 — Permisos, procesos y primer script** | — |

[← Volver al índice del bootcamp](../README.md)
