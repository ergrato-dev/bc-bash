# Lab 07 — Analizar un access log

⏱ Duración estimada: ~60 min

## Objetivo

Responder preguntas reales sobre el tráfico de un servidor web (quién, qué, cuándo y con qué resultado) combinando `grep`, `cut`, `sort`, `uniq` y `head` en pipes.

## Contexto

- Un **access log** es el registro que escriben nginx o Apache: una línea por petición, con la IP del cliente, la fecha, la petición, el código de estado y el tamaño de la respuesta.
- Los **códigos de estado** HTTP dicen cómo acabó cada petición: `2xx` bien (`200`), `3xx` redirección o "no ha cambiado" (`301`, `304`), `4xx` error del cliente (`404`, no existe) y `5xx` error del servidor (`500`).
- Todo el lab usa la receta de la [teoría](../../1-teoria/03-cortar-ordenar-y-contar.md): cortar lo que quieres contar, `sort | uniq -c | sort -rn`. `starter/status-report.sh` la aplica cuatro veces, con cuatro TODOs.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-04-filtros_de_texto_y_regex/2-practicas/lab-07-analizar-un-access-log
   ```
   (sin salida).

1. **El log:**
   ```bash
   wc -l < datos/access.log
   head -2 datos/access.log
   ```
   ```text
   60
   192.0.2.44 - - [07/Nov/2026:08:03:32 +0000] "GET /admin HTTP/1.1" 304 0 "-" "python-requests/2.32.3"
   203.0.113.9 - - [07/Nov/2026:08:05:03 +0000] "GET /static/app.js HTTP/1.1" 200 4170 "-" "python-requests/2.32.3"
   ```
   60 peticiones de una mañana.

2. **¿Qué campo es cada cosa?** Cambia los espacios por saltos de línea y numera:
   ```bash
   head -1 datos/access.log | tr ' ' '\n' | cat -n
   ```
   ```text
        1	192.0.2.44
        2	-
        3	-
        4	[07/Nov/2026:08:03:32
        5	+0000]
        6	"GET
        7	/admin
        8	HTTP/1.1"
        9	304
       10	0
       11	"-"
       12	"python-requests/2.32.3"
   ```
   Separando por espacios: campo 1, la IP; 4, la fecha y la hora; 7, la ruta; 9, el código de estado; 10, el tamaño en bytes. Antes de cortar cualquier archivo, mira así una línea.

3. **¿Quién hace más peticiones?**
   ```bash
   cut -d' ' -f1 datos/access.log | sort | uniq -c | sort -rn | head -3
   ```
   ```text
        12 198.51.100.4
        10 203.0.113.9
         8 192.0.2.44
   ```
   La receta completa. Es lo que hará `bk-top-ips` en el proyecto, con un cuidado más: no todas las líneas de un log real empiezan por una IP.

4. **¿Cómo acaban las peticiones?**
   ```bash
   cut -d' ' -f9 datos/access.log | sort | uniq -c | sort -rn
   ```
   ```text
        39 200
         6 404
         6 304
         6 301
         3 500
   ```

5. **Elegir bien el patrón.** ¿Cuántas peticiones dieron `404`?
   ```bash
   grep -c ' 404 ' datos/access.log
   grep -c '" 404 ' datos/access.log
   ```
   ```text
   7
   6
   ```
   El paso 4 dice 6. ¿Cuál sobra?
   ```bash
   grep ' 404 ' datos/access.log | grep -v '" 404 '
   ```
   ```text
   203.0.113.9 - - [07/Nov/2026:08:28:53 +0000] "GET /wp-login.php HTTP/1.1" 200 404 "-" "Mozilla/5.0 (Windows NT 10.0) Chrome/130.0"
   ```
   Una respuesta `200` que pesó 404 bytes. El código va justo después de la comilla que cierra la petición: `'" 404 '` solo encaja ahí.

6. **¿A qué hora hay más tráfico?** La hora está dentro del campo 4, entre el primer y el segundo `:`:
   ```bash
   cut -d' ' -f4 datos/access.log | head -2
   cut -d' ' -f4 datos/access.log | cut -d: -f2 | sort -n | uniq -c
   ```
   ```text
   [07/Nov/2026:08:03:32
   [07/Nov/2026:08:05:03
        13 08
        11 09
        19 10
        17 11
   ```
   Un `cut` detrás de otro: el primero por espacios, el segundo por `:`. Aquí el orden que importa es el de las horas, así que no hay `sort -rn` al final.

7. **Los errores, con detalle:**
   ```bash
   grep -cE '" (4|5)[0-9]{2} ' datos/access.log
   grep '" 500 ' datos/access.log | cut -d' ' -f1,4,7
   ```
   ```text
   9
   203.0.113.9 [07/Nov/2026:08:05:18 /static/app.js
   192.0.2.44 [07/Nov/2026:10:00:33 /
   10.0.0.40 [07/Nov/2026:11:09:37 /index.html
   ```
   `(4|5)[0-9]{2}`: un 4 o un 5 y dos cifras más, todos los `4xx` y `5xx`. Para cada `500`: quién, cuándo y qué pidió. Es lo primero que necesitas para buscar el fallo en el log de la aplicación.

8. **El script, sin tocar:**
   ```bash
   bash starter/status-report.sh
   ```
   ```text
   == códigos de estado ==
   == rutas que dan 404 ==
   == peticiones por hora ==
   ```
   Solo los títulos de cada sección.

9. **TODO 1.** Abre `starter/status-report.sh` en tu editor. Sustituye la línea del `TODO 1` por un `echo` que imprima `peticiones: ` y el número de líneas de `"$log"` (lab 01). Prueba:
   ```bash
   bash starter/status-report.sh | head -1
   ```
   ```text
   peticiones: 60
   ```

10. **TODO 2.** Sustituye la línea del `TODO 2` por el pipe del paso 4, leyendo de `"$log"`. Prueba:
    ```bash
    bash starter/status-report.sh | head -7
    ```
    ```text
    peticiones: 60
    == códigos de estado ==
         39 200
          6 404
          6 304
          6 301
          3 500
    ```

11. **TODO 3.** Sustituye la línea del `TODO 3` por un pipe: el `grep` del paso 5 que solo encaja con el código, `cut` de la ruta (campo 7) y la receta `sort | uniq -c | sort -rn`. Prueba:
    ```bash
    bash starter/status-report.sh | sed -n '8,13p'
    ```
    `sed -n '8,13p'` imprime solo las líneas 8 a 13 (semana 10):
    ```text
    == rutas que dan 404 ==
          2 /static/app.js
          1 /login
          1 /favicon.ico
          1 /admin
          1 /
    ```
    `/static/app.js` da 404 dos veces: el HTML pide un archivo que no está publicado.

12. **TODO 4.** Sustituye la línea del `TODO 4` por el pipe del paso 6. Borra los comentarios `TODO`. Prueba:
    ```bash
    bash starter/status-report.sh | tail -5
    ```
    ```text
    == peticiones por hora ==
         13 08
         11 09
         19 10
         17 11
    ```

## Criterios de éxito

- [ ] Explicas cómo averiguar el número de cada campo antes de usar `cut` (paso 2)
- [ ] Explicas por qué `' 404 '` contaba 7 y `'" 404 '` cuenta 6 (paso 5)
- [ ] Explicas por qué el informe por horas termina en `sort -n | uniq -c` y no en `sort -rn` (paso 6)
- [ ] `bash starter/status-report.sh` imprime las cuatro secciones con los números de los pasos 9 a 12

## Reto extra

¿Qué programas hacen las peticiones? El *user agent* es el último campo entre comillas, pero tiene espacios dentro (`Mozilla/5.0 (X11; Linux x86_64) Firefox/131.0`), así que separar por espacios no sirve. Prueba a separar por `"`: `cut -d'"' -f6`. ¿Cuántas peticiones hizo `python-requests`, un programa y no una persona?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 06 — Buscar archivos con find](../lab-06-buscar-con-find/README.md) | [Proyecto — bk-top-ips: quién carga el servidor](../../3-proyecto/README.md) → |

[↑ Semana 04](../../README.md)
