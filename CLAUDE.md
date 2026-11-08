# CLAUDE.md — bc-bash

Instrucciones de proyecto para Claude Code. Este archivo se carga automáticamente en cada sesión.

---

## Identidad del proyecto

- **Nombre:** bc-bash
- **Tipo:** Bootcamp técnico, 100% orientado a la práctica
- **Duración:** 14 semanas × 12 horas = 168 horas totales (Zero to Advanced)
- **Herramienta central:** GNU Bash **≥ 5.2** (Ubuntu 24.04 LTS). Lo que exija una versión mayor se marca "bash 5.3+" con alternativa para 5.2
- **Sistema mínimo del estudiante:** Docker (el laboratorio trae todo). Ubuntu 24.04 LTS, WSL2 o macOS solo para editar archivos
- **Repositorio de referencia de estructura:** ergrato-dev/bc-tmux

## Audiencia objetivo

Personas que **nunca abrieron una terminal**. No asumas nada: ni qué es un directorio, ni qué es una ruta, ni cómo se copia un comando. Sí asume que saben instalar un programa en su sistema operativo y usar un editor de texto con interfaz gráfica.

## Filosofía de contenido: 100% práctica

- **Teoría mínima:** solo el contexto indispensable para no perderse en el lab. Máximo 1 h por semana.
- **Labs primero:** el estudiante aprende haciendo, no leyendo.
- **Errores intencionados:** algunos labs traen scripts rotos (comillas que faltan, `set -e` que no salta, `for` sobre `ls`) para que el estudiante los depure.
- **Progresión real:** cada semana construye sobre la anterior (ver proyecto hilo conductor).
- **Sin hello world vacío:** cada ejercicio tiene un propósito concreto y un output verificable.

## Proyecto hilo conductor: `bashkit`

El estudiante construye a lo largo del bootcamp **una CLI de operaciones en bash**: scripts sueltos al principio, una librería y un dispatcher de subcomandos a mitad, y una herramienta probada con bats que hace backups de PostgreSQL en Docker al final. Cada `3-proyecto/starter/` parte del resultado de la semana anterior. Detalle en `docs/proyecto-hilo-conductor.md`.

```
bashkit/
├── bin/bashkit          # dispatcher: bashkit <subcomando> (semana 08)
├── bin/bk-*             # un script por subcomando
├── lib/                 # core.sh (log, die, require), una librería por tema
├── tests/               # bats-core (semana 12)
└── compose.yaml         # PostgreSQL para el backup (semana 14)
```

## Distribución de tiempo por semana (12 h)

| Sección | Tiempo | Descripción |
|---------|--------|-------------|
| 1-teoria | 1 h | Contexto mínimo + referencia rápida (1–4 archivos) |
| Conocimiento | 30 min | 10 preguntas de la rúbrica, respondidas por escrito |
| 2-practicas | 7 h | 7 labs progresivos (~60 min c/u) |
| 3-proyecto | 3 h 30 min | Proyecto semanal integrador (incremento de `bashkit`) |

## Estructura de carpetas por semana

```
week-NN-nombre_del_tema/
├── README.md                  # Descripción, objetivos, tabla de contenidos, navegación
├── rubrica-evaluacion.md      # Conocimiento 30 / Desempeño 40 / Producto 30
├── checks.json                # Autograding (ver docs/autograding.md)
├── 0-assets/                  # Diagramas SVG, enlazados desde 1-teoria
│   └── NN-nombre.svg
├── 1-teoria/                  # Contexto mínimo, NO tutoriales largos
│   └── 01-contexto.md         # 1–4 archivos, ≤ 600 palabras de prosa c/u
├── 2-practicas/
│   ├── README.md              # Índice de labs con duración estimada
│   └── lab-NN-nombre/
│       ├── README.md          # Enunciado, instrucciones, criterios de éxito
│       ├── starter/           # scripts y datos con TODOs
│       └── solucion/          # solución de referencia (pasa a repo privado)
├── 3-proyecto/
│   ├── README.md
│   ├── starter/               # bashkit de la semana anterior + TODOs
│   ├── solucion/              # bashkit al terminar esta semana
│   └── tests/                 # datos y dobles que usa checks.json
├── 4-recursos/
│   ├── ebooks-free/README.md
│   ├── videografia/README.md
│   └── webgrafia/README.md
└── 5-glosario/
    └── README.md              # Término | Definición en una línea | Ejemplo
```

