# Lab 07 — CI con GitHub Actions

⏱ Duración estimada: ~60 min

## Objetivo

Escribir el workflow de GitHub Actions de un proyecto pequeño, con un PostgreSQL de usar y tirar, y ejecutar en el laboratorio los mismos comandos que ejecutará la CI para saber antes de subirlo si saldrá en verde.

## Contexto

- `starter/` es un proyecto completo y pequeño: `bin/count-orders.sh` cuenta los pedidos de la tienda, `tests/count-orders.bats` lo prueba contra un PostgreSQL de verdad y `datos/tienda.sql` son los datos. Le falta la CI: `.github/workflows/ci.yml` tiene tres TODO.
- GitHub ejecuta el workflow en una máquina limpia en cada push. Cada paso es un comando: si sale con 0, sigue; si no, el trabajo se para y el commit sale en rojo.
- El laboratorio no puede ejecutar GitHub Actions, pero sí los mismos comandos. Lo que falla aquí falla allí. Para verlo en GitHub de verdad, el reto extra lo sube a un repositorio tuyo.

## Instrucciones

0. Con PostgreSQL en marcha (lab 01), entra al laboratorio y ve a la carpeta `starter` del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-14-proyecto_integrador/2-practicas/lab-07-ci-con-github-actions/starter
   ```
   (sin salida).

1. **El proyecto.** `find` también enseña las carpetas que empiezan por punto, que `ls` esconde:
   ```bash
   find . -type f | sort
   ```
   ```text
   ./.github/workflows/ci.yml
   ./bin/count-orders.sh
   ./datos/tienda.sql
   ./tests/count-orders.bats
   ```
   GitHub busca los workflows en `.github/workflows/` de la **raíz** del repositorio. Aquí están en la raíz de `starter`: funcionarán cuando `starter` sea su propio repositorio (reto extra).

2. **Lo que hará la CI, a mano.** El workflow va a ejecutar shellcheck y los tests. Ejecútalos tú primero:
   ```bash
   shellcheck bin/*.sh; echo $?
   bats tests; echo $?
   ```
   ```text
   0
   count-orders.bats
    ✓ cuenta los 12 pedidos de la tienda
    ✓ si PostgreSQL no responde, avisa y sale con 1

   2 tests, 0 failures

   0
   ```
   Los tests recargan la tienda antes de cada uno (`setup`): en la CI la base empieza vacía, y aquí puede que la hayas cambiado en otro lab.

3. **Un rojo.** Cambia lo que espera el primer test (`sed -i` cambia el archivo), ejecuta los tests y mira el código:
   ```bash
   sed -i 's/== 12 ]]/== 13 ]]/' tests/count-orders.bats
   bats tests; echo $?
   ```
   ```text
   count-orders.bats
    ✗ cuenta los 12 pedidos de la tienda
      (in test file tests/count-orders.bats, line 15)
        `[[ $output == 13 ]]' failed
    ✓ si PostgreSQL no responde, avisa y sale con 1

   2 tests, 1 failure

   1
   ```
   Ese 1 es lo que ve GitHub: el paso falla, el trabajo para y el commit sale con una cruz roja. Déjalo como estaba:
   ```bash
   sed -i 's/== 13 ]]/== 12 ]]/' tests/count-orders.bats
   ```
   (sin salida).

4. **TODO 1: cuándo y dónde.** Abre `.github/workflows/ci.yml` en tu editor. En YAML la estructura la marca la **sangría con espacios**: lo que va más a la derecha está dentro de lo de arriba. Nunca uses tabuladores. Debajo del primer `# TODO 1`, al principio de la línea:
   ```yaml
   on: [push, pull_request]
   ```
   `on` dice cuándo se ejecuta: en cada push y en cada pull request. Debajo del segundo `# TODO 1`, con 4 espacios, como el comentario:
   ```yaml
       runs-on: ubuntu-24.04
   ```
   La misma Ubuntu que el laboratorio: `bash`, `shellcheck` y los clientes de PostgreSQL tienen las mismas versiones mayores.

5. **TODO 2: el PostgreSQL de usar y tirar.** Un **servicio** es un contenedor que GitHub arranca antes de los pasos y borra al acabar. Es el `db` de `compose.yaml` con otra forma de escribirlo. Debajo del primer `# TODO 2`:
   ```yaml
       services:
         db:
           image: postgres:16
           env:
             POSTGRES_USER: tienda
             POSTGRES_PASSWORD: tienda
             POSTGRES_DB: tienda
           ports:
             - 5432:5432
           options: >-
             --health-cmd "pg_isready -U tienda"
             --health-interval 2s
             --health-retries 15
   ```
   `options` son opciones de `docker run`: el healthcheck. GitHub no empieza los pasos hasta que dice que está sano. `>-` junta las líneas de debajo en una sola. Debajo del segundo `# TODO 2`:
   ```yaml
       env:
         PGHOST: localhost
         PGUSER: tienda
         PGPASSWORD: tienda
         PGDATABASE: tienda
   ```
   `localhost` y no `db`: los pasos corren en la propia máquina, no en la red de un compose, y el puerto publicado (`5432:5432`) deja PostgreSQL ahí. Una contraseña escrita en el YAML vale para una base de usar y tirar; la de una base de verdad va en *Settings → Secrets* del repositorio.

6. **TODO 3: los pasos.** Debajo de `- uses: actions/checkout@v7` (que baja tu repositorio a la máquina), cambia el `# TODO 3` por:
   ```yaml
         - name: Instalar bats
           run: sudo apt-get update && sudo apt-get install -y bats
         - name: shellcheck
           run: shellcheck bin/*.sh
         - name: Tests
           run: bats tests
   ```
   La máquina de GitHub trae `shellcheck` y los clientes de PostgreSQL, pero no `bats`. Cada `run` es un trozo de bash; `name` es lo que verás en la página de GitHub.

7. **Revisar el YAML.** Un tabulador rompe el archivo. `$'\t'` es un tabulador para `grep`; que no encuentre ninguno (código 1) es lo que quieres:
   ```bash
   grep -n $'\t' .github/workflows/ci.yml; echo $?
   grep -c TODO .github/workflows/ci.yml
   ```
   ```text
   1
   0
   ```
   Compara tu archivo con `../solucion/.github/workflows/ci.yml` si dudas de una sangría: `diff .github/workflows/ci.yml ../solucion/.github/workflows/ci.yml` no debería enseñar más que los comentarios que borraste.

8. **La CI en local.** Saca los comandos de los `run` del workflow, en orden, y ejecútalos como lo haría GitHub: uno detrás de otro, parando en el primero que falle. El de `apt-get` se salta, porque el laboratorio ya tiene `bats` y no tiene `sudo`:
   ```bash
   grep -E '^ +run: ' .github/workflows/ci.yml | sed 's/^ *run: //'
   ```
   ```text
   sudo apt-get update && sudo apt-get install -y bats
   shellcheck bin/*.sh
   bats tests
   ```
   ```bash
   grep -E '^ +run: ' .github/workflows/ci.yml | sed 's/^ *run: //' | grep -v apt-get |
     while IFS= read -r cmd; do
       echo "▶ $cmd"
       bash -c "$cmd" < /dev/null || { echo "✗ rojo: $cmd"; break; }
     done
   ```
   ```text
   ▶ shellcheck bin/*.sh
   ▶ bats tests
   1..2
   ok 1 cuenta los 12 pedidos de la tienda
   ok 2 si PostgreSQL no responde, avisa y sale con 1
   ```
   `< /dev/null`: como en GitHub, los comandos no tienen teclado; y `bats` escribe en formato TAP (`ok 1 ...`) cuando su salida no es una terminal, que es como lo verás en la página de GitHub. Si repites el paso 3 antes, la salida acaba en `✗ rojo: bats tests`.

## Criterios de éxito

- `shellcheck bin/*.sh` y `bats tests` salen con 0 en el laboratorio (paso 2).
- Con un test roto, `bats tests` sale con 1 y marca el test con `✗` (paso 3).
- `.github/workflows/ci.yml` no tiene TODO ni tabuladores (paso 7).
- Los `run` del workflow, ejecutados en orden, pasan sin ningún `✗ rojo` (paso 8).

## Reto extra

Súbelo a GitHub y míralo en verde de verdad. Necesitas una cuenta de GitHub y `git` en tu equipo (fuera del laboratorio, para usar tus credenciales). En GitHub, crea un repositorio vacío (por ejemplo `tienda-ci`). En tu equipo, copia el contenido de `starter/` a una carpeta nueva fuera del repositorio del bootcamp, y desde ella:

```bash
git init -b main
git add .
git commit -m "tienda con CI"
git remote add origin https://github.com/TU-USUARIO/tienda-ci.git
git push -u origin main
```

En la pestaña *Actions* del repositorio verás el trabajo `test` con sus pasos. Después rompe un test como en el paso 3, haz commit y push, y mira cómo sale el paso `Tests` en rojo con el mismo mensaje que viste en el laboratorio.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 06 — Restaurar sin miedo](../lab-06-restaurar-sin-miedo/README.md) | [Proyecto — `bashkit backup`: copias de PostgreSQL en Docker](../../3-proyecto/README.md) → |

[↑ Semana 14](../../README.md)
