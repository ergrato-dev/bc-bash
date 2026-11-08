# Lab 05 — mapfile

⏱ Duración estimada: ~60 min

## Objetivo

Cargar un archivo entero en un array con `mapfile -t`, recorrerlo y sacar una línea por su número, con el índice validado.

## Contexto

- `while read` procesa las líneas una a una y las olvida. Cuando hacen falta todas a la vez (cuántas hay, la tercera, la última), `mapfile -t nombre < archivo` las guarda en un **array**: una variable con varios valores numerados desde `0`.
- Esta semana basta con cuatro formas: `"${lines[@]}"` (todas), `${lines[2]}` (una), `${#lines[@]}` (cuántas) y `"${!lines[@]}"` (los números). Los arrays a fondo, en la semana 09.
- `starter/line-at.sh` imprime la línea N de un archivo; `datos/hosts.txt` es una lista de cinco servidores.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-07-bucles_read_y_archivos_seguros/2-practicas/lab-05-mapfile
   ```
   (sin salida).

1. **Cargar el archivo.** `-t` quita el salto de línea del final de cada línea (lo ves en el paso 5):
   ```bash
   mapfile -t hosts < datos/hosts.txt
   echo "${#hosts[@]}"
   ```
   ```text
   5
   ```
   `${#hosts[@]}` es el número de elementos: cinco líneas, cinco elementos.

2. **Un elemento por su número.** Los números (índices) empiezan en `0`; `-1` es el último:
   ```bash
   echo "${hosts[0]}"; echo "${hosts[4]}"; echo "${hosts[-1]}"
   ```
   ```text
   web-01.interno
   backup-01.interno
   backup-01.interno
   ```
   La línea 1 del archivo es `hosts[0]`, y la 5, `hosts[4]`.

3. **Recorrer todos.** `"${hosts[@]}"` con comillas da cada elemento como un argumento, igual que `"$@"` con los argumentos (semana 06):
   ```bash
   for h in "${hosts[@]}"; do echo "conectando a $h"; done
   ```
   ```text
   conectando a web-01.interno
   conectando a web-02.interno
   conectando a db-01.interno
   conectando a cache-01.interno
   conectando a backup-01.interno
   ```

4. **Recorrer los índices.** `"${!hosts[@]}"`, con `!`, da los números en lugar de los valores. Dentro de `[ ]`, el índice se calcula como en `$(( ))`:
   ```bash
   for i in "${!hosts[@]}"; do echo "$((i + 1)): ${hosts[i]}"; done
   ```
   ```text
   1: web-01.interno
   2: web-02.interno
   3: db-01.interno
   4: cache-01.interno
   5: backup-01.interno
   ```
   `$((i + 1))` pasa del índice, que empieza en 0, al número de línea, que empieza en 1.

5. **Sin `-t`.**
   ```bash
   mapfile sin < datos/hosts.txt; echo "[${sin[0]}]"
   ```
   ```text
   [web-01.interno
   ]
   ```
   El `]` cae en la línea siguiente: sin `-t`, cada elemento se queda con su salto de línea. Comparado con `"web-01.interno"`, ese valor no es igual.

6. **TODO 1: cargar e imprimir.** Abre `starter/line-at.sh` en tu editor y pruébalo tal cual:
   ```bash
   bash starter/line-at.sh datos/hosts.txt 2
   ```
   ```text
   sin implementar: datos/hosts.txt 2
   ```
   Borra el comentario del `TODO 1` y sustituye el `echo "sin implementar..."` por:
   ```bash
   mapfile -t lines < "$file"
   echo "${lines[n - 1]}"
   ```
   Prueba con números buenos y malos:
   ```bash
   bash starter/line-at.sh datos/hosts.txt 3; echo $?
   bash starter/line-at.sh datos/hosts.txt 0; echo $?
   bash starter/line-at.sh datos/hosts.txt 9; echo $?
   bash starter/line-at.sh datos/hosts.txt dos; echo $?
   ```
   ```text
   db-01.interno
   0
   backup-01.interno
   0
   starter/line-at.sh: line 11: lines[n - 1]: unbound variable
   1
   starter/line-at.sh: line 11: dos: unbound variable
   1
   ```
   `3` va bien. `0` es el peor: `lines[-1]` es el último, y el script responde algo que parece correcto. `9` no existe y `set -u` para el script (semana 05). Con `dos`, bash busca una variable llamada `dos` para hacer la cuenta.

7. **TODO 2: validar el número.** Un índice que llega de fuera se valida antes de usarlo: tiene que ser un número de 1 o más (la regex de la semana 06) y no pasar del total. Debajo del `mapfile`, antes del `echo`, añade:
   ```bash
   if [[ ! $n =~ ^[1-9][0-9]*$ || $n -gt ${#lines[@]} ]]; then
     echo "line-at.sh: '$n' no está entre 1 y ${#lines[@]}" >&2
     exit 1
   fi
   ```
   Si la regex no encaja, `||` ya no evalúa la segunda parte, así que `-gt` nunca recibe `dos`. Borra el comentario del `TODO 2`. Prueba:
   ```bash
   bash starter/line-at.sh datos/hosts.txt 5; echo $?
   bash starter/line-at.sh datos/hosts.txt 0; echo $?
   bash starter/line-at.sh datos/hosts.txt 6; echo $?
   bash starter/line-at.sh datos/hosts.txt dos; echo $?
   ```
   ```text
   backup-01.interno
   0
   line-at.sh: '0' no está entre 1 y 5
   1
   line-at.sh: '6' no está entre 1 y 5
   1
   line-at.sh: 'dos' no está entre 1 y 5
   1
   ```

8. **shellcheck.**
   ```bash
   shellcheck starter/line-at.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas qué cambia `-t` con el ejemplo del paso 5
- [ ] Explicas por qué `line-at.sh datos/hosts.txt 0` respondía `backup-01.interno` antes del TODO 2
- [ ] `bash starter/line-at.sh datos/hosts.txt 5` imprime `backup-01.interno`, y `0`, `6` y `dos` salen con `1` y aviso en stderr
- [ ] `shellcheck starter/line-at.sh` no imprime nada

## Reto extra

`mapfile -d '' -t files < <(find datos -type f -print0)` carga rutas separadas por el byte nulo (lab 06). Pruébalo y enseña cuántos archivos hay en `datos/` con `${#files[@]}`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 04 — read e IFS](../lab-04-read-e-ifs/README.md) | [Lab 06 — find -print0](../lab-06-find-print0/README.md) → |

[↑ Semana 07](../../README.md)
