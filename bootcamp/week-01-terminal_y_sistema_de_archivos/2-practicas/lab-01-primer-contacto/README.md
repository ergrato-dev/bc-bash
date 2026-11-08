# Lab 01 — Primer contacto con la terminal

⏱ Duración estimada: ~60 min

## Objetivo

Ejecutar tus primeros comandos, leer sus errores y escribir un script que los repita por ti.

## Contexto

- La terminal es la ventana; bash es el programa que interpreta lo que escribes ([teoría](../../1-teoria/01-terminal-shell-y-comandos.md)).
- Un comando es `comando opciones argumentos`, separados por espacios.
- Un **script** es un archivo de texto con comandos, uno por línea. `bash archivo.sh` los ejecuta en orden, como si los teclearas tú.

## Instrucciones

0. **Entra al laboratorio.** Abre la terminal de tu sistema (en Windows, la de Ubuntu de WSL2; en macOS, Terminal). Escribe `cd`, un espacio y la carpeta donde clonaste el repositorio ([docs/setup-entorno.md](../../../../docs/setup-entorno.md) explica cómo clonarlo); por ejemplo, si lo clonaste en tu home:
   ```bash
   cd ~/bc-bash
   docker compose run --rm lab
   ```
   El prompt cambia a algo como:
   ```text
   alumno@bc-bash-lab:/bc-bash$
   ```
   Ya estás dentro del laboratorio, en `/bc-bash`, la raíz del repositorio. Ve a la carpeta del lab (puedes copiar y pegar la línea):
   ```bash
   cd bootcamp/week-01-terminal_y_sistema_de_archivos/2-practicas/lab-01-primer-contacto
   ```
   (sin salida). El prompt ahora termina en `.../lab-01-primer-contacto$`.

1. **Tu primer comando.** `echo` imprime los argumentos que le das:
   ```bash
   echo Hola, bash
   ```
   ```text
   Hola, bash
   ```

2. **Comandos sin argumentos.** `whoami` imprime tu usuario, `hostname` el nombre de la máquina, `date` la fecha y hora, y `pwd` la carpeta en la que estás:
   ```bash
   whoami
   hostname
   date
   pwd
   ```
   Algo como (la fecha será la tuya; el laboratorio usa la hora UTC):
   ```text
   alumno
   bc-bash-lab
   Sun Nov  8 04:33:08 UTC 2026
   /bc-bash/bootcamp/week-01-terminal_y_sistema_de_archivos/2-practicas/lab-01-primer-contacto
   ```

3. **Opciones y argumentos.** `ls` lista el contenido de una carpeta. La opción `-l` (formato largo) da una línea con detalles por cada elemento:
   ```bash
   ls
   ls -l
   ```
   Algo como (cambian la fecha y la hora):
   ```text
   solucion  starter
   total 8
   drwxr-xr-x 2 alumno alumno 4096 Nov  8 04:29 solucion
   drwxr-xr-x 2 alumno alumno 4096 Nov  8 04:29 starter
   ```
   Ahora con un argumento, la carpeta `starter`, y dos opciones: `-l` y `-a` (mostrar también los ocultos). Juntas o separadas, es lo mismo:
   ```bash
   ls -l -a starter
   ls -la starter
   ```
   Las dos imprimen lo mismo, algo como:
   ```text
   total 12
   drwxr-xr-x 2 alumno alumno 4096 Nov  8 04:29 .
   drwxr-xr-x 4 alumno alumno 4096 Nov  8 04:29 ..
   -rw-r--r-- 1 alumno alumno  509 Nov  8 04:29 first-commands.sh
   ```
   La semana 02 explica cada columna. Por ahora: la `d` del principio marca una carpeta y el último campo es el nombre.

4. **Leer los errores.** Equivócate a propósito:
   ```bash
   lss
   LS
   ls noexiste
   ```
   ```text
   bash: lss: command not found
   bash: LS: command not found
   ls: cannot access 'noexiste': No such file or directory
   ```
   Fíjate en quién habla al principio de cada línea. En las dos primeras es `bash`: no existe ningún programa con ese nombre (y `LS` no es `ls`: mayúsculas y minúsculas cuentan). En la tercera habla `ls`: el programa existe, pero el archivo que le pediste no.

