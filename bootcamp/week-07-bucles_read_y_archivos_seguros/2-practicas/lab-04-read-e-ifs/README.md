# Lab 04 — read e IFS

⏱ Duración estimada: ~60 min

## Objetivo

Leer un archivo línea a línea con `while IFS= read -r`, partir cada línea en campos con `IFS` y no perder la última línea.

## Contexto

- `read` lee **una línea** de la entrada y la guarda en una o varias variables. Dentro de `while read ...; do ... done < archivo`, da una vuelta por línea.
- `IFS` es la lista de caracteres por los que `read` parte la línea en campos; por defecto, espacio, tabulador y salto de línea. `IFS=:` delante de `read` vale solo para ese `read`.
- `datos/passwd` tiene el formato de `/etc/passwd`: siete campos separados por `:` (usuario, `x`, uid, gid, nombre, home y shell). `starter/list-users.sh` tiene que listar las personas: uid de 1000 o más.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-07-bucles_read_y_archivos_seguros/2-practicas/lab-04-read-e-ifs
   ```
   (sin salida).

1. **`read` con varias variables.** `<<<` (here-string) le pasa un texto a un comando como si fuera su entrada, igual que un here-doc de una línea (semana 03):
   ```bash
   read -r first rest <<< "ana maria garcia"; echo "[$first] [$rest]"
   IFS=: read -r a b c <<< "uno:dos:tres:cuatro"; echo "[$a] [$b] [$c]"
   ```
   ```text
   [ana] [maria garcia]
   [uno] [dos] [tres:cuatro]
   ```
   Cada variable se lleva un campo, y la **última se lleva el resto** de la línea, separadores incluidos.

2. **Sin `-r`, las barras desaparecen.**
   ```bash
   read line <<< "C:\temp\nuevo"; echo "$line"
   read -r line <<< "C:\temp\nuevo"; echo "$line"
   ```
   ```text
   C:tempnuevo
   C:\temp\nuevo
   ```
   Sin `-r`, `read` trata `\` como un carácter especial y se lo come. Con `-r`, la línea llega tal cual. Ponlo siempre; shellcheck avisa si falta (`SC2162`).

3. **Sin `IFS=`, los espacios del principio desaparecen.**
   ```bash
   read -r line <<< "   con sangría"; echo "[$line]"
   IFS= read -r line <<< "   con sangría"; echo "[$line]"
   ```
   ```text
   [con sangría]
   [   con sangría]
   ```
   `read` quita los separadores del principio y del final. Con `IFS=` (vacío) no hay separadores: la línea entera, sin tocar. Para leer líneas completas, `IFS= read -r line`.

4. **La última línea sin salto de línea.** `cat -E` marca con `$` el final de cada línea:
   ```bash
   tail -n 3 datos/passwd | cat -E
   ```
   ```text
   luis:x:1001:1001:Luis Pérez,Sala 2,,:/home/luis:/bin/bash$
   nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin$
   marta:x:1002:1002:Marta Ruiz:/home/marta:/bin/zsh
   ```
   La última no tiene `$`: el archivo termina sin salto de línea, algo que pasa con archivos escritos a mano o en Windows. Puede que el prompt aparezca pegado a esa línea.

5. **Un bucle que lee el archivo.** `done < datos/passwd` le pasa el archivo al `while`, y cada `read` lee la línea siguiente:
   ```bash
   while IFS= read -r line; do echo "> $line"; done < datos/passwd
   ```
   ```text
   > root:x:0:0:root:/root:/bin/bash
   > daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
   > www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
   > ana:x:1000:1000:Ana García,,,:/home/ana:/bin/bash
   > luis:x:1001:1001:Luis Pérez,Sala 2,,:/home/luis:/bin/bash
   > nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
   ```
   Falta `marta`. `read` sí la lee y la guarda en `line`, pero sale con `1` porque no encontró el salto de línea, y el `while` termina sin dar esa vuelta. Lo arreglas en el paso 9.

6. **TODO 1: campos con `IFS=:`.** Abre `starter/list-users.sh` en tu editor. Borra el comentario del `TODO 1` y sustituye el `echo "sin implementar..."` por:
   ```bash
   while IFS=: read -r user _ uid _ gecos _; do
     echo "$user $uid"
   done < "$file"
   ```
   `_` es una variable que se usa para "este campo no me interesa"; el último `_` se lleva el home y el shell. Prueba:
   ```bash
   bash starter/list-users.sh datos/passwd
   ```
   ```text
   root 0
   daemon 1
   www-data 33
   ana 1000
   luis 1001
   nobody 65534
   ```

7. **TODO 2: solo personas.** Los usuarios de sistema tienen uid menor de 1000, y `nobody` (`65534`) es un usuario especial sin permisos. Dentro del bucle, antes del `echo`, añade (`continue`, lab 03):
   ```bash
     if [[ $uid -lt 1000 || $uid -eq 65534 ]]; then
       continue
     fi
   ```
   Borra el comentario del `TODO 2`. Prueba:
   ```bash
   bash starter/list-users.sh datos/passwd
   ```
   ```text
   ana 1000
   luis 1001
   ```

8. **TODO 3: el nombre, sin lo de detrás de la coma.** El quinto campo (`gecos`) puede llevar despacho y teléfonos tras comas: `Ana García,,,`. `${gecos%%,*}` quita desde la primera coma hasta el final (semana 05). Cambia el `echo` por:
   ```bash
     echo "$user (uid $uid): ${gecos%%,*}"
   ```
   Borra el comentario del `TODO 3`. Prueba:
   ```bash
   bash starter/list-users.sh datos/passwd
   ```
   ```text
   ana (uid 1000): Ana García
   luis (uid 1001): Luis Pérez
   ```

9. **TODO 4: no perder a `marta`.** Cuando `read` falla en la última línea, ya la ha guardado: `user` no está vacía. Cambia la condición del `while` para que dé la vuelta también en ese caso:
   ```bash
   while IFS=: read -r user _ uid _ gecos _ || [[ -n $user ]]; do
   ```
   `||` ejecuta lo de la derecha solo si `read` falla (semana 03). Al final del archivo, `read` no lee nada, `user` queda vacía y el bucle termina. Borra el comentario del `TODO 4`. Prueba con los datos y con el `/etc/passwd` del laboratorio:
   ```bash
   bash starter/list-users.sh datos/passwd
   bash starter/list-users.sh /etc/passwd
   ```
   ```text
   ana (uid 1000): Ana García
   luis (uid 1001): Luis Pérez
   marta (uid 1002): Marta Ruiz
   alumno (uid 1000): Alumno bc-bash
   ```

10. **shellcheck.**
    ```bash
    shellcheck starter/list-users.sh; echo $?
    ```
    ```text
    0
    ```

## Criterios de éxito

- [ ] Explicas qué cambian `-r` e `IFS=` con los ejemplos de los pasos 2 y 3
- [ ] Explicas por qué el bucle del paso 5 no imprimió la línea de `marta`
- [ ] `bash starter/list-users.sh datos/passwd` imprime las tres personas, `marta` incluida, y nadie más
- [ ] `shellcheck starter/list-users.sh` no imprime nada

## Reto extra

Añade el shell de cada persona a la salida: `ana (uid 1000, /bin/bash): Ana García`. ¿Cuántos `_` tienes que cambiar por variables con nombre?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 03 — break y continue](../lab-03-break-y-continue/README.md) | [Lab 05 — mapfile](../lab-05-mapfile/README.md) → |

[↑ Semana 07](../../README.md)
