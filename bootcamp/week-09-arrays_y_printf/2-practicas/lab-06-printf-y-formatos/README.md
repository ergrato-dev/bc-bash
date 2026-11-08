# Lab 06 — printf y formatos

⏱ Duración estimada: ~60 min

## Objetivo

Escribir una tabla alineada con `printf`: anchos fijos y variables, números, porcentajes y una barra hecha con `printf -v`.

## Contexto

- `printf formato argumentos...` escribe el **formato** cambiando cada `%` por el argumento que le toca: `%s` un texto, `%d` un número entero. No añade salto de línea: se pone con `\n`.
- Un número entre el `%` y la letra es el **ancho**: `%6s` rellena con espacios por la izquierda hasta 6 caracteres; `%-6s`, por la derecha. Así se alinean las columnas.
- `datos/discos.txt` tiene una línea por disco, `montaje total_gb usado_gb`. `starter/disk-table.sh` la convierte en una tabla con el porcentaje de uso y una barra.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-09-arrays_y_printf/2-practicas/lab-06-printf-y-formatos
   ```
   (sin salida).

1. **El formato se repite.**
   ```bash
   printf '%s y %s\n' uno dos tres cuatro cinco
   ```
   ```text
   uno y dos
   tres y cuatro
   cinco y 
   ```
   Si sobran argumentos, `printf` vuelve a empezar el formato. Si faltan, los `%s` que quedan valen vacío. Por eso `printf '%s\n' "${arr[@]}"` escribe un elemento por línea.

2. **Anchos.**
   ```bash
   printf '[%6s] [%-6s]\n' web web
   printf '[%*s]\n' 8 web
   ```
   ```text
   [   web] [web   ]
   [     web]
   ```
   Con `*`, el ancho llega como argumento, delante del texto: sirve cuando el script lo calcula.

3. **Números.**
   ```bash
   printf '%d %05d %.1f %d%%\n' 42 42 3.14159 90
   printf '%d\n' 12abc; echo $?
   ```
   ```text
   42 00042 3.1 90%
   bash: printf: 12abc: invalid number
   12
   1
   ```
   `%05d` rellena con ceros; `%.1f`, un decimal; `%%` es un `%` de verdad. Con algo que no es un número, `%d` avisa, escribe lo que pudo leer y sale con `1`.

4. **`printf -v` y el formato fijo.**
   ```bash
   printf -v line '%-5s|' a bb ccc
   echo "[$line]"
   name='100% listo'
   printf "$name\n"
   printf '%s\n' "$name"
   ```
   ```text
   [a    |bb   |ccc  |]
   100 0sto
   100% listo
   ```
   `-v line` guarda el resultado en la variable `line` en lugar de escribirlo, sin `$( )` ni subshell. Un dato dentro del formato es peligroso: `printf` leyó `% l` del texto como una instrucción. El formato, siempre fijo; los datos, siempre como argumentos.

5. **El script, tal cual.** Abre `starter/disk-table.sh` en tu editor y ejecútalo:
   ```bash
   cat datos/discos.txt
   bash starter/disk-table.sh datos/discos.txt
   ```
   ```text
   / 59 21
   /var 120 101
   /home 250 40
   /var/lib/docker 500 470
   / 59G 21G 35% 
   /var 120G 101G 84% 
   /home 250G 40G 16% 
   /var/lib/docker 500G 470G 94% 
   ```
   El bucle ya guarda cada columna en un array y calcula `width`, el largo del montaje más largo. Falta alinear.

6. **TODO 1: la cabecera.** Cambia el comentario del `TODO 1` por:
   ```bash
     # Un formato para la cabecera y otro para las filas, con los mismos anchos.
     printf '%-*s %6s %6s %4s\n' "$width" MONTAJE TOTAL USADO USO
   ```
   Prueba:
   ```bash
   bash starter/disk-table.sh datos/discos.txt
   ```
   ```text
   MONTAJE          TOTAL  USADO  USO
   / 59G 21G 35% 
   /var 120G 101G 84% 
   /home 250G 40G 16% 
   /var/lib/docker 500G 470G 94% 
   ```

7. **TODO 2: las filas.** Cada columna de la fila tiene que medir lo mismo que su cabecera: `%5sG` son 6 caracteres, como `%6s`; `%3d%%`, 4, como `%4s`. Cambia el comentario del `TODO 2` y el `echo` de debajo por:
   ```bash
       printf '%-*s %5sG %5sG %3d%% %s\n' "$width" "${mounts[i]}" "${sizes[i]}" "${useds[i]}" "$pct" "${bar// /#}"
   ```
   `${bar// /#}` cambia cada espacio de `bar` por un `#` (semana 05). Prueba:
   ```bash
   bash starter/disk-table.sh datos/discos.txt
   ```
   ```text
   MONTAJE          TOTAL  USADO  USO
   /                  59G    21G  35% 
   /var              120G   101G  84% 
   /home             250G    40G  16% 
   /var/lib/docker   500G   470G  94% 
   ```

8. **TODO 3: la barra.** Una barra de `#` es un texto de N espacios con cada espacio cambiado:
   ```bash
   printf -v bar '%*s' 4 ''
   echo "[$bar] [${bar// /#}]"
   ```
   ```text
   [    ] [####]
   ```
   Cambia el comentario del `TODO 3` y `bar=""` por:
   ```bash
       # %*s con un texto vacío da tantos espacios como diga el ancho; luego cada espacio, un #.
       printf -v bar '%*s' $((pct / 10)) ''
   ```
   Prueba:
   ```bash
   bash starter/disk-table.sh datos/discos.txt
   ```
   ```text
   MONTAJE          TOTAL  USADO  USO
   /                  59G    21G  35% ###
   /var              120G   101G  84% ########
   /home             250G    40G  16% #
   /var/lib/docker   500G   470G  94% #########
   ```

9. **shellcheck.**
   ```bash
   shellcheck starter/disk-table.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas qué hace `printf` cuando le sobran argumentos (paso 1)
- [ ] Explicas por qué `printf "$name\n"` escribió `100 0sto` (paso 4)
- [ ] `bash starter/disk-table.sh datos/discos.txt` imprime la tabla del paso 8, con las columnas alineadas
- [ ] `shellcheck starter/disk-table.sh` no imprime nada

## Reto extra

Pon en amarillo las filas de más del 80 % y en rojo las de más del 90 %. Un color de terminal es un texto especial: `printf '\e[31m%s\e[0m\n' rojo`. ¿Sigue alineada la tabla si el color va dentro de un `%-*s`? ¿Por qué?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 05 — Contar por clave](../lab-05-contar-por-clave/README.md) | [Lab 07 — Tablas rotas](../lab-07-tablas-rotas/README.md) → |

[↑ Semana 09](../../README.md)
