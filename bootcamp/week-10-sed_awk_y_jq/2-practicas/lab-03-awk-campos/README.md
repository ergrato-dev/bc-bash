# Lab 03 — awk: campos y patrones

⏱ Duración estimada: ~60 min

## Objetivo

Leer un archivo por columnas con `awk`, elegir las líneas con un patrón y escribirlas alineadas con `printf`.

## Contexto

- `awk` lee un archivo línea a línea, como `sed`, pero parte cada línea en **campos**: `$1` es el primero, `$2` el segundo, y `$0` la línea entera. Por defecto los separa por espacios; `-F:` los separa por `:`.
- Un programa de awk son pares `patrón { acción }`: la acción se ejecuta en las líneas en que el patrón es verdad. Sin patrón, en todas; sin acción, escribe la línea.
- `datos/passwd` es un `/etc/passwd` de ejemplo: una cuenta por línea, siete campos separados por `:` (usuario, `x`, uid, gid, nombre completo, carpeta personal y shell). `starter/list-users.sh` tiene que enseñar solo las cuentas de personas.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-10-sed_awk_y_jq/2-practicas/lab-03-awk-campos
   ```
   (sin salida).

1. **Campos.**
   ```bash
   echo "web-01   10.0.0.5  activo" | awk '{ print $2 }'
   echo "web-01   10.0.0.5  activo" | awk '{ print NF, $NF, $0 }'
   ```
   ```text
   10.0.0.5
   3 activo web-01   10.0.0.5  activo
   ```
   Varios espacios seguidos cuentan como uno, al contrario que `cut -d' '` (semana 04). `NF` es cuántos campos tiene la línea, y `$NF`, el último. En `print`, la coma pone un espacio entre los valores. El programa va entre comillas simples: `$2` es de awk, no una variable de bash.

2. **Otro separador.**
   ```bash
   awk -F: '{ print $1, $5 }' datos/passwd | head -n 5
   awk '{ print $1 }' datos/passwd | head -n 2
   ```
   ```text
   root root
   daemon daemon
   www-data www-data
   postgres PostgreSQL administrator
   ana Ana María Ruiz
   root:x:0:0:root:/root:/bin/bash
   daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
   ```
   Con `-F:`, el nombre completo con espacios es un solo campo. Sin `-F`, `$1` es la línea entera: no tiene espacios.

3. **Patrones.**
   ```bash
   awk -F: 'NR == 5' datos/passwd
   awk -F: '$3 == 0 { print $1 }' datos/passwd
   awk -F: '$NF ~ /bash$/ { print $1 }' datos/passwd | paste -sd' '
   ```
   ```text
   ana:x:1000:1000:Ana María Ruiz:/home/ana:/bin/bash
   root
   root postgres ana
   ```
   `NR` es el número de la línea; un patrón sin acción escribe la línea. `~` comprueba una regex sobre un campo; `!~`, que no encaja.

4. **Números y textos.**
   ```bash
   echo 9 10 | awk '{ print ($1 < $2), ("9" < "10") }'
   ```
   ```text
   1 0
   ```
   Un campo que parece un número se compara como número: 9 es menor que 10 (`1` es verdad). Dos textos entre comillas se comparan letra a letra, y `"9"` va después de `"1"`. El uid es un número: `$3 >= 1000` funciona.

5. **El script, tal cual.** Abre `starter/list-users.sh` en tu editor y ejecútalo:
   ```bash
   bash starter/list-users.sh datos/passwd | head -n 3
   ```
   ```text
   root:x:0:0:root:/root:/bin/bash
   daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
   www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
   ```
   Es el paso 2: sin `-F:`, la línea entera.

6. **TODO 1: los campos.** Cambia el `awk` por:
   ```bash
   awk -F: '{ print $1, $3, $6, $NF }' "$passwd"
   ```
   Prueba:
   ```bash
   bash starter/list-users.sh datos/passwd
   ```
   ```text
   root 0 /root /bin/bash
   daemon 1 /usr/sbin /usr/sbin/nologin
   www-data 33 /var/www /usr/sbin/nologin
   postgres 112 /var/lib/postgresql /bin/bash
   ana 1000 /home/ana /bin/bash
   luis 1001 /home/luis /usr/bin/zsh
   deploy 1002 /srv/deploy /usr/sbin/nologin
   nobody 65534 /nonexistent /usr/sbin/nologin
   ```

7. **TODO 2: solo las personas.** Las cuentas de personas empiezan en el uid 1000; `nobody` (65534) es una cuenta especial. Con `nologin` como shell, la cuenta no puede abrir una sesión. Pon el patrón delante de la acción:
   ```bash
   awk -F: '$3 >= 1000 && $3 < 60000 && $NF !~ /nologin$/ { print $1, $3, $6, $NF }' "$passwd"
   ```
   `&&` es "y", como en `[[ ]]`. Prueba:
   ```bash
   bash starter/list-users.sh datos/passwd
   ```
   ```text
   ana 1000 /home/ana /bin/bash
   luis 1001 /home/luis /usr/bin/zsh
   ```

8. **TODO 3: en columnas.** `printf` de awk funciona como el de bash (semana 09), pero sus argumentos van separados por comas. `BEGIN` es un patrón especial: su acción se ejecuta una vez, antes de leer la primera línea. Cambia el `awk` por:
   ```bash
   awk -F: '
     BEGIN { printf "%-10s %6s  %-14s %s\n", "USUARIO", "UID", "CARPETA", "SHELL" }
     $3 >= 1000 && $3 < 60000 && $NF !~ /nologin$/ { printf "%-10s %6d  %-14s %s\n", $1, $3, $6, $NF }
   ' "$passwd"
   ```
   Un programa de awk puede ocupar varias líneas dentro de las comillas. Borra los tres comentarios de los TODO y explica en uno qué es el campo 3, por qué 1000 y por qué `$NF`. Prueba:
   ```bash
   bash starter/list-users.sh datos/passwd
   ```
   ```text
   USUARIO       UID  CARPETA        SHELL
   ana          1000  /home/ana      /bin/bash
   luis         1001  /home/luis     /usr/bin/zsh
   ```
   Y con el `/etc/passwd` del laboratorio, que es el que lee sin argumento:
   ```bash
   bash starter/list-users.sh
   ```
   ```text
   USUARIO       UID  CARPETA        SHELL
   alumno       1000  /home/alumno   /bin/bash
   ```

9. **shellcheck.**
   ```bash
   shellcheck starter/list-users.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas qué son `$1`, `$0`, `NF` y `$NF` (paso 1)
- [ ] Explicas por qué sin `-F:` el `$1` era la línea entera (paso 5)
- [ ] Explicas por qué `"9" < "10"` da `0` y `$3 >= 1000` funciona (paso 4)
- [ ] `bash starter/list-users.sh datos/passwd` imprime la tabla del paso 8
- [ ] `shellcheck starter/list-users.sh` no imprime nada

## Reto extra

Añade una columna `NOMBRE` con el campo 5. ¿Qué pasa con la alineación si un nombre tiene tilde? Recuerda el lab 07 de la semana 09. ¿Tiene el `printf` de `gawk` el mismo problema que el de bash?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 02 — sed: rangos, borrar e in-place](../lab-02-sed-rangos-e-in-place/README.md) | [Lab 04 — awk: BEGIN, END y arrays](../lab-04-awk-begin-end-y-arrays/README.md) → |

[↑ Semana 10](../../README.md)
