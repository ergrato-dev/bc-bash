# Lab 06 — Dispatcher de subcomandos

⏱ Duración estimada: ~60 min

## Objetivo

Escribir un script con subcomandos (`notes.sh add`, `list`, `count`) que reparte cada uno a su función con un `case`.

## Contexto

- `git commit`, `docker compose up`, `apt install`: muchas herramientas son un solo comando con **subcomandos**. El primer argumento dice qué hacer y el resto son los argumentos de ese subcomando.
- El script que los reparte se llama **dispatcher**: un `case` sobre `$1` (semana 06), un `shift` para quitarlo y una función por subcomando, `cmd_<nombre>`.
- `starter/notes.sh` guarda notas rápidas en `notas.txt`, en la carpeta en la que estás (o en el archivo que diga la variable `NOTES_FILE`).

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-08-funciones_alcance_y_librerias/2-practicas/lab-06-dispatcher
   ```
   (sin salida).

1. **El script, tal cual.** Abre `starter/notes.sh` en tu editor: tiene `usage`, un borrador de cada `cmd_*` y un `main` sin hacer.
   ```bash
   bash starter/notes.sh add revisar backups
   ```
   ```text
   sin implementar: add revisar backups
   ```

2. **TODO 1: el `case`.** En `main`, borra el comentario del `TODO 1` y el `echo`, y escribe:
   ```bash
     case "${1:-}" in
       add)
         shift
         cmd_add "$@"
         ;;
       list) cmd_list ;;
       count) cmd_count ;;
       -h | --help) usage ;;
       *)
         usage >&2
         exit 2
         ;;
     esac
   ```
   En `add`, `shift` quita la palabra `add` de `"$@"`: a `cmd_add` le llega solo el texto de la nota. `*)` recoge todo lo demás, también nada (`${1:-}` vacío). Prueba:
   ```bash
   bash starter/notes.sh add revisar backups
   bash starter/notes.sh borrar; echo $?
   bash starter/notes.sh > /dev/null; echo $?
   bash starter/notes.sh -h; echo $?
   ```
   ```text
   sin implementar: add revisar backups
   uso: notes.sh add <texto> | list | count
   2
   uso: notes.sh add <texto> | list | count
   2
   uso: notes.sh add <texto> | list | count
   0
   ```
   El primero ya llega a `cmd_add`, que es un borrador. `borrar` y nada dan el uso en stderr con código `2` (por eso sale aunque tires stdout); `-h`, en stdout con `0`.

3. **TODO 2: `cmd_add`.** Borra el comentario del `TODO 2` y el `echo`, y escribe:
   ```bash
     [[ $# -gt 0 ]] || { usage >&2; exit 2; }
     echo "$*" >> "$notes_file"
   ```
   `{ ...; }` agrupa dos comandos detrás de `||`. `"$*"` junta los argumentos con un espacio: `add revisar backups` guarda `revisar backups`. Prueba:
   ```bash
   bash starter/notes.sh add revisar backups
   bash starter/notes.sh add "subir  la versión de nginx"
   cat notas.txt
   bash starter/notes.sh add; echo $?
   ```
   ```text
   revisar backups
   subir  la versión de nginx
   uso: notes.sh add <texto> | list | count
   2
   ```
   Entre comillas, los dos espacios de la segunda nota llegan intactos.

4. **TODO 3: `cmd_list`.** Borra el comentario del `TODO 3` y el `echo`, y escribe:
   ```bash
     [[ -f $notes_file ]] || return 0
     local n=0 line
     while IFS= read -r line; do
       n=$((n + 1))
       echo "$n. $line"
     done < "$notes_file"
   ```
   Si todavía no hay notas, el archivo no existe: `return 0` sale de la función sin error, con la lista vacía. Prueba, también con otro archivo:
   ```bash
   bash starter/notes.sh list
   bash starter/notes.sh count
   NOTES_FILE=otra.txt bash starter/notes.sh list
   NOTES_FILE=otra.txt bash starter/notes.sh count
   ```
   ```text
   1. revisar backups
   2. subir  la versión de nginx
   2
   0
   ```
   `cmd_count` ya estaba escrita: `cmd_list | wc -l`. Una función reutiliza a otra como a cualquier comando. Con `otra.txt`, `list` no imprime nada y `count` dice `0`.

5. **Limpieza y shellcheck.**
   ```bash
   rm notas.txt
   shellcheck starter/notes.sh; echo $?
   ```
   ```text
   0
   ```

## Criterios de éxito

- [ ] Explicas por qué `add` lleva `shift` y `list` no
- [ ] Explicas por qué `bash starter/notes.sh > /dev/null` imprimió el uso igualmente
- [ ] `add`, `list` y `count` funcionan como en los pasos 3 y 4, y un subcomando desconocido sale con `2`
- [ ] `shellcheck starter/notes.sh` no imprime nada

## Reto extra

Añade un subcomando `clear` que borre el archivo de notas. ¿Cuántos sitios del script tienes que tocar? Luego cambia el `case` por `declare -F "cmd_$1" > /dev/null && "cmd_$@"`: `declare -F nombre` sale con `0` si existe esa función. ¿Qué pierdes y qué ganas?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 05 — source y librerías](../lab-05-source-y-librerias/README.md) | [Lab 07 — Funciones rotas](../lab-07-funciones-rotas/README.md) → |

[↑ Semana 08](../../README.md)
