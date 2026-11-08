# Lab 03 — Huecos y slices

⏱ Duración estimada: ~60 min

## Objetivo

Sacar un trozo de un array con un slice, y recorrer un array con huecos sin perder elementos.

## Contexto

- Un **slice** es un trozo del array: `"${arr[@]:desde:cuántos}"` da `cuántos` elementos a partir de la posición `desde`. Sin `:cuántos`, hasta el final.
- `unset 'arr[1]'` borra la casilla 1, pero no mueve las demás: el array queda con un **hueco**. Por eso `${#arr[@]}` (cuántos hay) ya no es el último índice más uno.
- `starter/paginate.sh` enseña una página de `datos/tareas.txt` (10 tareas), 4 por página, como hace `less` o una web con "página 2 de 3".

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-09-arrays_y_printf/2-practicas/lab-03-huecos-y-slices
   ```
   (sin salida).

1. **Slices.**
   ```bash
   letters=(a b c d e f)
   echo "${letters[@]:2:3}"
   echo "${letters[@]:4}"
   echo "${letters[@]: -2}"
   ```
   ```text
   c d e
   e f
   e f
   ```
   Desde la posición 2 (la tercera, `c`), tres. Desde la 4, hasta el final. Con un número negativo, desde el final; el espacio antes del `-` hace falta, porque `:-` es otra cosa (el valor por defecto de la semana 05).

2. **Un hueco.**
   ```bash
   hosts=(web-01 web-02 db-01 cache-01)
   unset 'hosts[1]'
   echo "${#hosts[@]}"
   echo "${!hosts[@]}"
   ```
   ```text
   3
   0 2 3
   ```
   Quedan tres elementos, en las casillas 0, 2 y 3. Las comillas de `'hosts[1]'` evitan que bash tome `[1]` como un patrón de archivos (semana 05).

3. **El bucle que pierde uno.** Un `for` de estilo C (semana 07) supone que los índices van de `0` a `${#hosts[@]} - 1`:
   ```bash
   for ((i = 0; i < ${#hosts[@]}; i++)); do echo "$i: [${hosts[i]}]"; done
   ```
   ```text
   0: [web-01]
   1: []
   2: [db-01]
   ```
   Lee la casilla vacía y no llega a la 3: `cache-01` no sale. Con los índices que existen de verdad, sale todo:
   ```bash
   for i in "${!hosts[@]}"; do echo "$i: ${hosts[i]}"; done
   ```
   ```text
   0: web-01
   2: db-01
   3: cache-01
   ```

4. **Quitar los huecos.** Volver a crear el array con sus propios elementos los renumera:
   ```bash
   hosts=("${hosts[@]}")
   echo "${!hosts[@]}"
   ```
   ```text
   0 1 2
   ```

5. **El script, tal cual.** Abre `starter/paginate.sh` en tu editor y ejecútalo:
   ```bash
   bash starter/paginate.sh datos/tareas.txt 2
   ```
   ```text
   página 2 de 1
     renovar certificado de web-01
     revisar backups de db-01
     subir nginx a 1.26
     borrar usuarios de prueba
     rotar claves ssh
     ampliar disco de cache-01
     documentar el despliegue
     probar la restauración
     limpiar /tmp de web-02
     actualizar el inventario
   ```
   Enseña las 10 tareas, y "de 1" no es verdad. `printf '  %s\n'` repite el formato una vez por argumento: una línea por tarea.

6. **TODO 1: solo la página.** La página 1 empieza en la posición 0; la 2, en la 4; la página `p`, en `(p - 1) * 4`. Cambia el comentario del `TODO 1` y la línea de `printf` por:
   ```bash
     # Desde la posición (page - 1) * per_page, per_page elementos (menos si no quedan).
     printf '  %s\n' "${lines[@]:(page - 1) * per_page:per_page}"
   ```
   Las dos partes del slice son cuentas, como dentro de `$(( ))`. Prueba:
   ```bash
   bash starter/paginate.sh datos/tareas.txt 1
   bash starter/paginate.sh datos/tareas.txt 3
   bash starter/paginate.sh datos/tareas.txt 9
   ```
   ```text
   página 1 de 1
     renovar certificado de web-01
     revisar backups de db-01
     subir nginx a 1.26
     borrar usuarios de prueba
   página 3 de 1
     limpiar /tmp de web-02
     actualizar el inventario
   página 9 de 1
     
   ```
   La página 3 solo tiene dos: el slice no se queja si faltan. La 9 está vacía, y `printf` sin argumentos aplica el formato una vez: dos espacios y un salto de línea.

7. **TODO 2: cuántas páginas.** La división de `$(( ))` es entera y redondea hacia abajo:
   ```bash
   echo $((10 / 4)) $(((10 + 4 - 1) / 4))
   ```
   ```text
   2 3
   ```
   Sumar `per_page - 1` antes de dividir redondea hacia arriba. Cambia el comentario del `TODO 2` y `pages=1` por:
   ```bash
     # Redondeo hacia arriba: con 10 líneas, la página 3 lleva las 2 que sobran.
     pages=$(((${#lines[@]} + per_page - 1) / per_page))
   ```
   Prueba:
   ```bash
   bash starter/paginate.sh datos/tareas.txt 3
   ```
   ```text
   página 3 de 3
     limpiar /tmp de web-02
     actualizar el inventario
   ```

8. **TODO 3: una página que no existe.** Cambia el comentario del `TODO 3` por:
   ```bash
     if [[ ! $page =~ ^[0-9]+$ ]] || ((page < 1 || page > pages)); then
       echo "paginate.sh: la página va de 1 a $pages" >&2
       exit 2
     fi
   ```
   La regex va primero: `(( ))` con un texto como `dos` no compararía números. Prueba:
   ```bash
   bash starter/paginate.sh datos/tareas.txt 9; echo $?
   bash starter/paginate.sh datos/tareas.txt dos; echo $?
   bash starter/paginate.sh datos/tareas.txt 0; echo $?
   bash starter/paginate.sh datos/tareas.txt 2
   ```
   ```text
   paginate.sh: la página va de 1 a 3
   2
   paginate.sh: la página va de 1 a 3
   2
   paginate.sh: la página va de 1 a 3
   2
   página 2 de 3
     rotar claves ssh
     ampliar disco de cache-01
     documentar el despliegue
     probar la restauración
   ```

9. **shellcheck.**
   ```bash
   shellcheck starter/paginate.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas por qué el `for` de estilo C del paso 3 no imprimió `cache-01`
- [ ] Explicas por qué la página 9 imprimió una línea con dos espacios antes del TODO 3 (paso 6)
- [ ] `bash starter/paginate.sh datos/tareas.txt 2` imprime las cinco líneas del paso 8
- [ ] Una página fuera de rango o que no es un número sale con código `2` y un aviso en stderr
- [ ] `shellcheck starter/paginate.sh` no imprime nada

## Reto extra

Haz que `paginate.sh` acepte `ultima` como página. Y otra: lee el tamaño de página de una variable `PER_PAGE` si existe (`${PER_PAGE:-4}`). ¿Qué pasa con `PER_PAGE=0`, y dónde lo compruebas?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 02 — `[@]` frente a `[*]`](../lab-02-arroba-y-asterisco/README.md) | [Lab 04 — Arrays asociativos](../lab-04-arrays-asociativos/README.md) → |

[↑ Semana 09](../../README.md)
