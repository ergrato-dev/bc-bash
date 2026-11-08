# Lab 04 — Valores por defecto

⏱ Duración estimada: ~60 min

## Objetivo

Dar valores por defecto, exigir variables obligatorias y añadir texto condicional con `${var:-}`, `${var:=}`, `${var:?}` y `${var:+}`.

## Contexto

- Un script configurable lee variables de entorno, y no puede suponer que estén definidas. Con `set -u`, usar una que no existe para el script ([teoría](../../1-teoria/03-expansiones-de-parametros.md)).
- `${var:-valor}` resuelve los dos problemas a la vez: vale `$var` si tiene algo, y `valor` si no existe o está vacía. Ya lo usaste en `bk-top-ips`: `${2:-10}`.
- `starter/connect-db.sh` arma la URL de conexión a PostgreSQL a partir de variables `DB_*`, como hacen las herramientas de backup que verás en la semana 14. Tiene cinco TODOs.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-05-variables_comillas_y_expansiones/2-practicas/lab-04-valores-por-defecto
   ```
   (sin salida).

1. **`:-`, el valor por defecto:**
   ```bash
   echo "${color:-azul}"
   echo "[$color]"
   color=rojo
   echo "${color:-azul}"
   ```
   ```text
   azul
   []
   rojo
   ```
   `color` no existe: la expansión vale `azul`, pero la variable sigue sin existir. Cuando tiene valor, se usa el suyo.

2. **Vacía o sin definir.** Sin los dos puntos, solo cuenta si existe:
   ```bash
   vacia=""
   echo "[${vacia:-x}] [${vacia-x}]"
   unset vacia
   echo "[${vacia:-x}] [${vacia-x}]"
   ```
   ```text
   [x] []
   [x] [x]
   ```
   `:-` usa `x` si la variable no existe **o** está vacía; `-`, solo si no existe. Casi siempre quieres `:-`: una variable vacía rara vez es un valor útil.

3. **`:=`, valor por defecto que se queda:**
   ```bash
   unset color
   echo "${color:=verde}"
   echo "$color"
   ```
   ```text
   verde
   verde
   ```
   A diferencia de `:-`, `:=` además guarda el valor en la variable.

4. **`:?`, obligatoria:**
   ```bash
   bash -c 'echo "${DB_USER:?falta DB_USER}"; echo sigue'
   echo $?
   ```
   ```text
   bash: line 1: DB_USER: falta DB_USER
   127
   ```
   Si la variable no existe o está vacía, escribe el mensaje en stderr y para la shell: `sigue` no se imprime. Va dentro de `bash -c` porque en tu shell interactiva solo cancelaría la línea. Dentro de un script, el código de salida es `1`.

5. **`:+`, texto solo si hay valor:**
   ```bash
   debug=1
   echo "[${debug:+modo debug}]"
   unset debug
   echo "[${debug:+modo debug}]"
   ```
   ```text
   [modo debug]
   []
   ```
   Es el contrario de `:-`: vale el texto si la variable **tiene** algo, y vacío si no. Sirve para añadir una opción o un aviso solo cuando toca.

6. **Una variable solo para un comando.** `VAR=valor comando` la exporta solo a ese comando (lab 01, paso 2). El laboratorio ya trae las variables `PG*`, que usarás con PostgreSQL en la semana 14; por eso este lab usa `DB_*`:
   ```bash
   env | grep '^PG' | sort
   DB_HOST=db bash -c 'echo "$DB_HOST"'
   echo "[${DB_HOST:-}]"
   ```
   ```text
   PGDATABASE=bashkit
   PGHOST=db
   PGPASSWORD=bashkit
   PGUSER=bashkit
   db
   []
   ```
   `env` lista las variables de entorno. `DB_HOST` existió solo para ese `bash -c`. `${DB_HOST:-}`, con el valor por defecto vacío, es la forma de leer una variable que puede no existir sin que `set -u` se queje.

7. **El script, sin tocar:**
   ```bash
   bash starter/connect-db.sh
   echo $?
   ```
   ```text
   starter/connect-db.sh: line 6: DB_HOST: unbound variable
   1
   ```
   **TODO 1:** abre `starter/connect-db.sh` en tu editor y cambia `"$DB_HOST"` por `"${DB_HOST:-localhost}"`. Borra el comentario del `TODO 1`. Prueba sin la variable y con ella:
   ```bash
   bash starter/connect-db.sh
   DB_HOST=db bash starter/connect-db.sh
   ```
   ```text
   postgresql://postgres@localhost:5432/postgres
   postgresql://postgres@db:5432/postgres
   ```

8. **TODO 2.** `port=5432` ignora `DB_PORT`. Cámbialo para que use `DB_PORT` o `5432`, como en el TODO 1. Borra el comentario del `TODO 2`. Prueba:
   ```bash
   DB_PORT=6543 bash starter/connect-db.sh
   ```
   ```text
   postgresql://postgres@localhost:6543/postgres
   ```

9. **TODO 3.** Para el usuario no hay un valor razonable que inventar: si falta, el script tiene que parar y decirlo. Cambia `user=postgres` por `user="${DB_USER:?dime con qué usuario conectar}"`. Borra el comentario del `TODO 3`. Prueba sin la variable y con ella:
   ```bash
   bash starter/connect-db.sh
   echo $?
   DB_USER=ana bash starter/connect-db.sh
   ```
   ```text
   starter/connect-db.sh: line 10: DB_USER: dime con qué usuario conectar
   1
   postgresql://ana@localhost:5432/postgres
   ```

10. **TODO 4.** En PostgreSQL, la base de datos se llama como el usuario si no dices otra. El valor por defecto puede ser otra variable: cambia `name=postgres` para que use `DB_NAME` o, si no está, `$user`. Borra el comentario del `TODO 4`. Prueba:
    ```bash
    DB_USER=ana bash starter/connect-db.sh
    DB_USER=ana DB_NAME=tienda bash starter/connect-db.sh
    ```
    ```text
    postgresql://ana@localhost:5432/ana
    postgresql://ana@localhost:5432/tienda
    ```

11. **TODO 5.** La contraseña nunca se imprime, pero sí conviene saber si hay una. Añade al final de la URL del `echo`, dentro de las mismas comillas, `${DB_PASSWORD:+ (con contraseña)}` (con el espacio delante del paréntesis). Borra el comentario del `TODO 5`. Prueba:
    ```bash
    DB_USER=ana bash starter/connect-db.sh
    DB_USER=ana DB_PASSWORD=secreto bash starter/connect-db.sh
    DB_USER=ana DB_PASSWORD= bash starter/connect-db.sh
    ```
    ```text
    postgresql://ana@localhost:5432/ana
    postgresql://ana@localhost:5432/ana (con contraseña)
    postgresql://ana@localhost:5432/ana
    ```
    `DB_PASSWORD=` la define vacía: para `:+` es lo mismo que no tenerla.

## Criterios de éxito

- [ ] Explicas la diferencia entre `${vacia:-x}` y `${vacia-x}` (paso 2)
- [ ] Explicas cuándo usar `:-` y cuándo `:?` para una variable de configuración (pasos 7 y 9)
- [ ] `bash starter/connect-db.sh` sin `DB_USER` para con `dime con qué usuario conectar` y código `1`
- [ ] Con `DB_USER=ana DB_PASSWORD=secreto` imprime `postgresql://ana@localhost:5432/ana (con contraseña)`

## Reto extra

Prueba `DB_USER= bash starter/connect-db.sh`. ¿Por qué para igual que sin la variable? ¿Qué cambiaría si el TODO 3 usara `${DB_USER?...}`, sin los dos puntos (paso 2)?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 03 — Word splitting y globbing](../lab-03-word-splitting-y-globbing/README.md) | [Lab 05 — Recortar y sustituir](../lab-05-recortar-y-sustituir/README.md) → |

[↑ Semana 05](../../README.md)
