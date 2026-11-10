# Semana 14 — Proyecto integrador: backups de PostgreSQL en Docker

## Descripción

La última semana junta todo lo anterior en lo que hace una herramienta de operaciones de verdad: copiar una base de datos cada noche y poder devolverla cuando algo sale mal. Aprendes a arrancar PostgreSQL en Docker y esperar a que responda, a copiar con `pg_dump` y restaurar con `pg_restore` sin dejar nada a medias, a guardar solo las últimas copias y a pasar los tests y una restauración de verdad en GitHub Actions. `bashkit` gana `backup` y `restore`, su `compose.yaml` y su CI.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Arrancar PostgreSQL con `docker compose`, comprobar su healthcheck y conectarte con `psql` y las variables `PG*`
- Esperar a que una base acepte conexiones con `pg_isready`, con un límite de tiempo
- Copiar una base con `pg_dump` en texto y en formato custom, y restaurarla en una base nueva con `pg_restore` o `psql`
- Escribir una copia que nunca miente ni deja nada a medias, con `pipefail`, un temporal, `mv` y `trap`
- Guardar solo las N copias más nuevas, eligiéndolas por la fecha del nombre
- Restaurar con `--clean` y `--single-transaction`, comprobando la copia y preguntando antes
- Escribir un workflow de GitHub Actions con un PostgreSQL de usar y tirar, y ejecutar sus pasos antes en el laboratorio

## Prerrequisitos

- [Semana 13](../week-13-procesos_y_concurrencia/README.md) completada: `bashkit` con `bk-healthcheck`, tests de bats y la línea de cron
- `trap`, `flock` y `getopts` de la [semana 11](../week-11-scripts_robustos/README.md), y bats y `bk-lint` de la [semana 12](../week-12-calidad_testing_y_depuracion/README.md)
- Docker funcionando en tu equipo y el laboratorio construido: ver [docs/setup-entorno.md](../../docs/setup-entorno.md). Esta semana usas también el servicio `db` de `compose.yaml`

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-postgresql-en-docker.md](1-teoria/01-postgresql-en-docker.md) · [02-copias-y-restauracion.md](1-teoria/02-copias-y-restauracion.md) · [03-ci-con-github-actions.md](1-teoria/03-ci-con-github-actions.md) | 1 h |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 30 min |
| 1 | Lab | [lab-01-postgresql-en-docker](2-practicas/lab-01-postgresql-en-docker/README.md) | 60 min |
| 2 | Lab | [lab-02-esperar-a-que-responda](2-practicas/lab-02-esperar-a-que-responda/README.md) | 60 min |
| 3 | Lab | [lab-03-pg-dump-y-pg-restore](2-practicas/lab-03-pg-dump-y-pg-restore/README.md) | 60 min |
| 4 | Lab | [lab-04-un-backup-que-miente](2-practicas/lab-04-un-backup-que-miente/README.md) | 60 min |
| 5 | Lab | [lab-05-rotacion-de-copias](2-practicas/lab-05-rotacion-de-copias/README.md) | 60 min |
| 6 | Lab | [lab-06-restaurar-sin-miedo](2-practicas/lab-06-restaurar-sin-miedo/README.md) | 60 min |
| 7 | Lab | [lab-07-ci-con-github-actions](2-practicas/lab-07-ci-con-github-actions/README.md) | 60 min |
| — | Proyecto | [bashkit backup: copias de PostgreSQL en Docker](3-proyecto/README.md) | 3 h 30 min |

**Total: 12 horas**

## Distribución del tiempo

```text
[1 h]        Leer 1-teoria/ (compose y healthcheck, psql, pg_dump, pg_restore, copia atómica, rotación, CI)
[30 min]     Responder las 10 preguntas de Conocimiento
[60 min]     lab-01 — PostgreSQL en Docker
[60 min]     lab-02 — esperar a que responda
[60 min]     lab-03 — pg_dump y pg_restore
[60 min]     lab-04 — un backup que miente
[60 min]     lab-05 — rotación de copias
[60 min]     lab-06 — restaurar sin miedo
[60 min]     lab-07 — CI con GitHub Actions
[3 h 30 min] Proyecto: bin/bk-backup, bin/bk-restore, compose.yaml, la CI y sus tests
```

## Verificación de completitud

Desde la raíz del repositorio (en tu equipo o dentro del laboratorio):

```bash
./scripts/verificar-semana.sh 14
```

Comprueba tu proyecto (`3-proyecto/starter/`) contra los 15 requisitos verificables de la semana, dentro del laboratorio Docker. No necesita PostgreSQL en marcha: usa sus propios dobles de `pg_dump`, `pg_isready` y `pg_restore`.

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [← Semana 13 — Procesos y concurrencia](../week-13-procesos_y_concurrencia/README.md) | **Semana 14 — Proyecto integrador** | — |

[← Volver al índice del bootcamp](../README.md)
