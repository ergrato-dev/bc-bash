# Labs — Semana 10: sed, awk y jq

| # | Lab | Objetivo | Tiempo |
|---|-----|----------|--------|
| 1 | [lab-01-sed-sustituir](lab-01-sed-sustituir/README.md) | Cambiar partes de cada línea con `s///`, grupos y regex extendidas | ~60 min |
| 2 | [lab-02-sed-rangos-e-in-place](lab-02-sed-rangos-e-in-place/README.md) | Elegir las líneas con direcciones y rangos, y cambiar un archivo con `sed -i.bak` | ~60 min |
| 3 | [lab-03-awk-campos](lab-03-awk-campos/README.md) | Leer por columnas con `awk`, filtrar con patrones y alinear con `printf` | ~60 min |
| 4 | [lab-04-awk-begin-end-y-arrays](lab-04-awk-begin-end-y-arrays/README.md) | Sumar y contar por clave con los arrays de awk y escribir el resultado en `END` | ~60 min |
| 5 | [lab-05-awk-y-variables-de-bash](lab-05-awk-y-variables-de-bash/README.md) | Pasar datos a awk con `-v`, comparar números pegados a un texto y salir con un código | ~60 min |
| 6 | [lab-06-jq-leer-json](lab-06-jq-leer-json/README.md) | Sacar valores de un JSON con `.campo`, `.[]` y `select`, y llevarlos a bash con `-r` | ~60 min |
| 7 | [lab-07-json-roto](lab-07-json-roto/README.md) | Arreglar un script que escribe JSON a mano, con `jq -n`, `--arg` y `--argjson` | ~60 min |

**Total labs: 7 horas**

## Antes de cada lab

- Todo se hace dentro del laboratorio Docker, como `alumno`. Desde la raíz del repositorio en tu equipo: `docker compose run --rm lab`.
- Cada lab empieza con un **paso 0**: el `cd` a su carpeta desde `/bc-bash`, la raíz del repositorio dentro del laboratorio.
- Los programas de `sed`, `awk` y `jq` van **entre comillas simples**: así bash no toca los `$` ni las comillas de dentro. Si copias un comando y falla con un error raro de bash, mira primero las comillas.
- `sed`, `awk` y `jq` escriben en stdout y no cambian el archivo que leen. La excepción es `sed -i` (lab 02), que se usa siempre sobre una copia en `mktemp -d`.
- El lab 07 trae un script **roto a propósito**: ejecútalo tal cual antes de arreglarlo, para ver cómo falla.

Completa los labs en orden. Después, el [Proyecto semanal](../3-proyecto/README.md).

<!-- nav -->
---

## 🔗 Navegación

| Anterior | Siguiente |
|---|---|
| ← [Teoría — jq: leer y escribir JSON](../1-teoria/03-jq.md) | [Lab 01 — sed: sustituir](lab-01-sed-sustituir/README.md) → |

[↑ Semana 10](../README.md)
