# Lab 02 — return y salida

⏱ Duración estimada: ~60 min

## Objetivo

Separar lo que una función imprime (el dato, que se recoge con `$( )`) de su código de salida (sí o no, que se usa en un `if`), y distinguir `return` de `exit`.

## Contexto

- Una función tiene dos salidas, como cualquier comando: lo que **imprime** por stdout y su **código de salida**, un número de 0 a 255. `return N` termina la función con el código `N`; sin `return`, el código es el del último comando.
- `$(funcion)` recoge lo que imprime. El código lo usa un `if`, un `||` o `$?`.
- `datos/servicios.txt` es una lista de servicios y sus puertos, con un puerto imposible a propósito. `starter/lookup-port.sh` busca el puerto de un servicio.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-08-funciones_alcance_y_librerias/2-practicas/lab-02-return-y-salida
   ```
   (sin salida).

1. **El código es el del último comando.** `(( ))` sale con `0` si la cuenta es verdad (semana 07):
   ```bash
   is_even() { (($1 % 2 == 0)); }
   is_even 4; echo $?
   is_even 3; echo $?
   ```
   ```text
   0
   1
   ```
   Una función que responde sí o no no necesita imprimir nada: `if is_even 4; then ...` ya funciona.

2. **`return` solo llega a 255.**
   ```bash
   f() { return 3; }; f; echo $?
   g() { return 256; }; g; echo $?
   ```
   ```text
   3
   0
   ```
   El código es un número de 0 a 255, y 256 da la vuelta a 0. Con `return` no se devuelve un dato (un total, un nombre): eso se imprime.

3. **Dato y código, a la vez.**
   ```bash
   get_name() { echo "ana"; return 1; }
   name=$(get_name); echo "[$name] código $?"
   ```
   ```text
   [ana] código 1
   ```
   `name` recoge lo impreso, y el `$?` de la asignación es el código de la función.

4. **`exit` para el script entero.**
   ```bash
   bash -c 'f() { exit 5; }; f; echo sigue'; echo $?
   bash -c 'f() { exit 5; }; x=$(f); echo "sigue, código $?"'
   ```
   ```text
   5
   sigue, código 5
   ```
   `exit` dentro de una función no vuelve: termina el script, y `sigue` no sale. Dentro de `$( )` la función va en un subshell (semana 07), y `exit` solo termina ese subshell.

5. **TODO 1: `port_of` imprime el puerto.** Abre `starter/lookup-port.sh` en tu editor y pruébalo:
   ```bash
   bash starter/lookup-port.sh ssh; bash starter/lookup-port.sh postgres
   ```
   ```text
   ssh: 80
   postgres: 80
   ```
   El borrador siempre dice `80`. En `port_of`, borra el comentario del `TODO 1` y el `echo "80"`, y escribe:
   ```bash
     local name port
     while read -r name port; do
       if [[ $name == "$1" ]]; then
         echo "$port"
         return 0
       fi
     done < "$services"
     return 1
   ```
   `local` hace que `name` y `port` sean de la función (lab 03). `return 0` sale de la función en cuanto lo encuentra, sin leer el resto. Prueba:
   ```bash
   bash starter/lookup-port.sh ssh; bash starter/lookup-port.sh postgres; bash starter/lookup-port.sh nada; echo $?
   ```
   ```text
   ssh: 22
   postgres: 5432
   1
   ```
   Con `nada`, `port_of` sale con `1`, la asignación `port=$(...)` también, y `set -e` para el script sin decir nada.

6. **TODO 2: `main` mira los códigos.** En `main`, borra el comentario del `TODO 2` y la línea `port=$(port_of "$service")`, y escribe:
   ```bash
     if ! port=$(port_of "$service"); then
       echo "lookup-port.sh: '$service' no está en $services" >&2
       exit 1
     fi
     if ! is_port "$port"; then
       echo "lookup-port.sh: '$port' no es un puerto válido" >&2
       exit 1
     fi
   ```
   Dentro de un `if`, un fallo no para el script: el `if` lo trata. `port` se declaró con `local` en otra línea: `local port=$(...)` saldría siempre con `0`, el código de `local`, y el `if` no vería el fallo. Prueba:
   ```bash
   bash starter/lookup-port.sh nada; echo $?; bash starter/lookup-port.sh legacy; echo $?
   ```
   ```text
   lookup-port.sh: 'nada' no está en datos/servicios.txt
   1
   legacy: 99999
   0
   ```
   `99999` no es un puerto (el máximo es 65535), pero el borrador de `is_port` siempre dice que sí.

7. **TODO 3: `is_port` responde con el código.** En `is_port`, borra el comentario del `TODO 3` y el `return 0`, y escribe:
   ```bash
     [[ $1 =~ ^[1-9][0-9]*$ ]] || return 1
     (($1 <= 65535))
   ```
   La regex descarta lo que no es un número (semana 06); la cuenta, el último comando, decide el código. Prueba:
   ```bash
   bash starter/lookup-port.sh legacy; echo $?; bash starter/lookup-port.sh https; echo $?
   bash starter/lookup-port.sh; echo $?
   ```
   ```text
   lookup-port.sh: '99999' no es un puerto válido
   1
   https: 443
   0
   starter/lookup-port.sh: line 27: 1: uso: lookup-port.sh <servicio>
   1
   ```
   El último aviso es el de `${1:?...}` (semana 05): dentro de `main`, `$1` es el primer argumento de `main`.

8. **shellcheck.**
   ```bash
   shellcheck starter/lookup-port.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas por qué `g` salió con `0` en el paso 2
- [ ] Explicas por qué `sigue` no apareció en el primer comando del paso 4 y sí en el segundo
- [ ] `bash starter/lookup-port.sh https` imprime `https: 443`, y `nada` y `legacy` salen con `1` y aviso en stderr
- [ ] `shellcheck starter/lookup-port.sh` no imprime nada

## Reto extra

Cambia `datos/servicios.txt` para que `ssh` aparezca dos veces con puertos distintos. ¿Cuál devuelve `port_of`, y qué línea lo decide?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 01 — Funciones](../lab-01-funciones/README.md) | [Lab 03 — local y alcance](../lab-03-local-y-alcance/README.md) → |

[↑ Semana 08](../../README.md)
