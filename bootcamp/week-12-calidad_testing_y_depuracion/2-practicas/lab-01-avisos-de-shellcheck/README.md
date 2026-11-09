# Lab 01 — Los avisos de shellcheck

⏱ Duración estimada: ~60 min

## Objetivo

Leer los avisos de shellcheck (código, gravedad y posición), arreglar los de un script roto y callar con un motivo el único que no es un fallo.

## Contexto

- **shellcheck** lee un script sin ejecutarlo y avisa de los fallos típicos: variables sin comillas, un `for` sobre `ls`, un `local` que esconde un error. Cada aviso tiene un código (`SC2086`) con su página en el wiki de shellcheck, que explica el porqué y cómo arreglarlo.
- `starter/archive-reports.sh` copia los `.txt` de una carpeta a otra y apunta cada copia en `copias.log`. Está **roto a propósito**: con nombres sin espacios funciona, y con los demás no.
- `datos/informes/` tiene tres archivos: `enero 2026.txt` (con un espacio), `febrero.txt` y `notas.md`.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-12-calidad_testing_y_depuracion/2-practicas/lab-01-avisos-de-shellcheck
   ```
   (sin salida).

1. **El script, tal cual.** Abre `starter/archive-reports.sh` en tu editor.
   ```bash
   ls datos/informes
   bash starter/archive-reports.sh datos/informes archivo; echo $?
   ls archivo
   ```
   ```text
   enero 2026.txt
   febrero.txt
   notas.md
   cp: cannot stat 'datos/informes/2026.txt': No such file or directory
   1
   ```
   `ls archivo` no enseña nada: no copió ni `febrero.txt`. `$(ls $src)` parte `enero 2026.txt` en dos palabras, `enero` y `2026.txt`, y la segunda no existe.

2. **Todos los avisos.**
   ```bash
   shellcheck starter/archive-reports.sh; echo $?
   ```
   Tres trozos (la salida entera tiene unas 50 líneas):
   ```text

   In starter/archive-reports.sh line 7:
     echo 'uso: archive-reports.sh <carpeta> <destino>   (ejemplo: archive-reports.sh "$HOME/informes" archivo)' >&2
          ^-- SC2016 (info): Expressions don't expand in single quotes, use double quotes for that.


   In starter/archive-reports.sh line 14:
     local stamp=$(date +%T)
           ^---^ SC2155 (warning): Declare and assign separately to avoid masking return values.
   ```
   ```text
   In starter/archive-reports.sh line 20:
   for f in $(ls $src); do
            ^--------^ SC2045 (error): Iterating over ls output is fragile. Use globs.
                 ^--^ SC2086 (info): Double quote to prevent globbing and word splitting.

   Did you mean: 
   for f in $(ls "$src"); do
   ```
   ```text
   For more information:
     https://www.shellcheck.net/wiki/SC2045 -- Iterating over ls output is fragi...
     https://www.shellcheck.net/wiki/SC2155 -- Declare and assign separately to ...
     https://www.shellcheck.net/wiki/SC2016 -- Expressions don't expand in singl...
   1
   ```
   Cada aviso dice la línea, señala con `^--^` dónde está el problema y da su código y su **gravedad**: `error` (casi seguro un fallo), `warning` (probablemente un fallo), `info` y `style` (buenas costumbres). Sale con `1` si hay algún aviso. `Did you mean:` propone un arreglo, pero no siempre es el bueno: aquí citar `"$src"` no arregla el `for` sobre `ls`.

3. **Una línea por aviso.** `-f gcc` (*format*) escribe cada aviso en una línea, `archivo:línea:columna: gravedad: texto [código]`, el formato de los compiladores. `-S warning` (*severity*) enseña solo de `warning` para arriba:
   ```bash
   shellcheck -f gcc starter/archive-reports.sh
   shellcheck -S warning -f gcc starter/archive-reports.sh
   ```
   ```text
   starter/archive-reports.sh:7:8: note: Expressions don't expand in single quotes, use double quotes for that. [SC2016]
   starter/archive-reports.sh:14:9: warning: Declare and assign separately to avoid masking return values. [SC2155]
   starter/archive-reports.sh:18:10: note: Double quote to prevent globbing and word splitting. [SC2086]
   starter/archive-reports.sh:20:10: error: Iterating over ls output is fragile. Use globs. [SC2045]
   starter/archive-reports.sh:20:15: note: Double quote to prevent globbing and word splitting. [SC2086]
   starter/archive-reports.sh:22:6: note: Double quote to prevent globbing and word splitting. [SC2086]
   starter/archive-reports.sh:22:11: note: Double quote to prevent globbing and word splitting. [SC2086]
   starter/archive-reports.sh:22:14: note: Double quote to prevent globbing and word splitting. [SC2086]
   starter/archive-reports.sh:26:4: note: Double quote to prevent globbing and word splitting. [SC2086]
   starter/archive-reports.sh:14:9: warning: Declare and assign separately to avoid masking return values. [SC2155]
   starter/archive-reports.sh:20:10: error: Iterating over ls output is fragile. Use globs. [SC2045]
   ```
   En este formato, `info` sale como `note`. Que un aviso sea `info` no quiere decir que no importe: el fallo del paso 1 es un `SC2086`.

4. **SC2045 y SC2086: un glob y comillas.** Cambia `src=$1` y `dest=$2` por `src="$1"` y `dest="$2"`, y todo lo que va desde `mkdir -p $dest` hasta el final por:
   ```bash
   mkdir -p "$dest"
   count=0
   # Un glob y no $(ls): cada nombre llega entero, con sus espacios (SC2045).
   for f in "$src"/*.txt; do
     # Sin ningún .txt, el glob se queda tal cual ("carpeta/*.txt"): -e lo descarta.
     [[ -e $f ]] || continue
     cp -- "$f" "$dest/"
     log_copy "${f##*/}"
     count=$((count + 1))
   done
   echo "copiados: $count"
   ```
   Sin el `cd`, `log_copy` tiene que escribir en el destino: cambia su `>> copias.log` por `>> "$dest/copias.log"`. `${f##*/}` es el nombre sin la carpeta (semana 05), y `--` evita que un archivo que empiece por `-` se lea como una opción de `cp` (semana 07). Prueba, también con una carpeta sin informes:
   ```bash
   shellcheck -f gcc starter/archive-reports.sh
   bash starter/archive-reports.sh datos/informes archivo
   cat archivo/copias.log
   mkdir vacia
   bash starter/archive-reports.sh vacia otro
   ls otro
   ```
   Algo como (cambian las horas):
   ```text
   starter/archive-reports.sh:7:8: note: Expressions don't expand in single quotes, use double quotes for that. [SC2016]
   starter/archive-reports.sh:14:9: warning: Declare and assign separately to avoid masking return values. [SC2155]
   copiados: 2
   03:23:10 enero 2026.txt
   03:23:10 febrero.txt
   copiados: 0
   ```
   `ls otro` no enseña nada. Sin el `[[ -e $f ]]`, el `cp` recibiría `vacia/*.txt` y fallaría: eso shellcheck no lo ve, porque depende de qué haya en la carpeta al ejecutar.

5. **SC2155: `local` en su línea.** Mira por qué importa:
   ```bash
   bash -c 'set -e; f() { local x=$(false); echo "sigue: $?"; }; f'
   bash -c 'set -e; f() { local x; x=$(false); echo nunca; }; f'; echo "código: $?"
   ```
   ```text
   sigue: 0
   código: 1
   ```
   En la primera, el código que ve `set -e` es el de `local`, que siempre es `0`: el fallo de `false` se pierde (semana 11). Cambia la línea de `local` de `log_copy` por:
   ```bash
     local stamp
     stamp="$(date +%T)"
   ```
   Prueba:
   ```bash
   shellcheck -f gcc starter/archive-reports.sh
   ```
   ```text
   starter/archive-reports.sh:7:8: note: Expressions don't expand in single quotes, use double quotes for that. [SC2016]
   ```

6. **SC2016: callarlo con un motivo.** Aquí las comillas simples son a propósito: el uso enseña `"$HOME/informes"` tal cual, como ejemplo, no tu carpeta. Un comentario `# shellcheck disable=SC2016` justo encima de una línea calla ese aviso solo en ella. Añade encima del `echo 'uso: ...'`:
   ```bash
     # $HOME va entre comillas simples a propósito: es un ejemplo para quien lo lee, no una ruta.
     # shellcheck disable=SC2016
   ```
   Prueba:
   ```bash
   shellcheck starter/archive-reports.sh; echo $?
   bash starter/archive-reports.sh; echo $?
   ```
   ```text
   0
   uso: archive-reports.sh <carpeta> <destino>   (ejemplo: archive-reports.sh "$HOME/informes" archivo)
   2
   ```
   Un `disable` sin motivo esconde un aviso que alguien tendrá que volver a pensar. Úsalo solo cuando sepas por qué el aviso no es un fallo, y escribe ese porqué.

7. **Limpieza.** Borra lo que crearon las pruebas:
   ```bash
   rm -r archivo vacia otro
   ```
   (sin salida).

## Criterios de éxito

- [ ] Explicas qué dicen el código, la gravedad y la columna de un aviso de `shellcheck -f gcc` (paso 3)
- [ ] `bash starter/archive-reports.sh datos/informes archivo` imprime `copiados: 2` (paso 4)
- [ ] Explicas por qué `local x=$(false)` no para el script con `set -e` (paso 5)
- [ ] El único `disable` del script tiene un comentario que dice por qué (paso 6)
- [ ] `shellcheck starter/archive-reports.sh` no imprime nada (paso 6)

## Reto extra

Busca en el wiki de shellcheck el aviso `SC2164` (un `cd` sin `|| exit`). Escribe un script de dos líneas, sin `set -e`, con un `cd` a una carpeta que no existe seguido de un `rm *.tmp`, y pásale shellcheck: ¿qué avisa? Añade `set -e` y vuelve a pasarlo: ¿por qué deja de avisar?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Índice de labs](../README.md) | [Lab 02 — Formato con shfmt](../lab-02-formato-con-shfmt/README.md) → |

[↑ Semana 12](../../README.md)
