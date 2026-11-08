# Rúbrica de Evaluación — Semana 01

> Terminal y sistema de archivos. Se evalúan tres evidencias por separado y hace falta **70% en cada una**. Saberte los comandos de memoria no compensa no saber por qué `rm -r` en la carpeta equivocada no tiene vuelta atrás.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 7 labs, con sus criterios de éxito comprobados en el laboratorio |
| 📦 Producto | 30% | El esqueleto de `bashkit`: 60 pts de autograding + 40 pts de calidad |

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
| 1 | Escribes `lss` y ves `bash: lss: command not found`; escribes `ls noexiste` y ves `ls: cannot access 'noexiste'`. ¿Quién da cada error y qué te dice eso sobre dónde está el problema? |
| 2 | ¿Por qué `cd` tiene que ser un *builtin* de bash y no puede ser un programa aparte como `ls`? |
| 3 | Un script hace `cd /tmp` y termina. ¿Por qué tu terminal sigue en la carpeta de antes? |
| 4 | Estás en `/home/alumno/proyecto`. Escribe la ruta absoluta y la relativa a `/home/alumno/docs/notas.txt`. ¿Cuál deja de funcionar si mueves la carpeta `alumno` entera a otro disco montado en `/datos`? |
| 5 | `ls Mis Fotos` falla con dos errores. ¿Por qué dos, y cómo lo arreglas? |
| 6 | `mv informe.txt viejo/` y `mv informe.txt viejo` pueden hacer cosas distintas. ¿Cuándo, y por qué la barra final te protege? |
| 7 | ¿Por qué `rmdir` es más seguro que `rm -r` para borrar una carpeta que crees vacía? |
| 8 | ¿Por qué git necesita un `.gitkeep` para guardar `bin/`, y por qué ese archivo empieza por punto? |
| 9 | En `find . -name '*.txt'`, ¿qué pasa con el `*` si quitas las comillas y en la carpeta actual hay un archivo `a.txt`? |
| 10 | `scaffold.sh` usa `mkdir -p` en vez de `mkdir`. ¿Qué cambia cuando lo ejecutas por segunda vez? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** El primero lo da **bash**: no encontró ningún programa llamado `lss`, así que el problema está en el nombre del comando. El segundo lo da **`ls`**: el programa existe y se ejecutó, pero el argumento que le pasaste no existe. Saber quién habla te dice si corregir el comando o el argumento.

**2.** Cada programa corre en su propio proceso con su propio directorio de trabajo. Un `cd` externo cambiaría su directorio y terminaría, sin afectar a la shell que lo lanzó. Solo la propia shell puede cambiar su directorio, así que `cd` tiene que ejecutarlo bash.

**3.** `bash script.sh` arranca **otro** bash. El `cd` cambia el directorio de ese bash, que desaparece al terminar el script. Tu shell es otro proceso y nunca se movió (el mismo motivo que la pregunta 2).

**4.** Absoluta: `/home/alumno/docs/notas.txt`. Relativa: `../docs/notas.txt`. Si `alumno` pasa a `/datos/alumno`, la absoluta deja de funcionar; la relativa sigue valiendo, porque `proyecto` y `docs` siguen siendo hermanas.

**5.** Los espacios separan argumentos: `ls` recibe `Mis` y `Fotos`, busca dos archivos que no existen y da un error por cada uno. Con comillas (`ls "Mis Fotos"`) o con `Tab`, que escapa el espacio (`Mis\ Fotos`), es un solo argumento.

**6.** Si `viejo` es una carpeta que existe, los dos mueven `informe.txt` dentro. Si no existe, `mv informe.txt viejo` **renombra** el archivo a `viejo`, mientras que con `viejo/` `mv` falla porque exige que el destino sea una carpeta. La barra convierte un error silencioso en uno visible.

**7.** `rmdir` se niega si la carpeta tiene algo dentro (`Directory not empty`). Si te equivocaste y no estaba vacía, no pierdes nada. `rm -r` borra todo lo que haya, sin preguntar y sin papelera.

**8.** git guarda archivos, no carpetas: una carpeta vacía no existe para él y no llega al repositorio. Con un archivo dentro, sí. Empieza por punto para estar oculto y no estorbar al listar; el nombre `.gitkeep` es solo una convención que todo el mundo reconoce.

**9.** Sin comillas, bash sustituye `*.txt` por los archivos `.txt` de la carpeta actual **antes** de lanzar `find`. `find` recibe `-name a.txt` y solo encuentra los archivos llamados exactamente `a.txt`, no todos los `.txt` del árbol.

