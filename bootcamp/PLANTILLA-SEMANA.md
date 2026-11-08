# PLANTILLA DE SEMANA — bc-bash

> Archivo de referencia. Copia esta estructura al crear contenido nuevo.
> Reglas completas en `CLAUDE.md`.

---

## README.md de semana (plantilla)

~~~markdown
# Semana NN — Título del Tema

## Descripción

<2-3 oraciones. Qué aprenderá el estudiante. Por qué importa en la práctica real.>

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Escribir <concepto> usando <técnica>
- Depurar <problema común> con <herramienta>
- Construir <artefacto concreto> desde cero

## Prerrequisitos

- Semanas 01–NN-1 completadas
- El laboratorio Docker construido (`docker compose build`, ver docs/setup-entorno.md)

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-contexto.md](1-teoria/01-contexto.md) | 1 h |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 30 min |
| 1 | Lab | [lab-01-nombre](2-practicas/lab-01-nombre/README.md) | 60 min |
| … | Lab | … | 60 min |
| 7 | Lab | [lab-07-nombre](2-practicas/lab-07-nombre/README.md) | 60 min |
| — | Proyecto | [Proyecto semanal](3-proyecto/README.md) | 3 h 30 min |

**Total: 12 horas**

## Distribución del tiempo

```text
[1 h]       Leer 1-teoria/
[30 min]    Responder las 10 preguntas de Conocimiento
[60 min]    lab-01 — <tema>
...
[60 min]    lab-07 — <tema>
[3 h 30 min] Proyecto: <nombre>
```

## Verificación de completitud

Desde la raíz del repositorio:

```bash
./scripts/verificar-semana.sh NN
```

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [← Semana NN-1 — Tema](../week-NN-1-slug/README.md) | **Semana NN — Tema** | [Semana NN+1 — Tema →](../week-NN+1-slug/README.md) |

[← Volver al índice del bootcamp](../README.md)
~~~

---

## README.md de lab (plantilla)

~~~markdown
# Lab NN — Título del Lab

⏱ Duración estimada: ~60 min

## Objetivo

<Verbo en infinitivo> <qué> usando <qué técnica de bash>.

## Contexto

<Máx. 3 párrafos o 5 bullets. Referencia al tema de la semana sin repetir la teoría.>

## Instrucciones

0. Entra al laboratorio desde la raíz del repositorio y ve a la carpeta del lab:
   ```bash
   docker compose run --rm lab
   cd bootcamp/week-NN-slug/2-practicas/lab-NN-nombre
   ```

1. <Qué vas a hacer y qué es la pieza nueva, en una línea>:
   ```bash
   ./starter/count-lines.sh datos.txt; echo $?
   ```
   ```text
   sin implementar
   1
   ```

2. **TODO 1** de `starter/count-lines.sh`: <qué hacer>. Pista: `wc -l < "$archivo"`.
   Borra la línea `echo "sin implementar"`, guarda y prueba solo ese TODO:
   ```bash
   ./starter/count-lines.sh datos.txt
   ```
   ```text
   3
   ```

## Criterios de éxito

- [ ] `./starter/count-lines.sh datos.txt` imprime `3`
- [ ] `./starter/count-lines.sh no-existe.txt; echo $?` imprime el error en stderr y `1`

## Reto extra

<Extensión opcional para ir más lejos.>
~~~

---

## Script starter (plantilla)

```bash
#!/usr/bin/env bash
# count-lines.sh — cuenta las líneas de un archivo.
# Lab NN, semana NN. Prueba: ./starter/count-lines.sh datos.txt  ->  3
set -euo pipefail

# TODO 1: imprime el número de líneas de "$1".
#         Pista: wc -l < "$1"
echo "sin implementar"
exit 1
```

## Script solución (plantilla)

```bash
#!/usr/bin/env bash
# count-lines.sh — cuenta las líneas de un archivo.
set -euo pipefail

file="${1:?uso: count-lines.sh <archivo>}"
[[ -f "$file" ]] || { printf 'no existe: %s\n' "$file" >&2; exit 1; }

# Con < el nombre del archivo no aparece en la salida: solo el número.
wc -l < "$file"
```
