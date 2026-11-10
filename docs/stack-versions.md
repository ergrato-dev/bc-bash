# Versiones del stack

Las versiones son las del laboratorio (`lab/Dockerfile`, Ubuntu 24.04). Todo ejemplo, output y check del bootcamp se escribe y se prueba con ellas.

| Herramienta | Versión | Para qué | Semanas |
|---|---|---|---|
| bash | 5.2.21 | Todo el curso | 01–14 |
| coreutils, findutils, grep, sed | las de Ubuntu 24.04 (GNU) | Comandos y filtros | 01–14 |
| gawk | 5.2 | `awk` | 10 |
| jq | 1.7 | JSON y autograding | 10–14 |
| shellcheck | 0.9.0 | Lint de scripts | 12–14 |
| shfmt | 3.8.0 | Formato de scripts | 12–14 |
| bats-core | 1.10.0 | Tests de scripts | 12–14 |
| postgresql-client | 16 | `psql`, `pg_dump`, `pg_restore` | 14 |
| PostgreSQL (servicio `db`) | 16 | Base de datos del backup | 14 |
| Docker Compose | v2 | Laboratorio y servicios | 01–14 |

## Por qué estas

- **bash 5.2** es la de Ubuntu 24.04 LTS, la base más común en servidores hoy. Lo que necesite 5.3 se marca "bash 5.3+" y lleva alternativa.
- **GNU y no BSD**: macOS trae bash 3.2 y utilidades BSD con opciones distintas (`sed -i ''`, `date -v`). Por eso nada se ejecuta en el host: todo en el laboratorio.
- **PostgreSQL 16, cliente y servidor**: `pg_dump` no copia un servidor de una versión mayor más nueva que la suya ("aborting because of server version mismatch"). El cliente de Ubuntu 24.04 es el 16, así que el servicio `db` usa `postgres:16`, y la CI del kit también.
- **PostgreSQL**, nunca MySQL. Si alguna vez hiciera falta Python, siempre con **uv**; Node.js, siempre con **pnpm**.
