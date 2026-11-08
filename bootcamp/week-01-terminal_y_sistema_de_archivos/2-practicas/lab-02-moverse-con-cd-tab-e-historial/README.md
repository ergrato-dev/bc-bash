# Lab 02 — Moverse con cd, Tab e historial

⏱ Duración estimada: ~60 min

## Objetivo

Recorrer un árbol de carpetas con rutas relativas y absolutas, dejando que `Tab` y el historial escriban por ti.

## Contexto

- `pwd` dice dónde estás; `cd` te mueve. Una ruta que empieza por `/` es absoluta; si no, es relativa a donde estás ([teoría](../../1-teoria/02-sistema-de-archivos-y-rutas.md)).
- `..` es la carpeta de arriba, `~` tu home y `cd -` vuelve a la anterior.
- En `starter/empresa` tienes el árbol de una empresa pequeña: `ventas/2025`, `ventas/2026`, `rrhh` e `it/servidores`.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-01-terminal_y_sistema_de_archivos/2-practicas/lab-02-moverse-con-cd-tab-e-historial
   ```

1. **Mira antes de entrar.** `ls` con una ruta lista esa carpeta sin moverte:
   ```bash
   ls starter/empresa
   ```
   ```text
   it  rrhh  ventas
   ```

2. **Entra con una ruta relativa** y comprueba dónde estás:
   ```bash
   cd starter/empresa
   pwd
   ```
   ```text
   /bc-bash/bootcamp/week-01-terminal_y_sistema_de_archivos/2-practicas/lab-02-moverse-con-cd-tab-e-historial/starter/empresa
   ```
   `starter/empresa` no empieza por `/`, así que bash la buscó dentro de la carpeta del lab.

3. **Baja dos niveles de una vez:**
   ```bash
   cd ventas/2025
   ls
   ```
   ```text
   resumen.txt
   ```

4. **Sube con `..`.** Cada `..` sube un nivel: `../..` vuelve a `empresa` y desde ahí bajas a `it`:
   ```bash
   cd ../../it
   pwd
   ls
   ```
   ```text
   /bc-bash/bootcamp/week-01-terminal_y_sistema_de_archivos/2-practicas/lab-02-moverse-con-cd-tab-e-historial/starter/empresa/it
   servidores
   ```

5. **Vuelve atrás con `cd -`.** Ve a `rrhh`, sube a `empresa` y regresa a `rrhh` sin escribir la ruta:
   ```bash
   cd ../rrhh
   cd ..
   pwd
   cd -
   ```
   ```text
   /bc-bash/bootcamp/week-01-terminal_y_sistema_de_archivos/2-practicas/lab-02-moverse-con-cd-tab-e-historial/starter/empresa
   /bc-bash/bootcamp/week-01-terminal_y_sistema_de_archivos/2-practicas/lab-02-moverse-con-cd-tab-e-historial/starter/empresa/rrhh
   ```
   `cd -` imprime la carpeta a la que vuelve.

6. **Home y raíz.** `cd` sin argumentos te lleva a tu home (lo mismo que `cd ~`). Una ruta absoluta te lleva a un sitio fijo, estés donde estés:
   ```bash
   cd
   pwd
   cd /bc-bash
   pwd
   ```
   ```text
   /home/alumno
   /bc-bash
   ```

7. **`Tab` escribe por ti.** Vuelve a la carpeta del lab tecleando lo mínimo. Escribe `cd boo` y pulsa `Tab`: bash completa `bootcamp/`. Sigue: `w` + `Tab` completa `week-01-terminal_y_sistema_de_archivos/`, `2` + `Tab`, `lab-02` + `Tab`. Pulsa `Enter`. Comprueba con `pwd` que estás en la carpeta del lab.

   Ahora escribe `ls starter/empresa/` y pulsa `Tab` dos veces: como hay varias opciones, bash las lista:
   ```text
   it/     rrhh/   ventas/
   ```
   Termina la línea con `Ctrl+U` (la borra) y sigue.

8. **Historial.** Pulsa `↑` varias veces: aparecen tus comandos anteriores. Pulsa `Ctrl+C` para dejar la línea sin ejecutarla. Después:
   ```bash
   history
   ```
   Algo como (los números y comandos serán los tuyos):
   ```text
       1  cd bootcamp/week-01-terminal_y_sistema_de_archivos/2-practicas/lab-02-moverse-con-cd-tab-e-historial
       2  ls starter/empresa
       ...
      16  history
   ```
   Pulsa `Ctrl+R` y escribe `ventas`: aparece el último comando que contenía `ventas`. Pulsa `Ctrl+C` para salir de la búsqueda sin ejecutarlo.

9. **Mira el script.** `starter/routes.sh` hará el recorrido por ti. Ejecútalo antes de tocarlo:
   ```bash
   bash starter/routes.sh
   ```
   ```text
   == 1. ventas, con ruta relativa ==
   == 2. servidores, subiendo con .. ==
   == 3. raíz, con ruta absoluta ==
   == 4. home ==
   sin implementar
   ```

10. **TODO 1.** Abre `starter/routes.sh` en tu editor. Debajo del `TODO 1`, en dos líneas: `cd` a `starter/empresa/ventas` y `ls`. Añade ` || exit 1` al final del `cd`: si `cd` falla (por ejemplo, porque escribiste mal la ruta), el script se detiene en vez de listar la carpeta equivocada. Prueba:
    ```bash
    bash starter/routes.sh
    ```
    La primera cabecera va seguida de `2025  2026`.

11. **TODO 2.** Estás en `ventas`. Para llegar a `it/servidores` sube un nivel con `..` y baja: `cd ../it/servidores || exit 1`, y `ls`. Prueba: la segunda cabecera va seguida de `db01.txt  web01.txt`.

12. **TODO 3 y TODO 4.** `cd / || exit 1` y `pwd`; después `cd ~ || exit 1` y `pwd`. Borra `echo "sin implementar"` y los comentarios `TODO`. Prueba:
    ```bash
    bash starter/routes.sh
    ```
    ```text
    == 1. ventas, con ruta relativa ==
    2025  2026
    == 2. servidores, subiendo con .. ==
    db01.txt  web01.txt
    == 3. raíz, con ruta absoluta ==
    /
    == 4. home ==
    /home/alumno
    ```

13. **¿Dónde estás tú?**
    ```bash
    pwd
    ```
    Sigues en la carpeta del lab, aunque el script acabó en `/home/alumno`. `bash starter/routes.sh` arranca **otro bash**: sus `cd` cambian la carpeta de ese bash, que desaparece al terminar. Tu shell no se movió.

14. **Rompe el script a propósito.** En el TODO 1, cambia `ventas` por `ventaz`, guarda y ejecuta. Verás la primera cabecera, una línea de error que termina en `cd: starter/empresa/ventaz: No such file or directory` y nada más: el `|| exit 1` detuvo el script. Deja `ventas` como estaba.

## Criterios de éxito

- [ ] Llegaste a `it` desde `ventas/2025` con una sola ruta relativa (paso 4)
- [ ] Completaste una ruta larga con `Tab` y encontraste un comando con `Ctrl+R` (pasos 7 y 8)
- [ ] `bash starter/routes.sh` imprime las cuatro paradas del paso 12
- [ ] Explicas por qué tu terminal no se movió aunque el script hizo `cd` (paso 13)

## Reto extra

Desde `starter/empresa/it/servidores`, escribe la ruta relativa más corta a `starter/empresa/ventas/2026` y compruébala con `ls`. Después escribe la absoluta. ¿Cuál seguiría funcionando si movieras la carpeta del lab a otro sitio?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 01 — Primer contacto con la terminal](../lab-01-primer-contacto/README.md) | [Lab 03 — Listar y mirar archivos](../lab-03-listar-y-mirar-archivos/README.md) → |

[↑ Semana 01](../../README.md)
