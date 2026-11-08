# Lab 05 — source y librerías

⏱ Duración estimada: ~60 min

## Objetivo

Guardar funciones en una librería, cargarla con `source` desde un script y buscarla junto al script para que funcione desde cualquier carpeta.

## Contexto

- Una **librería** es un archivo que solo define funciones. No se ejecuta: se carga con `source archivo`, que lee el archivo dentro de la shell actual, como si sus líneas estuvieran escritas ahí.
- Una ruta relativa en `source` se busca desde la carpeta en la que estás, no desde la del script. La ruta del script está en `${BASH_SOURCE[0]}`.
- `starter/lib/strings.sh` tiene `to_lower` y `to_slug`; `starter/make-slug.sh` la usa para convertir títulos en nombres de archivo.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-08-funciones_alcance_y_librerias/2-practicas/lab-05-source-y-librerias
   ```
   (sin salida).

1. **Ejecutar una librería no deja nada.** Abre `starter/lib/strings.sh` en tu editor: no tiene shebang, solo funciones.
   ```bash
   bash starter/lib/strings.sh; echo $?
   to_slug "Informe Anual"; echo $?
   ```
   ```text
   0
   bash: to_slug: command not found
   127
   ```
   `bash archivo` lo ejecuta en **otra** bash, que define las funciones y termina. Tu shell no se entera.

2. **`source` las carga en tu shell.** `type -t` dice qué es un nombre en una palabra:
   ```bash
   source starter/lib/strings.sh
   type -t to_slug
   to_slug "Informe Anual"
   ```
   ```text
   function
   sin implementar: to_lower

   ```
   Ahora `to_slug` existe en tu shell. Imprime una línea vacía porque llama a `to_lower`, que es un borrador.

3. **TODO 1: `to_lower`.** En `starter/lib/strings.sh`, borra el comentario del `TODO 1` y el `echo "sin implementar..."`, y escribe:
   ```bash
     echo "${1,,}"
   ```
   `${var,,}` es la variable en minúsculas (`${var^^}`, en mayúsculas). Las funciones que ya cargaste son las de antes: un archivo cambiado se vuelve a cargar con otro `source`. Prueba:
   ```bash
   source starter/lib/strings.sh
   to_slug "Informe Anual 2024"
   ```
   ```text
   informe-anual-2024
   ```

4. **La ruta relativa falla.** Abre `starter/make-slug.sh` en tu editor y ejecútalo desde la carpeta del lab y desde `starter/`. Los paréntesis hacen el `cd` en un subshell, sin cambiar tu carpeta:
   ```bash
   bash starter/make-slug.sh "Informe Anual"; echo $?
   (cd starter && bash make-slug.sh "Informe Anual")
   ```
   ```text
   starter/make-slug.sh: line 7: lib/strings.sh: No such file or directory
   1
   informe-anual
   ```
   `source lib/strings.sh` busca `lib/` en la carpeta en la que estás. Desde la del lab no existe; desde `starter/`, sí.

5. **TODO 2: la librería, junto al script.** Cambia el comentario del `TODO 2` y la línea `source lib/strings.sh` por:
   ```bash
   # shellcheck source=SCRIPTDIR/lib/strings.sh
   source "$(dirname "${BASH_SOURCE[0]}")/lib/strings.sh"
   ```
   `${BASH_SOURCE[0]}` es la ruta con la que se llamó al script (`starter/make-slug.sh`), y `dirname` le quita el nombre (`starter`). El comentario de encima es para shellcheck (paso 6). Prueba desde dos sitios:
   ```bash
   bash starter/make-slug.sh "Informe Anual" "Acta de Reunión"
   (cd /tmp && bash "$OLDPWD/starter/make-slug.sh" "Hola Mundo")
   ```
   ```text
   informe-anual
   acta-de-reunión
   hola-mundo
   ```
   `$OLDPWD` es la carpeta en la que estabas antes del último `cd`.

6. **shellcheck y `source`.**
   ```bash
   shellcheck starter/make-slug.sh; echo $?
   ```
   ```text

   In starter/make-slug.sh line 7:
   source "$(dirname "${BASH_SOURCE[0]}")/lib/strings.sh"
          ^-- SC1091 (info): Not following: SCRIPTDIR/lib/strings.sh was not specified as input (see shellcheck -x).

   For more information:
     https://www.shellcheck.net/wiki/SC1091 -- Not following: SCRIPTDIR/lib/stri...
   1
   ```
   shellcheck no abre otros archivos si no se lo pides, y sin leer la librería no sabe si `to_slug` existe. `-x` le deja seguir el `source`; `SCRIPTDIR` en el comentario significa "la carpeta del script":
   ```bash
   shellcheck -x starter/make-slug.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas por qué `to_slug` no existía después de `bash starter/lib/strings.sh` y sí después de `source`
- [ ] Explicas por qué `source lib/strings.sh` funcionaba desde `starter/` y no desde la carpeta del lab
- [ ] `bash starter/make-slug.sh "Acta de Reunión"` imprime `acta-de-reunión` desde cualquier carpeta
- [ ] `shellcheck -x starter/make-slug.sh` no imprime nada

## Reto extra

Añade a la librería una función `strip_accents` que cambie `á` por `a`, `é` por `e`, y así con las cinco vocales (`${var//á/a}`), y úsala en `to_slug`. ¿Hace falta cambiar `make-slug.sh`?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 04 — declare -n](../lab-04-declare-n/README.md) | [Lab 06 — Dispatcher de subcomandos](../lab-06-dispatcher/README.md) → |

[↑ Semana 08](../../README.md)