## Convenciones de naming

| Elemento | Convención | Ejemplo |
|----------|-----------|---------|
| Carpeta de semana | `week-NN-nombre_con_guion_bajo` | `week-05-variables_comillas_y_expansiones` |
| Carpeta de lab | `lab-NN-nombre-con-guion` | `lab-03-comillas-dobles-y-simples` |
| Scripts del kit | `bin/bk-name-kebab` (sin extensión), **en inglés** | `bin/bk-top-ips` |
| Scripts de labs | `name-kebab.sh`, en inglés | `starter/count-lines.sh` |
| Librerías | `lib/name.sh`, se cargan con `source`, sin bit de ejecución | `lib/core.sh` |
| Funciones y variables | `snake_case` en inglés; constantes y exportadas en `UPPER_CASE` | `log_info`, `BK_LOG_LEVEL` |
| Tooling del repo | en español | `scripts/verificar-semana.sh` |

## Estándares de bash en el repo

```bash
#!/usr/bin/env bash
# Qué hace el script en una línea. Para qué existe en otra, si no es obvio.
set -euo pipefail

# Citar siempre: sin comillas, un nombre con espacios se parte en dos argumentos.
main() {
  local target="${1:?uso: bk-ejemplo <archivo>}"
  [[ -f "$target" ]] || { printf 'no existe: %s\n' "$target" >&2; exit 1; }
}

main "$@"
```

- `#!/usr/bin/env bash` siempre. `set -euo pipefail` desde la semana 03 (antes se explica por qué falta). La semana 11 enseña sus límites.
- Citar siempre `"$var"` y `"$@"`. `[[ ]]` en lugar de `[ ]`. `$(...)` en lugar de backticks.
- Nunca `for f in $(ls)` ni `cat archivo | while`: `find -print0` + `while IFS= read -r -d ''`, o un glob.
- Mensajes de error a `stderr` (`>&2`) y código de salida distinto de 0.
- `shellcheck` limpio en todo script de `solucion/` (los labs rotos a propósito, no).
- Nada borra fuera de un directorio temporal (`mktemp -d`) o de la carpeta del lab.

## Estándares de idioma

- **Prosa, enunciados, comentarios:** español, siempre **tuteo** (tú, tienes, puedes, haz). **Nunca voseo** (vos, tenés, podés, hacé, mirá).
- **Nomenclatura técnica en inglés:** nombres de scripts, funciones, variables, archivos de código. Siguen en español: carpetas del curso (`week-*`, `lab-*`), archivos `.md` y el tooling del repo (`scripts/verificar-*.sh`).
- **Comentarios en español, solo donde hagan falta:** documentan qué hace, para qué y qué impacto tiene (qué se rompe sin esa línea). Nunca repiten el código, otro comentario ni el README.
- **Mensajes `echo`/`printf` para el usuario:** español.
- **Nunca mezclar idiomas en la misma línea de prosa.**
- **Herramientas:** Python solo con **uv**, nunca pip. Node.js solo con **pnpm**, nunca npm. Bases de datos solo **PostgreSQL**, nunca MySQL. Servicios siempre con **Docker** (`compose.yaml`).

## Estructura de un lab (README.md de lab)

1. **Título y duración estimada**
2. **Objetivo** — una sola oración con el verbo en infinitivo
3. **Contexto** — máx. 3 párrafos o bullets; no repetir lo que ya está en 1-teoria
4. **Instrucciones** — pasos numerados, con comandos exactos
5. **Criterios de éxito** — outputs verificables (`./count-lines.sh datos.txt` imprime `3`)
6. **Reto extra** (opcional)

## Estándar paso a paso (labs y proyectos): no asumir nada