**10.** Sin `-p`, la segunda ejecución falla con `File exists` porque las carpetas ya están. Con `-p`, `mkdir` acepta carpetas existentes sin error y sin tocar lo que hay dentro: el script se puede repetir con el mismo resultado.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 70, llevada a porcentaje. Cada criterio de éxito se comprueba ejecutando el comando en el laboratorio.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — Primer contacto](2-practicas/lab-01-primer-contacto/README.md) | Errores atribuidos a bash o al programa; `Ctrl+C` usado; `first-commands.sh` imprime usuario, máquina y carpeta | 10 |
| [02 — cd, Tab e historial](2-practicas/lab-02-moverse-con-cd-tab-e-historial/README.md) | Rutas relativas con `..`; `Tab` y `Ctrl+R` usados; `routes.sh` imprime las cuatro paradas | 10 |
| [03 — Listar y mirar](2-practicas/lab-03-listar-y-mirar-archivos/README.md) | Columnas de `ls -l` explicadas; oculto encontrado; `inspect.sh` completo | 10 |
| [04 — Crear, copiar y mover](2-practicas/lab-04-crear-copiar-y-mover/README.md) | `-p` y `-r` explicados; sobrescritura reproducida; `build-office.sh` imprime el árbol esperado | 10 |
| [05 — Borrar sin sustos](2-practicas/lab-05-borrar-sin-sustos/README.md) | `rm -i`, `rmdir` y el error de los espacios explicados; `cleanup.sh` deja solo `informe-final.txt` | 10 |
| [06 — Pedir ayuda](2-practicas/lab-06-pedir-ayuda/README.md) | Builtin, programa y alias distinguidos; opción `-S` encontrada en `man`; `help-check.sh` completo | 10 |
| [07 — Buscar con find](2-practicas/lab-07-buscar-con-find/README.md) | Filtros por tipo, nombre y patrón; `find-files.sh` guarda las páginas en `zona/paginas.txt` | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con tus palabras por qué funciona; 8 si se cumplen todos; 7 si falla uno; menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 01`. Es binario: pasa o no pasa.

| Comprobación | Puntos |
|---|:--:|
| `kit-carpetas` — bashkit tiene bin, lib, tests y docs | 4 |
| `kit-gitkeep` — bin, lib y tests tienen `.gitkeep` | 4 |
| `kit-mapa-movido` — `mapa.txt` en `docs/` y no en la raíz | 4 |
| `kit-borrador-borrado` — `borrador-viejo.txt` ya no existe | 3 |
| `scaffold-carpetas` — `scaffold.sh` crea las cuatro carpetas | 5 |
| `scaffold-gitkeep` — `scaffold.sh` deja un `.gitkeep` en cada una | 4 |
| `scaffold-readme` — `scaffold.sh` escribe `bashkit/README.md` | 4 |
| `scaffold-solo-su-carpeta` — no crea nada fuera de `bashkit/` | 4 |
| `scaffold-dos-veces` — se puede ejecutar dos veces seguidas | 5 |
| `scaffold-no-borra` — no borra lo que ya había en `bashkit/` | 5 |
| `scaffold-limpio` — sin TODOs y limpio para shellcheck | 4 |
| `inventario-archivos` — `docs/inventario.txt` generado con `find` | 4 |
| `inventario-al-dia` — incluye `scaffold.sh` y `docs/mapa.txt` | 3 |
| `inventario-solo-archivos` — solo archivos, no carpetas | 3 |
| `readme-completo` — README del kit sin TODOs y con las cuatro carpetas | 4 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **README del kit** | Alguien que no te conoce entiende qué es el kit, para qué sirve cada carpeta y cómo recrearlo; la bitácora dice qué te costó | Lista las carpetas sin explicarlas | 10 |
| **Comentarios del porqué** | Los comentarios de `scaffold.sh` explican decisiones (`-p`, `.gitkeep`), no repiten el comando | Comentarios que repiten el código | 10 |
| **Portabilidad** | Solo rutas relativas: `scaffold.sh` funciona en cualquier carpeta y máquina | Alguna ruta absoluta a tu carpeta | 10 |
| **Seguridad** | Ningún `rm` en `scaffold.sh`; el kit no tiene archivos sobrantes | Un archivo de pruebas olvidado | 10 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| `scaffold.sh` contiene `rm -r` o `rm -rf` | −10 pts |
| Rutas absolutas a tu home dentro del kit | −5 pts |

---

## 📋 Checklist de entrega

- [ ] Los 7 labs con sus criterios de éxito comprobados
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/` sin ningún `TODO`
- [ ] `./scripts/verificar-semana.sh 01` con las 15 comprobaciones en verde

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Proyecto — El esqueleto de bashkit](3-proyecto/README.md) | [Recursos — ebooks](4-recursos/ebooks-free/README.md) → |

[↑ Semana 01](README.md)
