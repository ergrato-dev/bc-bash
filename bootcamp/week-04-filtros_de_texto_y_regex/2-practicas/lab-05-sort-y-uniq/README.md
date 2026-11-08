# Lab 05 — sort y uniq: ordenar y contar

⏱ Duración estimada: ~60 min

## Objetivo

Ordenar líneas como texto o como número con `sort`, y contar las repetidas con `uniq -c` sin caer en la trampa de las líneas no seguidas.

## Contexto

- `sort` ordena como texto salvo que le digas `-n`. `uniq` solo junta repetidas **seguidas**: casi siempre va detrás de `sort` ([teoría](../../1-teoria/03-cortar-ordenar-y-contar.md)).
- `datos/visitas.txt` tiene la ciudad de cada visita a una web, en el orden en que llegaron: 30 líneas. `datos/tiempos.txt` tiene 10 tiempos de respuesta, en milisegundos.
- `starter/top-cities.sh` tiene un recuento que sale mal a propósito y dos TODOs.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-04-filtros_de_texto_y_regex/2-practicas/lab-05-sort-y-uniq
   ```
   (sin salida).

1. **Los datos y `sort`:**
   ```bash
   head -5 datos/visitas.txt
   sort datos/visitas.txt | head -12
   ```
   ```text
   Madrid
   Sevilla
   Madrid
   Bilbao
   Madrid
   Bilbao
   Bilbao
   Bilbao
   Bilbao
   Bilbao
   Madrid
   Madrid
   Madrid
   Madrid
   Madrid
   Madrid
   Madrid
   ```
   Desordenadas, las ciudades se repiten salteadas. Ordenadas, las iguales quedan juntas.

2. **Al revés y sin repetidas:**
   ```bash
   sort -r datos/visitas.txt | head -3
   sort -u datos/visitas.txt
   ```
   ```text
   Zaragoza
   Zaragoza
   Valencia
   Bilbao
   Madrid
   Sevilla
   Valencia
   Zaragoza
   ```
   `-r` (*reverse*) da la vuelta al orden. `-u` (*unique*) deja una línea de cada.

3. **Números como texto.** `tr '\n' ' '` pone todas las líneas en una para leerlas mejor; el `echo` del final añade el salto que falta:
   ```bash
   sort datos/tiempos.txt | tr '\n' ' '; echo
   sort -n datos/tiempos.txt | tr '\n' ' '; echo
   ```
   ```text
   1020 12 1840 2210 230 315 47 640 88 95 
   12 47 88 95 230 315 640 1020 1840 2210 
   ```
   Sin `-n`, `sort` compara carácter a carácter, como en un diccionario: `1020` va antes que `12` porque su segundo carácter, `0`, va antes que `2`. Con `-n` compara el número entero.

4. **Por un campo:**
   ```bash
   sort -t: -k3,3n /etc/passwd | cut -d: -f1,3 | tail -3
   sort -t: -k7 /etc/passwd | cut -d: -f1,7 | head -3
   ```
   ```text
   systemd-network:998
   alumno:1000
   nobody:65534
   alumno:/bin/bash
   root:/bin/bash
   sync:/bin/sync
   ```
   `-t:` es el separador, como `-d:` en `cut`. `-k3,3n` ordena solo por el campo 3 (el UID) y como número: los 3 UID más altos. `-k7` ordena por la shell; `alumno` y `root` empatan y se quedan en orden de la línea completa.

5. **Contar a mano.** Para comprobar luego el script, cuenta dos ciudades con `grep -c`:
   ```bash
   grep -c Madrid datos/visitas.txt
   grep -c Sevilla datos/visitas.txt
   ```
   ```text
   11
   8
   ```

6. **El script, sin tocar:**
   ```bash
   bash starter/top-cities.sh
   ```
   ```text
   == las 3 ciudades con más visitas ==
         2 Madrid
         1 Zaragoza
         1 Zaragoza
   == las 3 respuestas más lentas (ms) ==
   ```
   Madrid tiene 11 visitas, no 2, y Zaragoza sale dos veces. Mira qué hace `uniq -c` con el archivo tal cual:
   ```bash
   uniq -c datos/visitas.txt | head -6
   ```
   ```text
         1 Madrid
         1 Sevilla
         1 Madrid
         1 Bilbao
         1 Madrid
         1 Valencia
   ```
   `uniq` solo compara cada línea con la anterior. Madrid aparece suelta muchas veces y cada aparición cuenta aparte; el `2` del script es la única vez que salen dos seguidas.

7. **TODO 1.** Abre `starter/top-cities.sh` en tu editor y, en la línea de debajo del `TODO 1`, pon un `sort` del archivo delante del `uniq -c`: `sort "$visitas" | uniq -c | ...`. Prueba:
   ```bash
   bash starter/top-cities.sh
   ```
   ```text
   == las 3 ciudades con más visitas ==
        11 Madrid
         8 Sevilla
         5 Bilbao
   == las 3 respuestas más lentas (ms) ==
   ```
   Coincide con el paso 5. El primer `sort` junta las iguales; `uniq -c` las cuenta; `sort -rn` ordena por el número, de mayor a menor; `head -3` deja las 3 primeras.

8. **TODO 2.** Sustituye la línea del `TODO 2` por los 3 tiempos más altos de `"$tiempos"`: un `sort` como número y al revés, y `head -3`. Prueba:
   ```bash
   bash starter/top-cities.sh
   ```
   ```text
   == las 3 ciudades con más visitas ==
        11 Madrid
         8 Sevilla
         5 Bilbao
   == las 3 respuestas más lentas (ms) ==
   2210
   1840
   1020
   ```
   Con `sort -r` sin `-n` saldrían `95`, `88` y `640`: el orden de diccionario del paso 3, al revés.

9. **TODO 3.** Sustituye la línea del `TODO 3` por un `echo` que imprima `ciudades distintas: ` y el número, con `$(sort -u ... | wc -l)`. Borra los comentarios `TODO`. Prueba:
   ```bash
   bash starter/top-cities.sh | tail -1
   ```
   ```text
   ciudades distintas: 5
   ```

## Criterios de éxito

- [ ] Explicas por qué `sort` sin `-n` pone `1020` antes que `12` (paso 3)
- [ ] Explicas por qué `uniq -c` contaba 2 visitas de Madrid y no 11 (paso 6)
- [ ] `bash starter/top-cities.sh` imprime 11 Madrid, 8 Sevilla y 5 Bilbao, los tiempos `2210`, `1840` y `1020`, y `ciudades distintas: 5`

## Reto extra

El recuento de `uniq -c` lleva espacios delante para alinear los números (`     11 Madrid`, `      8 Sevilla`). Prueba `sort datos/visitas.txt | uniq -c | sort -r` sin `-n`: ¿por qué aquí sale bien? Después, piensa en qué caso fallaría (pista: `uniq -c` alinea a 7 caracteres).

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 04 — cut y tr: columnas y caracteres](../lab-04-cut-y-tr/README.md) | [Lab 06 — Buscar archivos con find](../lab-06-buscar-con-find/README.md) → |

[↑ Semana 04](../../README.md)