5. **Interrumpir con `Ctrl+C`.** `sleep 30` espera 30 segundos sin hacer nada; mientras tanto el prompt no vuelve:
   ```bash
   sleep 30
   ```
   Antes de que termine, pulsa `Ctrl+C`. Verás `^C` y vuelve el prompt. Así se para cualquier programa que no termina o que lanzaste por error.

6. **Limpiar la pantalla.** Escribe `clear` (o pulsa `Ctrl+L`). La pantalla queda vacía; no se ha borrado nada más.

7. **Mira el script antes de completarlo.** `cat` muestra el contenido de un archivo:
   ```bash
   cat starter/first-commands.sh
   ```
   Las líneas que empiezan por `#` son **comentarios**: bash las ignora; están para las personas. La primera línea (`#!/usr/bin/env bash`) la explica la semana 02. Ejecútalo tal cual:
   ```bash
   bash starter/first-commands.sh
   ```
   ```text
   == usuario ==
   == máquina ==
   == carpeta ==
   sin implementar
   ```

8. **TODO 1.** Abre `starter/first-commands.sh` en tu editor (la carpeta del repositorio de tu equipo es la misma que ves en `/bc-bash`: lo que guardes en el editor aparece dentro del laboratorio). Debajo del comentario `# TODO 1`, escribe en una línea nueva el comando que imprime tu usuario (`whoami`). Guarda y prueba:
   ```bash
   bash starter/first-commands.sh
   ```
   ```text
   == usuario ==
   alumno
   == máquina ==
   == carpeta ==
   sin implementar
   ```

9. **TODO 2.** Debajo de `# TODO 2`, el comando que imprime el nombre de la máquina. Prueba con el mismo comando: después de `== máquina ==` aparece `bc-bash-lab`.

10. **TODO 3.** Debajo de `# TODO 3`, el comando que imprime la carpeta actual. Borra la línea `echo "sin implementar"` y los tres comentarios `# TODO` (ya están hechos). Prueba:
    ```bash
    bash starter/first-commands.sh
    ```
    ```text
    == usuario ==
    alumno
    == máquina ==
    bc-bash-lab
    == carpeta ==
    /bc-bash/bootcamp/week-01-terminal_y_sistema_de_archivos/2-practicas/lab-01-primer-contacto
    ```

11. **Desde otra carpeta.** `cd ..` sube a la carpeta de arriba. Ejecuta el mismo script desde allí y vuelve:
    ```bash
    cd ..
    bash lab-01-primer-contacto/starter/first-commands.sh
    cd lab-01-primer-contacto
    ```
    La última línea del script ahora termina en `/2-practicas`: `pwd` imprime la carpeta **desde la que ejecutas** el script, no la carpeta donde está guardado.

12. **Salir.** Escribe `exit` (o pulsa `Ctrl+D`). Vuelves a la terminal de tu equipo. Para seguir con el lab 02, vuelve a entrar con `docker compose run --rm lab`.

## Criterios de éxito

- [ ] Sabes decir, ante un error, si lo da bash o el programa (paso 4)
- [ ] Paraste `sleep 30` con `Ctrl+C` (paso 5)
- [ ] `bash starter/first-commands.sh` imprime `alumno`, `bc-bash-lab` y la carpeta del lab (paso 10)
- [ ] Explicas por qué la última línea cambia al ejecutarlo desde `2-practicas` (paso 11)

## Reto extra

`date` acepta un formato que empieza por `+`. Averigua qué imprime `date +%Y-%m-%d` y añádelo al script bajo una cabecera `== fecha ==`. ¿Por qué no puedes poner su salida en los criterios de éxito?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Índice de labs](../README.md) | [Lab 02 — Moverse con cd, Tab e historial](../lab-02-moverse-con-cd-tab-e-historial/README.md) → |

[↑ Semana 01](../../README.md)
