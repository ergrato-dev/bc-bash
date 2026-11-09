# Lab 02 — Formato con shfmt

⏱ Duración estimada: ~60 min

## Objetivo

Ver qué cambiaría shfmt en un script con `-d`, elegir el estilo con sus opciones o con un `.editorconfig` y aplicarlo con `-w` sin cambiar lo que hace el script.

## Contexto

- Un script que escriben varias personas acaba con varios estilos: tabuladores y espacios, `;then` y `then` en otra línea, un `case` sangrado y otro no. Funciona, pero cuesta leerlo, y cada cambio de estilo ensucia los diffs.
- **shfmt** lee un script y lo vuelve a escribir con un estilo fijo. Solo cambia espacios, saltos de línea y sangrías: nunca lo que hace el script. Y como tiene que entender el script para escribirlo, también avisa de los errores de sintaxis.
- `starter/rotate-logs.sh` guarda una copia numerada de cada log de una carpeta (`app.log` pasa a `app.log.1`, la `.1` a `.2`...) y lo deja vacío. Funciona, pero con cuatro estilos mezclados.

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-12-calidad_testing_y_depuracion/2-practicas/lab-02-formato-con-shfmt
   ```
   (sin salida).

1. **El script, tal cual.** Abre `starter/rotate-logs.sh` en tu editor y fíjate en las sangrías: unas con tabuladores, otras con cuatro espacios, otras sin nada. Pruébalo con una carpeta de logs, dos veces:
   ```bash
   mkdir logs
   echo "linea 1" > logs/app.log
   : > logs/error.log
   bash starter/rotate-logs.sh logs
   echo "linea 2" > logs/app.log
   bash starter/rotate-logs.sh logs
   ls logs
   cat logs/app.log.2
   ```
   ```text
   rotado: app.log
   vacío, no se rota: error.log
   rotado: app.log
   vacío, no se rota: error.log
   app.log
   app.log.1
   app.log.2
   error.log
   linea 1
   ```
   `: > archivo` deja un archivo vacío (`:` es un comando que no hace nada). La primera línea que escribiste ya va por la copia `.2`.

2. **Qué cambiaría: `-d`.** `-d` (*diff*) no toca el archivo: enseña qué cambiaría, como un diff. Las líneas con `-` son las de ahora; las de `+`, como las dejaría.
   ```bash
   shfmt -d starter/rotate-logs.sh; echo "código: $?"
   ```
   El principio (son unas 50 líneas):
   ```text
   --- starter/rotate-logs.sh.orig
   +++ starter/rotate-logs.sh
   @@ -5,27 +5,31 @@
    set -euo pipefail
    
    keep=${2:-3}
   -if [[ $# -lt 1 ]];then echo "uso: rotate-logs.sh <carpeta> [copias]" >&2;exit 2;fi
   +if [[ $# -lt 1 ]]; then
   +	echo "uso: rotate-logs.sh <carpeta> [copias]" >&2
   +	exit 2
   +fi
    dir="$1"
   ```
   El final es `código: 1`: hay cambios. Sin opciones, shfmt sangra con tabuladores. `@@ -5,27 +5,31 @@` dice que el trozo empieza en la línea 5 y pasa de 27 líneas a 31.

3. **El estilo, con opciones.** `-i 2` (*indent*): dos espacios en lugar de un tabulador. `-ci` (*case indent*): los casos de un `case` sangrados. `-sr` (*space redirects*): un espacio detrás de `>` y `<`. Es el estilo de los scripts de este bootcamp.
   ```bash
   shfmt -i 2 -ci -sr -d starter/rotate-logs.sh | tail -n 16
   ```
   ```text
    for log in "$dir"/*.log; do
   -[[ -e $log ]] || continue
   -case "$(wc -c <"$log")" in
   -0) echo "vacío, no se rota: ${log##*/}";;
   -*) rotate "$log"
   -   echo "rotado: ${log##*/}";;
   -esac
   +  [[ -e $log ]] || continue
   +  case "$(wc -c < "$log")" in
   +    0) echo "vacío, no se rota: ${log##*/}" ;;
   +    *)
   +      rotate "$log"
   +      echo "rotado: ${log##*/}"
   +      ;;
   +  esac
    done
   ```
   Un caso de una línea se queda en una línea; uno de dos, se abre en tres con el `;;` aparte.

4. **Qué archivos: `-l`.** `-l` (*list*) escribe solo los nombres de los archivos que cambiaría. Con una carpeta llena de scripts, es lo primero que miras:
   ```bash
   shfmt -l -i 2 -ci -sr starter/rotate-logs.sh; echo "código: $?"
   ```
   ```text
   starter/rotate-logs.sh
   código: 0
   ```
   Ojo: `-l` sale con `0` aunque haya archivos por cambiar. Para un script o un CI que tiene que fallar, usa `-d`, que sale con `1`.

5. **Aplicarlo: `-w`.** `-w` (*write*) reescribe el archivo con el estilo. Prueba que ya no hay nada que cambiar y que el script hace lo mismo que antes:
   ```bash
   shfmt -i 2 -ci -sr -w starter/rotate-logs.sh
   shfmt -i 2 -ci -sr -d starter/rotate-logs.sh; echo "código: $?"
   echo "linea 3" > logs/app.log
   bash starter/rotate-logs.sh logs
   cat logs/app.log.3
   ```
   ```text
   código: 0
   rotado: app.log
   vacío, no se rota: error.log
   linea 1
   ```
   Abre `starter/rotate-logs.sh` en tu editor: todo sangrado con dos espacios, un `then` por `if`, cada caso de `case` en su sitio.

6. **Errores de sintaxis.** Crea un script al que le falta el `fi` y compáralo con `bash -n`, que lee un script sin ejecutarlo y solo avisa de la sintaxis:
   ```bash
   printf 'if true; then\n  echo hola\n' > roto.sh
   shfmt -d roto.sh; echo "código: $?"
   bash -n roto.sh; echo "código: $?"
   ```
   ```text
   roto.sh:1:1: if statement must end with "fi"
   código: 1
   roto.sh: line 3: syntax error: unexpected end of file
   código: 2
   ```
   shfmt dice dónde empieza el `if` que no termina (línea 1, columna 1); bash solo dice que el archivo se acabó antes de tiempo (línea 3).

7. **El estilo, en un archivo.** Escribir `-i 2 -ci -sr` cada vez es fácil de olvidar. Sin opciones de formato, shfmt busca un `.editorconfig`, un archivo de estilo que leen también muchos editores. Créalo en la carpeta del lab con tu editor, con este contenido:
   ```ini
   # .editorconfig — el estilo de los scripts de esta carpeta: shfmt lo lee si no le das opciones.
   root = true

   [*.sh]
   indent_style = space
   indent_size = 2
   switch_case_indent = true
   space_redirects = true
   ```
   `root = true` dice que no busque más `.editorconfig` en las carpetas de arriba; `[*.sh]`, que estas reglas son para los `.sh`. `starter/rotate-logs.sh` ya está formateado, así que prueba con un script nuevo sangrado con tabuladores:
   ```bash
   printf 'f() {\n\tcase "$1" in\n\ta) echo uno;;\n\tesac\n}\n' > feo.sh
   shfmt -d feo.sh
   ```
   ```text
   --- feo.sh.orig
   +++ feo.sh
   @@ -1,5 +1,5 @@
    f() {
   -	case "$1" in
   -	a) echo uno;;
   -	esac
   +  case "$1" in
   +    a) echo uno ;;
   +  esac
    }
   ```
   Sin ninguna opción, dos espacios y el caso sangrado: lo leyó del `.editorconfig`. Si das alguna opción de formato (`-i 4`), shfmt no lo lee.

8. **Limpieza.**
   ```bash
   rm -r logs roto.sh feo.sh
   ```
   (sin salida). El `.editorconfig` se queda: es parte del lab.

## Criterios de éxito

- [ ] Explicas qué son las líneas con `-` y con `+` de `shfmt -d` (paso 2)
- [ ] Explicas por qué un CI usa `shfmt -d` y no `shfmt -l` para fallar (paso 4)
- [ ] Después de `-w`, `rotate-logs.sh` hace lo mismo que antes (paso 5)
- [ ] `shfmt -d starter/rotate-logs.sh`, sin opciones y con tu `.editorconfig`, no imprime nada (paso 7)

## Reto extra

`shfmt -s` (*simplify*) además simplifica lo que se puede escribir más corto. Pruébalo con `printf 'x=$((${a}+1))\n[[ "$x" == "1" ]]\n' > s.sh` y `shfmt -s -d s.sh`: ¿qué quita y por qué no cambia lo que hace?

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Lab 01 — Los avisos de shellcheck](../lab-01-avisos-de-shellcheck/README.md) | [Lab 03 — Primeros tests con bats](../lab-03-primeros-tests-con-bats/README.md) → |

[↑ Semana 12](../../README.md)
