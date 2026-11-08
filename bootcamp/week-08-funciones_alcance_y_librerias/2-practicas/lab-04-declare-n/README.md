# Lab 04 — declare -n

⏱ Duración estimada: ~60 min

## Objetivo

Devolver varios valores desde una función guardándolos en variables de quien la llama, con una referencia `declare -n`.

## Contexto

- `$(funcion)` devuelve un solo texto. Cuando una función tiene que dar dos resultados (un host y un puerto), una salida es pasarle el **nombre** de las variables donde quieres cada uno.
- `declare -n ref=nombre` (o `local -n` dentro de una función) crea una **referencia**: leer o cambiar `ref` es leer o cambiar la variable que se llama `nombre`.
- `datos/destinos.txt` es una lista de máquinas `host:puerto`; una no lleva puerto. `starter/split-targets.sh` separa cada línea en host y puerto, y usa el 22 de ssh si no lo dice.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-08-funciones_alcance_y_librerias/2-practicas/lab-04-declare-n
   ```
   (sin salida).

1. **Una referencia.**
   ```bash
   fruit=manzana
   declare -n ref=fruit
   echo "$ref"
   ref=pera
   echo "$fruit"
   ```
   ```text
   manzana
   pera
   ```
   `ref` no guarda nada: es otro nombre para `fruit`. Cambiar `ref` cambia `fruit`.

2. **En una función.** El nombre de la variable llega como argumento:
   ```bash
   set_value() { local -n target=$1; target=$2; }
   set_value color azul
   echo "$color"
   ```
   ```text
   azul
   ```
   `set_value` escribió en `color` sin `$( )` y sin subshell. `local -n` hace que la referencia sea de la función; la variable a la que apunta, no.

3. **El nombre que no puedes usar.** Pídele a `set_value` que escriba en una variable que se llame como su referencia:
   ```bash
   set_value target rojo
   ```
   ```text
   bash: local: warning: target: circular name reference
   bash: warning: target: circular name reference
   bash: warning: target: circular name reference
   ```
   `local -n target=target` apunta a sí misma. Por eso las referencias llevan nombres que nadie usaría fuera, como `out_host`.

4. **El script, tal cual.** Abre `starter/split-targets.sh` en tu editor y ejecútalo:
   ```bash
   bash starter/split-targets.sh datos/destinos.txt
   ```
   ```text
   host= puerto=
   host= puerto=
   host= puerto=
   host= puerto=
   ```
   `split_target` recibe la línea y los nombres `host` y `port`, pero no escribe en ellos.

5. **TODO 1: las referencias.** En `split_target`, cambia la línea del `TODO 1` por:
   ```bash
     local -n out_host=$2 out_port=$3
     out_host=${1%%:*}
     out_port=${1##*:}
   ```
   y borra el `:` (un comando que no hace nada, puesto para que la función no quedase vacía). `${1%%:*}` quita desde el `:` hasta el final; `${1##*:}`, desde el principio hasta el `:` (semana 05). Prueba:
   ```bash
   bash starter/split-targets.sh datos/destinos.txt
   ```
   ```text
   host=web-01 puerto=8080
   host=db-01 puerto=5432
   host=bastion puerto=bastion
   host=cache-01 puerto=6379
   ```
   Sin `:`, ninguno de los dos recortes encuentra nada que quitar, y `bastion` sale entero en los dos sitios.

6. **TODO 2: el puerto por defecto.** Cambia la línea `out_port=${1##*:}` y el comentario del `TODO 2` por:
   ```bash
     out_port=22
     if [[ $1 == *:* ]]; then
       out_port=${1##*:}
     fi
   ```
   Prueba:
   ```bash
   bash starter/split-targets.sh datos/destinos.txt
   ```
   ```text
   host=web-01 puerto=8080
   host=db-01 puerto=5432
   host=bastion puerto=22
   host=cache-01 puerto=6379
   ```

7. **shellcheck no ve la referencia.**
   ```bash
   shellcheck starter/split-targets.sh; echo $?
   ```
   ```text

   In starter/split-targets.sh line 10:
     out_host=${1%%:*}
     ^------^ SC2034 (warning): out_host appears unused. Verify use (or export if used externally).


   In starter/split-targets.sh line 13:
       out_port=${1##*:}
       ^------^ SC2034 (warning): out_port appears unused. Verify use (or export if used externally).

   For more information:
     https://www.shellcheck.net/wiki/SC2034 -- out_host appears unused. Verify u...
   1
   ```
   shellcheck cree que `out_host` y `out_port` se asignan y nadie las lee: no sigue la referencia hasta `host` y `port`. Es un falso aviso. Un comentario `# shellcheck disable=SC2034` justo encima de `split_target() {` lo apaga solo para esa función:
   ```bash
   # shellcheck disable=SC2034
   split_target() {
   ```
   Prueba:
   ```bash
   shellcheck starter/split-targets.sh; echo $?
   ```
   ```text
   0
   ```
   Apaga un aviso solo cuando sepas por qué es falso, y escribe el porqué en un comentario.

## Criterios de éxito

- [ ] Explicas qué cambió `ref=pera` en el paso 1 y por qué
- [ ] Explicas por qué `set_value target rojo` no funciona (paso 3)
- [ ] `bash starter/split-targets.sh datos/destinos.txt` imprime las cuatro líneas del paso 6
- [ ] `shellcheck starter/split-targets.sh` no imprime nada

## Reto extra

Escribe `split_target` sin `declare -n`, imprimiendo `host puerto` en una línea y separándolo fuera con `read -r host port < <(split_target "$target")`. ¿Cuál de las dos versiones se lee mejor, y cuál lanza un subshell por línea?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 03 — local y alcance](../lab-03-local-y-alcance/README.md) | [Lab 05 — source y librerías](../lab-05-source-y-librerias/README.md) → |

[↑ Semana 08](../../README.md)
