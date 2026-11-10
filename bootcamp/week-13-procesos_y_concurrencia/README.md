# Semana 13 — Procesos y concurrencia

## Descripción

Hasta ahora cada comando de tus scripts esperaba al anterior. Esta semana aprendes a lanzar varios a la vez sin perder el código de ninguno, a ponerles un límite y un tiempo máximo, a conectar procesos con `<( )` y `coproc`, a parar a los hijos cuando el script muere y a programar un script para que se ejecute solo con cron o con un timer de systemd. `bashkit` gana `healthcheck`: comprobaciones de la máquina en paralelo.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Lanzar trabajos en segundo plano con `&` y manejarlos con `jobs`, `fg`, `bg` y `kill %N`
- Recoger el código de cada trabajo con `wait <pid>` para que ningún fallo pase sin aviso
- Limitar cuántos trabajos van a la vez con `jobs -rp` y `wait -n`, y cortar los colgados con `timeout`
- Repartir trabajo entre los núcleos con `find -print0 | xargs -0 -P`
- Pasar la salida de un comando como archivo con `<( )` y leerla en un `while` con `< <( )`
- Mantener una conversación con un proceso ayudante con `coproc` sin bloquearse por el búfer
- Parar a los hijos de un script con `trap`, `kill` y `wait` para que no queden huérfanos
- Programar un script con cron y con un timer de systemd, probado en un entorno vacío y sin solaparse con `flock`

## Prerrequisitos

- [Semana 12](../week-12-calidad_testing_y_depuracion/README.md) completada: `bashkit` con tests de bats y `bk-lint`
- `trap`, `mktemp` y `flock` de la [semana 11](../week-11-scripts_robustos/README.md), y `ps`, `kill` y jobs de la [semana 02](../week-02-permisos_procesos_y_primer_script/README.md)
- El laboratorio funcionando: ver [docs/setup-entorno.md](../../docs/setup-entorno.md)

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-trabajos-y-wait.md](1-teoria/01-trabajos-y-wait.md) · [02-process-substitution-y-coproc.md](1-teoria/02-process-substitution-y-coproc.md) · [03-senales-cron-y-timers.md](1-teoria/03-senales-cron-y-timers.md) | 1 h |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 30 min |
| 1 | Lab | [lab-01-trabajos-en-segundo-plano](2-practicas/lab-01-trabajos-en-segundo-plano/README.md) | 60 min |
| 2 | Lab | [lab-02-limite-de-trabajos-y-timeout](2-practicas/lab-02-limite-de-trabajos-y-timeout/README.md) | 60 min |
| 3 | Lab | [lab-03-xargs-en-paralelo](2-practicas/lab-03-xargs-en-paralelo/README.md) | 60 min |
| 4 | Lab | [lab-04-process-substitution](2-practicas/lab-04-process-substitution/README.md) | 60 min |
| 5 | Lab | [lab-05-coproc](2-practicas/lab-05-coproc/README.md) | 60 min |
| 6 | Lab | [lab-06-senales-a-los-hijos](2-practicas/lab-06-senales-a-los-hijos/README.md) | 60 min |
| 7 | Lab | [lab-07-cron-y-timers-de-systemd](2-practicas/lab-07-cron-y-timers-de-systemd/README.md) | 60 min |
| — | Proyecto | [bashkit healthcheck: comprobaciones en paralelo](3-proyecto/README.md) | 3 h 30 min |

**Total: 12 horas**

## Distribución del tiempo

```text
[1 h]        Leer 1-teoria/ (&, wait, xargs -P, <( ), coproc, señales, cron, timers)
[30 min]     Responder las 10 preguntas de Conocimiento
[60 min]     lab-01 — trabajos en segundo plano
[60 min]     lab-02 — límite de trabajos y timeout
[60 min]     lab-03 — xargs en paralelo
[60 min]     lab-04 — process substitution
[60 min]     lab-05 — coproc
[60 min]     lab-06 — señales a los hijos
[60 min]     lab-07 — cron y timers de systemd
[3 h 30 min] Proyecto: bin/bk-healthcheck, sus tests y la línea de cron
```

## Verificación de completitud

Desde la raíz del repositorio (en tu equipo o dentro del laboratorio):

```bash
./scripts/verificar-semana.sh 13
```

Comprueba tu proyecto (`3-proyecto/starter/`) contra los 15 requisitos verificables de la semana, dentro del laboratorio Docker.

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [← Semana 12 — Calidad, testing y depuración](../week-12-calidad_testing_y_depuracion/README.md) | **Semana 13 — Procesos y concurrencia** | — |

[← Volver al índice del bootcamp](../README.md)
