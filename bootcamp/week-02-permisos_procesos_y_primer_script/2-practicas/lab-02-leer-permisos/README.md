# Lab 02 — Leer permisos

⏱ Duración estimada: ~60 min

## Objetivo

Leer en `ls -l` y en `stat` quién puede leer, escribir y ejecutar cada archivo y cada carpeta.

## Contexto

- Diez caracteres: el tipo y tres grupos `rwx` para el dueño, el grupo y los demás ([teoría](../../1-teoria/01-usuarios-grupos-y-permisos.md#leer-los-permisos)).
- En una carpeta, `r` deja ver los nombres, `w` crear y borrar dentro, `x` entrar.
- `starter/read-perms.sh` prepara en `zona/` cinco archivos y carpetas con permisos distintos. Los prepara con `chmod`, que verás en el lab 03: aquí solo los lees.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-02-permisos_procesos_y_primer_script/2-practicas/lab-02-leer-permisos
   ```

1. **Dos archivos del sistema:**
   ```bash
   ls -l /etc/passwd /usr/bin/ls
   ```
   Algo como (cambian el tamaño y la fecha):
   ```text
   -rw-r--r-- 1 root root    969 Nov  8 04:41 /etc/passwd
   -rwxr-xr-x 1 root root 142312 Aug 25 15:09 /usr/bin/ls
   ```
   Lee de izquierda a derecha. `/etc/passwd`: `-` archivo; dueño `root` con `rw-` (leer y escribir); grupo `root` con `r--`; los demás con `r--`. Tú eres "los demás": puedes leerlo, no cambiarlo. `/usr/bin/ls` tiene además `x` en los tres grupos: todo el mundo puede ejecutarlo.

2. **Carpetas.** `ls -l` sobre una carpeta lista lo que hay dentro. Con `-d` (*directory*) muestra la carpeta misma:
   ```bash
   ls -ld /etc /home/alumno /tmp
   ```
   Algo como:
   ```text
   drwxr-xr-x 1 root   root   4096 Nov  8 04:45 /etc
   drwxr-x--- 2 alumno alumno 4096 Sep 11 02:10 /home/alumno
   drwxrwxrwt 2 root   root   4096 Sep 11 02:10 /tmp
   ```
   - `/etc`: todos pueden entrar y listar; solo root crea archivos ahí.
   - `/home/alumno`: tu home. Los demás no tienen nada (`---`): otro usuario no podría ni entrar.
   - `/tmp`: todos pueden escribir (`rwx` en los tres). La `t` final es un permiso especial, el *sticky bit*: aunque todos escriban ahí, cada uno solo puede borrar sus propios archivos.

3. **El script, sin tocar:**
   ```bash
   bash starter/read-perms.sh
   ```
   ```text
   == ls -l ==
   == la carpeta zona, no su contenido ==
   == permisos en octal ==
   == dueño y grupo ==
   ```
   Las cabeceras salen vacías, pero `zona/` ya está preparada.

4. **TODO 1.** Abre `starter/read-perms.sh` en tu editor. `ls -l zona`. Prueba con `bash starter/read-perms.sh`:
   ```text
   == ls -l ==
   total 8
   -rwxr-xr-x 1 alumno alumno    0 Nov  8 04:45 deploy.sh
   -rw-r--r-- 1 alumno alumno    0 Nov  8 04:45 informe.txt
   drwx------ 2 alumno alumno 4096 Nov  8 04:45 privada
   drwxr-xr-x 2 alumno alumno 4096 Nov  8 04:45 publica
   -rw------- 1 alumno alumno    0 Nov  8 04:45 secreto.txt
   ```
   (las fechas cambian). Antes de seguir, contesta para cada línea: ¿quién puede leerlo? ¿Quién puede cambiarlo? ¿Es un archivo o una carpeta?

5. **TODO 2.** `ls -ld zona`. Prueba: bajo la segunda cabecera aparece una sola línea, la de `zona` (`drwxr-xr-x ... zona`).

6. **TODO 3.** El mismo permiso en números. `stat` muestra datos de un archivo; con `-c` eliges cuáles: `%a` es el permiso en octal y `%n` el nombre. `zona/*` significa "todo lo que hay en `zona`". Escribe `stat -c '%a %n' zona/*`. Prueba: aparece
   ```text
   == permisos en octal ==
   755 zona/deploy.sh
   644 zona/informe.txt
   700 zona/privada
   755 zona/publica
   600 zona/secreto.txt
   ```
   Comprueba la suma con el paso 4: `rwx` = 4+2+1 = 7, `r-x` = 4+0+1 = 5, `r--` = 4, `---` = 0.

7. **TODO 4.** `%U` es el nombre del dueño y `%G` el del grupo: `stat -c '%U %G %n' zona/*`. Borra los comentarios `TODO`. Prueba:
   ```bash
   bash starter/read-perms.sh
   ```
   El último bloque:
   ```text
   == dueño y grupo ==
   alumno alumno zona/deploy.sh
   alumno alumno zona/informe.txt
   alumno alumno zona/privada
   alumno alumno zona/publica
   alumno alumno zona/secreto.txt
   ```

8. **Limpieza:**
   ```bash
   rm -r zona
   ```
   (sin salida).

## Criterios de éxito

- [ ] Explicas los tres permisos de `/home/alumno` y por qué otro usuario no podría entrar (paso 2)
- [ ] Para cada archivo de `zona/`, dices quién puede leerlo y quién cambiarlo (paso 4)
- [ ] Pasas de `rwxr-xr-x` a `755` y de `600` a `rw-------` sin mirar (paso 6)
- [ ] `bash starter/read-perms.sh` imprime los cuatro bloques de los pasos 4 a 7

## Reto extra

`ls -l /usr/bin/passwd` muestra una `s` donde esperarías una `x`. Busca en `man chmod` (sección *SETUID AND SETGID BITS*) qué significa y por qué `passwd` la necesita para cambiar tu contraseña en `/etc/shadow`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 01 — Usuarios y grupos](../lab-01-usuarios-y-grupos/README.md) | [Lab 03 — Cambiar permisos con chmod](../lab-03-cambiar-permisos-con-chmod/README.md) → |

[↑ Semana 02](../../README.md)
