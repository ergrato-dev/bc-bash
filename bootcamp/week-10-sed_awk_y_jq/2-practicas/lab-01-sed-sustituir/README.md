# Lab 01 — sed: sustituir

⏱ Duración estimada: ~60 min

## Objetivo

Cambiar partes de cada línea de un archivo con `sed 's/.../.../'`, grupos y regex extendidas.

## Contexto

- `sed` lee un archivo línea a línea, aplica a cada una su **programa** y la escribe en stdout. El archivo no cambia: la salida es una copia.
- El programa más usado es `s/regex/reemplazo/`: busca la regex en la línea y cambia lo que encuentra por el reemplazo. Las regex son las de `grep` (semana 04).
- `datos/access.log` tiene tres peticiones con IP de visitantes y URLs con `token=`, el código que da acceso a un informe. `starter/mask-ips.sh` tiene que escribir una copia que se pueda pegar en un ticket sin esos datos.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-10-sed_awk_y_jq/2-practicas/lab-01-sed-sustituir
   ```
   (sin salida).

1. **Una vez o todas.**
   ```bash
   echo "uno dos uno" | sed 's/uno/1/'
   echo "uno dos uno" | sed 's/uno/1/g'
   ```
   ```text
   1 dos uno
   1 dos 1
   ```
   Sin nada detrás, `s` cambia la primera vez que encuentra la regex en cada línea. La `g` del final (*global*) las cambia todas.

2. **El punto es cualquier carácter.**
   ```bash
   echo 10.0.0.5 | sed 's/./X/'
   echo 10.0.0.5 | sed 's/\./-/g'
   ```
   ```text
   X0.0.0.5
   10-0-0-5
   ```
   En una regex, `.` es "un carácter cualquiera": la primera vez encaja con el `1`. `\.` es un punto de verdad.

3. **Grupos con `-E`.**
   ```bash
   echo "garcía ana" | sed -E 's/([^ ]+) (.+)/\2 \1/'
   echo "garcía ana" | sed 's/\([^ ]*\) \(.*\)/\2 \1/'
   ```
   ```text
   ana garcía
   ana garcía
   ```
   Lo que va entre paréntesis es un **grupo**, y en el reemplazo, `\1` es lo que encajó en el primero y `\2` en el segundo, como `BASH_REMATCH` (semana 06). Con `-E` (regex extendidas, como `grep -E`), `(`, `+` y `|` funcionan tal cual; sin `-E`, hay que escribir `\(` y `\)`. En este bootcamp, siempre `-E`.

4. **Otro separador y `&`.**
   ```bash
   echo /var/log/nginx | sed 's|/var/log|/srv/logs|'
   echo "puerto 8080" | sed -E 's/[0-9]+/[&]/'
   ```
   ```text
   /srv/logs/nginx
   puerto [8080]
   ```
   El carácter que va detrás de la `s` es el separador: con rutas, `|` evita escribir `\/` en cada barra. En el reemplazo, `&` es todo lo que encajó.

5. **Solo las líneas que encajan.**
   ```bash
   sed -n '/token=/p' datos/access.log | wc -l
   ```
   ```text
   2
   ```
   `-n` hace que `sed` no escriba nada por su cuenta, y `p` escribe la línea. `/regex/p` hace lo mismo que `grep`: lo usarás con `s///p` en el proyecto.

6. **El script, tal cual.** Abre `starter/mask-ips.sh` en tu editor y ejecútalo:
   ```bash
   bash starter/mask-ips.sh datos/access.log
   ```
   ```text
   192.168.1.27 - - [08/Nov/2026:09:00:01 +0000] "GET /informe?id=7&token=a8f3e2 HTTP/1.1" 200 931 "-" "curl/8.5.0"
   10.20.30.40 - - [08/Nov/2026:09:00:05 +0000] "GET /descarga?token=77c1b0&formato=pdf HTTP/1.1" 200 20480 "http://10.20.30.1/panel" "Mozilla/5.0"
   172.16.0.9 - - [08/Nov/2026:09:01:12 +0000] "GET /estado HTTP/1.1" 200 15 "-" "kube-probe/1.31"
   ```
   El `cat` lo escribe tal cual: IP completas y tokens.

7. **TODO 1: la IP sin su último número.** Cambia el `cat "$log"` por:
   ```bash
   sed -E \
     -e 's/^([0-9]+\.[0-9]+\.[0-9]+)\.[0-9]+ /\1.0 /' \
     "$log"
   ```
   `-e` da un programa a `sed`; con varios, los aplica en orden a cada línea. La `\` del final de línea sigue el comando en la siguiente. El grupo guarda los tres primeros números con sus puntos; el cuarto se cambia por `0`. Prueba:
   ```bash
   bash starter/mask-ips.sh datos/access.log
   ```
   ```text
   192.168.1.0 - - [08/Nov/2026:09:00:01 +0000] "GET /informe?id=7&token=a8f3e2 HTTP/1.1" 200 931 "-" "curl/8.5.0"
   10.20.30.0 - - [08/Nov/2026:09:00:05 +0000] "GET /descarga?token=77c1b0&formato=pdf HTTP/1.1" 200 20480 "http://10.20.30.1/panel" "Mozilla/5.0"
   172.16.0.0 - - [08/Nov/2026:09:01:12 +0000] "GET /estado HTTP/1.1" 200 15 "-" "kube-probe/1.31"
   ```
   La IP del *referer* de la segunda línea, `10.20.30.1`, no cambia: `^` ata la regex al principio, y esa es la de un panel interno, no la del visitante.

8. **TODO 2: los tokens.** Añade otro `-e` debajo del primero:
   ```bash
     -e 's/([?&]token=)[^& "]+/\1XXX/g' \
   ```
   `[?&]` es `?` o `&`, lo que va delante de un parámetro en una URL; `[^& "]+`, el valor, hasta el siguiente parámetro, un espacio o unas comillas. Borra los dos comentarios de los TODO y deja uno que diga por qué `^` y por qué `[^& "]+`. Prueba:
   ```bash
   bash starter/mask-ips.sh datos/access.log | head -n 2
   ```
   ```text
   192.168.1.0 - - [08/Nov/2026:09:00:01 +0000] "GET /informe?id=7&token=XXX HTTP/1.1" 200 931 "-" "curl/8.5.0"
   10.20.30.0 - - [08/Nov/2026:09:00:05 +0000] "GET /descarga?token=XXX&formato=pdf HTTP/1.1" 200 20480 "http://10.20.30.1/panel" "Mozilla/5.0"
   ```

9. **shellcheck.**
   ```bash
   shellcheck starter/mask-ips.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas qué cambia la `g` del final de `s///` (paso 1)
- [ ] Explicas qué son `\1` y `&` en un reemplazo (pasos 3 y 4)
- [ ] Explicas por qué la IP del *referer* no cambia (paso 7)
- [ ] `bash starter/mask-ips.sh datos/access.log` imprime las IP terminadas en `.0` y `token=XXX` (paso 8)
- [ ] `shellcheck starter/mask-ips.sh` no imprime nada

## Reto extra

Las IP v6 (`2001:db8::1`) no tienen puntos. Añade un `-e` que deje solo sus dos primeros bloques, `2001:db8::`. ¿Qué tiene que pasar para que no toque una IP v4?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Índice de labs](../README.md) | [Lab 02 — sed: rangos, borrar e in-place](../lab-02-sed-rangos-e-in-place/README.md) → |

[↑ Semana 10](../../README.md)
