# Lab 03 — Expresiones regulares

⏱ Duración estimada: ~60 min

## Objetivo

Describir con expresiones regulares básicas y extendidas el texto que buscas, y sacar solo ese trozo con `grep -o`.

## Contexto

- El patrón de `grep` es una expresión regular: unos pocos símbolos (`.`, `*`, `^`, `$`, `[ ]`) tienen significado especial, y con `-E` se suman `+`, `?`, `{n,m}`, `|` y `( )` ([teoría](../../1-teoria/02-grep-y-expresiones-regulares.md)).
- `<<<` (here-string, semana 03) pasa un texto corto por stdin: sirve para probar una regex sin crear un archivo.
- `datos/contactos.txt` es una lista de contactos con tres campos separados por `;`: nombre, correo y teléfono. Algunos están mal escritos a propósito. `starter/extract-contacts.sh` tiene una regex con un fallo y dos TODOs.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-04-filtros_de_texto_y_regex/2-practicas/lab-03-expresiones-regulares
   ```
   (sin salida).

1. **Los datos:**
   ```bash
   cat datos/contactos.txt
   ```
   ```text
   ana;ana.garcia@ejemplo.com;612 345 678
   luis;luis@ejemplo.com;612345678
   marta;marta@ejemplo-com;+34 699 111 222
   pablo;pablo.ruiz@correo.es;699 111 22
   sofía;sofia@ejemploscom.net;611 222 333
   jorge;jorge@@ejemplo.com;622 333 444
   lucía;LUCIA@EJEMPLO.COM;633 444 555
   ```
   Fíjate en los que están mal: el correo de marta no tiene punto, el teléfono de pablo tiene 8 cifras y jorge tiene dos `@`.

2. **Anclas: `^` y `$`.** Escribe el patrón entre comillas simples, siempre:
   ```bash
   grep '^l' datos/contactos.txt
   grep '5$' datos/contactos.txt
   ```
   ```text
   luis;luis@ejemplo.com;612345678
   lucía;LUCIA@EJEMPLO.COM;633 444 555
   lucía;LUCIA@EJEMPLO.COM;633 444 555
   ```
   `^l`: líneas que **empiezan** por `l`. `5$`: líneas que **terminan** en `5`. Sin ancla, `l` encajaría en casi todas.

3. **El punto y los corchetes.** `printf` escribe cada texto separado por `\n` en una línea:
   ```bash
   printf 'casa\ncosa\nc-sa\ncsa\n' | grep 'c.sa'
   printf 'casa\ncosa\nc-sa\ncsa\n' | grep 'c[ao]sa'
   ```
   ```text
   casa
   cosa
   c-sa
   casa
   cosa
   ```
   `.` es "un carácter cualquiera", también `-`, pero tiene que haber uno: `csa` no entra. `[ao]` es "una `a` o una `o`", ni más ni menos.

4. **Repeticiones y `-o`:**
   ```bash
   grep -o '[0-9][0-9]*' <<< 'versión 5.2.21'
   grep -oE '[0-9]+' <<< 'versión 5.2.21'
   grep -oE '[0-9]+\.[0-9]+' <<< 'versión 5.2.21'
   ```
   ```text
   5
   2
   21
   5
   2
   21
   5.2
   ```
   `-o` imprime solo los trozos que encajan, cada uno en su línea. `[0-9][0-9]*` es "un dígito y luego cero o más"; con `-E`, `[0-9]+` dice lo mismo más corto. En la tercera, `\.` es un punto de verdad: "dígitos, punto, dígitos".

5. **Extendidas: `|`, `( )`, `?` y `{n}`:**
   ```bash
   grep -E '^(ana|luis);' datos/contactos.txt
   grep -oE 'https?://[a-z.]+' <<< 'ver http://ejemplo.com y https://gnu.org'
   grep -oE '[0-9]{3}' <<< '612345678'
   ```
   ```text
   ana;ana.garcia@ejemplo.com;612 345 678
   luis;luis@ejemplo.com;612345678
   http://ejemplo.com
   https://gnu.org
   612
   345
   678
   ```
   `(ana|luis)` es "ana o luis", agrupado para que el `^` y el `;` valgan para los dos. `s?` es "una `s` o ninguna". `{3}` es "exactamente 3 veces". Dentro de `[a-z.]`, el punto es un punto: entre corchetes los símbolos pierden su significado especial.

6. **El script, sin tocar:**
   ```bash
   bash starter/extract-contacts.sh
   ```
   ```text
   de ejemplo.com: 5
   ```
   En el paso 1 hay 4 contactos de `ejemplo.com`: ana, luis, jorge (mal escrito, pero del dominio) y lucía (en mayúsculas). ¿De dónde salen 5?

7. **Encuentra el fallo.** Quita el `-c` para ver qué líneas cuenta:
   ```bash
   grep '@ejemplo.com' datos/contactos.txt
   ```
   ```text
   ana;ana.garcia@ejemplo.com;612 345 678
   luis;luis@ejemplo.com;612345678
   marta;marta@ejemplo-com;+34 699 111 222
   sofía;sofia@ejemploscom.net;611 222 333
   jorge;jorge@@ejemplo.com;622 333 444
   ```
   El `.` de la regex encaja con el `-` de marta y con la `s` de sofía (`ejemplo` + `s` + `com`). Y lucía no sale: está en mayúsculas.

8. **TODO 1.** Abre `starter/extract-contacts.sh` en tu editor y arregla la regex del `TODO 1`: `\.` para que el punto sea un punto, `;` al final para que el dominio termine ahí, y `-i` en `grep` para no distinguir mayúsculas (`-ci`). Prueba primero la regex suelta y después el script:
   ```bash
   grep -i '@ejemplo\.com;' datos/contactos.txt
   bash starter/extract-contacts.sh
   ```
   ```text
   ana;ana.garcia@ejemplo.com;612 345 678
   luis;luis@ejemplo.com;612345678
   jorge;jorge@@ejemplo.com;622 333 444
   lucía;LUCIA@EJEMPLO.COM;633 444 555
   de ejemplo.com: 4
   ```

9. **TODO 2.** Un correo con buena forma, entre los dos `;`: letras, dígitos, `.` o `_` (`[a-z0-9._]+`), una `@`, un nombre de dominio (`[a-z0-9-]+`), un punto (`\.`) y al menos 2 letras (`[a-z]{2,}`). Bajo el `TODO 2`, un `grep -iE` con esa regex entre `;` y `;`, redirigido a `zona/correos-validos.txt`. Prueba:
   ```bash
   bash starter/extract-contacts.sh > /dev/null
   cat zona/correos-validos.txt
   ```
   ```text
   ana;ana.garcia@ejemplo.com;612 345 678
   luis;luis@ejemplo.com;612345678
   pablo;pablo.ruiz@correo.es;699 111 22
   sofía;sofia@ejemploscom.net;611 222 333
   lucía;LUCIA@EJEMPLO.COM;633 444 555
   ```
   Fuera quedan marta (sin punto en el dominio) y jorge: tras la primera `@` viene otra, que no es `[a-z0-9-]`. `sofia@ejemploscom.net` tiene buena forma: es otro dominio, no un error.

10. **TODO 3.** Un teléfono completo: un `+34 ` opcional, y 9 cifras en tres grupos de 3 con un espacio opcional entre ellos, al final de la línea. Bajo el `TODO 3`, un `grep -oE` que saque solo eso, redirigido a `zona/telefonos.txt`. Pista: `(\+34 )?` (el `+` lleva `\` porque en `-E` significa "una o más") y ` ?` es "un espacio o ninguno". Borra los comentarios `TODO`. Prueba:
    ```bash
    bash starter/extract-contacts.sh > /dev/null
    cat zona/telefonos.txt
    ```
    ```text
    612 345 678
    612345678
    +34 699 111 222
    611 222 333
    622 333 444
    633 444 555
    ```
    Seis teléfonos: el de pablo tiene 8 cifras y no entra.

## Criterios de éxito

- [ ] Explicas qué hacen `^`, `$`, `.` y `[ ]` con un ejemplo de los pasos 2 y 3
- [ ] Explicas por qué `'@ejemplo.com'` contaba a marta y a sofía (paso 7)
- [ ] Explicas la diferencia entre `*` y `+`, y qué añade `-E` (pasos 4 y 5)
- [ ] `bash starter/extract-contacts.sh` imprime `de ejemplo.com: 4` y deja 5 correos y 6 teléfonos en `zona/`

## Reto extra

La regex de la teoría para una IP, `^([0-9]{1,3}\.){3}[0-9]{1,3}$`, acepta `999.1.1.1`. Prueba con `grep -E` y un here-string que la acepta, y busca una IP válida que no pase si quitas el `{1,3}` y pones `{3}`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 02 — grep: elegir líneas](../lab-02-grep/README.md) | [Lab 04 — cut y tr: columnas y caracteres](../lab-04-cut-y-tr/README.md) → |

[↑ Semana 04](../../README.md)
