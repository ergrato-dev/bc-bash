# Labs — Semana 11: Scripts robustos

| # | Lab | Objetivo | Tiempo |
|---|-----|----------|--------|
| 1 | [lab-01-limites-de-set-e](lab-01-limites-de-set-e/README.md) | Encontrar dónde `set -e` no para un script que falla, y arreglarlo | ~60 min |
| 2 | [lab-02-trap-exit-y-mktemp](lab-02-trap-exit-y-mktemp/README.md) | Trabajar en una carpeta temporal propia con `mktemp -d` y borrarla siempre con `trap ... EXIT` | ~60 min |
| 3 | [lab-03-senales-int-y-term](lab-03-senales-int-y-term/README.md) | Atrapar `INT` y `TERM` para avisar, limpiar y salir con el código de cada señal | ~60 min |
| 4 | [lab-04-opciones-con-getopts](lab-04-opciones-con-getopts/README.md) | Leer opciones con y sin valor con `getopts` y avisar de las que no existen | ~60 min |
| 5 | [lab-05-bloqueo-con-flock](lab-05-bloqueo-con-flock/README.md) | Impedir que un script corra dos veces a la vez con `flock` | ~60 min |
| 6 | [lab-06-logging-por-niveles](lab-06-logging-por-niveles/README.md) | Escribir avisos con nivel, hora y copia en un archivo, según `LOG_LEVEL` | ~60 min |
| 7 | [lab-07-script-idempotente](lab-07-script-idempotente/README.md) | Arreglar un script de instalación para poder repetirlo sin errores ni duplicados | ~60 min |

**Total labs: 7 horas**

## Antes de cada lab

- Todo se hace dentro del laboratorio Docker, como `alumno`. Desde la raíz del repositorio en tu equipo: `docker compose run --rm lab`.
- Cada lab empieza con un **paso 0**: el `cd` a su carpeta desde `/bc-bash`, la raíz del repositorio dentro del laboratorio.
- Muchas pruebas van dentro de `bash -c '...'`: un bash nuevo para cada una, con su propio `set -e`, sus `trap` y sus procesos de fondo. Así una prueba no deja nada puesto en tu terminal.
- Los labs 03 y 05 lanzan procesos de fondo y les mandan señales. Si algo se queda colgado, `Ctrl-C` lo para; si sigue, `exit` y vuelve a entrar al laboratorio.
- Los labs 01 y 07 traen un script **roto a propósito**: ejecútalo tal cual antes de arreglarlo, para ver cómo falla.

Completa los labs en orden. Después, el [Proyecto semanal](../3-proyecto/README.md).

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — flock, logging e idempotencia: scripts que conviven](../1-teoria/03-flock-logging-e-idempotencia.md) | [Lab 01 — Los límites de set -e](lab-01-limites-de-set-e/README.md) → |

[↑ Semana 11](../README.md)
