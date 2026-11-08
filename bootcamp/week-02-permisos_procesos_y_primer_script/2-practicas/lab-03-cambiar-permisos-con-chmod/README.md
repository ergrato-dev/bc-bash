# Lab 03 — Cambiar permisos con chmod

⏱ Duración estimada: ~60 min

## Objetivo

Cambiar permisos con `chmod` en forma simbólica y octal, y comprobar qué deja de funcionar cuando falta cada letra.

## Contexto

- Simbólica: `u`/`g`/`o`/`a`, `+`/`-`/`=` y las letras. Octal: un número por grupo, `r`=4, `w`=2, `x`=1 ([teoría](../../1-teoria/01-usuarios-grupos-y-permisos.md#cambiar-permisos-chmod)).
- Todo el lab ocurre en `zona/`. Si un experimento te deja una carpeta en la que no puedes entrar, el paso siguiente te dice cómo devolverle el permiso.
- `stat -c '%A %a %n'` muestra el permiso en letras (`%A`), en octal (`%a`) y el nombre (`%n`).

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio, ve a la carpeta del lab y crea la zona de pruebas:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-02-permisos_procesos_y_primer_script/2-practicas/lab-03-cambiar-permisos-con-chmod
   mkdir zona
   ```
   (sin salida). Si `mkdir` responde `File exists`, borra la anterior con `rm -r zona` y repite.

1. **Con qué permisos nace un archivo:**
   ```bash
   umask
   touch zona/nuevo.txt
   mkdir zona/caja
   echo hola > zona/caja/a.txt
   ls -l zona
   ```
   Algo como (las fechas cambian):
   ```text
   0022
   total 4
   drwxr-xr-x 2 alumno alumno 4096 Nov  8 04:45 caja
   -rw-r--r-- 1 alumno alumno    0 Nov  8 04:45 nuevo.txt
   ```
   La umask `022` quita la `w` al grupo y a los demás: los archivos nacen `644` y las carpetas `755`.

2. **Forma simbólica.** Cada `chmod` cambia solo lo que nombra:
   ```bash
   chmod u+x zona/nuevo.txt
   ls -l zona/nuevo.txt
   chmod go-r zona/nuevo.txt
   ls -l zona/nuevo.txt
   ```
   ```text
   -rwxr--r-- 1 alumno alumno 0 Nov  8 04:45 zona/nuevo.txt
   -rwx------ 1 alumno alumno 0 Nov  8 04:45 zona/nuevo.txt
   ```
   `u+x`: el dueño gana `x`. `go-r`: grupo y demás pierden `r`.

3. **Forma octal y `=`.** El número fija los nueve permisos de una vez; `a=r` deja exactamente `r` para todos:
   ```bash
   chmod 644 zona/nuevo.txt
   ls -l zona/nuevo.txt
   chmod a=r zona/nuevo.txt
   ls -l zona/nuevo.txt
   ```
   ```text
   -rw-r--r-- 1 alumno alumno 0 Nov  8 04:45 zona/nuevo.txt
   -r--r--r-- 1 alumno alumno 0 Nov  8 04:45 zona/nuevo.txt
   ```

4. **Sin `w` en el archivo no puedes cambiarlo.** `>>` añade texto al final de un archivo (se ve en la semana 03):
   ```bash
   echo mas >> zona/nuevo.txt
   ```
   ```text
   bash: zona/nuevo.txt: Permission denied
   ```
   Quien da el error es bash: es bash quien intenta abrir el archivo para escribir. Eres el dueño, pero también a ti te afecta tu propio permiso. Devuélvelo con `chmod u+w zona/nuevo.txt`.

5. **Sin `r` en el archivo no puedes leerlo:**
   ```bash
   chmod u-r zona/caja/a.txt
   cat zona/caja/a.txt
   chmod u+r zona/caja/a.txt
   ```
   ```text
   cat: zona/caja/a.txt: Permission denied
   ```

6. **Sin `x` en la carpeta no puedes entrar ni llegar a lo de dentro:**
   ```bash
   chmod u-x zona/caja
   cd zona/caja
   ls zona/caja
   cat zona/caja/a.txt
   ```
   ```text
   bash: cd: zona/caja: Permission denied
   a.txt
   cat: zona/caja/a.txt: Permission denied
   ```
   `ls` aún ve el **nombre** `a.txt` (eso lo da la `r` de la carpeta), pero nadie llega al archivo: ni `cd`, ni `cat`. Prueba también `ls -l zona/caja`: los datos del archivo salen como `?`. Devuelve el permiso:
   ```bash
   chmod u+x zona/caja
   ```

7. **Sin `w` en la carpeta no puedes crear ni borrar dentro**, aunque el archivo sea tuyo:
   ```bash
   chmod u-w zona/caja
   touch zona/caja/b.txt
   rm zona/caja/a.txt
   chmod u+w zona/caja
   ```
   ```text
   touch: cannot touch 'zona/caja/b.txt': Permission denied
   rm: cannot remove 'zona/caja/a.txt': Permission denied
   ```
   Borrar un archivo es cambiar la carpeta que lo contiene: lo que cuenta es la `w` de la carpeta.

8. **Errores de `chmod`:**
   ```bash
   chmod 9 zona/nuevo.txt
   ```
   ```text
   chmod: invalid mode: ‘9’
   Try 'chmod --help' for more information.
   ```
   En octal solo existen los dígitos del 0 al 7: la suma más alta es 4+2+1. Limpia antes del script:
   ```bash
   rm -r zona
   ```
   (sin salida). Si `rm` pregunta `remove write-protected regular empty file`, es un archivo sin `w`: responde `y`. Si se queja de `Permission denied`, te quedó una carpeta sin `w` o sin `x`: `chmod -R u+rwx zona` (`-R` aplica el cambio a todo lo de dentro) y repite.

9. **El script, sin tocar.** `starter/set-perms.sh` rehace `zona/` con cuatro elementos y muestra sus permisos:
   ```bash
   bash starter/set-perms.sh
   ```
   ```text
   -rw-r--r-- 644 zona/compartido.txt
   -rw-r--r-- 644 zona/deploy.sh
   -rw-r--r-- 644 zona/notas.txt
   drwxr-xr-x 755 zona/privada
   ```
   Todos con los permisos de nacimiento.

10. **TODO 1.** Abre `starter/set-perms.sh` en tu editor. `chmod +x zona/deploy.sh`. Prueba con `bash starter/set-perms.sh`: `deploy.sh` pasa a `-rwxr-xr-x 755`.

11. **TODO 2.** En octal, `600` sobre `zona/notas.txt`. Prueba: `notas.txt` pasa a `-rw------- 600`.

12. **TODO 3.** En simbólico, añade `w` al grupo de `zona/compartido.txt` (`g+w`). Prueba: `compartido.txt` pasa a `-rw-rw-r-- 664`.

13. **TODO 4.** En simbólico, quita `r` y `x` al grupo y a los demás en `zona/privada` (`go-rx`). Borra los comentarios `TODO`. Prueba:
    ```bash
    bash starter/set-perms.sh
    ```
    ```text
    -rw-rw-r-- 664 zona/compartido.txt
    -rwxr-xr-x 755 zona/deploy.sh
    -rw------- 600 zona/notas.txt
    drwx------ 700 zona/privada
    ```

14. **Limpieza:**
    ```bash
    rm -r zona
    ```
    (sin salida).

## Criterios de éxito

- [ ] Explicas por qué `ls zona/caja` ve el nombre del archivo pero `cat` no puede leerlo (paso 6)
- [ ] Explicas por qué no pudiste borrar un archivo tuyo (paso 7)
- [ ] Explicas cuándo usarías la forma simbólica y cuándo la octal
- [ ] `bash starter/set-perms.sh` imprime lo del paso 13

## Reto extra

Ejecuta `umask 077`, crea un archivo con `touch` y mira sus permisos. ¿Qué cambió y por qué? Esa umask solo dura hasta que salgas del laboratorio.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 02 — Leer permisos](../lab-02-leer-permisos/README.md) | [Lab 04 — Propietarios y root](../lab-04-propietarios-y-root/README.md) → |

[↑ Semana 02](../../README.md)
