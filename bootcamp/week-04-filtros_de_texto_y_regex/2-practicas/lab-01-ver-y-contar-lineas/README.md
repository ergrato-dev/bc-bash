# Lab 01 — Ver y contar líneas

⏱ Duración estimada: ~60 min

## Objetivo

Leer un log por partes con `less`, `head` y `tail`, seguirlo en vivo con `tail -f` y contar sus líneas con `wc`.

## Contexto

- Un log es un archivo de texto al que un programa añade una línea por cada cosa que pasa. `datos/app.log` es el de una aplicación web imaginaria durante una mañana: 25 líneas con fecha, hora, nivel (`INFO`, `WARN`, `ERROR`), componente y mensaje.
- `head`, `tail` y `wc` son filtros: leen de un archivo o de stdin y escriben por stdout ([teoría](../../1-teoria/01-filtros-de-texto.md)).
- `starter/log-summary.sh` hace un resumen del log con cuatro TODOs. No toques `datos/`: los demás pasos cuentan con que esté igual.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-04-filtros_de_texto_y_regex/2-practicas/lab-01-ver-y-contar-lineas
   ```
   (sin salida).

1. **Un visor: `less`.**
   ```bash
   less datos/app.log
   ```
   El log ocupa la pantalla. Muévete con las flechas o con la barra espaciadora (una página). Escribe `/ERROR` y pulsa Enter: salta a la primera línea con `ERROR`; `n` salta a la siguiente. Sal con `q`. Al salir, la terminal vuelve a estar como antes, sin salida.

2. **El principio y el final:**
   ```bash
   head -3 datos/app.log
   tail -2 datos/app.log
   ```
   ```text
   2026-11-07 08:00:01 INFO web: servicio arrancado en el puerto 8080
   2026-11-07 08:00:02 INFO db: conexión abierta con postgres
   2026-11-07 08:03:17 INFO web: GET /index.html 200
   2026-11-07 10:33:48 WARN web: respuesta lenta en /api/users (2210 ms)
   2026-11-07 10:45:00 INFO web: servicio detenido
   ```
   `-3` es la forma corta de `-n 3`. Sin número, los dos enseñan 10 líneas. En un log, lo último es lo más reciente: `tail` es lo primero que mirarás cuando algo falle.

3. **Desde una línea hasta el final:**
   ```bash
   tail -n +23 datos/app.log
   ```
   ```text
   2026-11-07 10:20:03 INFO web: GET /login 200
   2026-11-07 10:33:48 WARN web: respuesta lenta en /api/users (2210 ms)
   2026-11-07 10:45:00 INFO web: servicio detenido
   ```
   Con `+`, el número ya no es "cuántas" sino "desde cuál". Lo usarás para saltarte la cabecera de un CSV con `tail -n +2`.

4. **Un trozo del medio.** `cat -n` numera las líneas; así compruebas qué rango sale:
   ```bash
   cat -n datos/app.log | head -10 | tail -3
   head -10 datos/app.log | tail -3
   ```
   ```text
        8	2026-11-07 08:20:44 WARN disk: Disco al 85% en /var
        9	2026-11-07 08:31:09 INFO web: GET /api/users 200
       10	2026-11-07 08:45:23 ERROR web: POST /api/orders 500
   2026-11-07 08:20:44 WARN disk: Disco al 85% en /var
   2026-11-07 08:31:09 INFO web: GET /api/users 200
   2026-11-07 08:45:23 ERROR web: POST /api/orders 500
   ```
   Las líneas 8 a 10: de las 10 primeras, las 3 últimas.

5. **Contar:**
   ```bash
   wc datos/app.log
   wc -l datos/app.log
   wc -l < datos/app.log
   head -1 datos/app.log | wc -w
   ```
   ```text
     25  203 1412 datos/app.log
   25 datos/app.log
   25
   10
   ```
   Sin opciones: líneas, palabras y bytes. Con `<`, `wc` lee de stdin, no conoce el nombre del archivo y solo imprime el número. La primera línea tiene 10 palabras: trozos separados por espacios, como `08:00:01` o `web:`.

6. **Seguir un log en vivo.** Escribe estas tres líneas una a una. La segunda deja un proceso en segundo plano (`&`, semana 02) que añadirá una línea al log dentro de 2 segundos:
   ```bash
   mkdir zona; echo primera > zona/vivo.log
   (sleep 2; echo "llega más tarde" >> zona/vivo.log) &
   tail -f zona/vivo.log
   ```
   Algo como (cambia el número del proceso):
   ```text
   [1] 17
   primera
   llega más tarde
   ```
   `tail -f` no termina: enseña lo que hay y se queda esperando. A los 2 segundos aparece la línea nueva sin que hagas nada. Pulsa `Ctrl+C` para salir. Así se mira el log de un servidor mientras reproduces un fallo.

7. **El script, sin tocar:**
   ```bash
   bash starter/log-summary.sh
   ls
   ```
   ```text
   datos
   solucion
   starter
   zona
   ```
   El script no imprime nada: solo crea `zona/`, si no existía.

8. **TODO 1.** Abre `starter/log-summary.sh` en tu editor. Sustituye la línea del `TODO 1` por un `echo` que imprima `líneas: ` seguido del número, con `$(wc -l < "$log")` (`$( )` cambia el comando por lo que imprime, semana 02). Prueba:
   ```bash
   bash starter/log-summary.sh
   ```
   ```text
   líneas: 25
   ```
   Con `wc -l "$log"` saldría `líneas: 25 datos/app.log`.

9. **TODOs 2 y 3.** Igual, con `head -1 "$log"` para `primera: ` y `tail -1 "$log"` para `última: `. Prueba:
   ```bash
   bash starter/log-summary.sh
   ```
   ```text
   líneas: 25
   primera: 2026-11-07 08:00:01 INFO web: servicio arrancado en el puerto 8080
   última: 2026-11-07 10:45:00 INFO web: servicio detenido
   ```

10. **TODO 4.** Sustituye la línea del `TODO 4` por un `tail` de las 5 últimas líneas redirigido con `>` a `zona/ultimas.txt`. Borra los comentarios `TODO`. Prueba:
    ```bash
    bash starter/log-summary.sh > /dev/null
    cat zona/ultimas.txt
    ```
    ```text
    2026-11-07 10:01:00 INFO web: GET /api/users 200
    2026-11-07 10:14:27 ERROR db: autenticación fallida para el usuario report
    2026-11-07 10:20:03 INFO web: GET /login 200
    2026-11-07 10:33:48 WARN web: respuesta lenta en /api/users (2210 ms)
    2026-11-07 10:45:00 INFO web: servicio detenido
    ```
    Con `>`, cada ejecución deja las 5 últimas del momento; con `>>` se irían acumulando.

## Criterios de éxito

- [ ] Explicas la diferencia entre `tail -n 3` y `tail -n +3` (paso 3)
- [ ] Explicas por qué `wc -l < datos/app.log` imprime solo el número (paso 5)
- [ ] Sigues un log con `tail -f` y sales con `Ctrl+C` (paso 6)
- [ ] `bash starter/log-summary.sh` imprime las tres líneas del paso 9 y deja 5 líneas en `zona/ultimas.txt`

## Reto extra

`wc -l` cuenta saltos de línea, no líneas. Comprueba qué pasa con un archivo cuya última línea no termina en salto (`printf` no añade uno si no se lo pides):

```bash
printf 'uno\ndos' > zona/sin-salto.txt
wc -l < zona/sin-salto.txt
```

¿Qué número sale y por qué? ¿Qué ves al hacer `cat zona/sin-salto.txt`?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Índice de labs](../README.md) | [Lab 02 — grep: elegir líneas](../lab-02-grep/README.md) → |

[↑ Semana 04](../../README.md)
