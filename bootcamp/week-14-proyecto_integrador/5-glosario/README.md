# Glosario — Semana 14

| Término | Definición en una línea | Ejemplo |
|---------|-------------------------|---------|
| Servicio (compose) | Un contenedor descrito en `compose.yaml`, con nombre, imagen y configuración | `db:` con `image: postgres:16` |
| Perfil (*profile*) | Etiqueta que hace que un servicio solo arranque cuando lo pides | `docker compose --profile db up -d db` |
| Healthcheck | Comando que Docker repite para saber si un servicio está listo, no solo arrancado | `pg_isready -U bashkit` cada 2 s |
| Volumen | Almacenamiento de Docker que sobrevive al contenedor | `pgdata:/var/lib/postgresql/data` |
| `psql` | La consola de PostgreSQL; con `-c` ejecuta una consulta y sale | `psql -Atc 'select count(*) from pedidos'` |
| `pg_isready` | Pregunta si PostgreSQL acepta conexiones y lo dice con el código de salida | `until pg_isready -q; do sleep 1; done` |
| `pg_dump` | Escribe las órdenes que vuelven a crear una base: en texto o en formato custom | `pg_dump -Fc -f tienda.dump` |
| `pg_restore` | Restaura una copia custom en una base, o lista su índice con `-l` | `pg_restore -l tienda.dump` |
| Formato custom (`-Fc`) | Copia comprimida, con índice, que empieza por `PGDMP` y se restaura con `pg_restore` | `head -c 5 tienda.dump` da `PGDMP` |
| `--single-transaction` | Restaura todo o nada: al primer error, la base se queda como estaba | `pg_restore --clean --if-exists --single-transaction -d bashkit c.dump` |
| Escritura atómica | Escribir en un temporal y renombrarlo con `mv` al terminar, para que nunca exista media copia | `pg_dump -Fc -f .c.partial && mv .c.partial c.dump` |
| Rotación | Borrar las copias viejas y quedarse con las N más nuevas | `rotate.sh copias tienda 7` |
| CI (integración continua) | Ejecutar el lint y los tests en una máquina limpia en cada cambio que subes | un push que sale en rojo porque `bats tests` falla |
| Workflow | Archivo YAML de `.github/workflows/` que dice qué ejecuta GitHub Actions y cuándo | `on: [push, pull_request]` |
| Contenedor de servicio | Contenedor que GitHub Actions arranca para un trabajo y borra al acabar | `services: db: image: postgres:16` |

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Recursos — web](../4-recursos/webgrafia/README.md) | — |

[↑ Semana 14](../README.md)
