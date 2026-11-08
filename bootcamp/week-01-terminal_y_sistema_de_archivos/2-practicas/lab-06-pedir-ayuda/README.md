# Lab 06 — Pedir ayuda

⏱ Duración estimada: ~60 min

## Objetivo

Encontrar por tu cuenta qué es un comando y qué opción necesitas, usando `type`, `help`, `--help` y `man`.

## Contexto

- `type` dice qué es un comando; `help` explica los *builtins* de bash; `--help` da un resumen; `man` el manual completo ([teoría](../../1-teoria/04-ayuda-atajos-e-historial.md)).
- En `starter/tamanos` hay tres archivos con nombres que **no** van en orden de tamaño: `a-pequeno.txt`, `b-grande.txt` y `c-mediano.txt`.
- El objetivo final: descubrir en el manual de `ls` la opción que ordena por tamaño, sin buscarla en internet.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-01-terminal_y_sistema_de_archivos/2-practicas/lab-06-pedir-ayuda
   ```

1. **¿Qué es cada comando?**
   ```bash
   type cd
   type mkdir
   type ls
   ```
   ```text
   cd is a shell builtin
   mkdir is /usr/bin/mkdir
   ls is aliased to `ls --color=auto'
   ```
   `cd` está dentro de bash (*builtin*); `mkdir` es un programa guardado en `/usr/bin/mkdir`. `ls` es un **alias**: un apodo que el archivo de configuración de bash (`~/.bashrc`) define para que `ls` pinte en colores. Detrás está el programa `/usr/bin/ls`.

2. **Un comando puede ser dos cosas.** `-a` hace que `type` muestre todas:
   ```bash
   type -a echo
   type nocomando
   ```
   ```text
   echo is a shell builtin
   echo is /usr/bin/echo
   echo is /bin/echo
   bash: type: nocomando: not found
   ```
   bash usa la primera de la lista: el *builtin*. (`/bin/echo` y `/usr/bin/echo` son el mismo archivo; en Ubuntu, `/bin` apunta a `/usr/bin`.)

3. **`help` para los builtins:**
   ```bash
   help cd
   ```
   Las primeras líneas:
   ```text
   cd: cd [-L|[-P [-e]] [-@]] [dir]
       Change the shell working directory.

       Change the current directory to DIR.  The default DIR is the value of the
       HOME shell variable. If DIR is "-", it is converted to $OLDPWD.
   ```
   Primera línea: la sintaxis. Lo que va entre `[ ]` es opcional: `cd` funciona sin argumentos (te lleva a `HOME`, tu home). `help` sobre un *builtin* da su ayuda; `man cd` en cambio responde `No manual entry for cd`.

4. **La opción de una línea.** ¿Hay forma de que `help` dé solo la descripción corta? Pregúntale a `help` por sí mismo:
   ```bash
   help help
   ```
   Busca en su salida la opción que dice *short description* y pruébala con `cd`. Debe imprimir:
   ```text
   cd - Change the shell working directory.
   ```

5. **`--help` para los programas.** Casi todos los programas aceptan `--help`:
   ```bash
   ls --help
   ```
   Es largo: sube con la rueda del ratón o la barra de la terminal para ver el principio. Empieza así:
   ```text
   Usage: ls [OPTION]... [FILE]...
   List information about the FILEs (the current directory by default).
   Sort entries alphabetically if none of -cftuvSUX nor --sort is specified.
   ```
   La tercera línea ya da una pista: el orden por defecto es alfabético, salvo que uses alguna de esas letras.

6. **`man` para el manual completo.** Mira primero los tamaños reales:
   ```bash
   ls -l starter/tamanos
   ```
   Algo como:
   ```text
   total 12
   -rw-r--r-- 1 alumno alumno    6 Nov  8 04:29 a-pequeno.txt
   -rw-r--r-- 1 alumno alumno 2991 Nov  8 04:29 b-grande.txt
   -rw-r--r-- 1 alumno alumno  311 Nov  8 04:29 c-mediano.txt
   ```
   Abre el manual:
   ```bash
   man ls
   ```
   Escribe `/size` y pulsa `Enter` para buscar la palabra `size`. Pulsa `n` hasta llegar a una opción que diga *sort by file size*. Apunta su letra y sal con `q`.

7. **El script, sin tocar:**
   ```bash
   bash starter/help-check.sh
   ```
   ```text
   == qué es cd ==
   == qué es mkdir ==
   == pwd en una línea ==
   == tamanos, del más grande al más pequeño ==
   sin implementar
   ```

8. **TODO 1 y TODO 2.** Abre `starter/help-check.sh` en tu editor. `type cd` y `type mkdir`, cada uno bajo su `TODO`. Prueba con `bash starter/help-check.sh`: aparecen `cd is a shell builtin` y `mkdir is /usr/bin/mkdir`.

9. **TODO 3.** `help` con la opción del paso 4, sobre `pwd`. Prueba: aparece `pwd - Print the name of the current working directory.`

10. **TODO 4.** `ls` con la opción del paso 6 sobre `starter/tamanos`. Borra `echo "sin implementar"` y los comentarios `TODO`. Prueba:
    ```bash
    bash starter/help-check.sh
    ```
    ```text
    == qué es cd ==
    cd is a shell builtin
    == qué es mkdir ==
    mkdir is /usr/bin/mkdir
    == pwd en una línea ==
    pwd - Print the name of the current working directory.
    == tamanos, del más grande al más pequeño ==
    b-grande.txt  c-mediano.txt  a-pequeno.txt
    ```

11. **¿Por qué `ls` no es un alias en el script?** Añade temporalmente `type ls` al final del script y ejecútalo: imprime `ls is /usr/bin/ls`. Los alias de `~/.bashrc` solo existen en la shell que usas para teclear; un script arranca un bash sin ellos. Quita la línea.

## Criterios de éxito

- [ ] Distingues builtin, programa y alias con `type` (pasos 1 y 2)
- [ ] Encontraste en `help help` la opción de descripción corta (paso 4)
- [ ] Encontraste en `man ls` la opción que ordena por tamaño, sin buscar en internet (paso 6)
- [ ] `bash starter/help-check.sh` imprime lo del paso 10

## Reto extra

En `man ls`, busca la opción que invierte el orden y combínala con la del paso 6 para listar `starter/tamanos` del más pequeño al más grande. Después busca en `man man` qué significan los números de sección (`man 1 ls`, `man 5 passwd`).

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 05 — Borrar sin sustos](../lab-05-borrar-sin-sustos/README.md) | [Lab 07 — Buscar con find](../lab-07-buscar-con-find/README.md) → |

[↑ Semana 01](../../README.md)