El estudiante nunca usó una terminal. Cada ejemplo es completo y se puede seguir sin adivinar:

1. **Paso 0**: dónde se ejecuta (dentro del laboratorio: `docker compose run --rm lab`) y el `cd` a la carpeta del lab desde la raíz del repo (`cd bootcamp/week-NN-.../2-practicas/lab-NN-...`).
2. **Output tras cada bloque**, incluido `echo $?` cuando importa el código de salida. Sin salida: `(sin salida)`. Si varía (pid, fechas, tamaños): "algo como" + qué cambia. Se pega de una ejecución real en el laboratorio, nunca de memoria.
3. **Qué es cada pieza la primera vez que aparece**: un comando, una opción o un símbolo nuevo se explica en una línea antes de usarlo. Nada de "como ya sabes".
4. **Un subpaso por TODO**: qué hacer, pista de sintaxis mínima, el comando que prueba solo ese TODO y su output. Prohibido "Completa `starter/x.sh`" a secas. Si el starter tiene un `echo "sin implementar"`, se dice que se borra.
5. **Todo criterio de éxito sale de un paso** que lo produce. Toda herramienta extra ya está en el laboratorio; si no, se instala explícitamente.
6. **Orden y seguridad**: las precondiciones (`rm`, crear datos, `chmod +x`) van antes del comando que las necesita. Nada toca el `$HOME` real del estudiante: los labs trabajan en su carpeta o en `mktemp -d`.
7. **Proyectos**: sección `## Paso a paso` que recorre los TODOs en orden, cada uno con su comprobación y output. Se trabaja sobre `3-proyecto/starter/` (es lo que corrige el autograding). Termina con `cd "$(git rev-parse --show-toplevel)" && ./scripts/verificar-semana.sh NN` y su output.
8. **Agnóstico de editor**: "abre `starter/x.sh` en tu editor", nunca teclas de vim/nano salvo en el lab donde se enseñan.

## Estructura del README.md de semana

1. Título y número de semana
2. Descripción (2-3 oraciones)
3. Objetivos de aprendizaje (lista con verbos de acción)
4. Prerrequisitos
5. Tabla de contenidos con tiempos
6. Distribución del tiempo
7. Cómo verificar que completaste la semana (`./scripts/verificar-semana.sh NN`)
8. `## 🔗 Navegación` (tabla anterior / actual / siguiente + volver al índice)

## Rúbrica de evaluación

Tres evidencias, **mínimo 70% en cada una** (no en el promedio):
- 🧠 Conocimiento 30%: 10 preguntas conceptuales (3 pts c/u) que piden explicar el porqué, no recordar opciones
- 💪 Desempeño 40%: los 7 labs, con criterios de éxito verificables
- 📦 Producto 30%: proyecto semanal — 60 pts de autograding (`checks.json`) + 40 pts de calidad (comillas, mensajes a stderr, códigos de salida, comentarios del porqué, shellcheck limpio)

Bandas: Sobresaliente 90–100, Notable 80–89, Aprobado 70–79.

## Plan de 14 semanas

Índice con estado: `bootcamp/README.md` (✅ = semana al estándar actual).

