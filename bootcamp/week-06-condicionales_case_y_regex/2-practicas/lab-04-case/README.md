# Lab 04 — case

⏱ Duración estimada: ~60 min

## Objetivo

Elegir entre varias opciones según la forma de un texto con `case`, sus patrones glob, `|` y la rama `*)`.

## Contexto

- `case` compara un valor con una lista de patrones y ejecuta solo la **primera** rama que encaja ([teoría](../../1-teoria/03-case.md)). Sustituye a una cadena de `elif` que compara el mismo valor una y otra vez.
- Los patrones son globs, como los de los nombres de archivo (semana 05): `*`, `?`, `[0-9]`. `*)` encaja con todo: es la rama "en cualquier otro caso".
- `starter/extract-hint.sh` dice con qué comando se descomprime un archivo según su extensión. Viene **roto a propósito**: una rama nunca se usa, falta otra y no reconoce las mayúsculas.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-06-condicionales_case_y_regex/2-practicas/lab-04-case
   ```
   (sin salida).

1. **La forma de `case`.** `case valor in`, después cada rama: patrones, `)`, comandos y `;;`; al final, `esac` (`case` al revés). `|` separa dos patrones de la misma rama:
   ```bash
   resp=s
   case "$resp" in s | si) echo "adelante" ;; n | no) echo "cancelado" ;; *) echo "no te entiendo" ;; esac
   resp=quizas
   case "$resp" in s | si) echo "adelante" ;; n | no) echo "cancelado" ;; *) echo "no te entiendo" ;; esac
   ```
   ```text
   adelante
   no te entiendo
   ```
   En un script, cada rama va en su línea (como en `starter/extract-hint.sh`); en la terminal cabe en una.

2. **Mayúsculas.** `case` distingue mayúsculas. Con `${var,,}` (semana 05) comparas en minúsculas sin cambiar la variable:
   ```bash
   resp=Sí
   case "${resp,,}" in s | si | sí) echo "adelante" ;; *) echo "no te entiendo" ;; esac
   ```
   ```text
   adelante
   ```

3. **Patrones glob.** `*` es "cualquier texto"; `[0-9]`, "una cifra":
   ```bash
   f=foto.JPG
   case "$f" in *.jpg | *.JPG | *.png) echo "imagen" ;; *.txt) echo "texto" ;; *) echo "otro" ;; esac
   v=7
   case "$v" in [0-9]) echo "una cifra" ;; [0-9][0-9]) echo "dos cifras" ;; *) echo "otra cosa" ;; esac
   v=42
   case "$v" in [0-9]) echo "una cifra" ;; [0-9][0-9]) echo "dos cifras" ;; *) echo "otra cosa" ;; esac
   ```
   ```text
   imagen
   una cifra
   dos cifras
   ```
   Un patrón encaja con el texto **entero**: `42` no encaja con `[0-9]`, que es una sola cifra.

4. **Patrón entre comillas, texto literal.** Igual que con `[[ == ]]` (lab 02):
   ```bash
   p="*"
   case "$p" in "*") echo "un asterisco" ;; *) echo "otra cosa" ;; esac
   p=hola
   case "$p" in "*") echo "un asterisco" ;; *) echo "otra cosa" ;; esac
   ```
   ```text
   un asterisco
   otra cosa
   ```

5. **Gana la primera rama.** `app.tar.gz` encaja con `*.gz` y con `*.tar.gz`:
   ```bash
   f=app.tar.gz
   case "$f" in *.gz) echo "rama gz" ;; *.tar.gz) echo "rama tar.gz" ;; esac
   ```
   ```text
   rama gz
   ```
   El patrón más concreto va antes que el más general, y `*)`, siempre el último.

6. **Sin `;;`.** Si olvidas el `;;`, bash sigue leyendo la rama hasta el final:
   ```bash
   bash -c 'case x in x) echo uno esac'
   ```
   ```text
   bash: -c: line 2: syntax error: unexpected end of file
   ```
   Sin `;;` delante, `esac` es un argumento más de `echo`, y el `case` se queda sin cerrar.

7. **El script y el TODO 1.**
   ```bash
   bash starter/extract-hint.sh app.tar.gz
   bash starter/extract-hint.sh notas.txt.gz
   ```
   ```text
   gunzip -- 'app.tar.gz'
   gunzip -- 'notas.txt.gz'
   ```
   `gunzip` descomprime `app.tar.gz` a `app.tar`, pero no saca lo que hay dentro: para eso es `tar -xzf`. Abre `starter/extract-hint.sh` en tu editor y mueve la línea de `*.gz)` debajo de la de `*.tar)`, como en el paso 5. Borra el comentario del `TODO 1`. Prueba:
   ```bash
   bash starter/extract-hint.sh app.tar.gz
   bash starter/extract-hint.sh notas.txt.gz
   ```
   ```text
   tar -xzf 'app.tar.gz'
   gunzip -- 'notas.txt.gz'
   ```

8. **TODO 2.** Sustituye el comentario del `TODO 2` por una rama para `*.zip` que imprima `unzip '<archivo>'`, con la forma de las otras. Prueba:
   ```bash
   bash starter/extract-hint.sh fotos.zip
   bash starter/extract-hint.sh FOTOS.ZIP; echo $?
   ```
   ```text
   unzip 'fotos.zip'
   0
   ```
   `FOTOS.ZIP` no encaja con ninguna rama: no imprime nada y sale con `0`, como si todo fuera bien.

9. **TODO 3.** Cambia `case "$file" in` por `case "${file,,}" in` (paso 2). Las ramas siguen imprimiendo `$file`, con el nombre original. Borra el comentario del `TODO 3`. Prueba:
   ```bash
   bash starter/extract-hint.sh FOTOS.ZIP
   bash starter/extract-hint.sh "Copia App.TAR.GZ"
   ```
   ```text
   unzip 'FOTOS.ZIP'
   tar -xzf 'Copia App.TAR.GZ'
   ```

10. **TODO 4.** Lo que no encaja con nada tiene que avisar. Sustituye el comentario del `TODO 4` por la rama `*)`, con varias líneas:
    ```bash
      *)
        echo "extract-hint.sh: no sé descomprimir '$file'" >&2
        exit 1
        ;;
    ```
    Prueba:
    ```bash
    bash starter/extract-hint.sh informe.pdf; echo $?
    bash starter/extract-hint.sh datos.tar; echo $?
    ```
    ```text
    extract-hint.sh: no sé descomprimir 'informe.pdf'
    1
    tar -xf 'datos.tar'
    0
    ```

## Criterios de éxito

- [ ] Explicas por qué `app.tar.gz` entraba en la rama de `*.gz` (pasos 5 y 7)
- [ ] Explicas por qué `"*")` y `*)` no son la misma rama (paso 4)
- [ ] `bash starter/extract-hint.sh "Copia App.TAR.GZ"` imprime `tar -xzf 'Copia App.TAR.GZ'`
- [ ] `bash starter/extract-hint.sh informe.pdf` avisa en stderr y sale con `1`

## Reto extra

Añade `*.tar.bz2 | *.tbz2)` con `tar -xjf` y `*.tar.xz | *.txz)` con `tar -xJf`. ¿En qué orden respecto a `*.tar)` tienen que ir? ¿Y `*.xz)` con `unxz`?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 03 — Operadores de archivo](../lab-03-operadores-de-archivo/README.md) | [Lab 05 — Regex y BASH_REMATCH](../lab-05-regex-y-bash-rematch/README.md) → |

[↑ Semana 06](../../README.md)
