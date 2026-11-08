# Lab 03 — Listar y mirar archivos

⏱ Duración estimada: ~60 min

## Objetivo

Inspeccionar una carpeta desconocida con `ls`, `cat`, `less` y `file` sin modificar nada.

## Contexto

- Te dejan una carpeta, `starter/inbox`, y tienes que contar qué hay dentro antes de tocar nada.
- Los archivos cuyo nombre empieza por punto están ocultos ([teoría](../../1-teoria/02-sistema-de-archivos-y-rutas.md#archivos-ocultos)).
- La extensión (`.txt`, `.jpg`) es parte del nombre y nada más: no garantiza qué hay dentro.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-01-terminal_y_sistema_de_archivos/2-practicas/lab-03-listar-y-mirar-archivos
   ```

1. **Lista simple:**
   ```bash
   ls starter/inbox
   ```
   ```text
   estado.csv  foto.jpg  leeme.txt
   ```

2. **Lista larga.** `-l` añade detalles:
   ```bash
   ls -l starter/inbox
   ```
   Algo como (cambian la fecha y la hora):
   ```text
   total 12
   -rw-r--r-- 1 alumno alumno 61 Nov  8 04:29 estado.csv
   -rw-r--r-- 1 alumno alumno 51 Nov  8 04:29 foto.jpg
   -rw-r--r-- 1 alumno alumno 78 Nov  8 04:29 leeme.txt
   ```
   | Columna | Ejemplo | Qué es |
   |---|---|---|
   | 1 | `-rw-r--r--` | tipo (`-` archivo, `d` carpeta) y permisos (semana 02) |
   | 3 y 4 | `alumno alumno` | usuario y grupo dueños |
   | 5 | `61` | tamaño en bytes (un byte ≈ un carácter en texto simple) |
   | 6 a 8 | `Nov  8 04:29` | última modificación |
   | 9 | `estado.csv` | nombre |

3. **Los ocultos.** `-a` (*all*) muestra también lo que empieza por punto:
   ```bash
   ls -a starter/inbox
   ```
   ```text
   .  ..  .nota-oculta  estado.csv  foto.jpg  leeme.txt
   ```
   Aparecen `.` (la propia carpeta), `..` (la de arriba) y `.nota-oculta`, que el paso 1 no mostraba.

4. **La carpeta, no su contenido.** `-d` lista la carpeta en sí. Sirve para ver sus detalles:
   ```bash
   ls -ld starter/inbox
   ```
   ```text
   drwxr-xr-x 2 alumno alumno 4096 Nov  8 04:29 starter/inbox
   ```
   La `d` del principio dice que es una carpeta.

5. **Leer un archivo de texto.** `cat` lo imprime entero:
   ```bash
   cat starter/inbox/estado.csv
   cat starter/inbox/.nota-oculta
   ```
   ```text
   fecha,servidor,estado
   2026-11-01,web01,ok
   2026-11-01,db01,ok
   Si me ves, usaste ls -a.
   ```

6. **Archivos largos: `less`.** `cat` vuelca todo de golpe; con un archivo de miles de líneas solo verías el final. `less` lo abre a pantalla completa y lo recorres con las mismas teclas que `man` (flechas, `Espacio`, `/` para buscar, `q` para salir). Pruébalo con un archivo largo del sistema:
   ```bash
   less /etc/services
   ```
   Baja con `Espacio`, busca `/http` + `Enter`, pulsa `n` para la siguiente aparición y sal con `q`.

7. **Qué es cada archivo de verdad.** `file` mira el **contenido** y dice de qué tipo es:
   ```bash
   file starter/inbox/leeme.txt starter/inbox/estado.csv starter/inbox/foto.jpg
   ```
   ```text
   starter/inbox/leeme.txt:  ASCII text
   starter/inbox/estado.csv: CSV ASCII text
   starter/inbox/foto.jpg:   Unicode text, UTF-8 text
   ```
   `foto.jpg` es texto, no una imagen. `UTF-8` quiere decir que tiene caracteres fuera del inglés básico (como la `ó` de `extensión`). Compruébalo con `cat starter/inbox/foto.jpg`.

8. **El script, sin tocar.**
   ```bash
   bash starter/inspect.sh
   ```
   ```text
   == todo, también lo oculto ==
   == leeme.txt ==
   == qué es foto.jpg ==
   sin implementar
   ```

9. **TODO 1.** Abre `starter/inspect.sh` en tu editor. Debajo del `TODO 1`: `ls` con la opción que muestra los ocultos, sobre `starter/inbox`. Prueba: tras la primera cabecera aparece `.  ..  .nota-oculta  estado.csv  foto.jpg  leeme.txt`.

10. **TODO 2.** `cat` de `starter/inbox/leeme.txt`. Prueba: tras la segunda cabecera aparecen las dos líneas de bienvenida.

11. **TODO 3.** `file` sobre `starter/inbox/foto.jpg`. Borra `echo "sin implementar"` y los comentarios `TODO`. Prueba:
    ```bash
    bash starter/inspect.sh
    ```
    ```text
    == todo, también lo oculto ==
    .  ..  .nota-oculta  estado.csv  foto.jpg  leeme.txt
    == leeme.txt ==
    Bienvenida al equipo de operaciones.
    Tu primer encargo: revisar esta carpeta.
    == qué es foto.jpg ==
    starter/inbox/foto.jpg: Unicode text, UTF-8 text
    ```

## Criterios de éxito

- [ ] Sabes leer en `ls -l` el tipo, el tamaño y el nombre de cada elemento (paso 2)
- [ ] Encontraste `.nota-oculta` y leíste su contenido (pasos 3 y 5)
- [ ] Saliste de `less` con `q` después de buscar una palabra (paso 6)
- [ ] `bash starter/inspect.sh` imprime lo del paso 11
- [ ] Explicas por qué `foto.jpg` no es una imagen aunque lo diga su nombre (paso 7)

## Reto extra

`ls -lh` muestra los tamaños en K, M o G en vez de en bytes. Prueba `ls -lhSr /usr/bin`: `-S` ordena por tamaño (lo verás en el lab 06) y `-r` invierte el orden, así el más grande queda al final, junto al prompt. ¿Cuál es el programa más grande del laboratorio?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 02 — Moverse con cd, Tab e historial](../lab-02-moverse-con-cd-tab-e-historial/README.md) | [Lab 04 — Crear, copiar y mover](../lab-04-crear-copiar-y-mover/README.md) → |

[↑ Semana 01](../../README.md)
