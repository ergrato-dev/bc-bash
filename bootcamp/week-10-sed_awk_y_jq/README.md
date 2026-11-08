# Semana 10 — sed, awk y jq

## Descripción

Hasta ahora, los datos los leía bash línea a línea, con `while read` y arrays. Esta semana usarás las tres herramientas que hacen ese trabajo mejor: `sed` para cambiar y filtrar texto, `awk` para trabajar por columnas, sumar y contar, y `jq` para leer y escribir JSON. Con las tres añadirás a `bashkit` el subcomando `logs`: un access log convertido en CSV y en JSON.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Sustituir texto con `sed 's///'`, grupos y regex extendidas, y escribir solo las líneas que encajan con `-n` y `p`
- Elegir líneas con direcciones y rangos, borrarlas con `d` y cambiar un archivo con `sed -i.bak` sin perder el original
- Leer columnas con `awk`, filtrar con patrones y escribir tablas con su `printf`
- Contar y sumar por clave con los arrays de awk, y escribir el resultado en `END`
- Pasar datos de bash a awk con `-v` y comparar como número lo que llega pegado a un texto
- Sacar valores de un JSON con `jq` (`.campo`, `.[]`, `select`, `-r`) y construirlo con `jq -n`, `--arg` y `--argjson`
- Escribir `bin/bk-logs` (`bashkit logs`)

## Prerrequisitos

- [Semana 09](../week-09-arrays_y_printf/README.md) completada: arrays, `printf` y `bashkit report`
- Las regex de la [semana 04](../week-04-filtros_de_texto_y_regex/README.md): `grep -E`, `[^ ]`, `+`, `{3}`
- El laboratorio funcionando: ver [docs/setup-entorno.md](../../docs/setup-entorno.md)

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-sed.md](1-teoria/01-sed.md) · [02-awk.md](1-teoria/02-awk.md) · [03-jq.md](1-teoria/03-jq.md) | 1 h |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 30 min |
| 1 | Lab | [lab-01-sed-sustituir](2-practicas/lab-01-sed-sustituir/README.md) | 60 min |
| 2 | Lab | [lab-02-sed-rangos-e-in-place](2-practicas/lab-02-sed-rangos-e-in-place/README.md) | 60 min |
| 3 | Lab | [lab-03-awk-campos](2-practicas/lab-03-awk-campos/README.md) | 60 min |
| 4 | Lab | [lab-04-awk-begin-end-y-arrays](2-practicas/lab-04-awk-begin-end-y-arrays/README.md) | 60 min |
| 5 | Lab | [lab-05-awk-y-variables-de-bash](2-practicas/lab-05-awk-y-variables-de-bash/README.md) | 60 min |
| 6 | Lab | [lab-06-jq-leer-json](2-practicas/lab-06-jq-leer-json/README.md) | 60 min |
| 7 | Lab | [lab-07-json-roto](2-practicas/lab-07-json-roto/README.md) | 60 min |
| — | Proyecto | [bashkit logs: el access log en CSV y JSON](3-proyecto/README.md) | 3 h 30 min |

**Total: 12 horas**

## Distribución del tiempo

```text
[1 h]        Leer 1-teoria/ (sed, awk y jq)
[30 min]     Responder las 10 preguntas de Conocimiento
[60 min]     lab-01 — s///, grupos y -n con p
[60 min]     lab-02 — rangos, d y sed -i.bak
[60 min]     lab-03 — campos, -F y patrones
[60 min]     lab-04 — BEGIN, END y arrays de awk
[60 min]     lab-05 — -v, OFS y textos que parecen números
[60 min]     lab-06 — leer JSON con jq
[60 min]     lab-07 — depurar un script que escribe JSON a mano
[3 h 30 min] Proyecto: bin/bk-logs
```

## Verificación de completitud

Desde la raíz del repositorio (en tu equipo o dentro del laboratorio):

```bash
./scripts/verificar-semana.sh 10
```

Comprueba tu proyecto (`3-proyecto/starter/`) contra los 15 requisitos verificables de la semana, dentro del laboratorio Docker.

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [← Semana 09 — Arrays y printf](../week-09-arrays_y_printf/README.md) | **Semana 10 — sed, awk y jq** | — |

[← Volver al índice del bootcamp](../README.md)
