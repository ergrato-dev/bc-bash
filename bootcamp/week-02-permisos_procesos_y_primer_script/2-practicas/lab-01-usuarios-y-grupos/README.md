# Lab 01 — Usuarios y grupos

⏱ Duración estimada: ~60 min

## Objetivo

Averiguar con qué usuario y grupos trabajas, y leer cómo los guarda el sistema en `/etc/passwd`.

## Contexto

- Para el sistema eres un número, el uid; el nombre es para las personas ([teoría](../../1-teoria/01-usuarios-grupos-y-permisos.md#quién-eres-para-el-sistema)).
- En el laboratorio eres `alumno` (uid 1000). Existe también `root` (uid 0), el administrador.
- `getent passwd NOMBRE` imprime la línea de un usuario en `/etc/passwd`. Si el usuario no existe, no imprime nada.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-02-permisos_procesos_y_primer_script/2-practicas/lab-01-usuarios-y-grupos
   ```

1. **¿Quién soy?**
   ```bash
   whoami
   id
   ```
   ```text
   alumno
   uid=1000(alumno) gid=1000(alumno) groups=1000(alumno)
   ```
   `id` da el número y, entre paréntesis, el nombre: tu usuario (`uid`), tu grupo principal (`gid`) y todos tus grupos (`groups`). Aquí solo perteneces a un grupo, que se llama igual que tú: es lo normal en Ubuntu.

2. **Solo una parte.** Las opciones de `id` recortan la salida:
   ```bash
   id -un
   id -u
   id -Gn
   ```
   ```text
   alumno
   1000
   alumno
   ```
   `-u` es el usuario, `-G` todos los grupos y `-n` pide nombres en vez de números. `groups` imprime lo mismo que `id -Gn`.

3. **El archivo de usuarios.** `/etc/passwd` tiene una línea por usuario. Mira las primeras con `less` (sales con `q`):
   ```bash
   less /etc/passwd
   ```
   Las primeras líneas:
   ```text
   root:x:0:0:root:/root:/bin/bash
   daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
   bin:x:2:2:bin:/bin:/usr/sbin/nologin
   sys:x:3:3:sys:/dev:/usr/sbin/nologin
   sync:x:4:65534:sync:/bin:/bin/sync
   ```
   Hay unas 20 líneas, pero tú eres la única persona: el resto son **usuarios de sistema**, que existen para que algunos programas corran con permisos limitados. Su shell es `/usr/sbin/nologin`: nadie puede entrar con ellos.

4. **Tu línea y la de root:**
   ```bash
   getent passwd alumno
   getent passwd root
   ```
   ```text
   alumno:x:1000:1000:Alumno bc-bash:/home/alumno:/bin/bash
   root:x:0:0:root:/root:/bin/bash
   ```
   Siete campos separados por `:`: nombre, `x` (la contraseña está en otro sitio), uid, gid, descripción, home y shell. Compara los dos home: el tuyo es `/home/alumno`; el de root, `/root`.

5. **Un usuario que no existe:**
   ```bash
   getent passwd nadie
   echo $?
   ```
   ```text
   2
   ```
   `getent` no imprime nada. `echo $?` muestra el **código de salida** del último comando: `0` si fue bien, otro número si no. `getent` usa `2` para decir "no existe". Los códigos se ven a fondo en la semana 03.

6. **Lo que no puedes ver.** Las contraseñas cifradas están en `/etc/shadow`:
   ```bash
   ls -l /etc/passwd /etc/shadow
   cat /etc/shadow
   ```
   ```text
   -rw-r--r-- 1 root root   969 Nov  8 04:41 /etc/passwd
   -rw-r----- 1 root shadow 533 Nov  8 04:41 /etc/shadow
   cat: /etc/shadow: Permission denied
   ```
   Fíjate en la primera columna: `/etc/passwd` termina en `r--` (los demás pueden leer) y `/etc/shadow` en `---` (los demás, nada). Aprenderás a leer esas letras en el lab 02. Lo mismo pasa con el home de root:
   ```bash
   ls /root
   ```
   ```text
   ls: cannot open directory '/root': Permission denied
   ```

7. **El script, sin tocar:**
   ```bash
   bash starter/who-am-i.sh
   ```
   ```text
   == nombre de usuario ==
   == número de usuario (uid) ==
   == grupos ==
   == tu línea en /etc/passwd ==
   == la línea de root ==
   ```

8. **TODO 1 y TODO 2.** Abre `starter/who-am-i.sh` en tu editor. Bajo cada `TODO`, el comando que te indica: `id -un` y `id -u`. Prueba con `bash starter/who-am-i.sh`: aparecen `alumno` y `1000` bajo sus cabeceras.

9. **TODO 3.** `id -Gn`. Prueba: aparece `alumno` bajo `== grupos ==`.

10. **TODO 4 y TODO 5.** `getent passwd alumno` y `getent passwd root`. Borra los comentarios `TODO`. Prueba:
    ```bash
    bash starter/who-am-i.sh
    ```
    ```text
    == nombre de usuario ==
    alumno
    == número de usuario (uid) ==
    1000
    == grupos ==
    alumno
    == tu línea en /etc/passwd ==
    alumno:x:1000:1000:Alumno bc-bash:/home/alumno:/bin/bash
    == la línea de root ==
    root:x:0:0:root:/root:/bin/bash
    ```

## Criterios de éxito

- [ ] Explicas qué significa cada parte de la salida de `id` (paso 1)
- [ ] Explicas los siete campos de tu línea en `/etc/passwd` (paso 4)
- [ ] Explicas por qué `cat /etc/shadow` falla y `cat /etc/passwd` no (paso 6)
- [ ] `bash starter/who-am-i.sh` imprime lo del paso 10

## Reto extra

`getent group alumno` imprime la línea de tu grupo en `/etc/group`. ¿Qué significa cada campo? Pista: `man 5 group`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Índice de labs](../README.md) | [Lab 02 — Leer permisos](../lab-02-leer-permisos/README.md) → |

[↑ Semana 02](../../README.md)
