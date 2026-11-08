# Lab 05 — Borrar sin sustos

⏱ Duración estimada: ~60 min

## Objetivo

Borrar archivos y carpetas con `rm`, `rmdir` y `rm -r`, comprobando siempre antes qué vas a borrar.

## Contexto

- `rm` no tiene papelera: lo que borra no vuelve ([teoría](../../1-teoria/03-crear-copiar-mover-borrar.md#rm-no-tiene-papelera)).
- `starter/prepare.sh` (ya completo) crea en `zona/` unos archivos de prueba. Lo puedes ejecutar tantas veces como quieras: cada vez rehace `zona/` desde cero.
- El método en tres pasos: `pwd` (dónde estoy), `ls` con la misma ruta (qué voy a borrar), y entonces `rm`.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-01-terminal_y_sistema_de_archivos/2-practicas/lab-05-borrar-sin-sustos
   ```

1. **Prepara los archivos de prueba:**
   ```bash
   bash starter/prepare.sh
   ls zona
   ```
   ```text
   'copia de seguridad.txt'   informe-borrador.txt   vacia
    fotos-viejas              informe-final.txt
   ```
   `ls` pone entre comillas el nombre con espacios para que se vea dónde empieza y dónde termina. Con `ls -l zona` distingues qué es carpeta (`d`) y qué archivo (`-`).

2. **`rm -i` pregunta antes de borrar.** Responde `n`:
   ```bash
   rm -i zona/informe-borrador.txt
   ```
   ```text
   rm: remove regular empty file 'zona/informe-borrador.txt'?
   ```
   Escribe `n` y `Enter`. Comprueba con `ls zona` que sigue ahí.

3. **`rmdir` solo borra carpetas vacías.** Con una que tiene archivos, se niega:
   ```bash
   rmdir zona/fotos-viejas
   ```
   ```text
   rmdir: failed to remove 'zona/fotos-viejas': Directory not empty
   ```
   Esa negativa es útil: si alguien dejó algo dentro, no lo pierdes. `rm` a secas tampoco borra carpetas:
   ```bash
   rm zona/fotos-viejas
   ```
   ```text
   rm: cannot remove 'zona/fotos-viejas': Is a directory
   ```

4. **Mira antes de `rm -r`.** `rm -r` borraría la carpeta con todo lo que tenga dentro, sin preguntar. Antes, mira qué hay:
   ```bash
   ls -R zona/fotos-viejas
   ```
   ```text
   zona/fotos-viejas:
   monte.jpg  playa.jpg
   ```
   Todavía no la borres: lo hará el script.

5. **Nombres con espacios.** Sin comillas, `rm` recibe tres nombres distintos:
   ```bash
   rm zona/copia de seguridad.txt
   ```
   ```text
   rm: cannot remove 'zona/copia': No such file or directory
   rm: cannot remove 'de': No such file or directory
   rm: cannot remove 'seguridad.txt': No such file or directory
   ```
   Esta vez no pasó nada porque ninguno de esos tres existe. Si hubiera un archivo llamado `de` en la carpeta, lo habrías borrado. Con comillas es un solo nombre. Escribe `rm zona/co` y pulsa `Tab`: bash completa el nombre y pone `\` delante de cada espacio, que es otra forma de decir "este espacio es parte del nombre". No pulses `Enter`; borra la línea con `Ctrl+U`.

6. **El script, sin tocar.** `starter/cleanup.sh` llama primero a `prepare.sh`, así que siempre parte de la misma `zona/`:
   ```bash
   bash starter/cleanup.sh
   ```
   ```text
   'copia de seguridad.txt'   informe-borrador.txt   vacia
    fotos-viejas              informe-final.txt
   ```

7. **TODO 1.** Abre `starter/cleanup.sh` en tu editor. `rm` sobre `zona/informe-borrador.txt` (sin `-i`: en un script nadie responde). Prueba con `bash starter/cleanup.sh`: `informe-borrador.txt` ya no aparece.

8. **TODO 2.** `rmdir zona/vacia`. Prueba: `vacia` ya no aparece.

9. **TODO 3.** `rm -rv zona/fotos-viejas`. `-v` (*verbose*) imprime cada cosa que borra. Prueba: aparecen tres líneas `removed ...` antes del listado.

10. **TODO 4.** `rm` con el nombre entre comillas dobles: `"zona/copia de seguridad.txt"`. Borra los comentarios `TODO`. Prueba:
    ```bash
    bash starter/cleanup.sh
    ```
    ```text
    removed 'zona/fotos-viejas/playa.jpg'
    removed 'zona/fotos-viejas/monte.jpg'
    removed directory 'zona/fotos-viejas'
    informe-final.txt
    ```
    El orden de `playa.jpg` y `monte.jpg` puede variar: `rm -r` los borra en el orden en que están guardados en el disco.

11. **Limpieza final:**
    ```bash
    rm -r zona
    ls
    ```
    ```text
    README.md  solucion  starter
    ```

## Criterios de éxito

- [ ] Respondiste `n` a `rm -i` y el archivo siguió ahí (paso 2)
- [ ] Explicas por qué `rmdir` es más seguro que `rm -r` para carpetas que deberían estar vacías (paso 3)
- [ ] Explicas los tres errores de `rm` sin comillas (paso 5)
- [ ] `bash starter/cleanup.sh` termina listando solo `informe-final.txt` (paso 10)

## Reto extra

Ejecuta `bash starter/prepare.sh` y luego `rm -ri zona`. ¿Cuántas preguntas hace y en qué orden? ¿Qué pasa si respondes `n` a una carpeta y `y` a lo de dentro?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 04 — Crear, copiar y mover](../lab-04-crear-copiar-y-mover/README.md) | [Lab 06 — Pedir ayuda](../lab-06-pedir-ayuda/README.md) → |

[↑ Semana 01](../../README.md)
