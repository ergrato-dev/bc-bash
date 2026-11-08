# Lab 02 — Comillas

⏱ Duración estimada: ~60 min

## Objetivo

Elegir entre comillas simples, dobles, `\` y `$'...'` según lo que tenga que sustituir bash y lo que tenga que llegar tal cual.

## Contexto

- Las **comillas simples** dejan todo tal cual. Las **dobles** sustituyen `$variable` y `$( )`, y dejan el resto. La `\` quita el significado especial del carácter siguiente ([teoría](../../1-teoria/01-variables-y-comillas.md)).
- Las comillas no llegan al comando: bash las usa para saber qué es una palabra y qué sustituir, y después las quita.
- `starter/write-bashrc.sh` escribe un `.bashrc` de prueba en `zona/bashrc`: un saludo, un alias y una línea del `PATH`. Las tres líneas salen mal, cada una por unas comillas distintas.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-05-variables_comillas_y_expansiones/2-practicas/lab-02-comillas
   ```
   (sin salida).

1. **Simples, dobles y sin comillas:**
   ```bash
   echo '$HOME'
   echo "$HOME"
   echo $HOME
   ```
   ```text
   $HOME
   /home/alumno
   /home/alumno
   ```
   Entre simples, `$HOME` son cinco caracteres. Entre dobles o sin comillas, bash lo sustituye por su valor. La diferencia entre dobles y nada aparece con espacios y con `*` (lab 03).

2. **Un `$` que no se sustituye dentro de dobles:**
   ```bash
   echo "Tu shell es $SHELL"
   echo 'Tu shell es $SHELL'
   echo "Tu shell es \$SHELL"
   ```
   ```text
   Tu shell es /bin/bash
   Tu shell es $SHELL
   Tu shell es $SHELL
   ```
   Dentro de dobles, `\$` es un `$` normal. Así puedes mezclar en la misma frase lo que se sustituye y lo que no.

3. **Comillas dentro de comillas:**
   ```bash
   echo "Se llama 'bashkit'"
   echo 'Dijo "hola"'
   echo "Dijo \"hola\""
   echo 'O'\''Brien'
   ```
   ```text
   Se llama 'bashkit'
   Dijo "hola"
   Dijo "hola"
   O'Brien
   ```
   Unas comillas de un tipo no cuentan dentro de las del otro. Dentro de dobles, `\"` es una comilla doble. Dentro de simples no hay forma de poner una simple: el último ejemplo cierra (`'O'`), pone `\'` y abre otra vez (`'Brien'`). bash junta los tres trozos en una palabra.

4. **La barra invertida:**
   ```bash
   echo Mi\ Foto.jpg
   echo "Cuesta 5 \$ y lleva \\ y \" "
   ```
   ```text
   Mi Foto.jpg
   Cuesta 5 $ y lleva \ y " 
   ```
   Fuera de comillas, `\ ` es un espacio que no separa palabras: la tecla tab lo escribe así al completar un nombre con espacios. Dentro de dobles, la `\` solo es especial delante de `$`, `` ` ``, `"`, `\` y el salto de línea.

5. **Tabuladores y saltos de línea con `$'...'`:**
   ```bash
   echo 'uno\tdos'
   echo $'uno\tdos'
   echo $'línea 1\nlínea 2'
   ```
   ```text
   uno\tdos
   uno	dos
   línea 1
   línea 2
   ```
   Entre simples, `\t` son dos caracteres. Con un `$` delante, bash convierte `\t` en un tabulador y `\n` en un salto de línea.

6. **Las comillas no llegan al comando:**
   ```bash
   echo alias ll='ls -l'
   echo "alias ll='ls -l'"
   ```
   ```text
   alias ll=ls -l
   alias ll='ls -l'
   ```
   En la primera línea, las simples solo agrupan `ls -l`: bash las quita antes de pasar los argumentos a `echo`, que nunca las ve. En la segunda, están dentro de unas dobles y son caracteres normales.

7. **El script, sin tocar:**
   ```bash
   bash starter/write-bashrc.sh
   ```
   ```text
   echo "Hola, $usuario"
   alias ll=ls -l
   export PATH="/home/alumno/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
   ```
   El script imprime al final lo que escribió en `zona/bashrc`. Pruébalo como lo usaría una shell al arrancar. `source archivo` ejecuta sus líneas como si las escribieras tú (semana 08); va dentro de `bash -c` para no tocar tu shell:
   ```bash
   bash -c 'source zona/bashrc'
   ```
   ```text
   Hola, 
   zona/bashrc: line 2: alias: -l: not found
   ```
   - `$usuario` no existe en la shell nueva: se escribió sin sustituir.
   - El alias es `ll=ls`, y `-l` se toma por otro alias que no existe (paso 6).
   - El `PATH` parece bien, pero lleva fijo el valor de hoy: si mañana cambias el `PATH` antes de cargar este archivo, ese cambio se pierde.

8. **TODO 1.** Abre `starter/write-bashrc.sh` en tu editor. En la línea del `TODO 1`, `$usuario` tiene que sustituirse **ya**, y las comillas de `"Hola, ..."` tienen que llegar al archivo: usa dobles por fuera y `\"` por dentro (paso 3). Borra el comentario del `TODO 1`. Prueba:
   ```bash
   bash starter/write-bashrc.sh | head -1
   ```
   ```text
   echo "Hola, alumno"
   ```

9. **TODO 2.** En la línea del `TODO 2`, pon el texto `alias ll='ls -l'` entre comillas dobles, para que las simples lleguen al archivo (paso 6). Borra el comentario del `TODO 2`. Prueba:
   ```bash
   bash starter/write-bashrc.sh | sed -n 2p
   ```
   `sed -n 2p` imprime solo la línea 2 (semana 10):
   ```text
   alias ll='ls -l'
   ```

10. **TODO 3.** En la línea del `TODO 3`, `$HOME` y `$PATH` tienen que llegar **sin sustituir** al archivo: usa simples por fuera, y las dobles de dentro ya no necesitan `\`. Borra el comentario del `TODO 3`. Prueba el archivo y cárgalo:
    ```bash
    bash starter/write-bashrc.sh
    bash -c 'source zona/bashrc; alias ll'
    ```
    ```text
    echo "Hola, alumno"
    alias ll='ls -l'
    export PATH="$HOME/bin:$PATH"
    Hola, alumno
    alias ll='ls -l'
    ```
    Ahora el `PATH` se calcula cada vez que se carga el archivo, con el `PATH` que haya en ese momento.

## Criterios de éxito

- [ ] Explicas qué sustituyen las comillas dobles y qué dejan tal cual (pasos 1 y 2)
- [ ] Explicas por qué `echo alias ll='ls -l'` imprime `alias ll=ls -l` (paso 6)
- [ ] Explicas por qué la línea del `PATH` tiene que ir entre comillas simples (paso 10)
- [ ] `bash starter/write-bashrc.sh` deja en `zona/bashrc` las tres líneas del paso 10, y `bash -c 'source zona/bashrc'` imprime `Hola, alumno` sin errores

## Reto extra

`shellcheck solucion/write-bashrc.sh` no avisa, pero si borras la línea `# shellcheck disable=SC2016` sí. Lee el aviso: ¿por qué shellcheck sospecha de un `$HOME` entre comillas simples, y por qué aquí es justo lo que quieres?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 01 — Variables](../lab-01-variables/README.md) | [Lab 03 — Word splitting y globbing](../lab-03-word-splitting-y-globbing/README.md) → |

[↑ Semana 05](../../README.md)
