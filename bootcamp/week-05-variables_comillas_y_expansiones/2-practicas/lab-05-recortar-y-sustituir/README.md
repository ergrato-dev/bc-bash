# Lab 05 — Recortar y sustituir

⏱ Duración estimada: ~60 min

## Objetivo

Medir, recortar, sustituir y cambiar a mayúsculas el valor de una variable con expansiones de parámetros, sin lanzar ningún programa.

## Contexto

- `${var#patrón}` y `${var%patrón}` quitan del principio o del final lo que encaje con un patrón glob (`*`, `?`, `[ ]`, lab 03). `${var/patrón/texto}` sustituye ([teoría](../../1-teoria/03-expansiones-de-parametros.md)).
- Lo hace bash solo, sin `cut`, `sed` ni `basename`: es más rápido y no depende de que el programa exista.
- `starter/path-parts.sh` recibe una ruta y la separa en carpeta, nombre y extensión. El nombre sale mal a propósito, y faltan cuatro TODOs.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-05-variables_comillas_y_expansiones/2-practicas/lab-05-recortar-y-sustituir
   ```
   (sin salida).

1. **La longitud:**
   ```bash
   ruta=/var/log/nginx/access.log.2.gz
   echo "${#ruta}"
   ```
   ```text
   30
   ```
   `${#var}` es el número de caracteres del valor.

2. **Un trozo por posición.** `${var:inicio:largo}` cuenta desde `0`:
   ```bash
   fecha=2026-11-08
   echo "${fecha:0:4}"
   echo "${fecha:5:2}"
   echo "${fecha: -2}"
   echo "${fecha:-2}"
   ```
   ```text
   2026
   11
   08
   2026-11-08
   ```
   Un inicio negativo cuenta desde el final, pero necesita un espacio después de los dos puntos: sin él, `:-2` es el valor por defecto del lab 04, y como `fecha` tiene valor, vale la fecha entera.

3. **Quitar del principio: `#` y `##`:**
   ```bash
   echo "${ruta#*/}"
   echo "${ruta##*/}"
   ```
   ```text
   var/log/nginx/access.log.2.gz
   access.log.2.gz
   ```
   El patrón `*/` es "cualquier cosa y una `/`". Con `#` se quita lo **más corto** que encaje desde el principio: solo la primera `/`. Con `##`, lo **más largo**: hasta la última `/`, y queda el nombre del archivo.

4. **Quitar del final: `%` y `%%`:**
   ```bash
   archivo=access.log.2.gz
   echo "${archivo%.*}"
   echo "${archivo%%.*}"
   echo "${archivo##*.}"
   echo "${ruta%/*}"
   ```
   ```text
   access.log.2
   access
   gz
   /var/log/nginx
   ```
   Lo mismo desde el final: `%.*` quita la última extensión; `%%.*`, todas. `##*.` quita hasta el último punto y deja la extensión. `%/*` quita la última `/` y el nombre: deja la carpeta. Para recordar cuál es cuál: en el teclado, `#` va antes que `%`, como el principio va antes que el final.

5. **Sustituir: `/` y `//`:**
   ```bash
   echo "${fecha/-/}"
   echo "${fecha//-/}"
   echo "${fecha//-//}"
   ```
   ```text
   202611-08
   20261108
   2026/11/08
   ```
   `${var/patrón/texto}` cambia la primera aparición; con `//`, todas. Con el texto vacío, borra. En el último ejemplo, el patrón es `-` y el texto, `/`.

6. **Mayúsculas y minúsculas:**
   ```bash
   ciudad=sevilla
   echo "${ciudad^}"
   echo "${ciudad^^}"
   GRITO=HOLA
   echo "${GRITO,,}"
   ```
   ```text
   Sevilla
   SEVILLA
   hola
   ```
   `^` pone en mayúscula la primera letra; `^^`, todas. `,` y `,,` hacen lo mismo hacia minúsculas. A diferencia de `tr` (semana 04), funcionan con letras con tilde.

7. **El script, sin tocar:**
   ```bash
   bash starter/path-parts.sh /var/log/nginx/access.log.2.gz
   bash starter/path-parts.sh
   echo $?
   ```
   ```text
   ruta:      /var/log/nginx/access.log.2.gz (30 caracteres)
   nombre:    var/log/nginx/access.log.2.gz
   uso: path-parts.sh <ruta>
   2
   ```
   El nombre sale con toda la ruta menos la primera `/`.

8. **TODO 1.** Abre `starter/path-parts.sh` en tu editor. Arregla la línea del `nombre` con lo del paso 3 y borra el comentario del `TODO 1`. Prueba:
   ```bash
   bash starter/path-parts.sh /var/log/nginx/access.log.2.gz | tail -1
   ```
   ```text
   nombre:    access.log.2.gz
   ```

9. **TODO 2.** Sustituye el comentario del `TODO 2` por dos líneas: `carpeta="${ruta%/*}"` y un `echo` que imprima `carpeta:   ` (tres espacios, para alinear) y su valor. Prueba:
   ```bash
   bash starter/path-parts.sh /var/log/nginx/access.log.2.gz | tail -1
   ```
   ```text
   carpeta:   /var/log/nginx
   ```

10. **TODO 3.** Sustituye el comentario del `TODO 3` por la extensión (`extension`, lo que hay tras el último punto de `$nombre`) y la base (`base`, `$nombre` sin la última extensión), cada una con su `echo`, como en el paso 4. Prueba:
    ```bash
    bash starter/path-parts.sh /var/log/nginx/access.log.2.gz | tail -2
    ```
    ```text
    extensión: gz
    base:      access.log.2
    ```

11. **TODO 4.** Sustituye el comentario del `TODO 4` por un `echo` que imprima `tipo:      ` y la extensión en mayúsculas (paso 6). Prueba:
    ```bash
    bash starter/path-parts.sh /var/log/nginx/access.log.2.gz | tail -1
    ```
    ```text
    tipo:      GZ
    ```

12. **TODO 5.** Sustituye el comentario del `TODO 5` por un `echo` que imprima `copia:     ` y la ruta de la copia: `$carpeta`, una `/`, `$base`, `-copia.` y `$extension`. Borra los comentarios `TODO`. Prueba con una ruta con espacios:
    ```bash
    bash starter/path-parts.sh "fotos/Mi Viaje/playa.JPG"
    ```
    ```text
    ruta:      fotos/Mi Viaje/playa.JPG (24 caracteres)
    nombre:    playa.JPG
    carpeta:   fotos/Mi Viaje
    extensión: JPG
    base:      playa
    tipo:      JPG
    copia:     fotos/Mi Viaje/playa-copia.JPG
    ```
    El espacio no rompe nada: cada expansión va entre comillas dobles.

## Criterios de éxito

- [ ] Explicas la diferencia entre `${ruta#*/}` y `${ruta##*/}` (paso 3)
- [ ] Explicas por qué `${fecha:-2}` no da los dos últimos caracteres (paso 2)
- [ ] `bash starter/path-parts.sh /var/log/nginx/access.log.2.gz` imprime `carpeta:   /var/log/nginx`, `extensión: gz`, `base:      access.log.2`, `tipo:      GZ` y `copia:     /var/log/nginx/access.log.2-copia.gz`

## Reto extra

Prueba `bash starter/path-parts.sh notas.txt` y `bash starter/path-parts.sh /etc/hostname`. ¿Qué sale como carpeta en el primero y como extensión en el segundo, y por qué? Para arreglarlo hay que preguntar antes si la ruta tiene `/` o el nombre tiene `.`: lo harás con `if` y `[[ ]]` en la semana 06. `bk-rename` esquiva el primer caso con otro truco: mira cómo calcula `dir` en el proyecto.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 04 — Valores por defecto](../lab-04-valores-por-defecto/README.md) | [Lab 06 — Aritmética](../lab-06-aritmetica/README.md) → |

[↑ Semana 05](../../README.md)
