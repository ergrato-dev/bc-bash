# Rúbrica de Evaluación — Semana 02

> Permisos, procesos y primer script. Se evalúan tres evidencias por separado y hace falta **70% en cada una**. Saber que `755` "funciona" no basta: hay que saber quién puede hacer qué con ese archivo y por qué.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 7 labs, con sus criterios de éxito comprobados en el laboratorio |
| 📦 Producto | 30% | `bin/bk-info`: 60 pts de autograding + 40 pts de calidad |

**Mínimo 70% en cada evidencia.** No en el promedio.

| Calificación | Rango |
|---|:--:|
| Sobresaliente | 90-100% |
| Notable | 80-89% |
| Aprobado | 70-79% |
| No aprobado | < 70% |

---

## 🧠 Conocimiento (30%)

Diez preguntas, 3 puntos cada una. No se pide recordar opciones: se pide explicar por qué.

| # | Pregunta |
|:--:|---|
| 1 | `/etc/passwd` tiene permisos `644` y `/etc/shadow` `640`. ¿Por qué cualquiera puede leer el primero, y qué se rompería si el segundo también fuera legible para todos? |
| 2 | Una carpeta tiene `r--` para ti. `ls` te da los nombres, pero `cat` de un archivo de dentro falla. ¿Por qué? |
| 3 | No tienes permiso de escritura en `informe.txt`, pero sí en la carpeta que lo contiene. ¿Puedes borrarlo? ¿Por qué? |
| 4 | `chmod g+w a.txt` y `chmod 664 a.txt` pueden dejar el archivo igual o distinto. ¿Cuándo dan resultados diferentes? |
| 5 | ¿Por qué un usuario normal no puede hacer `chown` de sus propios archivos a otro usuario? Piensa en qué podría hacer si pudiera. |
| 6 | `kill PID` y `kill -9 PID` terminan el proceso. ¿Por qué se recomienda probar primero el primero? |
| 7 | Un script lanza `sleep 300 &` y termina. ¿Qué le pasa al `sleep` y quién pasa a ser su padre? |
| 8 | `./script.sh` da `Permission denied`, pero `bash script.sh` funciona. ¿Por qué cada uno se comporta así? |
| 9 | Escribes `export BK_ENTORNO=pruebas` en tu shell y un script hace `BK_ENTORNO=prod`. Al terminar el script, ¿qué vale `BK_ENTORNO` en tu shell? ¿Por qué? |
| 10 | ¿Por qué `PATH="$PWD/bin:$PATH"` pone la carpeta al principio y con `$PWD`, y por qué nunca se añade `.` al `PATH`? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** Muchos programas necesitan pasar de uid a nombre (por ejemplo `ls -l` para mostrar `alumno`), y por eso `/etc/passwd` es público. No contiene contraseñas, solo una `x`. `/etc/shadow` tiene los hashes de las contraseñas: si todos lo leyeran, cualquiera podría copiarlos e intentar adivinar contraseñas por fuerza bruta en su propio equipo.

**2.** La `r` de una carpeta solo deja leer la lista de nombres. Para llegar a un archivo de dentro (abrirlo, ver sus datos) hace falta la `x` de la carpeta. Sin ella, `cat` no puede atravesarla.

**3.** Sí. Borrar un archivo es quitar su nombre de la carpeta, o sea, cambiar la carpeta, y eso lo decide la `w` de la carpeta. La `w` del archivo controla su contenido, no su existencia. `rm` preguntará `remove write-protected ...?` antes, pero si respondes `y` lo borra.

**4.** `g+w` solo añade la escritura al grupo y deja todo lo demás como estaba; `664` fija los nueve permisos. Si el archivo era `644`, los dos dan `664`. Si era `755` (o `600`), `g+w` da `775` (o `620`) y `664` da `664`: quita la `x`, o da permisos que antes no había.

**5.** Si pudiera, cualquiera podría dejar un archivo a nombre de otra persona, por ejemplo un script malicioso que pareciera suyo, o llenar su cuota de disco. También podría crear un programa y dárselo a root con permisos especiales. Por eso solo root cambia el dueño.

**6.** `kill PID` manda `SIGTERM`: el programa recibe el aviso y puede terminar limpiamente (guardar, borrar temporales, cerrar conexiones). `kill -9` manda `SIGKILL`: el sistema lo elimina sin avisarle, y lo que tuviera a medias queda a medias. Solo se usa si `SIGTERM` no funciona.

**7.** Sigue vivo hasta que pasan los 300 segundos: la muerte del padre no lo para. Queda huérfano y lo adopta el proceso 1 (en el laboratorio, tu bash inicial), que pasa a ser su PPID. Por eso un script tiene que parar lo que lanza.

**8.** `bash script.sh` ejecuta el programa bash y le pasa el archivo para que lo lea: basta con poder leerlo. `./script.sh` pide al sistema que ejecute el archivo en sí, y eso exige la `x`. Sin ella, `Permission denied` y código `126`.

