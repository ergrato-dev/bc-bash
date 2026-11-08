# Lab 01 — Arrays indexados

⏱ Duración estimada: ~60 min

## Objetivo

Guardar una lista en un array, leer sus elementos por posición y recorrerla con sus índices.

## Contexto

- Una variable guarda un texto; un **array** guarda varios, cada uno en una casilla numerada desde `0`. `lista=(a b c)` lo crea, `${lista[1]}` lee la casilla 1 y `"${lista[@]}"` son todos los elementos, cada uno como un argumento.
- `mapfile -t` (semana 07) ya te dejaba un archivo en un array, una línea por elemento. Ahora toca usarlo.
- `starter/servers.sh` lee `datos/servidores.txt` y tiene que decir cuántos servidores hay, cuál es el primero y el último, y numerarlos.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-09-arrays_y_printf/2-practicas/lab-01-arrays-indexados
   ```
   (sin salida).

1. **Crear y leer.** Los paréntesis crean el array; las comillas hacen que `pera limonera` sea un solo elemento:
   ```bash
   fruits=(manzana "pera limonera" kiwi)
   echo "${fruits[0]}"
   echo "${fruits[1]}"
   echo "${#fruits[@]}"
   echo "${fruits[-1]}"
   ```
   ```text
   manzana
   pera limonera
   3
   kiwi
   ```
   `${#fruits[@]}` es cuántos elementos hay. Un índice negativo cuenta desde el final: `-1` es el último.

2. **Añadir y recorrer.** `+=( )` añade al final:
   ```bash
   fruits+=(uva)
   echo "${#fruits[@]}"
   for f in "${fruits[@]}"; do echo "- $f"; done
   echo "${!fruits[@]}"
   ```
   ```text
   4
   - manzana
   - pera limonera
   - kiwi
   - uva
   0 1 2 3
   ```
   `"${fruits[@]}"`, con las comillas, da una vuelta por elemento. `${!fruits[@]}`, con `!`, son los **índices**, no los valores.

3. **El nombre a secas.**
   ```bash
   echo "$fruits"
   ```
   ```text
   manzana
   ```
   `$fruits` sin `[ ]` es solo la casilla `0`. Es un error frecuente: parece que funciona hasta que miras el resto.

4. **El script, tal cual.** Abre `starter/servers.sh` en tu editor y ejecútalo:
   ```bash
   bash starter/servers.sh datos/servidores.txt
   ```
   ```text
   sin implementar: web-01 web-02 db-01 cache-01 backup-01
   ```
   `mapfile` ya llenó `servers`; falta usarlo.

5. **TODO 1: cuántos.** Cambia el comentario del `TODO 1` por:
   ```bash
     echo "${#servers[@]} servidores"
   ```
   Prueba:
   ```bash
   bash starter/servers.sh datos/servidores.txt
   ```
   ```text
   5 servidores
   sin implementar: web-01 web-02 db-01 cache-01 backup-01
   ```

6. **TODO 2: el primero y el último.** Cambia el comentario del `TODO 2` por:
   ```bash
     echo "primero: ${servers[0]}"
     # -1 cuenta desde el final: el último, sin saber cuántos hay.
     echo "último: ${servers[-1]}"
   ```
   Prueba:
   ```bash
   bash starter/servers.sh datos/servidores.txt
   ```
   ```text
   5 servidores
   primero: web-01
   último: backup-01
   sin implementar: web-01 web-02 db-01 cache-01 backup-01
   ```

7. **TODO 3: la lista numerada.** Los índices empiezan en `0` y una lista para personas empieza en `1`. Cambia el comentario del `TODO 3` y el `echo "sin implementar..."` por:
   ```bash

     # ${!servers[@]} son los índices (0, 1, 2...); se suma 1 para numerar desde 1.
     for i in "${!servers[@]}"; do
       echo "$((i + 1)). ${servers[i]}"
     done
   ```
   Dentro de `[ ]`, `i` va sin `$`: el índice de un array indexado es una cuenta, como en `$(( ))`. Prueba:
   ```bash
   bash starter/servers.sh datos/servidores.txt
   ```
   ```text
   5 servidores
   primero: web-01
   último: backup-01
   1. web-01
   2. web-02
   3. db-01
   4. cache-01
   5. backup-01
   ```

8. **Un nombre con espacio.** Crea una lista con un servidor más, con espacio en el nombre:
   ```bash
   cp datos/servidores.txt mas.txt
   echo "nas 01" >> mas.txt
   bash starter/servers.sh mas.txt | tail -n 2
   rm mas.txt
   ```
   ```text
   5. backup-01
   6. nas 01
   ```
   Una línea, un elemento: `nas 01` no se parte en dos.

9. **shellcheck.**
   ```bash
   shellcheck starter/servers.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas qué diferencia hay entre `"${fruits[@]}"` y `"${!fruits[@]}"` (paso 2)
- [ ] Explicas por qué `echo "$fruits"` solo imprimió `manzana` (paso 3)
- [ ] `bash starter/servers.sh datos/servidores.txt` imprime las ocho líneas del paso 7
- [ ] `shellcheck starter/servers.sh` no imprime nada

## Reto extra

Añade una opción `--reverse` que numere la lista del último al primero. Pista: `for ((i = ${#servers[@]} - 1; i >= 0; i--))`, el `for` de estilo C de la semana 07.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Índice de labs](../README.md) | [Lab 02 — `[@]` frente a `[*]`](../lab-02-arroba-y-asterisco/README.md) → |

[↑ Semana 09](../../README.md)
