# Lab 01 — if y códigos de salida

⏱ Duración estimada: ~60 min

## Objetivo

Decidir qué hace un script según el código de salida de un comando, con `if`, `elif`, `else` y `!`.

## Contexto

- `if` no compara nada por sí mismo: ejecuta un comando y mira su código de salida. `0` es "se cumple"; cualquier otro, "no se cumple" ([teoría](../../1-teoria/01-if-y-codigos-de-salida.md)).
- `[` y `[[` también son comandos: comprueban una condición y salen con `0` o `1`.
- `starter/need-tool.sh` dice si un programa está instalado y dónde, lo primero que comprueba un script que lo va a necesitar. Tiene cuatro TODOs.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-06-condicionales_case_y_regex/2-practicas/lab-01-if-y-codigos-de-salida
   ```
   (sin salida).

1. **Dos comandos que solo devuelven un código.** `true` no hace nada y sale con `0`; `false`, con `1`. `$?` es el código del último comando (semana 03):
   ```bash
   true; echo $?
   false; echo $?
   ```
   ```text
   0
   1
   ```

2. **`if` con un comando.** La forma es `if comando; then ...; fi`. `fi` (`if` al revés) cierra el bloque, y `else` da lo que se hace si no se cumple:
   ```bash
   if true; then echo "se cumple"; fi
   if false; then echo "se cumple"; else echo "no se cumple"; fi
   ```
   ```text
   se cumple
   no se cumple
   ```
   En un script se escribe en varias líneas, con el cuerpo sangrado; en la terminal, los `;` hacen de salto de línea.

3. **Cualquier comando vale.** `grep -q` (de *quiet*) no imprime nada: solo sale con `0` si encuentra el texto y con `1` si no. `/etc/passwd` tiene una línea por usuario del sistema:
   ```bash
   grep -q alumno /etc/passwd; echo $?
   grep -q nadie /etc/passwd; echo $?
   if grep -q alumno /etc/passwd; then echo "alumno existe"; fi
   ```
   ```text
   0
   1
   alumno existe
   ```

4. **`!` invierte el código.** `if ! comando` se cumple cuando el comando falla:
   ```bash
   if ! grep -q nadie /etc/passwd; then echo "nadie no existe"; fi
   ```
   ```text
   nadie no existe
   ```

5. **`[` es un comando.** `type` dice qué es un nombre para bash. `[` recibe la condición como argumentos, y el último tiene que ser `]`. `-gt` es "mayor que" entre números:
   ```bash
   type [
   [ 3 -gt 2 ]; echo $?
   [ 3 -gt 5 ]; echo $?
   [3 -gt 2]
   [ 3 -gt 2
   ```
   ```text
   [ is a shell builtin
   0
   1
   bash: [3: command not found
   bash: [: missing `]'
   ```
   Sin espacio, `[3` es una sola palabra y bash busca un comando con ese nombre. Sin `]`, `[` se queja. Por eso los espacios dentro de los corchetes son obligatorios.

6. **`[[ ]]`, la versión de bash.** Hace lo mismo que `[` y evita sus trampas (lab 02). En este bootcamp usas siempre `[[ ]]`. `elif` (*else if*) añade otra condición si la anterior no se cumplió:
   ```bash
   [[ 3 -gt 2 ]]; echo $?
   n=7
   if [[ $n -gt 10 ]]; then echo "grande"; elif [[ $n -gt 5 ]]; then echo "mediano"; else echo "pequeño"; fi
   n=2
   if [[ $n -gt 10 ]]; then echo "grande"; elif [[ $n -gt 5 ]]; then echo "mediano"; else echo "pequeño"; fi
   ```
   ```text
   0
   mediano
   pequeño
   ```
   bash prueba las condiciones en orden y ejecuta solo el primer bloque que se cumple.

7. **`set -e` no salta dentro de un `if`.** Un comando que falla en la condición es una respuesta, no un error:
   ```bash
   bash -c 'set -e; grep -q nadie /etc/passwd; echo sigue'; echo $?
   bash -c 'set -e; if grep -q nadie /etc/passwd; then echo hay; fi; echo sigue'; echo $?
   ```
   ```text
   1
   sigue
   0
   ```
   Fuera del `if`, el `grep` que falla para el script antes del `echo`. Dentro, el script sigue.

8. **`command -v` y el código de `$( )`.** `command -v nombre` imprime dónde está un programa y sale con `0`, o no imprime nada y sale con `1`. Para una orden interna de bash, imprime solo su nombre. Una asignación con `$( )` sale con el código del comando de dentro:
   ```bash
   command -v git; echo $?
   command -v cd; echo $?
   command -v terraform; echo $?
   ruta=$(command -v git); echo $?
   ruta=$(command -v terraform); echo $?
   ```
   ```text
   /usr/bin/git
   0
   cd
   0
   1
   0
   1
   ```
   Así, `if ruta=$(command -v git)` guarda la ruta y decide a la vez.

9. **El script, sin tocar:**
   ```bash
   bash starter/need-tool.sh; echo $?
   bash starter/need-tool.sh git
   ```
   ```text
   starter/need-tool.sh: line 6: $1: unbound variable
   1
   sin implementar: git
   ```
   **TODO 1:** abre `starter/need-tool.sh` en tu editor. Sustituye el comentario del `TODO 1` por un `if` que, si el número de argumentos (`$#`) no es `1` (`-ne`, "distinto de"), escriba el uso en stderr y salga con `2`:
   ```bash
   if [[ $# -ne 1 ]]; then
     echo "uso: need-tool.sh <programa>" >&2
     exit 2
   fi
   ```
   Prueba:
   ```bash
   bash starter/need-tool.sh; echo $?
   bash starter/need-tool.sh git curl; echo $?
   ```
   ```text
   uso: need-tool.sh <programa>
   2
   uso: need-tool.sh <programa>
   2
   ```

10. **TODO 2.** Sustituye el comentario del `TODO 2` por el principio del `if` que decide: si `command -v` **no** encuentra el programa, avisa y sale con `1`. Usa `--` para que un nombre que empiece por `-` no se tome por una opción:
    ```bash
    if ! path=$(command -v -- "$tool"); then
      echo "falta: $tool" >&2
      exit 1
    fi
    ```
    Prueba:
    ```bash
    bash starter/need-tool.sh terraform; echo $?
    ```
    ```text
    falta: terraform
    1
    ```

11. **TODO 3.** Si lo encuentra y la ruta empieza por `/`, es un programa instalado. Dentro de `[[ ]]`, `==` compara con un patrón glob (lab 02): `[[ $path == /* ]]` es "empieza por `/`". Cambia el `fi` del paso 10 por un `elif` que imprima `ok: <programa> está en <ruta>`, y borra el comentario del `TODO 3`:
    ```bash
    elif [[ $path == /* ]]; then
      echo "ok: $tool está en $path"
    fi
    ```
    Prueba (el `sin implementar` sigue ahí hasta el paso 12):
    ```bash
    bash starter/need-tool.sh git
    ```
    ```text
    ok: git está en /usr/bin/git
    sin implementar: git
    ```

12. **TODO 4.** Si no empieza por `/`, `command -v` devolvió el nombre tal cual: es parte de bash. Añade, antes del `fi`, un `else` que imprima `ok: <programa> es parte de bash`. Borra el comentario del `TODO 4` y el `echo "sin implementar..."` del final. Prueba los tres casos:
    ```bash
    bash starter/need-tool.sh git; echo $?
    bash starter/need-tool.sh cd
    bash starter/need-tool.sh terraform; echo $?
    ```
    ```text
    ok: git está en /usr/bin/git
    0
    ok: cd es parte de bash
    falta: terraform
    1
    ```

## Criterios de éxito

- [ ] Explicas por qué `[3 -gt 2]` da `command not found` (paso 5)
- [ ] Explicas por qué `set -e` no para el script cuando falla la condición de un `if` (paso 7)
- [ ] `bash starter/need-tool.sh` sin argumentos imprime el uso y sale con `2`
- [ ] `bash starter/need-tool.sh git` imprime `ok: git está en /usr/bin/git`, y con `terraform`, `falta: terraform` y código `1`

## Reto extra

Prueba `bash starter/need-tool.sh ls` y `bash starter/need-tool.sh echo`. ¿Por qué `echo` es "parte de bash" si también existe `/usr/bin/echo`? Mira qué dice `type -a echo`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Índice de labs](../README.md) | [Lab 02 — Comparar textos y números](../lab-02-comparar-textos-y-numeros/README.md) → |

[↑ Semana 06](../../README.md)