**9.** Sigue valiendo `pruebas`. El script recibe una **copia** del entorno y cambia su copia, que desaparece al terminar. Un hijo nunca puede cambiar las variables de su padre.

**10.** Al principio, porque bash usa el primer comando que encuentra: tu carpeta gana a las del sistema. Con `$PWD`, porque es una ruta absoluta y funciona desde cualquier carpeta; con `bin` a secas solo funcionaría desde la raíz del kit. `.` nunca, porque entrarías en carpetas de otras personas y podrías ejecutar sin querer un archivo suyo llamado como un comando normal (`ls`).

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 70, llevada a porcentaje. Cada criterio de éxito se comprueba ejecutando el comando en el laboratorio.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — Usuarios y grupos](2-practicas/lab-01-usuarios-y-grupos/README.md) | Salida de `id` y campos de `/etc/passwd` explicados; `who-am-i.sh` completo | 10 |
| [02 — Leer permisos](2-practicas/lab-02-leer-permisos/README.md) | Permisos de `/home/alumno` y de `zona/` leídos; paso de letras a octal; `read-perms.sh` completo | 10 |
| [03 — Cambiar permisos con chmod](2-practicas/lab-03-cambiar-permisos-con-chmod/README.md) | Efecto de quitar `r`, `w` y `x` en archivos y carpetas reproducido; `set-perms.sh` deja 664, 755, 600 y 700 | 10 |
| [04 — Propietarios y root](2-practicas/lab-04-propietarios-y-root/README.md) | `chown` fallido como alumno; `runuser` usado; `owners.sh` deja la nómina fuera del alcance de `alumno` | 10 |
| [05 — Procesos y señales](2-practicas/lab-05-procesos-y-senales/README.md) | `Ctrl+Z`, `bg`, `fg` y `kill` usados; huérfano explicado; `process-check.sh` para su `sleep` | 10 |
| [06 — Shebang y bit de ejecución](2-practicas/lab-06-shebang-y-bit-de-ejecucion/README.md) | Errores 126 y 127 explicados; efecto de `#!/bin/sh` explicado; `shell-info.sh` ejecutable con el shebang correcto | 10 |
| [07 — PATH y variables de entorno](2-practicas/lab-07-path-y-variables-de-entorno/README.md) | `backup-name` por su nombre; `export` explicado con `bash -c`; `env-check.sh` completo | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con tus palabras por qué funciona; 8 si se cumplen todos; 7 si falla uno; menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 02`. Es binario: pasa o no pasa.

| Comprobación | Puntos |
|---|:--:|
| `info-shebang` — `bin/bk-info` empieza por `#!/usr/bin/env bash` | 4 |
| `info-permisos` — `bin/bk-info` tiene permisos `755` | 5 |
| `info-cabecera` — se ejecuta directamente e imprime la cabecera | 4 |
| `info-usuario` — línea `usuario:` correcta | 4 |
| `info-grupos` — línea `grupos:` correcta | 4 |
| `info-equipo` — línea `equipo:` correcta | 4 |
| `info-home` — lee `HOME`, no lo escribe a mano | 5 |
| `info-bash` — línea `bash:` con `BASH_VERSION` | 3 |
| `info-path` — imprime el `PATH` que recibe | 5 |
| `info-sin-implementar` — ya no imprime `sin implementar` | 2 |
| `info-desde-path` — funciona por su nombre con `bin/` en el `PATH` | 5 |
| `info-limpio` — sin TODOs y limpio para shellcheck | 4 |
| `scaffold-ejecutable` — `./scaffold.sh` funciona | 4 |
| `inventario-al-dia` — `docs/inventario.txt` incluye `./bin/bk-info` | 3 |
| `readme-completo` — README sin TODOs, con `bk-info` y la bitácora de la semana 02 | 4 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **Nada escrito a mano** | Cada valor de `bk-info` sale de un comando o de una variable | Algún valor fijo que coincide por casualidad con el laboratorio | 10 |
| **Comentarios del porqué** | Explican decisiones (`id` en vez de `USER`, falta de `set -euo pipefail`), no repiten el código | Comentarios que repiten el código | 10 |
| **Comillas** | Cada `echo` con variables o `$( )` va entre comillas dobles | Alguna expansión sin comillas | 10 |
| **README del kit** | Explica qué imprime `bk-info`, cuándo usarlo y cómo ejecutarlo por su nombre; la bitácora dice qué te costó | Solo el nombre del comando | 10 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| Permisos `777` (o `w` para los demás) en cualquier archivo del kit | −10 pts |
| Archivos de root dentro del repositorio | −5 pts |

---

## 📋 Checklist de entrega

- [ ] Los 7 labs con sus criterios de éxito comprobados
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/` sin ningún `TODO`
- [ ] `./scripts/verificar-semana.sh 02` con las 15 comprobaciones en verde

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Proyecto — bk-info: la ficha del sistema](3-proyecto/README.md) | [Recursos — ebooks](4-recursos/ebooks-free/README.md) → |

[↑ Semana 02](README.md)
