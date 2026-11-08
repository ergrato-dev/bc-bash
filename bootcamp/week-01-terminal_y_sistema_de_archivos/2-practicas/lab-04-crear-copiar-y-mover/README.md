# Lab 04 — Crear, copiar y mover

⏱ Duración estimada: ~60 min

## Objetivo

Construir una estructura de carpetas y reorganizarla con `mkdir`, `touch`, `cp` y `mv`, viendo qué pasa cuando el destino ya existe.

## Contexto

- Todo el lab ocurre dentro de `zona/`, una carpeta de pruebas que git ignora. Puedes borrarla y empezar de cero cuando quieras.
- El último argumento de `cp` y `mv` es el destino. Renombrar es mover ([teoría](../../1-teoria/03-crear-copiar-mover-borrar.md)).
- `cp` y `mv` sobrescriben sin avisar si el destino ya existe.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-01-terminal_y_sistema_de_archivos/2-practicas/lab-04-crear-copiar-y-mover
   mkdir zona
   ```
   (sin salida). Si `mkdir` responde `File exists`, `zona/` ya estaba de una vez anterior: bórrala con `rm -r zona` y repite el `mkdir`.

1. **`mkdir` y las carpetas intermedias.** Intenta crear `zona/a/b` cuando `zona/a` no existe:
   ```bash
   mkdir zona/a/b
   ```
   ```text
   mkdir: cannot create directory ‘zona/a/b’: No such file or directory
   ```
   Con `-p` crea todas las que falten. `ls -R` lista una carpeta y, dentro, todas sus subcarpetas:
   ```bash
   mkdir -p zona/a/b
   ls -R zona
   ```
   ```text
   zona:
   a

   zona/a:
   b

   zona/a/b:
   ```

2. **Archivo vacío con `touch`:**
   ```bash
   touch zona/a/nota.txt
   ls -l zona/a
   ```
   Algo como:
   ```text
   total 4
   drwxr-xr-x 2 alumno alumno 4096 Nov  8 04:33 b
   -rw-r--r-- 1 alumno alumno    0 Nov  8 04:33 nota.txt
   ```
   Tamaño `0`: el archivo existe, pero está vacío.

3. **Copiar un archivo dentro de una carpeta.** Como `zona/a/b/` es una carpeta que existe, la copia entra dentro con el mismo nombre:
   ```bash
   cp zona/a/nota.txt zona/a/b/
   ls zona/a/b
   ```
   ```text
   nota.txt
   ```

4. **Copiar una carpeta.** Sin `-r` (*recursive*), `cp` se niega:
   ```bash
   cp zona/a zona/c
   ```
   ```text
   cp: -r not specified; omitting directory 'zona/a'
   ```
   Con `-r` copia la carpeta y todo lo que tiene dentro. `zona/c` no existía, así que la copia se llama `c`:
   ```bash
   cp -r zona/a zona/c
   ls -R zona/c
   ```
   ```text
   zona/c:
   b  nota.txt

   zona/c/b:
   nota.txt
   ```

5. **Renombrar con `mv`:**
   ```bash
   mv zona/c/nota.txt zona/c/renombrada.txt
   ls zona/c
   ```
   ```text
   b  renombrada.txt
   ```

6. **El peligro: sobrescribir.** `echo uno > zona/x.txt` crea `x.txt` con el texto `uno` (el `>` lo viste en la teoría). Crea dos archivos y mueve uno encima del otro:
   ```bash
   echo uno > zona/x.txt
   echo dos > zona/y.txt
   mv zona/x.txt zona/y.txt
   cat zona/y.txt
   ls zona
   ```
   ```text
   uno
   a  c  y.txt
   ```
   El `dos` se perdió sin ningún aviso. Con `-i`, `mv` pregunta antes:
   ```bash
   mv -i zona/c/renombrada.txt zona/a/nota.txt
   ```
   ```text
   mv: overwrite 'zona/a/nota.txt'?
   ```
   Escribe `n` y pulsa `Enter`: no se mueve nada.

7. **Limpia antes del script:**
   ```bash
   rm -r zona
   ```
   (sin salida). Borra `zona/` entera; el lab 05 explica `rm` con calma.

8. **El script, sin tocar.** `starter/build-office.sh` empieza con dos protecciones ya escritas: sale si no estás en la carpeta del lab y rehace `zona/` desde cero en cada ejecución.
   ```bash
   bash starter/build-office.sh
   ```
   ```text
   zona:
   ```
   `zona/` existe pero está vacía. Prueba la protección desde otra carpeta:
   ```bash
   cd /tmp
   bash /bc-bash/bootcamp/week-01-terminal_y_sistema_de_archivos/2-practicas/lab-04-crear-copiar-y-mover/starter/build-office.sh
   cd -
   ```
   ```text
   ls: cannot access 'starter': No such file or directory
   /bc-bash/bootcamp/week-01-terminal_y_sistema_de_archivos/2-practicas/lab-04-crear-copiar-y-mover
   ```
   En `/tmp` no hay `starter/`: el script salió sin crear ni borrar nada.

9. **TODO 1.** Abre `starter/build-office.sh` en tu editor. Un solo `mkdir -p` con dos rutas: `zona/oficina/docs` y `zona/oficina/archivo`. Prueba con `bash starter/build-office.sh`: la salida empieza por `zona:` / `oficina` y lista `archivo  docs`.

10. **TODO 2.** `touch zona/oficina/docs/acta.txt`. Prueba: bajo `zona/oficina/docs:` aparece `acta.txt`.

11. **TODO 3.** Copia `starter/plantilla.txt` a `zona/oficina/docs/informe.txt` (aquí el destino no es una carpeta: es el nombre nuevo). Prueba: bajo `zona/oficina/docs:` aparecen `acta.txt  informe.txt`.

12. **TODO 4.** Copia la carpeta `zona/oficina/docs` entera a `zona/oficina/docs-copia` (necesitas `-r`). Prueba: aparece `zona/oficina/docs-copia:` con los mismos dos archivos.

13. **TODO 5.** Renombra `zona/oficina/docs-copia/acta.txt` a `zona/oficina/docs-copia/acta-2025.txt`. Prueba: en `docs-copia` aparece `acta-2025.txt  informe.txt`.

14. **TODO 6.** Mueve `zona/oficina/docs-copia` a `zona/oficina/archivo`. Como `archivo` es una carpeta que existe, `docs-copia` entra **dentro**. Borra los comentarios `TODO`. Prueba:
    ```bash
    bash starter/build-office.sh
    ```
    ```text
    zona:
    oficina

    zona/oficina:
    archivo  docs

    zona/oficina/archivo:
    docs-copia

    zona/oficina/archivo/docs-copia:
    acta-2025.txt  informe.txt

    zona/oficina/docs:
    acta.txt  informe.txt
    ```

15. **Comprueba el contenido:**
    ```bash
    cat zona/oficina/archivo/docs-copia/informe.txt
    ```
    ```text
    Informe semanal
    ===============
    Responsable:
    Resumen:
    ```

## Criterios de éxito

- [ ] Explicas qué hace `-p` en `mkdir` y `-r` en `cp` (pasos 1 y 4)
- [ ] Viste cómo `mv` perdió `dos` sin avisar y cómo `-i` lo evita (paso 6)
- [ ] `bash starter/build-office.sh` imprime el árbol del paso 14
- [ ] Explicas por qué en el TODO 3 el destino es un nombre de archivo y en el TODO 6 es una carpeta

## Reto extra

Repite el TODO 6 con `mv zona/oficina/docs-copia zona/oficina/historico` (una carpeta que **no** existe). ¿Qué cambia en el árbol y por qué?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 03 — Listar y mirar archivos](../lab-03-listar-y-mirar-archivos/README.md) | [Lab 05 — Borrar sin sustos](../lab-05-borrar-sin-sustos/README.md) → |

[↑ Semana 01](../../README.md)
