# Lab 03 — Operadores de archivo

⏱ Duración estimada: ~60 min

## Objetivo

Comprobar antes de actuar si una ruta existe, qué es y qué se puede hacer con ella, con los operadores de archivo de `[[ ]]`.

## Contexto

- Un script que va a leer, escribir o borrar algo lo comprueba antes: `-e` (existe), `-f` (archivo), `-d` (carpeta), `-s` (no vacío), `-r`/`-w`/`-x` (puedes leer, escribir, ejecutar), `-L` (enlace) ([teoría](../../1-teoria/02-comparar-con-dobles-corchetes.md)).
- Varios se solapan: un enlace a un archivo es también `-f`, y una carpeta también es `-x`. En una cadena de `elif`, el orden decide la respuesta.
- `starter/path-kind.sh` dice qué hay en una ruta. Tiene cinco TODOs, uno por rama.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-06-condicionales_case_y_regex/2-practicas/lab-03-operadores-de-archivo
   ```
   (sin salida).

1. **Prepara una carpeta de pruebas** con un archivo con texto, uno vacío, un script, una carpeta, un enlace a un archivo y un enlace roto. `ln -s destino nombre` crea un enlace simbólico: un archivo que apunta a otro. `printf` escribe el texto tal cual, con `\n` como salto de línea:
   ```bash
   mkdir zona
   echo "hola" > zona/notas.txt
   touch zona/vacio.txt
   printf '#!/usr/bin/env bash\necho hola\n' > zona/saluda.sh
   chmod +x zona/saluda.sh
   mkdir zona/fotos
   ln -s notas.txt zona/enlace
   ln -s nada.txt zona/roto
   ls -l zona
   ```
   Algo como (cambian las fechas):
   ```text
   total 12
   lrwxrwxrwx 1 alumno alumno    9 Nov  8 06:15 enlace -> notas.txt
   drwxr-xr-x 2 alumno alumno 4096 Nov  8 06:15 fotos
   -rw-r--r-- 1 alumno alumno    5 Nov  8 06:15 notas.txt
   lrwxrwxrwx 1 alumno alumno    8 Nov  8 06:15 roto -> nada.txt
   -rwxr-xr-x 1 alumno alumno   30 Nov  8 06:15 saluda.sh
   -rw-r--r-- 1 alumno alumno    0 Nov  8 06:15 vacio.txt
   ```
   La primera letra de cada línea es el tipo (semana 02): `-` archivo, `d` carpeta, `l` enlace. `zona/` es solo para este lab: git la ignora.

2. **Existe, archivo, carpeta.**
   ```bash
   [[ -e zona/notas.txt ]]; echo $?
   [[ -e zona/nada.txt ]]; echo $?
   [[ -f zona/notas.txt ]]; echo $?
   [[ -f zona/fotos ]]; echo $?
   [[ -d zona/fotos ]]; echo $?
   ```
   ```text
   0
   1
   0
   1
   0
   ```

3. **Vacío o no.** `-s` (*size*) se cumple si el archivo existe y tiene al menos un byte:
   ```bash
   [[ -s zona/notas.txt ]]; echo $?
   [[ -s zona/vacio.txt ]]; echo $?
   ```
   ```text
   0
   1
   ```

4. **Permisos.** `-r`, `-w` y `-x` miran si **tú**, el usuario que ejecuta, puedes leer, escribir o ejecutar:
   ```bash
   [[ -r zona/notas.txt ]]; echo $?
   [[ -w zona/notas.txt ]]; echo $?
   [[ -x zona/saluda.sh ]]; echo $?
   [[ -x zona/notas.txt ]]; echo $?
   [[ -x zona/fotos ]]; echo $?
   [[ -w /etc/passwd ]]; echo $?
   ```
   ```text
   0
   0
   0
   1
   0
   1
   ```
   Una carpeta con `x` es una en la que puedes entrar (semana 02): también cumple `-x`. `/etc/passwd` es de `root`, y `alumno` no puede escribir en él.

5. **Enlaces.** `-L` mira el enlace en sí; los demás operadores lo siguen y miran su destino:
   ```bash
   [[ -L zona/enlace ]]; echo $?
   [[ -f zona/enlace ]]; echo $?
   [[ -L zona/roto ]]; echo $?
   [[ -e zona/roto ]]; echo $?
   ```
   ```text
   0
   0
   0
   1
   ```
   `zona/roto` es un enlace, pero `-e` dice que no existe: su destino, `nada.txt`, no está.

6. **Más reciente que.** `-nt` (*newer than*) compara las fechas de modificación. `touch -d` le pone una fecha a un archivo:
   ```bash
   touch -d "2026-01-01" zona/vacio.txt
   [[ zona/notas.txt -nt zona/vacio.txt ]]; echo $?
   ```
   ```text
   0
   ```
   Es la pregunta de "¿hay que regenerar esto?": si la fuente es más nueva que el resultado.

7. **Sin `if`, y con espacios.** Para una sola acción basta `&&`/`||` (semana 03). Dentro de `[[ ]]` una ruta con espacios no necesita comillas:
   ```bash
   [[ -f zona/notas.txt ]] && echo "hay notas" || echo "no hay notas"
   f="zona/mi archivo.txt"
   [[ -e $f ]]; echo $?
   ```
   ```text
   hay notas
   1
   ```
   Con `[ -e $f ]` serían dos argumentos y un error. Igual que en el lab 02: `[[ ]]`.

8. **El script y el TODO 1.**
   ```bash
   bash starter/path-kind.sh zona/notas.txt
   ```
   ```text
   zona/notas.txt: sin implementar
   ```
   Abre `starter/path-kind.sh` en tu editor. Sustituye el comentario del `TODO 1` por el principio de la cadena: si `p` es un enlace **y** su destino no existe.
   ```bash
   if [[ -L $p && ! -e $p ]]; then
     echo "$p: enlace roto"
   fi
   ```
   Prueba (el `sin implementar` sigue ahí hasta el paso 12):
   ```bash
   bash starter/path-kind.sh zona/roto
   ```
   ```text
   zona/roto: enlace roto
   zona/roto: sin implementar
   ```

9. **TODO 2.** Cambia el `fi` por un `elif` que, si `p` no existe, lo diga en stderr y salga con `1`, y vuelve a cerrar con `fi`:
   ```bash
   elif [[ ! -e $p ]]; then
     echo "$p: no existe" >&2
     exit 1
   fi
   ```
   Borra el comentario del `TODO 2`. Prueba:
   ```bash
   bash starter/path-kind.sh zona/nada.txt; echo $?
   ```
   ```text
   zona/nada.txt: no existe
   1
   ```
   Si el TODO 2 fuera antes que el TODO 1, `zona/roto` diría "no existe": `-e` sigue el enlace (paso 5).

10. **TODO 3.** Otro `elif` antes del `fi`: si es un directorio (`-d`), `"$p: directorio"`. Borra el comentario del `TODO 3`. Prueba:
    ```bash
    bash starter/path-kind.sh zona/fotos
    ```
    ```text
    zona/fotos: directorio
    zona/fotos: sin implementar
    ```

11. **TODO 4.** Otro `elif`: si **no** tiene contenido (`! -s`), `"$p: archivo vacío"`. Borra el comentario del `TODO 4`. Prueba:
    ```bash
    bash starter/path-kind.sh zona/vacio.txt
    ```
    ```text
    zona/vacio.txt: archivo vacío
    zona/vacio.txt: sin implementar
    ```

12. **TODO 5.** El último `elif`: si se puede ejecutar (`-x`), `"$p: ejecutable"`; y un `else` para el resto, `"$p: archivo"`. Borra el comentario del `TODO 5` y el `echo` del `sin implementar`. Prueba todas las rutas:
    ```bash
    bash starter/path-kind.sh zona/saluda.sh
    bash starter/path-kind.sh zona/notas.txt
    bash starter/path-kind.sh zona/enlace
    bash starter/path-kind.sh zona/fotos
    bash starter/path-kind.sh zona/roto
    ```
    ```text
    zona/saluda.sh: ejecutable
    zona/notas.txt: archivo
    zona/enlace: archivo
    zona/fotos: directorio
    zona/roto: enlace roto
    ```
    `zona/fotos` sigue diciendo "directorio" porque su rama va antes que `-x` (paso 4). Para empezar de cero: `rm -r zona` y vuelve al paso 1.

## Criterios de éxito

- [ ] Explicas por qué `[[ -e zona/roto ]]` da `1` aunque `zona/roto` aparece en `ls` (paso 5)
- [ ] Explicas por qué la rama de `-d` va antes que la de `-x` (pasos 4 y 12)
- [ ] `bash starter/path-kind.sh` da `enlace roto`, `directorio`, `archivo vacío`, `ejecutable` y `archivo` para las rutas de `zona/`
- [ ] Con una ruta que no existe, `no existe` en stderr y código `1`

## Reto extra

Haz `chmod -r zona/notas.txt` y prueba `[[ -r zona/notas.txt ]]; echo $?`. Después, `cat zona/notas.txt`. Añade al script una rama que diga `sin permiso de lectura`. ¿Dónde tiene que ir en la cadena? Devuélvele el permiso con `chmod +r zona/notas.txt`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 02 — Comparar textos y números](../lab-02-comparar-textos-y-numeros/README.md) | [Lab 04 — case](../lab-04-case/README.md) → |

[↑ Semana 06](../../README.md)
