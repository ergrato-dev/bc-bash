# Lab 06 — Shebang y bit de ejecución

⏱ Duración estimada: ~60 min

## Objetivo

Convertir un script en un comando ejecutable con `chmod +x` y el shebang, y reconocer el error que da cada pieza que falta.

## Contexto

- `bash x.sh` solo necesita leer el archivo; `./x.sh` necesita el permiso `x` y un shebang en la primera línea ([teoría](../../1-teoria/03-scripts-y-shebang.md)).
- `starter/shell-info.sh` imprime qué programa lo está interpretando. Así verás el efecto de cada shebang.
- `/proc/PID/exe` es una ruta especial que apunta al programa que ejecuta el proceso `PID`; `readlink` muestra adónde apunta.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-02-permisos_procesos_y_primer_script/2-practicas/lab-06-shebang-y-bit-de-ejecucion
   ```

1. **Con `bash` delante, funciona:**
   ```bash
   bash starter/shell-info.sh
   ```
   ```text
   intérprete: /usr/bin/bash
   versión de bash: 5.2.21(1)-release
   script: starter/shell-info.sh
   ```
   `$0` (la línea `script:`) es la ruta con la que llamaste al script.

2. **Como comando, todavía no:**
   ```bash
   ./starter/shell-info.sh
   echo $?
   ```
   ```text
   bash: ./starter/shell-info.sh: Permission denied
   126
   ```
   `126` es el código de "existe, pero no se puede ejecutar". Mira por qué:
   ```bash
   ls -l starter/shell-info.sh
   ```
   Algo como:
   ```text
   -rw-r--r-- 1 alumno alumno 602 Nov  8 04:46 starter/shell-info.sh
   ```
   No hay ninguna `x`.

3. **El bit de ejecución:**
   ```bash
   chmod +x starter/shell-info.sh
   ls -l starter/shell-info.sh
   ./starter/shell-info.sh
   ```
   ```text
   -rwxr-xr-x 1 alumno alumno 602 Nov  8 04:46 starter/shell-info.sh
   intérprete: /usr/bin/bash
   versión de bash: 5.2.21(1)-release
   script: ./starter/shell-info.sh
   ```
   Funciona sin shebang porque quien lo lanza es bash, y bash, si no hay shebang, lo lee con otro bash. Desde otro programa fallaría: el shebang no es opcional.

4. **TODO 1, primer intento: `#!/bin/sh`.** Abre `starter/shell-info.sh` en tu editor y sustituye la línea del `TODO 1` por:
   ```text
   #!/bin/sh
   ```
   Guarda y ejecuta:
   ```bash
   ./starter/shell-info.sh
   ls -l /bin/sh
   ```
   ```text
   intérprete: /usr/bin/dash
   versión de bash:
   script: ./starter/shell-info.sh
   lrwxrwxrwx 1 root root 4 Mar 31  2024 /bin/sh -> dash
   ```
   Lo interpreta **dash**, no bash: `/bin/sh` es un enlace (la `l` del principio) a `dash`. dash no define `BASH_VERSION`, así que esa línea sale vacía. Un script con cosas de bash fallaría.

5. **Segundo intento: un error de tecleo.** Cambia la primera línea por:
   ```text
   #!/usr/bin/env bassh
   ```
   ```bash
   ./starter/shell-info.sh
   echo $?
   ```
   ```text
   /usr/bin/env: ‘bassh’: No such file or directory
   127
   ```
   Quien se queja es `env`: buscó `bassh` en el `PATH` y no lo encontró. `127` es el código de "comando no encontrado".

6. **El shebang correcto.** Deja la primera línea así:
   ```text
   #!/usr/bin/env bash
   ```
   ```bash
   ./starter/shell-info.sh
   ```
   ```text
   intérprete: /usr/bin/bash
   versión de bash: 5.2.21(1)-release
   script: ./starter/shell-info.sh
   ```

7. **Quien ejecuta manda.** Si pones el intérprete delante, el shebang se ignora:
   ```bash
   sh starter/shell-info.sh
   ```
   ```text
   intérprete: /usr/bin/dash
   versión de bash:
   script: starter/shell-info.sh
   ```
   Por eso los scripts de bash se ejecutan con `./script` o con `bash script`, nunca con `sh script`.

8. **Sin ruta, bash no lo encuentra:**
   ```bash
   cd starter
   shell-info.sh
   ./shell-info.sh
   cd ..
   ```
   ```text
   bash: shell-info.sh: command not found
   intérprete: /usr/bin/bash
   versión de bash: 5.2.21(1)-release
   script: ./shell-info.sh
   ```
   Aunque estés en su carpeta: sin `/` en el nombre, bash solo busca en el `PATH`. Lo arreglarás en el lab 07.

9. **TODO 2.** Bajo el comentario de `PWD`, añade una línea que imprima `directorio: ` seguido de `$PWD`, entre comillas dobles como las demás. Borra el comentario `TODO 2`. Prueba desde la carpeta del lab y desde `/tmp`:
   ```bash
   ./starter/shell-info.sh
   cd /tmp
   /bc-bash/bootcamp/week-02-permisos_procesos_y_primer_script/2-practicas/lab-06-shebang-y-bit-de-ejecucion/starter/shell-info.sh
   cd -
   ```
   ```text
   intérprete: /usr/bin/bash
   versión de bash: 5.2.21(1)-release
   script: ./starter/shell-info.sh
   directorio: /bc-bash/bootcamp/week-02-permisos_procesos_y_primer_script/2-practicas/lab-06-shebang-y-bit-de-ejecucion
   intérprete: /usr/bin/bash
   versión de bash: 5.2.21(1)-release
   script: /bc-bash/bootcamp/week-02-permisos_procesos_y_primer_script/2-practicas/lab-06-shebang-y-bit-de-ejecucion/starter/shell-info.sh
   directorio: /tmp
   /bc-bash/bootcamp/week-02-permisos_procesos_y_primer_script/2-practicas/lab-06-shebang-y-bit-de-ejecucion
   ```
   `PWD` es la carpeta **desde la que lo lanzas**, no donde está el script. Un script que use rutas relativas se comporta distinto según dónde estés: por eso los scripts de los labs comprueban primero que están en su carpeta.

## Criterios de éxito

- [ ] Explicas el error y el código de salida de los pasos 2 y 5
- [ ] Explicas por qué `#!/bin/sh` dejó vacía la versión de bash (paso 4)
- [ ] Explicas por qué `shell-info.sh` sin `./` no se encuentra aunque estés en su carpeta (paso 8)
- [ ] `./starter/shell-info.sh` imprime las cuatro líneas del paso 9

## Reto extra

`git status` desde la raíz del repositorio muestra `starter/shell-info.sh` como modificado. `git diff` enseña, además de tus líneas, `old mode 100644` / `new mode 100755`: git guarda el bit de ejecución. ¿Qué pasaría si subieras un script sin él y otra persona lo clonara?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 05 — Procesos y señales](../lab-05-procesos-y-senales/README.md) | [Lab 07 — PATH y variables de entorno](../lab-07-path-y-variables-de-entorno/README.md) → |

[↑ Semana 02](../../README.md)