| Semana | Carpeta | Tema | Proyecto semanal (`bashkit`) |
|--------|---------|------|-----------------|
| **Fase 1 — La terminal** ||||
| 01 | `week-01-terminal_y_sistema_de_archivos` | Terminal vs shell, prompt, `pwd`/`ls`/`cd`, rutas absolutas y relativas, `mkdir`/`touch`/`cp`/`mv`/`rm`, `man`/`help`/`--help`, tab e historial | Estructura de `bashkit/` creada a mano + inventario con `find` |
| 02 | `week-02-permisos_procesos_y_primer_script` | Usuarios y grupos, `rwx`, `chmod`/`chown`, `ps`/`kill`/jobs, shebang, `$PATH`, variables de entorno | `bin/bk-info`: ficha del sistema |
| 03 | `week-03-redireccion_pipes_y_codigos_de_salida` | stdin/stdout/stderr, `>`/`>>`/`2>`/`&>`, `/dev/null`, pipes, `tee`, here-docs, `$?`, `&&`/`\|\|`, `set -euo pipefail` | `bin/bk-run`: ejecuta un comando y registra salida y código en un log |
| 04 | `week-04-filtros_de_texto_y_regex` | `cat`/`head`/`tail`/`wc`, `grep -E`, `cut`, `sort`, `uniq -c`, `tr`, `find`, regex básicas y extendidas | `bin/bk-top-ips`: las N IP más frecuentes de un access log |
| **Fase 2 — Programar en bash** ||||
| 05 | `week-05-variables_comillas_y_expansiones` | Variables, comillas, word splitting, globbing, `${var:-}`/`${var:?}`, `${var#}`/`${var%}`/`${var//}`, `$(( ))`, `$( )` | `bin/bk-rename`: normaliza nombres de archivo con `--dry-run` |
| 06 | `week-06-condicionales_case_y_regex` | `if`, `test`/`[[ ]]`, operadores de archivo y cadena, `case`, `=~` y `BASH_REMATCH`, argumentos `$1`/`$#`/`$@` | `bin/bk-check`: valida IP, email y versión semántica |
| 07 | `week-07-bucles_read_y_archivos_seguros` | `for`, `while`, `until`, `break`/`continue`, `read -r`, `IFS`, `mapfile`, `find -print0`, nombres con espacios | `bin/bk-clean`: borra archivos viejos de forma segura |
| 08 | `week-08-funciones_alcance_y_librerias` | Funciones, `local`, `return` vs salida, `declare -n`, `source`, librerías, dispatcher de subcomandos | `lib/core.sh` + `bin/bashkit <subcomando>` |
| 09 | `week-09-arrays_y_printf` | Arrays indexados y asociativos, `"${arr[@]}"`, slices, `printf` con formato, `printf -v`, tablas alineadas | `bashkit report`: resumen tabular con arrays asociativos |
| **Fase 3 — Scripts profesionales** ||||
| 10 | `week-10-sed_awk_y_jq` | `sed` (sustituir, rangos, `-i`), `awk` (campos, patrones, arrays, `BEGIN/END`), `jq` para JSON | `bashkit logs`: access log a CSV y JSON |
| 11 | `week-11-scripts_robustos` | Límites de `set -e`, `trap` y señales, `mktemp`, `getopts`, `flock`, logging por niveles, idempotencia | `bashkit` con opciones `getopts`, limpieza con `trap` y bloqueo con `flock` |
| 12 | `week-12-calidad_testing_y_depuracion` | shellcheck, shfmt, bats-core, `set -x`/`PS4`/`BASH_XTRACEFD`, rendimiento: subshells, builtins vs procesos | Suite bats de `bashkit` + depuración de un script roto |
| 13 | `week-13-procesos_y_concurrencia` | Jobs, `wait`/`wait -n`, `xargs -P`, process substitution, `coproc`, señales a hijos, cron y systemd timers | `bashkit healthcheck`: comprobaciones en paralelo con límite |
| **Fase 4 — Producción** ||||
| 14 | `week-14-proyecto_integrador` | Docker + PostgreSQL, `pg_dump`/`pg_restore`, rotación, healthchecks, CI con GitHub Actions | `bashkit backup`: backup y restauración de PostgreSQL en Docker |

Versiones del stack: `docs/stack-versions.md`. No usar otras.

## Autograding

Cada check corre dentro del laboratorio Docker, en un directorio temporal propio, contra `3-proyecto/starter/` (o `solucion/` con `ENTREGA=solucion`). Contrato completo en `docs/autograding.md`.

```json
{ "id": "info-user", "descripcion": "...", "cmd": "{proyecto}/bin/bk-info", "assert": "stdout~usuario: ", "pista": "3-proyecto/README.md, paso 2" }
```

## Comandos útiles durante el desarrollo del bootcamp

