# Lab 04 — Propietarios y root

⏱ Duración estimada: ~60 min

## Objetivo

Cambiar el dueño y el grupo de un archivo con `chown` como root, y comprobar con otro usuario qué permite cada permiso.

## Contexto

- Solo root puede regalar un archivo a otro usuario ([teoría](../../1-teoria/01-usuarios-grupos-y-permisos.md#cambiar-el-dueño-chown)).
- El laboratorio no tiene `sudo`. Para ser root se entra con `docker compose run --rm -u root lab`: `-u root` arranca el contenedor como ese usuario.
- Como root trabajarás en `/tmp`, que está dentro del contenedor y desaparece al salir. **Nunca crees archivos como root dentro de `/bc-bash`**: es la carpeta del repositorio en tu equipo, y esos archivos serían de root también allí. No podrías borrarlos sin permisos de administrador.

## Instrucciones

0. Entra al laboratorio **como alumno**, como siempre, y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-02-permisos_procesos_y_primer_script/2-practicas/lab-04-propietarios-y-root
   ```

1. **Como alumno, `chown` no funciona:**
   ```bash
   mkdir zona
   touch zona/mio.txt
   chown root zona/mio.txt
   ```
   ```text
   chown: changing ownership of 'zona/mio.txt': Operation not permitted
   ```
   Aunque el archivo es tuyo, no puedes dárselo a otro. Borra la zona y sal del laboratorio:
   ```bash
   rm -r zona
   exit
   ```

2. **Entra como root.** En tu equipo, desde la raíz del repositorio:
   ```bash
   docker compose run --rm -u root lab
   ```
   El prompt cambia:
   ```text
   root@bc-bash-lab:/bc-bash#
   ```
   El `#` final en vez de `$` es la señal de que eres root. Mientras lo veas, cada comando puede cambiar cualquier cosa del sistema.

3. **Root no tiene límites:**
   ```bash
   id
   ls /root
   ```
   ```text
   uid=0(root) gid=0(root) groups=0(root)
   ```
   `ls /root` ya no da `Permission denied` (no imprime nada porque la carpeta está vacía).

4. **Crea una usuaria.** `useradd` añade un usuario al sistema:
   ```bash
   useradd ana
   id ana
   ```
   ```text
   uid=1001(ana) gid=1001(ana) groups=1001(ana)
   ```
   `ana` recibe el siguiente uid libre y un grupo propio con su nombre. Solo existirá hasta que salgas.

5. **`chown` y `chgrp` en `/tmp`:**
   ```bash
   cd /tmp
   mkdir prueba
   cd prueba
   echo hola > a.txt
   ls -l a.txt
   chown ana a.txt
   ls -l a.txt
   chgrp alumno a.txt
   ls -l a.txt
   ```
   Algo como (cambia la fecha):
   ```text
   -rw-r--r-- 1 root root 5 Nov  8 04:45 a.txt
   -rw-r--r-- 1 ana root 5 Nov  8 04:45 a.txt
   -rw-r--r-- 1 ana alumno 5 Nov  8 04:45 a.txt
   ```
   Las columnas tercera y cuarta son el dueño y el grupo. `chown ana:alumno a.txt` habría hecho los dos cambios a la vez.

6. **Probar como otro usuario.** `runuser -u USUARIO -- COMANDO` ejecuta un comando como ese usuario, sin cambiar de sesión. Solo root puede usarlo. Deja `a.txt` solo para su dueña:
   ```bash
   chmod 600 a.txt
   runuser -u ana -- cat a.txt
   runuser -u alumno -- cat a.txt
   cat a.txt
   ```
   ```text
   hola
   cat: a.txt: Permission denied
   hola
   ```
   `ana` lee (es la dueña), `alumno` no (es del grupo, pero el grupo tiene `---`), y root lee igualmente: a root no le afectan los permisos.

7. **El script, sin tocar.** Vuelve a la carpeta del lab:
   ```bash
   cd /bc-bash/bootcamp/week-02-permisos_procesos_y_primer_script/2-practicas/lab-04-propietarios-y-root
   bash starter/owners.sh
   ```
   Algo como:
   ```text
   total 8
   -rw-r--r-- 1 root root 19 Nov  8 04:45 informe.txt
   -rw-r--r-- 1 root root 17 Nov  8 04:45 nomina.txt
   == alumno lee nomina.txt ==
   nómina de marzo
   == alumno lee informe.txt ==
   informe del equipo
   ```
   El script trabaja en `/tmp/lab-04`, pero tu shell sigue en la carpeta del lab: compruébalo con `pwd`. El `cd` del script cambió el directorio de **su** proceso, no el tuyo. Ahora mismo `alumno` puede leer la nómina: hay que arreglarlo.

8. **TODO 1 y TODO 2.** Abre `starter/owners.sh` en tu editor (en tu equipo: el archivo es el mismo). Que `nomina.txt` sea de `ana` (`chown ana nomina.txt`) y solo para ella (`chmod 600 nomina.txt`). Prueba con `bash starter/owners.sh`: bajo `== alumno lee nomina.txt ==` aparece `cat: nomina.txt: Permission denied`.

9. **TODO 3 y TODO 4.** `informe.txt` debe ser de `ana` y del grupo `alumno`: `chown ana:alumno informe.txt`. Luego `chmod 640 informe.txt`: dueña lee y escribe, grupo lee, los demás nada. Borra los comentarios `TODO`. Prueba:
   ```bash
   bash starter/owners.sh
   ```
   Algo como:
   ```text
   total 8
   -rw-r----- 1 ana alumno 19 Nov  8 04:45 informe.txt
   -rw------- 1 ana root   17 Nov  8 04:45 nomina.txt
   == alumno lee nomina.txt ==
   cat: nomina.txt: Permission denied
   == alumno lee informe.txt ==
   informe del equipo
   ```
   `alumno` lee el informe gracias al grupo, no por ser el dueño.

10. **Sal de root:**
    ```bash
    exit
    ```
    El contenedor se borra con `ana`, `/tmp/prueba` y `/tmp/lab-04`. En tu repositorio no queda nada de root.

## Criterios de éxito

- [ ] Explicas por qué `alumno` no puede hacer `chown` ni sobre sus propios archivos (paso 1)
- [ ] Explicas por qué `alumno` no lee `a.txt` aunque pertenece a su grupo (paso 6)
- [ ] Explicas por qué tu shell no se movió a `/tmp/lab-04` (paso 7)
- [ ] `bash starter/owners.sh`, como root, imprime lo del paso 9

## Reto extra

Ejecuta `bash starter/owners.sh` como `alumno` (en una sesión normal del laboratorio). Lee los dos mensajes de `useradd`: ¿qué archivo intenta modificar y por qué no puede? ¿Qué línea del script hace que se detenga ahí?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 03 — Cambiar permisos con chmod](../lab-03-cambiar-permisos-con-chmod/README.md) | [Lab 05 — Procesos y señales](../lab-05-procesos-y-senales/README.md) → |

[↑ Semana 02](../../README.md)
