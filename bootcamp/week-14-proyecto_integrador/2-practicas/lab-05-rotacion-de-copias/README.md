# Lab 05 — Rotación de copias: guardar solo las últimas

⏱ Duración estimada: ~60 min

## Objetivo

Escribir un script que deja en una carpeta solo las N copias más nuevas de una base, eligiéndolas por la fecha que llevan en el nombre, con un modo `-n` que enseña qué borraría sin borrar nada.

## Contexto

- Una copia cada noche son 365 al año. La **rotación** borra las viejas y deja las últimas N: suficientes para volver atrás unos días, pocas para que el disco no se llene.
- Si el nombre lleva la fecha de mayor a menor (`tienda-20261110-030000.dump`: año, mes, día, hora, minuto, segundo), ordenar los nombres como texto es ordenarlos por fecha. Un glob de bash ya sale ordenado por nombre.
- Este lab no necesita PostgreSQL: las copias son archivos vacíos creados con `touch`. Borrar es lo único que no tiene vuelta atrás, y se practica mejor con archivos que no importan.

## Instrucciones

0. Entra al laboratorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-14-proyecto_integrador/2-practicas/lab-05-rotacion-de-copias
   ```
   (sin salida).

1. **La fecha para un nombre.** `printf '%(formato)T'` escribe una fecha sin lanzar `date`; `-1` significa "ahora". El formato es el mismo de `date`: `%Y` año, `%m` mes, `%d` día, `%H%M%S` hora, minuto y segundo:
   ```bash
   printf '%(%Y%m%d-%H%M%S)T\n' -1
   date +%Y%m%d-%H%M%S
   ```
   ```text
   20261110-210502
   20261110-210502
   ```
   (tu fecha y tu hora). Los dos dan lo mismo; `printf` es un builtin y no lanza otro proceso.

2. **Copias de prueba.** `{01..10}` se expande a `01 02 ... 10`, con el cero delante. Crea diez copias de `tienda`, una por día, una de otra base (`otra`) y una de una base que se llama `tienda-viejo`:
   ```bash
   mkdir copias
   for d in {01..10}; do touch "copias/tienda-202611${d}-030000.dump"; done
   touch copias/tienda-viejo-20200101-000000.dump copias/otra-20261101-030000.dump
   ls copias
   ```
   ```text
   otra-20261101-030000.dump
   tienda-20261101-030000.dump
   tienda-20261102-030000.dump
   tienda-20261103-030000.dump
   tienda-20261104-030000.dump
   tienda-20261105-030000.dump
   tienda-20261106-030000.dump
   tienda-20261107-030000.dump
   tienda-20261108-030000.dump
   tienda-20261109-030000.dump
   tienda-20261110-030000.dump
   tienda-viejo-20200101-000000.dump
   ```

3. **El glob justo.** `printf '%s\n'` escribe cada argumento en una línea. Con `tienda-*.dump` se cuela la copia de `tienda-viejo`, que es de otra base y además saldría la **última**, como si fuera la más nueva:
   ```bash
   printf '%s\n' copias/tienda-*.dump | tail -n 2
   ```
   ```text
   copias/tienda-20261110-030000.dump
   copias/tienda-viejo-20200101-000000.dump
   ```
   Cada `?` encaja con un solo carácter: `????????-??????` solo encaja con la forma exacta de la fecha:
   ```bash
   printf '%s\n' copias/tienda-????????-??????.dump | tail -n 2
   ```
   ```text
   copias/tienda-20261109-030000.dump
   copias/tienda-20261110-030000.dump
   ```

4. **Por qué no la fecha del archivo.** `ls -t` ordena por fecha de **modificación**, la más reciente primero. Esa fecha la cambia cualquier cosa que toque el archivo: un `touch`, un `cp` sin `-p`, una copia a otro disco. Toca la copia del día 3, como lo haría uno de esos:
   ```bash
   touch copias/tienda-20261103-030000.dump
   ls -t copias | head -n 1
   ```
   ```text
   tienda-20261103-030000.dump
   ```
   Para `ls -t`, la del día 3 es ahora la más nueva, y una rotación por fecha de modificación se quedaría con ella y borraría la del día 10. El nombre no cambia con un `touch`.

5. **El script, tal cual.** `starter/rotate.sh` recibe la carpeta, la base y cuántas copias guardar:
   ```bash
   ./starter/rotate.sh copias tienda 3; echo $?
   ls copias | wc -l
   ```
   ```text
   0
   12
   ```
   No hace nada todavía: siguen las 12.

6. **TODO 1: la lista.** Un glob que no encaja con nada se queda tal cual, como texto. `declare -p` enseña qué hay en una variable:
   ```bash
   a=(vacia/*.dump); declare -p a
   shopt -s nullglob; a=(vacia/*.dump); declare -p a; shopt -u nullglob
   ```
   ```text
   declare -a a=([0]="vacia/*.dump")
   declare -a a=()
   ```
   Sin `nullglob`, en una carpeta vacía el script creería que hay una copia llamada `vacia/*.dump`. Abre `starter/rotate.sh` en tu editor y, debajo del TODO 1, escribe:
   ```bash
   shopt -s nullglob
   copies=("$dir/$db"-????????-??????.dump)
   ```

7. **TODO 2: cuántas sobran.** Debajo del TODO 2:
   ```bash
   excess=$((${#copies[@]} - keep))
   if ((excess <= 0)); then
     exit 0
   fi
   ```
   `${#copies[@]}` es el número de elementos del array (semana 09). Si hay 3 o menos, no sobra ninguna.

8. **TODO 3: borrar, o decir qué borraría.** `${copies[@]:0:excess}` son los `excess` primeros elementos del array: las más viejas. Debajo del TODO 3:
   ```bash
   for old in "${copies[@]:0:excess}"; do
     if [[ -n $dry_run ]]; then
       echo "borraría $old"
     else
       rm -- "$old"
       echo "borrada $old"
     fi
   done
   ```
   `--` le dice a `rm` que lo que sigue son archivos aunque empiecen por `-`. Prueba primero con `-n`, que no borra nada:
   ```bash
   ./starter/rotate.sh -n copias tienda 3; echo $?
   ```
   ```text
   borraría copias/tienda-20261101-030000.dump
   borraría copias/tienda-20261102-030000.dump
   borraría copias/tienda-20261103-030000.dump
   borraría copias/tienda-20261104-030000.dump
   borraría copias/tienda-20261105-030000.dump
   borraría copias/tienda-20261106-030000.dump
   borraría copias/tienda-20261107-030000.dump
   0
   ```
   La del día 3 está en la lista aunque la tocaste en el paso 4: lo que cuenta es su nombre. Si la lista te convence, sin `-n`:
   ```bash
   ./starter/rotate.sh copias tienda 3; echo $?
   ls copias
   ```
   ```text
   borrada copias/tienda-20261101-030000.dump
   borrada copias/tienda-20261102-030000.dump
   borrada copias/tienda-20261103-030000.dump
   borrada copias/tienda-20261104-030000.dump
   borrada copias/tienda-20261105-030000.dump
   borrada copias/tienda-20261106-030000.dump
   borrada copias/tienda-20261107-030000.dump
   0
   otra-20261101-030000.dump
   tienda-20261108-030000.dump
   tienda-20261109-030000.dump
   tienda-20261110-030000.dump
   tienda-viejo-20200101-000000.dump
   ```
   Las de `otra` y `tienda-viejo` siguen ahí.

9. **Se puede repetir.** Un script que cron lanza cada noche tiene que poder ejecutarse dos veces sin hacer daño (semana 11: idempotente). Repítelo, y prueba una base sin copias y un número que no vale:
   ```bash
   ./starter/rotate.sh copias tienda 3; echo $?
   ./starter/rotate.sh copias nadie 3; echo $?
   ./starter/rotate.sh copias tienda 0; echo $?
   ```
   ```text
   0
   0
   uso: rotate.sh [-n] <carpeta> <base> <copias>
   2
   ```

10. **Dos noches seguidas.** Simula dos copias nuevas, con la hora de ahora, rotando después de cada una. `sleep 1` para que no caigan en el mismo segundo:
    ```bash
    for i in 1 2; do
      touch "copias/tienda-$(printf '%(%Y%m%d-%H%M%S)T' -1).dump"
      ./starter/rotate.sh copias tienda 3
      sleep 1
    done
    ls copias
    ```
    ```text
    borrada copias/tienda-20261108-030000.dump
    borrada copias/tienda-20261109-030000.dump
    otra-20261101-030000.dump
    tienda-20261110-030000.dump
    tienda-20261110-210502.dump
    tienda-20261110-210503.dump
    tienda-viejo-20200101-000000.dump
    ```
    (las dos nuevas llevan tu fecha y tu hora). Siempre quedan 3 de `tienda`: la nueva entra y la más vieja sale.

11. **Recoger.**
    ```bash
    shellcheck starter/rotate.sh && echo limpio
    rm -r copias
    ```
    ```text
    limpio
    ```

## Criterios de éxito

- `copias/tienda-????????-??????.dump` no incluye la copia de `tienda-viejo` (paso 3).
- `./starter/rotate.sh -n copias tienda 3` lista 7 copias, de la del día 1 a la del día 7, y no borra ninguna (paso 8).
- Sin `-n`, quedan las copias de los días 8, 9 y 10 de `tienda`, y las de `otra` y `tienda-viejo` intactas (paso 8).
- Repetirlo no borra nada y sale con 0; con 0 copias que guardar sale con 2 (paso 9).
- Después de dos copias nuevas siguen quedando 3 de `tienda` (paso 10).

## Reto extra

Muchas empresas guardan más que "las últimas N": las 7 últimas diarias, más la primera de cada mes durante un año. Añade a `rotate.sh` que nunca borre una copia del día 01 de un mes (`tienda-AAAAMM01-...`). Pista: dentro del `for`, `[[ $old == *-??????01-??????.dump ]]` reconoce el día 01; piensa qué pasa entonces con la cuenta de `excess`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 04 — Un backup que miente](../lab-04-un-backup-que-miente/README.md) | [Lab 06 — Restaurar sin miedo](../lab-06-restaurar-sin-miedo/README.md) → |

[↑ Semana 14](../../README.md)
