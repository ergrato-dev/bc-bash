# Lab 07 — Buscar con find

⏱ Duración estimada: ~60 min

## Objetivo

Encontrar archivos y carpetas por nombre y por tipo con `find`, y guardar el resultado en un archivo con `>`.

## Contexto

- `find RUTA FILTROS` recorre la carpeta `RUTA` y todo lo que hay debajo, e imprime lo que cumple los filtros ([teoría](../../1-teoria/03-crear-copiar-mover-borrar.md#buscar-con-find)).
- En `starter/web` tienes una web pequeña: dos páginas `.html`, una hoja de estilos, un script y una carpeta de imágenes.
- `find` es la herramienta del proyecto de esta semana: con ella generarás el inventario de `bashkit`.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-01-terminal_y_sistema_de_archivos/2-practicas/lab-07-buscar-con-find
   ```

1. **Sin filtros, `find` lo lista todo:**
   ```bash
   find starter/web
   ```
   Algo como (el orden puede variar):
   ```text
   starter/web
   starter/web/index.html
   starter/web/js
   starter/web/js/app.js
   starter/web/contacto.html
   starter/web/img
   starter/web/img/PENDIENTE.txt
   starter/web/css
   starter/web/css/estilos.css
   ```
   A diferencia de `ls`, imprime la ruta completa de cada cosa (desde donde empezaste) y entra en todas las subcarpetas. El orden no es alfabético: es el de cómo están guardados en el disco.

2. **Solo archivos o solo carpetas.** `-type f` (*file*) y `-type d` (*directory*):
   ```bash
   find starter/web -type f
   find starter/web -type d
   ```
   Algo como:
   ```text
   starter/web/index.html
   starter/web/js/app.js
   starter/web/contacto.html
   starter/web/img/PENDIENTE.txt
   starter/web/css/estilos.css
   starter/web
   starter/web/js
   starter/web/img
   starter/web/css
   ```

3. **Por nombre exacto:**
   ```bash
   find starter/web -name app.js
   ```
   ```text
   starter/web/js/app.js
   ```
   No hace falta saber en qué subcarpeta está: `find` la busca.

4. **Por patrón.** `*` significa "cualquier cosa": `'*.html'` es todo lo que termina en `.html`. Las comillas simples hacen que el `*` le llegue a `find` sin que bash lo toque:
   ```bash
   find starter/web -name '*.html'
   ```
   Algo como (el orden puede variar):
   ```text
   starter/web/index.html
   starter/web/contacto.html
   ```

5. **Mayúsculas.** `-name` distingue mayúsculas; `-iname` no:
   ```bash
   find starter/web -name '*.HTML'
   find starter/web -iname '*.txt'
   ```
   ```text
   starter/web/img/PENDIENTE.txt
   ```
   El primero no imprime nada: ningún nombre termina en `.HTML` en mayúsculas.

6. **Errores de `find`:**
   ```bash
   find starter/noexiste
   ```
   ```text
   find: ‘starter/noexiste’: No such file or directory
   ```

7. **Guardar en un archivo.** `>` manda la salida a un archivo en vez de a la pantalla. Si el archivo existe, lo reemplaza entero:
   ```bash
   mkdir -p zona
   find starter/web -type d > zona/carpetas.txt
   cat zona/carpetas.txt
   ```
   El primer `find` no imprime nada en pantalla: todo fue al archivo. `cat` muestra las cuatro carpetas del paso 2.

8. **El script, sin tocar:**
   ```bash
   bash starter/find-files.sh
   ```
   ```text
   == hojas de estilo ==
   == carpetas ==
   == páginas, guardadas en zona/paginas.txt ==
   cat: zona/paginas.txt: No such file or directory
   ```
   El error es normal: nadie ha creado todavía `zona/paginas.txt`.

9. **TODO 1.** Abre `starter/find-files.sh` en tu editor. `find` en `starter/web` con `-name '*.css'`. Prueba con `bash starter/find-files.sh`: tras la primera cabecera aparece `starter/web/css/estilos.css`.

10. **TODO 2.** `find` en `starter/web` con `-type d`. Prueba: tras la segunda cabecera aparecen las cuatro carpetas.

11. **TODO 3.** Combina dos filtros: `-type f -name '*.html'`, y manda la salida a `zona/paginas.txt` con `>`. La línea `cat zona/paginas.txt` que ya está en el script la muestra. Borra los comentarios `TODO`. Prueba:
    ```bash
    bash starter/find-files.sh
    ```
    Algo como (el orden dentro de cada bloque puede variar):
    ```text
    == hojas de estilo ==
    starter/web/css/estilos.css
    == carpetas ==
    starter/web
    starter/web/js
    starter/web/img
    starter/web/css
    == páginas, guardadas en zona/paginas.txt ==
    starter/web/index.html
    starter/web/contacto.html
    ```

12. **Limpieza:**
    ```bash
    rm -r zona
    ```
    (sin salida).

## Criterios de éxito

- [ ] Explicas la diferencia entre `find starter/web` y `ls starter/web` (paso 1)
- [ ] Filtraste por tipo, por nombre exacto y por patrón (pasos 2 a 4)
- [ ] Explicas por qué `-name '*.HTML'` no encontró nada (paso 5)
- [ ] `bash starter/find-files.sh` imprime lo del paso 11, sin el error de `cat`

## Reto extra

Desde la raíz del repositorio (`cd /bc-bash`), usa `find` para contestar: ¿cuántos archivos `.svg` tiene la semana 01? ¿Y en qué carpeta están? Pista: `find bootcamp/week-01-terminal_y_sistema_de_archivos -name '*.svg'`.

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 06 — Pedir ayuda](../lab-06-pedir-ayuda/README.md) | [Proyecto — El esqueleto de bashkit](../../3-proyecto/README.md) → |

[↑ Semana 01](../../README.md)
