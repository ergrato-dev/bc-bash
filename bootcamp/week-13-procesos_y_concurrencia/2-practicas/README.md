# Labs — Semana 13: Procesos y concurrencia

| # | Lab | Objetivo | Tiempo |
|---|-----|----------|--------|
| 1 | [lab-01-trabajos-en-segundo-plano](lab-01-trabajos-en-segundo-plano/README.md) | Lanzar trabajos con `&`, manejarlos con `jobs`, `fg`, `bg` y `kill %N`, y recoger el código de cada uno con `wait <pid>` | ~60 min |
| 2 | [lab-02-limite-de-trabajos-y-timeout](lab-02-limite-de-trabajos-y-timeout/README.md) | No pasar de N trabajos a la vez con `jobs -rp` y `wait -n`, y cortar con `timeout` la tarea que se cuelga | ~60 min |
| 3 | [lab-03-xargs-en-paralelo](lab-03-xargs-en-paralelo/README.md) | Comprimir muchos archivos en todos los núcleos con `find -print0 \| xargs -0 -P` sin romper los nombres con espacios | ~60 min |
| 4 | [lab-04-process-substitution](lab-04-process-substitution/README.md) | Comparar la salida de dos comandos con `<( )` sin temporales, y que un `while` no pierda lo que cuenta con `< <( )` | ~60 min |
| 5 | [lab-05-coproc](lab-05-coproc/README.md) | Preguntar y leer la respuesta de un proceso ayudante con `coproc`, sin que el búfer lo deje callado | ~60 min |
| 6 | [lab-06-senales-a-los-hijos](lab-06-senales-a-los-hijos/README.md) | Ver que un `kill` no llega a los hijos, y hacer que un script pare a sus workers con `trap`, `kill` y `wait` | ~60 min |
| 7 | [lab-07-cron-y-timers-de-systemd](lab-07-cron-y-timers-de-systemd/README.md) | Programar un script con cron y con un timer de systemd, probado antes en el entorno vacío en el que lo lanzan | ~60 min |

**Total labs: 7 horas**

## Antes de cada lab

- Todo se hace dentro del laboratorio Docker, como `alumno`. Desde la raíz del repositorio en tu equipo: `docker compose run --rm lab`.
- Cada lab empieza con un **paso 0**: el `cd` a su carpeta desde `/bc-bash`, la raíz del repositorio dentro del laboratorio.
- Muchos pasos miden el tiempo con `time` o lanzan `sleep`: los segundos exactos y los pid cambian en cada ejecución. Lo que importa es si tarda 3 segundos o 5, no las décimas.
- Los labs 03 y 06 traen un script **roto a propósito**: ejecútalo tal cual antes de arreglarlo, para ver cómo falla.
- En el lab 07, el laboratorio no tiene cron ni systemd en marcha: compruebas las líneas y los archivos, y los activas en tu propia máquina si quieres.

Completa los labs en orden. Después, el [Proyecto semanal](../3-proyecto/README.md).

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — Señales a los hijos, cron y timers de systemd](../1-teoria/03-senales-cron-y-timers.md) | [Lab 01 — Trabajos en segundo plano: &, jobs y wait](lab-01-trabajos-en-segundo-plano/README.md) → |

[↑ Semana 13](../README.md)
