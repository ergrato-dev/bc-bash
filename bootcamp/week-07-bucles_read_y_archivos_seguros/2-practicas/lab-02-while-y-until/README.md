# Lab 02 — while y until

⏱ Duración estimada: ~60 min

## Objetivo

Repetir un bloque mientras se cumpla una condición, o hasta que se cumpla, sin quedarse esperando para siempre.

## Contexto

- `while condición; do ... done` repite mientras la condición sale con `0`. `until` es al revés: repite mientras sale con algo distinto de `0`, es decir, **hasta** que se cumpla.
- La condición es un comando, como en un `if` (semana 06): `[[ $n -gt 0 ]]`, `grep -q`, `ping -c1`...
- `starter/wait-for-file.sh` espera a que aparezca un archivo: lo que hace un script que necesita lo que deja otro (un volcado, un archivo "listo"). Hoy no espera nada.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-07-bucles_read_y_archivos_seguros/2-practicas/lab-02-while-y-until
   mkdir -p zona
   ```
   (sin salida).

1. **Una cuenta atrás con `while`.** El bloque cambia `n` en cada vuelta; si no lo hiciera, la condición se cumpliría siempre:
   ```bash
   n=3; while [[ $n -gt 0 ]]; do echo "quedan $n"; n=$((n - 1)); done; echo "fin, n vale $n"
   ```
   ```text
   quedan 3
   quedan 2
   quedan 1
   fin, n vale 0
   ```
   Con `n` en `0`, `[[ 0 -gt 0 ]]` sale con `1` y el bucle termina.

2. **La misma cuenta con `until`.** La condición se escribe al revés: "hasta que `n` sea `0`".
   ```bash
   n=3; until [[ $n -eq 0 ]]; do echo "quedan $n"; n=$((n - 1)); done
   ```
   ```text
   quedan 3
   quedan 2
   quedan 1
   ```
   `until X` es lo mismo que `while ! X`. Usa el que se lea mejor: "hasta que exista el archivo" se lee mejor que "mientras no exista".

3. **Un bucle sin fin.** `true` es un comando que no hace nada y sale con `0`; `false`, con `1`:
   ```bash
   true; echo $?; false; echo $?
   ```
   ```text
   0
   1
   ```
   `while true` no termina nunca por sí solo. Pruébalo; `sleep 1` espera un segundo entre vuelta y vuelta. Páralo con `Ctrl+C` tras tres o cuatro líneas:
   ```bash
   while true; do echo "otra vuelta"; sleep 1; done
   ```
   Algo como (cambia cuántas líneas salen):
   ```text
   otra vuelta
   otra vuelta
   otra vuelta
   ^C
   ```
   Un bucle así necesita una salida desde dentro: un `break` (lab 03) o un `exit`.

4. **El script, tal cual.** Abre `starter/wait-for-file.sh` en tu editor y léelo. Ejecútalo con un archivo que no existe:
   ```bash
   bash starter/wait-for-file.sh zona/listo 3; echo $?
   ```
   ```text
   listo: zona/listo (tras 0 s)
   0
   ```
   Miente: dice "listo" y el archivo no existe.

5. **TODO 1: esperar con `until`.** Sustituye el comentario del `TODO 1` por un `until` que, mientras el archivo no exista, espere un segundo:
   ```bash
   until [[ -e $file ]]; do
     sleep 1
   done
   ```
   Para probarlo, alguien tiene que crear el archivo mientras el script espera. `(sleep 2; touch zona/listo) &` lo hace en segundo plano (`&`, semana 02): los paréntesis agrupan los dos comandos y la terminal queda libre. `time` delante de un comando dice cuánto tardó:
   ```bash
   (sleep 2; touch zona/listo) &
   time bash starter/wait-for-file.sh zona/listo 5
   rm zona/listo
   ```
   Algo como (cambian el número del trabajo y los tiempos):
   ```text
   [1] 4321
   listo: zona/listo (tras 0 s)

   real	0m2.006s
   user	0m0.003s
   sys	0m0.005s
   [1]+  Done                    ( sleep 2; touch zona/listo )
   ```
   Esperó 2 segundos (`real`), pero dice `tras 0 s`: nadie suma a `waited`. Borra el comentario del `TODO 1`.

6. **TODO 2: contar las vueltas.** Dentro del `until`, debajo del `sleep 1`, añade:
   ```bash
     waited=$((waited + 1))
   ```
   Borra el comentario del `TODO 2`. Prueba:
   ```bash
   (sleep 2; touch zona/listo) &
   bash starter/wait-for-file.sh zona/listo 5
   rm zona/listo
   ```
   Algo como:
   ```text
   [1] 4330
   listo: zona/listo (tras 2 s)
   [1]+  Done                    ( sleep 2; touch zona/listo )
   ```
   Si el archivo no llega nunca, el script se queda esperando para siempre: el TODO 3.

7. **TODO 3: un límite.** Al principio del bloque del `until`, antes del `sleep 1`, añade un `if` que pare el script cuando `waited` llegue a `max`:
   ```bash
     if [[ $waited -ge $max ]]; then
       echo "wait-for-file.sh: '$file' no apareció en $max s" >&2
       exit 1
     fi
   ```
   `-ge` es "mayor o igual". Borra el comentario del `TODO 3`. Prueba sin archivo, con un archivo que llega a tiempo y con uno que ya existe:
   ```bash
   bash starter/wait-for-file.sh zona/listo 3; echo $?
   (sleep 2; touch zona/listo) &
   bash starter/wait-for-file.sh zona/listo 5; echo $?
   bash starter/wait-for-file.sh zona/listo 5; echo $?
   ```
   Algo como:
   ```text
   wait-for-file.sh: 'zona/listo' no apareció en 3 s
   1
   [1] 4342
   listo: zona/listo (tras 2 s)
   0
   [1]+  Done                    ( sleep 2; touch zona/listo )
   listo: zona/listo (tras 0 s)
   0
   ```
   Si ya existe, la condición del `until` se cumple al empezar y el bloque no se ejecuta ni una vez.

8. **shellcheck.**
   ```bash
   shellcheck starter/wait-for-file.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas la diferencia entre `while` y `until` con la cuenta atrás de los pasos 1 y 2
- [ ] Explicas qué le pasa a un bucle cuyo bloque no cambia nada de su condición (paso 3)
- [ ] `bash starter/wait-for-file.sh zona/nunca 3` sale con `1` tras 3 segundos y avisa en stderr
- [ ] Con un archivo que aparece a los 2 segundos, imprime `tras 2 s` y sale con `0`

## Reto extra

`until` acepta cualquier comando como condición. Escribe en la terminal un bucle que repita `ls zona/listo` hasta que funcione, sin `[[ ]]`: `until ls zona/listo 2>/dev/null; do sleep 1; done`. ¿Para qué otro comando de red te serviría la misma forma?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 01 — for](../lab-01-for/README.md) | [Lab 03 — break y continue](../lab-03-break-y-continue/README.md) → |

[↑ Semana 07](../../README.md)
