# Lab 07 — Rendimiento: subshells y builtins

⏱ Duración estimada: ~60 min

## Objetivo

Medir con `time` cuánto tarda un script, contar con la traza cuántos procesos lanza y hacerlo cientos de veces más rápido cambiando los `$(comando)` de un bucle por expansiones y builtins.

## Contexto

- Un **builtin** es un comando que lleva bash dentro (`echo`, `printf`, `read`, `[[`): ejecutarlo no cuesta casi nada. Un comando de fuera (`sed`, `basename`, `cat`) es un programa aparte: para ejecutarlo, bash crea un proceso nuevo, carga el programa y espera a que termine. Y cada `$( )` crea además un subshell. Una vez no se nota; dentro de un bucle de miles de vueltas, sí.
- `time comando` ejecuta el comando y dice cuánto tardó. `time` es una palabra de bash, no un programa: mide también bucles y pipes enteros.
- `starter/count-ext.sh` cuenta cuántos archivos hay de cada extensión en una carpeta. Funciona, pero por cada archivo lanza `basename`, `echo` y `sed`.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-12-calidad_testing_y_depuracion/2-practicas/lab-07-rendimiento-subshells-y-builtins
   ```
   (sin salida).

1. **Una carpeta con muchos archivos.** `{1..2000}` son los números del 1 al 2000, y `${exts[i % 4]}` va eligiendo una extensión del array por turnos (`%` es el resto de la división, semana 05):
   ```bash
   mkdir muchos
   exts=(txt log csv json)
   for i in {1..2000}; do : > "muchos/archivo-$i.${exts[i % 4]}"; done
   ls muchos | wc -l
   ```
   ```text
   2000
   ```

2. **Cuánto tarda.** Abre `starter/count-ext.sh` en tu editor.
   ```bash
   time bash starter/count-ext.sh muchos
   ```
   Algo como (cambian los tiempos, según tu equipo):
   ```text
   csv 500
   json 500
   log 500
   txt 500

   real	0m8.179s
   user	0m6.863s
   sys	0m3.530s
   ```
   `real` es el tiempo de reloj, el que esperas tú. `user` y `sys`, el que pasó el procesador trabajando para el script y para el sistema. Ocho segundos para contar 2000 nombres.
   shellcheck también ve uno de los problemas, como un aviso de estilo:
   ```bash
   shellcheck starter/count-ext.sh
   ```
   ```text

   In starter/count-ext.sh line 13:
     ext="$(echo "$name" | sed 's/.*\.//')"
            ^---------------------------^ SC2001 (style): See if you can use ${variable//search/replace} instead.

   For more information:
     https://www.shellcheck.net/wiki/SC2001 -- See if you can use ${variable//se...
   ```

3. **Cuántos procesos.** En la traza (lab 05), cada `++` es un comando que corrió dentro de otro, en un subshell. Cuéntalos y mira la primera vuelta del bucle:
   ```bash
   bash -x starter/count-ext.sh muchos 2>&1 | grep -c '^++'
   bash -x starter/count-ext.sh muchos 2>&1 | sed -n '5,9p'
   ```
   ```text
   6000
   + for path in "$dir"/*
   ++ basename muchos/archivo-1.log
   + name=archivo-1.log
   ++ echo archivo-1.log
   ++ sed 's/.*\.//'
   ```
   Tres por archivo: `basename`, y `echo` y `sed`, cada uno a un lado del pipe. 6000 procesos para hacer algo que bash sabe hacer solo. Para no leer `real`, `user` y `sys` cada vez, `TIMEFORMAT` dice qué escribe `time`: `%R` es el tiempo real.
   ```bash
   TIMEFORMAT='real %R s'
   time sleep 0.2
   ```
   ```text
   real 0.202 s
   ```

4. **TODO 1: sin `basename`.** `${path##*/}` quita todo hasta la última `/` (semana 05): es lo mismo que `basename`, sin proceso. Cambia el comentario del `TODO 1` y la línea de debajo por:
   ```bash
     # Expansiones y no $(basename) ni $(echo | sed): cada $( ) con un comando de fuera
     # lanza un proceso, y con miles de archivos el script pasa el tiempo creando procesos.
     name="${path##*/}"
   ```
   Prueba:
   ```bash
   time bash starter/count-ext.sh muchos
   bash -x starter/count-ext.sh muchos 2>&1 | grep -c '^++'
   ```
   Algo como:
   ```text
   csv 500
   json 500
   log 500
   txt 500
   real 5.220 s
   4000
   ```

5. **TODO 2: sin `echo | sed`.** Es el `SC2001` del paso 2.
   `${name##*.}` quita todo hasta el último punto: la extensión. Cambia el comentario del `TODO 2` y la línea de debajo por:
   ```bash
     ext="${name##*.}"
   ```
   Prueba:
   ```bash
   time bash starter/count-ext.sh muchos
   bash -x starter/count-ext.sh muchos 2>&1 | grep -c '^++'
   shellcheck starter/count-ext.sh; echo $?
   ```
   Algo como:
   ```text
   csv 500
   json 500
   log 500
   txt 500
   real 0.019 s
   0
   0
   ```
   De 8 segundos a 0,02: unas 400 veces más rápido, con el mismo resultado. Ningún proceso dentro del bucle.

6. **Más builtins.** Leer un archivo de una línea, mil veces, de tres maneras. `$(<archivo)` es como `$(cat archivo)`, pero bash lo lee sin lanzar `cat`; `read` lo lee sin subshell. Los `{ ...; } 2>&1` juntan lo que escribe `time` con la salida, para que salga en orden:
   ```bash
   echo hola > f.txt
   { time for i in {1..1000}; do x=$(cat f.txt); done; } 2>&1
   { time for i in {1..1000}; do x=$(<f.txt); done; } 2>&1
   { time for i in {1..1000}; do IFS= read -r x < f.txt; done; } 2>&1
   echo "x=$x"
   ```
   Algo como:
   ```text
   real 1.494 s
   real 0.010 s
   real 0.015 s
   x=hola
   ```
   Lo mismo con `printf`: `printf -v x` guarda el resultado en la variable `x` en lugar de escribirlo (semana 09), y ahorra el subshell de `$( )`:
   ```bash
   { time for i in {1..1000}; do x=$(printf "%05d" "$i"); done; } 2>&1
   { time for i in {1..1000}; do printf -v x "%05d" "$i"; done; } 2>&1
   echo "x=$x"
   ```
   Algo como:
   ```text
   real 0.759 s
   real 0.004 s
   x=01000
   ```
   `printf` es un builtin: aquí lo que cuesta es el subshell de `$( )`, no el comando.

7. **Cuándo gana un comando de fuera.** Lo lento no son `sed` o `sort`: es lanzarlos una vez por línea. Un solo pipe que procesa todos los nombres de una vez lanza cuatro procesos en total:
   ```bash
   time (find muchos -type f | sed 's/.*\.//' | sort | uniq -c)
   ```
   Algo como:
   ```text
       500 csv
       500 json
       500 log
       500 txt
   real 0.004 s
   ```
   La regla: dentro de un bucle, expansiones y builtins. Para un archivo entero, un pipe de herramientas (semana 04) o `awk` (semana 10), y no un bucle de bash.

8. **Limpieza.**
   ```bash
   rm -r muchos f.txt
   ```
   (sin salida).

## Criterios de éxito

- [ ] Explicas qué miden `real`, `user` y `sys` (paso 2)
- [ ] Explicas por qué la traza del paso 3 tiene tres `++` por archivo
- [ ] `bash -x starter/count-ext.sh muchos 2>&1 | grep -c '^++'` imprime `0` (paso 5)
- [ ] Explicas por qué `x=$(printf ...)` es lento aunque `printf` sea un builtin (paso 6)
- [ ] `shellcheck starter/count-ext.sh` no imprime nada (paso 5)

## Reto extra

Haz `count-ext.sh` con un solo `awk` (semana 10) que reciba los nombres de `find muchos -type f` y cuente las extensiones con un array. Mídelo con `time` contra tu versión de bash. Después crea 50 000 archivos en lugar de 2000: ¿cuál escala mejor?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 06 — Depurar con tests](../lab-06-depurar-con-tests/README.md) | [Proyecto — Tests, lint y depuración de bashkit](../../3-proyecto/README.md) → |

[↑ Semana 12](../../README.md)
