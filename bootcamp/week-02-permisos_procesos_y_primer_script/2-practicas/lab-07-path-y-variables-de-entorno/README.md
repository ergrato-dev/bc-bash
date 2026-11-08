# Lab 07 — PATH y variables de entorno

⏱ Duración estimada: ~60 min

## Objetivo

Hacer que un script funcione por su nombre añadiendo su carpeta al `PATH`, y comprobar qué variables recibe un proceso hijo.

## Contexto

- bash busca los comandos en las carpetas de `PATH`, en orden; una variable sin `export` no llega a los hijos ([teoría](../../1-teoria/04-path-y-variables-de-entorno.md)).
- `starter/tools/backup-name` es un script ya terminado y ejecutable: propone un nombre de copia de seguridad con la fecha de hoy.
- Todo lo que cambies en esta sesión (`PATH`, variables) se pierde al salir del laboratorio. No hay forma de romper nada.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-02-permisos_procesos_y_primer_script/2-practicas/lab-07-path-y-variables-de-entorno
   ```

1. **El `PATH` del laboratorio:**
   ```bash
   echo $PATH
   ```
   ```text
   /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
   ```
   Seis carpetas separadas por `:`. bash las recorre en ese orden.

2. **Un script fuera del `PATH`:**
   ```bash
   backup-name
   ls -l starter/tools
   ./starter/tools/backup-name
   ```
   Algo como (cambia la fecha):
   ```text
   bash: backup-name: command not found
   total 4
   -rwxr-xr-x 1 alumno alumno 131 Nov  8 04:45 backup-name
   backup-2026-11-08.tar.gz
   ```
   Es ejecutable y tiene shebang, pero su carpeta no está en el `PATH`. Con la ruta (`./starter/tools/...`) sí funciona.

3. **Añade su carpeta al `PATH`, al principio:**
   ```bash
   PATH="$PWD/starter/tools:$PATH"
   echo $PATH
   backup-name
   ```
   Algo como:
   ```text
   /bc-bash/bootcamp/week-02-permisos_procesos_y_primer_script/2-practicas/lab-07-path-y-variables-de-entorno/starter/tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
   backup-2026-11-08.tar.gz
   ```
   `$PWD` se sustituye por la carpeta actual, así que añades una ruta absoluta: `backup-name` funcionará aunque te muevas a otra carpeta. Pruébalo con `cd /tmp`, `backup-name` y `cd -`.

4. **¿Dónde lo encontró?**
   ```bash
   type backup-name
   command -v backup-name ls cd
   ```
   ```text
   backup-name is hashed (/bc-bash/bootcamp/week-02-permisos_procesos_y_primer_script/2-practicas/lab-07-path-y-variables-de-entorno/starter/tools/backup-name)
   /bc-bash/bootcamp/week-02-permisos_procesos_y_primer_script/2-practicas/lab-07-path-y-variables-de-entorno/starter/tools/backup-name
   alias ls='ls --color=auto'
   cd
   ```
   `hashed` significa que bash recuerda dónde lo encontró la última vez y no vuelve a buscar. `command -v` da solo la respuesta corta: una ruta para un programa, la definición para un alias y el nombre para un *builtin*.

5. **Una variable de la shell:**
   ```bash
   color=verde
   echo $color
   bash -c 'echo "hijo: $color"'
   ```
   ```text
   verde
   hijo:
   ```
   `bash -c '...'` arranca un bash hijo que ejecuta ese texto. Las comillas simples evitan que **tu** bash sustituya `$color` antes: lo hace el hijo, y el hijo no tiene esa variable.

6. **Exportarla:**
   ```bash
   export color
   bash -c 'echo "hijo: $color"'
   printenv color
   ```
   ```text
   hijo: verde
   verde
   ```
   Ahora es una variable de entorno: los hijos reciben una copia. `printenv` es un programa, no un *builtin*, así que también es un hijo: antes del `export` no la habría visto.

7. **Solo para un comando, y borrar:**
   ```bash
   color=rojo bash -c 'echo "hijo: $color"'
   echo $color
   unset color
   echo "color: $color"
   ```
   ```text
   hijo: rojo
   verde
   color:
   ```
   `VAR=valor comando` le da la variable solo a ese comando; tu shell sigue con `verde`. `unset` la borra: una variable que no existe vale texto vacío.

8. **El script, sin tocar:**
   ```bash
   bash starter/env-check.sh
   ```
   ```text
   HOME: /home/alumno
   ultimo_script dentro del script:
   ```

9. **TODO 1.** Abre `starter/env-check.sh` en tu editor. Una línea `echo "PATH: $PATH"`, como la de `HOME`. Prueba con `bash starter/env-check.sh`: aparece tu `PATH`, con `starter/tools` al principio. El script lo recibió porque `PATH` ya estaba exportada.

10. **TODO 2.** Una línea que imprima `BK_ENTORNO: ` seguido de `$BK_ENTORNO`. Prueba de las tres formas:
    ```bash
    bash starter/env-check.sh
    BK_ENTORNO=pruebas bash starter/env-check.sh
    BK_ENTORNO=local
    bash starter/env-check.sh
    export BK_ENTORNO
    bash starter/env-check.sh
    ```
    Fíjate solo en la línea de `BK_ENTORNO` de cada ejecución:
    ```text
    BK_ENTORNO:
    BK_ENTORNO: pruebas
    BK_ENTORNO:
    BK_ENTORNO: local
    ```
    La tercera sale vacía: existe en tu shell, pero sin `export` no llega al script.

11. **TODO 3.** Guarda `env-check.sh` en la variable `ultimo_script` (sin espacios alrededor del `=`). Borra los comentarios `TODO`. Prueba y después pregunta a tu shell:
    ```bash
    bash starter/env-check.sh
    echo "ultimo_script en la shell: $ultimo_script"
    ```
    Algo como:
    ```text
    HOME: /home/alumno
    PATH: /bc-bash/bootcamp/week-02-permisos_procesos_y_primer_script/2-practicas/lab-07-path-y-variables-de-entorno/starter/tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    BK_ENTORNO: local
    ultimo_script dentro del script: env-check.sh
    ultimo_script en la shell:
    ```
    El script la creó en **su** proceso. Al terminar, desapareció con él: un hijo nunca cambia las variables de su padre.

## Criterios de éxito

- [ ] Explicas por qué `backup-name` no se encontraba aunque era ejecutable (paso 2)
- [ ] Explicas por qué la carpeta va al principio del `PATH` y con ruta absoluta (paso 3)
- [ ] Explicas la diferencia entre `color=verde` y `export color` con `bash -c` (pasos 5 y 6)
- [ ] `bash starter/env-check.sh` imprime las cuatro líneas del paso 11, y tu shell no ve `ultimo_script`

## Reto extra

Crea en `starter/tools` un script llamado `ls` que imprima `te he engañado` (con shebang y `chmod +x`). Escribe `ls`. ¿Qué se ejecuta y por qué? (`ls` es un alias de `ls --color=auto`, y el alias apunta al nombre, no a la ruta.) Borra ese archivo al terminar: es justo lo que pasaría si pusieras `.` en el `PATH` y entraras en una carpeta preparada por otra persona.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 06 — Shebang y bit de ejecución](../lab-06-shebang-y-bit-de-ejecucion/README.md) | [Proyecto — bk-info: la ficha del sistema](../../3-proyecto/README.md) → |

[↑ Semana 02](../../README.md)
