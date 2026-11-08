# Lab 05 — Here-docs y here-strings

⏱ Duración estimada: ~60 min

## Objetivo

Pasar varias líneas de texto a un comando con un here-doc, decidir si bash sustituye lo que hay dentro, y pasar un solo texto con un here-string.

## Contexto

- Un **here-doc** (`<<EOF`) mete en el stdin de un comando las líneas que escribes debajo, hasta una línea que diga solo `EOF`. Es la forma de que un script genere archivos de varias líneas ([teoría](../../1-teoria/02-pipes-tee-y-here-docs.md)).
- Un **here-string** (`<<<`) hace lo mismo con un único texto.
- `starter/write-config.sh` genera `zona/app.conf`, la configuración de una aplicación imaginaria, con datos de este equipo.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-03-redireccion_pipes_y_codigos_de_salida/2-practicas/lab-05-here-docs-y-here-strings
   ```
   (sin salida).

1. **Un here-doc en la terminal.** Escribe la primera línea y pulsa Enter: el prompt cambia a `>`, que significa "bash espera más". Escribe las otras tres:
   ```bash
   cat <<EOF
   primera línea
   segunda línea
   EOF
   ```
   En tu pantalla:
   ```text
   $ cat <<EOF
   > primera línea
   > segunda línea
   > EOF
   primera línea
   segunda línea
   ```
   `cat` sin archivo lee su stdin y lo imprime. Al llegar a `EOF`, bash le da las dos líneas. `EOF` (*end of file*) es costumbre: vale cualquier palabra, siempre que la de cierre sea igual.

2. **Dentro, bash sustituye:**
   ```bash
   cat <<EOF
   usuario: $(id -un)
   carpeta: $PWD
   EOF
   ```
   Algo como (cambia la carpeta):
   ```text
   usuario: alumno
   carpeta: /bc-bash/bootcamp/week-03-redireccion_pipes_y_codigos_de_salida/2-practicas/lab-05-here-docs-y-here-strings
   ```
   `$(...)` y las variables se sustituyen antes de que `cat` vea el texto, como dentro de comillas dobles.

3. **Con comillas en el `EOF`, no:**
   ```bash
   cat <<'EOF'
   usuario: $(id -un)
   carpeta: $PWD
   EOF
   ```
   ```text
   usuario: $(id -un)
   carpeta: $PWD
   ```
   El texto llega tal cual, como dentro de comillas simples. Lo usarás para escribir scripts o configuraciones que tengan sus propios `$`.

4. **Un here-doc a un archivo:**
   ```bash
   mkdir zona
   cat > zona/saludo.txt <<EOF
   hola, $(id -un)
   EOF
   cat zona/saludo.txt
   ```
   ```text
   hola, alumno
   ```
   Hay dos redirecciones: `<<EOF` alimenta el stdin de `cat` y `>` manda su stdout al archivo.

5. **La línea de cierre tiene que ser exacta:**
   ```bash
   cat <<EOF
    EOF
   EOF
   ```
   ```text
    EOF
   ```
   La primera línea tiene un espacio delante de `EOF`, así que no cierra: es texto. Si un here-doc de un script "se come" el resto del archivo, mira si la línea de cierre tiene espacios.

6. **Here-string, `<<<`:** `wc -w` cuenta palabras.
   ```bash
   wc -w <<< "uno dos tres"
   wc -w <<< uno dos tres
   ```
   ```text
   3
   wc: dos: No such file or directory
   wc: tres: No such file or directory
   0 total
   ```
   Con comillas, las tres palabras son un único texto que entra por stdin. Sin comillas, `<<<` solo se lleva `uno`, y `wc` toma `dos` y `tres` como nombres de archivo.

7. **El script, sin tocar:**
   ```bash
   bash starter/write-config.sh
   ```
   ```text
   cat: zona/app.conf: No such file or directory
   ```
   El script termina con `cat zona/app.conf`, pero nadie lo ha creado todavía.

8. **TODO 1.** Abre `starter/write-config.sh` en tu editor. Bajo el `TODO 1`, un here-doc que escriba en `zona/app.conf` (como en el paso 4) tres líneas: `usuario=` seguido de `$(id -un)`, `equipo=` con `$(hostname)` y `creado=` con `$(date '+%F')`. Prueba:
   ```bash
   bash starter/write-config.sh
   ```
   Algo como (cambia la fecha):
   ```text
   usuario=alumno
   equipo=bc-bash-lab
   creado=2026-11-08
   ```

9. **TODO 2.** Bajo el `TODO 2`, otro `cat` con here-doc, esta vez con `'EOF'` entre comillas y `>>` para añadir. Dentro, las dos líneas que dice el comentario, tal cual. Borra los comentarios `TODO`. Prueba dos veces:
   ```bash
   bash starter/write-config.sh
   bash starter/write-config.sh
   ```
   Algo como (cada ejecución imprime esto):
   ```text
   usuario=alumno
   equipo=bc-bash-lab
   creado=2026-11-08
   # $HOME lo resuelve la aplicación al arrancar, no este script
   datos=$HOME/datos
   ```
   `$HOME` queda escrito: la aplicación lo resolverá con el home de quien la arranque. Y la segunda ejecución no duplica líneas, porque el primer here-doc usa `>` y vuelve a empezar.

## Criterios de éxito

- [ ] Explicas la diferencia entre `<<EOF` y `<<'EOF'` (pasos 2 y 3)
- [ ] Explicas por qué falla `wc -w <<< uno dos tres` sin comillas (paso 6)
- [ ] `bash starter/write-config.sh` imprime las cinco líneas del paso 9, con `$HOME` sin sustituir, también al repetirlo

## Reto extra

Cambia el primer here-doc para que la línea de `creado=` no se sustituya pero las otras dos sí. Pista: dentro de un here-doc sin comillas, `\$` escribe un `$` literal.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 04 — Pipes y tee](../lab-04-pipes-y-tee/README.md) | [Lab 06 — Códigos de salida](../lab-06-codigos-de-salida/README.md) → |

[↑ Semana 03](../../README.md)
