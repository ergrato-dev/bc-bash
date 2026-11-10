# Lab 04 — Process substitution: <( ) y >( )

⏱ Duración estimada: ~60 min

## Objetivo

Pasar la salida de un comando a otro que solo acepta archivos con `<( )`, sin crear archivos temporales, y usar `< <( )` para que un `while` no pierda lo que cuenta.

## Contexto

- Algunos comandos comparan **dos archivos**: `diff`, `comm` o `join` quieren dos nombres, no un pipe. Para comparar la salida de dos comandos tendrías que guardarlas antes en archivos, y acordarte de borrarlos.
- `<(comando)` (*process substitution*) es un archivo de mentira: bash lanza el comando a la vez y lo que escribe se lee por ese archivo. `>(comando)` es lo contrario: lo que escribas en ese archivo le llega al comando por stdin.
- `datos/servidor-a.txt` y `datos/servidor-b.txt` son los paquetes de dos servidores, `nombre versión`, sin ordenar. `starter/compare-packages.sh` los compara, pero deja archivos en `/tmp` y su cuenta final está mal.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-13-procesos_y_concurrencia/2-practicas/lab-04-process-substitution
   ```
   (sin salida).

1. **Qué es `<( )`.** `echo` no lee nada: solo escribe sus argumentos. Así se ve en qué se convierte `<(true)`. `cat` lo lee como un archivo, y `ls -l` dice qué es:
   ```bash
   echo <(true)
   cat <(echo hola)
   ls -l <(true)
   ```
   ```text
   /dev/fd/63
   hola
   lr-x------ 1 alumno alumno 64 Nov 10 04:12 /dev/fd/63 -> pipe:[1218519]
   ```
   Un nombre de archivo, `/dev/fd/63`, que en realidad es un pipe (el número entre corchetes y la fecha cambian). El comando de dentro escribe en un lado; quien abre el "archivo" lee del otro.

2. **`diff` de dos salidas.** Las listas están en distinto orden, y `diff` compara línea a línea:
   ```bash
   diff datos/servidor-a.txt datos/servidor-b.txt | head -n 5
   diff <(sort datos/servidor-a.txt) <(sort datos/servidor-b.txt); echo "código: $?"
   ```
   ```text
   0a1,3
   > bash 5.2.21
   > curl 8.5.0
   > git 2.45.1
   1a5
   3c3,4
   < git 2.43.0
   ---
   > git 2.45.1
   > jq 1.7.1
   6d6
   < postgresql-client 16.2
   código: 1
   ```
   Sin ordenar, casi todo parece distinto. Ordenadas, solo tres diferencias: `git` cambia de versión, `jq` solo está en B y `postgresql-client` solo en A (`<` es el primer archivo, `>` el segundo). `diff` sale con `1` cuando hay diferencias.

3. **`comm`: tres columnas.** `comm` lee dos listas **ordenadas** y escribe en la primera columna lo que solo está en la primera, en la segunda lo que solo está en la segunda, y en la tercera lo que está en las dos. `cut -d ' ' -f 1` se queda con el nombre:
   ```bash
   comm <(cut -d ' ' -f 1 datos/servidor-a.txt | sort) <(cut -d ' ' -f 1 datos/servidor-b.txt | sort)
   ```
   ```text
   		bash
   		curl
   		git
   	jq
   		nginx
   		openssl
   postgresql-client
   ```
   Las columnas se separan con tabuladores. `comm -23` quita la segunda y la tercera (queda "solo en A"); `comm -13`, la primera y la tercera ("solo en B").

4. **El script, tal cual.** Abre `starter/compare-packages.sh` en tu editor. `ls /tmp` enseña qué hay en `/tmp` antes y después:
   ```bash
   ls /tmp
   bash starter/compare-packages.sh datos/servidor-a.txt datos/servidor-b.txt; echo "código: $?"
   ls /tmp
   ```
   ```text
   solo en datos/servidor-a.txt:
   postgresql-client
   solo en datos/servidor-b.txt:
   jq
   con otra versión:
     git: de 2.43.0 a 2.45.1
   total con otra versión: 0
   código: 0
   tmp.WLEBeTEGVz
   tmp.ziS17fNpkt
   ```
   Dos fallos. `/tmp` estaba vacía (el primer `ls` no escribe nada) y ahora tiene los dos temporales de `mktemp`, que nadie borra. Y lista `git` pero dice `0`. Los nombres de `/tmp` cambian; bórralos:
   ```bash
   rm /tmp/tmp.*
   ```
   (sin salida).

5. **TODO 1: sin temporales.** Cambia el comentario del `TODO 1` y las líneas hasta el segundo `comm` (las de `mktemp`, `names ... >` y los dos `comm`, con sus `echo`) por:
   ```bash
   # <(comando) es un archivo de mentira (/dev/fd/63) que se lee como la salida del comando:
   # comm recibe dos "archivos" sin que haya que crearlos, ni acordarse de borrarlos.
   echo "solo en $a:"
   comm -23 <(names "$a") <(names "$b")
   echo "solo en $b:"
   comm -13 <(names "$a") <(names "$b")
   ```
   Una función también vale dentro de `<( )`. Prueba:
   ```bash
   bash starter/compare-packages.sh datos/servidor-a.txt datos/servidor-b.txt | head -n 4
   ls /tmp | wc -l
   ```
   ```text
   solo en datos/servidor-a.txt:
   postgresql-client
   solo en datos/servidor-b.txt:
   jq
   0
   ```
   Lo mismo, y nada en `/tmp`.

6. **`join`: las versiones, una al lado de otra.** `join` junta las líneas de dos archivos ordenados que empiezan por la misma palabra. Es lo que usa el script:
   ```bash
   join <(sort datos/servidor-a.txt) <(sort datos/servidor-b.txt)
   ```
   ```text
   bash 5.2.21 5.2.21
   curl 8.5.0 8.5.0
   git 2.43.0 2.45.1
   nginx 1.24.0 1.24.0
   openssl 3.0.13 3.0.13
   ```
   Solo los paquetes que están en los dos, con la versión de A y la de B.

7. **TODO 2: la cuenta.** El bucle va detrás de un pipe (`join ... | while`): corre en un subshell, y el `changed` que suma se pierde al terminar (semana 07, y la traza del lab 05 de la semana 12). Con `< <(comando)`, el `while` lee de un `<( )` y corre en la shell del script. Cambia el comentario del `TODO 2` y el bucle por:
   ```bash
   # < <(join ...) y no join | while: detrás de un pipe, el while va en un subshell y lo que
   # cuenta en changed se pierde al salir del bucle.
   changed=0
   echo "con otra versión:"
   while read -r name version_a version_b; do
     if [[ $version_a != "$version_b" ]]; then
       echo "  $name: de $version_a a $version_b"
       changed=$((changed + 1))
     fi
   done < <(join <(sort "$a") <(sort "$b"))
   ```
   El primer `<` es una redirección normal; el segundo, el de `<( )`. Van separados por un espacio: `<<(` sería otra cosa. Prueba:
   ```bash
   bash starter/compare-packages.sh datos/servidor-a.txt datos/servidor-b.txt
   ```
   ```text
   solo en datos/servidor-a.txt:
   postgresql-client
   solo en datos/servidor-b.txt:
   jq
   con otra versión:
     git: de 2.43.0 a 2.45.1
   total con otra versión: 1
   ```

8. **`>( )`: escribir a un comando.** `tee` copia su entrada a stdout y a los archivos que le des. Con `>(gzip > numeros.gz)`, uno de esos "archivos" es `gzip`: guardas una copia comprimida mientras la salida sigue su camino:
   ```bash
   seq 1000 | tee >(gzip > numeros.gz) | wc -l
   sleep 0.2
   zcat numeros.gz | tail -n 1
   rm numeros.gz
   ```
   ```text
   1000
   1000
   ```
   `wc -l` cuenta las 1000 líneas, y `numeros.gz` tiene las mismas (`zcat` lo descomprime a stdout). El `sleep`: bash no espera al comando de `>( )`, y nada asegura que `gzip` haya terminado de escribir cuando acaba el pipe.

9. **shellcheck.**
   ```bash
   shellcheck starter/compare-packages.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas qué es `/dev/fd/63` y por qué `diff` y `comm` pueden leer de `<( )` (pasos 1 a 3)
- [ ] `bash starter/compare-packages.sh datos/servidor-a.txt datos/servidor-b.txt` no deja nada en `/tmp` (paso 5)
- [ ] El script dice `total con otra versión: 1`, y explicas por qué antes decía `0` (paso 7)
- [ ] Explicas por qué hace falta el `sleep` del paso 8

## Reto extra

Añade al script una línea final con cuántos paquetes tiene cada servidor, sin leer cada archivo dos veces: `wc -l < "$a"` sí lo lee dos veces si ya lo leíste para `sort`. ¿Se te ocurre cómo con `tee >( )`? ¿Merece la pena con archivos tan pequeños?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 03 — xargs en paralelo](../lab-03-xargs-en-paralelo/README.md) | [Lab 05 — coproc: una conversación con otro proceso](../lab-05-coproc/README.md) → |

[↑ Semana 13](../../README.md)
