# CI con GitHub Actions: los tests en cada push

Tienes tests (semana 12) y un lint. Solo sirven si se ejecutan, y la memoria falla: la **integración continua** (CI) los ejecuta en una máquina limpia cada vez que subes un cambio, y marca el commit en verde o en rojo.

## Un workflow

GitHub Actions lee los archivos `.github/workflows/*.yml` de tu repositorio. Uno mínimo:

```yaml
name: ci                         # el nombre que ves en la pestaña Actions
on: [push, pull_request]         # cuándo se ejecuta
jobs:
  test:                          # un trabajo; varios irían en paralelo
    runs-on: ubuntu-24.04        # una máquina nueva, la misma Ubuntu que el laboratorio
    steps:
      - uses: actions/checkout@v7          # baja tu repositorio a la máquina
      - run: sudo apt-get install -y bats  # cada run es un trozo de bash
      - run: bats tests
```

YAML marca la estructura con **sangría de espacios** (nunca tabuladores): `steps` va dentro de `test` porque está más a la derecha. Un `-` empieza un elemento de una lista.

La regla que lo mueve todo es la de siempre: **cada `run` termina con un código de salida**. Si es 0, sigue el paso siguiente; si no, el trabajo se para y el commit sale en rojo. Por eso los códigos de salida que cuidaste desde la semana 03 importan aquí: un script que falla y sale con 0 deja la CI en verde con un fallo dentro.

Un `run` de varias líneas va con `|`. Cada `run` es un `bash -e` aparte: para que un pipe también pare el paso, empieza con `set -euo pipefail`.

```yaml
      - name: Copia y restauración
        run: |
          set -euo pipefail
          file="$(bin/bk-backup -d "$RUNNER_TEMP/backups")"
          bin/bk-restore -y "$file"
```

`RUNNER_TEMP` es una carpeta temporal que GitHub borra al acabar.

## Un PostgreSQL de usar y tirar

Un trabajo puede pedir **servicios**: contenedores que arrancan antes de los pasos y se borran después. Es el mismo `db` de tu `compose.yaml`, con otra sintaxis:

```yaml
    services:
      db:
        image: postgres:16
        env:
          POSTGRES_PASSWORD: bashkit
        ports:
          - 5432:5432
        options: >-
          --health-cmd "pg_isready -U postgres"
          --health-interval 2s
          --health-retries 15
    env:
      PGHOST: localhost
```

GitHub espera a que el healthcheck diga que está sano antes del primer paso. Los pasos corren en la máquina, no en un contenedor: el puerto publicado hace que PostgreSQL esté en `localhost`. La máquina de GitHub ya trae `psql`, `pg_dump` y `pg_restore` 16, la misma versión mayor que `postgres:16`.

## Lo que la CI no hace por ti

- **No ve tu laboratorio.** Instala lo que necesites en un paso (`bats`, `shfmt`) y no supongas nada de tu máquina: ni archivos que no estén en git, ni variables de tu `.bashrc`.
- **No guarda secretos en el YAML.** La contraseña del servicio de usar y tirar puede ir escrita; la de una base de verdad va en *Settings → Secrets* y se lee con `${{ secrets.NOMBRE }}`.
- **Solo lee `.github/` en la raíz del repositorio.** El workflow de `bashkit` funciona cuando el kit es su propio repositorio.

Antes de subirlo, ejecuta los mismos `run` en el laboratorio: es una máquina limpia muy parecida, y un fallo ahí es un fallo en GitHub.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — Copias y restauración: pg_dump, pg_restore y una copia que no miente](02-copias-y-restauracion.md) | [Índice de labs](../2-practicas/README.md) → |

[↑ Semana 14](../README.md)
