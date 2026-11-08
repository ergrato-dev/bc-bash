# Lab 01 — Variables

⏱ Duración estimada: ~60 min

## Objetivo

Guardar valores en variables, usarlos con `$` y `${ }`, y distinguir una variable de la shell de una exportada a los programas que lanza.

## Contexto

- Una **variable** es un nombre que guarda un texto: `app=tienda` la crea y `$app` la usa ([teoría](../../1-teoria/01-variables-y-comillas.md)). En bash todo es texto, también `1.4.2` o `5432`.
- La sintaxis es estricta: sin espacios alrededor del `=`. Un espacio de más no da un error de "variable mal escrita": bash lo lee como otro comando.
- `starter/deploy-vars.sh` guarda los datos de un despliegue en variables. Tiene dos fallos típicos y tres TODOs.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-05-variables_comillas_y_expansiones/2-practicas/lab-01-variables
   ```
   (sin salida).

1. **Crear y usar una variable:**
   ```bash
   nombre=Ana
   echo $nombre
   echo "Hola, $nombre"
   ```
   ```text
   Ana
   Hola, Ana
   ```
   `nombre=Ana` no imprime nada: guarda `Ana` con el nombre `nombre`. `$nombre` es "el valor de `nombre`": bash lo sustituye antes de ejecutar `echo`, que recibe `Ana`.

2. **Lo que no es una asignación:**
   ```bash
   nombre = Ana
   saludo=Hola Ana
   echo "[$saludo]"
   1dia=lunes
   mi-nombre=Ana
   ```
   ```text
   bash: nombre: command not found
   bash: Ana: command not found
   []
   bash: 1dia=lunes: command not found
   bash: mi-nombre=Ana: command not found
   ```
   - Con espacios, bash ve tres palabras: el comando `nombre` con los argumentos `=` y `Ana`.
   - `saludo=Hola Ana` es "ejecuta `Ana` con `saludo=Hola` solo para él". `Ana` no existe, y `saludo` sigue vacía: los corchetes del `echo` lo enseñan.
   - Un nombre de variable lleva letras, cifras y `_`, y no empieza por cifra: `1dia` y `mi-nombre` no lo son, así que bash los toma por comandos.

3. **Un valor con espacios, entre comillas:**
   ```bash
   saludo="Hola Ana"
   echo "$saludo"
   ```
   ```text
   Hola Ana
   ```
   Las comillas hacen que `Hola Ana` sea una sola palabra (lab 02).

4. **Dónde acaba el nombre.** ¿Cómo escribes `peras` a partir de `fruta=pera`?
   ```bash
   fruta=pera
   echo "[$frutas]"
   echo "${fruta}s"
   ```
   ```text
   []
   peras
   ```
   `$frutas` es la variable `frutas`, que no existe. `${fruta}` marca con llaves dónde acaba el nombre: lo que va detrás ya es texto.

5. **Una variable que no existe:**
   ```bash
   echo "[$nada]"
   bash -u -c 'echo "[$nada]"'
   echo $?
   ```
   ```text
   []
   bash: line 1: nada: unbound variable
   127
   ```
   Por defecto, una variable que no existe vale vacío, sin aviso: un nombre mal escrito pasa sin que te enteres. `bash -c '...'` ejecuta ese texto en una bash nueva, y `-u` la arranca como `set -u` (semana 03): la variable sin definir es un error que para el comando.

6. **Cambiar y borrar:**
   ```bash
   fruta=manzana
   echo "$fruta"
   unset fruta
   echo "[$fruta]"
   ```
   ```text
   manzana
   []
   ```
   Asignar otra vez sustituye el valor. `unset` borra la variable.

7. **De la shell o exportada.** `printenv nombre` es un programa aparte que imprime la variable de entorno `nombre`, si la recibe:
   ```bash
   color=azul
   printenv color
   echo $?
   export color
   printenv color
   ```
   ```text
   1
   azul
   ```
   Sin `export`, `color` solo existe en tu shell y `printenv` no la ve (sale con `1`). Con `export`, pasa a las variables de entorno que recibe cada programa que lances (semana 02). La convención: mayúsculas para las de entorno (`PATH`, `HOME`), minúsculas para las de tus scripts.

8. **El script, sin tocar:**
   ```bash
   bash starter/deploy-vars.sh
   echo $?
   ```
   ```text
   starter/deploy-vars.sh: line 8: entorno: command not found
   127
   ```
   El fallo del paso 2. `set -e` para el script ahí con `127`, "comando no encontrado". **TODO 1:** abre `starter/deploy-vars.sh` en tu editor, quita los espacios de la línea `entorno = produccion` y borra el comentario del `TODO 1`. Prueba:
   ```bash
   bash starter/deploy-vars.sh
   echo $?
   ```
   ```text
   app: tienda 1.4.2
   entorno: produccion
   starter/deploy-vars.sh: line 13: app_: unbound variable
   1
   ```

9. **TODO 2.** El fallo del paso 4: `$app_` es la variable `app_`, y con `set -u` el script para. Pon llaves al nombre de la variable `app` en esa línea y borra el comentario del `TODO 2`. Prueba:
   ```bash
   bash starter/deploy-vars.sh
   echo $?
   ```
   ```text
   app: tienda 1.4.2
   entorno: produccion
   log: tienda_produccion.log
   printenv no ve app
   0
   ```

10. **TODO 3.** Añade `export` delante de `app=tienda` (en la misma línea: `export app=tienda` crea y exporta a la vez). Borra el comentario del `TODO 3`. Prueba:
    ```bash
    bash starter/deploy-vars.sh | tail -1
    ```
    ```text
    tienda
    ```

## Criterios de éxito

- [ ] Explicas qué hace bash con `nombre = Ana` y con `saludo=Hola Ana` (paso 2)
- [ ] Explicas cuándo hacen falta las llaves de `${fruta}` (paso 4)
- [ ] Explicas por qué `printenv` no veía `color` hasta el `export` (paso 7)
- [ ] `bash starter/deploy-vars.sh` imprime `log: tienda_produccion.log` y `tienda` en la última línea, y sale con `0`

## Reto extra

Ejecuta `app=otra bash starter/deploy-vars.sh | tail -1`. ¿Por qué no imprime `otra`? Pista: mira qué hace la primera línea del script con `app`, y compáralo con el `saludo=Hola Ana` del paso 2.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Índice de labs](../README.md) | [Lab 02 — Comillas](../lab-02-comillas/README.md) → |

[↑ Semana 05](../../README.md)
