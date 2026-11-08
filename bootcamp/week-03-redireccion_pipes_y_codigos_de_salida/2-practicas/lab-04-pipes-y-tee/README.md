# Lab 04 — Pipes y tee

⏱ Duración estimada: ~60 min

## Objetivo

Encadenar comandos con `|` para que cada uno trabaje sobre la salida del anterior, y guardar una copia por el camino con `tee`.

## Contexto

- `a | b` conecta el stdout de `a` con el stdin de `b`. Los dos arrancan a la vez, y stderr no pasa por el pipe ([teoría](../../1-teoria/02-pipes-tee-y-here-docs.md)).
- `getent passwd` imprime una línea por cuenta del sistema, igual que `/etc/passwd` (semana 02). `wc -l` cuenta líneas, `sort` las ordena y `head -3` deja pasar solo las 3 primeras. Esta semana solo los usas como piezas; en la semana 04 los verás a fondo.
- `starter/users-report.sh` es un informe de cuentas con tres TODOs.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-03-redireccion_pipes_y_codigos_de_salida/2-practicas/lab-04-pipes-y-tee
   mkdir zona
   ```
   (sin salida).

1. **Un pipe:**
   ```bash
   getent passwd | head -3
   getent passwd | wc -l
   ```
   ```text
   root:x:0:0:root:/root:/bin/bash
   daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
   bin:x:2:2:bin:/bin:/usr/sbin/nologin
   20
   ```
   `getent` no sabe que su salida va a otro programa, ni `wc` de dónde viene lo que lee. Ninguno necesita un archivo intermedio.

2. **Varios pipes:**
   ```bash
   getent passwd | sort | head -3
   ```
   ```text
   _apt:x:42:65534::/nonexistent:/usr/sbin/nologin
   alumno:x:1000:1000:Alumno bc-bash:/home/alumno:/bin/bash
   backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
   ```
   Se lee de izquierda a derecha: las cuentas, ordenadas, las 3 primeras.

3. **stderr se salta el pipe:**
   ```bash
   ls /etc/hostname /no-existe | wc -l
   ls /etc/hostname /no-existe |& wc -l
   ```
   ```text
   ls: cannot access '/no-existe': No such file or directory
   1
   2
   ```
   El error salió por pantalla y `wc` solo contó la línea buena. `|&` es el atajo de bash para `2>&1 |`: mete también stderr en el pipe (lab 03).

4. **El código de un pipe es el del último comando:**
   ```bash
   ls /no-existe | wc -l
   echo $?
   ```
   ```text
   ls: cannot access '/no-existe': No such file or directory
   0
   0
   ```
   `ls` falló, pero `wc` contó 0 líneas sin problema y el pipe entero sale con `0`. En el lab 07 verás que un script puede seguir como si nada por esto, y cómo evitarlo.

5. **`tee`: una copia por el camino.**
   ```bash
   getent passwd | tee zona/cuentas.txt | wc -l
   wc -l < zona/cuentas.txt
   ```
   ```text
   20
   20
   ```
   `tee` es como una T de fontanería: lo que recibe lo escribe en el archivo **y** lo deja seguir por su stdout. `wc` contó lo mismo que quedó guardado.

6. **`tee -a` y tirar la copia de pantalla:**
   ```bash
   echo primera | tee -a zona/h.txt
   echo segunda | tee -a zona/h.txt > /dev/null
   cat zona/h.txt
   ```
   ```text
   primera
   primera
   segunda
   ```
   `-a` añade al final, como `>>`. Sin `-a`, `tee` vacía el archivo, como `>`. Con `> /dev/null` solo queda la copia en el archivo.

7. **El script, sin tocar:**
   ```bash
   bash starter/users-report.sh
   ```
   (sin salida). Solo crea `zona/`.

8. **TODO 1.** Abre `starter/users-report.sh` en tu editor. Bajo el `TODO 1`, un pipe de tres piezas: `getent passwd`, `tee zona/cuentas.txt` y `wc -l`. Prueba:
   ```bash
   bash starter/users-report.sh
   ```
   ```text
   20
   ```

9. **TODO 2.** Bajo el `TODO 2`: `sort` sobre `zona/cuentas.txt` y su salida, por un pipe, a `head -3`. Prueba:
   ```bash
   bash starter/users-report.sh
   ```
   ```text
   20
   _apt:x:42:65534::/nonexistent:/usr/sbin/nologin
   alumno:x:1000:1000:Alumno bc-bash:/home/alumno:/bin/bash
   backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
   ```

10. **TODO 3.** Bajo el `TODO 3`: `date '+%F'` por un pipe a `tee -a zona/historial.txt`, con la salida de `tee` a `/dev/null`. Borra los comentarios `TODO`. Prueba dos veces:
    ```bash
    bash starter/users-report.sh > /dev/null
    bash starter/users-report.sh > /dev/null
    cat zona/historial.txt
    ```
    Algo como (cambia la fecha):
    ```text
    2026-11-08
    2026-11-08
    ```
    Una línea por ejecución, y ninguna fecha por pantalla.

## Criterios de éxito

- [ ] Explicas por qué `wc -l` contó 1 y no 2 en el paso 3
- [ ] Explicas por qué el pipe del paso 4 sale con `0` aunque `ls` falló
- [ ] Explicas qué hace `tee` y la diferencia entre `tee` y `tee -a`
- [ ] `bash starter/users-report.sh` imprime el total y 3 cuentas, y cada ejecución suma una fecha a `zona/historial.txt`

## Reto extra

`sort zona/cuentas.txt | head -3` funciona, y `cat zona/cuentas.txt | sort | head -3` también. ¿Qué hace de más el segundo? Busca en el [wiki de ShellCheck](https://www.shellcheck.net/wiki/SC2002) el aviso que le daría.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 03 — El orden de las redirecciones](../lab-03-orden-de-las-redirecciones/README.md) | [Lab 05 — Here-docs y here-strings](../lab-05-here-docs-y-here-strings/README.md) → |

[↑ Semana 03](../../README.md)
