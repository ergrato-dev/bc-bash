# Labs — Semana 14: Proyecto integrador

| # | Lab | Objetivo | Tiempo |
|---|-----|----------|--------|
| 1 | [lab-01-postgresql-en-docker](lab-01-postgresql-en-docker/README.md) | Arrancar el PostgreSQL del laboratorio con su healthcheck, conectarte con `psql`, cargar la tienda y sacar un resumen desde bash | ~60 min |
| 2 | [lab-02-esperar-a-que-responda](lab-02-esperar-a-que-responda/README.md) | Esperar a que PostgreSQL acepte conexiones con `pg_isready`, con un límite de tiempo | ~60 min |
| 3 | [lab-03-pg-dump-y-pg-restore](lab-03-pg-dump-y-pg-restore/README.md) | Copiar la base en texto y en formato custom, restaurarla en una base nueva y comprobar que tiene las mismas filas | ~60 min |
| 4 | [lab-04-un-backup-que-miente](lab-04-un-backup-que-miente/README.md) | Arreglar un script de copias que dice "copia hecha" cuando falla y pisa la copia buena | ~60 min |
| 5 | [lab-05-rotacion-de-copias](lab-05-rotacion-de-copias/README.md) | Guardar solo las N copias más nuevas, elegidas por la fecha del nombre, con un modo que solo enseña qué borraría | ~60 min |
| 6 | [lab-06-restaurar-sin-miedo](lab-06-restaurar-sin-miedo/README.md) | Restaurar con `--clean` y `--single-transaction`, y un script que comprueba la copia y pregunta antes | ~60 min |
| 7 | [lab-07-ci-con-github-actions](lab-07-ci-con-github-actions/README.md) | Escribir el workflow de GitHub Actions de un proyecto con PostgreSQL y ejecutar sus pasos en el laboratorio | ~60 min |

**Total labs: 7 horas**

## Antes de cada lab

- Esta semana usas **dos terminales**: una en tu equipo, en la raíz del repositorio, para arrancar y parar PostgreSQL con `docker compose`, y otra dentro del laboratorio (`docker compose run --rm lab`) para todo lo demás. Cada paso dice en cuál va.
- PostgreSQL se arranca una vez, en tu equipo: `docker compose --profile db up -d --wait db`. Sigue en marcha entre labs hasta que lo pares con `docker compose stop db`.
- Los labs 03, 04 y 06 empiezan recargando la tienda (`datos/tienda.sql` del lab 01): si un lab deja los datos raros, el siguiente empieza limpio.
- El lab 04 trae un script **roto a propósito**: ejecútalo tal cual antes de arreglarlo, para ver cómo falla.
- Las fechas, los tamaños de las copias y los números de `pg_restore -l` cambian en cada ejecución; lo que importa es el código de salida y cuántas filas hay.

Completa los labs en orden. Después, el [Proyecto semanal](../3-proyecto/README.md).

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — CI con GitHub Actions: los tests en cada push](../1-teoria/03-ci-con-github-actions.md) | [Lab 01 — PostgreSQL en Docker: arrancar, conectar y consultar](lab-01-postgresql-en-docker/README.md) → |

[↑ Semana 14](../README.md)