```bash
docker compose run --rm lab                        # shell dentro del laboratorio
./scripts/verificar-enlaces.sh                     # estructura, enlaces, SVG, idioma
./scripts/generar-navegacion.sh NN                 # tabla anterior/siguiente al pie de cada documento
./scripts/verificar-semana.sh NN                   # autograding de una semana
ENTREGA=solucion ./scripts/verificar-semana.sh NN  # valida la solución de referencia
shellcheck bootcamp/week-NN-*/**/solucion/**/*     # dentro del laboratorio
```

## Contenido esperado por sección

### 0-assets/
Diagramas en **SVG escrito a mano**, un archivo por diagrama, nombrado `NN-nombre-descriptivo.svg` en orden de lectura. **Sin cupo por semana: los que pida el contenido, ni uno más ni uno menos.** Un diagrama entra cuando muestra algo que el texto no puede (un árbol de directorios, el flujo de un pipe, los tres descriptores, una expansión paso a paso); sobra si es una lista o una tabla con cajas alrededor o repite el bloque de código de al lado. **Nada de Mermaid ni arte ASCII.**

- **Todo SVG se enlaza desde el archivo de `1-teoria/` donde aparece el concepto**, con `../0-assets/NN-nombre.svg`. El texto alternativo describe lo que muestra. `verificar-enlaces.sh` falla con SVG huérfanos.
- `viewBox` obligatorio, sin `width`/`height` fijos en la raíz.
- `role="img"` y `<title>` descriptivo como primer hijo.
- `<rect>` de fondo `#0d1117` que cubra el `viewBox`. **Tema dark siempre.**
- **Sin degradados** (`linearGradient`/`radialGradient`), sin `foreignObject`, sin fuentes externas. Texto ≥ 12 px.
- **Solo fuentes sans-serif**, también para comandos: `font-family="Inter, system-ui, -apple-system, sans-serif"`. Los comandos se distinguen por color (naranja), no por fuente.

Paleta (GitHub dark + verde bash del header `assets/bootcamp-header.svg`):

| Rol | Hex |
|-----|-----|
| Lienzo | `#0d1117` |
| Superficie (cajas) | `#161b22` |
| Borde | `#30363d` |
| Texto principal | `#f0f6fc` |
| Texto secundario | `#8b949e` |
| Acento bash (elemento principal, proceso, shell) | `#3fb950` |
| Azul (datos, flujo, stdin/stdout) | `#58a6ff` / `#79c0ff` |
| Naranja (comandos) | `#f78166` |
| Amarillo (aviso) | `#e3b341` |
| Rojo (error, stderr, peligro) | `#f85149` |
| Morado (secundario, metadatos) | `#d2a8ff` |

### 4-recursos/
- `ebooks-free/`: `| Título | Formato | Descripción | Enlace |`, mínimo 2.
- `videografia/`: `| Título | Canal | Duración | Enlace |`, mínimo 3; en español si existe con calidad.
- `webgrafia/`: `| Recurso | Descripción |`, 3–5, priorizando el manual de GNU Bash, `man bash`, el Bash Hackers Wiki (archivo) y el wiki de ShellCheck.

Solo enlaces comprobados al escribir la semana; nada inventado.

### 5-glosario/
`| Término | Definición en una línea | Ejemplo |`, entre 8 y 15 términos nuevos de esa semana.

## Notas para Claude al generar contenido

- Las soluciones se moverán al repo privado `ergrato-dev/bc-bash-instructor` (misma ruta relativa); hasta entonces viven aquí.
- Cada semana nueva lleva `checks.json` escrito antes que el contenido y pasa `./scripts/verificar-enlaces.sh`.
- Probar toda solución dentro del laboratorio (`docker compose run --rm lab`) y pegar los outputs reales.
- Al generar teoría, máximo 600 palabras de prosa por archivo. Preferir ejemplos concretos sobre explicaciones abstractas.
- No generar contenido de semanas futuras si no se pidió explícitamente.
- Al cerrar una semana, `./scripts/verificar-enlaces.sh` comprueba voseo, herramientas prohibidas y estilo de SVG; debe salir limpio.
- Tono: directo, sin relleno, orientado al profesional.
